> Last updated: 2026-05-09 · Version: v1.01

# CONTEXT.md — jqz-deck-2026

Deck institucional da J Queiroz Comércio e Serviços Ltda. para apresentações comerciais em 2026. Produzido por Albatroz Studio.

---

## O que é este projeto

Apresentação institucional em HTML puro (sem framework), exportável para PDF via Chrome headless. Substituiu o PowerPoint legado `241223-jqz-deck-ptbr.pptx` com identidade visual JQZ completa, copy estilo Eugene Schwartz e estrutura por frente de atuação (em vez de por cliente).

---

## Estrutura da pasta

```
deck/
├── jqz-deck-2026.html        ← arquivo de trabalho (sempre a versão atual)
├── jqz-deck-2026.pdf         ← última exportação em PDF
├── CONTEXT.md                ← este arquivo
├── build-dist.sh             ← script de build para deploy (Netlify / GitHub Pages)
├── dist/                     ← output do build-dist.sh (não versionar)
│   ├── index.html
│   └── assets/imagens/
├── _extracao/                ← não versionar — arquivos grandes
│   ├── imagens/              ← 76 imagens extraídas do PPT original + logos novos
│   └── (scripts python de extração)
├── _log/                     ← snapshots versionados (imutáveis)
│   ├── YYMMDD-vN.NN-jqz-deck-2026.html
│   └── YYMMDD-vN.NN-jqz-deck-2026.changes.md
└── _source/                  ← não versionar — arquivo PPT original (57MB)
    └── 241223-jqz-deck-ptbr.pptx
```

---

## Identidade visual

Brand completo em `../jqz-brand/jqz-brand.md`. Resumo aplicado neste deck:

| Token CSS | Hex | Uso |
|---|---|---|
| `--red-deep` | `#8B1A1A` | Headers, títulos principais, bordas de destaque |
| `--red-mid` | `#B22222` | CTAs, KPI numbers, bordas secundárias |
| `--green-dark` | `#2E3B26` | Slides de seção, subtítulos, footer |
| `--white` | `#F7F5F0` | Fundo padrão |
| `--cream` | `#F2EFE8` | Fundo alternado, cards de KPI |
| `--charcoal` | `#1C1C1C` | Texto principal |

Fontes: **Barlow Condensed** (títulos, KPIs, números grandes) + **Inter** (corpo, labels, legendas). Carregadas via Google Fonts CDN.

---

## Dimensionamento

- **Canvas fixo:** 1280 × 720 px (16:9, HD)
- **Responsive scaling:** CSS `transform: scale()` proporcional ao viewport (aplicado via JS no `.deck`). Os slides não reconstroem layout em telas menores — escalam inteiros.
- **PDF export:** `@media print` com `@page { size: 1280px 720px; margin: 0 }`. Gerar via Chrome: `--print-to-pdf --no-margins`.

---

## Estrutura de slides (32 slides)

### Introdução (01–06)
| # | Tipo | Título |
|---|---|---|
| 01 | Capa | J Queiroz · Engenharia Ferroviária · 2026 |
| 02 | Quem Somos | Frentes de Atuação + Diferenciais |
| 03 | Clientes | 12 cards com fade-in sequencial |
| 04 | Indicadores | 8 KPIs (87 PNs, segurança, anos de operação…) |
| 05 | Cinco Frentes | Pillars das frentes de atuação |
| 06 | Linha do Tempo | Timeline montanha 2009–2026 (8 marcos) |

### Frente 01 · Sinalização (07–14)
| # | Tipo | Contrato |
|---|---|---|
| 07 | Seção | Sinalização e Circuitos de Via |
| 08 | Projeto | Vale EFC · Sinalização (33km cabos, 200+ circuitos) |
| 09 | Projeto | Wabtec + Vale · 55 PNs EFC |
| 10 | Galeria | Wabtec + Vale · EFC + pandemia |
| 11 | Projeto | FIPS + Rumo · Outeirinhos (placeholder) |
| 12 | Projeto | Vale + Wabtec · Pátios EFVM (Itabira + Ipatinga) |
| 13 | Projeto | Vale + Wabtec · 32 PNs EFVM (placeholder) |
| 14 | Projeto | Vale · Saúde, Segurança e Conduta |

### Frente 02 · Energia e Rede Aérea (15–20)
| # | Tipo | Contrato |
|---|---|---|
| 15 | Seção | Energia e Rede Aérea |
| 16 | Seção (contextual) | — |
| 17 | Projeto | Vale · Rede Aérea 13kV Mãe Maria (190 postes, 10km+) |
| 18 | Projeto | MetrôRio · Subestações 145kV |
| 19 | Projeto | Siemens · L8 e L9 SP rede aérea (placeholder) |
| 20 | Projeto | VLT · Terminal Gentileza TIG (placeholder) |

### Frente 03 · Via Permanente (21–25)
| # | Tipo | Contrato |
|---|---|---|
| 21 | Seção | Via Permanente |
| 22 | Projeto | MetrôRio · Via Permanente |
| 23 | Projeto | MetrôRio · Solda e Lastro |
| 24 | Projeto | MetrôRio · Renovação 3× (placeholder) |
| 25 | Projeto | SuperVia · Via Permanente (placeholder) |

### Frentes 04 e 05 · Telecom, Pátios e Material Rodante (26–29)
| # | Tipo | Contrato |
|---|---|---|
| 26 | Seção combinada | Telecom, Pátios e Material Rodante |
| 27 | Projeto | L4 RJ Olímpica + Siemens SP Telecom + Alstom |
| 28 | Projeto | MRS + VLT + SuperVia + Nitriflex |
| 29 | Projeto | Frota Ferroviária |

### Encerramento (30–32)
| # | Tipo | Conteúdo |
|---|---|---|
| 30 | Fechamento | Por que J Queiroz |
| 31 | Fechamento | Contatos (Natã Gomes) |
| 32 | Capa final | — |

---

## Animações

Motor: **IntersectionObserver** nativo. Classe `.in-view` é adicionada ao `.slide` quando entra no viewport.

| Efeito | Aplicação |
|---|---|
| Fade-in + translateY | Todos os slides (entrada na tela) |
| Fade-in sequencial (delay 0.15s a 1.25s) | Cards de clientes (slide 03) |
| translateX sequencial | Client items na capa |
| `transform: scale(1.04)` | Imagens de projeto ao entrar em view |
| `scale(0) → scale(1)` | Dots da timeline (delay progressivo) |

Regra: zero bounces, zero spins, zero easing agressivo. Fades e slides suaves apenas.

---

## Copy

Estilo **Eugene Schwartz**: frases curtas e contundentes em PT-BR. Sem parágrafos descritivos.

**Regra rígida:** zero em-dashes (`—`) em todo o documento. Usar `·` (mid-dot U+00B7) como separador quando necessário.

---

## Imagens

Todas as imagens ficam em `_extracao/imagens/` (desenvolvimento) e são copiadas para `dist/assets/imagens/` no build.

| Convenção | Exemplo |
|---|---|
| Extraídas do PPT | `sNN-imgNNN.jpg` / `.png` |
| Logos externos | nome descritivo (`wise.png`, `Motiva.svg`) |

**Logos de clientes (slide 03):**
- MRS: `s04-img011.png`
- Vale: `s04-img014.png`
- Wabtec: `s04-img013.png`
- MetrôRio: `s04-img012.png`
- SuperVia: `s04-img010.png`
- VLT Carioca: `s04-img007.png`
- Alstom: `s04-img006.png`
- Siemens: `s04-img008.png`
- Rumo: `Rumo_Logística_logo.svg.png` → build: `Rumo_Logistica_logo.svg.png`
- Motiva (CCR): `Motiva.svg`
- Wise: `wise.png`
- Águas do Rio: `logo_aguas_rio.webp`

**Slides com placeholder (sem foto real ainda):**
- 11 · FIPS + Rumo · Outeirinhos
- 13 · Vale + Wabtec · 32 PNs EFVM
- 19 · Siemens L8 e L9 rede aérea
- 20 · VLT Terminal Gentileza TIG
- 24 · MetrôRio Renovação 3×
- 25 · SuperVia Via Permanente

---

## Build e deploy

```bash
# Gerar dist/ para deploy
bash build-dist.sh

# Exportar PDF (Chrome headless)
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --headless --print-to-pdf=jqz-deck-2026.pdf \
  --no-margins --print-to-pdf-no-header \
  "file://$(pwd)/dist/index.html"
```

O `build-dist.sh`:
1. Recria `dist/` do zero
2. Copia `_extracao/imagens/` → `dist/assets/imagens/`
3. Renomeia arquivo com acento (`Rumo_Logística` → `Rumo_Logistica`)
4. Reescreve o HTML com os novos paths

---

## GitHub — o que versionar

**Incluir:**
- `jqz-deck-2026.html`
- `CONTEXT.md`
- `build-dist.sh`
- `_log/` (snapshots e changes files)

**Excluir via `.gitignore`:**
- `_extracao/` (76 imagens + scripts de extração, 50MB+)
- `_source/` (PPT original, 57MB)
- `dist/` (gerado pelo build)
- `*.pdf`
- `"J Queiroz · Engenharia Ferroviária · 2026.pdf"`

As imagens de deploy ficam no repositório via pasta `assets/` se o projeto usar GitHub Pages, ou são servidas separadamente.

---

## Pendências

- [ ] Confirmar premiação 1º lugar em segurança Vale por 2 anos consecutivos (slide 14)
- [ ] Fotos reais para slides 11, 13, 19, 20, 24, 25
- [ ] Atualizar contagem de frota 2026 (slide 29)
- [ ] Detalhar os 15 estados de operação (citado na timeline, slide 06)
- [ ] Capa: confirmar se MRS permanece ou inclui mais clientes em destaque

---

## Contatos

| Canal | Dado |
|---|---|
| Responsável | Natã Gomes · Comercial |
| E-mail | nata@jqueiroz.net |
| WhatsApp | (11) 5199-9787 |
| Ligação | (21) 99725-3070 |
| Site | jqueiroz.net |

*Produzido por Albatroz Studio para J Queiroz · 2026*
