MAX_RESTSLOT_CNT = 20;

function RESTQUICKSLOT_ON_INIT(addon, frame)

	for i = 0, MAX_RESTSLOT_CNT-1 do
		local slot 			= frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString 	= 'QuickSlotExecute'..(i+1);
		local text 			= hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
	end

	addon:RegisterMsg('RESTQUICKSLOT_OPEN', 'ON_RESTQUICKSLOT_OPEN');
	addon:RegisterMsg('RESTQUICKSLOT_CLOSE', 'ON_RESTQUICKSLOT_CLOSE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_REMOVE', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
end

function RESTQUICKSLOT_ON_ITEM_CHANGE(frame)
	-- �켱 ���� ������Ʈ �ϴ°ŷ�
	if frame:IsVisible() == 1 then
		ON_RESTQUICKSLOT_OPEN(frame);
	end
end

function ON_RESTQUICKSLOT_OPEN(frame, msg, argStr, argNum)

	local slotIndex = 1;
	local list = GetClassList('restquickslotinfo')
	for i = 0, MAX_RESTSLOT_CNT-1 do
		local cls = GetClassByIndexFromList(list, i);
		if cls ~= nil then
			if cls.VisibleScript == "None" or _G[cls.VisibleScript]() == 1 then
				if scp ~= "None" then
					local slot 			  = GET_CHILD(frame, "slot"..slotIndex, "ui::CSlot");
					if slot ~= nil then
						slot:ReleaseBlink();
						slot:ClearIcon();
						SET_REST_QUICK_SLOT(slot, cls);
						slotIndex = slotIndex + 1;
					end
				end
			end
		end
	end
	
	frame:ShowWindow(1);

	if IsJoyStickMode() == 0 then

		local quickFrame = ui.GetFrame('quickslotnexpbar')
			if quickFrame:IsVisible() == 1 then
				quickFrame:ShowWindow(0);
			end
	elseif IsJoyStickMode(pc) == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
			if joystickQuickFrame:IsVisible() == 1 then
				joystickQuickFrame:ShowWindow(0);
			end
	end
end

function QSLOT_ENABLE_ARROW_CRAFT()
	local abil = session.GetAbilityByName("Fletching")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_DIPELLER_CRAFT()
	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_VISIBLE_ARROW_CRAFT()
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType
	if pcCtrlType == "Archer" then
		return 1;
	end

	return 0;
end

function ON_RESTQUICKSLOT_CLOSE(frame, msg, argStr, argNum)

	frame:ShowWindow(0);

	if IsJoyStickMode() == 0 then
		local quickFrame = ui.GetFrame('quickslotnexpbar')
		if quickFrame:IsVisible() == 0 then
			quickFrame:ShowWindow(1);
		end
	elseif IsJoyStickMode() == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		if joystickQuickFrame:IsVisible() == 0 then
			joystickQuickFrame:ShowWindow(1);
		end
	end
	ui.CloseFrame('reinforce_by_mix')

end

function SET_REST_QUICK_SLOT(slot, cls)

	slot:SetEventScript(ui.LBUTTONUP, cls.Script);
	slot:SetUserValue("REST_TYPE", cls.ClassID);
	
	local icon 	= CreateIcon(slot);
	local desctext = cls.Desc;
	
	if desctext ~= 'None' then
		 icon:SetTextTooltip('{@st59}'..desctext);
	 end
	
	if cls.Icon ~= 'None' then
		icon:SetImage(cls.Icon);
	end
	slot:EnableDrag(0);
	slot:Invalidate();

	local targetItem = cls.TargetItem;
	if targetItem ~= "None" then
		local invItem = session.GetInvItemByName(targetItem);
		local itemCount = 0;
		if invItem ~= nil then
			itemCount = invItem.count;
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end

		slot:GetIcon():SetText('{s18}{ol}{b}'.. itemCount, 'count', 'right', 'bottom', -2, 1);
	end

	local enableScp = cls.EnableScript;
	if enableScp ~= "None" then
		if _G[enableScp]() == 0 then
			slot:SetEventScript(ui.LBUTTONUP, "None");
			icon:SetTextTooltip('{@st59}'..cls.DisableTooltip);
			icon:SetGrayStyle(1);
		end
	end
end

function REST_SLOT_USE(frame, slotIndex)

	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end

	local slot = GET_CHILD(frame, "slot"..slotIndex+1, "ui::CSlot");	
	local type = slot:GetUserValue("REST_TYPE");
	local cls = GetClassByType("restquickslotinfo", type);	
	local scp = _G[cls.Script];
	if scp == nil then
		print(cls.Script);
		return;
	end
	scp();
end

function REQUEST_JOURNAL_UPDATE()
	
	control.CustomCommand("REQUEST_JOURNAL_RANK_UPDATE", 0, 0);
end

function REQUEST_OPEN_JORUNAL_CRAFT()
	local frame = ui.GetFrame("itemcraft");
	if frame ~= nil then
		SET_CRAFT_IDSPACE(frame, "Recipe");
		SET_ITEM_CRAFT_UINAME("itemcraft");
		ui.OpenFrame("itemcraft");
		CRAFT_OPEN(frame);
	end
end

function OPEN_ARROW_CRAFT()
	local abil = session.GetAbilityByName("Fletching")
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		local frame = ui.GetFrame("itemcraft_fletching");
		SET_ITEM_CRAFT_UINAME("itemcraft_fletching");
		SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
		CREATE_CRAFT_ARTICLE(frame);
		ui.ToggleFrame("itemcraft_fletching");
	end

end

function OPEN_DIPELLER_CRAFT()
	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		local frame = ui.GetFrame("itemcraft_alchemist");
		SET_ITEM_CRAFT_UINAME(frame, "itemcraft_alchemist");
		SET_CRAFT_IDSPACE("Recipe_ItemCraft", obj.ClassName, obj.Level);
		CREATE_CRAFT_ARTICLE(frame);
		ui.ToggleFrame("itemcraft_alchemist");
		
	end

end

function CHECK_CAMPFIRE_ENABLE(x, y, z)

	local mon = world.GetMonsterByClassName(x, y, z, "bonfire_1", 20);
	local camfireitem = session.GetInvItemByName('misc_campfireKit');
	if mon ~= nil or camfireitem == nil then
		return 0;
	end

	return 1;
end

function REQUEST_CAMPFIRE()
local camfireitem = session.GetInvItemByName('misc_campfireKit');
	if camfireitem == nil then
		ui.AlarmMsg("NotCampfireKit");
	return
	end

item.CellSelect(30, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}");
end

function CLOSE_REST_QUICKSLOT(frame)
	item.CellSelect(0, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}");
end

function EXEC_CAMPFIRE(x, y, z)
	control.CustomCommand("PUT_CAMPFIRE", x, z);
end


function QSLOT_VISIBLE_DISPELLER_CRAFT()
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType
	if pcCtrlType == "Cleric" then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_DISPELLER_CRAFT()
	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function OPEN_DISPELLER_CRAFT()
	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		print(obj.ClassName)
		local frame = ui.GetFrame("itemcraft_alchemist");
		SET_ITEM_CRAFT_UINAME("itemcraft_alchemist");
		SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
		CREATE_CRAFT_ARTICLE(frame);
		ui.ToggleFrame("itemcraft_alchemist");
		
	end

end