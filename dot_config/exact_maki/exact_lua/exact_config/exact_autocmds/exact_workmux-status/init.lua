-- workmux-status: report maki session activity to workmux.
--
-- Purpose: keeps the workmux window indicator (and tmux icon) in sync with
-- what the agent is doing by shelling out to the workmux CLI:
--   * `workmux register-agent` once at startup so workmux tracks this agent.
--   * `workmux set-window-status <working|waiting|done>` on every session /
--     subagent status change.
-- Outside a workmux-managed window these CLIs fail silently, so no
-- environment guards are needed. Unknown agents (like maki) fall back to
-- workmux's DefaultProfile instead of erroring.
--
-- NOTE: prompt capture is intentionally omitted. `maki.fn.jobstart` has no
-- stdin support (it only takes a command plus stdout/stderr routing
-- options), so there is no way to pipe the current prompt text to workmux.

-- Last status sent to workmux; used to dedup repeated statuses.
local last_status = nil

-- Main session status as reported by SessionStatusChanged:
-- "working" | "needs_input" | "idle". Starts as "idle" (nothing running yet).
local main_status = "idle"

-- Set of subagent task ids currently active (status == "working"),
-- tracked from TaskStatusChanged events.
local active_tasks = {}

local function count_active_tasks()
  local n = 0
  for _ in pairs(active_tasks) do
    n = n + 1
  end
  return n
end

-- Aggregate main + subagent state into a single workmux status:
-- waiting wins (user input needed), then working, otherwise done.
local function overall_status()
  if main_status == "needs_input" then
    return "waiting"
  end
  if main_status == "working" or count_active_tasks() > 0 then
    return "working"
  end
  return "done"
end

-- Run a workmux CLI command synchronously (jobstart + jobwait).
-- Must be called from a context that may park (autocmd callback or
-- async task): jobs started inside an autocmd dispatch die with it unless
-- awaited there via jobwait.
local function run_workmux(args)
  local ok, id, err = pcall(maki.fn.jobstart, args, { stdout = false, stderr = false })
  if not ok then
    maki.log.debug("workmux-status: jobstart raised: " .. tostring(id))
    return
  end
  if not id then
    maki.log.debug("workmux-status: jobstart failed: " .. tostring(err))
    return
  end
  local res_ok, res_or_err = pcall(maki.fn.jobwait, id, 3000)
  if not res_ok then
    maki.log.debug("workmux-status: jobwait failed: " .. tostring(res_or_err))
  end
end

local function push_status()
  local status = overall_status()
  if status == last_status then
    return
  end
  last_status = status
  run_workmux({ "workmux", "set-window-status", status })
end

-- Register once at load. Top-level plugin code may not park via jobwait,
-- so spawn a task that does jobstart + jobwait inside it.
maki.async.spawn(function()
  run_workmux({ "workmux", "register-agent" })
end)

maki.api.create_autocmd("SessionStatusChanged", {
  callback = function(ev)
    local s = ev.data and ev.data.status
    if s == "working" or s == "needs_input" or s == "idle" then
      main_status = s
      push_status()
    end
  end,
})

maki.api.create_autocmd("TaskStatusChanged", {
  callback = function(ev)
    local data = ev.data
    if not (data and data.id and data.status) then
      return
    end
    if data.status == "working" then
      active_tasks[data.id] = true
    elseif data.status == "done" or data.status == "error" then
      active_tasks[data.id] = nil
    else
      return
    end
    push_status()
  end,
})
