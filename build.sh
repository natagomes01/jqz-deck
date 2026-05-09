#!/usr/bin/env bash
# build.sh — assembles a deck variant from the modular sources.
#
# Reads src/variants/<name>.json, concatenates src/layouts/deck-shell.html
# with the partials listed there (in order), substitutes the
# <!-- BUILD:SLIDES --> marker, scans the result for referenced images and
# copies only those into public/images/, writes the final public/index.html.
#
# Usage:
#   bash build.sh                 # build default variant 'full'
#   bash build.sh full            # build variant defined in src/variants/full.json
#   bash build.sh client-mrs      # build a custom variant (when present)
#   bash build.sh --pdf           # build full + export public/index.pdf
#   bash build.sh full --pdf      # explicit variant + PDF
#
# Dependencies: bash, python3 (no extra modules), Chrome/Chromium for --pdf.

set -euo pipefail

cd "$(dirname "$0")"

# ── parse args ────────────────────────────────────────────────────────────
VARIANT="full"
PDF=0
for arg in "$@"; do
  case "$arg" in
    --pdf)        PDF=1 ;;
    -h|--help)
      sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    -*)
      echo "ERROR: unknown flag: $arg" >&2
      exit 2 ;;
    *)            VARIANT="$arg" ;;
  esac
done

VARIANT_FILE="src/variants/${VARIANT}.json"
SHELL_FILE="src/layouts/deck-shell.html"
SLIDES_DIR="src/slides"
SRC_IMAGES="images"
OUT_DIR="public"
OUT_HTML="${OUT_DIR}/index.html"
OUT_IMAGES="${OUT_DIR}/images"

# ── validate inputs ───────────────────────────────────────────────────────
if [[ ! -f "$VARIANT_FILE" ]]; then
  echo "ERROR: variant manifest not found: $VARIANT_FILE" >&2
  echo "       available: $(ls src/variants/*.json 2>/dev/null | xargs -n1 basename 2>/dev/null | tr '\n' ' ')" >&2
  exit 1
fi
if [[ ! -f "$SHELL_FILE" ]]; then
  echo "ERROR: shell not found: $SHELL_FILE" >&2
  exit 1
fi

# ── prepare output directory ──────────────────────────────────────────────
rm -rf "$OUT_DIR"
mkdir -p "$OUT_IMAGES"

echo "→ Building variant: ${VARIANT}"

# ── delegate to python (JSON parse, marker substitution, image scan) ──────
python3 - "$VARIANT_FILE" "$SHELL_FILE" "$SLIDES_DIR" "$OUT_HTML" "$SRC_IMAGES" "$OUT_IMAGES" <<'PY'
import json
import re
import shutil
import sys
from pathlib import Path

variant_file, shell_file, slides_dir, out_html, src_images, dst_images = (Path(p) for p in sys.argv[1:7])

variant = json.loads(variant_file.read_text(encoding='utf-8'))
slugs = variant.get('slides', [])
if not slugs:
    sys.exit("ERROR: variant has empty 'slides' array")

# concatenate partials in declared order
parts = []
for slug in slugs:
    p = slides_dir / f"{slug}.html"
    if not p.exists():
        sys.exit(f"ERROR: partial missing: {p}")
    parts.append(p.read_text(encoding='utf-8'))
slides_block = "\n".join(parts)

# substitute marker in shell
shell = shell_file.read_text(encoding='utf-8')
marker = '<!-- BUILD:SLIDES -->'
if marker not in shell:
    sys.exit(f"ERROR: marker {marker!r} not found in {shell_file}")
result = shell.replace(marker, slides_block)

# patch <title> if variant defines one
if 'title' in variant and variant['title']:
    result = re.sub(r'<title>[^<]*</title>', f"<title>{variant['title']}</title>", result, count=1)

# write final html
out_html.parent.mkdir(parents=True, exist_ok=True)
out_html.write_text(result, encoding='utf-8')

# scan for referenced images: <img src="images/...">, <link/script href="images/...">,
# url(images/...) inside style attributes or inline <style>.
referenced = set()
for m in re.finditer(r'(?:src|href)="images/([^"]+)"', result):
    referenced.add(m.group(1))
for m in re.finditer(r"""url\(\s*['"]?images/([^'")\s]+)['"]?\s*\)""", result):
    referenced.add(m.group(1))

# copy referenced images
dst_images.mkdir(parents=True, exist_ok=True)
copied = 0
missing = []
for name in sorted(referenced):
    src = src_images / name
    if not src.exists():
        missing.append(name)
        continue
    shutil.copy2(src, dst_images / name)
    copied += 1

# report
print(f"  partials:       {len(parts)} concatenated ({len(slides_block):,} bytes)")
print(f"  output html:    {out_html} ({len(result):,} bytes)")
print(f"  images copied:  {copied} of {len(referenced)} referenced")
if missing:
    print(f"  WARN: {len(missing)} referenced image(s) missing in {src_images}/:")
    for n in missing:
        print(f"    - {n}")
PY

# ── optional PDF export via Chrome headless ───────────────────────────────
if [[ "$PDF" == "1" ]]; then
  echo "→ Exporting PDF..."
  CHROME=""
  for candidate in \
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
      "/Applications/Chromium.app/Contents/MacOS/Chromium" \
      "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
    if [[ -x "$candidate" ]]; then CHROME="$candidate"; break; fi
  done
  if [[ -z "$CHROME" ]]; then
    for cmd in google-chrome chromium chromium-browser chrome; do
      if command -v "$cmd" >/dev/null 2>&1; then CHROME="$(command -v "$cmd")"; break; fi
    done
  fi
  if [[ -z "$CHROME" ]]; then
    echo "ERROR: Chrome/Chromium/Edge not found. Install Chrome or use a CI image with chromium." >&2
    exit 1
  fi

  ABS_HTML="$(cd "$OUT_DIR" && pwd)/index.html"
  PDF_OUT="${OUT_DIR}/index.pdf"
  "$CHROME" \
    --headless=new \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf-no-header \
    --print-to-pdf="$PDF_OUT" \
    "file://$ABS_HTML" 2>/dev/null || {
      # retry without --headless=new for older Chrome versions
      "$CHROME" \
        --headless \
        --disable-gpu \
        --no-pdf-header-footer \
        --print-to-pdf-no-header \
        --print-to-pdf="$PDF_OUT" \
        "file://$ABS_HTML"
    }
  echo "  $PDF_OUT ($(wc -c <"$PDF_OUT" | tr -d ' ') bytes)"
fi

echo "✓ Build complete."
