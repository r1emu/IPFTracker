function EXCHANGE_ON_INIT(addon, frame)

   addon:RegisterMsg('EXCHANGE_START', 'EXCHANGE_MSG_START');
   addon:RegisterMsg('EXCHANGE_UPDATE', 'EXCHANGE_MSG_UPDATE');   
   addon:RegisterMsg('EXCHANGE_CANCEL', 'EXCHANGE_MSG_END');
   addon:RegisterMsg('EXCHANGE_SUCCESS', 'EXCHANGE_MSG_END');
   addon:RegisterMsg('EXCHANGE_AGREE', 'EXCHANGE_MSG_AGREE');
   addon:RegisterMsg('EXCHANGE_FINALAGREE', 'EXCHANGE_MSG_FINALAGREE');
   addon:RegisterMsg('EXCHANGE_REQUEST', 'EXCHANGE_MSG_REQUEST');
   
end 

function EXCHANGE_ON_OPEN(frame)
	packet.RequestItemList(IT_WAREHOUSE);
	INVENTORY_SET_CUSTOM_RBTNDOWN("EXCHANGE_INV_RBTN");
	local myfinalbutton = GET_CHILD_RECURSIVELY(frame,'myfinalagree','ui::CButton');
	local oppfinalbutton = GET_CHILD_RECURSIVELY(frame,'opponentfinalagree','ui::CButton');
	myfinalbutton:SetEnable(0);
	oppfinalbutton:SetEnable(1);
end

function EXCHANGE_ON_CANCEL(frame)
 
	exchange.SendCancelExchangeMsg();

	exchange.ResetExchangeItem();
	local invFrame = ui.GetFrame('inventory')
	UPDATE_INV_LIST(invFrame);	

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
end 

function EXCHANGE_ON_AGREE(frame)
 
 	local itemCount = exchange.GetExchangeItemCount(1);	
	local isEquip = false;
	for  i = 0, itemCount-1 do 		
		local itemData = exchange.GetExchangeItemInfo(1,i);
		local class 			= GetClassByType('Item', itemData.type);
		if class.ItemType == 'Equip' then
			isEquip = true;
		end
	end
	if false == isEquip then
   exchange.SendAgreeExchangeMsg();
	else
		ui.MsgBox(ScpArgMsg("DecreasePotaionByExchangeForBuyer"),"exchange.SendAgreeExchangeMsg()" , "None");		
	end
end 

function EXCHANGE_ON_FINALAGREE(frame)
 
   exchange.SendFinalAgreeExchangeMsg();
end 

function EXCHANGE_MSG_REQUEST(frame)
	ui.MsgBox(ScpArgMsg("Auto_KeoLaeyoCheong_SuLageul_KiDaLiKoissSeupNiDa."));
end

function EXEC_INPUT_EXCHANGE_CNT(frame, inputframe, ctrl)

	if ctrl ~= nil then
		if ctrl:GetName() == "inputstr" then
			inputframe = ctrl;
		end
	end
	
	local inputCnt = tonumber(GET_INPUT_STRING_TXT(inputframe));
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");

	-- ����äũ
	local invItemList = session.GetInvItemList();
	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end

		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		if invItem:GetIESID() == iesid then
			local obj = GetIES(invItem:GetObject());
			local noTrade = TryGetProp(obj, "BelongingCount");
			local tradeCount = invItem.count;
			if nil ~= noTrade then
				local wareItem = session.GetWarehouseItemByType(obj.ClassID);
				local wareCnt = 0;
				if nil ~= wareItem then
					wareCnt = wareItem.count;
				end
				tradeCount = (invItem.count + wareCnt) - noTrade;
				if tradeCount > invItem.count then
					tradeCount = invItem.count;
				end
				if 0 >= tradeCount then
					ui.SysMsg(ClMsg("ItemOverCount"));	
					return;
				end
			end
			if tradeCount >= inputCnt then
				exchange.SendOfferItem(iesid, inputCnt);
			else
				ui.AlarmMsg("ItemOverCount"); -- ��ϼ��� �Һ񰳼����� ŭ
			end
			break;
		end
	end
end

function EXCHANGE_INV_RBTN(itemobj, slot)

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local item = session.GetInvItem(iconInfo.ext);
	if nil ~= item then
		return;
	end

	local obj = GetIES(item:GetObject());
	local noTradeCnt = TryGetProp(obj, "BelongingCount");
	local tradeCount = item.count;
	if noTradeCnt ~= nil then
		local wareItem = session.GetWarehouseItemByType(obj.ClassID);
	local wareCnt = 0;
		if nil ~= wareItem then
			wareCnt = wareItem.count;
		end
		tradeCount = (item.count + wareCnt) - noTradeCnt;
		if tradeCount > item.count then
			tradeCount = item.count;
	end
	end

	EXCHANGE_ADD_FROM_INV(obj, item, tradeCount)
end

function EXCHANGE_ADD_FROM_INV(obj, item, tradeCnt)
	if true == item.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

		if obj.UserTrade == 'NO' then
			ui.AlarmMsg("ItemIsNotTradable");
			return;
		end

		if geItemTable.IsHavePotential(obj.ClassID) == 1 and obj.PR == 0 then
			ui.AlarmMsg("NoPotentialForExchange");
			return;
		end

	if nil ~= string.find(obj.ClassName, "PremiumToken") then
		ui.AlarmMsg("ItemIsNotTradable");
		return;
	end

		local invframe = ui.GetFrame("inventory");
		if item:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_MORU") 
		or item:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_AWAKEN")  
		or item:GetIESID() == invframe:GetUserValue("STONE_ITEM_GUID_IN_AWAKEN") then
			return;
		end
		if geItemTable.IsStack(obj.ClassID) == 1  then
		local noTrade = TryGetProp(obj, "BelongingCount");
		local tradeCount = item.count;
		if nil ~= noTrade then
			local wareItem = session.GetWarehouseItemByType(obj.ClassID);
			local wareCnt = 0;
			if nil ~= wareItem then
				wareCnt = wareItem.count;
			end
			tradeCount = (item.count + wareCnt) - noTrade;
			if tradeCount > item.count then
				tradeCount = item.count;
			end

			if 0 >= tradeCount then
				ui.SysMsg(ClMsg("ItemOverCount"));	
				return;
			end
		end
		
		if tradeCount >= 1 then
			INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_INPUT_EXCHANGE_CNT", tradeCnt, 1, tradeCnt, nil, tostring(item:GetIESID()));
			return;
		else
				ui.AlarmMsg("ItemOverCount"); -- ��ϼ��� �Һ񰳼����� ŭ
			end
		end
	if obj.ItemType == "Equip" then
		local yesScp = string.format("exchange.SendOfferItem(\'%s\', %d)", tostring(item:GetIESID()), 1)
		ui.MsgBox(ScpArgMsg("DecreasePotaionByExchange"),yesScp , "None");		
	else
		exchange.SendOfferItem(tostring(item:GetIESID()), 1);	
	end
			
end

function EXCHANGE_ON_DROP(frame, control, argStr, argNum)
 	
	if 'YES' == frame:GetTopParentFrame():GetUserValue('CLICK_EQUIP_INV_ITEM') then
		ui.SysMsg(ScpArgMsg("Auto_JangChagJungin_aiTemeun_KeoLae_Hal_Su_eopSeupNiDa."));
		frame:GetTopParentFrame():SetUserValue('CLICK_EQUIP_INV_ITEM', 'NO')
		return;
	end

	
	local liftIcon 		= ui.GetLiftIcon();	
	local iconParentFrame = liftIcon:GetTopParentFrame();
				
	if iconParentFrame:GetName() == 'inventory' then 

		local iconInfo = liftIcon:GetInfo();
		local item = session.GetInvItem(iconInfo.ext);

		if item == nil then
			return;
		end

		local obj = GetIES(item:GetObject());
		local noTradeCnt = TryGetProp(obj, "BelongingCount");
		local tradeCount = item.count;
		if noTradeCnt ~= nil then
			local wareItem = session.GetWarehouseItemByType(obj.ClassID);
		local wareCnt = 0;
			if nil ~= wareItem then
				wareCnt = wareItem.count;
		end
			tradeCount = (item.count + wareCnt) - noTradeCnt;
			if tradeCount > item.count then
				tradeCount = item.count;
		end
		
			if 0 >= tradeCount then
				ui.SysMsg(ClMsg("ItemOverCount"));	
				return;
			end
		end
		EXCHANGE_ADD_FROM_INV(obj, item, tradeCount)
			
	elseif iconParentFrame:GetName() == 'wiki' then
		local iconInfo = liftIcon:GetInfo();
		
		if iconInfo.ext == 0 then
			return;
		end
		
		exchange.SendOfferWiki(iconInfo.type);				
	end 	
	
end 

function EXCHANGE_MSG_END(frame, msg, argStr, argNum)
 	
	--local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	--timer:Stop();

	frame:ShowWindow(0);		
end 

function EXCHANGE_INIT_SLOT(frame)
 
	local myslotset = GET_CHILD_RECURSIVELY(frame,'myslot','ui::CSlotSet')
	myslotset:ClearIconAll();
	
	local oppslotset = GET_CHILD_RECURSIVELY(frame,'opponentslot','ui::CSlotSet')
	oppslotset:ClearIconAll();

	local visEdit = GET_CHILD_RECURSIVELY(frame, 'visEdit', "ui::CEditControl");
	visEdit:SetText('0');
	frame:SetUserValue("INPUT_VIS_COUNT", '0');

	local opmoneyText = GET_CHILD_RECURSIVELY(frame, 'opponentVis', 'ui::CRichText');
	opmoneyText:SetTextByKey('money',0);

	local mymoneyText = GET_CHILD_RECURSIVELY(frame, 'myVis', 'ui::CRichText');
	mymoneyText:SetTextByKey('money',0);
end 

function EXCHANGE_MSG_START(frame, msg, argStr, argNum)
 
	EXCHANGE_INIT_SLOT(frame);
	EXCHANGE_RESET_AGREE_BUTTON(frame);
	
	local nameRichText = GET_CHILD_RECURSIVELY(frame,'myname','ui::CRichText');
	local Name = info.GetName(session.GetMyHandle());
	
	nameRichText = GET_CHILD_RECURSIVELY(frame,'opponentname','ui::CRichText');
	nameRichText:SetTextByKey('oppName',argStr)
	
	frame:ShowWindow(1);
	ui.OpenFrame('inventory');
	
	--local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	--timer:SetUpdateScript("CHECK_VIS_INPUT");
	--timer:Start(0.1);
			
end 

function CHECK_VIS_INPUT(frame)

	local preVis = tonumber( frame:GetUserValue("INPUT_VIS_COUNT") );

	local visEdit = GET_CHILD_RECURSIVELY(frame, "visEdit", "ui::CEditControl");
	local myvisTxt = GET_CHILD_RECURSIVELY(frame, "myVis", "ui::CRichText");
	local curVis = tonumber( visEdit:GetText() );

	-- �����Է��ϸ� �ʱ�ȭ���ѹ�����. �ϴ��� �̷���. �Ҽ����Է��Ѱ� �����ұ??
	if curVis == nil then
		frame:SetUserValue("INPUT_VIS_COUNT", '0');
		visEdit:SetText('0');
		curVis = 0;
	end
	
	if preVis ~= curVis then
		
		local myMaxMoney = GET_TOTAL_MONEY();
		if curVis > myMaxMoney then
			curVis = myMaxMoney;
			ui.SysMsg(ScpArgMsg("NotEnoughMoney"));
		end

		local visItem = session.GetInvItemByName('Vis');
		local obj = GetIES(visItem:GetObject());
		exchange.SendOfferItemByClassID(obj.ClassID, curVis);		
		myvisTxt:SetTextByKey('money', GetCommaedText(curVis));
		frame:SetUserValue("INPUT_VIS_COUNT", curVis);
	end	
end

function EXCHANGE_UPDATE_SLOT(slotset,listindex)
 
	slotset:ClearIconAll();
	local frame = ui.GetFrame('exchange');
	local moneyText = GET_CHILD_RECURSIVELY(frame, 'opponentVis', 'ui::CRichText');
	if listindex == 1 then
		moneyText:SetTextByKey('money',0);
	end

	local itemCount = exchange.GetExchangeItemCount(listindex);	
	local index = 0 
	for  i = 0, itemCount-1 do 		
		local itemData = exchange.GetExchangeItemInfo(listindex,i);
		local slot	= slotset:GetSlotByIndex(index);			
		if itemData.tradeType == TRADE_ITEM then
			local class 			= GetClassByType('Item', itemData.type);

			if class.ItemType == 'Unused' and listindex == 1 then
				moneyText:SetTextByKey('money', GetCommaedText(itemData.count));
			elseif class.ItemType ~= 'Unused' then

				local icon = SET_SLOT_ITEM_INFO(slot, class, itemData.count);
				SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, class.ClassName, 'exchange', itemData.type, i * 10 + listindex);

				if listindex == 0 then 
					icon:SetDumpScp('EXCHANGE_DUMP_ICON');	
				end 

				index = index + 1
			end			

		else
			local cls = GetClassByType("Wiki", itemData.itemID);
			SET_SLOT_ICON(slot, cls.Illust);
			local icon = slot:GetIcon();
			icon:SetTextTooltip(	string.format("%s{nl}%s", ClMsg("Recipe"), cls.Desc)  );				
			index = index + 1
		end			
	end
end 

function EXCHANGE_DUMP_ICON(parent, icon, argStr, argNum)
     
    local slot = tolua.cast(parent, "ui::CSlot");
    --print(ScpArgMsg('Auto_BeoLyeo') .. slot:GetSlotIndex());
    exchange.SendRemoveOfferItem(slot:GetSlotIndex());

end 


function EXCHANGE_MSG_UPDATE(frame, msg, argStr, argNum)

	EXCHANGE_RESET_AGREE_BUTTON(frame);
	local myslotSet = GET_CHILD_RECURSIVELY(frame,'myslot','ui::CSlotSet');
	
	EXCHANGE_UPDATE_SLOT(myslotSet,0);
	
	local opslotSet = GET_CHILD_RECURSIVELY(frame,'opponentslot','ui::CSlotSet');
	EXCHANGE_UPDATE_SLOT(opslotSet,1);
	
	local invFrame = ui.GetFrame('inventory')
	UPDATE_INV_LIST(invFrame);
end 

function EXCHANGE_RESET_AGREE_BUTTON(frame)
 
	local mybutton = GET_CHILD_RECURSIVELY(frame,'myagree','ui::CButton');
	mybutton:SetEnable(1);

	local myfinalbutton = GET_CHILD_RECURSIVELY(frame,'myfinalagree','ui::CButton');
	myfinalbutton:SetEnable(0);

	local oppbutton = GET_CHILD_RECURSIVELY(frame,'opponentagree','ui::CButton');
	oppbutton:SetEnable(1);

	local oppfinalbutton = GET_CHILD_RECURSIVELY(frame,'opponentfinalagree','ui::CButton');
	oppfinalbutton:SetEnable(1);
end 

function EXCHANGE_MSG_AGREE(frame, msg, argStr, argNum)
 
	local mybutton = GET_CHILD_RECURSIVELY(frame,'myagree','ui::CButton');
	local oppbutton = GET_CHILD_RECURSIVELY(frame,'opponentagree','ui::CButton');

	if argNum == 0 then 
	   mybutton:SetEnable(0);
	else
	   oppbutton:SetEnable(0);	
	end 

	if mybutton:IsEnable() == 0 and oppbutton:IsEnable() == 0 then
		local myfinalbutton = GET_CHILD_RECURSIVELY(frame,'myfinalagree','ui::CButton');
		local oppfinalbutton = GET_CHILD_RECURSIVELY(frame,'opponentfinalagree','ui::CButton');
		myfinalbutton:SetEnable(1);
		oppfinalbutton:SetEnable(1);
	end
	
	--local timer = GET_CHILD_RECURSIVELY(frame, "addontimer", "ui::CAddOnTimer");
	--timer:Stop();
end 

function EXCHANGE_MSG_FINALAGREE(frame, msg, argStr, argNum)

	if argNum == 0 then 
		local myfinalbutton = GET_CHILD_RECURSIVELY(frame,'myfinalagree','ui::CButton');
	   myfinalbutton:SetEnable(0);
	else 
	   local oppfinalbutton = GET_CHILD_RECURSIVELY(frame,'opponentfinalagree','ui::CButton');
	   oppfinalbutton:SetEnable(0);
	end 

	--local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	--timer:Stop();
end 

