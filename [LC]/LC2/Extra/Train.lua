Trains = {}
Assigned = {}
Count = 4 -- How long are the trains?

function runTrain()
	for iA,vA in pairs(Tracks) do
		Trains[iA] = {}
		Trains[iA]['Power'] = 200 -- Default Speed
		Trains[iA]['Trains'] = {} -- Trains Table
		Trains[iA]['Doors'] = {} -- Doors Table
		Trains[iA]['Timer'] = {} -- Timers
		Trains[iA]['Track'] = {} 
		for i,v in pairs(vA) do
			if v[4] == 1 then
				local blip = createBlip(v[1],v[2],v[3],33) -- Mark Stations
			end
		end
		CreateCarts(iA)
	end
	setTimer ( updateClient, 1000, 0)
end


function Speedtest(_,_,Train,Speed)
	if Trains[tonumber(Train)] then
		Trains[tonumber(Train)]['Power'] = Speed -- Set the Speed
		outputChatBox("Setting speed for train# "..Train.." At "..Speed)
	end
end
addCommandHandler("Speed",Speedtest) -- Stynax , /Speed Train# Speed


function CreateCarts(TrackNumber)
	for i=1,Count do
		if Trains[TrackNumber]['Trains'][i-1]  then
			local x,y,z = getElementOffset(Trains[TrackNumber]['Trains'][i-1],0,22,0)
			Trains[TrackNumber]['Trains'][i] = exports['MTA-Stream']:streamObject('tram',x,y,z,0,0,0) -- Create cart at track subset.
		else
			local x,y,z = unpack(Tracks[TrackNumber][1])
			Trains[TrackNumber]['Trains'][i] = exports['MTA-Stream']:streamObject('tram',x,y,z,0,0,0) -- Create cart at track subset.
		end
		
		Trains[TrackNumber]['Doors'][i] = {}
		Trains[TrackNumber]['Doors'][i][1] = exports['MTA-Stream']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #1
		Trains[TrackNumber]['Doors'][i][2] = exports['MTA-Stream']:streamObject('tramd',x,y,z,0,0,0) -- Create Door #2
		local Cart = Trains[TrackNumber]['Trains'][i]
		Assigned[Cart] = {TrackNumber,i} -- Defines which track the cart is on, and which subsection.
		attachElements(Trains[TrackNumber]['Doors'][i][1],Cart,0,0,0)	-- Attach Door #1
		attachElements(Trains[TrackNumber]['Doors'][i][2],Cart,0,0.8,0)	-- Attach Door #2
		createBlipAttachedTo(Cart,56) -- Attach Blip to cart
		
		setTimer(timer,500,1,Cart,i)
	end
end

function Fix(RotationA,RotationB)
	local fix = RotationA-RotationB
	if fix > 300 then
		local fix = fix-360
		return fix
	elseif fix < -300 then
		local fix = fix+360
		return fix
	else
		return fix
	end
end

function updateClient()
	for i = 1,#Tracks do
		for ia = 2,Count do
			local cart = Trains[i]['Trains'][(ia)]
			local lead = Trains[i]['Trains'][(ia-1)]
			if isElement(cart) and isElement(lead) then
				triggerClientEvent ( root, "trainRotation", root,cart,lead )
				triggerClientEvent ( root, "prepLods", root, lead,Trains[i]['Doors'][ia][1],Trains[i]['Doors'][ia][2] )
				triggerClientEvent ( root, "prepLods", root, cart,Trains[i]['Doors'][ia][1],Trains[i]['Doors'][ia][2] )
			else
				print(i,ia)
			end
		end
	end
end

function timer(Cart,CartID)
	local Track = unpack(Assigned[Cart])
	
	local Speed = Trains[Track]['Power']

	getTrack(Cart) -- Define the carts track
	local Track,SubSet = unpack(Assigned[Cart])

	local TheTrack = Tracks[Track][SubSet]

	local CartX,CartY,CartZ = getElementPosition(Cart)
	local TrackX,TrackY,TrackZ = TheTrack[1],TheTrack[2],TheTrack[3]
	local Distance = getDistanceBetweenPoints3D (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Distance

	local PreviousTrain = Trains[Track]['Trains'][CartID-1]
	if PreviousTrain then
		CartDistance = getDistance(Cart,PreviousTrain)*25
	else
		CartDistance = 0
	end
	
	local CartSpeed = math.max((Distance*Speed)+CartDistance,50) -- Ensures that it doesn't go below 50
	
	if (CartID > 1) then
		moveObject (Cart,CartSpeed,TheTrack[1],TheTrack[2],TheTrack[3])
	else
		local xr,yr,zr = getElementRotation(Cart)
		local Xr,Yr,Zr = GetRotation2 (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Rotation
		local Xr = -Fix(xr,Xr)
		local Yr = -Fix(yr,Yr)
		local Zr = -Fix(zr,Zr)
		moveObject (Cart,CartSpeed,TheTrack[1],TheTrack[2],TheTrack[3],Xr,Yr,Zr)
	end
	
	Trains[Track]['Timer'][CartID] = setTimer (timer,CartSpeed-5, 1,Cart,CartID)

	if TheTrack[4] == 1 and CartID == 1 then -- If it's a station, and this is the 3rd cart stop the train
		for i=1,Count do
			stopObject(Trains[Track]['Trains'][i])
			killTimer(Trains[Track]['Timer'][i])
			setTimer ( timer, 30000, 1,Trains[Track]['Trains'][i],i)
		end

		OpenDoors(Track)
		setTimer ( CloseDoors, 28000, 1,Track)
	end
end


function getClosestTrain(player)
	Distance = 50
	Assigned2 = 0
	for i,v in pairs(Tracks[1]) do
		local x,y,z = v[1],v[2],v[3]
		local xa,ya,za = getElementPosition(player)
		local distance = getDistanceBetweenPoints3D ( x,y,z,xa,ya,za)
		if distance < Distance then
			Distance = distance
			Assigned2 = i
		end
	end
	print(Assigned2)
end

addCommandHandler ( "getTrainStation", getClosestTrain )

setTimer ( runTrain, 15000, 1)
