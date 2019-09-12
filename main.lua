lurker = require("external.lurker")
Player = require("player")
local HumpCamera = require("external/hump/camera")

local player = Player(0,0)
local scale = 1


function love.load()
    camera = HumpCamera(0,0, scale, 0)
end

function love.update(dt)
    lurker.update()
    player:update(dt)
end

-- Just test to print to the graphics window and the terminal
tmp = 1
function love.draw()
    camera:attach()
    love.graphics.print(camera.x,400,350)
    love.graphics.print("Testing install", 400, 300)
    if tmp == 1 then
        print("Testing debug console")
        tmp = tmp +  1
    end

    player:draw()
    camera:detach()
end