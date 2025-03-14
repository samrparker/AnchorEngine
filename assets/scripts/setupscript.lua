
ECS = {}
ECS._nextEntityID = 1
ECS.Components = {}
ECS.Components.position = {}

setmetatable( ECS.Components, { __index = function( table, key )
    table[key] = {}
    return table[key]
    end } )


function ECS.CreateEntity()
    ECS._nextEntityID = ECS._nextEntityID + 1
	return ECS._nextEntityID - 1
end

x = ECS.CreateEntity()
    
ECS.Components.position[x] = { x = 10, y = 10 }


AddSprite("Blue pig", "assets/images/Blue Pig.png", 0.0, 0.0)
AddSprite("Button1", "assets/images/Button1.png", 0.0, 250.0)
AddScript("GameLoopScript", "assets/scripts/gameloop.lua")
AddSound("RICK", "assets/sounds/RICKROLL.MP3")


function ECS.GetComponents( name )
    if ECS.Components[name] == nil then
        ECS.Components[name] = {}
    end
    return ECS.Components[name]
end

function ECS.DestroyEntity( e )
    for key, value in pairs( ECS.Components ) do
        value[e] = nil
    end
end