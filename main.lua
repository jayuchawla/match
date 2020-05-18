require 'src/Dependencies'
require 'src/constants'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Match 3')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
        vsync = true
    })
    math.randomseed(os.time())

    
    gStateMachine:change('start')
    backgroundX = 0

    
    --we want to access key presses from each state hence we have to write
    --love.keypressed in each state to avoid this we create a table which is globally accessible
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    if backgroundX <= -1024 + VIRTUAL_WIDTH + 47 then
        backgroundX = 0
    end

    gSounds['music']:setLooping(true)
    gSounds['music']:play()
    

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(gTextures['background'], backgroundX, -17)
    gStateMachine:render()
    push:finish()
end