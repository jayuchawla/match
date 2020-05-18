push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife/timer'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/BeginGameState'
require 'src/states/PlayState'
require 'src/states/GameOverState'

require 'src/StateMachine'
require 'src/Util'
require 'src/Board'
require 'src/Tile'

gStateMachine = StateMachine{
    ['start'] = function () return StartState() end,
    ['begin-game'] = function () return BeginGameState() end,
    ['play'] = function () return PlayState() end,
    ['game-over'] = function () return GameOverState() end
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['tilesprite'] = love.graphics.newImage('graphics/match3.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tilesprite'], 32, 32)
}