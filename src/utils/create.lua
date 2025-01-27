
function defaultRect()
    local w = 1
    roll = love.math.random(1000)
    -- if roll < 751 then
    --     w = love.math.randomNormal(3,3)
    -- elseif roll < 901 then
    --     w = love.math.randomNormal(3,10)
    -- elseif roll<999 then
    --     w = love.math.randomNormal(5, 20)
    -- else
    --     w = love.math.randomNormal(20,80)
    --     end
    w = math.ceil(roll/200)
    return createRect(w)
end

function createRect(w)
    rect = {}
    -- rect.x = 100 + love.math.random(love.graphics.getWidth()-100)
    -- rect.y = 100 + love.math.random(love.graphics.getHeight()-100)
    local angle = math.pi*love.math.random(999)/500
    local distance = love.math.random(love.graphics.getWidth()-100)
    rect.x = love.graphics.getWidth()/2+distance*math.cos(angle)
    rect.y = love.graphics.getHeight()/2+distance*math.sin(angle)

    rect.w = w
    -- rect.vx = love.math.random(30)/10
    -- if love.math.random(2) == 1 then rect.vx = -rect.vx end
    -- rect.vy = love.math.random(30)/10
    -- if love.math.random(2) == 1 then rect.vy = -rect.vy end
    rect.vx = 0
    rect.vy = 0
    rect.r = love.math.random(40)/40
    rect.g = love.math.random(40)/40
    rect.b = love.math.random(40)/40
    -- rect.r = 0.8
    -- rect.g = 1
    -- rect.b = 1


    return rect
end
