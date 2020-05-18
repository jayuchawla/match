local col = {
    [1] = {99/255, 155/255, 1, 1},
    [2] = {172/255, 50/255, 50/255, 1}
}

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.transitionAlpha = 255
    
    self.highlightedX = 0
    self.highlightedY = 0

    self.input = true

    self.highlightedTile = nil

    self.rectHighlighted = false

    self.score = 0
    self.timer = 60

    self.changer = 1

    Timer.every(0.5, function ()
        self.rectHighlighted = not self.rectHighlighted
    end)

    Timer.every(1, function ()
        self.timer = self.timer - 1

        if self.timer <= 10 then
            self.changer = self.changer == 1 and 2 or 1
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score or 0
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.timer <= 0 then
        Timer.clear()
        gSounds['game-over']:play()
        gStateMachine:change('game-over',{
            score = self.score
        })
    end

    if self.score >= self.scoreGoal then
        Timer.clear()
        -- always clear before you change state, else next state's timers
        -- will also clear!
        gSounds['next-level']:play()
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    if self.input then
        if love.keyboard.wasPressed('up') then
            gSounds['select']:play()
            if self.highlightedY == 0 then
                self.highlightedY = 7
            else
                self.highlightedY = math.max(0, self.highlightedY - 1)
            end
        elseif love.keyboard.wasPressed('down') then
            gSounds['select']:play()
            if self.highlightedY == 7 then
                self.highlightedY = 0
            else
                self.highlightedY = math.min(7, self.highlightedY + 1)
            end
        elseif love.keyboard.wasPressed('left') then
            gSounds['select']:play()
            if self.highlightedX == 0 then
                self.highlightedX = 7
            else
                self.highlightedX = math.max(0, self.highlightedX - 1)
            end 
        elseif love.keyboard.wasPressed('right') then
            gSounds['select']:play()
            if self.highlightedX == 7 then
                self.highlightedX = 0
            else
                self.highlightedX = math.min(7, self.highlightedX + 1)
            end
        end


        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            local x = self.highlightedX + 1
            local y = self.highlightedY + 1

            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

            elseif math.abs(x - self.highlightedTile.gridX) + math.abs(y - self.highlightedTile.gridY) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            else
                local tempX = self.highlightedTile.gridX
                local tempY = self.highlightedTile.gridY

                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] = self.highlightedTile
                self.board.tiles[newTile.gridY][newTile.gridX] = newTile

                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                })
                :finish(function ()
                    self:calculateMatches()
                end)
            end
        end
    end
    Timer.update(dt)
end

function PlayState:calculateMatches()
    self.highlightedTile = nil

    local matches = self.board:calculateMatches()

    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()

        for k, match in pairs(matches) do
            self.timer = self.timer + #match - 1
            self.score = self.score + #match * 50
        end

        self.board:removeMatches()

        local fallTiles = self.board:getFallingTiles()
        Timer.tween(0.8, fallTiles)
            :finish(function ()
                local newTiles = self.board:getNewTiles()
                Timer.tween(0.25, newTiles)
                    :finish(function ()
                        self:calculateMatches()
                    end)
            end)
    else
        self.input = true
    end
end

function PlayState:render()
    self.board:render()
    
    if self.highlightedTile then
        love.graphics.setBlendMode('add') --show brighter effect

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1)*32 + (VIRTUAL_WIDTH - 272), (self.highlightedTile.gridY - 1)*32 + 16, 32, 32, 4)
        love.graphics.setBlendMode('alpha')
    end

    if self.rectHighlighted then
        love.graphics.setColor(21/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.highlightedX * 32 + (VIRTUAL_WIDTH - 272), self.highlightedY * 32 + 16, 32, 32, 4)

    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.setColor(col[self.changer])
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end