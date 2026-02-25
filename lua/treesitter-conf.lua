local configs = require("nvim-treesitter.configs")

configs.setup({
    auto_install = true,
    ignore_install = { "org" },
    highlight = { enable = true },
})
