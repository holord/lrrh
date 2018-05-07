lovecallbacks = {
    "load",
    "update",
    "draw",
    "mousepressed",
    "mousereleased",
    "mousemoved",
    "wheelmoved",
    "keypressed",
    "keyreleased",
    "textinput",
    "textedited",
    "touchmoved",
    "touchpressed",
    "touchreleased",
    "resize",
    "focus",
    "quit",
    "filedropped",
}

love.graphics.setDefaultFilter("nearest", "nearest")

local gameState = require "game"

function loadState(newState, arg)
    state = newState
    if(state.load) then state.load(arg) end
end

-- set up callbacks
for _, callback in pairs(lovecallbacks) do
    love[callback] = function(arg1, arg2, arg3, arg4, arg5, arg6)
        if(state[callback]) then state[callback](arg1, arg2, arg3, arg4, arg5, arg6) end
    end
end

function love.load()
    loadState(gameState)
end
