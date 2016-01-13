-- sequentialpickitem.lua

SEQUENTIALPICKITEM_openCount = 0;
SEQUENTIALPICKITEM_alreadyOpendGUIDs = {};

function SEQUENTIALPICKITEM_ON_INIT(addon, frame)

	addon:RegisterMsg('INV_ITEM_IN', 'SEQUENTIAL_PICKITEMON_MSG');
	addon:RegisterMsg('INV_ITEM_ADD', 'SEQUENTIAL_PICKITEMON_MSG');
	
end

function SEQUENTIAL_PICKITEMON_MSG(frame, msg, arg1, type, class)

	if msg == 'INV_ITEM_ADD' then
		if arg1 == 'UNEQUIP' then
			return
		end
		
		local invitem = session.GetInvItem(type);
		if class == nil then
			class = GetClassByType("Item",	invitem.prop.type)
		end
		local tablekey = invitem:GetIESID().."_"..invitem.count

		if SEQUENTIALPICKITEM_alreadyOpendGUIDs[tablekey] == nil then
			SEQUENTIALPICKITEM_alreadyOpendGUIDs[tablekey] = "AlreadyOpen"
			ADD_SEQUENTIAL_PICKITEM(frame, msg, invitem:GetIESID(), invitem.count, class, tablekey, invitem.fromWareHouse)
		end

	elseif msg == 'INV_ITEM_IN' then

		local count = type
		local invitem = session.GetInvItemByGuid(arg1);

		local tablekey = arg1.."_"..invitem.count
		
		if SEQUENTIALPICKITEM_alreadyOpendGUIDs[tablekey] == nil then
			SEQUENTIALPICKITEM_alreadyOpendGUIDs[tablekey] = "AlreadyOpen"
			ADD_SEQUENTIAL_PICKITEM(frame, msg, arg1, count, class, tablekey)
		end

	end

	
end

function SEQUENTIALPICKITEM_OPEN(frame)

	local index = string.find(frame:GetName(), "SEQUENTIAL_PICKITEM_");
	local frameindex = string.sub(frame:GetName(), index + string.len("SEQUENTIAL_PICKITEM_"), string.len(frame:GetName()))
	local nowcount = tonumber(frameindex);

	for i = nowcount, 0, -1 do
		local beforeFrameName = "SEQUENTIAL_PICKITEM_"..tostring(i);
		local beforeframe = ui.GetFrame(beforeFrameName)
		if beforeframe == nil then
			break;
		end

		local PUSHUP_ANIM_NAME = frame:GetUserConfig("PUSHUP_ANIM_NAME")
		UI_PLAYFORCE(beforeframe, PUSHUP_ANIM_NAME);
	end

end

function SEQUENTIALPICKITEM_CLOSE(frame)

	local tablekey = frame:GetUserValue("ITEMGUID_N_COUNT")
	SEQUENTIALPICKITEM_alreadyOpendGUIDs[tablekey] = nil

	ui.DestroyFrame(frame:GetName());

end

function ADD_SEQUENTIAL_PICKITEM(frame, msg, itemGuid, itemCount, class, tablekey, fromWareHouse)
	if class.ItemType == 'Unused' then
		return
	end

	local wiki = session.GetWikiByName(class.ClassName);

	SEQUENTIALPICKITEM_openCount = SEQUENTIALPICKITEM_openCount + 1;
	local frameName = "SEQUENTIAL_PICKITEM_"..tostring(SEQUENTIALPICKITEM_openCount);

	ui.DestroyFrame(frameName);

	local frame = ui.CreateNewFrame("sequentialpickitem", frameName);
	if frame == nil then
		return nil;
	end

	
	frame:SetUserValue("ITEMGUID_N_COUNT",tablekey)
	
	local duration = tonumber(frame:GetUserConfig("POPUP_DURATION"))


	local PickItemGropBox	= GET_CHILD(frame,'pickitem')
	PickItemGropBox:RemoveAllChild();

	-- ControlSet 이름 설정
	local img = class.Icon;

	if class.ItemType == 'Equip' and class.ClassType == 'Outer' then

		local tempiconname = string.sub(img,string.len(img)-1);

		if tempiconname ~= "_m" and tempiconname ~= "_f" then
    	local pc = GetMyPCObject();
    	local gender = pc.Gender;
    	
    	if gender == 1 then
    	    img = img.."_m"
    	else
    	    img = img.."_f"
	    end
	end
	
    	
	end
	
	local PickItemCountObj		= PickItemGropBox:CreateControlSet('pickitemset_Type', 'pickitemset', 0, 0);
	local PickItemCountCtrl		= tolua.cast(PickItemCountObj, "ui::CControlSet");
	--PickItemCountCtrl:SetGravity(ui.LEFT, ui.TOP);

	local ConSetBySlot 	= PickItemCountCtrl:GetChild('slot');
	local slot			= tolua.cast(ConSetBySlot, "ui::CSlot");
	local icon = CreateIcon(slot);
	local iconName = img;

	icon:Set(iconName, 'PICKITEM', itemCount, 0);

	-- 아이템 이름과 획득량 출력
	local printName	 = '{@st41}' ..GET_FULL_NAME(class);
	local printCount = '{@st41b}'..ScpArgMsg("GetByCount{Count}", "Count", itemCount);

	PickItemCountCtrl:SetTextByKey('ItemName', printName);
	PickItemCountCtrl:SetTextByKey('ItemCount', printCount);
	
	local AddWiki = GET_CHILD(PickItemCountCtrl,'AddWiki')

	if wiki ~= nil and false == fromWareHouse then	

		if wiki:GetIntProp("Total") ~= nil then

		local totalCount = wiki:GetIntProp("Total").propValue;

		if totalCount > 1 then
			AddWiki:ShowWindow(0)
		else
			AddWiki:ShowWindow(1)
		end

	else
		AddWiki:ShowWindow(0)
	end

	else
		AddWiki:ShowWindow(0)
	end


	-- 아이템이름 너무길때 짤려서 resize 일단 셋팅.
	--PickItemGropBox:Resize(250, 120);
	--frame:Resize(250, 120);
	local textLen = string.len(printName);
	local rate = 6;
	if textLen < 20 then
		rate = 2;
	end
	--PickItemGropBox:Resize(PickItemGropBox:GetWidth() + (textLen*rate), PickItemGropBox:GetHeight());
	--frame:Resize(PickItemGropBox:GetWidth() + (textLen*rate), PickItemGropBox:GetHeight());

	PickItemGropBox:UpdateData();
	PickItemGropBox:Invalidate();

	--내용 끝

	frame:ShowWindow(1);
	frame:SetDuration(duration);
	frame:Invalidate();
end