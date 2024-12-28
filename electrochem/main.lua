require '../utils/sort'
require '../utils/create'
require '../utils/path'
require '../utils/stats'

function love.load()
    lor = {}
    G = 1
    path = {}
    lormax = 0
    lormean = 0
    framecount = 0
    inertial = true
    trackcount = 2
    solarsys()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        love.load()
    end
end

function pushBalls()
    for i,r in ipairs(lor) do
        for j,s in ipairs(lor) do
            if not (i == j) then
                local dist = math.sqrt((r.x-s.x)^2+(r.y-s.y)^2)^3
                r.vx = r.vx + r.p*s.p*G*((s.w)^3)*(r.x - s.x)/dist
                r.vy = r.vy + r.p*s.p*G*((s.w)^3)*(r.y - s.y)/dist
            end
        end 
    end
end

function step()
    for i,r in ipairs(lor) do
        r.x = r.x + r.vx
        r.y = r.y + r.vy
    end
end




function solarsys() 
    if inertial then
        local b = createRect(100)
        b.x = 560
        b.y = 540
        b.vx = 0
        b.vy = 0
        b.p = 1
        table.insert(lor,b)
        local c = createRect(100)
        c.x = 1360
        c.y = 540
        c.vx = 0
        c.vy = 0
        c.p = 1
        table.insert(lor,c)
    end

    local e = createRect(3)
    e.x = 560
    e.y = 940
    e.vx = 0
    e.vx = 10/math.sqrt(3)
    -- e.vx = love.math.randomNormal(50,20)
    e.vx = 47.7
    e.vy = 0
    e.p = -1
    table.insert(lor,e)

    -- local p = createRect(100)
    -- p.x = 2000
    -- p.y = 1100
    -- p.vx = 0
    -- p.vy = 0
    -- table.insert(lor, p)
end



function love.update(dt)
    -- if love.math.random(5) == 1 then table.insert(lor,defaultRect()) end
    pushBalls()
    traceBall(lor[3],path)
    -- if #lor >= trackcount then
    --     for j = 1,trackcount do
    --         traceBall(lor[j])
    --     end
    -- end
    if inertial then
        lor[1].vx = 0
        lor[1].vy = 0
        lor[2].vx = 0
        lor[2].vy = 0
    end

    -- lor[3].x, lor[3].y = love.mouse.getPosition()
    -- lor[3].vx = 0
    -- lor[3].vy = 0
    step()
end



function love.draw()
    drawPath(path)

    garbageCollect(path,trackcount)

    for i,r in ipairs(lor) do
        love.graphics.setColor(r.r,r.g,r.b)
        love.graphics.circle("fill",r.x,r.y,r.w)
    end

    stats(lor,lormax,lormean,framecount)
end