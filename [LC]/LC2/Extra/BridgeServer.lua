
Bridges = {}
Original = {}
GlobalPos = {}

Bridge = {}
Bridge['bridge_lift'] = true

function getID(element)
	return getElementData(element,'id')
end

function runBridge()
	for i,v in pairs(getElementsByType('object')) do
		if Bridge[getID(v)] then
			setLowLODElement(v, createObject(getElementModel(v), 0, 0, 0, 0, 0, 0, true));
			local lowlod = getLowLODElement (v)
			attachElements(lowlod,v)
			Bridges[#Bridges+1] = v
			local x,y,z = getElementPosition(v)
			Original[v] = {x,y,z}
			GlobalPos = {x,y,z}
		end
	end
end

function moveBridgeBack(V)
	local x,y,z = unpack(Original[v] or GlobalPos)
	moveObject ( V, 5000, x,y,z )
	setTimer ( removeThem, 6000, 1)
end

function removeThem()
	triggerClientEvent ( root, "removeThem",root )
end

function moveBridge()
	for i,v in pairs(Bridges) do
		local x,y,z = unpack(Original[v] or GlobalPos)
		moveObject ( v, 5000, x,y,z+50 )
		setTimer ( moveBridgeBack, 20000, 1,v)
	end
end

function moveBridgeA()
	triggerClientEvent ( root, "createThem",root )
	setTimer ( moveBridge, 1000, 1)
end

setTimer ( moveBridgeA, 1000,1)
setTimer ( moveBridgeA, 300000, 0)

setTimer ( runBridge, 15000, 1)