jqz-deck-2026
=============

Pitch deck institucional **J Queiroz · 2026**. HTML puro, exportável para PDF, deploy via GitHub Pages.

Produzido por **Albatroz Studio** para J Queiroz Comércio e Serviços Ltda.

Modos de exibição
-----------------

* **≥1024px**: apresentação 16:9 (canvas 1280×720, scaling proporcional via JS).
* **<1024px**: site fluido (slides como seções verticais, scroll contínuo).
* **Print**: força 1280×720 sempre (export para PDF independente do viewport).

Mesmo URL serve os três modos, alternando via ``@media``.

Estrutura modular
-----------------

================================  ============================================
Caminho                           O que é
================================  ============================================
``src/layouts/deck-shell.html``   Shell único (head + CSS dual-mode + JS)
``src/slides/NN-<slug>.html``     32 partials de slide
``src/variants/full.json``        Manifest com a ordem dos slides
``src/components/``               Snippets compartilhados (reservado)
``build.sh``                      Assembler bash + python3
``images/``                       Pool curado de imagens (31 arquivos)
``.github/workflows/pages.yml``   Pipeline de publicação no GitHub Pages
================================  ============================================

Documentos de trabalho (CLAUDE.md, PRD, design tokens, brand voice, snapshots de versão) ficam locais no Drive, gitignored.

Build local
-----------

::

   bash build.sh full
   open public/index.html

Para gerar PDF (precisa Chrome ou Chromium instalado)::

   bash build.sh full --pdf
   open public/index.pdf

Variantes por cliente
---------------------

Para criar uma variante com subset dos slides, adicionar ``src/variants/<nome>.json`` no formato de ``full.json`` (com array ``slides`` na ordem desejada), depois::

   bash build.sh <nome>

Deploy
------

Push em ``main`` aciona a Action que roda ``bash build.sh full`` e publica ``public/`` em GitHub Pages.

URL pública: https://natagomes01.github.io/jqz-deck/
