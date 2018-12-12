function getDistance(first,secound)
	if isElement(first) and isElement(secound) then
		local x,y,z = getElementPosition(first)
		local xa,ya,za = getElementPosition(secound)
		local distance = getDistanceBetweenPoints3D(x,y,z,xa,ya,za)
		return distance-20 -- If they are in the right position it returns 0.
	else
		return 0
	end
end
-- Allows script to get distance between two carts

function getTrack(Cart)
	local Track,SubSet = unpack(Assigned[Cart])
	if SubSet > (#Tracks[Track])-2 then
		Assigned[Cart] = {Track,2}
	else
		Assigned[Cart] = {Track,SubSet+1}
	end
end
-- Gets next track

function GetRotation2 (x1,y1,z1,x2,y2,z2)
	local rotz = 6.2831853071796 - math.atan2 ( ( x2 - x1 ), ( y2 - y1 ) ) % 6.2831853071796
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2, y2, x1, y1 ) )
	rotx = -math.deg(rotx)
	rotz = (math.deg(rotz)+180)
	return rotx,0,rotz
end
-- Rotation finder, gets the x,y,z rotation

function OpenDoors(Track)
	for i=1,Count do
		setElementAttachedOffsets(Trains[Track]['Doors'][i][1],0,-1,0)
		setElementAttachedOffsets(Trains[Track]['Doors'][i][2],0,2,0)
	end
end
-- Open Train Doors

function CloseDoors(Track)
	for i=1,Count do
		setElementAttachedOffsets(Trains[Track]['Doors'][i][1],0,0,0)
		setElementAttachedOffsets(Trains[Track]['Doors'][i][2],0,0.8,0)
	end
end
-- Close Train Doors

function getClosest(player)
	local x,y,z = getElementPosition(player)
	distanceA = 100
	closest = 0
	for i,v in pairs(Tracks1) do
		local xa,ya,za = v[1],v[2],v[3]
		local distance = getDistanceBetweenPoints3D(xa,ya,za,x,y,z)
		if distance < distanceA then
			distance = distanceA
			closest = i
		end
	end
	outputChatBox(closest)
end

addCommandHandler("Closest",getClosest)
-- Get Closest track, for adding train stations

function openOrCloseDoors(Train,Open)
	if Open then
		OpenDoors(Train)
	else
		CloseDoors(Train)
	end
end
addEvent( "openOrCloseTheDoors", true )
addEventHandler( "openOrCloseTheDoors",root, openOrCloseDoors )
-- Open or close doors client side thing
