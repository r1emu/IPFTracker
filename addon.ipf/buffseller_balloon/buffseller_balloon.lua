
function BUFFSELLER_BALLOON_ON_INIT(addon, frame)

	
end

function AUTOSELLER_BALLOON(title, sellType, handle, skillID)
	if title == "" then
		if AUTO_SELL_BUFF == sellType then
			local frame = ui.GetFrame("buffseller_target");
			local ownerHandle = frame:GetUserIValue("HANDLE");
			if ownerHandle == handle then
				ui.CloseFrame("buffseller_target");
			end
		elseif  sellType == AUTO_SELL_PERSONAL_SHOP then
			local frame = ui.GetFrame("personal_shop_register");
			local ownerHandle = frame:GetUserIValue("HANDLE");
			if ownerHandle == handle then
				ui.CloseFrame("personal_shop_register");
			end
		elseif sellType == AUTO_TITLE_FOOD_TABLE then
		else
			CLOSE_SQUIRE_STORE(handle, skillID);
		end

		ui.DestroyFrame("SELL_BALLOON_" .. handle);
		CLOSE_SQUIRE_STORE(handle, skillID);
		return;
	end

	local frame = ui.CreateNewFrame("buffseller_balloon", "SELL_BALLOON_" .. handle);
	if frame == nil then
		return nil;
	end

	frame:SetUserValue("SELL_TYPE", sellType);
	frame:SetUserValue("HANDLE", handle);
	local text = frame:GetChild("text");
	text:SetTextByKey("value", title);
	frame:ShowWindow(1);

	local offsetY = - 30;
	if sellType == AUTO_TITLE_FOOD_TABLE then
		offsetY = - 150;
	end

	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, offsetY, 3, 1);
end

function BUFFSELLER_OPEN(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local sellType = frame:GetUserIValue("SELL_TYPE");
	local handle = parent:GetUserIValue("HANDLE");

	if sellType == AUTO_TITLE_FOOD_TABLE then
		local frame = ui.GetFrame("foodtable_ui");
		session.camp.RequestOpenFoodTable(handle);
	else
	session.autoSeller.RequestOpenShop(handle, sellType);
end
end

function CLOSE_SQUIRE_STORE(handle, skillID)
	if 0 == skillID then		
		return;
	end

	local skillName = GetClassByType("Skill", skillID).ClassName;
	 -- GetUserIValue �� string, GetUserIValue inter!

	if "Squire_Repair" == skillName then
		local repair = ui.GetFrame("itembuffrepair");
		local re_handle = repair:GetUserIValue("HANDLE");
		if  handle == re_handle then
			ui.CloseFrame("itembuffrepair");
		end
	elseif "Squire_WeaponTouchUp" == skillName or "Squire_ArmorTouchUp" == skillName then
		local mending = ui.GetFrame("itembuffopen");
		local mend_handle = mending:GetUserIValue("HANDLE");
		if handle == mend_handle then
			ui.CloseFrame("itembuffopen");
		end
		packet.StopTimeAction(1);

	elseif "Alchemist_Roasting" == skillName then
		local mending = ui.GetFrame("itembuffgemroasting");
		local mend_handle = mending:GetUserIValue("HANDLE");
		if handle == mend_handle then
				ui.CloseFrame("itembuffgemroasting");
		end
	end
		
en