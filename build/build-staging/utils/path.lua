function traceBall(ball, tab)
    point = {}
    point.x = ball.x
    point.y = ball.y
    point.r = ball.r
    point.g = ball.g
    point.b = ball.b
    table.insert(tab, point)
    return tab
end

function drawPath(tab)
    for i,r in ipairs(tab) do
        love.graphics.setColor(r.r,r.g,r.b)
        love.graphics.circle("fill",r.x,r.y,1)
    end

end

function garbageCollect(tab,count)
    if #tab > 1000*count then
        for i = 1,count do
            table.remove(tab,1)
        end
    end
end