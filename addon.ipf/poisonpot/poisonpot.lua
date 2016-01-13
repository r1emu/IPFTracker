
function POISONPOT_ON_INIT(addon, frame)
	addon:RegisterMsg("MSG_UPDATE_POISONPOT_UI", "POISONPOT_MSG");
	addon:RegisterMsg("DO_OPEN_POISONPOT_UI", "POISONPOT_MSG");
	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'POISONPOT_MSG');
end

function POISONPOT_MSG(frame, msg, argStr, argNum)

	if msg == "MSG_UPDATE_POISONPOT_UI" or msg == "INV_ITEM_ADD" then
		UPDATE_POISONPOT_UI(frame)
	elseif msg == "DO_OPEN_POISONPOT_UI" then
		frame:ShowWindow(1)
	end
end

function POISONPOT_FRAME_OPEN(frame)

	local selectallbutton = GET_CHILD_RECURSIVELY(frame,"selectAllBtn","ui::CButton")
	selectallbutton:SetUserValue("SELECTED", "notselected");

	UPDATE_POISONPOT_UI(frame)
end

function POISONPOT_FRAME_CLOSE(frame)
	
end

function UPDATE_POISONPOT_UI(frame)
	
	local etc_pc = GetMyEtcObject();
	local poisonAmount = etc_pc['Wugushi_PoisonAmount']
	local poisonMaxAmount = etc_pc['Wugushi_PoisonMaxAmount']

	local poisonAmountGauge = GET_CHILD_RECURSIVELY(frame,"poisonAmountGauge","ui::CGauge")
	poisonAmountGauge:SetPoint(poisonAmount, poisonMaxAmount);

	local poisonAmountText = GET_CHILD_RECURSIVELY(frame,"poisonAmount")
	poisonAmountText:SetTextByKey("amount",poisonAmount);

	--local slottextname = 'subbosstext'..i
	local bosscardid = etc_pc['Wugushi_bosscard']

	local bosscardcls = GetClassByType("Item", bosscardid)

	if bosscardcls ~= nil then
		local slotchild = GET_CHILD_RECURSIVELY(frame, 'subboss',"ui::CSlot");
		slotchild:EnableDrag(0)
		SET_SLOT_ICON(slotchild, bosscardcls.TooltipImage);

		--local slotchild_text= GET_CHILD(gbox, slottextname,"ui::CRichText");
		--slotchild_text:SetText(bosscardcls.Name)
	end


	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	slotSet:ClearIconAll();

	local invItemList = session.GetInvItemList();

	local i = invItemList:Head();
	local slotindex = 0
	while 1 do
		
		if i == invItemList:InvalidIndex() then
			break;
		end

		local invItem = invItemList:Element(i);
		local obj = GetIES(invItem:GetObject());
		
		if IS_USEABLEITEM_IN_POISONPOT(obj) == 1 then

			local slot = slotSet:GetSlotByIndex(slotindex)
			
			while slot == nil do 
				slotSet:ExpandRow()
				slot = slotSet:GetSlotByIndex(slotindex)
			end

			slot:SetMaxSelectCount(invItem.count);
			
			local icon = CreateIcon(slot);
			
			icon:Set(obj.Icon, 'Item', invItem.type, i, invItem:GetIESID(), invItem.count);
			local class 			= GetClassByType('Item', invItem.type);
			SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, invItem.count);
			ICON_SET_INVENTORY_TOOLTIP(icon, invItem, "poisonpot", class);

			slotindex = slotindex + 1

		end

		i = invItemList:Next(i);
	end

end

function IS_USEABLEITEM_IN_POISONPOT(itemobj)

	local useable = GetClass("item_poisonpot", itemobj.ClassName)
	if useable == nil then
		return 0
	end

	return 1
end

function SCP_LBTDOWN_POISONPOT(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

end

function POISONPOT_SELECT_ALL(frame, ctrl) 

	local isselected =  ctrl:GetUserValue("SELECTED");

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")
	
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "selected" then
				slot:Select(0)
				slot:SetSelectCount(0)
			else
				slot:Select(1)
				slot:SetSelectCount(99999) -- ?�차???�스?�서 ???�한?�고 ?�다. ?�에??맥스값�? ?��? ?�정 ?�으므�?
			end
		end
	end
	slotSet:MakeSelectionList()

	if isselected == "selected" then
		ctrl:SetUserValue("SELECTED", "notselected");
	else
		ctrl:SetUserValue("SELECTED", "selected");
	end

end

function POISONPOT_SLOT_DROP(frame, control, argStr, argNum) 

	local liftIcon 					= ui.GetLiftIcon();
	local iconParentFrame 			= liftIcon:GetTopParentFrame();
	local slot 						= tolua.cast(control, 'ui::CSlot');
	
	local iconInfo = liftIcon:GetInfo();
	invenItemInfo = session.GetInvItem(iconInfo.ext);

	local tempobj = invenItemInfo:GetObject()
	local cardobj = GetIES(invenItemInfo:GetObject());

	local etc_pc = GetMyEtcObject();
	local bosscardid = etc_pc['Wugushi_bosscard']

	if bosscardid == cardobj.ClassID then
		return
	end

	if cardobj.GroupName ~= 'Card' then
		return 
	end

	local bossCls = GetClassByType("Monster", cardobj.NumberArg1);
	if bossCls.RaceType ~= 'Klaida' then -- 곤충?�인가?
		return 
	end

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());

	SET_POISONPOT_CARD_COMMIT(slot:GetName())

end

function EXECUTE_POISONPOT(frame)

	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("SelectSomeItemPlz"))
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
		
		local  cnt = slot:GetSelectCount();
		session.AddItemID(iconInfo:GetIESID(), cnt );
	end

	local msg = ScpArgMsg('AreYouSerious')
	ui.MsgBox(msg, 'EXECUTE_POISONPOT_COMMIT', "None");
end

function EXECUTE_POISONPOT_COMMIT()

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("POISONPOT", resultlist);
end

function SET_POISONPOT_CARD_COMMIT(slotname)

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("SET_POISON_CARD", resultlist); -- ?�버??SCR_SET_CARD()가 ?�출?�다.

en