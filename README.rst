jqz-deck-2026
=============

Pitch deck institucional **J Queiroz · 2026**. HTML puro, exportável para PDF, deploy via GitHub Pages.

Produzido por **Albatroz Studio** para J Queiroz Comércio e Serviços Ltda.

Status
------

Estado atual: deck monolítico funcional (``jqz-deck-2026.html``).
Refatoração modular em planejamento: split em partials, dual-mode (apresentação 16:9 + site responsivo), variantes por cliente.

Estrutura
---------

================================  ============================================
Caminho                           O que é
================================  ============================================
``jqz-deck-2026.html``            Arquivo de trabalho atual (32 slides)
``images/``                       Imagens usadas pelo deck (31 arquivos curados)
``.github/workflows/pages.yml``   Pipeline de publicação no GitHub Pages
================================  ============================================

Documentos de trabalho (PRD, brand voice, design tokens, histórico) ficam locais no Drive — não versionados no GitHub.

Local
-----

::

   open jqz-deck-2026.html

Deploy
------

Push em ``main`` aciona a Action que publica em GitHub Pages.

URL pública: https://natagomes01.github.io/jqz-deck/
