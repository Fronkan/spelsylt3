local Class = require("external.hump.class")
local Enemy = require("enemy")
local WeaponSystem = require("weaponsystem")
local Vector = require("external/hump/vector")

EnemySystem = Class {
    init = function(self)
        self.spawn_prob = 0.20
        self.mean_distance_to_player = 900
        self.stddev_distance_to_player = 1
        self.timer = 0
        self.enemies = {}
    end;

    load = function(self)
        local pos  = Vector.fromPolar( -- HERE IS THE ERROR: cos number expected got table
        math.random(0,math.pi*2),
        love.math.randomNormal(
            self.stddev_distance_to_player,
            self.mean_distance_to_player
        )
        )
        local ws = WeaponSystem(
            math.random(2,10),
            math.random(10,30)
        )
        local enemy = Enemy(pos, ws, game.player)
        enemy.collider.ENTITY_TYPE = "TEMPORARY"
        if next(game.PYSICS_WORLD:collisions(enemy.collider)) == nil then
            enemy.collider.ENTITY_TYPE = ENTITY_SUBMARINE
            ws:set_collider_to_ignore(enemy.collider)
            table.insert(
                self.enemies,
                enemy
            )
        end
    end;

    update = function(self, dt)
        if game.player == nil then
            return
        end

        self.timer = self.timer + dt
        if self.timer > 5 then
            print("timer_end")
            self.timer = 0
            if math.random() <= self.spawn_prob then
                local pos  = Vector.fromPolar( -- HERE IS THE ERROR: cos number expected got table
                    math.random(0,math.pi*2),
                    love.math.randomNormal(
                        self.stddev_distance_to_player,
                        self.mean_distance_to_player
                    )
                )
                local ws = WeaponSystem(
                    math.random(2,10),
                    math.random(10,30)
                )
                local enemy = Enemy(pos, ws, game.player)
                enemy.collider.ENTITY_TYPE = "TEMPORARY"
                if next(game.PYSICS_WORLD:collisions(enemy.collider)) == nil then
                    enemy.collider.ENTITY_TYPE = ENTITY_SUBMARINE
                    ws:set_collider_to_ignore(enemy.collider)
                    table.insert(
                        self.enemies,
                        enemy
                    )
                end
            end
        end

        local to_be_removed = {}
        for idx, enemy in ipairs(self.enemies) do
            if enemy.is_alive == false then
                table.insert(to_be_removed, idx)
                game.score = game.score + 20
                enemy:delete()
            else
                enemy:update(dt)
            end
        end
        for _, enemy_idx in ipairs(to_be_removed) do
            table.remove(self.enemies, enemy_idx)
        end
    end;

    draw = function(self)
        for _, enemy in ipairs(self.enemies) do
            enemy:draw()
        end
    end;
}

return EnemySystem