require './utils/sort'
require './utils/create'
require './utils/stats'
require './utils/path'
json = require './utils/json'



function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        restart()
    elseif key == "l" then
        if trackCount > 0 then camTrack() else camTrackInd = 1 end
    elseif key == "space" then
        if love.update == run then
            love.update = pause
        else
            love.update = run
        end
    end
end

function love.mousepressed(x,y,button,istouch)
    for i,r in ipairs(lor) do
        if len(x,y,r.x,r.y) < r.w then 
            camTrackInd = i
            goto mousedone
        end
    end
    ::mousedone::
end

camTrackTable = {}
camTrackTable[1] = function ()
    if camTrackInd > -1 then
        camTrackInd = -1
    else 
        camTrackInd = tracktab[love.math.random(#tracktab)]
    end
end

camTrackTable[2] = function ()
    camTrackInd = -1
    camTrackTimeout = -1
    camTrack = camTrackTable[1]
end

function restart()
    local data = ""
    data = json.encode({ tracking = (camTrackInd > 0) })
    io.output("./data.json")
    io.write(data)
    love.load()
end

function newBall()
    local r = math.abs(love.math.randomNormal(planetSizeStdDev,planetSizeMean))
    if r < 2 then r = 2 end
    b = createRect(r)
    if camTrackInd > -1 then
        b.x = b.x - lor[camTrackInd].vx
        b.y = b.y - lor[camTrackInd].vy
    end
    table.insert(lor,b)
end

function godPush(axis,dir)
    for i,r in pairs(lor) do
        r[axis] = r[axis] + dir
    end
    for i,p in ipairs(path) do
        p[axis] = p[axis] + dir
    end
end

function len(x1,y1,x2,y2)
    return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

function dist(r,s)
    return len(r.x,r.y,s.x,s.y)
end

function pushBalls()
    if #lor>1 then
        for i,r in pairs(lor) do
            for j = i+1,#lor do
                local d = dist(r,lor[j])
                -- standard push/pull with collision
                if d < (r.w + lor[j].w) then
                    d = bounceFactor*d
                end
                local dx = G*(r.x - lor[j].x)/(d^3)
                local dy =  G*(r.y - lor[j].y)/(d^3)
                
                if not bounceFactor == 1 and (dx >5 or dy>5) then dx,dy = 0,0 end
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
        godPush("y",5)
    end
    if love.keyboard.isDown("down","s") then
    godPush("y",-5) 
    end
    if love.keyboard.isDown("left","a") then
        godPush("x",5)
    end
    if love.keyboard.isDown("right","d") then
        godPush("x",-5)
    end
    
end

function step()
    for i,r in pairs(lor) do
        r.x = r.x + r.vx
        r.y = r.y + r.vy
    end
    if camTrackInd > -1 then
        godPush("x", love.graphics.getWidth()/2 - lor[camTrackInd].x + 5*lor[camTrackInd].vx)
        godPush("y", love.graphics.getHeight()/2 - lor[camTrackInd].y + 5*lor[camTrackInd].vy)
    end
end

function garbageCollect()
    if #path > math.min(1000*trackCount,10000) then
        for i = 1,trackCount do
            table.remove(path,1)
        end
    end
    for i,r in pairs(lor) do
        if r.x > love.graphics.getWidth()+600 or r.x < -600 or r.y > love.graphics.getHeight()+600 or r.y < -600 then
            table.insert(rml, i)
        end
    end
    sort(rml)
    for i,j in ipairs(rml) do
        if j == camTrackInd then camTrackInd = -1 elseif j < camTrackInd then camTrackInd = camTrackInd -1 end
        table.remove(lor,j)
        for k,l in ipairs(tracktab) do
            if l == j then 
                table.remove(tracktab,k)
                goto rmldone
            end
        end
        ::rmldone::
    end
    rml = {}
end

pause = function (dt) end

run = function (dt)
    if #lor<=maxPlanets-spawnCap then 
        for i=1,spawnCap do 
            if love.math.random(spontFactor) == 1 then newBall() end 
        end
    end
    pushBalls()
    if #tracktab < trackCount then
        for i,r in pairs(lor) do
            for j,k in ipairs(tracktab) do
                if k == i then
                    goto intab
                end
            end
            table.insert(tracktab, i)
            ::intab::
            if #tracktab == trackCount then goto tracktabfull end
        end
        ::tracktabfull::
    end
    for i,j in ipairs(tracktab) do
        if not (lor[j] == nil) then traceBall(lor[j],path) end
    end
    step()
    garbageCollect()
    frameCount = frameCount + 1
    if camTrackTimeout>-1 and os.clock() - camTrackTimeout >1 then
        camTrack = camTrackTable[1]
        camTrack()
        camTrackTimeout = -1
    end
    
    if spectatorMode and camTrackInd > -1 and len(lor[camTrackInd].vx,lor[camTrackInd].vy,0,0) > speedLimit then
        camTrack()
        camTrack = camTrackTable[2]
        camTrackTimeout = os.clock()
    end
    if not love.window.hasFocus() and not spectatorMode then
        love.update = pause
    end
    secondFrameCount = secondFrameCount + 1
    if os.clock() - secondTimer >=1 then 
        secondFrameRate = secondFrameCount
        secondFrameCount = 0
        secondTimer = os.clock()
    end

    if slideShowMode and os.clock() - slideShowTimer >= 45 then restart() end
end

function love.draw()
    for i,r in ipairs(path) do
        local d = len(r.vx,r.vy,0,0)
        local angle = math.acos(r.vx/d)
        if r.vy < 0 then angle = -1*angle end
        love.graphics.push()
        love.graphics.translate(r.x,r.y)
        love.graphics.rotate(angle)
        for j=1,3 do -- j=1 is the darkest, most translucent, and largest ball, j=5 is the brightest, fully opaque, smallest ball
            local bloomFactor = (4/((4-j)^2))*(2*i/(#path))
            love.graphics.setColor((r.r)*bloomFactor,(r.g)*bloomFactor,(r.b)*bloomFactor,1/((4-j)^2))
            local s = 3/(j)
            love.graphics.rectangle("fill",-s,-s, d+2*s,2*s)
        end
        
        love.graphics.pop()
        
    end
    for i,r in pairs(lor) do
        for j=1,3 do -- j=1 is the darkest, most translucent, and largest ball, j=5 is the brightest, fully opaque, smallest ball
            local bloomFactor = (1/((4-j)))
            love.graphics.setColor((r.r)*bloomFactor,(r.g)*bloomFactor,(r.b)*bloomFactor,1/((4-j)^2))
            love.graphics.circle("fill",r.x,r.y,1.25*r.w/math.log(j+1))
        end
    end

    lormax, lormean = stats(lor,lormax,lormean,frameCount,secondFrameRate)
    if camTrackInd > -1 then speedStat(len(lor[camTrackInd].vx,lor[camTrackInd].vy,0,0)) end
end

function love.load()
    lor = {}
    path = {}
    tracktab = {}
    rml = {}

    lormax = 0
    lormean = 0
    frameCount = 0
    -- trackCount = 5
    secondFrameCount = 0
    secondFrameRate = 0
    secondTimer = os.clock()
    
    love.update = run
    
    -- io.input("./data.json")
    -- if json.decode(io.read("*all"))["tracking"] then
    --     newBall()
    --     camTrackInd = 1
    -- else 
    --     camTrackInd = -1
    -- end
    
    camTrackInd = -1
    camTrack = camTrackTable[1]
    camTrackTimeout = -1

    io.input("./options.json")
    optionsString = io.read("*all")

    options = {}
    options = json.decode(optionsString)

    slideShowMode = false
    slideShowTimer = os.clock()
    address = "./presets/z/config.json"
    if options["index"] < 0 then
        slideShowMode = true
        options["index"] = love.math.random(#options["options"])
    end


    -- if options["index"]==0 then
    --     G = 
    -- else 

    address = string.gsub(address,"z",options["options"][options["index"]])
    io.input(address)
    optionsString = io.read("*all")
    options = json.decode(optionsString)

    G = tostring(options["G"])

    trackCount = options["trackCount"]
    spectatorMode = options["spectatorMode"]
    bounceFactor = options["bounceFactor"]
    spontFactor = options["spontFactorCap"]
    spawnCap = options["spawnCap"]
    planetSizeMean = options["planetSizeMean"]
    planetSizeStdDev = options["planetSizeStdDev"]
    maxPlanets = options["maxPlanets"]
    
    trackCount = math.min(options["trackCount"],maxPlanets)

    speedLimit = 0
    if bounceFactor > 1 then speedLimit = 20
    elseif bounceFactor >0 then speedLimit = 10
    else speedLimit = 8
    end

    -- spectatorMode = true

    -- bounceFactor = -1
    -- G = 1/50

    -- spontFactor = love.math.random(10)
    -- bounceFactor = (-1)^love.math.random(2)
    -- G = 1/(50*math.random(4))
    
end