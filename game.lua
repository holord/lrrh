local gameState = {}

local font = require "font"
local story = require "story"

function gameState.load()
    story.current = story.menu
end

function gameState.update(dt) end

function gameState.draw()
    love.graphics.setFont(font)
    story.current.draw()
end

return gameState
