local object = {}
object.__index = object

function object:new()
    local obj = {

    }
    setmetatable(obj, self)
    return obj
end

function object:update(dt)

end

function object:draw()

end

function object:mousepressed(x,y,b)

end

function object:mousereleased(x,y,b)

end

function object:keypressed(k)

end

function object:keyreleased(k)

end

return object