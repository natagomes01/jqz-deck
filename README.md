# jqz-deck-2026

Pitch deck institucional J Queiroz · 2026. HTML puro, exportável para PDF, deploy via GitHub Pages.

Produzido por Albatroz Studio para J Queiroz Comércio e Serviços Ltda.

## Status

Estado atual: deck monolítico funcional (`jqz-deck-2026.html`). Refatoração modular em planejamento (Sessão 2): split em partials, dual-mode (apresentação 16:9 + site responsivo), variantes por cliente.

## Estrutura

| Caminho | O que é |
|---|---|
| `jqz-deck-2026.html` | Arquivo de trabalho atual (monolítico, 32 slides) |
| `images/` | Imagens usadas pelo deck (31 arquivos curados) |
| `CONTEXT.md` | PRD provisório do projeto |
| `_log/*.changes.md` | Histórico de mudanças por versão (`/stamp`) |
| `.github/workflows/` | Pipeline de publicação no GitHub Pages |
| `_source/` | PPT + PDF originais (gitignored) |
| `_extracao/` | Pool completo de imagens extraídas (gitignored) |

## Local

```bash
open jqz-deck-2026.html
```

## Deploy

Push em `main` aciona a Action que publica em GitHub Pages.
URL pública: https://natagomes01.github.io/jqz-deck/
