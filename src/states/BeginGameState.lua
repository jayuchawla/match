BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    self.transitionAlpha = 1
    self.levelLabelY = -64
    self.board = Board(VIRTUAL_WIDTH - 272, 16)  
end

function BeginGameState:enter(params)
    self.level = params.level

    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function ()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        :finish(function ()
            Timer.after(1, function ()
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                :finish(function ()
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    self.board:render()

    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setFont(gFonts['large'])
    --shadow
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Level :: ' .. tostring(self.level), 1, self.levelLabelY + 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Level :: ' .. tostring(self.level), 0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 128/255, 128/255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end