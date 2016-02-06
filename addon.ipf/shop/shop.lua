function SHOP_ON_INIT(addon, frame)

	addon:RegisterMsg('SHOP_ITEM_LIST_GET', 'SHOP_ON_MSG');
	addon:RegisterMsg('DIALOG_CLOSE', 'SHOP_ON_MSG');
	addon:RegisterMsg('INV_ITEM_POST_REMOVE', 'SHOP_ON_MSG');
	addon:RegisterMsg('INV_ITEM_CHANGE_COUNT', 'SHOP_ON_MSG');
	addon:RegisterMsg('ESCAPE_PRESSED', 'SHOP_ON_MSG');
	addon:RegisterMsg('SOLD_ITEM_LIST', 'ON_SOLD_ITEM_LIST');
	addon:RegisterMsg('FAIL_SHOP_BUY', 'ON_FAIL_SHOP_BUY');

	addon:RegisterMsg('COMMON_SHOP_ITEM_LIST_GET', 'SHOP_ON_MSG');

	FINALPRICE = GET_TOTAL_MONEY();
	NOWPAGENUM = 1;
	TOTALPAGENUM = 1;
	BUYSLOTCOUNT = {};
end

function SHOP_UI_OPEN(frame)

	--HIDE_OR_SHOW_REPAIR_BUTTON(frame)
	OPEN_SHOPUI_COMMON();

	--jansori.lua �� �Լ�
	JS_SHOP_OPEN(frame)
	ui.EnableSlotMultiSelect(1);

	FINALPRICE = GET_TOTAL_MONEY();

	return 1;
end


function HIDE_OR_SHOW_REPAIR_BUTTON(frame)

	local repairbutton = GET_CHILD_RECURSIVELY(frame,"repair","ui::CButton")

	local test = IS_REPAIRABLE_SHOP() 

	if IS_REPAIRABLE_SHOP() == "true" then
		repairbutton:ShowWindow(1);
	else
		repairbutton:ShowWindow(0);
	end

end

function IS_REPAIRABLE_SHOP()

	local shopname = session.GetCurrentShopName()

	local clslist, cnt  = GetClassList("repairableshoplist");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if cls.ClassName == shopname then
			return cls.RepairAble;
		end
	end

	return "false";
end

function SHOP_UI_CLOSE(frame, obj, argStr, argNum)
	control.DialogOk()

	--jansori.lua �� �Լ�
	JS_SHOP_CLOSE(frame)
	ui.EnableSlotMultiSelect(0);
	SHOP_SELECT_ITEM_LIST = {}

	local invenFrame = ui.GetFrame('inventory');
	INVENTORY_UPDATE_ICONS(invenFrame);
	if invenFrame:IsVisible() == 1 then
		invenFrame:ShowWindow(0);
	end
end

function SHOP_SLOT_RBTNDOWN_2(frame, slotList, argStr, argNum)

	local ConSetBySlot 	= slotList:GetChild('slot');
	local slot			= tolua.cast(ConSetBySlot, "ui::CSlot");

	SHOP_SLOT_RBTNDOWN(frame, slot, argStr, argNum)
end

function SHOP_SLOT_RBTNDOWN(frame, slot, argStr, argNum)

	local frame     = ui.GetFrame("shop");
	local clsID = GET_SHOP_SLOT_CLSID(slot);
	if clsID == 0 then
		return;
	end

	local shopItem	= geShopTable.GetByClassID(clsID);

	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		local remainPrice = frame:GetUserIValue("EXPECTED_REMAIN_ZENY");
		local maxStack = GET_SHOP_ITEM_MAXSTACK(shopItem);
		if -1 == maxStack then
			SHOP_BUY(clsID, shopItem.count);
			SHOP_UPDATE_BUY_PRICE();
			return;
		end

		local itemPrice = shopItem.price * shopItem.count;
		local buyableCnt = math.floor(remainPrice / itemPrice);

		local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", buyableCnt);
		INPUT_NUMBER_BOX(frame, titleText, "EXEC_SHOP_SLOT_BUY", 1, 1, buyableCnt, nil, nil, 1);
		frame:SetUserValue("BUY_CLSID", clsID);
		return;
	end

	SHOP_BUY(clsID, shopItem.count);
	SHOP_UPDATE_BUY_PRICE();
end

function ON_FAIL_SHOP_BUY(frame)
	local MyMoney = GET_TOTAL_MONEY();
	local TotalPrice = GET_TOTAL_BUY_PRICE(frame);
	FINALPRICE = MyMoney + TotalPrice;
	SHOP_UPDATE_BUY_PRICE();
end

function EXEC_SHOP_SLOT_BUY(frame, ret)

	ret = tonumber(ret);
	local remainPrice = frame:GetUserIValue("EXPECTED_REMAIN_ZENY");
	local clsID = frame:GetUserIValue("BUY_CLSID");

	local shopItem	= geShopTable.GetByClassID(clsID);
	local itemCount = ret * shopItem.count;

	SHOP_BUY(clsID, itemCount);
	SHOP_UPDATE_BUY_PRICE();

end

function SHOP_BUTTON_BUYSELL(frame, slot, argStr, argNum)
	local MyMoney = GET_TOTAL_MONEY();
	local TotalPrice = GET_TOTAL_BUY_PRICE(frame);
	if -TotalPrice > MyMoney then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughMoney'));
		return;
	end
	
	local isSellSound = SHOP_BUTTON_SELL(frame);
	local isBuySound  = SHOP_BUTTON_BUY(frame);

	if isBuySound == true and isSellSound == true then
		imcSound.PlaySoundEvent("market_sell");
	elseif isBuySound == true then
		imcSound.PlaySoundEvent("market buy");
	elseif isSellSound == true then
		imcSound.PlaySoundEvent("market_sell");
	end

	FINALPRICE = MyMoney + TotalPrice;
	SHOP_UPDATE_BUY_PRICE();

	SHOP_SELECT_ITEM_LIST = {}
	
end

function SHOP_BUTTON_BUY(frame, slot, argStr, argNum)
	-- ������ ����
	local frame     = ui.GetFrame("shop");
	local groupbox  = frame:GetChild('buyitemslot');
	local buyslotSet	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = buyslotSet:GetSlotCount();
	local isSound = false;
	local redrawItemName = false;
	for i = 0, slotCount - 1 do
		local slotIcon	= buyslotSet:GetIconByIndex(i);

		if slotIcon ~= nil then
			local slot  = buyslotSet:GetSlotByIndex(i);
			local clsID = GET_SHOP_SLOT_CLSID(slot);
			item.AddToBuyList(clsID, BUYSLOTCOUNT[i]);
			BUYSLOTCOUNT[i] = 0;
			slot:ClearText();
			isSound = true;
			local shopItem	= geShopTable.GetByClassID(clsID);
			if shopItem:GetIDSpace() == "Wiki" then
				redrawItemName = true;
			end
		end
	end
	item.BuyList();
	buyslotSet:ClearIconAll();

	return isSound;
end

function SHOP_BUTTON_SELL(frame, slot, argStr, argNum)
	-- ������ �Ǹ�
	local frame     = ui.GetFrame("shop");
	local groupbox  = frame:GetChild('sellitemslot');
	local sellslotSet	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = sellslotSet:GetSlotCount();

	local isSound = false;
	for i = 0, slotCount - 1 do
		local slotIcon	= sellslotSet:GetIconByIndex(i);

		if slotIcon ~= nil then
			local slot  = sellslotSet:GetSlotByIndex(i);
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			item.AddToSellList(itemID, slot:GetUserIValue("SELL_CNT"));
			CLEAR_SELL_SLOT(slot);
			isSound = true;
		end
	end
	item.SellList();
	sellslotSet:ClearIconAll();

	return isSound;
end

function IS_SHOP_SELL(invitem, maxStack)
	local frame     = ui.GetFrame("shop");
	local groupbox  = frame:GetChild('sellitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	--imcSound.PlaySoundItem('inven_equip');
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		if slotIcon == nil then
			return 1;
		end
	--	print(invitem, maxStack);
		if slotIcon ~= nil and nil ~= invitem and 1 < maxStack then
			local slot  = slotSet:GetSlotByIndex(i);
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			if invitem:GetIESID() == itemID then
				return 1;
			end
		end
	end
	return 0;
end

function SHOP_GET_SELL_SLOT_BY_ITEM_ID(frame, itemID)

	local groupbox  = frame:GetChild('sellitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		if slotIcon ~= nil then
			local slot = slotSet:GetSlotByIndex(i);
			local slotItemID = slot:GetUserValue("SLOT_ITEM_ID");
			if slotItemID == itemID then
				return slot;
			end
		end
	end

	return nil;
end

function GET_USABLE_SLOTSET(frame, invitem)

	local groupbox  = frame:GetChild('sellitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slot = SHOP_GET_SELL_SLOT_BY_ITEM_ID(frame, invitem:GetIESID());
	if slot ~= nil then
		return slot;
	end

	local slotCount = slotSet:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		if slotIcon == nil then
			return slotSet:GetSlotByIndex(i);
		end
	end

end

function SHOP_SELL_DROP(frame, ctrl)

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if ctrl:GetClassName() ~= "slot" then
		return;
	end

	local iconInfo = liftIcon:GetInfo();
	local iesID = liftIcon:GetTooltipIESID();

	local invItem = session.GetInvItemByGuid(iesID);

	SHOP_SELL(invItem, invItem.count);

end


function SHOP_SELL(invitem, sellCount, setTotalCount)
	if true == invitem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemobj = GetIES(invitem:GetObject());
	if itemobj.ShopTrade ~= 'YES' then
		ui.SysMsg(ClMsg("CannoTradeToNPC"));
		return;
	end

	local frame     = ui.GetFrame("shop");

	imcSound.PlaySoundEvent('button_inven_click_item');
	local slot = GET_USABLE_SLOTSET(frame, invitem);
	slot:SetUserValue("SLOT_ITEM_ID", invitem:GetIESID());
	local icon = CreateIcon(slot);
	local imageName = itemobj.Icon;
	icon:Set(imageName, 'SELLITEMITEM', 0, 0, invitem:GetIESID());

	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invitem, itemobj.ClassName,'buy', invitem.type, invitem:GetIESID());
	
	slot:SetEventScript(ui.RBUTTONDOWN, "CANCEL_SELL");

	local curCnt = slot:GetUserIValue("SELL_CNT");
	if setTotalCount then
		curCnt = sellCount;
	else
		curCnt = curCnt + sellCount;
	end
	if curCnt > 1 and sellCount == 1 then
	    local sObj = session.GetSessionObjectByName("ssn_klapeda")
	    if sObj ~= nil then
    	    sObj = GetIES(sObj:GetIESObject())
    	    if sObj ~= nil then
    	        local pc = GetMyPCObject();
    	        if sObj.SHOP_SELLITEM_HELP == 0 then
    	            addon.BroadMsg('NOTICE_Dm_Shoptutorial', ScpArgMsg('shoptutorial_Rclick'), 10);
            	    sObj.SHOP_SELLITEM_HELP = sObj.SHOP_SELLITEM_HELP + 1
            	end
        	end
    	end
	end

	if curCnt > invitem.count then
		curCnt = invitem.count;
	end

	slot:SetUserValue("SELL_CNT", curCnt);

	if itemobj.MaxStack > 1 then
		slot:SetText('{s18}{b}{ol}'..curCnt, 'count', 'right', 'bottom', -2, 1);
	end
	local noTrade = TryGetProp(itemobj, "BelongingCount");
	if nil ~= noTrade then
		local cnt = tonumber(noTrade);
		local compareCnt = 0;
		if nil == curCnt then
			compareCnt = sellCount;
		else
			compareCnt = curCnt;
		end
		if cnt > compareCnt then
			cnt = compareCnt
		end
		icon:SetNoTradeCount(cnt);
	end

	SHOP_SELECT_ITEM_LIST[invitem:GetIESID()] = curCnt;

	SHOP_ITEM_LIST_GET(frame);
	SHOP_UPDATE_BUY_PRICE();

	INVENTORY_UPDATE_ICON_BY_INVITEM(ui.GetFrame('inventory'), invitem);

end

function GET_SHOP_TOTAL_USED_POINT(frame, shopItem)
	local buygroupbox  = frame:GetChild('buyitemslot');
	local buyslotSet   = GET_CHILD(frame, "buyitemslot", "ui::CSlotSet");
	local buyslotCount = buyslotSet:GetSlotCount();

	local shopItemList = session.GetShopItemList();

	local totalPoint = 0;
	for i = 0, buyslotCount - 1 do
		local icon = buyslotSet:GetIconByIndex(i);

		if icon ~= nil and icon:GetTooltipNumArg() > 0 then
			local idx = icon:GetValue();
			local atItem = shopItemList:PtrAt(idx);
			if atItem:GetPropName() == shopItem:GetPropName() then
				totalPoint = totalPoint + BUYSLOTCOUNT[i];
			end
		end
	end

	return totalPoint;

end

function GET_SHOP_HAVE_POINT(shopItem)

	local needProp = shopItem:GetPropName();
	return GET_SHOP_PROP_POINT(needProp);

end

function GET_SHOP_ITEM_MAXSTACK(shopItem)
	if shopItem:GetIDSpace() == "Item" then
		local cls = GET_SHOP_ITEM_CLS(shopItem);
		local mStack = cls.MaxStack;
		if mStack == 1 then
			return -1;
		end
		return mStack;
	end

	return 1;
end

function GET_SHOP_ITEM_CLS(shopItem)
	return GetClassByType(shopItem:GetIDSpace(), shopItem.type);
end

function GET_SHOP_SLOT_CLSID(slot)
	if slot:GetClassName() ~= "slot" then
		return;
	end

	slot = tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return 0;
	end

	return icon:GetUserIValue("SHOPCLSID");
end

function GET_SHOP_ITEM_MY_CNT(shopItem)
	if shopItem:GetIDSpace() == "Item" then
		local item = session.GetInvItemByType(shopItem.type);
		if item == nil then
			return 0;
		end

		return item.count;
	elseif shopItem:GetIDSpace() == "Wiki" then
		local wiki = GetWiki(shopItem.type);
		if wiki == nil then
			return 0;
		end

		return 1;
	end


	return 0;

end

function SHOP_BUY(clsID, buyCnt)

	local MyMoney = GET_TOTAL_MONEY();
	local TotalPrice = GET_TOTAL_BUY_PRICE(ui.GetFrame("shop"));
	if clsID == nil then
		return;
	end

	local shopItem	= geShopTable.GetByClassID(clsID);

	local frame     = ui.GetFrame("shop");

	if shopItem:GetPropName() ~= "None" then
		local used = GET_SHOP_TOTAL_USED_POINT(frame, shopItem);
		local remain = GET_SHOP_HAVE_POINT(shopItem);
		if used + 1 > remain then
			ui.AlarmMsg("ItemBuyCountLimited");
			return;
		end
	end

	if shopItem.price > MyMoney + TotalPrice then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughMoney'));
		return;
	end

	local myCnt = GET_SHOP_ITEM_MY_CNT(shopItem);
	local maxStack = GET_SHOP_ITEM_MAXSTACK(shopItem);
	if maxStack ~= -1 and myCnt + buyCnt > maxStack then
		ui.SysMsg(ClMsg('YouAlreadyHaveIt'));
		return;
	end

	local groupbox  = frame:GetChild('buyitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	imcSound.PlaySoundEvent('inven_equip');

	local sameItemExist = false;
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);

		local class 		= GET_SHOP_ITEM_CLS(shopItem);
		local imageName 	= shopItem:GetIcon();

		if slotIcon ~= nil then
			local slot = slotSet:GetSlotByIndex(i);
			local slotShopItem = GET_SHOP_SLOT_CLSID(slot);
			if slotShopItem == clsID then
				sameItemExist = true;
				if GET_SHOP_ITEM_MAXSTACK(shopItem) >= BUYSLOTCOUNT[i] + buyCnt  then
					BUYSLOTCOUNT[i] = BUYSLOTCOUNT[i] + buyCnt;
					local slotIcon	= slotSet:GetIconByIndex(i);
					slot:SetText('{s18}{ol}{b}'..BUYSLOTCOUNT[i], 'count', 'right', 'bottom', -2, 1);
					slot:Invalidate();
					SHOP_ITEM_LIST_GET(frame);
					return;
				end
			end
		end
	end

	if shopItem:GetIDSpace() == "Wiki" and sameItemExist == true then
		return;
	end

	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);

		if slotIcon == nil then
			local slot			= slotSet:GetSlotByIndex(i);
			local icon = CreateIcon(slot);
			icon:Set(shopItem:GetIcon(), 'BUYITEMITEM', clsID, 0);



			local itemlist = session.GetShopItemList();
			SET_SHOP_ITEM_TOOLTIP(icon, shopItem)

			slot:SetEventScript(ui.RBUTTONDOWN, "CANCEL_BUY");
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
			BUYSLOTCOUNT[i] = buyCnt;
			slot:SetText('{s18}{ol}{b}'..BUYSLOTCOUNT[i], 'count', 'right', 'bottom', -2, 1);
			SHOP_ITEM_LIST_GET(frame);
			return;
		end
	end
end

function CANCEL_BUY(frame, ctrl, argstr, argnum)
	local frame     = ui.GetFrame("shop");
	local groupbox  = frame:GetChild('buyitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local slot	= slotSet:GetSlotByIndex(argnum);
	if slot:GetIcon() ~= nil then
		BUYSLOTCOUNT[argnum] = 0;
		slot:ClearText();
		slot:ClearIcon();
		SHOP_UPDATE_BUY_PRICE();
		SHOP_ITEM_LIST_GET(frame);
	end
	imcSound.PlaySoundEvent("inven_unequip");
end

function CLEAR_SELL_SLOT(slot)
	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("SLOT_ITEM_ID", "0");
	slot:SetUserValue("SELL_CNT", "0");
end

function CANCEL_SELL(frame, ctrl, argstr, argnum)
	local frame     = ui.GetFrame("shop");
	local groupbox  = frame:GetChild('sellitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local slot;
	if ctrl:GetClassName() == "slot" then
		slot = tolua.cast(ctrl, "ui::CSlot");
	end

	-- �κ����� ������ ����
	local itemID = slot:GetUserValue("SLOT_ITEM_ID");
	local invitem = session.GetInvItemByGuid(itemID);

	SHOP_SELECT_ITEM_LIST[itemID] = nil
	INVENTORY_UPDATE_ICONS(ui.GetFrame("inventory"));

	CLEAR_SELL_SLOT(slot);
	SHOP_UPDATE_BUY_PRICE();
	SHOP_ITEM_LIST_GET(frame);

	imcSound.PlaySoundEvent("inven_unequip");
end

function GET_TOTAL_BUY_PRICE(frame)

	-- ���� �� �ݾ� ���
	local buygroupbox  = frame:GetChild('buyitemslot');
	local buyslotSet   = tolua.cast(buygroupbox, 'ui::CSlotSet');
	local buyslotCount = buyslotSet:GetSlotCount();

	local price = 0;
	local buyprice = 0;
	for i = 0, buyslotCount - 1 do
		local icon = buyslotSet:GetIconByIndex(i);

		if icon ~= nil then
			local clsid = icon:GetUserIValue("SHOPCLSID");
			local shopItem = geShopTable.GetByClassID(clsid);
			if BUYSLOTCOUNT[i] ~= nil then
				buyprice = buyprice - shopItem.price * BUYSLOTCOUNT[i];
			else
				buyprice = buyprice - shopItem.price;
			end
		end
	end

	local buypricetext = frame:GetChild('buy_price');
	buypricetext:SetText("{@st41b}" .. tostring(buyprice));

	-- �Ǹ�  �� �ݾ� ���
	local sellgroupbox  = frame:GetChild('sellitemslot');
	if sellgroupbox == nil then
		return buyprice;
	end
	local sellslotSet   = tolua.cast(sellgroupbox, 'ui::CSlotSet');
	local sellslotCount = sellslotSet:GetSlotCount();

	local sellprice = 0;
	for i = 0, sellslotCount - 1 do
		local slot = sellslotSet:GetSlotByIndex(i);
		local icon = slot:GetIcon();

		if icon ~= nil then
			local slotItem = GET_SLOT_ITEM(slot);
			if slotItem ~= nil then
				local itemcls = GetIES(slotItem:GetObject());

				if itemcls ~= nil then
					local cnt = slot:GetUserIValue("SELL_CNT");
					local itemProp = geItemTable.GetPropByName(itemcls.ClassName);
					sellprice = sellprice + (geItemTable.GetSellPrice(itemProp) * cnt);
				end
			end
		end
	end

	local sellpricetext = frame:GetChild('sell_price');
	sellpricetext:SetText("{@st41b}" .. tostring(sellprice));

	return sellprice + buyprice;
end

function SHOP_UPDATE_BUY_PRICE()
	local frame     = ui.GetFrame("shop");
	local price = GET_TOTAL_BUY_PRICE(frame);
	local txt = frame:GetChild("pricetxt");
	if price >= 0 then
		txt:SetText("{@st41}" ..COLOR_YELLOW .. price);
	else
		txt:SetText("{@st41}" ..COLOR_RED .. price);
	end

	local invenZeny = FINALPRICE;
	local totaltext = frame:GetChild("finalprice");
	local totalprice = invenZeny + price;

	totaltext:SetText("{@st41}"..COLOR_YELLOW .. totalprice);
	frame:SetUserValue("EXPECTED_REMAIN_ZENY", totalprice);

	return totalprice;
end

function SHOP_UPDATE_PAGE_NUMBER()
	local frame     = ui.GetFrame("shop");
	local txt = frame:GetChild("pagetxt");
	txt:SetText("{@st66b}" .. NOWPAGENUM .. " / " .. TOTALPAGENUM);
end

function SHOP_ON_MSG(frame, msg, argStr, argNum)
	local shopItemList = session.GetShopItemList();
	local shopItemCount = 0;
	if shopItemList ~= nil then
		shopItemCount = shopItemList:Count();
	end

	if  msg == 'SHOP_ITEM_LIST_GET' or msg == 'COMMON_SHOP_ITEM_LIST_GET' then
		
		SHOP_ITEM_LIST_GET(frame);
		SHOP_ITEM_SLOT_INIT(frame);
		--UPDATE_SOLD_ITEM_LIST(frame);

		frame:ShowWindow(1);
		ui.CloseFrame('notice');
	end

	if msg == 'INV_ITEM_POST_REMOVE' or msg == 'INV_ITEM_CHANGE_COUNT' then
		SHOP_ITEM_LIST_GET(frame);
	end

	if  msg == 'DIALOG_CLOSE' or msg == 'ESCAPE_PRESSED' then
		local frame     = ui.GetFrame("shop");
		if frame:IsVisible() == 0 then
			return;
		end

		local groupbox  = frame:GetChild('buyitemslot');
		local buyslotSet	= tolua.cast(groupbox, 'ui::CSlotSet');
		local buyslotCount = buyslotSet:GetSlotCount();

		for i = 0, buyslotCount - 1 do
			local slot = buyslotSet:GetSlotByIndex(i);
			if slot:GetIcon() ~= nil then
				slot:ClearText();
				slot:ClearIcon();
			end
		end

		local groupbox  = frame:GetChild('sellitemslot');
		local sellslotSet	= tolua.cast(groupbox, 'ui::CSlotSet');
		local slotCount = sellslotSet:GetSlotCount();

		for i = 0, slotCount - 1 do
			local slotIcon	= sellslotSet:GetIconByIndex(i);
			if slotIcon ~= nil then
				local slot  = sellslotSet:GetSlotByIndex(i);
				local itemID = slot:GetUserValue("SLOT_ITEM_ID");
				CLEAR_SELL_SLOT(slot);
				local invitem = session.GetInvItemByGuid(itemID);
				SHOP_SELECT_ITEM_LIST[itemID] = nil
			end
		end
		sellslotSet:ClearIconAll();

		frame:ShowWindow(0);
		
		RIGHT_PAGEBUTTON_ENABLE(frame, 1);
		LEFT_PAGEBUTTON_ENABLE(frame, 0);
		NOWPAGENUM = 1;
	end
end

function SHOP_REPAIR_ITEM(frame)
	addon.BroadMsg("OPEN_DLG_REPAIR","",0)
end

function SHOP_ITEM_SLOT_INIT(frame)
	-- ���� ���� �ʱ�ȭ
	local groupbox  = frame:GetChild('buyitemslot');
	local slotSet   = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:ClearText();
			slot:ClearIcon();
		end
	end

	--slotSet:ClearIconAll();

	-- �Ǹ� ���� �ʱ�ȭ ( �ǸŴ� �κ������� �������� ���� ������� �Ѵ� )
	groupbox  = frame:GetChild('sellitemslot');
	slotSet   = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	local updateInv = false;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			local invItem = session.GetInvItemByGuid(itemID);

			updateInv = true;
			SHOP_SELECT_ITEM_LIST[itemID] = nil

			slot:ClearText();
			slot:ClearIcon();
		end
	end

	if updateInv == true then
		INVENTORY_UPDATE_ICONS(ui.GetFrame("inventory"));
	end

	SHOP_UPDATE_BUY_PRICE();
	SHOP_UPDATE_PAGE_NUMBER();
	SHOP_ITEM_LIST_GET(frame);
end

function SHOP_ITEM_LIST_GET(frame)

	local ShopItemGroupBox 	= frame:GetChild('shop');
	local SHOPITEM_listSet	= tolua.cast(ShopItemGroupBox, "ui::CGroupBox");
	SHOPITEM_listSet:DeleteAllControl();
	local grid = SHOPITEM_listSet:CreateOrGetControl('grid', 'grid', 0, 0, ui.NONE_HORZ, ui.NONE_VERT, 30, 15, 30, 8)

	local shopgrid	= tolua.cast(grid, "ui::CGrid");
	shopgrid:SetSlotSize(460, 50)
	shopgrid:SetSlotSpace(0, 0)

	-- ������ �Ĵ� ������ ���� �ľ�
	local shopItemList = session.GetShopItemList();
	if shopItemList == nil then
		return;
	end
	local shopItemCount = shopItemList:Count();
	local SHOPITEMLIST_prevItem = nil;

	-- ������ �Ĵ� �������� 10���� ���� ��
	if shopItemCount - shopItemCount % 8 > 0 then
		if shopItemCount % 8 == 0 then
			TOTALPAGENUM = shopItemCount / 8;
		else
			local total = shopItemCount / 8;
			TOTALPAGENUM = total - total % 1 + 1;
		end


		local pageEndCount = NOWPAGENUM * 8 - 1;
		if pageEndCount > shopItemCount then
			pageEndCount = shopItemCount - 1;
		end

		for i = (NOWPAGENUM - 1) * 8, pageEndCount do
			SHOP_ITEM_LIST_UPDATE(frame, i, shopItemCount);
		end
	else

		for i = 0, shopItemCount - 1 do
			SHOP_ITEM_LIST_UPDATE(frame, i, shopItemCount);
		end
	end

	SHOP_UPDATE_PAGE_NUMBER();
end

function GET_SHOPITEM_TXT(shopItem, class)
	local idSpace = GetIDSpace(class);
	if idSpace == "Item" then
		return class.Name;
	elseif idSpace == "Wiki" then
		local curCnt = GET_SHOP_ITEM_MY_CNT(shopItem);
		if curCnt > 0 then
			return string.format("%s (%s)", class.Name, ClMsg("Have"));
		end
	end

	return class.Name;
end

function GET_SHOPITEM_PRICE_TXT(shopItem, class)

	local needProp = shopItem:GetPropName();
	if needProp == "None" then
		return shopItem.price * shopItem.count;
	end

	local availCnt = GET_SHOP_PROP_POINT(needProp);

	local limitedTxt = ScpArgMsg("{Auto_1}_Count_Limited", "Auto_1", availCnt);
	return string.format("%d {@st45r14}(%s)", shopItem.price * shopItem.count, limitedTxt);

end

function IS_SHOPITEM_BUYABLE(shopItem)
	if shopItem:GetIDSpace() == "Item" then
		if shopItem.ItemType == "Equip" then
		return CHECK_EQUIPABLE(shopItem.type);
	end
	end

	return "OK";
end

function SET_SHOP_ITEM_TOOLTIP(icon, shopItem)
	if shopItem:GetIDSpace() == "Item" then
	SET_ITEM_TOOLTIP_TYPE(icon, shopItem.type);
	icon:SetTooltipArg('sell', shopItem.type, shopItem.iesID);
	else
		icon:SetTooltipType('wikidetail');
		icon:SetTooltipArg('', shopItem.type, shopItem.iesID);
	end

	icon:SetUserValue("SHOPCLSID", shopItem.classID);
end

function SHOP_ITEM_LIST_UPDATE(frame, ShopItemData, ShopItemCount)
	-- ������ �Ĵ� ������ ���� �ľ�
	local shopItemList = session.GetShopItemList();

	local shopItemList = session.GetShopItemList();
	if ShopItemData  >= shopItemList:Count() then
		return;
	end

	local shopItem	= shopItemList:PtrAt(ShopItemData);

	-- ������ �Ĵ� ������ �׷켳��
	local ShopItemGroupBox 	= frame:GetChild('shop');
	local SHOPITEM_listSet	= tolua.cast(ShopItemGroupBox, "ui::CGroupBox");
	local ShopItemName		= 'SHOPITEMLLIST_' .. ShopItemData;

	local grid = GET_CHILD(SHOPITEM_listSet, 'grid', 'ui::CGrid')

	if grid == nil then
		ui.MsgBox(ShopItemData)
	end

	-- ���� ������ ����Ʈ�� �Է��Ѵ�
	local ShopItemCountObj		= grid:CreateControlSet('shopitemset_Type', ShopItemName, 0, 0);
	local ShopItemCountCtrl		= tolua.cast(ShopItemCountObj, "ui::CControlSet");
	ShopItemCountCtrl:SetEnableSelect(1);
	ShopItemCountCtrl:SetSelectGroupName("ShopItemList");


	-- Sort�� ���� ���� ���� ����϶�
	--[[
	ui.MsgBox(ShopItemData)
	if ShopItemData % 8 == 0 then
		ShopItemCountCtrl:SetGravity(ui.LEFT, ui.TOP);
		SHOPITEMLIST_prevItem = ShopItemCountCtrl;
	elseif  ShopItemData % 8 > 0 and ShopItemData <= ShopItemCount - 1 then
			SHOPITEMLIST_prevItem = ShopItemCountCtrl;
		end

	end
	]]


		-- ���� ������ ���� �� ��Ÿ �������� �Ѵ�
	local ConSetBySlot 	= ShopItemCountCtrl:GetChild('slot');
	local slot			= tolua.cast(ConSetBySlot, "ui::CSlot");
	local icon = CreateIcon(slot);

	local class 		= GetClassByType(shopItem:GetIDSpace(), shopItem.type);
	local imageName 	= shopItem:GetIcon();

	icon:Set(imageName, 'SHOPITEM', ShopItemData, 0);
	local printText	= '{@st66b}' .. GET_SHOPITEM_TXT(shopItem, class);
    local priceText	= string.format(" {img icon_item_silver 20 20} {@st66b}%s", GET_SHOPITEM_PRICE_TXT(shopItem));

	ShopItemCountCtrl:SetEventScript(ui.RBUTTONDOWN, 'SHOP_SLOT_RBTNDOWN_2');
	ShopItemCountCtrl:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
	ShopItemCountCtrl:SetEventScriptArgNumber(ui.RBUTTONDOWN, ShopItemData);
	ShopItemCountCtrl:SetTextByKey('ItemName_Count', printText);
	ShopItemCountCtrl:SetTextByKey('Item_Price', priceText);
	ShopItemCountCtrl:SetOverSound("button_over");

	slot:SetEventScript(ui.RBUTTONDOWN, 'SHOP_SLOT_RBTNDOWN');
	slot:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
	slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, ShopItemData);

	-- ���������� ���� ǥ��
	if shopItem.count > 1 then
		slot:SetText(shopItem.count,  'quickiconfont', 'right', 'bottom', 0, 0);
	end

	SET_SHOP_ITEM_TOOLTIP(icon, shopItem);

	-- ���� �Ұ��� �� ����ũ ó��
	local result = IS_SHOPITEM_BUYABLE(shopItem);


	if result ~= "OK" then
		icon:SetColorTone("FFFF0000");
		local printText	= '{@st67b}' .. GET_SHOPITEM_TXT(shopItem, class);
		local priceText = string.format(" {img icon_item_silver 20 20} {@st67b}%s", GET_SHOPITEM_PRICE_TXT(shopItem));
		ShopItemCountCtrl:SetTextByKey('ItemName_Count', printText);
		ShopItemCountCtrl:SetTextByKey('Item_Price', priceText);

	end
	SHOPITEM_listSet:UpdateData();

end

-- ���� ������ ">" ">>" �� �������� ó��
-- �������� �°� ��������Ʈ�� ����ó��
-- ">>" �� ���������� argnum���� 1�� �ѱ�
function SHOP_PAGE_RIGHT(frame, ctrl, argstr, argnum)
	if ctrl:IsEnable() == 1 then
		if argnum == 1 then
			NOWPAGENUM = TOTALPAGENUM;

			SHOP_UPDATE_PAGE_NUMBER();
			SHOP_ITEM_LIST_GET(frame);
			RIGHT_PAGEBUTTON_ENABLE(frame, 0);
			LEFT_PAGEBUTTON_ENABLE(frame, 1);
		else
			if NOWPAGENUM < TOTALPAGENUM then
				NOWPAGENUM = NOWPAGENUM + 1;
				SHOP_UPDATE_PAGE_NUMBER();
				SHOP_ITEM_LIST_GET(frame);

				if NOWPAGENUM == TOTALPAGENUM then
					RIGHT_PAGEBUTTON_ENABLE(frame, 0);
				end

				LEFT_PAGEBUTTON_ENABLE(frame, 1);
			else
				RIGHT_PAGEBUTTON_ENABLE(frame, 0);
				LEFT_PAGEBUTTON_ENABLE(frame, 1);
			end
		end
	end
end

-- ���� ������ "<" "<<" �� �������� ó��
-- �������� �°� ��������Ʈ�� ����ó��
-- "<<" �� ���������� argnum���� 1�� �ѱ�
function SHOP_PAGE_LEFT(frame, ctrl, argstr, argnum)
	if ctrl:IsEnable() == 1 then
		if argnum == 1 then
			NOWPAGENUM = 1;

			SHOP_UPDATE_PAGE_NUMBER();
			SHOP_ITEM_LIST_GET(frame);
			RIGHT_PAGEBUTTON_ENABLE(frame, 1);
			LEFT_PAGEBUTTON_ENABLE(frame, 0);
		else
			if NOWPAGENUM > 1 then
				NOWPAGENUM = NOWPAGENUM - 1;
				SHOP_UPDATE_PAGE_NUMBER();
				SHOP_ITEM_LIST_GET(frame);

				if NOWPAGENUM == 1 then
					LEFT_PAGEBUTTON_ENABLE(frame, 0);
				end

				RIGHT_PAGEBUTTON_ENABLE(frame, 1);
			else
				RIGHT_PAGEBUTTON_ENABLE(frame, 1);
				LEFT_PAGEBUTTON_ENABLE(frame, 0);
			end
		end
	end
end

function RIGHT_PAGEBUTTON_ENABLE(frame, argNum)
	local pageRight = frame:GetChild('pageright');
	local pageEnd	= frame:GetChild('pageend');

	pageRight:SetEnable(argNum);
	pageEnd:SetEnable(argNum);
end

function LEFT_PAGEBUTTON_ENABLE(frame, argNum)
	local pageLeft  = frame:GetChild('pageleft');
	local pageStart	= frame:GetChild('pagestart');

	pageLeft:SetEnable(argNum);
	pageStart:SetEnable(argNum);
end

function ON_SOLD_ITEM_LIST(frame, msg, str, num)

	UPDATE_SOLD_ITEM_LIST(frame);

end

function UPDATE_SOLD_ITEM_LIST(frame)
	local slotSet = GET_CHILD(frame, "solditemslot", "ui::CSlotSet");
	CLEAR_SOLD_ITEM_LIST(slotSet);

	local list = session.GetSoldItemList();
	local i = list:Tail();
	local idx = 0;
	while 1 do
		if i == list:InvalidIndex() then
			break;
		end

		local slot = slotSet:GetSlotByIndex(idx);
		if slot == nil then
			break;
		end
		local info = list:Element(i);
		local obj = GetIES(info:GetObject());
		local info = list:Element(i);
		SOLD_SLOT_SET(slot, i, info);

		local noTrade = TryGetProp(obj, "BelongingCount");
		if nil ~= noTrade then
			local icon = slot:GetIcon();
			icon:SetNoTradeCount(noTrade);
		end

		idx = idx + 1;
		i = list:Prev(i);
	end

	slotSet:Invalidate();


	local MyMoney = GET_TOTAL_MONEY();
	local TotalPrice = GET_TOTAL_BUY_PRICE(frame);
	FINALPRICE = MyMoney + TotalPrice;

	SHOP_UPDATE_BUY_PRICE();


end

function SOLD_SLOT_SET(slot, index, info)

	local obj = GetIES(info:GetObject());
	--local icon = SET_SLOT_ITEM_INFO(slot, obj, info.count);

	local icon = CreateIcon(slot);
	icon:EnableHitTest(0);
	icon:SetImage(obj.Icon);

	--SET_ITEM_TOOLTIP_TYPE(icon, obj.ClassID, obj);
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, info, obj.ClassName, 'soldItem', info.type, index);

	if IS_EQUIP(obj) == false then
		slot:SetText('{s18}{ol}{b}'..info.count, 'count', 'right', 'bottom', -2, 1);
	end
   -- icon:SetTooltipArg('soldItem', info.type, index);

	slot:SetEventScript(ui.RBUTTONUP, "CONTEXT_SOLD_ITEM");
	slot:SetEventScriptArgNumber(ui.RBUTTONUP, index);

end

function CONTEXT_SOLD_ITEM(frame, slot, str, num)

	local list = session.GetSoldItemList();
	if list:IsValidIndex(num) == 0 then
		return;
	end

	local info = list:Element(num);
	local obj = GetIES(info:GetObject());


	local context = ui.CreateContextMenu("SOLD_ITEM_CONTEXT", "{@st41}".. GET_FULL_NAME(obj).. "{@st42b}..",0, 0, 100, 100);
	local strScp = string.format("SHOP_REQ_CANCEL_SELL(%d)", num);
--	ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}JaeMaeip"), strScp);
	strScp = string.format("SHOP_REQ_DELETE_SOLDITEM(%d)", num);
--	ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}yeongKuJeKeo"), strScp);
--	ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}ChwiSo"), "SHOP_SOLDED_CANCEL");
--	ui.OpenContextMenu(context);
end
function SHOP_SOLDED_CANCEL()
	imcSound.PlaySoundEvent("button_click");
end
function SHOP_REQ_CANCEL_SELL(index)
	imcSound.PlaySoundEvent("button_click");
	item.ReqCancelSell(index);
end

function SHOP_REQ_DELETE_SOLDITEM(index)
	imcSound.PlaySoundEvent("inven_arrange");
	item.ReqDeleteSoldItem(index);
end

function CLEAR_SOLD_ITEM_LIST(slotSet)

	local slotCount = slotSet:GetSlotCount();
	for i = 0 , slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		SHOP_SLOT_CLEAR(slot);
	end

end

function SHOP_SLOT_CLEAR(slot)

	slot:ClearIcon();
	slot:SetText("");

end
