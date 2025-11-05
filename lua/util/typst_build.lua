local M = {}

-- Asynchronous "typst compile" with quickfix output.
function M.build_current(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then
    vim.notify("Save the file before building", vim.log.levels.WARN)
    return
  end
  local out = opts.out or ""
  local cmd = { "typst", "compile", file }
  if out ~= "" then table.insert(cmd, out) end

  local stdout, stderr = {}, {}
  local function collect(tbl)
    return function(_, data)
      for _, l in ipairs(data) do
        if l and l ~= "" then table.insert(tbl, l) end
      end
    end
  end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = collect(stdout),
    on_stderr = collect(stderr),
    on_exit = function(_, code)
      local lines = vim.list_extend(stdout, stderr)
      local items = {}
      if #lines == 0 and code ~= 0 then
        table.insert(items, { filename = file, lnum = 1, col = 1, text = "typst failed (no output)", type = "E" })
      else
        for _, line in ipairs(lines) do
          table.insert(items, { filename = file, lnum = 1, col = 1, text = line })
        end
      end
      vim.schedule(function()
        vim.fn.setqflist({}, "r", { title = "Typst Build", items = items })
        if code ~= 0 or #items > 0 then vim.cmd("copen") end
        if code == 0 then vim.notify("Typst build succeeded", vim.log.levels.INFO) end
      end)
    end,
  })
  vim.notify("Running: " .. table.concat(cmd, " "))
end

return M
