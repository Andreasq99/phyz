
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
    rect.x = 100 + love.math.random(love.graphics.getWidth()-100)
    rect.y = 100 + love.math.random(love.graphics.getHeight()-100)
    rect.w = w
    -- rect.vx = love.math.random(30)/10
    -- if love.math.random(2) == 1 then rect.vx = -rect.vx end
    -- rect.vy = love.math.random(30)/10
    -- if love.math.random(2) == 1 then rect.vy = -rect.vy end
    rect.vx = 0
    rect.vy = 0
    rect.r = love.math.random(10)/10
    rect.g = love.math.random(10)/10
    rect.b = love.math.random(10)/10

    return rect
end

function createFermion()
    local r = {}
    if love.math.random(2) == 1 then
        r = createRect(20)
        r.p = -1
        r.g = 0
        r.r = 0
        r.b = 1
    else
        r = createRect(20)
        r.p = 1
        r.g = 0
        r.r = 1
        r.b = 0
    end
    return r
end