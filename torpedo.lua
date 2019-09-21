Class = require("external.hump.class")
Vector = require("external.hump.vector")

local Torpedo = Class{
    init = function(self, pos, rot, speed)
        self.pos = pos
        self.rot = rot
        self.speed = speed
        self.img = love.graphics.newImage("assets/torpedo.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.scale = 0.05
        self.is_crashed = false
        self.max_trabel_time = 5
        self.cur_travel_time = 0
        self.collider = GAME_STATE.PYSICS_WORLD:rectangle(
            self.pos.x - self.size.x*self.scale/2,
            self.pos.y - self.size.y*self.scale/2,
            self.size.x*self.scale,
            self.size.y*self.scale
        )
        self.collider:setRotation(self.rot)
    end;

    update = function(self, dt)
        if self.collider == nil then
            return
        end
        if self.collider.IS_HIT == true then
            self.is_crashed = true
            GAME_STATE.PYSICS_WORLD:remove(self.collider)
            return
        end
        local direction = Vector.fromPolar(self.rot-math.pi/2,1)
        self.pos = self.pos + (direction * self.speed * dt)
        self.cur_travel_time = self.cur_travel_time + dt
        if self.cur_travel_time >= self.max_trabel_time then
            self.is_crashed = true
        end
        self.collider:moveTo(self.pos.x, self.pos.y)
        self.collider:setRotation(self.rot)
        local collisions = GAME_STATE.PYSICS_WORLD:collisions(self.collider) 
        for shape, delta in pairs(collisions) do
            shape.IS_HIT = true
            if self.is_crashed == false then
                self.is_crashed = true
                GAME_STATE.PYSICS_WORLD:remove(self.collider)
            end
        end
    end;

    draw = function(self)
    if not self.is_crashed then
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
        self.collider:draw()
    end;

    has_crashed = function(self)
        return self.is_crashed
    end;

}

return Torpedo