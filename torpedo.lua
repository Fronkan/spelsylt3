Class = require("external.hump.class")
Vector = require("external.hump.vector")
Explosion = require("explosion")
require("utils")

local Torpedo = Class{
    init = function(self, pos, rot, speed, dmg, collider_to_ignore)
        self.pos = pos
        self.rot = rot
        self.speed = speed
        self.dmg = dmg
        self.img = love.graphics.newImage("assets/torpedo.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.scale = 0.05
        self.is_alive = true
        self.max_trabel_time = 5
        self.cur_travel_time = 0
        self.collider = create_rect_collider(
            self.pos - self.size*self.scale/2,
            self.size*self.scale,
            self.rot,
            ENTITY_WEAPON
        )
        print(collider_to_ignore)
        self.collider_to_ignore = collider_to_ignore
        self.bubbles = BubbleParticles(self)
    end;

    update = function(self, dt)

        if self.collider.IS_HIT == true then
            self.is_alive = false
            return
        end
        local direction = Vector.fromPolar(self.rot-math.pi/2,1)
        self.pos = self.pos + (direction * self.speed * dt)
        self.cur_travel_time = self.cur_travel_time + dt
        if self.cur_travel_time >= self.max_trabel_time then
            self.is_alive = true
        end
        self.collider:moveTo(self.pos.x, self.pos.y)
        self.collider:setRotation(self.rot)
        local collisions = game.PYSICS_WORLD:collisions(self.collider)
        for shape, delta in pairs(collisions) do
            if shape ~= self.collider_to_ignore then
                shape.IS_HIT = true
                shape.RAW_DMG = shape.RAW_DMG + self.dmg
                if self.is_alive then
                    self.is_alive = false
                end
            end
        end
        self.bubbles:update(dt, self.pos + (Vector.fromPolar(self.rot+math.pi/2,1)*20), 30*direction, self.rot, -1)
    end;

    draw = function(self)
    if self.is_alive then
        self.bubbles:draw()
        love.graphics.draw(
            self.img,
            self.pos.x,
            self.pos.y,
            self.rot,
            self.scale, -- scale x
            self.scale, -- scale y 
            self.size.x/2, -- origin offset x
            self.size.y/2 -- origin offset y
        )
    end
        -- self.collider:draw()
    end;

    has_crashed = function(self)
        return not self.is_alive
    end;

    explode = function(self)
        return Explosion(self.pos)
    end;

    delete = function(self)
        game.PYSICS_WORLD:remove(self.collider)
        self = nil
    end;
}

return Torpedo