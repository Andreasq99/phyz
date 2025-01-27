function stats(lor,lormax,lormean,framecount,framerate)
    
    love.graphics.setColor(1,1,1)
    countlog = string.gsub("Number of particles: z","z",tostring(#lor))
    love.graphics.print(countlog,10,30)
    if #lor > lormax then lormax = #lor end
    maxlog = string.gsub("Maximum number of particles: z", "z", tostring(lormax))
    love.graphics.print(maxlog, 10,50)
    lormean = lormean * framecount
    framecount = framecount + 1
    lormean = (lormean + #lor)/framecount
    meanlog = string.gsub("Mean number of particles: z", "z", tostring(math.floor(lormean)))
    love.graphics.print(meanlog, 10,70)
    love.graphics.print("Press (Esc) to close. Press (Enter) to restart the simulation.",10,10)
    frameslog = string.gsub("Framerate: z","z",tostring(framerate))
    love.graphics.print(frameslog,10,90)
    return lormax, lormean
end

function speedStat(v)
    love.graphics.setColor(1,1,1)
    speedLog = string.gsub("Tracker speed: z m/s","z",tostring(math.floor(1000*v)))
    love.graphics.print(speedLog,10,110)
end