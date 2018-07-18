Trains = {}
Assigned = {}
Count = 4 -- How long are the trains?

function Run()
for iA,vA in pairs(Tracks) do
Trains[iA] = {}
Trains[iA]['Power'] = 150 -- Default Speed
Trains[iA]['Trains'] = {} -- Trains Table
Trains[iA]['Doors'] = {} -- Doors Table
Trains[iA]['Timer'] = {} -- Timers
Trains[iA]['Track'] = {} -- Timers
for i,v in pairs(vA) do
if v[4] == 1 then
local blip = createBlip(v[1],v[2],v[3],33) -- Mark Stations
end
end
CreateCarts(iA)
end
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
local x,y,z = unpack(Tracks[TrackNumber][i])
Trains[TrackNumber]['Trains'][i] = exports.JStreamer3:JcreateObject('tram',x,y,z,0,0,0) -- Create cart at track subset.
Trains[TrackNumber]['Doors'][i] = {}
Trains[TrackNumber]['Doors'][i][1] = exports.JStreamer3:JcreateObject('tramd',x,y,z,0,0,0) -- Create Door #1
Trains[TrackNumber]['Doors'][i][2] = exports.JStreamer3:JcreateObject('tramd',x,y,z,0,0,0) -- Create Door #2
local Cart = Trains[TrackNumber]['Trains'][i] 
Assigned[Cart] = {TrackNumber,i} -- Defines which track the cart is on, and which subsection.
attachElements(Trains[TrackNumber]['Doors'][i][1],Cart,0,0,0)  -- Attach Door #1
attachElements(Trains[TrackNumber]['Doors'][i][2],Cart,0,0.8,0)  -- Attach Door #2
createBlipAttachedTo(Cart,56) -- Attach Blip to cart
setElementDoubleSided(Cart,true)
timer(Cart,i)
end
end

function Fix(RotationA,RotationB)
local fix = RotationA-RotationB
if RotationA > 300 or RotationB > 300 then
local fix = fix-360
return fix
else
return fix
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



function timer(Cart,CartID)
local Track = unpack(Assigned[Cart])

local Speed = Trains[Track]['Power']

getTrack(Cart) -- Define the carts track
local Track,SubSet = unpack(Assigned[Cart])

local TheTrack = Tracks[Track][SubSet]

local CartX,CartY,CartZ = getElementPosition(Cart)
local TrackX,TrackY,TrackZ = TheTrack[1],TheTrack[2],TheTrack[3]
local Distance = getDistanceBetweenPoints3D (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Distance
local xr,yr,zr = getElementRotation(Cart)
local Xr,Yr,Zr = GetRotation2 (CartX,CartY,CartZ,TrackX,TrackY,TrackZ) -- Grab Rotation
local Xr = -Fix(xr,Xr)
local Yr = -Fix(yr,Yr)
local Zr = -Fix(zr,Zr)


local PreviousTrain = Trains[Track]['Trains'][CartID+1]
local CartDistance = -getDistance(Cart,PreviousTrain)*10

local CartSpeed = math.max((Distance*(Speed/1.5))+CartDistance,55) -- Ensures that it doesn't go below 50

moveObject (Cart,CartSpeed,TheTrack[1],TheTrack[2],TheTrack[3], Xr,Yr,Zr)
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

Run ()

