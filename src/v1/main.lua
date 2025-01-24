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
    if key == "escape" or key == "space" then
        love.event.quit()
    elseif key == "return" then
        love.load()
    elseif key == "=" then
        camTrack()
    end
    table.insert(lor,defaultRect())
end

function godPush(axis,dir)
    for i,r in ipairs(lor) do
        r[axis] = r[axis] + dir*.5
    end
    for i,p in ipairs(path) do
        p[axis] = p[axis] + dir*.5
    end
end

function pushBalls()
    for i,r in ipairs(lor) do
        for j,s in ipairs(lor) do
            if not (i == j) then
                local dist = math.sqrt((r.x-s.x)^2+(r.y-s.y)^2)^3
                -- r.vx = r.vx + r.p*s.p*G*((s.w)^3)*(r.x - s.x)/dist
                -- r.vy = r.vy + r.p*s.p*G*((s.w)^3)*(r.y - s.y)/dist
                r.vx = r.vx - G*((s.w)^3)*(r.x - s.x)/dist
                r.vy = r.vy - G*((s.w)^3)*(r.y - s.y)/dist
            end
        end
        if love.keyboard.isDown("up","w") then
            godPush("y",1)
        end
        if love.keyboard.isDown("down","s") then
           godPush("y",-1) 
        end
        if love.keyboard.isDown("left","a") then
            godPush("x",1)
        end
        if love.keyboard.isDown("right","d") then
            godPush("x",-1)
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
        b.p = 1
        table.insert(lor,b)
    end
    for i = 1,love.math.randomNormal(5,20) do
        local r = defaultRect()
        r.vx = 0
        r.vy = 0
        r.p = -1
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
end

function love.update(dt)
    if love.math.random(5) == 1 then 
        rect = defaultRect()
        -- if love.math.random(2) == 1 then rect.p = 1 else rect.p = -1 end
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
        love.graphics.circle("fill",r.x,r.y,r.w)
    end

    lormax, lormean = stats(lor,lormax,lormean,framecount)
end