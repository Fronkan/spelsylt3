local Class = require("external.hump.class")
local Torpedo = require("torpedo")

local WeaponSystem = Class {
    init = function(self, mean_torpedo_dmg, mean_explosion_dmg, collider_to_ignore)
        self.torpedos = {}
        self.cool_down = 2
        self.reload_timer = 0
        self.collider_to_ignore = collider_to_ignore
        self.explosions = {}
        self.mean_torpedo_dmg = mean_torpedo_dmg
        self.mean_explosion_dmg = mean_explosion_dmg
    end;

    update = function(self, dt)
        local explosions_to_be_removed = {}
        for idx, explosion in ipairs(self.explosions) do
            if explosion == nil then
                table.insert(explosions_to_be_removed, idx)
            else
                explosion:update(dt)
            end
        end
        for _, explosion_idx in ipairs(explosions_to_be_removed) do
            table.remove(self.explosions, explosion_idx)
        end
        -- Check the reload_timer
        if self.reload_timer > 0 then
            self.reload_timer = self.reload_timer -dt
        else
            self.reload_timer = 0
        end

        -- Update torpedos and remove crashed ones
        local to_be_removed = {}
        for idx, torpedo in ipairs(self.torpedos) do
            if torpedo:has_crashed() then
                table.insert(to_be_removed, idx)
                table.insert(self.explosions, torpedo:explode())
                torpedo:delete()
            else
                torpedo:update(dt)
            end
        end
        for _, torpedo_idx in ipairs(to_be_removed) do
            table.remove(self.torpedos, torpedo_idx)
        end
    end;

    fire = function(self, pos, rot)
        if self.reload_timer == 0 then
            local dmg = love.math.randomNormal(1, self.mean_torpedo_dmg)
            local torpedo = Torpedo(pos, rot, 150,dmg,self.collider_to_ignore)
            table.insert(self.torpedos,torpedo)
            self.reload_timer = self.cool_down
        end
    end;

    set_collider_to_ignore = function(self, collider_to_ignore)
        self.collider_to_ignore = collider_to_ignore
    end;

    draw = function(self)
        for _, torpedo in ipairs(self.torpedos) do
            torpedo:draw()
        end
        for _, explosions in ipairs(self.explosions) do
            explosions:draw()
        end
    end;

}

return WeaponSystem
