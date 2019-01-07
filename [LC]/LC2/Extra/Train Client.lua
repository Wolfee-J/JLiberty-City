functions = {}
rotationT = {}


functions.getRotation3D = function( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

functions.getElementOffset = function(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

functions.prepLODs = function(cart,door1,door2)
	local lod = getLowLODElement(cart)
	attachElements(lod,cart)
	local lod = getLowLODElement(door1)
	attachElements(lod,door1)
	local lod = getLowLODElement(door2)
	attachElements(lod,door2)
end
addEvent( "prepLods", true )
addEventHandler( "prepLods", root, functions.prepLODs )


functions.rotation = function(cart,lead)
	rotationT[cart] = {cart,lead}
end

addEvent( "trainRotation", true )
addEventHandler( "trainRotation", root, functions.rotation )

functions.rotateCarts = function ()
	for i,v in pairs(rotationT) do
		local x,y,z =  getElementPosition(v[1])
		local xa,ya,za = functions.getElementOffset(v[2],0,-9,0)
		local xr,yr,zr = functions.getRotation3D(x,y,z,xa,ya,za)
		setElementRotation(v[1],xr,yr,zr)
	end
end
addEventHandler ( "onClientRender", root, functions.rotateCarts )


