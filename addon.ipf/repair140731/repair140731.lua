
function REPAIR140731_ON_INIT(addon, frame)

	addon:RegisterMsg('DIALOG_CLOSE', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('OPEN_DLG_REPAIR', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('UPDATE_DLG_REPAIR', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'REPAIR140731_ON_MSG');
	
end


function REPAIR140731_ON_MSG(frame, msg, argStr, argNum)

	if  msg == 'DIALOG_CLOSE'  then
		frame:OpenFrame(0);
    elseif msg == 'OPEN_DLG_REPAIR' then
    	UPDATE_REPAIR140731_LIST(frame);
		frame:OpenFrame(1);
	elseif msg == 'UPDATE_DLG_REPAIR' then
		UPDATE_REPAIR140731_LIST(frame);
	elseif msg == 'UPDATE_ITEM_REPAIR' then

		if argNum == 90000 then
			DRAW_TOTAL_VIS_OTHER_FRAME(frame, 'sys_silver');
		else
			UPDATE_REPAIR140731_LIST(frame);
		end
	end
end

function REPAIR140731_OPEN(frame)

	ui.EnableSlotMultiSelect(1);

	UPDATE_REPAIR140731_LIST(frame);
end

function REPAIR140731_CLOSE(frame)

	ui.EnableSlotMultiSelect(0);
end

function UPDATE_REPAIR140731_LIST(frame)
	
	--���� �� �� ��ü ���� �ʱ�ȭ �ؾߵ�
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	slotSet:ClearIconAll();
	local slotcnt = 0

	local equiplist = session.GetEquipItemList()
	local isSquire = 0;

	if "itembuffrepair" == frame:GetName() then
		isSquire = 1;
	end
	
	for i = 0, equiplist:Count() - 1 do
		local equipItem = equiplist:Element(i);
		local tempobj = equipItem:GetObject()
		if tempobj ~= nil then
			local obj = GetIES(tempobj);
			if IS_NEED_REPAIR_ITEM(obj, isSquire) == true then
				local slot = slotSet:GetSlotByIndex(slotcnt)
				slot:SetClickSound('button_click_stats');
				while slot == nil do 
					slotSet:ExpandRow()
					slot = slotSet:GetSlotByIndex(slotcnt)
				end

				local icon = CreateIcon(slot);
				icon:Set(obj.Icon, 'Item', equipItem.type, slotcnt, equipItem:GetIESID());
				local class 			= GetClassByType('Item', equipItem.type);
				ICON_SET_INVENTORY_TOOLTIP(icon, equipItem, "repair", class);

				slotcnt = slotcnt + 1
			end
		else
			print('error! tempobj == nil')
		end
		

	end

	local invItemList = session.GetInvItemList();

	local i = invItemList:Head();
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end

		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		
		local tempobj = invItem:GetObject()
		if tempobj ~= nil then
			local obj = GetIES(tempobj);
			if IS_NEED_REPAIR_ITEM(obj, isSquire) == true then
				local slot = slotSet:GetSlotByIndex(slotcnt)

				while slot == nil do 
					slotSet:ExpandRow()
					slot = slotSet:GetSlotByIndex(slotcnt)
				end

				local icon = CreateIcon(slot);
				icon:Set(obj.Icon, 'Item', invItem.type, slotcnt, invItem:GetIESID());
				local class 			= GetClassByType('Item', invItem.type);
				ICON_SET_INVENTORY_TOOLTIP(icon, invItem, "repair", class);

				slotcnt = slotcnt + 1
			end

		else
			print('error! tempobj == nil')
		end


	end

	UPDATE_REPAIR140731_MONEY(frame)

end

function UPDATE_REPAIR140731_MONEY(frame)
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	local totalprice = 0;

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount);

	end

	local repairprice = GET_CHILD_RECURSIVELY(frame, "invenZeny", "ui::CRichText")
	-- �����̾� ���� ���� ������ UPDATE_REPAIR140731_LIST�� �����ٽ��
	-- �׷� �� money �Լ��� ȣ���� �Ǵµ� �� ������ ���� ��� ���� ����ó�� ������ϴ�.
	if nil ~= repairprice then
		repairprice:SetText(totalprice)
	end

	local calcprice = GET_CHILD_RECURSIVELY(frame, "remainInvenZeny", "ui::CRichText")
	-- �����̾� ���� ���� ������ UPDATE_REPAIR140731_LIST�� �����ٽ��
	-- �׷� �� money �Լ��� ȣ���� �Ǵµ� �� ������ ���� ��� ���� ����ó�� ������ϴ�.
	if nil ~= calcprice then
		calcprice:SetText(GET_TOTAL_MONEY()-totalprice)
	end

end

function IS_NEED_REPAIR_ITEM(itemobj, isSquireRepair)

	if itemobj == nil then
		return false
	end

	local Itemtype = itemobj.ItemType

	if Itemtype == nil then
		print('If This message has appeared, please tell its ClassId to Young.',itemobj.ClassID)
		return false;
	else
		if itemobj.ItemType ~= 'Equip' then
			return false
		end
	end

	if item.IsNoneItem(itemobj.ClassID) == 0  then
		if itemobj.MaxDur > 0 and itemobj.MaxDur - itemobj.Dur > 0 then
	--if item.IsNoneItem(itemobj.ClassID) == 0 and itemobj.MaxDur > 0  then
		return true
		else
			-- ������ �� ���� ã����, �����̾�� �θ� �� 
			if nil ~= isSquireRepair and isSquireRepair == 1 and itemobj.MaxDur ~= -1 then
				return true
			end
		end
	end
	

	return false
end

function EXECUTE_REPAIR140731(frame)

	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("SelectRepairItemPlz"))
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount);
	end

	if totalprice == 0 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_REPAIR"));
		return;
	end
	
	if GET_TOTAL_MONEY() < totalprice then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local msg = ScpArgMsg('ReallyRepair',"Price",totalprice)
	local msgBox = ui.MsgBox(msg, 'EXECUTE_REPAIR_COMMIT', "None");
	msgBox:SetYesButtonSound("button_click_repair");
end

function EXECUTE_REPAIR_COMMIT()

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("REPAIR", resultlist);
end


function SCP_LBTDOWN_REPAIR140731(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")

	local totalprice = 0;

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount);

	end

	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "invenZeny", "ui::CRichText")
	repairprice:SetText(totalprice)

	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "remainInvenZeny", "ui::CRichText")
	calcprice:SetText(GET_TOTAL_MONEY()-totalprice)


end

function REPAIR140731_SELECT_ALL(frame, ctrl)

	local isselected =  ctrl:GetUserValue("SELECTED");

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")
	
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "selected" then
				slot:Select(0)
			else
				slot:Select(1)
			end
		end
	end
	slotSet:MakeSelectionList()

	if isselected == "selected" then
		ctrl:SetUserValue("SELECTED", "notselected");
	else
		ctrl:SetUserValue("SELECTED", "selected");
	end

	UPDATE_REPAIR140731_MONEY(frame)
end