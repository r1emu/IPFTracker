

function RINGCOMMAND_ON_INIT(addon, frame)
 
	addon:RegisterMsg("UNTARGET_COMPANION", "ON_UNTARGET_COMPANION");
	
end 

function ON_TARGET_COMPANION(frame, msg, str, num , obj)
	obj = tolua.cast(obj, "CFSMActor");
	SHOW_PET_RINGCOMMAND(obj);
end

function CLOSE_PET_RINGCOMMAND(obj)

	local frame = ui.GetFrame("petcommand");
	frame:ShowWindow(0);
	
end

function SHOW_PET_RINGCOMMAND(obj, frame)

	local fsmActor = GetMyActor();
	if fsmActor:GetVehicleState() == true then
		return;
	end

	--[[
	local frame = ui.GetFrame("ringcommand");
	SET_RINGCOMMAND_TYPE(frame, "COMPANION", obj:GetHandleVal());
	frame:ShowWindow(1);
	]]

	local frame = ui.GetFrame("petcommand");
	SET_PETCOMMAND_TYPE(frame, "COMPANION", obj:GetHandleVal());
	frame:ShowWindow(1);
	
end

function ON_UNTARGET_COMPANION(frame)

	frame:ShowWindow(0);

end

function INSERT_HOR_RINGCOMMAND(frame, name, img, text, toolTipText, x, y, font)
	local ctrlSet = frame:CreateControlSet('ringcmd_menu', name, ui.LEFT, ui.TOP, x, y, 0, 0);
	ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');
	local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
	pic:SetImage(img);
	local textCtrl = ctrlSet:GetChild("text");		
	textCtrl:SetTextByKey("text", text);		
	if font ~= nil then
		textCtrl:SetTextByKey("font", font);		
	end
	ctrlSet:SetTextTooltip(toolTipText);
	return ctrlSet;
end

function INSERT_RINGCOMMAND(frame, name, img, text, toolTipText, y)
	local ctrlSet = frame:CreateControlSet('ringcmd_menu', name, ui.CENTER_HORZ, ui.TOP, 0, y, 0, 0);
	ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');

	-- �ش� ��Ʈ�Ѽ� ��ư ������ �ش� ��� �����ϱ� ���ؼ� name�� �Լ��� ����� ó����..
	-- ���� ������ �ƴѵ�.. ���� ���� ������ �������� �ʾƼ�.. �������� ���� ����.
	ctrlSet:SetEventScript(ui.LBUTTONUP, name);

	local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
	pic:SetImage(img);
	local textCtrl = ctrlSet:GetChild("text");		
	textCtrl:SetTextByKey("text", text);		
	y = y + ctrlSet:GetHeight();
	ctrlSet:SetTextTooltip(toolTipText);
	return y;
end

function SET_RINGCOMMAND_TYPE(frame, typeStr, handle)
	
	frame:SetUserValue("HANDLE", handle);
	local ringCmdType = frame:GetUserValue("RINGCMD_TYPE");
	if typeStr ~= ringCmdType then
		frame:SetUserValue("RINGCMD_TYPE", typeStr);
		ringCmdType = typeStr;
	end

	local bg = frame:GetChild("bg");
	if ringCmdType == "COMPANION" then
		local pet_pic = GET_CHILD(frame, "pet_pic", "ui::CPicture");
		local obj = world.GetActor(handle);
		if obj ~= nil then
			local mon = GetClassByType("Monster", obj:GetType());
			pet_pic:SetImage(mon.Icon); 
		end

		bg:RemoveAllChild();

		local y = 0;
		y = INSERT_RINGCOMMAND(bg, "RINGCMD_0", "icon_warri_Approach", "Alt+Up", ClMsg("Ride"), y);
		y = INSERT_RINGCOMMAND(bg, "RINGCMD_1", "icon_warri_gungho", "Alt+Dn", ClMsg("Unride"), y);
		y = INSERT_RINGCOMMAND(bg, "RINGCMD_2", "icon_cler_Heal", "Alt+1", ClMsg("Stroke"), y);
		y = INSERT_RINGCOMMAND(bg, "RINGCMD_3", "icon_wizar_swap", "Alt+2", ClMsg("Information"), y);
		GBOX_AUTO_ALIGN(bg, 10, 0, 50, true);
	end
	
end



function RINGCMD_0()
	ON_RIDING_VEHICLE(1)
end
function RINGCMD_1()
	ON_RIDING_VEHICLE(0)
end
function RINGCMD_2()
	COMPANION_INTERACTION(1)
end
function RINGCMD_3()
	COMPANION_INTERACTION(2)
end