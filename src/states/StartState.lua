
StartState = Class{__includes = BaseState}

function StartState:init()

    self.highlighted = 1

    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    self.letterTable = {
        {'M',-108},
        {'A',-64},
        {'T',-28},
        {'C',2},
        {'H',40},
        {'3',112}
    }

    
    --cycling colors
    local temp = 0
    self.colorTimer = Timer.every(0.1, function ()

        temp = self.colors[6]

        for i = 6, 1, -1 do
            if i > 1 then
                self.colors[i] = self.colors[i-1]
            elseif i == 1 then
                self.colors[i] = temp
            end
        end        
    end)

    self.tiles = {}
    self.transitionAlpha = 0
    self.pauseInput = false --used to let the transition complete effectively thrn state is changed

    for i = 1, 64 do
        table.insert(self.tiles, gFrames['tiles'][math.random(18)][math.random(6)])
    end
end

function StartState:update(dt)
    
    if not self.pauseInput then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.highlighted == 1 then
                --animate for 1 second if start game option chosen
                Timer.tween(1, {
                    [self] = {transitionAlpha = 255/255}
                }):finish(function ()
                    gStateMachine:change('begin-game',{
                        level = 1
                    })
    
                    --since Timer is global object and they exist indefinitely and we wanna not keep running it once this state is over
                    self.colorTimer:remove()
                end)
            else
                love.event.quit()
            end
            self.pauseInput = true
        end

        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.highlighted = self.highlighted == 1 and 2 or 1
            gSounds['select']:play()
        end
    end

    Timer.update(dt)
end

function StartState:render()
    for y1 = 1, 8 do
        for x1 = 1, 8 do
            --shadow for each brick
            love.graphics.setColor(0, 0, 0, 200/255)
            love.graphics.draw(gTextures['tilesprite'], self.tiles[(y1-1)*x1 + x1], (x1-1)*32 + 128 + 3, (y1-1)*32 + 16)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(gTextures['tilesprite'], self.tiles[(y1-1)*x1 + x1], (x1-1)*32 + 128, (y1-1)*32 + 16)
        end
    end

    love.graphics.setColor(0, 0, 0, 90/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawGameText(-60)
    self:options(12)

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawGameText(y)
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    love.graphics.setFont(gFonts['large'])
    self:drawShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y, VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

function StartState:options(y)
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2- 76, VIRTUAL_HEIGHT / 2 + y, 150 , 58, 6) 

    love.graphics.setFont(gFonts['medium'])
    self:drawShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
    
    if self.highlighted == 1 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130, 1)
    end
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    self:drawShadow('Quit', VIRTUAL_HEIGHT / 2 + y + 33)
    
    if self.highlighted == 2 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130, 1)
    end
    love.graphics.printf('Quit', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end

function StartState:drawShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0.5, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
end