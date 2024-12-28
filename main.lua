-- function love.draw()
--     love.graphics.print("Hello world",400,300)
-- end
-- function love.load()
--     x,y,w,h = 200,200,60,20
-- end

-- function love.keypressed()
--     x = x-1
--     y = y-1
--     w = w+2
--     h = h+2
--     love.graphics.print("Wow!",x+w/2, y+h/2)
-- end

-- function love.draw()
--     love.graphics.setColor(0,0.4,0.4)
--     love.graphics.rectangle("fill",x,y,w,h)
-- end

require './utils/sort'
require './utils/create'
require './utils/stats'

function love.load()
    lor = {}
    G = 1/10
    path = {}
    lormax = 0
    lormean = 0
    framecount = 0
    inertial = false
    trackcount = 10
    -- solarsys()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        love.load()
    end
    table.insert(lor,defaultRect())
end

function eatCollision()
    if love.math.random(10) == 1 then
        defaultRect()
    end
    local rml = {}
    for i,r in ipairs(lor) do
        if (r.x > 800 - r.w and r.vx >0) or (r.x <0 and r.vx <0) then
            r.vx = -r.vx
        end
        if (r.y > 600 - r.h and r.vy >0) or (r.y<0 and r.vy <0) then
            r.vy = -r.vy
        end
        for j = i+1,#lor do
            local s = lor[j]

            if r.x + r.w >s.x and s.x + s.w > r.x and r.y + r.h > s.y and s.y + s.h > r.y then
                if size(r)>size(s) then
                    r.w = r.w + s.w/5
                    r.h = r.h + s.h/5
                    table.insert(rml,j)
                    goto snext
                elseif size(r) < size(s) then
                    s.w = s.w + r.w/5
                    s.h = s.h + r.h/5
                    table.insert(rml,i)
                end
            end
            ::snext::
        end
        local removed = false
        -- if r.age > r.lt then 
        --     table.remove(lor,i)
        --     removed = true
        -- end
        rml = sort(rml)
        print("remove list:")
        for l,j in ipairs(rml) do 
            print(l,j)
        end
        for l,j in ipairs(rml) do
            if j == i and removed then 
                goto skip
            else
                log = "Removing abc at index def from list of rectangles."
                log = string.gsub(log, "abc", tostring(lor[j]))
                log = string.gsub(log, "def", tostring(j))
                print(log)
                table.remove(lor,j)
            end
            ::skip::
        end
        ::rnext::
    end
end

function pushBalls()
    for i,r in ipairs(lor) do
        for j,s in ipairs(lor) do
            if not (i == j) then
                local dist = math.sqrt((r.x-s.x)^2+(r.y-s.y)^2)^3
                r.vx = r.vx - G*((s.w)^3)*(r.x - s.x)/dist
                r.vy = r.vy - G*((s.w)^3)*(r.y - s.y)/dist
            end
        end 
    end
end

function step()
    for i,r in ipairs(lor) do
        r.x = r.x + r.vx
        r.y = r.y + r.vy
        -- r.age = r.age + 1
    end
end

function ballBounce()
    local rml = {}
    for i,r in ipairs(lor) do
        -- for j = i+1,#lor do
        --     local s = lor[j]
        --     local dist = math.sqrt((r.x-s.x)^2+(r.y-s.y)^2)
        --     local rvel = math.sqrt(r.vx^2+r.vy^2)
        --     local svel = math.sqrt(s.vx^2 + s.vy^2)
        --     if dist < r.w + s.w and s.age > 10 and r.age > 10 then
        --         local rrad = r.w
        --         local srad = s.w 
        --         rrad = explode(rrad,r)
        --         rrad = explode(rrad,r)
        --         srad = explode(srad,s)
        --         srad = explode(srad,s)
                
        --         r.x = love.math.randomNormal(1000, 10000)
        --         r.y = love.math.randomNormal(1000, 10000)
        --         s.x = love.math.randomNormal(1000, 10000)
        --         s.y = love.math.randomNormal(1000, 10000)
        --         local el = 1
        --         r.vx =  rvel * (s.w/el)^2* (r.x - s.x) / dist
        --         r.vy =  rvel * (s.w/el)^2*(r.y-s.y) / dist
        --         s.vx =  svel * (r.w/el)^2*(s.x - r.x) / dist
        --         s.vy =  svel * (r.w/el)^2*(s.y - r.y) / dist
        --     end
        -- end
        -- if (r.x > 800 - r.w and r.vx >0) or (r.x < r.w and r.vx < 0)then
        --     -- r.vx = - r.vx
        --     r.x = 800 - r.x
        -- end
        -- if (r.y > 600 - r.w and r.vy > 0 ) or (r.y < r.w and r.vy < 0) then 
        --     -- r.vy = - r.vy
        --     r.y = 600 - r.y
        -- end
        if r.x > 2520 or r.x < -600 or r.y > 1680 or r.y < -600 then
            table.insert(rml, i)
        end
    end
    sort(rml)
    for i,j in ipairs(rml) do
        table.remove(lor,j)
    end
end

function explode(rad, r)
    local rect = {}
    local rand1 = love.math.random(r.w/3)
    local rand2 = love.math.random(r.w/3)
    if math.floor(rand1)%2==0 then rect.x = r.x + rand1 else rect.x = r.x - rand1 end
    if math.floor(rand2)%2==0 then rect.y = r.y + rand2 else rect.y = r.y - rand2 end
    rect.w = love.math.random(rad)
    rad = rad - rect.w
    rect.r = (love.math.randomNormal(15,r.r*100))/100
    rect.g = (love.math.randomNormal(15,r.g*100))/100
    rect.b = (love.math.randomNormal(15,r.b*100))/100
    dist = math.sqrt((r.x-rect.x)^2+(r.y-rect.y)^2)
    rect.vx = 3*(rect.x - r.x)/dist
    rect.vy = 3*(rect.y - r.y)/dist
    -- rect.age = 0
    if rect.w > 2 then
        table.insert(lor,rect)
    end
    return rad
end

function traceBall(ball)
    point = {}
    point.x = ball.x
    point.y = ball.y
    point.r = ball.r
    point.g = ball.g
    point.b = ball.b
    table.insert(path, point)
    
end

function solarsys() 
    if inertial then
        b = {}
        b.x = love.graphics.getWidth()/2
        b.y = love.graphics.getHeight()/2
        b.w = 70
        b.vx = 0
        b.vy = 0
        b.r = .3
        b.g = .4
        b.b = .5
        table.insert(lor,b)
    end
    for i = 1,love.math.randomNormal(5,20) do
        local r = defaultRect()
        r.vx = 0
        r.vy = 0
        -- r.age = 0
        table.insert(lor, r)
    end
end

function garbageCollect()
    if #path > 1000*trackcount then
        for i = 1,trackcount do
            table.remove(path,1)
        end
    end
    if #lor > 200 then
        for i = 200,#lor do
            table.remove(lor,#lor)
        end
    end
end

function love.update(dt)
    if love.math.random(5) == 1 then 
        rect = defaultRect()
        -- rect.age = 0
        table.insert(lor,rect) 
    end
    pushBalls()
    ballBounce()
    if #lor > trackcount then
        for j = 1,trackcount do
            traceBall(lor[j])
        end
    end
    if inertial then
        lor[1].vx = 0
        lor[1].vy = 0
    end
    step()
    framecount = framecount + 1
end

function love.draw()
    for i,r in ipairs(path) do
        love.graphics.setColor( r.r, r.g, r.b)
        love.graphics.circle("fill", r.x,r.y,1)
    end

    garbageCollect()

    for i,r in ipairs(lor) do
        love.graphics.setColor(r.r,r.g,r.b)
        -- love.graphics.rectangle("fill",r.x,r.y,r.w,r.h)
        love.graphics.circle("fill",r.x,r.y,r.w)
    end

    lormax, lormean = stats(lor,lormax,lormean,framecount)
end