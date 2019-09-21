lurker = require("external.lurker")
Player = require("player")
Enemy = require("enemy")
HC = require("external.HC")
local HumpCamera = require("external/hump/camera")

local scale = 1




function love.load()
    GAME_STATE = {
        PYSICS_WORLD = HC.new(),
    }
    player = Player(0,0)
    enemy = Enemy(-200, 100, player)
    camera = HumpCamera(0,0, scale, 0)
end

function love.update(dt)
    
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
    camera:detach()
end