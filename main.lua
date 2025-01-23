require './utils/sort'
require './utils/create'
require './utils/stats'
require './utils/path'



function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        love.load()
    elseif key == "=" then
        camTrack()
    elseif key == "space" then
        if love.update == run then
            love.update = pause
        else
            love.update = run
        end
    end
end

function newBall()
    b = defaultRect()
    table.insert(lor,b)
end

function godPush(axis,dir)
    for i,r in pairs(lor) do
        r[axis] = r[axis] + dir*.5
    end
    for i,p in ipairs(path) do
        p[axis] = p[axis] + dir*.5
    end
end

function dist(r,s)
    return math.sqrt((r.x-s.x)^2+(r.y-s.y)^2)
end

function pushBalls()
    if #lor>1 then
        for i,r in pairs(lor) do
            for j = i+1,#lor do
                local d = dist(r,lor[j])
                -- standard push/pull with collision
                if d < r.w + lor[j].w then
                    d = -1*d
                end
                local dx = G*(r.x - lor[j].x)/(d^3)
                local dy =  G*(r.y - lor[j].y)/(d^3)
                r.vx = r.vx - ((lor[j].w)^3)*dx
                r.vy = r.vy - ((lor[j].w)^3)*dy
                lor[j].vx = lor[j].vx + ((r.w)^3)*dx
                lor[j].vy = lor[j].vy + ((r.w)^3)*dy

                -- broken eat code
                -- if d<r.w + lor[j].w then
                --     if r.w > lor[j].w then
                --         table.insert(rml,j)
                --         r.w = r.w + lor[j].w/2
                --     else
                --         table.insert(rml,i)
                --         lor[j].w = lor[j].w + r.w/2
                --     end
                -- else 
                --     local dx = G*(r.x - lor[j].x)/(d^3)
                --     local dy =  G*(r.y - lor[j].y)/(d^3)
                --     r.vx = r.vx - ((lor[j].w)^3)*dx
                --     r.vy = r.vy - ((lor[j].w)^3)*dy
                --     lor[j].vx = lor[j].vx + ((r.w)^3)*dx
                --     lor[j].vy = lor[j].vy + ((r.w)^3)*dy
                -- end
            end
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

function step()
    for i,r in pairs(lor) do
        r.x = r.x + r.vx
        r.y = r.y + r.vy
    end
end

function garbageCollect()
    if #path > 1000*trackcount then
        for i = 1,trackcount do
            table.remove(path,1)
        end
    end
    for i,r in pairs(lor) do
        if r.x > 2520 or r.x < -600 or r.y > 1680 or r.y < -600 then
            table.insert(rml, i)
        end
    end
    sort(rml)
    for i,j in ipairs(rml) do
        table.remove(lor,j)
        for k,l in ipairs(tracktab) do
            if j == l then 
                table.remove(tracktab,k)
                goto rmldone
            end
        end
        ::rmldone::
    end
    rml = {}
end

pause = function (dt)
    
end

run = function (dt)
    -- if love.math.random(1) == 1 then newBall() end 
    for i=1,love.math.random(10) do newBall() end
    pushBalls()
    if #tracktab >= trackcount then
        for i,j in ipairs(tracktab) do
            traceBall(lor[j],path)
        end
    else
        for i,r in pairs(lor) do
            for j,k in ipairs(tracktab) do
                if k == i then
                    goto intab
                end
            end
            table.insert(tracktab, i)
            ::intab::
            if #tracktab == trackcount then goto tracktabfull end
        end
        ::tracktabfull::
    end
    step()
    framecount = framecount + 1
    if not love.window.hasFocus() then
        love.update = pause
    end
end

function love.draw()
    for i,r in ipairs(path) do
        love.graphics.setColor( r.r, r.g, r.b)
        love.graphics.circle("fill", r.x,r.y,1)
    end

    garbageCollect()

    for i,r in pairs(lor) do
        love.graphics.setColor(r.r,r.g,r.b)
        love.graphics.circle("fill",r.x,r.y,r.w)
    end

    lormax, lormean = stats(lor,lormax,lormean,framecount)
end

function love.load()
    lor = {}
    G = 1
    path = {}
    lormax = 0
    lormean = 0
    framecount = 0
    inertial = false
    trackcount = 2
    tracktab = {}
    rml = {}
    love.update = run
end