local unit = {}
unit.__index = unit

local activeUnit = false

function unit:new(x,y,img,unitType,team,att)
    local obj = {
        x = x,
        y = y,
        img = img,
        unitType = unitType, --Motorized Infantry, Mechanized Infantry, Air Assault Infantry, Helicopter Gunship, Main Battle Tank,
        --Self-Propelled Howitzer, Multiple Rocket Launcher, Surface-to-Air Missile, Riverine Patrol Craft, Landing Craft Utility
        team = team,
        hp = 100,
        mp = 100,
        att = att,
        --attMod = attMod,
        def = 0,
        --defMod = defMod,
        state = "idle", --idle, selected, has moved, finished
        --SELECTED ACTIONS: hold, move, resupply... HAS MOVED ACTIONS: attack, bombard, wait, load, unload
        --canCap = canCap, isArty = isArty, isSAM = isSAM, minRange = minRange, maxRange = maxRange
    }
    setmetatable(obj, self)
    return obj
end

function unit:update(dt)
    
end

function unit:draw()
    if self.state == "finished" then
        love.graphics.setColor(1,1,1,0.5)
    else
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.draw(self.img, (self.x - 1) * 24, (self.y - 1) * 24)

    love.graphics.setColor(1,1,1,1)
    if self.state == "selected" then
        love.graphics.rectangle("line", (self.x - 1) * 24, (self.y - 1) * 24, 24,24)
        love.graphics.print(self.team.." "..self.unitType, love.graphics.getWidth() - 450, 50)
        love.graphics.print("HP: "..self.hp, love.graphics.getWidth() - 450, 70)
        love.graphics.print("MP: "..self.mp, love.graphics.getWidth() - 450, 90)
        love.graphics.print("Att: "..self.att, love.graphics.getWidth() - 450, 110)
        love.graphics.print("Def: "..self.def, love.graphics.getWidth() - 450, 130)
    elseif self.state == "has moved" then
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("line", (self.x - 1) * 24, (self.y - 1) * 24, 24,24)
        love.graphics.setColor(1,1,1)
        love.graphics.print(self.team.." "..self.unitType, love.graphics.getWidth() - 450, 50)
        love.graphics.print("HP: "..self.hp, love.graphics.getWidth() - 450, 70)
        love.graphics.print("MP: "..self.mp, love.graphics.getWidth() - 450, 90)
        love.graphics.print("Att: "..self.att, love.graphics.getWidth() - 450, 110)
        love.graphics.print("Def: "..self.def, love.graphics.getWidth() - 450, 130)
    end

    --UNIT HOVER
    local mx, my = love.mouse.getPosition()
    if mx >= (self.x - 1) * 24 + 48 and mx <= (self.x - 1) * 24 + 72 and
    my >= (self.y - 1) * 24 + 48 and my <= (self.y - 1) * 24 + 72 then
        love.graphics.print(self.team.." "..self.unitType, love.graphics.getWidth() - 250, 50)
        love.graphics.print("HP: "..self.hp, love.graphics.getWidth() - 250, 70)
        love.graphics.print("MP: "..self.mp, love.graphics.getWidth() - 250, 90)
        love.graphics.print("Att: "..self.att, love.graphics.getWidth() - 250, 110)
        love.graphics.print("Def: "..self.def, love.graphics.getWidth() - 250, 130)
    end
end

function unit:mousepressed(x,y,b)
    if b == 1 then
        if self.state == "idle" and not activeUnit then
            if x >= (self.x - 1) * 24 + 48 and x <= (self.x - 1) * 24 + 72 and y >= (self.y - 1) * 24 + 48 and y <= (self.y - 1) * 24 + 72 then
                self.state = "selected"
            end
        --elseif self.state == "selected" then
            --choose to hold, move or resupply
        elseif self.state == "has moved" then
            print(self.state) --choose (if not resupplied) to attack, bombard (hold only?), wait, load or unload
        elseif self.state == "finished" then
            print(self.state)
        else
            self.state = "idle"
        end
    end
end

function unit:keypressed(k)
    --h = hold, m = move, r = resupply
    --a = attack, b = bombard, w = wait, l = load, u = unload
    if k == "w" or "h" then
        if self.state == "selected" then
            self.state = "has moved"
            activeUnit = true
        elseif self.state == "has moved" then
            self.state = "finished"
            activeUnit = false
        end
    end
end

return unit
