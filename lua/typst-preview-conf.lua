return {
    debug = true,
    port = 56051,
    open_cmd = "open %s",
    extra_args = { "--input=preview=true" },
    get_root = function(_)
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
    end,
}
