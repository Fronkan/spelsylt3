Class = require("external.hump.class")
Vector = require("external.hump.vector")

Torpedo = Class{
    init = function(self, pos, rot, speed)
        self.pos = pos
        self.rot = rot
        self.speed = speed
        self.img = love.graphics.newImage("assets/mustasch.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.is_crashed = false
        self.max_trabel_time = 5
        self.cur_travel_time = 0
    end;

    update = function(self, dt)
        local direction = Vector.fromPolar(self.rot-math.pi/2,1)
        self.pos = self.pos + (direction * self.speed * dt)
        self.cur_travel_time = self.cur_travel_time + dt
        if self.cur_travel_time >= self.max_trabel_time then
            self.is_crashed = true
        end
    end;

    draw = function(self)
        love.graphics.draw(
            self.img,
            self.pos.x,
            self.pos.y,
            self.rot,
            0.2, -- scale x
            0.2, -- scale y 
            self.size.x/2, -- origin offset x
            self.size.y/2 -- origin offset y
        )
    end;

    has_crashed = function(self)
        return self.is_crashed
    end;
}

return Torpedo