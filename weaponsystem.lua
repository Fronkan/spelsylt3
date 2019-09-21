Class = require("external.hump.class")
Torpedo = require("torpedo")

local WeaponSystem = Class {
    init = function(self)
        self.torpedos = {}
        self.cool_down = 2
        self.reload_timer = 0
    end;

    update = function(self, dt)

        -- Check the reload_timer
        if self.reload_timer > 0 then
            self.reload_timer = self.reload_timer -dt
        else
            self.reload_timer = 0
        end

        -- Update torpedos and remove crashed ones
        local to_be_removed = {}
        for idx, torpedo in ipairs(self.torpedos) do
            torpedo:update(dt)
            if torpedo:has_crashed() then
                table.insert(to_be_removed, idx)
            end
        end
        for _, torpedo_idx in ipairs(to_be_removed) do
            table.remove(self.torpedos, torpedo_idx)
        end
    end;

    fire = function(self, pos, rot)
        if self.reload_timer == 0 then
            local torpedo = Torpedo(pos, rot, 150)
            table.insert(self.torpedos,torpedo)
            self.reload_timer = self.cool_down
        end
    end;

    draw = function(self)
        for _, torpedo in ipairs(self.torpedos) do
            torpedo:draw()
        end
    end;
}

return WeaponSystem
