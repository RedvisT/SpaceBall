-- The Ball --

Ball = {}


function Ball:load()
    -- Ball Location --
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    -- Ball Image and Size --
    self.img = love.graphics.newImage("assets/peg.png")
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()
    -- Ball Speed --
    self.speed = 800
    self.xVel = -self.speed
    self.yVel = 0
end

-- Update Function --
function Ball:update(dt)
    self:move(dt)
    self:collide()
end

-- Collide Parameters --
function 
    Ball:collide()
    Ball:collideWall()
    Ball:collidePlayer1()
    Ball:score()
end



-- Collide Parameters --
function Ball:collideWall()
    if  self.y < 0 then
        self.y = 0
        self.yVel = -self.yVel
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
        self.yVel = -self.yVel
    end
end

-- Player 1  Parameters --
function Ball:collidePlayer1()
    if CheckCollision(self, Player1) then
        self.xVel = self.speed
        local middleBall = self.y + self.height / 2
        local middlePayer1 = Player1.y + Player1.height / 2
        local collisionPosition = middleBall - middlePayer1
        self.yVel = collisionPosition * 5
    end
end


-- Player Score Parameters --
function Ball:score()
    if ScoreB == 15 then
        ScoreB = 0
        ScoreA = 0
    end
    if ScoreA == 15 then
        ScoreA = 0
        ScoreB = 0
    end
    if self.x < 0 then
        self:resetPosition(1)
        ScoreB = ScoreB + 1
            if ScoreB == 15 then
                GamePause = true
                Sounds.YouLose:play()
            end 
        Sounds.crash:play()
    end

    -- AI Score Parameters --
    if self.x + self.width > love.graphics.getWidth() then
        self:resetPosition(-1)
        ScoreA = ScoreA + 1
            if ScoreA == 15 then
                GamePause = true
                Sounds.No:play()
            end 
        Sounds.crash:play()
    end
end


function Ball:resetPosition(modifier)
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.yVel = 0
    self.xVel = self.speed * modifier
end

-- Ball Movement --
function Ball:move(dt)
    self.x = self.x + self.xVel * dt
    self.y = self.y + self.yVel * dt
end


-- Ball View Create --
function Ball:draw()
    love.graphics.draw(self.img, self.x, self.y)
end



