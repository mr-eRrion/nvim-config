# nvim Configuration Optimization Plan

This plan targets this repository (Neovim config under `~/.config/nvim`).
Goals:
- Improve maintainability and portability (less hardcoding, clearer modules)
- Fill LSP/diagnostics/completion gaps without changing the overall stack
- Expand Typst workflow and add short-trigger Typst math snippets
- Include a runnable unit/regression test plan (headless + optional plugin-backed)

## Current State (What Exists Today)
- Entry: `init.lua` loads `preferences` and `plugins`
- Plugin manager: `lazy.nvim` (`lua/plugins.lua`)
- LSP: `lua/lsp-conf.lua` enables servers via `mason-lspconfig`; `on_attach` currently only maps rename
- Typst:
  - Preview: `typst-preview.nvim` configured in `lua/plugins.lua`
  - Build: `:TypstBuild` via `after/ftplugin/typst.lua` and `lua/util/typst_build.lua` (writes output to quickfix)
  - Math detection: `lua/util/typst.lua` uses Tree-sitter node type `math`
  - Snippets: `luasnip/typst/*.lua` (basic/symbols/fonts/braces, etc.)

## Scope / Non-Goals
- Scope: incremental improvements inside this repo; keep the same plugin stack unless a change is clearly beneficial
- Non-goals: redesign UI/theme; replace the whole configuration framework; introduce external services

## Milestones (Ordered by ROI)

### M1 - Maintainability & Portability (Low Risk)
1. Reduce inline configs in `lua/plugins.lua`
   - Move inline plugin `config` blocks into `lua/*-conf.lua` modules (consistent with existing style)
2. Remove hardcoded paths
   - Replace `texpresso_path = "/Users/..."` with:
     - environment variable override (e.g. `TEXPRESSO_PATH`)
     - or only set if the path exists
     - otherwise do nothing
3. Define a stable `<Leader>`
   - Set leader explicitly (likely space) and update `readme.md`

### M2 - LSP UX (Medium Risk, High Value)
1. Expand `on_attach` in `lua/lsp-conf.lua`
   - Add common buffer-local mappings: hover, definition, references, code action, diagnostics, formatting, etc.
2. Unify diagnostic policy
   - Configure virtual text, floating windows, update timing, signs
3. Add per-server customization hook
   - Merge `server_settings[server_name]` into the default capabilities/on_attach per server

### M3 - Completion & Snippet Conflict Control (Medium Risk)
1. Improve `lua/cmp-conf.lua`
   - Make Tab / S-Tab behavior consistent (cmp visible vs snippet jump vs fallback)
2. Filetype-scoped snippet loading
   - Ensure Typst snippets do not get polluted by LaTeX snippet collections

### M4 - Typst Short-Trigger Math Snippets + Workflow (Medium Risk, Very High Value)
1. Add short-trigger math snippets
   - New file: `luasnip/typst/math_short.lua`
   - Rule: every autosnippet must be guarded by `typst.in_math()` to avoid firing in normal text
2. Add full Greek letter set (lowercase + variant forms + uppercase)
   - User requirement: uppercase MUST be autosnippet as well
3. Improve Typst ftplugin
   - Add buffer-local keymaps for `:TypstBuild` (and preview toggle if desired)
4. Make `lua/util/typst.lua` more robust
   - Handle missing Tree-sitter parser gracefully
   - Tolerate possible grammar changes (node type names)

### M5 - Better Typst Build Diagnostics (Optional)
- Parse `typst compile` output to extract line/column and populate quickfix items accurately

### M6 - Typst LSP (Optional but Recommended)
- Enable Typst LSP through Mason (exact server name depends on Mason registry)
- Add minimal per-server settings via the `server_settings` hook

## Typst Greek Letter Short-Trigger List (Full Set)

All triggers below are intended to be used only in Typst math context.
Implementation requirements:
- `snippetType = "autosnippet"`
- `wordTrig = true`
- `condition = typst.in_math()`
- Uppercase list is ALSO autosnippet (explicit requirement)

### Lowercase (24)
- `al` -> `alpha`
- `be` -> `beta`
- `ga` -> `gamma`
- `de` -> `delta`
- `ep` -> `epsilon`
- `ze` -> `zeta`
- `et` -> `eta`
- `th` -> `theta`
- `io` -> `iota`
- `ka` -> `kappa`
- `la` -> `lambda`
- `mu` -> `mu`
- `nu` -> `nu`
- `xi` -> `xi`
- `oc` -> `omicron`
- `pi` -> `pi`
- `rh` -> `rho`
- `si` -> `sigma`
- `ta` -> `tau`
- `up` -> `upsilon`
- `ph` -> `phi`
- `ch` -> `chi`
- `ps` -> `psi`
- `om` -> `omega`

### Lowercase Variants (Common Typst symbol names)
- `vbe` -> `beta.alt`
- `vep` -> `epsilon.alt`
- `vth` -> `theta.alt`
- `vka` -> `kappa.alt`
- `vph` -> `phi.alt`
- `vpi` -> `pi.alt`
- `vrh` -> `rho.alt`
- `vsi` -> `sigma.alt`

### Uppercase (24, autosnippet)
- `Al` -> `Alpha`
- `Be` -> `Beta`
- `Ga` -> `Gamma`
- `De` -> `Delta`
- `Ep` -> `Epsilon`
- `Ze` -> `Zeta`
- `Et` -> `Eta`
- `Th` -> `Theta`
- `Io` -> `Iota`
- `Ka` -> `Kappa`
- `La` -> `Lambda`
- `Mu` -> `Mu`
- `Nu` -> `Nu`
- `Xi` -> `Xi`
- `Oc` -> `Omicron`
- `Pi` -> `Pi`
- `Rh` -> `Rho`
- `Si` -> `Sigma`
- `Ta` -> `Tau`
- `Up` -> `Upsilon`
- `Ph` -> `Phi`
- `Ch` -> `Chi`
- `Ps` -> `Psi`
- `Om` -> `Omega`

Notes:
- These symbol names come from Typst's built-in symbols list (usable directly inside formulas).
- If some short codes conflict with your real math variables, we can tighten matching (regex boundaries) or require a prefix.

## Unit / Regression Test Plan

### T0 - Headless Load Sanity (Minimum)
Goal: detect syntax errors and missing-module crashes early.
- Run Neovim headless and require core modules:
  - `lua/preferences.lua`
  - `lua/lsp-conf.lua`
  - `lua/util/typst.lua`
  - `lua/util/typst_build.lua`
- Expected: no errors, no stacktraces.

### T1 - `util.typst` Unit Tests (Recommended)
Goal: ensure `typst.in_math()` behavior is stable.
Precondition: `lua/util/typst.lua` should not crash when Tree-sitter is missing.
Test cases:
1. No Tree-sitter / no parser: `in_math()` returns false.
2. Node at cursor has an ancestor math node: returns true.
3. Node at cursor has no math ancestor: returns false.

Implementation options:
- Option A (recommended): add a small `tests/` harness using `plenary.nvim` (busted runner).
- Option B: add a pure Lua self-test script executed by `nvim --headless` with lightweight mocks.

### T2 - Snippet Loading & Boundary Tests (Requires LuaSnip)
Goal: validate new snippet file is loadable and conditions work.
Test cases:
1. Load `luasnip/typst/math_short.lua` without error.
2. In non-Typst buffer or non-math context: Greek triggers do NOT expand.
3. In Typst math context: Greek triggers expand to correct Typst symbol names.

### T3 - Typst ftplugin Command/Keymap Regression
Goal: ensure Typst tooling remains stable.
Test cases:
1. In a typst buffer, `:TypstBuild` exists.
2. `<leader>tb` (or chosen mapping) exists and calls `:TypstBuild`.
3. `:TypstBuild` handles missing `typst` binary or unsaved buffer gracefully (notify, no crash).

### T4 - LSP Config Hook Regression (Lightweight)
Goal: ensure per-server merge does not break defaults.
Test cases:
1. `require("lsp-conf").setup(...)` executes.
2. `server_settings` merges without losing `capabilities` and `on_attach`.

## Risks & Rollback Strategy
- Short triggers might conflict with variable names.
  - Mitigation: strict `typst.in_math()` gating + `wordTrig = true` + (if needed) regex boundaries and/or prefix.
- Tree-sitter grammar changes could break math detection.
  - Mitigation: add compatibility checks and safe fallbacks in `lua/util/typst.lua`.
- Existing snippets may have semantic mismatches (e.g. `cup/cap` mapping).
  - Mitigation: fix in separate, isolated change so rollback is easy.

## Definition of Done
- `plan.md` and `progress.md` exist at repo root and match this plan.
- Greek short triggers (lowercase + variants + uppercase) are implemented for Typst math context.
- At least T0 and T1 can be executed successfully; T2/T3 when plugins are installed.
