Class = require("external.hump.class")
Vector = require("external.hump.vector")
WeaponSystem = require("weaponsystem")
BubbleParticles = require("bubbleparticles")
require("utils")

local Player = Class{
    init = function(self, x,y)
        self.pos = Vector(x,y)
        self.rot = 0
        self.rot_speed = 0.2
        self.vel = Vector(0,0)
        self.cur_acc = Vector(0,0)
        self.acc_force = 20
        self.img = love.graphics.newImage("assets/player_sub.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.max_thrust = 20
        self.max_speed = 40
        self.ws = WeaponSystem()
        self.bubbles = BubbleParticles(self)
    end;

    update = function(self, dt)
        local vertical
        local horizontal        
        if love.keyboard.isDown("right") then
            horizontal = 1
        elseif love.keyboard.isDown("left") then
            horizontal = -1
        else
            horizontal = 0 
        end
         
        if love.keyboard.isDown("down") then
            vertical = 1
        elseif love.keyboard.isDown("up") then
            vertical = -1
        else
            vertical = 0 
        end

        if love.keyboard.isDown("space") then
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
        love.graphics.print(
            "Pos: ".. math.floor(self.pos.x).. ", "..math.floor(self.pos.y),
             200, 
             200)
        love.graphics.print(
            "Speed: "..math.floor(self.vel:len()),
            200, 
            220
        )
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

return Player