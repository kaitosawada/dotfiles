SESSION_FILE="/tmp/bw_session"

-- local function get_notes(session, items)
--   if not session or session == "" or session == vim.NIL then
--     vim.notify("Bitwarden session not found.")
--     return
--   else
--     for _, item_id in ipairs(items) do
--       vim.notify("Getting item: " .. item_id)
--       local get_cmd = string.format("BW_SESSION=%s bw get notes %s 2>/dev/null", session, item_id)
--       local note = io.popen(get_cmd):read("*a")
--       if note then
--         note = note:gsub("\n", "")
--         vim.fn.setenv("BW_NOTE_" .. item_id, note)
--       end
--     end
--   end
-- end

local function get_session_from_file()
  local file = io.open(SESSION_FILE, "r")
  if not file then
    vim.notify("Bitwarden session file not found.")
    return nil
  end
  bwsession = file:read("*a")
  if not bwsession or bwsession == "" or bwsession == vim.NIL then
    vim.notify("Bitwarden not unlocked.")
    return nil
  else
    return bwsession
  end
end

local function get_session_from_env()
  local bwsession = vim.fn.getenv("BW_SESSION")
  if bwsession then
    return bwsession
  end
end

local function get_session_from_cli()
  local input = vim.fn.inputsecret({ prompt = 'Bitwarden Master Password: ' })
  if input then
    vim.notify("Unlocking Bitwarden...")
    local unlock_cmd = string.format("echo '%s' | bw unlock --raw", input)
    local session = io.popen(unlock_cmd):read("*a")
    if session and session ~= "" then
      session = session:gsub("\n", "")
      local file = io.open(SESSION_FILE, "w")
      if not file then
        vim.notify("Failed to open session file.")
        return session
      end
      file:write(session)
      file:close()
      return session
    else
      vim.notify("Bitwarden unlock failed.")
      return nil
    end
  else
    vim.notify("Bitwarden password input canceled.")
    return nil
  end
end


local function get_session()
  local bwsession = get_session_from_env()
  if bwsession and bwsession ~= "" and bwsession ~= vim.NIL then
    return bwsession
  end
  bwsession = get_session_from_file()
  if bwsession and bwsession ~= "" and bwsession ~= vim.NIL then
    return bwsession
  end
  bwsession = get_session_from_cli()
  if bwsession and bwsession ~= "" and bwsession ~= vim.NIL then
    return bwsession
  end
end

BW_SESSION = get_session()
vim.fn.setenv("BW_SESSION", BW_SESSION)
