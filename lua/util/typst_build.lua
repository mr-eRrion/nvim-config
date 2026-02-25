local M = {}

-- Parse diagnostics from `typst compile` combined stdout/stderr lines.
-- Exposed for testing as M._parse_diagnostics.
-- Supported patterns (minimal):
--   severity line:  "error: ..." or "warning: ..."
--   location line:  "  --> path/to/file.typ:LINE:COL" (allow leading spaces)
-- Behavior:
--   - If a location line immediately follows a severity line, attach filename/line/col.
--   - Otherwise fall back to default_file with lnum=1,col=1 and keep the original severity text.
function M._parse_diagnostics(lines, default_file)
  local items = {}

  local function parse_location(line)
    -- Try to parse a Typst-style location line of the form:
    --   "  --> path/to/file.typ:LINE:COL"
    -- This implementation tolerates leading spaces and captures the last :LINE:COL.
    local rest = line:match("^%s*%-%-%>%s*(.+)")
    if not rest then return nil end
    -- Trim possible surrounding whitespace
    rest = rest:match("^%s*(.-)%s*$")
    local lnum, col = rest:match(":(%d+):(%d+)%s*$")
    local fname = rest:match("^(.*):%d+:%d+%s*$")
    if fname and lnum and col then
      return fname, tonumber(lnum) or 1, tonumber(col) or 1
    end
    return nil
  end

  local i = 1
  while i <= #lines do
    local line = lines[i]
    local sev_any, msg = line:match("^(%w+):%s*(.*)")
    local sev = (sev_any == "error" or sev_any == "warning") and sev_any or nil
    if sev then
      local filename, lnum, col = default_file, 1, 1
      -- Look ahead one line for a location
      if i + 1 <= #lines then
        local fname, l, c = parse_location(lines[i + 1])
        if fname then
          filename, lnum, col = fname, l, c
          i = i + 1 -- consume location line
        end
      end
      table.insert(items, {
        filename = filename,
        lnum = lnum,
        col = col,
        text = line, -- keep original severity line text
        type = (sev == "error") and "E" or "W",
      })
    end
    i = i + 1
  end

  -- If nothing matched, fall back to dumping lines as generic messages.
  if #items == 0 then
    for _, l in ipairs(lines) do
      table.insert(items, { filename = default_file, lnum = 1, col = 1, text = l })
    end
  end
  return items
end

-- Asynchronous "typst compile" with quickfix output.
function M.build_current(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then
    vim.notify("Save the file before building", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable("typst") ~= 1 then
    vim.notify("typst executable not found in PATH", vim.log.levels.ERROR)
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
        items = M._parse_diagnostics(lines, file)
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
