

Player1 = {}

function Player1:load()
    self.x = 50
    self.y = love.graphics.getHeight() / 2
    self.img = love.graphics.newImage("assets/slideL.png")
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()
    self.speed = 500
end

function Player1:update(dt)
    self:move(dt)
    self:CheckBoundaries()
end

function Player1:move(dt)
    if  love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
end

function Player1:CheckBoundaries()
    if  self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
end


function Player1:draw()
    love.graphics.setColor(1, 3.5, 1)
    love.graphics.draw(self.img, self.x, self.y)
end



