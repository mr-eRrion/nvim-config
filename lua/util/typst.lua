local M = {}

-- Detect whether the cursor is inside a Typst math node.
-- Be resilient when Tree-sitter is unavailable or buffer isn't Typst.
M.in_math = function()
  -- Only operate in Typst buffers; otherwise never trigger.
  if vim.bo.filetype ~= "typst" then
    return false
  end

  -- Lazily require ts_utils so requiring this module doesn't fail
  -- when Tree-sitter (or the Typst parser) isn't installed.
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if not ok or not ts_utils or type(ts_utils.get_node_at_cursor) ~= "function" then
    return false
  end

  local node = ts_utils.get_node_at_cursor()
  while node do
    local node_type = node:type()
    if node_type == "math" then
      return true
    end
    node = node:parent()
  end
  return false
end

return M
