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