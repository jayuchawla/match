Tile = Class{}

function Tile:init(x, y, color, variety)
    self.gridX = x
    self.gridY = y

    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.variety = variety
end

function Tile:update(dt)
    
end

function Tile:swap(tile)
    
end

function Tile:render(x, y)
    --shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.draw(gTextures['tilesprite'], gFrames['tiles'][self.color][self.variety], self.x + x + 2, self.y + y + 2)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['tilesprite'], gFrames['tiles'][self.color][self.variety], self.x + x, self.y + y)
end