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

function add_custom_collider_data(collider, entity_type)
    collider.IS_HIT = false
    collider.RAW_DMG = 0
    collider.ENTITY_TYPE = entity_type
    return collider
end

function create_rect_collider(center_pos, size, rot, entity_type)
    local collider = game.PYSICS_WORLD:rectangle(
        center_pos.x ,
        center_pos.y,
        size.x,
        size.y
    )
    collider:setRotation(rot)
    collider = add_custom_collider_data(collider, entity_type)
    return collider
end

function create_circle_collider(center_pos, radius, entity_type)
    local collider = game.PYSICS_WORLD:circle(
        center_pos.x ,
        center_pos.y,
        radius
    )
    collider = add_custom_collider_data(collider, entity_type)
    return collider
end