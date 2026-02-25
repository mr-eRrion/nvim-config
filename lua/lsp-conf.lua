local M = {}

function M.setup(opts)
    local mason_lspconfig = require("mason-lspconfig")
    local lsp_config = vim.lsp.config
    -- Unified diagnostic policy
    vim.diagnostic.config({
        virtual_text = { source = "if_many" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "if_many"
        }
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local function on_attach(_, bufnr)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end
        -- LSP navigation
        map("n", "gd", vim.lsp.buf.definition, "LSP: Goto Definition")
        map("n", "gr", vim.lsp.buf.references, "LSP: References")
        map("n", "gI", vim.lsp.buf.implementation, "LSP: Goto Implementation")
        map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
        map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "LSP: Signature Help")
        -- Code actions / rename
        map("n", "<Leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
        map("n", "<Leader>rn", vim.lsp.buf.rename, "LSP: Rename")
        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Diagnostics: Prev")
        map("n", "]d", vim.diagnostic.goto_next, "Diagnostics: Next")
        -- Formatting (use async to avoid blocking)
        map({ "n", "v" }, "<Leader>cf", function() vim.lsp.buf.format({ async = true }) end, "LSP: Format")
    end

    mason_lspconfig.setup(opts)

    local function configure_and_enable(server_name)
        if not lsp_config[server_name] then
            lsp_config[server_name] = {}
        end
        -- Per-server customization hook
        local server_overrides = nil
        if type(opts) == "table" and type(opts.server_settings) == "table" then
            server_overrides = opts.server_settings[server_name]
        end

        local merged = vim.tbl_deep_extend("force", lsp_config[server_name], {
            capabilities = capabilities,
            on_attach = on_attach,
        })
        if type(server_overrides) == "table" then
            merged = vim.tbl_deep_extend("force", merged, server_overrides)
        end
        lsp_config[server_name] = merged
        if vim.lsp.enable then
            vim.lsp.enable(server_name)
        end
    end

    if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
            function(server_name)
                configure_and_enable(server_name)
            end
        })
        return
    end

    local servers = {}
    if type(opts) == "table" and type(opts.ensure_installed) == "table" then
        servers = opts.ensure_installed
    elseif mason_lspconfig.get_installed_servers then
        servers = mason_lspconfig.get_installed_servers()
    end

    for _, server_name in ipairs(servers) do
        configure_and_enable(server_name)
    end
end

return M
