-- Configure texpresso_path with the following priority:
-- 1) $TEXPRESSO_PATH if non-empty
-- 2) ~/texpresso/build/texpresso if it exists
-- 3) If 'texpresso' is in PATH, use its absolute path via exepath()
-- 4) Otherwise leave unset
local texpresso = require("texpresso")

local env_path = vim.env.TEXPRESSO_PATH
if env_path and env_path ~= "" then
    texpresso.texpresso_path = env_path
    return
end

local home_candidate = vim.fn.expand("~/texpresso/build/texpresso")
if vim.fn.filereadable(home_candidate) == 1 then
    texpresso.texpresso_path = home_candidate
    return
end

local exe = vim.fn.exepath("texpresso")
if exe and exe ~= "" then
    texpresso.texpresso_path = exe
    return
end
