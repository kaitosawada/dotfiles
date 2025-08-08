SESSION_FILE="/tmp/bw_session"

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

function get_secret(item_id, var_name)
  vim.fn.jobstart("bw get notes " .. item_id .. " --nointeraction", {
    on_stdout = function(job_id, data, event)
      if data then
        local line = data[1]
        -- 空文字の場合は上書きしない
        if line and line ~= "" then
          _G[var_name] = line
        end
      end
    end,
    on_stderr = function(job_id, data, event)
      if data then
        for _, line in ipairs(data) do
          if line and line ~= "" then
            vim.notify("stderr:", line)
          end
        end
      end
    end,
    on_exit = function(job_id, exit_code, event)
      vim.notify(item_id .. "を取得しました:", exit_code)
    end,
  })
end

BW_SESSION = get_session()
vim.fn.setenv("BW_SESSION", BW_SESSION)
get_secret("openai-api-key", "openai_api_key")
get_secret("anthropic-api-key", "anthropic_api_key")
