Class = require("external.hump.class")

local BubbleParticles = Class {
    init = function(self)
        self.pos = Vector(0,0)
        self.vel = Vector(0,0)
        self.rot = 0
        local img = love.graphics.newImage('assets/love_logo.png')
        self.psystem = love.graphics.newParticleSystem(img, 32)
        self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
        self.psystem:setSizes(0.05)
        self.psystem:setSizeVariation(1)
        -- self.psystem:setEmissionArea(
        --     "normal",
        --     5,
        --     10,
        --     0,
        --     false
        -- )
        self.psystem:setLinearDamping(0,0,10,10)
        --self.psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
        self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
    end;

    update = function(self, dt, pos, vel, rot, thrust_direction)
        self.pos = pos
        self.vel = vel
        self.rot = rot
        self.psystem:setEmissionArea(
            "normal",
            0.1*math.abs(self.vel.x),
            0.1*math.abs(self.vel.y),
            0,
            false
        )
        self.psystem:setParticleLifetime(1, self.vel:len()*0.05)
        if thrust_direction ~= 0 then
            self.psystem:setDirection((self.rot- (thrust_direction*math.pi/2)))
        end
        self.psystem:setSpeed( 0, self.vel:len())
        self.psystem:setEmissionRate(self.vel:len())
        self.psystem:update(dt)
    end;

    draw = function(self)
        love.graphics.draw(self.psystem, self.pos.x, self.pos.y)
    end;
}

return BubbleParticles