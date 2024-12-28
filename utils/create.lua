
function defaultRect()
    local w = 1
    roll = love.math.random(1000)
    if roll < 751 then
        w = love.math.randomNormal(3,3)
    elseif roll < 901 then
        w = love.math.randomNormal(3,10)
    elseif roll<999 then
        w = love.math.randomNormal(5, 20)
    else
        w = love.math.randomNormal(20,80)
        end
    return createRect(w)
end

function createRect(w)
    rect = {}
    rect.x = 200 + love.math.random(1520)
    rect.y = 100 + love.math.random(880)
    rect.w = w
    rect.vx = love.math.random(30)/10
    if love.math.random(2) == 1 then rect.vx = -rect.vx end
    rect.vy = love.math.random(30)/10
    if love.math.random(2) == 1 then rect.vy = -rect.vy end
    
    rect.r = love.math.random(10)/10
    rect.g = love.math.random(10)/10
    rect.b = love.math.random(10)/10

    return rect
end
