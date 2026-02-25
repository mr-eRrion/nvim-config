-- Minimal ftplugin for Typst buffers.
-- Provides :TypstBuild (uses util/typst_build.lua if present).

local ok, tb = pcall(require, "util.typst_build")
if not ok then
  -- No build helper found; you can still use typst-preview.nvim for live preview.
  -- Add lua/util/typst_build.lua (below) to enable :TypstBuild.
  return
end

vim.api.nvim_create_user_command("TypstBuild", function()
  tb.build_current({ out = vim.b.typst_output or "" })
end, {})

-- Buffer-local mapping to trigger a build
vim.keymap.set("n", "<leader>tb", "<cmd>TypstBuild<CR>", { buffer = true, silent = true, desc = "Typst Build" })
