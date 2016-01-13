-- briquetting.lua

function BRIQUETTING_ON_INIT(addon, frame)

end

function BRIQUETTING_SET_SKILLTYPE(frame, skillName, skillLevel)
	frame:SetUserValue("SKILLNAME", skillName)
	frame:SetUserValue("SKILLLEVEL", skillLevel)
end

function BRIQUETTING_UI_CLOSE()
	ui.CloseFrame("briquetting");	
end

function BRIQUETTING_SLOT_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_RESET(frame);
end

function BRIQUETTIN_MAX_MIN_TEXT(nowPower, min, max)
	return string.format("%d > {#FF0000}%d ~ {#00FF00}%d", nowPower, min, max);
end

function BRIQUETTING_SLOT_SET(richtxt, item)
	if nil == item then
		richtxt:SetTextByKey("guid", "");
		richtxt:SetTextByKey("itemtype", "");
		return;
	end
	richtxt:SetTextByKey("guid", item:GetIESID());
	richtxt:SetTextByKey("itemtype", item.type);
end

function BRIQUETTING_SLOT_DROP(parent, ctrl)
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- ���� �ڽ��� �̹����� �ְ�
	local itemCls = GetClassByType("Item", invItem.type);
	
	SET_SLOT_ITEM_IMANGE(slot, invItem);

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return nil;
	end
	-- ���� ���ݷ�, ������ ���� object�� �����.
	local tempObj = CreateIESByID("Item", itemCls.ClassID);
	if nil == tempObj then
		return;
	end
	local refreshScp = tempObj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(tempObj);
	end	

	local frame				= parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext      = bodyGBox:GetChild("slotName");
	bodyGBox:RemoveChild('tooltip_only_pr');

	-- �̸��� ǥ���Ѵ�.
	slotNametext:SetTextByKey("txt", obj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);

	-- ���� �ִ�, �ּ� ���ݷ�, ���ټ���ǥ���Ѵ�.

	-- ��Ʈ�� ������ ����Ǿ��ִ� ���ټ��� ������ ���� bodx�� ���δ�.
	local nowPotential = bodyGBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 40, 290);
	tolua.cast(nowPotential, "ui::CControlSet");
	-- ��Ʈ�Ѽ� ui�� �ִ� pr_gauge�� ã�� ���� ���ټȰ� ���� ���ټ��� ǥ���ϰ�
	local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(obj.PR, tempObj.PR);
	-- pr_txt�� ���� ���⼭ ���� �ʿ䰡 ����.
	local pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
	pr_txt:SetVisible(0);

	-- �ִ�, �ּҸ� �ۼ��ϰ��� �ش� �׸��� �Ӽ��� ������ �ɴϴ�.
	local minPowerStr = bodyGBox:GetChild("minPowerStr");
	local maxPowerStr = bodyGBox:GetChild("maxPowerStr");

	-- � Ÿ���� ���������� Ȯ���ϴ� �Ӽ��� �����մϴ�.
	-- �� �Լ��� ���ø� ���⿡ ���� ����� �ִ�, �ּҰ��ݷ���
	-- �������ݷ��� ����� �������ݷ°�  ��  ���ڸ� �����մϴ�.
	local prop1, prop2 = GET_ITEM_PROPERT_STR(obj);
	
	-- ���� ������ ���� ����, param1�� ������ Ű���� �������ݴϴ�.
	minPowerStr:SetTextByKey("txt", prop2);
	maxPowerStr:SetTextByKey("txt", prop1);
	
	local checkValue = _G["ALCHEMIST_VALUE_" .. frame:GetUserValue("SKILLNAME")];
	-- �̰��� ������ �ִ� �ּ��� ��ġ�� ǥ���ϰ��� �ϴ� �Ӽ��Դϴ�.
	local maxPower = bodyGBox:GetChild("maxPower");
	local minPower = bodyGBox:GetChild("minPower");
	if obj.BasicTooltipProp == "ATK" then
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MAXATK); -- �ִ�
		maxPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MAXATK, min, max));
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MINATK); -- �ּ�
		minPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MINATK, min, max));

	elseif obj.BasicTooltipProp == "MATK" then -- �������ݷ�
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MATK);
		maxPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MATK, min, max));
		minPower:SetTextByKey("txt", prop2);
	end

	local checkValue = _G["ALCHEMIST_NEEDITEM_" .. frame:GetUserValue("SKILLNAME")];
	local name, count = checkValue(GetMyPCObject(), tempObj);
	BRIQUETTING_REFRESH_MATERIAL(frame, count .. " " ..ClMsg("CountOfThings"));
	DestroyIES(tempObj);
end

function BRIQUETTING_SPEND_DROP(parent, ctrl)
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- ���� �ڽ��� �̹����� �ְ�
	SET_SLOT_ITEM_IMANGE(slot, invItem);
	local frame				= parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext		= bodyGBox:GetChild("spendName");

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return nil;
	end
	-- �̸��� ǥ���Ѵ�.
	slotNametext:SetTextByKey("txt", obj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);
end

function BRIQUETTING_SKILL_EXCUTE(parent)
	local frame = parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext		= bodyGBox:GetChild("spendName");
	local mainSlotName      = bodyGBox:GetChild("slotName");

	Alchemist.ExcuteBriquetting(mainSlotName:GetTextByKey("guid"), slotNametext:GetTextByKey("guid"));
end

function BRIQUETTING_SPEND_POP(parent)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_SPEND_RESET(frame);
end

function BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return nil;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return nil;
	end
	
	if iconInfo == nil or invItem == nil then
		return nil;
	end

	local checkItem = _G["ALCHEMIST_CHECK_" .. frame:GetUserValue("SKILLNAME")];
	local obj = GetIES(invItem:GetObject())
	if 1 ~= checkItem(GetMyPCObject(), obj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return nil;
	end
	
	if 0 > obj.PR then
		ui.SysMsg(ClMsg("NoMorePotential"));
	end

	-- ���� �ɸ� ���� ��ġ���� �ʴ��� Ȯ���Ѵ�.
	local bodyGBox = frame:GetChild("bodyGbox");
	local mainSlotName      = bodyGBox:GetChild("slotName");
	local slotNametext		= bodyGBox:GetChild("spendName");

	if slotNametext:GetTextByKey("guid") == invItem:GetIESID() or
	  mainSlotName:GetTextByKey("guid") == invItem:GetIESID() then 
		--�׽�Ʈ ����: ���������� �������� ����� �� �����ϴ�.
		ui.SysMsg(ClMsg("CantRegisterSameTypeGoods"));
		return nil;
	end

	local MainType = mainSlotName:GetTextByKey("itemtype");
	local spendType = slotNametext:GetTextByKey("itemtype");

	-- ���ΰ� �Һ���� �� ��..
	local mainCls = GetClassByType("Item", MainType);
	local spendCls = GetClassByType("Item", spendType);
	if nil ~= mainCls and mainCls.ItemStar > obj.ItemStar or
		nil ~= spendCls and spendCls.ItemStar > obj.ItemStar then
		ui.SysMsg(ClMsg("LowWeaponStar"));
		return nil;
	end

	return invItem;
end

function BRIQUETTING_UI_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot  = bodyGBox:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();
	
	local slotName = bodyGBox:GetChild("slotName");
	slotName:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotName);

	local maxPowerStr = bodyGBox:GetChild("maxPowerStr");
	local minPowerStr = bodyGBox:GetChild("minPowerStr");
	local maxPower = bodyGBox:GetChild("maxPower");
	local minPower = bodyGBox:GetChild("minPower");
	maxPowerStr:SetTextByKey("txt", "");
	maxPowerStr:SetTextByKey("txt", "");
	minPowerStr:SetTextByKey("txt", "");
	maxPower:SetTextByKey("txt", "");
	minPower:SetTextByKey("txt", "");
	bodyGBox:RemoveChild('tooltip_only_pr');

	BRIQUETTING_UI_SPEND_RESET(frame);
	BRIQUETTING_REFRESH_MATERIAL(frame, "");
end 

function BRIQUETTING_UI_SPEND_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot  = bodyGBox:GetChild("slot2");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local slotNametext		= bodyGBox:GetChild("spendName");
	slotNametext:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotNametext);
end

function BRIQUETTING_REFRESH_MATERIAL(frame, spendUI)
	local bodyGBox = frame:GetChild("bodyGbox");
	local materiaICount = bodyGBox:GetChild("materiaICount");
	local metarialName = bodyGBox:GetChild("metarialName");
	local materiaIimage = bodyGBox:GetChild("materiaIimage");
	
	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ALCHEMIST_MATERIAL_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(invItemList);
	local cls = GetClass("Item", name);
	local txt = GET_ITEM_IMG_BY_CLS(cls, 60);
	materiaIimage:SetTextByKey("txt", txt);
	metarialName:SetTextByKey("txt", cls.Name);
	local text = cnt .. " " .. ClMsg("CountOfThings");
	materiaICount:SetTextByKey("txt", text);

	local spendCount = bodyGBox:GetChild("spendCount");
	spendCount:SetTextByKey("txt", spendUI);
end

function ALCHEMIST_BRIQUE_SUCCEED()
	local frame = ui.GetFrame("briquetting");
	if nil == frame then
		return;
	end
	BRIQUETTING_UI_RESET(frame);
en