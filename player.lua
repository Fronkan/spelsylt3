Class = require("external.hump.class")
Vector = require("external.hump.vector")
WeaponSystem = require("weaponsystem")
BubbleParticles = require("bubbleparticles")
require("utils")

local Player = Class{
    init = function(self, x,y)
        self.pos = Vector(x,y)
        self.is_alive = true
        self.HP = 100
        self.rot = 0
        self.rot_speed = 0.2
        self.vel = Vector(0,0)
        self.cur_acc = Vector(0,0)
        self.acc_force = 20
        self.img = love.graphics.newImage("assets/player_sub.png")
        self.size = Vector(self.img:getWidth(), self.img:getHeight())
        self.scale = 0.2
        self.max_thrust = 20
        self.max_speed = 40
        self.bubbles = BubbleParticles(self)
        self.collider = create_rect_collider(
            self.pos - self.size*self.scale/2,
            self.size*self.scale,
            self.rot 
        )
        self.ws = WeaponSystem(self.collider)
    end;

    update = function(self, dt)
        if self.collider.IS_HIT == true then
            self.HP = self.HP - self.collider.RAW_DMG
            if self.HP < 0 then
                self.is_alive = false
            else
                self.collider.IS_HIT = false
                self.collider.RAW_DMG = 0
            end
        end
        local vertical = 0
        local horizontal = 0      
        if self.is_alive then
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
            self.collider:moveTo(self.pos.x, self.pos.y)
            self.collider:setRotation(self.rot)
            if self.collider.IS_HIT == true then
                --print("IM HIT SO BAD!")
            end
            self.bubbles:update(dt, self.pos + (Vector.fromPolar(self.rot+math.pi/2,1)*98), self.vel, self.rot, vertical)
    end;


    draw = function(self)
        self.ws:draw()
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
        self.collider:draw()
    end;

}

return Player