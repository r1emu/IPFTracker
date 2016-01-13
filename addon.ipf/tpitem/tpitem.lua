﻿
-- tpitem.lua : (tp shop)
g_firstValue = nil

function TPITEM_ON_INIT(addon, frame)

	addon:RegisterMsg('TP_SHOP_UI_OPEN', 'TP_SHOP_DO_OPEN');
	addon:RegisterMsg("TPSHOP_BUY_SUCCESS", "ON_TPSHOP_BUY_SUCCESS");

	MAKE_CATEGORY_TREE()

end


function TP_SHOP_DO_OPEN(frame, msg, shopName, argNum)
	
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(1);

end

function ON_TPSHOP_BUY_SUCCESS(frame)

	local previewslotset = GET_CHILD_RECURSIVELY(frame,"previewslotset")
	previewslotset:ClearIconAll();

	local basketslotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	basketslotset:ClearIconAll();

	UPDATE_PREVIEW_APC_IMAGE_N_MONEY(frame)
	UPDATE_BASKET_MONEY(frame)


end


function MAKE_CATEGORY_TREE()

	local frame = ui.GetFrame("tpitem")

	local categorySubGbox = GET_CHILD_RECURSIVELY(frame, "categorySubGbox")
	categorySubGbox:SetUserValue("CTRLNAME", "None");
	local tpitemtree = GET_CHILD(categorySubGbox, "tpitemtree")
	tpitemtree:Clear();
	DESTROY_CHILD_BYNAME(tpitemtree, "TPSHOP_CT_");

	local clsList, cnt = GetClassList('TPitem');	
	if cnt == 0 or clsList == nil then
		return;
	end

	
	for i = 0, cnt - 1 do
	
		local obj = GetClassByIndexFromList(clsList, i);

		local category  = obj.Category;
		local subcategory  = obj.SubCategory;

		local categoryCset = nil;
		categoryCset = GET_CHILD(tpitemtree, "TPSHOP_CT_" .. category )
		
		if categoryCset == nil then -- is equal tpitemtree:FindByName(ctrlSet:GetName()) == nil

			categoryCset = tpitemtree:CreateControlSet("tpshop_tree", "TPSHOP_CT_" .. category, ui.LEFT, 0, 0, 0, 0, 0);
			local part = GET_CHILD(categoryCset, "part");
			part:SetTextByKey("value", ScpArgMsg(category));
			local foldimg = GET_CHILD(categoryCset,"foldimg");
			foldimg:ShowWindow(0);
		end

	
		local htreeitem = tpitemtree:FindByValue(category);
	
		local tempFirstValue = nil

		if tpitemtree:IsExist(htreeitem) == 0 then
			htreeitem = tpitemtree:Add(categoryCset, category);
			tempFirstValue = tpitemtree:GetItemValue(htreeitem)
	
		end

		local hsubtreeitem = tpitemtree:FindByCaption("{@st42b}"..ScpArgMsg(subcategory));
		
		if tpitemtree:IsExist(hsubtreeitem) == 0 and subcategory ~= "None" then

			local added = tpitemtree:Add(htreeitem, "{@st42b}"..ScpArgMsg(subcategory), category.."#"..subcategory, "{#000000}");
			tpitemtree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
			local foldimg = GET_CHILD(categoryCset,"foldimg");
			foldimg:ShowWindow(1);

			tempFirstValue = tpitemtree:GetItemValue(added)
			
		end

		if g_firstValue == nil then
			g_firstValue = tempFirstValue
			
		end

	end
end


function TPITEM_OPEN(frame)

	local tpitemtree = GET_CHILD_RECURSIVELY(frame, "tpitemtree")
	local basketslotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	local previewslotset = GET_CHILD_RECURSIVELY(frame,"previewslotset")

	local basketTP = GET_CHILD_RECURSIVELY(frame,"basketTP")
	

	previewslotset:ClearIconAll();
	basketslotset:ClearIconAll();
	
	UPDATE_PREVIEW_APC_IMAGE_N_MONEY(frame)
	UPDATE_BASKET_MONEY(frame)

	basketTP:SetText(tostring(0))
	

	if g_firstValue ~= nil  then

		local sList = StringSplit(g_firstValue, "#");

		if #sList <= 0 then
			return;
		elseif #sList == 1 then -- 서브카테고리 없음. 그냥 열어라.
			local htreeitem = tpitemtree:FindByValue(g_firstValue);
			
			if tpitemtree:IsExist(htreeitem) == 1 then
				

				if tpitemtree:GetChildItemCount(htreeitem) < 1 then

					TPITEM_DRAW_ITEM(frame, sList[1], "None")
				end
			end
		elseif #sList == 2 then
			-- 서브카테고리 포함해서 열어라
			TPITEM_DRAW_ITEM(frame, sList[1], sList[2])
		end
	end

end

function TPITEM_CLOSE(frame)
	
end

function TPITEM_SELECT_TREENODE(uiobejct, value)

	local obj = uiobejct;
	local selValue = value;

	local frame = ui.GetFrame("tpitem")
	local categorySubGbox = GET_CHILD_RECURSIVELY(frame, "categorySubGbox")
	local btnName = categorySubGbox:GetUserValue("CTRLNAME");
	local tree = GET_CHILD(categorySubGbox, "tpitemtree")
	
	if "None" ~= btnName and obj ~= nil then
		if btnName ~= obj:GetName() then
			local htreeitem = tree:FindByName(btnName);
			local oldObj = tree:GetNodeObject(htreeitem);
			local gBox = oldObj:GetChild("group");
			gBox:SetSkinName("base_btn");
			tree:CloseTreeNode(htreeitem);
		end
	end
	if nil ~= obj then
		categorySubGbox:SetUserValue("CTRLNAME", obj:GetName());
		local gBox = obj:GetChild("group");
		gBox:SetSkinName("baseyellow_btn");
	end

	local sList = StringSplit(selValue, "#");
	
	if #sList <= 0 then
		return;
	elseif #sList == 1 then
		TPITEM_DRAW_ITEM(frame, sList[1], "None") -- 서브카테고리 없음. 그냥 열어라.
	elseif #sList == 2 then
		-- 서브카테고리 포함해서 열어라
		TPITEM_DRAW_ITEM(frame, sList[1], sList[2])
	end

end

function TPITEM_TREE_CLICK(parent, ctrl, str, num)

	local tree = AUTO_CAST(ctrl);
	local tnode = tree:GetLastSelectedNode();
	if tnode == nil then
		return;
	end

	TPITEM_SELECT_TREENODE( tnode:GetObject(), tnode:GetValue())

end

function _GET_IMG_NAME(itemobj)

	local imageName = itemobj.Icon

	if itemobj.ItemType == 'Equip' and itemobj.ClassType == 'Outer' then

		local tempiconname = string.sub(itemobj.Icon,string.len(itemobj.Icon)-1);

		if tempiconname ~= "_m" and tempiconname ~= "_f" then
		local pc = GetMyPCObject();
    	if pc.Gender == 1 then
    		imageName = itemobj.Icon.."_m"
    	else
    		imageName = itemobj.Icon.."_f"			
    	end
	end

		
	end

	return imageName
end

function IS_ITEM_WILL_CHANGE_APC(type)
	
	local item = GetClassByType("Item",type)

	local defaultEqpSlot = TryGetProp(item,'DefaultEqpSlot')

	if defaultEqpSlot == nil then
		return 0
	end

	local pc = GetMyPCObject();
	if pc == nil then
		return 0
	end

	local useGender = TryGetProp(item,'UseGender')

	if useGender =="Male" and pc.Gender ~= 1 then
		return 0
	end

	if useGender =="Female" and pc.Gender ~= 2 then
		return 0
	end
	

	if defaultEqpSlot == "RH" or defaultEqpSlot == "LH" or defaultEqpSlot == "HAT_L" or defaultEqpSlot == "HAT_T" or defaultEqpSlot == "HAIR" or defaultEqpSlot == "HAT" or defaultEqpSlot ==  "OUTER" or defaultEqpSlot ==  "ARMBAND" then
		return 1
	end

	return 0

end

function TPITEM_DRAW_ITEM(frame, category, subcategory)

	local mainText = GET_CHILD_RECURSIVELY(frame,"mainText")

	if subcategory ~= "None" then
		mainText:SetText(ScpArgMsg(category).." > "..ScpArgMsg(subcategory))
	else
		mainText:SetText(ScpArgMsg(category))
	end
	
	
	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox")
	DESTROY_CHILD_BYNAME(mainSubGbox, "eachitem_");

	local clsList, cnt = GetClassList('TPitem');	
	if cnt == 0 or clsList == nil then
		return;
	end

	local index = 0
	local x, y;

	for i = 0, cnt - 1 do
	
		local obj = GetClassByIndexFromList(clsList, i);

		local itemobj = GetClass("Item", obj.ItemClassName)

		if obj.Category == category and obj.SubCategory == subcategory then

			index = index + 1
			x = ( (index-1) % 2) * ui.GetControlSetAttribute("tpshop_item", 'width')
			y = (math.ceil( (index / 2) ) - 1) * (ui.GetControlSetAttribute("tpshop_item", 'height') * 1)
	
			local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_item', 'eachitem_'..index, x, y);

			local title = GET_CHILD_RECURSIVELY(itemcset,"title")
			title:SetText(itemobj.Name)

			local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")

			nxp:SetText(obj.Price)

			local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
			
			SET_SLOT_IMG(slot, _GET_IMG_NAME(itemobj));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', itemobj.ClassID, 0);

			local lv = GETMYPCLEVEL();
			local job = GETMYPCJOB();
			local gender = GETMYPCGENDER();
			local prop = geItemTable.GetProp(itemobj.ClassID);
			local result = prop:CheckEquip(lv, job, gender);

			local desc = GET_CHILD_RECURSIVELY(itemcset,"desc")
			if result == "OK" then
				desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
			else
				desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
			end
			
			local tradeable = GET_CHILD_RECURSIVELY(itemcset,"tradeable")

			if itemobj.UserTrade == "YES" then
				tradeable:ShowWindow(0)
			else
				tradeable:ShowWindow(1)
			end

			local previewbtn = GET_CHILD_RECURSIVELY(itemcset, "previewBtn");

			if itemobj.ItemType  ~= 'Equip' or result ~= "OK" or IS_ITEM_WILL_CHANGE_APC(itemobj.ClassID) ~= 1 then
				previewbtn:ShowWindow(0)
			else
				previewbtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemobj.ClassID);
				previewbtn:SetEventScriptArgString(ui.LBUTTONUP, obj.ClassName);
			end

			local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");
			buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemobj.ClassID);
			buyBtn:SetEventScriptArgString(ui.LBUTTONUP, obj.ClassName);

		end

	end

	--mainSubGbox:Resize(mainSubGbox:GetOriginalWidth(), y + ui.GetControlSetAttribute("tpshop_item", 'height'))
	
	mainSubGbox:Invalidate()

	frame:Invalidate()

end

function TPSHOP_ITEM_PREVIEW(parent, control, tpitemname, classid)	

	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local allowDup = TryGetProp(item,'AllowDuplicate')
				
	if allowDup == "NO" then
		if session.GetInvItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
		if session.GetEquipItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
		if session.GetWarehouseItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
	end

	local frame = parent:GetTopParentFrame()
	local slotset = GET_CHILD_RECURSIVELY(frame,"previewslotset")
	local slotCount = slotset:GetSlotCount();

	if item.ItemType  == 'Equip' then -- 그리고 펫도 해야함. 그리고 헤어도 해야함

		for i = 0, slotCount - 1 do
			local slotIcon	= slotset:GetIconByIndex(i);

			if slotIcon ~= nil then

				local slot  = slotset:GetSlotByIndex(i);
				local classname = slot:GetUserValue("CLASSNAME");
				local alreadyItem = GetClass("Item",classname)

				if alreadyItem ~= nil and item.DefaultEqpSlot == alreadyItem.DefaultEqpSlot then
					
					slot:ClearText();
					slot:ClearIcon();
					slot:SetUserValue("CLASSNAME", "None");
					slot:SetUserValue("TPITEMNAME", "None");
					break;
				end

			end
		end

	end

	local nodupliItems = {}
	nodupliItems[tpitemname] = true;

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("TPitem",classname)

			if alreadyItem ~= nil then

				local item = GetClass("Item", alreadyItem.ItemClassName)
				local allowDup = TryGetProp(item,'AllowDuplicate')

				if allowDup == "NO" then
		
					if nodupliItems[classname] == nil then
						nodupliItems[classname] = true
					else
						ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
						return;
					end

				end
			
			end

		end
	end

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_PREVIEWSLOT_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, classid);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", tpitemname);

			SET_SLOT_IMG(slot, _GET_IMG_NAME(item));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);

			break;

		end
	end

	UPDATE_PREVIEW_APC_IMAGE_N_MONEY(frame)
	
end

function TPSHOP_PREVIEWSLOT_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_PREVIEW_APC_IMAGE_N_MONEY(parent:GetTopParentFrame())

end

function UPDATE_PREVIEW_APC_IMAGE_N_MONEY(frame)

	local slotset = GET_CHILD_RECURSIVELY(frame,"previewslotset")
	local slotCount = slotset:GetSlotCount();

	local pcSession = session.GetMySession();
	if pcSession == nil then
		return
	end

	local apc = pcSession:GetPCDummyApc();
	
	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);

			local classname = slot:GetUserValue("CLASSNAME");
			local alreadyItem = GetClass("Item",classname)

			if alreadyItem ~= nil then

				local defaultEqpSlot = TryGetProp(alreadyItem,'DefaultEqpSlot')
				
				if defaultEqpSlot ~= nil then
					apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), alreadyItem.ClassID)
				end
				
			end

			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local tpitem = GetClass("TPitem", tpitemname)

			if tpitem ~= nil then

				allprice = allprice + tpitem.Price
				
			end

		end
	end
	local shihouette = GET_CHILD_RECURSIVELY(frame,"shihouette")
	local imgName = ui.CaptureMyFullStdImageByAPC(apc);
	shihouette:SetImage(imgName)

	local previewTP = GET_CHILD_RECURSIVELY(frame,"previewTP")
	previewTP:SetText(tostring(allprice))


	frame:Invalidate();

end

function TPSHOP_ITEM_PREVIEW_BUY(parent)

	ui.MsgBox(ScpArgMsg("ReallyBuy?"), string.format("EXEC_BUY_MARKET_ITEM(%d)", 1), "None");

	DISABLE_BUTTON_DOUBLECLICK("tpitem","previewSetBuyBtn")

end

function TPSHOP_ITEM_BASKET_BUY(parent)

	ui.MsgBox(ScpArgMsg("ReallyBuy?"), string.format("EXEC_BUY_MARKET_ITEM(%d)", 2), "None");

	DISABLE_BUTTON_DOUBLECLICK("tpitem","basketBuyBtn")

end

function EXEC_BUY_MARKET_ITEM(slotsettype)

	local slotsetname = nil
	local itemListStr = ""

	if slotsettype == 1 then
		slotsetname = "previewslotset"
	else
		slotsetname = "basketslotset"
	end

	local frame = ui.GetFrame("tpitem")
	local slotset = GET_CHILD_RECURSIVELY(frame,slotsetname)
	if slotset == nil then
		return;
	end

	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local tpitem = GetClass("TPitem",tpitemname)

			if tpitem ~= nil then
							
				allprice = allprice + tpitem.Price

				if itemListStr == "" then
					itemListStr = tostring(tpitem.ClassID)
				else
					itemListStr = itemListStr .." " .. tostring(tpitem.ClassID)
				end
				
			else
				return
			end

		end
	end

	if allprice == 0 then
		return
	end

	if GET_CASH_TOTAL_POINT_C() < allprice then 
		ui.MsgBox(ScpArgMsg("Auto_MeDali_BuJogHapNiDa."))
		return;
	end

	pc.ReqExecuteTx_NumArgs("SCR_TX_TP_SHOP", itemListStr);

end


function TPSHOP_ITEM_TO_BASKET(parent, control, tpitemname, classid)	

	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local allowDup = TryGetProp(item,'AllowDuplicate')
				
	if allowDup == "NO" then
		if session.GetInvItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
		if session.GetEquipItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
		if session.GetWarehouseItemByType(classid) ~= nil then
			ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
			return;
		end
	end

	if IS_EQUIP(item) == true then
		local lv = GETMYPCLEVEL();
		local job = GETMYPCJOB();
		local gender = GETMYPCGENDER();
		local prop = geItemTable.GetProp(classid);
		local result = prop:CheckEquip(lv, job, gender);

		if result ~= "OK" then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end

		local pc = GetMyPCObject();
		if pc == nil then
			return;
		end

		local useGender = TryGetProp(item,'UseGender')

		if useGender =="Male" and pc.Gender ~= 1 then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end

		if useGender =="Female" and pc.Gender ~= 2 then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end
	end

	local frame = parent:GetTopParentFrame()
	local slotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	local slotCount = slotset:GetSlotCount();

	local nodupliItems = {}
	nodupliItems[tpitemname] = true;

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("TPitem",classname)

			if alreadyItem ~= nil then

				local item = GetClass("Item", alreadyItem.ItemClassName)
				local allowDup = TryGetProp(item,'AllowDuplicate')
				
				if allowDup == "NO" then
		
					if nodupliItems[classname] == nil then
						nodupliItems[classname] = true
					else
						ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
						return;
					end

				end
			
			end

		end
	end


	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_BASKETSLOT_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, classid);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", tpitemname);

			SET_SLOT_IMG(slot, _GET_IMG_NAME(item));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);

			break;

		end
	end

	UPDATE_BASKET_MONEY(frame)
	
end

function TPSHOP_BASKETSLOT_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_BASKET_MONEY(parent:GetTopParentFrame())

end

function UPDATE_BASKET_MONEY(frame)

	local slotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	local slotCount = slotset:GetSlotCount();

	local pcSession = session.GetMySession();
	if pcSession == nil then
		return
	end

	local apc = pcSession:GetPCDummyApc();
	
	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("TPitem",classname)

			if alreadyItem ~= nil then

				allprice = allprice + alreadyItem.Price
			
			end

		end
	end

	local basketTP = GET_CHILD_RECURSIVELY(frame,"basketTP")
	basketTP:SetText(tostring(allprice))

	local accountObj = GetMyAccountObj();

	local haveTP = GET_CHILD_RECURSIVELY(frame,"haveTP")
	haveTP:SetText(tostring(GET_CASH_TOTAL_POINT_C()))

	local remainTP = GET_CHILD_RECURSIVELY(frame,"remainTP")
	remainTP:SetText(tostring(GET_CASH_TOTAL_POINT_C() - allprice))

	frame:Invalidate();

en