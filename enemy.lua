Class = require("external.hump.class")
Vector = require("external.hump.vector")
WeaponSystem = require("weaponsystem")
BubbleParticles = require("bubbleparticles")
require("utils")

local Enemy = Class{
    init = function(self, x,y, target)
        self.target = target
        self.pos = Vector(x,y)
        self.rot = 0
        self.rot_speed = 0.2
        self.vel = Vector(0,0)
        self.cur_acc = Vector(0,0)
        self.acc_force = 20
        self.img = love.graphics.newImage("assets/enemy_sub.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.max_thrust = 20
        self.max_speed = 40
        self.ws = WeaponSystem()
        self.bubbles = BubbleParticles(self)
    end;

    update = function(self, dt)
        local vertical
        local horizontal
        local fire = false
        local target_vector = self.pos - self.target.pos
        local target_angle = target_vector:angleTo(Vector.fromPolar(self.rot+math.pi/2, 1))
        if  target_angle < 0.1 and target_angle > -0.1 then
            horizontal = 0
            fire = true
        elseif target_angle < 0 then
            horizontal = -1
        else
            horizontal = 1
        end


        vertical = 0

        if fire then
            self.ws:fire(self.pos -(Vector.fromPolar(self.rot+math.pi/2,1)*80), self.rot)
        end
        self.ws:update(dt)

        self.rot = self.rot + horizontal*self.rot_speed*math.pi/2*dt
        direction = Vector.fromPolar(self.rot+math.pi/2, Vector(horizontal, vertical):len())
        
        local thrust = direction:normalized() * clamp_abs(
            direction:len() * vertical * self.acc_force*dt,
            self.max_thrust
        )
        local drag = Vector(0,0)
        if self.vel:len() ~= 0 then
            drag = self.vel:normalized() * 0.05
        end
        self.vel = self.vel + thrust - drag
        self.vel = self.vel:normalized()*clamp(
            self.vel:len(),
            0,
            self.max_speed
        )

        self.pos.x = self.pos.x + self.vel.x * dt
        self.pos.y = self.pos.y + self.vel.y * dt
        self.bubbles:update(dt, self.pos + (Vector.fromPolar(self.rot+math.pi/2,1)*98), self.vel, self.rot, vertical)
    end;


    draw = function(self)
        self.bubbles:draw()
        self.ws:draw()
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
}

return Enemy