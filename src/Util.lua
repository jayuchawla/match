function GenerateQuads(atlas, tile_width, tile_height)
    
    --local cols = atlas:getWidth() / tile_width
    --local rows = atlas:getHeight() / tile_height

    local sheetCounter = 1
    local spriteSheet = {}
    local x = 0
    local y = 0

    for row = 1, 9 do
        for i = 1, 2 do
            spriteSheet[sheetCounter] = {}
            for col = 1, 6 do
                table.insert(spriteSheet[sheetCounter], love.graphics.newQuad(x, y, 32, 32, atlas:getDimensions()))
                x = x + 32
            end
            sheetCounter = sheetCounter + 1
        end
        y = y + 32
        x = 0
    end
    return spriteSheet
end