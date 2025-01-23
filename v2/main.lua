require './../utils/sort'
require './../utils/create'
require './../utils/stats'

function love.load()
    lor = {}
    G = 1/10
    path = {}
    lormax = 0
    lormean = 0
    framecount = 0
    inertial = false
    trackcount = 10
end

function love.keypressed(key)
    if key == "escape" or key == "space" then
        love.event.quit()
    elseif key == "return" then
        love.load()
    elseif key == "=" then
        camTrack()
    end
end

function newBall()
    b = defaultRect()
    lor[framecount] = b
end

function godPush(axis,dir)
    for i,r in ipairs(lor) do
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
    for i,r in ipairs(lor) do
        for j,s in ipairs(lor) do
            if not (i == j) then
                local d = dist(r,s)^3
                r.vx = r.vx - G*((s.w)^3)*(r.x - s.x)/d
                r.vy = r.vy - G*((s.w)^3)*(r.y - s.y)/d
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


function garbageCollect()
    if #path > 1000*trackcount then
        for i = 1,trackcount do
            table.remove(path,1)
        end
    end
    local rml = {}
    for i,r in ipairs(lor) do
        if r.x > 2520 or r.x < -600 or r.y > 1680 or r.y < -600 then
            table.insert(rml, i)
        end
    end
    sort(rml)
    for i,j in ipairs(rml) do
        table.remove(lor,j)
    end
end

function love.update(dt)
    if love.math.random(5) == 1 then newBall() end 
    pushBalls()
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