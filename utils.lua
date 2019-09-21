function sign(val)
    if val < 0 then
        return -1
    else
        return 1
    end

end

function clamp(val, min, max)
    return math.max(min, math.min(val, max));
end

function clamp_abs(val, max)
    if math.abs(val) <= math.abs(max) then
        return val
    else
        return sign(val) * max
    end
end

function create_rect_collider(center_pos, size, rot)
    local collider = GAME_STATE.PYSICS_WORLD:rectangle(
        center_pos.x ,
        center_pos.y,
        size.x,
        size.y
    )
    collider:setRotation(rot)
    collider.IS_HIT = false
    collider.RAW_DMG = 0
    return collider
end