local a = ...
if KeyPressed(48) then
	print('REPRESENTINGTHEABQ, WHADUP ', a)
end

if KeyPressed(87) then
    MoveSprite("Blue pig", 0.0, 1.0)
end

if KeyPressed(83) then
    MoveSprite("Blue pig", 0.0, -1.0)
end

if KeyPressed(65) then
    MoveSprite("Blue pig", -1.0, 0.0)
end

if KeyPressed(68) then
    MoveSprite("Blue pig", 1.0, 0.0)
end