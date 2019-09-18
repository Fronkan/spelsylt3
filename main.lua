lurker = require("external.lurker")
Player = require("player")
Enemy = require("enemy")
HC = require("external.HC")
local HumpCamera = require("external/hump/camera")

local scale = 1


local player = Player(0,0)
local enemy = Enemy(-200, 100, player)

function love.load()
    GAME_STATE = {
        PYSICS_WORLD = HC
    }
    camera = HumpCamera(0,0, scale, 0)

    -- HC test½
    rect = HC.rectangle(0,0,400,20)
    -- END HC test
end

function love.update(dt)
    -- HC test
    rect:rotate(dt)
    -- END HC test
    lurker.update()
    player:update(dt)
    enemy:update(dt)
    local dx,dy = player.pos.x - camera.x, player.pos.y - camera.y
    camera:move(dx/2, dy/2)
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
    enemy:draw()
    -- HC test
    love.graphics.setColor(255,255,255)
    rect:draw('fill')
    -- END HC test
    camera:detach()
end