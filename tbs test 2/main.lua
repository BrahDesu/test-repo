local sti = require("libs/sti")
local map = sti("imgs/map/testmap.lua")
local unit = require("unit")

local turn = "Blue" --Blue = Player, Red = AI
local units = {}
local offset = 48

--(x,y,img,ut,team,mp,att)
table.insert(units, unit:new(5,2,love.graphics.newImage("imgs/units/blueMotorInf.png"),"Motorized Infantry","Blue",50))
table.insert(units, unit:new(4,3,love.graphics.newImage("imgs/units/blueMBT.png"),"Main Battle Tank","Blue",90))

table.insert(units, unit:new(5,3,love.graphics.newImage("imgs/units/redMechInf.png"),"Mechanized Infantry","Red",60))
table.insert(units, unit:new(8,2,love.graphics.newImage("imgs/units/redHGS.png"),"Helicopter Gunship","Red",80))

function love.load()

end

function love.update(dt)
    map:update(dt)
    for i,v in ipairs(units) do 
        v:update(dt)
    end
end

function love.draw()
    map:draw(offset, offset)
    getTileInfo()
    love.graphics.translate(offset, offset)

    for i,v in ipairs(units) do 
        v:draw()
        if v.ut == "Helicopter Gunship" then
            v.def = 1
        else
            v.def = map:getTileProperties("tile layer", v.x, v.y)["defence"]
        end
    end

    love.graphics.origin()
    local fps = love.timer.getFPS()
    love.graphics.print("Turn: "..turn, 10, love.graphics.getHeight() - 50)
    love.graphics.print("FPS: "..fps, 10, love.graphics.getHeight() - 30)
end

function love.mousepressed(x,y,b)
    for i,v in ipairs(units) do 
        if v.team == turn then
            v:mousepressed(x,y,b)
        end
    end
end

function love.keypressed(k)
    for i,v in ipairs(units) do 
        if v.team == turn then
            v:keypressed(k)
        end
    end

    --END TURN KEY
    if k == "return" then
        if turn == "Blue" then
            for i,v in ipairs(units) do 
                v.state = "idle"
                turn = "Red"
            end
        elseif turn == "Red" then
            for i,v in ipairs(units) do 
                v.state = "idle"
                turn = "Blue"
            end
        end
    end

    --QUIT
    if k == "escape" then
        love.event.quit()
    end

    --GET NEW MAP TEST
    if k == "backspace" then
        sti.call()
    end
end

function getTileInfo()
    local mouseX = love.mouse.getX() - offset
    local mouseY = love.mouse.getY() - offset
    local mx = math.floor(mouseX / 24) + 1
    local my = math.floor(mouseY / 24) + 1

    if mx > map:getLayerProperties("tile layer")["width"] then
        mx = map:getLayerProperties("tile layer")["width"]
    elseif mx < 1 then
        mx = 1
    end
    if my > map:getLayerProperties("tile layer")["height"] then
        my = map:getLayerProperties("tile layer")["height"]
    elseif my < 1 then
        my = 1
    end

    if mx >= 0 and mx <= map:getLayerProperties("tile layer")["width"] * 24 and
    my >= 0 and my <= map:getLayerProperties("tile layer")["height"] * 24 then
        love.graphics.print(map:getTileProperties("tile layer", mx, my)["name"].." "..
        map:getTileProperties("tile layer", mx, my)["defence"], 600, 10)
    else
        love.graphics.print("Out of bounds", 600, 10)
    end
end 

function damageFormula(att,attMod,attHP,def,defMod,defHP) --(Attack*Att.Modifier*Health/100)/(Terrain*Def.Modifier*Health/100)=Damage
    return (att*attMod*attHP/100)/(def*defMod*defHP/100)
end

function love.focus(f)
    if not f then
        print("LOST FOCUS")
    else
        print("GAINED FOCUS")
    end
end


