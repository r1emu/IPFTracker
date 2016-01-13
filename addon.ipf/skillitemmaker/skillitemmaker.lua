function SKILLITEMMAKER_ON_INIT(addon, frame)
end

function SKILLITEMMAKER_FIRST_OPEN(frame)
	SKILLITEMMAKER_REGISTER(frame, 0);
end

function POP_SKILLITEM_MAKER(frame)
	SKILLITEMMAKER_REGISTER(frame, 0)
end

function DROP_SKILLITEM_MAKER(frame, icon, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();

	if iconInfo.category == "Skill" then
		SKILLITEMMAKER_REGISTER(toFrame, iconInfo.type);
	end
end

function CLEAR_SKILLITEMMAKER(frame)
	frame:GetChild("skilltext"):SetTextByKey("value", "");
	frame:GetChild("skilllevel"):SetTextByKey("value", "");
	frame:GetChild("skillname"):SetTextByKey("value", "");
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(skill_slot);
	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", "");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(matslot);
end

function SKILLITEMMAKER_REGISTER(frame, skillType)
	local resultItem = GET_CHILD(frame, "slot_result", "ui::CSlot");
	local resultCls = GetClass("Item", "Scroll_SkillItem");
	SET_SLOT_ITEM_CLS(resultItem, resultCls);
	frame:GetChild("progtime"):SetTextByKey("value", "0");

	local sklCls = GetClassByType("Simony", skillType);

	if sklCls == nil or 'YES' ~= sklCls.CanMake then
	    ui.SysMsg(ClMsg("CanNotCraftSkill"));
		CLEAR_SKILLITEMMAKER(frame);
		_SKILLITEMMAKE_RESET(frame);
		return;
	end
	
	local skillInfo = session.GetSkill(skillType);
	local sklObj = GetIES(skillInfo:GetObject());
	SET_SKILL_TOOLTIP_BY_TYPE_LEVEL(resultItem:GetIcon(), skillType, sklObj.Level);

	frame:SetUserValue("SKILLTYPE", skillType);
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	
	SET_SLOT_SKILL(skill_slot, sklObj)

	local mySimonySkill = GetSkill(GetMyPCObject(), 'Pardoner_Simony');
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	droplist_level:ClearItems();
	local count = mySimonySkill.Level;

		-- ���� ��ų��, �ø�� ���� ���� Ŭ��
	if sklObj.Level >= mySimonySkill.Level then
		count = mySimonySkill.Level;
	elseif sklObj.Level < mySimonySkill.Level then
		count = sklObj.Level;
	end

	 for i = 1 , count do
	 	droplist_level:AddItem(i,  "{@st42}" .. ClMsg("Level") .. " " .. i, 0);
	 end
	 -- ��ų ���� ����
	 droplist_level:SelectItem(count-1);
	 droplist_level:SetSelectedScp("SKILLITEMMAKE_DROPLISTCHANGE");
	if sklObj.Caption == "None" then
		frame:GetChild("skilltext"):SetTextByKey("value", "");
	else
		frame:GetChild("skilltext"):SetTextByKey("value", sklObj.Caption);		
	end
	
	-- �ø�� ������ŭ �� ��
	frame:GetChild("skilllevel"):SetTextByKey("value", count);
	frame:GetChild("skillname"):SetTextByKey("value", sklObj.Name);

	local vis = GET_SKILL_MAT_PRICE(sklObj, sklObj.Level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local bottleCls = GetClass("Item", bottle);
	local matDesc = ClMsg("Material") .. " : ";
	matDesc = matDesc .. GET_MONEY_IMG(36) .. vis;
	matDesc = matDesc .. "   {img " .. bottleCls.Icon .. " 36 36} " .. bottleCnt;

	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", matDesc);
	
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	SET_SLOT_ITEM_CLS(matslot, bottleCls);
	
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	makecount:SetNumChangeScp("SKILLITEMKAE_NUMCHANGE");
	makecount:SetNumberValue(1);
	-- ��� �� ���������?
	makecount:SetIncrValue(1);
	UPDATE_SKILLITEMMAKE_PRICE(frame);

end

function SKILLITEMMAKE_GET_SKL_OBJ(frame)
	local skillType= frame:GetUserIValue("SKILLTYPE");
	local skillInfo = session.GetSkill(skillType);
	return GetIES(skillInfo:GetObject());
end

function SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame)

	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local vis = GET_SKILL_MAT_PRICE(sklObj, sklObj.Level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local totalVis = curCount * vis;
	local totalBottle = curCount * bottleCnt;
	return totalVis, totalBottle;
end

function UPDATE_SKILLITEMMAKE_PRICE(frame)
	local totalprice = frame:GetChild("totalprice");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");

	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame);
	totalprice:SetTextByKey("value", GetCommaedText(totalVis));
	matslot:SetText('{s20}{ol}{b}'..totalBottle, 'count', 'right', 'bottom', -2, 1);

	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local makeSec = GET_SKILL_ITEM_MAKE_TIME(sklObj, curCount);
	local progtime = frame:GetChild("progtime");
	progtime:SetTextByKey("value", makeSec);
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
    gauge:SetPoint(0, 100);
end

function SKILLITEM_MAKE_START(sec)
	local frame = ui.GetFrame("skillitemmaker");
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
	gauge:SetPoint(0, 100);
    gauge:SetPointWithTime(100, sec, 1);
	
end

function SKILLITEMKAE_NUMCHANGE(parent)
	UPDATE_SKILLITEMMAKE_PRICE(parent:GetTopParentFrame());
end

function SKILLITEMMAKE_DROPLISTCHANGE(parent)
	local frame = parent:GetTopParentFrame();
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	frame:GetChild("skilllevel"):SetTextByKey("value", droplist_level:GetSelItemIndex()+1);
end

function SKILLITEMMAKE_EXEC(frame)
	-- ��ų����� �ȵ��־�!
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	if nil == IS_CLEAR_SLOT_ITEM_INFO(skill_slot) then
		print("skill regit NO");
		return;
	end

	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	if 0 == makecount:GetNumber() then
		print("count 0");
		return;
	end


	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame);
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local bottleCls = GetClass("Item", bottle);
	local visCls = GetClass("Item", "Vis");
	local myVis = session.GetInvItemCountByType(visCls.ClassID);
	local myBottle = session.GetInvItemByName(bottleCls.ClassName);
	if myVis < totalVis or nil == myBottle then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	if true == myBottle.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if myBottle.count < totalBottle  then
		ui.SysMsg(ClMsg("NotEnoughRecipe"));
		return;
	end

	ui.MsgBox(ClMsg("ReallyManufactureItem?"), "_SKILLITEMMAKE_EXEC", "None");
end

function SKILLITEMMAKER_FIRST_OPEN(frame)
	SKILLITEMMAKER_REGISTER(frame, 0);
end

function POP_SKILLITEM_MAKER(frame)
	_SKILLITEMMAKE_RESET(frame)
end

function DROP_SKILLITEM_MAKER(frame, icon, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();

	if iconInfo.category == "Skill" then
		SKILLITEMMAKER_REGISTER(toFrame, iconInfo.type);
	end
end

function CLEAR_SKILLITEMMAKER(frame)
	frame:GetChild("skilltext"):SetTextByKey("value", "");
	frame:GetChild("skilllevel"):SetTextByKey("value", "");
	frame:GetChild("skillname"):SetTextByKey("value", "");
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	skill_slot:ClearIcon();

	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", "");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	matslot:ClearIcon();
end

function SKILLITEMMAKER_REGISTER(frame, skillType)
	local resultItem = GET_CHILD(frame, "slot_result", "ui::CSlot");
	local resultCls = GetClass("Item", "Scroll_SkillItem");
	SET_SLOT_ITEM_CLS(resultItem, resultCls);
	frame:GetChild("progtime"):SetTextByKey("value", "0");

	local sklCls = GetClassByType("Simony", skillType);

	if sklCls == nil or 'YES' ~= sklCls.CanMake then
	    ui.SysMsg(ClMsg("CanNotCraftSkill"));
		CLEAR_SKILLITEMMAKER(frame);
		_SKILLITEMMAKE_RESET(frame);
		return;
	end
	
	local skillInfo = session.GetSkill(skillType);
	local sklObj = GetIES(skillInfo:GetObject());

	frame:SetUserValue("SKILLTYPE", skillType);
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	
	local type = sklObj.ClassID;
	local icon = CreateIcon(skill_slot);
	local imageName = 'icon_' .. sklObj.Icon;
	icon:Set(imageName, "Skill", sklObj.ClassID, 0);
	SET_SKILL_TOOLTIP_BY_TYPE(icon, type);
	icon:ClearText();

	local mySimonySkill = GetSkill(GetMyPCObject(), 'Pardoner_Simony');
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	droplist_level:ClearItems();
	local count = mySimonySkill.Level;

		-- ���� ��ų��, �ø�� ���� ���� Ŭ��
	if sklObj.Level >= mySimonySkill.Level then
		count = mySimonySkill.Level;
	elseif sklObj.Level < mySimonySkill.Level then
		count = sklObj.Level;
	end

	 for i = 1 , count do
	 	droplist_level:AddItem(i,  "{@st42}" .. ClMsg("Level") .. " " .. i, 0);
	 end
	 -- ��ų ���� ����
	 droplist_level:SelectItem(count-1);
	 droplist_level:SetSelectedScp("SKILLITEMMAKE_DROPLISTCHANGE");
	if sklObj.Caption == "None" then
		frame:GetChild("skilltext"):SetTextByKey("value", "");
	else
		frame:GetChild("skilltext"):SetTextByKey("value", sklObj.Caption);		
	end
	
	-- �ø�� ������ŭ �� ��
	frame:GetChild("skilllevel"):SetTextByKey("value", count);
	frame:GetChild("skillname"):SetTextByKey("value", sklObj.Name);

	local vis = GET_SKILL_MAT_PRICE(sklObj, sklObj.Level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local bottleCls = GetClass("Item", bottle);
	local matDesc = ClMsg("Material") .. " : ";
	matDesc = matDesc .. GET_MONEY_IMG(36) .. vis;
	matDesc = matDesc .. "   {img " .. bottleCls.Icon .. " 36 36} " .. bottleCnt;

	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", matDesc);
	
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	SET_SLOT_ITEM_CLS(matslot, bottleCls);
	
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	makecount:SetNumChangeScp("SKILLITEMKAE_NUMCHANGE");
	makecount:SetNumberValue(1);
	-- ��� �� ���������?
	makecount:SetIncrValue(1);
	UPDATE_SKILLITEMMAKE_PRICE(frame);

end

function SKILLITEMMAKE_GET_SKL_OBJ(frame)
	local skillType= frame:GetUserIValue("SKILLTYPE");
	local skillInfo = session.GetSkill(skillType);
	return GetIES(skillInfo:GetObject());
end

function SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame)

	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local vis = GET_SKILL_MAT_PRICE(sklObj, sklObj.Level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local totalVis = curCount * vis;
	local totalBottle = curCount * bottleCnt;
	return totalVis, totalBottle;
end

function UPDATE_SKILLITEMMAKE_PRICE(frame)
	local totalprice = frame:GetChild("totalprice");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");

	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame);
	totalprice:SetTextByKey("value", GetCommaedText(totalVis));
	matslot:SetText('{s20}{ol}{b}'..totalBottle, 'count', 'right', 'bottom', -2, 1);

	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local makeSec = GET_SKILL_ITEM_MAKE_TIME(sklObj, curCount);
	local progtime = frame:GetChild("progtime");
	progtime:SetTextByKey("value", makeSec);
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
    gauge:SetPoint(0, 100);
end

function SKILLITEM_MAKE_START(sec)
	local frame = ui.GetFrame("skillitemmaker");
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
	gauge:SetPoint(0, 100);
    gauge:SetPointWithTime(100, sec, 1);
	
end

function SKILLITEMKAE_NUMCHANGE(parent)
	UPDATE_SKILLITEMMAKE_PRICE(parent:GetTopParentFrame());
end

function SKILLITEMMAKE_DROPLISTCHANGE(parent)
	local frame = parent:GetTopParentFrame();
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	frame:GetChild("skilllevel"):SetTextByKey("value", droplist_level:GetSelItemIndex()+1);
end

function SKILLITEMMAKE_EXEC(frame)
	-- ��ų����� �ȵ��־�!
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	if nil == IS_CLEAR_SLOT_ITEM_INFO(skill_slot) then
		print("skill regit NO");
		return;
	end

	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	if 0 == makecount:GetNumber() then
		print("count 0");
		return;
	end


	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame);
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(sklObj, sklObj.Level);
	local bottleCls = GetClass("Item", bottle);
	local visCls = GetClass("Item", "Vis");
	local myVis = session.GetInvItemCountByType(visCls.ClassID);
	local myBottle = session.GetInvItemByName(bottleCls.ClassName);
	if myVis < totalVis or myBottle == nil then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	if true == myBottle.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if myBottle.count < totalBottle  then
		ui.SysMsg(ClMsg("NotEnoughRecipe"));
		return;
	end

	ui.MsgBox(ClMsg("ReallyManufactureItem?"), "_SKILLITEMMAKE_EXEC", "None");
end

function _SKILLITEMMAKE_EXEC()
	local frame = ui.GetFrame("skillitemmaker");
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	local level = droplist_level:GetSelItemIndex()+1;
	
	control.CustomCommand("SKILLITEM_MAKE", curCount, sklObj.ClassID, level);
	_SKILLITEMMAKE_RESET(frame);
end

function _SKILLITEMMAKE_RESET(frame)

	-- ��ü�� �ʱ�ȭ ����... ???
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local totalprice = frame:GetChild("totalprice");
	makecount:SetNumberValue(0);
	makecount:SetIncrValue(0);
	totalprice:SetTextByKey("value", 0);

--local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
--droplist_level:ClearItems();

	CLEAR_SKILLITEMMAKER(frame);

	if myVis < totalVis then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	if myBottle < totalBottle  then
		ui.SysMsg(ClMsg("NotEnoughRecipe"));
		return;
	end

	ui.MsgBox(ClMsg("ReallyManufactureItem?"), "_SKILLITEMMAKE_EXEC", "None");
end

function _SKILLITEMMAKE_EXEC()
	local frame = ui.GetFrame("skillitemmaker");
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	local level = droplist_level:GetSelItemIndex()+1;
	
	control.CustomCommand("SKILLITEM_MAKE", curCount, sklObj.ClassID, level);
	_SKILLITEMMAKE_RESET(frame);
end

function _SKILLITEMMAKE_RESET(frame)

	-- ��ü�� �ʱ�ȭ ����... ???
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local totalprice = frame:GetChild("totalprice");
	makecount:SetNumberValue(0);
	makecount:SetIncrValue(0);
	totalprice:SetTextByKey("value", 0);

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	droplist_level:ClearItems();

	CLEAR_SKILLITEMMAKER(frame);
end