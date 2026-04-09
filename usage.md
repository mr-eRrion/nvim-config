# usage.md

This document is the practical "how to use" guide for this Neovim config.

Assumptions:
- `<Leader>` = Space (set in `lua/preferences.lua`)
- Snippets are powered by `LuaSnip` and completion by `nvim-cmp`

## Quick Start

1) First launch: open `nvim`, wait for `lazy.nvim` to install plugins.
2) Common entry points:
   - `:Lazy` plugin manager UI
   - `:Mason` LSP/DAP installer UI

## Keymaps (General)

From `lua/preferences.lua`:
- Window navigation: `<C-Left>` / `<C-Down>` / `<C-Up>` / `<C-Right>`
- Terminal:
  - `<Leader>tv` open terminal in vertical split (`term://zsh`)
  - `<Leader>ts` open terminal in horizontal split (`term://zsh`)
- Diagnostics:
  - `<Leader>sd` open diagnostic float under cursor
- Terminal-mode:
  - `<Esc>` back to Normal mode

From plugins (`lua/plugins.lua`):
- NvimTree: `<Leader>ls` toggle file tree
- Telescope:
  - `<Leader>ff` find files
  - `<Leader>fp` project picker
  - `<Leader>fg` live grep
  - `<Leader>fs` document symbols
  - `<Leader>fb` file browser
  - `<Leader>se` current buffer search
- Which-key: `<Leader>?` show buffer-local keymaps
- Trouble:
  - `<Leader>xx` diagnostics (workspace)
  - `<Leader>xX` diagnostics (current buffer)
  - `<Leader>cs` symbols
  - `<Leader>cl` LSP list (definitions/references/...)
  - `<Leader>xL` location list
  - `<Leader>xQ` quickfix list
- Neogit: `<Leader>gi`
- CopilotChat:
  - Normal: `<Leader>co`
  - Visual: select text then `<Leader>co`
- Formatter:
  - `<Leader>fm` `:Format`
  - `<Leader>fw` `:FormatWrite`
- DAP:
  - `<F5>` continue
  - `<F10>` step over
  - `<F11>` step into
  - `<F12>` step out
  - `<Leader>b` toggle breakpoint
  - `<Leader>B` set breakpoint
  - `<Leader>lp` log point breakpoint
  - `<Leader>dr` open REPL
  - `<Leader>dl` run last
  - `<Leader>da` toggle DAP UI
- iron.nvim (REPL):
  - `<space>rs` open REPL
  - `<space>rr` restart
  - `<space>rf` focus
  - `<space>rh` hide
- Clipboard image:
  - `<Leader>pi` `:PasteImage` (img-clip.nvim)

## LSP Usage

LSP is configured in `lua/lsp-conf.lua` and installed via Mason.

Install / manage servers:
- `:Mason` (UI)

Common LSP keymaps (buffer-local, only after server attaches):
- `gd` go to definition
- `gr` references
- `gI` implementation
- `K` hover
- `<C-k>` signature help (Normal/Insert)
- `<Leader>ca` code action
- `<Leader>rn` rename
- `[d` / `]d` prev/next diagnostic
- `<Leader>cf` format (async)

Typst LSP:
- Mason server is configured as `tinymist` via `lua/plugins.lua` (`mason-lspconfig` ensure_installed)

## Completion + Snippet Usage

Completion engine: `nvim-cmp` (`lua/cmp-conf.lua`).

Insert mode keys:
- `<C-Space>` open completion
- `<CR>` confirm selection
- `<Tab>`
  - if completion menu is visible: select next item
  - else if a snippet can expand/jump: expand or jump forward
  - else if there are words before cursor: trigger completion
  - else: insert a literal tab/fallback
- `<S-Tab>`
  - if completion menu is visible: select previous item
  - else if inside a snippet: jump backward
  - else: fallback

Notes about snippets in this config:
- Many Typst snippets are `autosnippet`: they expand automatically when you finish typing the trigger.
- Most math-only snippets are guarded by Tree-sitter based math detection (`util.typst.in_math()`).

## Typst Workflow

### Build

Provided by `after/ftplugin/typst.lua` and `lua/util/typst_build.lua`:
- `:TypstBuild` compile current buffer with `typst compile`
- `<Leader>tb` run `:TypstBuild` (buffer-local in Typst files)

Build output:
- On failure, diagnostics go to quickfix.
- Open quickfix:
  - `:copen` (built-in)
  - or `<Leader>xQ` (Trouble quickfix view)

### Preview

Plugin: `chomosuke/typst-preview.nvim` (configured in `lua/plugins.lua` with `lua/typst-preview-conf.lua`).
- Uses port `56051` and `open %s` (macOS).
- For actual preview commands, use `:h typst-preview` (this config only sets opts).

## Typst Snippets (LuaSnip)

All Typst snippet files live under `luasnip/typst/`.

Legend:
- `math-only` means it expands only when cursor is inside Typst math (Tree-sitter node type `math`).
- `typst-only` means it expands only in Typst buffers.

### Math Short Greek (math-only, autosnippet)

Defined in `luasnip/typst/math_short.lua`.

Lowercase:
- `al` -> `α`
- `be` -> `β`
- `ga` -> `γ`
- `de` -> `δ`
- `ep` -> `ε`
- `ze` -> `ζ`
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

Lowercase variants:
- `vbe` -> `beta.alt`
- `vep` -> `epsilon.alt`
- `vth` -> `theta.alt`
- `vka` -> `kappa.alt`
- `vph` -> `phi.alt`
- `vpi` -> `pi.alt`
- `vrh` -> `rho.alt`
- `vsi` -> `sigma.alt`

Uppercase (also autosnippet):
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

### Basic Math Structure (mostly math-only)

Defined in `luasnip/typst/basic.lua`.

Typst-only inline math (autosnippet):
- `km` -> `$ ... $`
- `mk` -> `$ ... $`

Line-begin display math (autosnippet):
- `eqs` -> multiline display math block
- `eqt` -> inline display math with `<<label(...)>>`

Math-only scripts:
- `td` -> `_ ( ... )` (subscript)
- `tp` -> `^( ... )` (superscript)
- Regex: `x2` -> `x_2`
- Regex: `x_12` -> `x_(12)`

Math-only fractions:
- `//` -> `frac(a, b)`
- Regex: `3/` -> `frac(3, ...)`
- Regex: `a/` -> `frac(a, ...)`
- Regex: `(expr)/` -> `frac(expr, ...)`

Math-only operators:
- `sum` -> choice of `sum_(...)^(...)`, `sum_(...)`, or `sum ...`
- `prod` -> choice of `product_(...)^(...)`, `product_(...)`, or `product ...`
- `lim` -> `lim ...` or `lim_(x -> infinity) ...`
- `int` -> `integral_(a)^(b) ... dif x` or `integral ... dif x`

Math-only nth root:
- Regex: `2sq`..`9sq` -> `root(n, ...)`

### Symbols + Decorations (math-only)

Defined in `luasnip/typst/symbols.lua`.

Constants / misc:
- `ee` -> `e^(...)`
- `ii` -> `i`
- `dd` -> `dif`

Grouping shortcuts:
- `@(` -> `( ... )`
- `@[ ` -> `[ ... ]`
- `@{` -> `{ ... }`
- `@|` -> `| ... |`

Accents / vectors:
- `hat` -> `hat(...)`
- `bar` -> `overline(...)`
- `tilde` -> `tilde(...)`
- `vec` -> `arrow(...)`
- `hbar` -> `planck.reduce`
- Regex: `xdot` -> `dot(x)`
- Regex: `xddot` -> `dot.double(x)`

Products:
- `xx` -> `times`
- `oxx` -> `times.circle`

Set operators (note: current mapping):
- `cup` -> `inter`
- `cap` -> `union`

### Braces / Dirac Notation (math-only)

Defined in `luasnip/typst/braces.lua`.

- `@|` -> `| ... |` (this overlaps with symbols.lua)
- `@>` -> `angle.l ... angle.r`
- `set` -> `\{ ... \}`
- `bra` -> `bra(...)`
- `ket` -> `ket(...)`

### Fonts + Text Styling

Defined in `luasnip/typst/fonts.lua`.

Typst-only (outside math) text styling:
- `tbf` -> `*...*` (bold)
- `tit` -> `_..._` (italic)
- `ttt` -> `` `...` `` (code)

Math-only font wrappers:
- `mbf` -> `bold(...)`
- `mit` -> `italic(...)`
- `mrm` -> `upright(...)`
- `mtt` -> `mono(...)`

Math-only regex fonts:
- `Acal` / `abc...cal` -> `cal(...)` (uppercased)
- `ascr` / `abc...scr` -> `scripts(...)`
- `Abb` / `abc...bb` -> `bb(...)` (uppercased)
- `afrk` / `abc...frk` -> `frak(...)`
- `abc...rm` -> `upright(...)`
- `asf` / `abc...sf` -> `sans(...)`

Math-only text-in-math:
- `txt` -> `upright("...")`

Math-only sizing:
- `big` -> `lr(..., size: #150%)`
- `Big` -> `lr(..., size: #200%)`

Typst-only (outside math) colors:
- `red` / `blue` / `green` -> `text(color, ...)`

Math-only colors:
- `mred` / `mblue` / `mgreen` -> `text(color, $...$)`

## Formatting

Plugin: `mhartington/formatter.nvim`.

Commands:
- `:Format`
- `:FormatWrite`
- `:FormatLock`
- `:FormatWriteLock`

Keymaps:
- `<Leader>fm` -> `:Format`
- `<Leader>fw` -> `:FormatWrite`

## Git

Neogit:
- `<Leader>gi` or `:Neogit`

Gitsigns:
- Enabled on file open; see `:h gitsigns` for default actions.

## Debugging (nvim-dap)

Configured in `lua/dap-conf.lua`.
- Use the DAP keymaps listed in the Keymaps section.
- For Python, ensure `debugpy` is installed.

## Troubleshooting

Headless load check (useful after edits):

```sh
XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state nvim --headless -u init.lua +"set shadafile=NONE" +qa
```

If Typst math-only snippets never trigger:
- Ensure Tree-sitter parser for Typst is installed and highlighting is enabled.
- `util.typst.in_math()` returns false outside Typst buffers by design.
