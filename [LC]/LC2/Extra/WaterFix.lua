
WaterHidden = false

function HideWater()
	for i,v in pairs(getElementsByType('water')) do
		local x,y,z = getElementPosition(v)
		setElementPosition(v,x,y,z-50)
	end
end

function ShowWater()
	for i,v in pairs(getElementsByType('water')) do
		local x,y,z = getElementPosition(v)
		setElementPosition(v,x,y,z+50)
	end
end

function count (text, search)
	if ( not text or not search ) then return false end

	return select ( 2, text:gsub ( search, "" ) );
end

function tunel(Element)
	if Element then
		if count(getElementID(Element),'tun') then
			return true
		end
	end
end


function clientRender()
	local x,y,z = getElementPosition(localPlayer)
	if z < 1 then
		local hit,x,y,z,hitele = processLineOfSight(x,y,z+5,x,y,z-5,true,false,false)

		if tunel(hitele) then
			if not WaterHidden then
				WaterHidden = true
				HideWater()
			end
		else
			if WaterHidden then
				WaterHidden = nil
				ShowWater()
			end
		end
	else
		if WaterHidden then
			WaterHidden = nil
			ShowWater()
		end
	end
end

setTimer ( clientRender, 2000, 0 )
