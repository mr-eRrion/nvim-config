local luasnip = require("luasnip")

luasnip.config.setup({ enable_autosnippets = true })

require("luasnip.loaders.from_lua").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/luasnip" },
})

-- Only load/setup LaTeX snippets for relevant filetypes to avoid impacting typst or others.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "plaintex", "latex", "markdown" },
    callback = function()
        local ok, latex_snips = pcall(require, "luasnip-latex-snippets")
        if not ok then
            return
        end
        latex_snips.setup({
            use_treesitter = true,
            allow_on_markdown = true,
        })
    end,
})
