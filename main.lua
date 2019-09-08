
-- Just test to print to the graphics window and the terminal
tmp = 1
function love.draw()
    love.graphics.print("Testing install", 400, 300)
    if tmp == 1 then
        print("Testing debug console")
        tmp = tmp +  1
    end
end