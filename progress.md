# Implementation Progress

Rules:
- Check a box when done.
- After completing an item, add a brief note: what changed, where, and how it was verified.

## Milestones
- [x] M1 Maintainability & Portability
- [x] M2 LSP UX
- [x] M3 Completion & Snippet Conflict Control
- [x] M4 Typst Short-Trigger Snippets + Workflow
- [x] M5 Typst Build Diagnostics (Optional)
- [x] M6 Typst LSP (Optional)

## M1 Maintainability & Portability
- [x] Move inline configs out of `lua/plugins.lua` into `lua/*-conf.lua`
- [x] Replace hardcoded `texpresso_path` with env/exists-based logic
- [x] Set `<Leader>` explicitly and update `readme.md`

Notes:
- Done: leader and localleader are Space via `lua/preferences.lua`.
- Done: texpresso path is now derived from `TEXPRESSO_PATH`, `~/texpresso/build/texpresso`, or `exepath('texpresso')` via `lua/plugins.lua`.
- Done: moved inline plugin config blocks out of `lua/plugins.lua` into small `lua/*-conf.lua` modules. Remaining inline tables/keys are minimal (`keys`, `opts`, boolean `config=true`) and intentional.
- Verified: full config loads headless with no errors (see Test Execution Log for exact commands and env used to avoid ShaDa/state writes).

## M2 LSP UX
- [x] Expand `on_attach` mappings (buffer-local) in `lua/lsp-conf.lua`
- [x] Centralize diagnostic policy (virtual text/float/signs/update timing)
- [x] Add `server_settings[server]` merge hook

Notes:
- Done: added common LSP navigation/actions/format/diagnostic mappings in `lua/lsp-conf.lua`.
- Done: configured `vim.diagnostic.config` in `lua/lsp-conf.lua`.
- Done: supports `opts.server_settings[server_name]` deep-merge per server.
- Verified: module loads headless (`require('lsp-conf')`) and the Mason handler path is valid on this Neovim (uses `vim.lsp.config` + `vim.lsp.enable`).

## M3 Completion & Snippet Conflict Control
- [x] Improve Tab/S-Tab behavior in `lua/cmp-conf.lua`
- [x] Scope snippet loading so Typst and LaTeX snippets do not interfere

Notes:
- Done: added `<S-Tab>` mapping with cmp-visible/snippet-jump/fallback logic in `lua/cmp-conf.lua`.
- Done: made `iurimateus/luasnip-latex-snippets.nvim` filetype-scoped and guarded setup so Typst buffers won't load/initialize LaTeX snippets via `lua/plugins.lua`.
- Verified: `nvim --headless +qa` loads without errors.

## M4 Typst Short-Trigger Snippets + Workflow
- [x] Add `luasnip/typst/math_short.lua`
- [x] Add Greek full set triggers (lowercase + variants + uppercase autosnippet)
- [x] Add Typst buffer keymaps in `after/ftplugin/typst.lua` (e.g. build)
- [x] Improve robustness of `lua/util/typst.lua`

Notes:
- Done: added `luasnip/typst/math_short.lua` with full Greek set (lowercase + variants + uppercase), all autosnippet/wordTrig/in_math.
- Done: `lua/util/typst.lua` no longer crashes without Tree-sitter; returns false outside typst buffers.
- Done: `after/ftplugin/typst.lua` adds `<leader>tb` buffer-local mapping for `:TypstBuild`.
- Verified: `luac -p after/ftplugin/typst.lua lua/util/typst.lua luasnip/typst/math_short.lua`, `nvim -u NONE --headless ... require('util.typst')`.

## M5 Typst Build Diagnostics (Optional)
- [x] Parse `typst compile` output to populate quickfix with real line/col

Notes:
- Done: added `M._parse_diagnostics(lines, default_file)` and wired it into `lua/util/typst_build.lua` quickfix population.
- Verified: headless self-check produced 2 items with expected lnum/col.

## M6 Typst LSP (Optional)
- [x] Identify Typst LSP server name in Mason and enable it
- [x] Add minimal Typst server settings via the `server_settings` hook

Notes:
- Done: enabled Typst LSP via Mason by adding `tinymist` to `ensure_installed` in `lua/plugins.lua` and wiring through `server_settings.tinymist` handled by `lua/lsp-conf.lua`.
- Verified: Mason/LSP wiring loads without error in headless mode; server startup not exercised here (requires a Typst buffer).

## Test Execution Log
- [x] T0 Headless load sanity
- [x] T1 `util.typst` unit tests (lightweight)
- [x] T2 Snippet load/boundary tests (LuaSnip)
- [x] T3 Typst ftplugin command/keymap regression
- [x] T4 LSP config hook regression

Last run:
- Date: 2026-02-25
- Environment:
  - `XDG_CACHE_HOME=/tmp/nvim-cache`
  - `XDG_STATE_HOME=/tmp/nvim-state`
  - For tests not loading the full config, also `XDG_DATA_HOME=/tmp/nvim-data`
  - Always set `:set shadafile=NONE` to avoid ShaDa writes under sandbox.
- Command(s):
  - Syntax check (Lua): `for f in $(find . -type f -name \"*.lua\" -not -path \"./.git/*\"); do luac -p \"$f\"; done`
  - T0 (core modules only): `nvim --headless -u NONE +\"set shadafile=NONE\" +\"lua local mods={'preferences','lsp-conf','util.typst','util.typst_build'}; for _,m in ipairs(mods) do assert(pcall(require,m), 'require('..m..') failed') end; print('T0: core modules loaded')\" +qa`
  - Full config load (no UI): `XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u init.lua +\"set shadafile=NONE\" +qa`
  - T1 (util.typst baseline): `XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u NONE +\"set shadafile=NONE\" +\"lua local t=require('util.typst'); assert(t.in_math()==false); print('T1: util.typst.in_math() baseline ok')\" +qa`
  - T1 (typst_build parser): `XDG_DATA_HOME=/tmp/nvim-data XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u NONE +\"set shadafile=NONE\" +\"lua local tb=require('util.typst_build'); local lines={'error: Oops','  --> /path/file.typ:12:7'}; local items=tb._parse_diagnostics(lines,'/tmp/f.typ'); assert(#items==1 and items[1].lnum==12 and items[1].col==7); print('T1: typst_build parser ok')\" +qa`
  - T2 (LuaSnip math_short load + static guard): `XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u NONE +\"set shadafile=NONE\" +\"luafile /tmp/nvim_t2.lua\" +qa`
  - T3 (Typst ftplugin command/keymap): `XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u NONE +\"set shadafile=NONE\" +\"luafile /tmp/nvim_t3.lua\" +qa`
  - T4 (LSP config hook regression, stubbed mason-lspconfig): `XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u NONE +\"set shadafile=NONE\" +\"luafile /tmp/nvim_t4.lua\" +qa`
- Result:
  - All commands completed successfully. No config/runtime errors observed. Addressed earlier ShaDa/state write errors by routing Neovim state/cache to `/tmp` and disabling ShaDa writes for headless runs.
  - T2 note: LuaSnip loader did not populate snippets in `-u NONE` mode, so the test uses direct `dofile` of `luasnip/typst/math_short.lua` plus a static check for `condition = typst.in_math` and `snippetType = "autosnippet"`.
