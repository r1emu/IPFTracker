function MINIMIZED_PERSONAL_HOUSING_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('ENTER_PERSONAL_HOUSE', 'MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('SET_PERSONAL_HOUSE_NAME', 'SCR_SET_PERSONAL_HOUSE_NAME');
	
	addon:RegisterMsg('PERSONAL_HOUSING_IS_REALLY_OUT', 'SCR_PERSONAL_HOUSING_IS_REALLY_OUT');
end

function MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);

	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		frame:ShowWindow(0);
		return
	end

	local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
	if housingPlaceType ~= "Personal" then
		frame:ShowWindow(0);
		return;
	end
	
	frame:ShowWindow(1);
end

function SCR_SET_PERSONAL_HOUSE_NAME(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);

	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		return
	end

	local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
	if housingPlaceType ~= "Personal" then
		return;
	end
	
	local aidString = argStr;

	local house_name = GET_CHILD_RECURSIVELY(frame, "house_name");
	
	local partyMemberList = session.party.GetPartyMemberList(PARTY_NORMAL);
	local memberCount = partyMemberList:Count();
	for i = 0, memberCount - 1 do
		local memberInfo = partyMemberList:Element(i);
		if memberInfo ~= nil then
			if memberInfo:GetAID() == aidString then
				house_name:SetTextByKey("value", memberInfo:GetName());
				break;
			end
		end
	end
end

function SCR_PERSONAL_HOUSING_IS_REALLY_OUT(frame, msg, argstr, argnum)
    local clmsg = ScpArgMsg("ANSWER_OUT_PH_1");
	local yesscp = string.format("ON_PERSONAL_HOUSING_IS_REALLY_OUT(%d)", argnum);
	ui.MsgBox(clmsg, yesscp, 'None');
end

function ON_PERSONAL_HOUSING_IS_REALLY_OUT()
    housing.RequestLeavePersonalHouse();
end


function BTN_MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE(parent, btn)
--	housing.RequestLeavePersonalHouse();
end