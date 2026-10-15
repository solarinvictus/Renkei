-- Presentation-only transition; combat timers remain unchanged.
local M={duration=0.28}
function M.new() return {value=0,last=nil} end
function M.update(state,visible,now)
    local dt=state.last and math.max(0,now-state.last) or 0
    state.last=now
    if M.duration<=0 then state.value=visible and 1 or 0
    else
        local step=dt/M.duration
        state.value=math.max(0,math.min(1,state.value+(visible and step or -step)))
    end
    local t=state.value
    return t*t*(3-2*t)
end
return M
