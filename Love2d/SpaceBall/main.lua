
require("playerone")
require("playertwo")
require("playerai")
require("ball")
require("states/game")

local STI = require("sti")
local gameState = ""

BUTTON_HEIGHT = 64

local
function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

local buttons = {}
local font = nil


function love.load()
    font = love.graphics.newFont(32)
        table.insert(buttons, newButton(
            "OnePlayer",
                function ()
                    if gameState == "MainMenu" then
                        gameState = "OnePlayer"
                        Music2.music:stop()
                    end
                end))

        table.insert(buttons, newButton(
            "TwoPlayer",
                function ()
                    if gameState == "MainMenu" then
                        gameState = "TwoPlayer"
                        Music2.music:stop()
                    end
                end))

        table.insert(buttons, newButton(
            "Controls",
                function ()
                    if gameState == "MainMenu" then
                        gameState = "Controls"
                    end
                end))

        table.insert(buttons, newButton(
        "Exit",
            function ()
                love.event.quit(0)
            end))

    GamePause = true
    Map = STI ("map/1.lua")
    MapMenu = STI ("map/2.lua")

    Game = Game()
        Player1:load()
        Player2:load()
        Ball:load()
        AI:load()

    Sounds = {}
        Sounds.crash = love.audio.newSource("Sounds/crash.mp3", "static")
        Sounds.YouLose = love.audio.newSource("Sounds/YouLose.mp3", "stream")
        Sounds.YouLose:setLooping(false)
        Sounds.No = love.audio.newSource("Sounds/No.mp3", "static")

    Music1 = {}
        Music1.music = love.audio.newSource("Sounds/computerWorld.mp3", "stream")
        Music1.music:setLooping(true)
        Music1.music:stop()

    Music2 = {}
        Music2.music = love.audio.newSource("Sounds/Boomerang.mp3", "stream")
        Music2.music:setLooping(true)
        Music2.music:play()


    Score = {}
        ScoreA = 0
        ScoreB = 0

    gameState = "MainMenu"

end

love.keypressed = function(key)
    if Game.state.OnePlayer or Game.state.TwoPlayer then
        -- Sound Off --
        if key == "z" then
            Music1.music:stop()
        end
        -- Sound On --
        if key == "x" then
            Music1.music:play()
        end
        -- Play --
        -- if key == "space" then
        --     GamePause = false
        -- end
        -- Pause --
        if key == "p" then
            GamePause = true
        end
        -- Escape to MainMenu --
        if key == "escape" then
            if gameState == "OnePlayer" then
            gameState = "MainMenu"
                if gameState == "MainMenu" then
                    GamePause = true
                    Music1.music:stop()
                    Music2.music:play()
                end
            end
        end

        if key == "escape" then
            if gameState == "TwoPlayer" then
            gameState = "MainMenu"
                if gameState == "MainMenu" then
                    GamePause = true
                    Music1.music:stop()
                    Music2.music:play()
                end
            end
        end
    end


    if Game.state.Controls then
        -- Sound Off --
        if key == "z" then
            Music1.music:stop()
        end
        -- Sound On --
        if key == "x" then
            Music1.music:play()
        end
        -- Play --
        if key == "space" then
            GamePause = false
            if state == MainMenu then
                Music1.music:stop()
            elseif state == OnePlayer then
                Music1.music:play()
            end
                Music1.music:play()
        end
        -- Pause --
        if key == "p" then
            GamePause = true
        end
        -- Escape to MainMenu --
        if key == "escape" then
            ScoreA = 0
            ScoreB = 0
            if gameState == "Controls" then
            gameState = "MainMenu"
            end
        end
    end
end

-- Game Update --
function love.update(dt)
    if Game.state.OnePlayer then
        if GamePause == false then
            if  gameState == "OnePlayer" then
                Player1:update(dt)
                AI:update(dt)
                Ball:update(dt)
                Ball:collideAI()
            end
        end
    end

    if Game.state.TwoPlayer then
        if GamePause == false then
            if  gameState == "TwoPlayer" then
                Player1:update(dt)
                Player2:update(dt)
                Ball:update(dt)
                Ball:collidePlayer2()
            end
        end
    end
end



-- Check Collision Parameters --

function CheckCollision(ball, player) 
    if  ball.x + ball.width > player.x and
        ball.x < player.x + player.width and
        ball.y + ball.height > player.y and
        ball.y < player.y + player.height then
        return true

    elseif  ball.x - ball.width < player.x and
    ball.x > player.x - player.width and
    ball.y - ball.height < player.y and
    ball.y > player.y - player.height then
        return true

    else
        return false
    end
end

function love.draw()
    if gameState == "MainMenu" then
            love.graphics.setColor(1, 1, 1)
            MapMenu:draw(0, 0, 1.35, 1.6)
            love.graphics.setColor(1, 1, 1)
            local ww = love.graphics.getWidth()
            local wh = love.graphics.getHeight()
            local button_width = ww * (1/3)
            local margin = 16
            local total_height = (BUTTON_HEIGHT - margin) * #buttons
            local cursor_y = 0
            love.graphics.setColor(1, 1, 1)
            love.graphics.print( "Game Menu",400 , 150, 0, 4.1)
            love.graphics.setColor(0, 0, 1)
            love.graphics.print( "Game Menu",403 , 150, 0, 4)

        for i, button in ipairs(buttons) do
            button.last = button.now

            local bx = (ww / 2) - (button_width / 2)
            local by = (wh / 2) - (total_height / 2) + cursor_y
            local color = {0.4, 0.4, 0.5, 1.0}
            local mx, my = love.mouse.getPosition()
            local hot = mx > bx and mx < bx + button_width and
                        my > by and my < by + BUTTON_HEIGHT

            if hot then
                color = {0.8, 0.8, 0.9, 1.0}
            end

            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot then
                button.fn()
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill",bx , by, button_width, BUTTON_HEIGHT)

                love.graphics.setColor(0, 0, 0, 1)

                local textW = font:getWidth(button.text)
                local textH = font:getHeight(button.text)

                love.graphics.print(
                    button.text,
                    font,
                    (ww / 2) - textW / 2,
                    by + textH / 2

                )
                cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
               
        end

    end


    if gameState == "OnePlayer" then
        Map:draw(0, 0, 1.5, 1.2)
        -- Game Name Displayed
        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Space Ball", love.graphics.getWidth() / 2.6 , 0, 0, 4.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Space Ball", love.graphics.getWidth() / 2.6 , 0, 0, 4)

        --  Player 1 Score Board
        love.graphics.setColor(0, 0.8, 0)
        love.graphics.print( "Player 1", 0, 0, 0, 2)

        love.graphics.setColor(0.3, 0.7, 0.7)
        love.graphics.print( "Score", 0, 50, 0, 2)

        love.graphics.print(ScoreA, 100, 50, 0, 2)

        -- Player 2 Score Board
        love.graphics.setColor(0, 0.8, 0)
        love.graphics.print( "Computer", love.graphics.getWidth() -160, 0, 0, 2)

        love.graphics.setColor(0.3, 0.7, 0.7)
        love.graphics.print( "Score", love.graphics.getWidth() -160, 50, 0, 2)

        love.graphics.print(ScoreB, love.graphics.getWidth() -50,  50, 0, 2)
        
        if ScoreA == 15 then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print( "You Win !!!!", love.graphics.getWidth() / 2.3, 250, 0, 2.5)
            love.graphics.setColor(1, 0, 0)
            love.graphics.print( "Computer Lose !!!!", love.graphics.getWidth() / 2.5, 300, 0, 2)
            Music1.music:stop()
            

        elseif ScoreB == 15 then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print( "Computer Win !!!!", love.graphics.getWidth() / 2.55, 300, 0, 2.5)
            love.graphics.setColor(1, 0, 0)
            love.graphics.print( "You Lose !!!!", love.graphics.getWidth() / 2.25, 250, 0, 2)
            Music1.music:stop()
        end

        if GamePause == true then
            love.graphics.setColor(0.3, 0.7, 0.7)
            love.graphics.print( "Press Spacebar to Start", love.graphics.getWidth() / 2.6, 400, 0, 2)
            love.graphics.print( "Press Esc to Exit", love.graphics.getWidth() / 2.3, 450, 0, 2)
        end
        if Score == 0 then
           Music1.music:play()
        end

        function Ball:collideAI()
            if CheckCollision(self, AI) then
                self.xVel = -self.speed
                local middleBall = self.y + self.height / 2
                local middleAI = AI.y + AI.height / 2
                local collisionPosition = middleBall + middleAI
                self.yVel = collisionPosition / 5
            end
        end
            
        Player1:draw()
        AI:draw()
        Ball:draw()
    end

    if gameState == "TwoPlayer" then
        Map:draw(0, 0, 1.5, 1.2)
        -- Game Name Displayed
        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Space Ball", love.graphics.getWidth() / 2.6 , 0, 0, 4.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Space Ball", love.graphics.getWidth() / 2.6 , 0, 0, 4) 

        --  Player 1 Score Board
        love.graphics.setColor(0, 0.8, 0)
        love.graphics.print( "Player 1", 0, 0, 0, 2)

        love.graphics.setColor(0.3, 0.7, 0.7)
        love.graphics.print( "Score", 0, 50, 0, 2)
        
        love.graphics.print(ScoreA, 100, 50, 0, 2)

        -- Player 2 Score Board
        love.graphics.setColor(0, 0.8, 0)
        love.graphics.print( "Player 2", love.graphics.getWidth() -160, 0, 0, 2)

        love.graphics.setColor(0.3, 0.7, 0.7)
        love.graphics.print( "Score", love.graphics.getWidth() -160, 50, 0, 2)

        love.graphics.print(ScoreB, love.graphics.getWidth() -50,  50, 0, 2)
        
        if ScoreA == 15 then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print( "Player One Win !!", love.graphics.getWidth() / 2.4, 300, 0, 2)
            Music1.music:stop()
        
        
        elseif ScoreB == 15 then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print( "Player Two Win !!", love.graphics.getWidth() / 2.4, 300, 0, 2)
            Music1.music:stop()
        end

        if GamePause == true then
            love.graphics.setColor(0.3, 0.7, 0.7)
            love.graphics.print( "Press Spacebar to Start", love.graphics.getWidth() / 2.6, 400, 0, 2)
            love.graphics.print( "Press Esc to Exit", love.graphics.getWidth() / 2.3, 450, 0, 2)
        end
        if GamePause == false then
            Music1.music:play()
        end
        
        function Ball:collidePlayer2()
            if CheckCollision(self, Player2) then
                self.xVel = -self.speed
                local middleBall = self.y + self.height / 2
                local middlePlayer2 = Player2.y + Player2.height / 2
                local collisionPosition = middleBall + middlePlayer2
                self.yVel = collisionPosition / 5
            end
        end
            
        Player1:draw()
        Player2:draw()
        Ball:draw()
    end


    if gameState == "Controls" then
        love.graphics.setColor(1, 1, 1)
        MapMenu:draw(0, 0, 1.35, 1.6)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Controls",443 , 50, 0, 3.5)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Controls",446 , 50, 0, 3.6)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Player One",463 , 120, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Player One",466 , 120, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "Player 'W' to go up", 466 , 160, 0, 1.2)
        love.graphics.print( "Player 'S' to go down",457 , 180, 0, 1.2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Player Two",463 , 220, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Player Two",463 , 220, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "Player 'UP' to go up", 468 , 260, 0, 1.2)
        love.graphics.print( "Player 'down' to go down",449 , 280, 0, 1.2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "Esc",510 , 320, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "Esc",513 , 320, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "'Esc' to Exit", 489 , 355, 0, 1.2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "P",525 , 385, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "P",528 , 385, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "'P' to Pause", 494 , 420, 0, 1.2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "z",525 , 450, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "z",528 , 450, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "'z' Sound Off", 490 , 480, 0, 1.2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print( "x",525 , 500, 0, 2.1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print( "x",528 , 500, 0, 2)
        love.graphics.setColor(0.7, 0.5, 1)
        love.graphics.print( "'x' Sound On", 492 , 530, 0, 1.2)
        

       
    end
end