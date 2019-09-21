local lurker = require("external.lurker")
local Player = require("player")
local Enemy = require("enemy")
local HC = require("external.HC")
local Explosion = require("explosion")
local HumpCamera = require("external/hump/camera")
local Vector = require("external/hump/vector")
local suit = require("external/suit")
local EnemySystem = require("enemy_system")
local bitser = require("external/bitser/bitser")


local OPTIONS = "options"
local MENU = "menu"
local LEVEL = "level"
local scale = 0.55

ENTITY_SUBMARINE = "SUBMARINE"
ENTITY_WEAPON = "WEAPON"

menu = {}
menu.options = {}
game = {        
    PYSICS_WORLD = HC.new(),
    state = MENU,
    highscore = 0,
    score = 0
}

function game:saveScore()
    local data = {}
    data.highscore = self.highscore
    bitser.dumpLoveFile("highscore.dat", data)
end

function game:loadScore()
    if love.filesystem.getInfo('highscore.dat') then
        local data = bitser.loadLoveFile("highscore.dat")
        game.highscore = data.highscore
    else
        game.highscore = 0
    end
end

function game:removeScore()
    local wasRemoved = false
    if love.filesystem.getInfo('highscore.dat') then
        wasRemoved = love.filesystem.remove('highscore.dat')
        game.highscore = 0
    end
    return wasRemoved
end

function game:load_options()
    self.state = OPTIONS
end

function game:load_mainmenu()
    self.state = MENU
end

function game.load_level()
    game.state = LEVEL
    game.player = Player(Vector(0,0))
    game.enemy_system = EnemySystem()
    game.enemy_system:load()
    game.game_time = 0
    camera = HumpCamera(0,0, scale, 0)
end

function love.load()
    menu.button_w = 300
    menu.button_x = love.graphics.getWidth()/2 - menu.button_w/2
    menu.button_y = 50
    menu.button_h = 100
    
    menu.suit = suit.new()

    -- create options
    menu.options.suit = suit.new()
end

function love.update(dt)
    if game.state == MENU then
        menu.start_button = menu.suit:Button("start",
            menu.button_x,
            menu.button_y,
            menu.button_w,
            menu.button_h
        )
    
        menu.option_button = menu.suit:Button("options",
            menu.button_x,
            menu.button_y + menu.button_h*1 + 10,
            menu.button_w,
            menu.button_h
        )
    
        menu.quit_button = menu.suit:Button("quit",
            menu.button_x,
            menu.button_y + menu.button_h*2 + 20,
            menu.button_w,
            menu.button_h
        )
    

        if menu.start_button.hit then
            game.load_level()
        end

        if menu.option_button.hit then
            game:load_options()
        end

        if menu.quit_button.hit then
            love.event.quit()
        end

        menu.suit:Label("Highscore: "..game.highscore,
            menu.button_x ,
            menu.button_y + menu.button_h*3 + 20,
            menu.button_w,
            menu.button_h 
        )

    elseif game.state == OPTIONS then
        
        menu.options.remove_score = menu.options.suit:Button("remove score",
            menu.button_x,
            menu.button_y,
            menu.button_w,
            menu.button_h
        )

        menu.options.back = menu.options.suit:Button("back",
            menu.button_x,
            menu.button_y + menu.button_h*1 + 10,
            menu.button_w,
            menu.button_h
        )
        if menu.options.remove_score.hit then
            local wasRemoved = game:removeScore()
            menu.options.remove_text = "No Highscore exist yet"
            if wasRemoved then
                menu.options.remove_text = "Highscore was removed"
            end
        end


        if menu.options.remove_text then
            menu.options.suit:Label(menu.options.remove_text,
                menu.button_x ,
                menu.button_y + menu.button_h*3 + 20,
                menu.button_w,
                menu.button_h 
            )
        end

        if menu.options.back.hit then 
            game:load_mainmenu()
        end
    elseif game.state == LEVEL then
        game.game_time = game.game_time + dt
        lurker.update()
        game.player:update(dt)
        game.enemy_system:update(dt)
        if not game.player.is_alive then
            if game.score >= game.highscore then
                game.highscore = game.score
                game:saveScore()
            end
            game.state = MENU
        end

        local dx,dy = game.player.pos.x - camera.x, game.player.pos.y - camera.y
        camera:move(dx/2, dy/2)
    end
end


function love.draw()
    if game.state == LEVEL then   
        camera:attach()
        game.player:draw()
        game.enemy_system:draw()
        camera:detach()
        love.graphics.print("Score: "..game.score, 0,0)
        love.graphics.print("HP: ".. math.ceil(game.player.HP), 0, 15)
    elseif game.state == MENU then
        menu.suit:draw()
    elseif game.state == OPTIONS then
        menu.options.suit:draw()
    end


end