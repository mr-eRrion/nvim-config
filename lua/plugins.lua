local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("colorscheme")
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns-conf")
        end
    },

    {
        "let-def/texpresso.vim",
        ft = { "tex" },
        config = function()
            require("texpresso-conf")
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
        keys = {
            { "<Leader>ls", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree Toggle" }
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree-conf")
        end
    },

    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline-conf")
        end
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine-conf")
        end
    },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = true
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp"
        },
        opts = {
            automatic_installation = true,
            ensure_installed = { "tinymist" },
            server_settings = {
                tinymist = {},
            },
        },
        config = function(_, opts)
            require("lsp-conf").setup(opts)
        end
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline"
        },
        config = function()
            require("cmp-conf")
        end
    },

	    {
	        "L3MON4D3/LuaSnip",
	        version = "v2.*",
	        event = "InsertEnter",
	        dependencies = {
	            { "iurimateus/luasnip-latex-snippets.nvim", ft = { "tex", "plaintex", "latex", "markdown" } }
	        },
	        config = function()
	            require("luasnip-conf")
	        end
	    },

    {
        "mhartington/formatter.nvim",
        cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
        keys = {
            { "<Leader>fm", "<cmd>Format<cr>", desc = "Format" },
            { "<Leader>fw", "<cmd>FormatWrite<cr>", desc = "Format Write" }
        },
        config = function()
            require("fmt-conf")
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-file-browser.nvim"
        },
        keys = {
            { "<Leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<Leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },
            { "<Leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
            { "<Leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
            { "<Leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
            { "<Leader>se", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Search" }
        },
        config = function()
            require("telescope-conf")
        end
    },

    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_enabled = false
        end
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        build = "make tiktoken",
        cmd = "CopilotChat",
        keys = {
            { "<Leader>co", "<cmd>CopilotChat<cr>", desc = "CopilotChat", mode = "n" },
            { "<Leader>co", "<cmd>CopilotChat<cr>", desc = "CopilotChat", mode = "v" }
        },
        dependencies = {
            "github/copilot.vim",
            "nvim-lua/plenary.nvim"
        },
        opts = require("copilotchat-conf")
    },

    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown", "text" }
    },

    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        keys = {
            { "<Leader>gi", "<cmd>Neogit<cr>", desc = "Neogit" }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            require("neogit-conf")
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("treesitter-conf")
        end
    },

    {
        "Vigemus/iron.nvim",
        cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
        keys = {
            { "<space>rs", "<cmd>IronRepl<cr>", desc = "Iron REPL" },
            { "<space>rr", "<cmd>IronRestart<cr>", desc = "Iron Restart" },
            { "<space>rf", "<cmd>IronFocus<cr>", desc = "Iron Focus" },
            { "<space>rh", "<cmd>IronHide<cr>", desc = "Iron Hide" }
        },
        config = function()
            require("iron-conf")
        end
    },

    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("comment-conf")
        end
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({global = false})
                end,
                desc = "Buffer Local Keymaps (which-key)"
            }
        }
    },

    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            }, {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)"
            }, {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)"
            }, {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)"
            }, {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)"
            }, {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)"
            }
        }
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
            { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
            { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
            { "<Leader>B", function() require("dap").set_breakpoint() end, desc = "DAP Set Breakpoint" },
            { "<Leader>lp", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end, desc = "DAP Log Point" },
            { "<Leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
            { "<Leader>dl", function() require("dap").run_last() end, desc = "DAP Run Last" },
            { "<Leader>da", function() require("dapui").toggle() end, desc = "DAP UI Toggle" }
        },
        config = function()
            require("dap-conf")
        end
    },

    {
        "keaising/im-select.nvim",
        event = "InsertEnter",
        config = function()
            require("im-select-conf")
        end
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        config = function()
            require("render-markdow-conf")
        end
    },

    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = require("img-clip-conf"),
        keys = {
            { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" }
        }
    },

    {
        "3rd/image.nvim",
        event = "VeryLazy",
        build = false,
        opts = require("image-conf")
    },

    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha-conf")
        end
    },

    {
        "lervag/vimtex",
        ft = { "tex", "plaintex", "latex", "bib" },
        init = function()
            require("vimtex")
        end
    },

    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = require("typst-preview-conf")
    }
})
