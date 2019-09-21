Class = require("external.hump.class")
require("utils")

Explosion = Class {
    init = function(self, pos, mean_dmg)
        self.pos = pos
        self.timer = 10
        self.dmg = love.math.randomNormal(1, mean_dmg)
        if self.dmg < 0 then
            self.dmg = 0
        end
        self.has_done_dmg = false
        self.collider = create_circle_collider(
            self.pos,
            80,
            ENTITY_WEAPON
        )
        local img = love.graphics.newImage('assets/love_logo.png')
        self.psystem = love.graphics.newParticleSystem(img, 1000)
        love.audio.newSource("assets/explosion.wav", "static"):play()
        self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
        self.psystem:setSizes(0.05,0.06)
        self.psystem:setSizeVariation(1)
        self.psystem:setParticleLifetime(0.2,0.5)
        self.psystem:setSpeed(0, 200)
        self.psystem:setSpread(100)
        -- self.psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
        self.psystem:setRadialAcceleration(0.5,100)
        self.psystem:emit(1000)


        --self.psystem:setLinearDamping(0,0,10,10)
        self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to tran
        self.is_alive = true
    end;

    update = function(self, dt)
        if not self.has_done_dmg then
            self.has_done_dmg = true
            local collisions = game.PYSICS_WORLD:collisions(self.collider)
            for collider, delta in pairs(collisions) do
                collider.IS_HIT = true
                collider.RAW_DMG = collider.RAW_DMG + self.dmg/(Vector(delta.x,delta.y):len()/10)
            end
            game.PYSICS_WORLD:remove(self.collider)
            self.collider = nil
        end
        self.timer = self.timer - dt
        if self.timer < 0 then
            self:delete()
        end
        self.psystem:update(dt)
    end;

    draw = function(self)
        if self.is_alive then
            love.graphics.draw(self.psystem, self.pos.x, self.pos.y)

            -- if self.collider ~= nil then
            --     self.collider:draw()
            -- end
        end
    end;

    delete= function(self)
        self = nil
    end
}

return Explosion