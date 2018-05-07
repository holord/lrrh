local gameState = {}

--local font = require "font"
require "font"
local story = require "story"

function gameState.load()
    story.current = story.menu
end

function gameState.update(dt) end

function gameState.draw()
    love.graphics.setFont(font)
    story.current.draw()
end

function gameState.resize(x, y)
    local f = y * 1 / 600
    font = love.graphics.newFont("monogram.ttf", f * 38)
end

return gameState
