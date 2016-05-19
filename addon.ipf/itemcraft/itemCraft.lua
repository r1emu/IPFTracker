--itemcraft.lua

function ITEMCRAFT_ON_INIT(addon, frame)
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_START', 'CRAFT_DETAIL_CRAFT_EXEC_ON_START');
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_FAIL', 'CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL');
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_SUCCESS', 'CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS');

	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'ITEMCRAFT_REFRSH');
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'ITEMCRAFT_REFRSH');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'ITEMCRAFT_REFRSH');

	addon:RegisterMsg('RESTQUICKSLOT_CLOSE', 'CRAFT_EXIT');
	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_CLOSE', 'CRAFT_EXIT');
	

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:SetSkinName('bg');
end

g_itemCraftFrameName = "itemcraft";
g_craftRecipe = nil;
g_craftRecipe_detail_item = nil;
g_craftRecipe_detail_memo = nil;
g_craftRecipe_makeBtn = nil;
g_craftRecipe_upDown = nil;

-- craftRecipe
function SET_ITEM_CRAFT_UINAME(uiName)
	g_itemCraftFrameName = uiName;

	g_craftRecipe = "craftRecipe";
	g_craftRecipe_detail_item = "craftRecipe_detail_item";
	g_craftRecipe_detail_memo = "craftRecipe_detail_memo";
	g_craftRecipe_makeBtn = "craftRecipe_makeBtn";
	g_craftRecipe_upDown =  "craftRecipe_numupdown";

	if uiName == "itemcraft_alchemist" then
		g_craftRecipe = g_craftRecipe .. "_alchemist";
		g_craftRecipe_detail_item = g_craftRecipe_detail_item .. "_alchemist";
		g_craftRecipe_detail_memo = g_craftRecipe_detail_memo .. "_alchemist";
		g_craftRecipe_makeBtn = g_craftRecipe_makeBtn .. "_alchemist";
	elseif	uiName == "itemcraft_fletching"	then
		g_craftRecipe = g_craftRecipe .. "_alchemist";
		g_craftRecipe_detail_item = g_craftRecipe_detail_item .. "_alchemist";
		g_craftRecipe_detail_memo = g_craftRecipe_detail_memo .. "_alchemist";
		g_craftRecipe_makeBtn = g_craftRecipe_makeBtn .. "_alchemist";
	end

end

function ITEMCRAFT_REFRSH(frame, msg, str, time)

	frame = ui.GetFrame(frame:GetUserValue("UI_NAME"));
	if frame == nil then
		frame = ui.GetFrame(g_itemCraftFrameName);
	end

	CREATE_CRAFT_ARTICLE(frame);
end

function CLOSE_ALL_ANOTHER_PAGE(nowpagename)

	local frame = ui.GetFrame(g_itemCraftFrameName);
	local slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;

	local tree = GET_CHILD_RECURSIVELY(frame, 'recipetree','ui::CTreeControl')

	local cnt = tree:GetAllTreeItemCount();
	for i = 0 , cnt - 1 do
		local item = tree:GetTreeItemByIndex(i);
		local page = item:GetObject();
		if page ~= nil then
			if page:GetClassName() == "page" and nowpagename ~= page:GetName() then
				page = tolua.cast(page, "ui::CPage");
				page:SetFocusedRowHeight(-1, slotHeight, 0.2, 0.7, 5);
				page:SetUserValue("minimized", 1);
				CRAFT_MINIMIZE_FOCUS(page);
			end
		end
	end
end

function ITEMCRAFT_FIRST_OPEN(frame)	
	CREATE_CRAFT_ARTICLE(frame);
end

function ITEMCRAFT_CLOSE(frame)

	session.ResetItemList();

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("ITEMCRAFT_INV_ICON"); -- �ѹ� ������Ʈ ��
	INVENTORY_SET_ICON_SCRIPT("None"); -- ����

	ui.CloseFrame('inventory')


end

function CRAFT_OPEN(frame)	 -- ���� �Ⱦ���?

	-- ���ǿ� ��Ͼȵ� ���������ִ��� �κ��丮���� �ֹ��� Ȯ���ؼ� �����ϱ�
	INV_CRAFT_CHECK();
	
	local f = ui.GetFrame(g_itemCraftFrameName);

	CREATE_CRAFT_ARTICLE(f)

	local bg = GET_CHILD(f, "bg", "ui::CGroupBox");
	bg:ShowWindow(1);

	local article = GET_CHILD(f, 'recipe', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(0);

	local group = GET_CHILD(f, 'Recipe', 'ui::CGroupBox')
	group:ShowWindow(1)
	imcSound.PlaySoundEvent('button_click_3');

	session.ResetItemList();
end

function SET_CRAFT_IDSPACE(frame, idSpace, arg1, arg2)
--	local frame = ui.GetFrame("itemcraft_alchemist");
	frame:SetUserValue("IDSPACE", idSpace);

	if arg1 ~= nil then
		frame:SetUserValue("IDSPACE_ARG1", arg1);
	end
	if arg2 ~= nil then
		frame:SetUserValue("IDSPACE_ARG2", arg2);
	end
end

function CRAFT_CHECK_Recipe(cls, arg1, arg2)
	if cls.NeedWiki == 0 or GetWikiByName(cls.ClassName) ~= nil then
		return true;
	end

	return false;
end

function CHECK_PC_ABILITY(cls, arg1, arg2)
	local abil = session.GetAbilityByName(cls.ClassName)
	if abil ~= nil then
		return true;
	end

	return false;
end

function CRAFT_CHECK_Recipe_ItemCraft(cls, arg1, arg2)
	if cls.IDSpc == 'Skill_Ability' then
		return CHECK_PC_ABILITY(cls, arg1, arg2);
	end

	if cls.SklName == arg1 and cls.SklLevel <= tonumber(arg2) then
		return true;
	end

	return false;
end	
		
		
function CREATE_CRAFT_ARTICLE(frame)

	if g_craftRecipe == nil then
		return;
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("None");

	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

	local slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;

	local tree_box = GET_CHILD(group, 'recipetree_Box','ui::CGroupBox')
	local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')
	if nil == tree then
		return;
	end
	tree:Clear();
	tree:EnableDrawTreeLine(false)
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,100)
	tree:SetFontName("brown_18_b");
	tree:SetTabWidth(5);

	local idSpace = frame:GetUserValue("IDSPACE");
	
	if idSpace == "None" then
		idSpace = "Recipe";
		frame:SetUserValue("IDSPACE", "Recipe");
	end
	
	local arg1 = frame:GetUserValue("IDSPACE_ARG1");
	local arg2 = frame:GetUserValue("IDSPACE_ARG2");

	--��� ���� ������ ����.
	local clslist = GetClassList(idSpace);
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");	
	local checkHaveMaterial = showonlyhavemat:IsChecked();	

	local checkCraftFunc = _G["CRAFT_CHECK_".. idSpace];
	-- ���� ī�װ�.
	while cls ~= nil do

		if checkCraftFunc(cls, arg1, arg2) == true then
			local haveM = CRAFT_HAVE_MATERIAL(cls);		
			if checkHaveMaterial == 1 then
				if haveM == 1 then
					CRAFT_INSERT_CRAFT(cls, tree, slotHeight,haveM);
				end
			else
				CRAFT_INSERT_CRAFT(cls, tree, slotHeight,haveM);
			end
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

	tree:OpenNodeAll();

end

function CRAFT_UPDATE_PAGE(page, cls, haveMaterial, item)

	page:SetUserValue("CLASSID", cls.ClassID);
	if item == nil then
		item = GetClass('Item', cls.TargetItem);
	end

	local app = page:CreateOrGetControlSet(g_craftRecipe, cls.ClassName, 10, 10);
	local titleText = GET_CHILD(app, "name", "ui::CRichText");

	local font = "{@st42_yellow}{s20}";
	local ableText = ScpArgMsg('craft_able')
	if haveMaterial ~= 1 then
		font = "{@st66b}{s20}";
		ableText = ""
	end
	

    local pc = GetMyPCObject()
	
	local skill = GetSkill(pc, "Alchemist_Tincturing")
	local Level = 0;
	if nil ~= skill and g_itemCraftFrameName ~= "itemcraft" then
		Level= skill.Level;
		local abil = session.GetAbilityByName(cls.ClassName);
		if cls.IDSpc == 'Skill_Ability' and nil ~= abil then
			local abilObj =  GetIES(abil:GetObject());
			Level = abilObj.Level;
		end
	end
    local len = string.len(item.Name)
    local itmeName = string.sub(item.Name, 1, len - 1)

    if skill ~= nil then
	    titleText:SetText(font ..itmeName..Level.. ableText .."{/}");
    else
        titleText:SetText(font ..item.Name.. ableText .."{/}");
    end
	local difficulty = GET_CHILD(app, "difficulty", "ui::CRichText");
	local difficultyText = GET_ITEM_GRADE_TXT(item, 24);
	difficulty:SetText(difficultyText);

	local icon = GET_CHILD(app, "icon", "ui::CPicture");
	icon:SetImage(item.Icon);
	icon:SetEnableStretch(1)
	--UI_ANIM(icon, "ItemCraftIconInit");
	icon:SetEventScript(ui.RBUTTONUP, 'CRAFT_BEFORE_START_CRAFT');
	icon:SetEventScriptArgString(ui.RBUTTONUP, cls.ClassName);
--T_ITEM_TOOLTIP_TYPE(icon, item.ClassID, item);
--on:SetTooltipArg('', item.ClassID, 0);
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, item.ClassName, '', item.ClassID, 0);

	app:SetEventScript(ui.LBUTTONUP, 'CRAFT_RECIPE_FOCUS');
	app:SetOverSound('button_cursor_over_3');
	app:SetClickSound('button_click_big_2');

	page:Resize(page:GetWidth(), app:GetY() + app:GetHeight() + 20);

end

function CRAFT_INSERT_CRAFT(cls, tree, slotHeight, haveMaterial)

	local item = GetClass('Item', cls.TargetItem);
	local groupName = item.GroupName;
	local classType = nil;
	if GetPropType(item, "ClassType") ~= nil then
		classType = item.ClassType;
	end

	local page = CRAFT_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType);
	CRAFT_UPDATE_PAGE(page, cls, haveMaterial, item);
end

function CRAFT_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType)
	
	local hGroup = tree:FindByValue(groupName);
	if tree:IsExist(hGroup) == 0 then
		hGroup = tree:Add(GET_RECIPE_GROUP_NAME(groupName), groupName);
		tree:SetNodeFont(hGroup,"brown_18_b")
	end

	local hParent = nil;
	if classType == nil then
		hParent = hGroup;
	else
		local hClassType = tree:FindByValue(hGroup, classType);
		if tree:IsExist(hClassType) == 0 then
			hClassType = tree:Add(hGroup, GET_RECIPE_GROUP_NAME(classType), classType);
			tree:SetNodeFont(hClassType,"brown_18_b")
			
		end

		hParent = hClassType;
	end

	local pageCtrlName = "PAGE_" .. groupName;
	if classType ~= nil then
		pageCtrlName = pageCtrlName .. "_" .. classType;
	end

	local page = tree:GetChild(pageCtrlName);
	if page == nil then
		page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);

		tolua.cast(page, 'ui::CPage')
		page:SetSkinName('None');
		page:SetSlotSize(415, slotHeight)
		page:SetFocusedRowHeight(-1, slotHeight);
		page:SetFitToChild(true, 10);
		page:SetSlotSpace(0, 0)
		page:SetBorder(5, 0, 0, 0)
		CRAFT_MINIMIZE_FOCUS(page);
		tree:Add(hParent, page);	
		tree:SetNodeFont(hParent,"brown_18_b")		
	end

	return page;

end


function JORNAL_DRAW_ITEM_PROP_TOOLTIP(queue, tgtItem, propName)
	local text = queue:CreateOrGetControl('richtext', propName, 200, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0);
	local randValue = 0;
	if GetPropType(tgtItem, propName .. "_RANDOM") ~= nil then
		randValue = tgtItem[propName .. "_RANDOM"];
	elseif propName == "MINATK" or propName == "MAXATK" then
		randValue = tgtItem.ATK_RANDOM;
	end

	local baseValue = tgtItem[propName];
	local retStr;
	if randValue == 0 then
		retStr = string.format("{@st66b}%s : %d", ClMsg(propName), baseValue);
	else
		retStr = string.format("{@st66b}%s : %d ~ %d", ClMsg(propName), baseValue, baseValue + randValue);
	end

	text:SetText(retStr);
end

function CRAFT_HAVE_MATERIAL(recipecls)
    local duplicationCnt = 1;
	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			
			local recipeItemCnt, invItemCnt = GET_RECIPE_MATERIAL_INFO(recipecls, i);

			if recipeItemCnt > invItemCnt then
				return 0;
			end
			
			if i > 1 and i < 5 then
			    if recipecls["Item_"..i.."_1"] == recipecls["Item_"..(i + 1).."_1"] then
			        duplicationCnt = duplicationCnt + 1;
			        if duplicationCnt > invItemCnt then
			            return 0;
			        end
			    else
			        duplicationCnt = 1;
			    end
			end
			
		end
	end

	return 1;
end

function GET_INVITEMS_BY_TYPE_WORTH_SORTED(type)

	local resultlist = {}

	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();

	for i = 0, itemCount - 1 do
		
		local invItem = invItemList:Element(index);
		if invItem ~= nil then

			if invItem.type == type then
				local itemobj = GetIES(invItem:GetObject());			

				resultlist[#resultlist+1] = invItem

			end
		end

		index = invItemList:Next(index);
	end
	
	table.sort(resultlist, SORT_INVITEM_BY_WORTH)

	return resultlist
end

function SORT_INVITEM_BY_WORTH(a,b)

	-- ���� ClassID�� ���� ���� ��� ���� ���� �ۺ��� �ռ� �ϵ��� �����ϴ� �Լ�. 
	-- ���ļ��� : ������ķ� > �� �� ����ġ > �� ���� > �ո� ���� �� > ���� ��ȭ Ƚ�� > ���� ���ټ�

	local itemobj_a = GetIES(a:GetObject());
	local itemobj_b = GetIES(b:GetObject());

	local a_amuletcnt = 0
	local b_amuletcnt = 0

	for i = 0, 3-1 do
	    local tempvala = TryGetProp(itemobj_a,'MagicAmulet_' .. i)
   	    local tempvalb = TryGetProp(itemobj_b,'MagicAmulet_' .. i)
        
        if tempvala ~= nil and tempvalb ~= nil then
            if itemobj_a['MagicAmulet_' .. i] ~= 0 then
    			a_amuletcnt = a_amuletcnt + 1
    		end
    		if itemobj_b['MagicAmulet_' .. i] ~= 0 then
    			b_amuletcnt = b_amuletcnt + 1
    		end
        end
        
	end

	if a_amuletcnt ~= b_amuletcnt then
		return a_amuletcnt < b_amuletcnt
	end

	local a_gemexp = 0
	local b_gemexp = 0

	for i = 0, 5-1 do
	    local tempvala = TryGetProp(itemobj_a,'SocketItemExp_' .. i)
   	    local tempvalb = TryGetProp(itemobj_b,'SocketItemExp_' .. i)
        
        if tempvala ~= nil and tempvalb ~= nil then
		    a_gemexp = a_gemexp +  itemobj_a['SocketItemExp_' .. i] 
    		b_gemexp = b_gemexp +  itemobj_b['SocketItemExp_' .. i] 
		end
	end

	if a_gemexp ~= b_gemexp then
		return a_gemexp < b_gemexp
	end


	local a_gemcnt = 0
	local b_gemcnt = 0

	for i = 0, 5-1 do
	    local tempvala = TryGetProp(itemobj_a,'Socket_Equip_' .. i)
   	    local tempvalb = TryGetProp(itemobj_b,'Socket_Equip_' .. i)
        
        if tempvala ~= nil and tempvalb ~= nil then
    		if itemobj_a['Socket_Equip_' .. i] ~= 0 then
    			a_gemcnt = a_gemcnt + 1
    		end
    		if itemobj_b['Socket_Equip_' .. i] ~= 0 then
    			b_gemcnt = b_gemcnt + 1
    		end
		end
	end

	if a_amuletcnt ~= b_amuletcnt then
		return a_amuletcnt < b_amuletcnt
	end


	local a_socketcnt = 0
	local b_socketcnt = 0

	for i = 0, 5-1 do
	    local tempvala = TryGetProp(itemobj_a,'Socket_' .. i)
   	    local tempvalb = TryGetProp(itemobj_b,'Socket_' .. i)
        
        if tempvala ~= nil and tempvalb ~= nil then
    		if itemobj_a['Socket_' .. i] > 0 then
    			a_socketcnt = a_socketcnt + 1
    		end
    		if itemobj_b['Socket_' .. i] > 0 then
    			b_socketcnt = b_socketcnt + 1
    		end
		end
	end

	if a_socketcnt ~= b_socketcnt then
		return a_socketcnt < b_socketcnt
	end

    local tempvala_reinforce = TryGetProp(itemobj_a,'Reinforce_2')
    local tempvalb_reinforce = TryGetProp(itemobj_b,'Reinforce_2')
    
    if tempvala_reinforce ~= nil and tempvalb_reinforce ~= nil then
    	if itemobj_a.Reinforce_2 ~= itemobj_b.Reinforce_2 then
	    	return itemobj_a.Reinforce_2  < itemobj_b.Reinforce_2 
    	end
    end
    
    local tempvala_PR = TryGetProp(itemobj_a,'PR')
    local tempvalb_PR = TryGetProp(itemobj_b,'PR')
    
    if tempvala_PR ~= nil and tempvalb_PR ~= nil then
    	if itemobj_a.PR ~= itemobj_b.PR then
	    	return itemobj_a.PR < itemobj_b.PR
    	end
    end

	return a:GetIESID() < b:GetIESID()
	
end

function CRAFT_BEFORE_START_CRAFT(ctrl, ctrlset, recipeName, artNum)

	local frame = ctrlset:GetTopParentFrame();
	local parentcset = ctrlset:GetParent()
	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, recipeName);

	if recipecls == nil then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		return;
	end

	local totalCount = 0;
	local upDown = GET_CHILD(parentcset, "upDown", "ui::CNumUpDown");
	if nil ~= upDown then
		totalCount = upDown:GetNumber();
	end

	if 0 >= totalCount then
		ui.SysMsg(ClMsg("InputCount"));
		return;
	end

	local cnt = parentcset:GetChildCount();
	for i = 0, cnt - 1 do
		local eachcset = parentcset:GetChildByIndex(i);
		if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
			local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")
			if selected ~= 'selected' then
				ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
				return;
			end
		end
	end

	
	local resultlist = session.GetItemIDList();
	
	local someflag = 0
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);

		if IS_VALUEABLE_ITEM(tempitem.ItemID) == 1 then
			someflag = 1
		end
	end
	if someflag > 0 then
		local yesScp = string.format("CRAFT_START_CRAFT(\'%s\', \'%s\', %d)",idSpace, recipeName, totalCount);
		ui.MsgBox(ScpArgMsg("IsValueAbleItem"), yesScp, "None");
	else
		CRAFT_START_CRAFT(idSpace, recipeName, totalCount)
	end
end

function CRAFT_START_CRAFT(idSpace, recipeName, totalCount)

	local frame = ui.GetFrame(g_itemCraftFrameName);
	local ctrl = GET_CHILD_RECURSIVELY(frame, "LABEL", "ui::CGroupBox");

	local recipecls = GetClass(idSpace, recipeName);

	local nameList = nil;
	local targetItem = GetClass("Item", recipecls.TargetItem);
	
	if IS_EQUIP(targetItem) then

		local cset = ctrl:GetParent()
		local memoSet = cset:GetChild("MEMO");

		if memoSet ~= nil then

			local name = memoSet:GetChild("name"):GetText();
			local memo = memoSet:GetChild("memo"):GetText();
			nameList = NewStringList();
			
			if GetUTF8Len(name) > RECIPE_ITEM_NAME_LEN then
				ui.SysMsg(ScpArgMsg("RecipeItemNameCantExceed{Auto_1}Byte", "Auto_1", RECIPE_ITEM_NAME_LEN));
				return;
			end
			
			if GetUTF8Len(memo) > ITEM_MEMO_LEN then
				ui.SysMsg(ScpArgMsg("RecipeMemoCantExceed{Auto_1}Byte", "Auto_1", ITEM_MEMO_LEN));
				return;
			end

			if ui.IsValidItemName(name, 1) == false then
				return;
			end

			if ui.IsValidItemName(memo) == false then
				return;
			end

			nameList:Add(name);
			nameList:Add(memo);

		end
	end
	
	session.ResetItemList();

	for index=1, 5 do
		local clsName = "Item_"..index.."_1";
		local itemName = recipecls[clsName];
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, clsName);
		local invItem = session.GetInvItemByName(itemName);
		if "None" ~= itemName then
			if nil == invItem then
				ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
				return;
			else
				if true == invItem.isLockState then
					ui.SysMsg(ClMsg("MaterialItemIsLock"));
					return;
				end
				session.AddItemID(invItem:GetIESID(), recipeItemCnt);
			end
		end

		if 0 ~= recipeItemCnt and 0 == IS_EQUIPITEM(itemName) then
			if nil ~= invItem and invItem.count < (recipeItemCnt * totalCount) then
				ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
				return;
			end
		end

	end

	--if frame:GetUserIValue("MANUFACTURING") == 1 then
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
			return;
		end

	-- �ӽ÷� �۵����� �ʰ� ���´�. ���߿� ���� ��������.
	if TryGetProp(recipecls, "UseQueue") == "YES" then
		session.CopyTempItemID();
		local queueFrame = ui.GetFrame("craftqueue");
		for i = 1, totalCount do
			ADD_CRAFT_QUEUE(queueFrame, targetItem, recipecls.ClassID, 1);
		end
		if frame:GetUserIValue("MANUFACTURING") == 1 then
			return;
	end
		frame:SetUserValue("MANUFACTURING", 1);
		SetCraftState(1)
		ui.OpenFrame("craftqueue");	
		frame:SetUserValue("MANUFACTURING", 1);
	end
	
	local resultlist = session.GetItemIDList();
	local cntText = string.format("%s %s", recipecls.ClassID, 1);
	frame:SetUserValue("IDSPACE", idSpace);
	item.DialogTransaction("SCR_ITEM_MANUFACTURE_" .. idSpace, resultlist, cntText, nameList);
	
end

function IS_VALUEABLE_ITEM(itemid)

	local invitem = session.GetInvItemByGuid(itemid);

	if nil == invitem then
		return;
	end

	local itemobj = GetIES(invitem:GetObject());

	if itemobj.ItemType ~= "Equip" then
		return 0
	end

	local amuletcnt = 0

	for i = 0, 3-1 do
		if itemobj['MagicAmulet_' .. i] ~= 0 then
			amuletcnt = amuletcnt + 1
		end
	end

	if amuletcnt > 0 then
		return 1
	end

	local gemcnt = 0

	for i = 0, 5-1 do
		if itemobj['Socket_Equip_' .. i] ~= 0 then
		gemcnt = gemcnt + 1
		end
	end

	if gemcnt > 0 then
		return 1
	end

	if itemobj.ItemGrade >= 2 then
		return 1
	end

	if itemobj.Reinforce_2 > 0 then
		return 1
	end

	if itemobj.IsAwaken ~= 0 then
		return 1
	end

	return 0
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_START(frame, msg, str, time)
	frame:SetUserValue("UI_NAME", g_itemCraftFrameName);
	frame = ui.GetFrame(g_itemCraftFrameName);
	if frame:GetUserIValue("MANUFACTURING") == 1 then
		
	end
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL(frame, msg, str, time)
	frame = ui.GetFrame(frame:GetUserValue("UI_NAME"))
	if frame:GetUserIValue("MANUFACTURING") == 1 then
		local queueFrame = ui.GetFrame("craftqueue");
		CLEAR_CRAFT_QUEUE(queueFrame);
		ui.CloseFrame("craftqueue");
	end
	frame:SetUserValue("MANUFACTURING", 0);
	SetCraftState(0)
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS(frame, msg, str, time)
	imcSound.PlaySoundEvent('sys_item_jackpot_get');

	frame = ui.GetFrame(frame:GetUserValue("UI_NAME"))
	if frame:GetUserIValue("MANUFACTURING") ~= 1 then
		return;
	end

	local queueFrame = ui.GetFrame("craftqueue");
	local recipeType, totalCount = REMOVE_CRAFT_QUEUE(queueFrame);
	if recipeType == nil then
		frame:SetUserValue("MANUFACTURING", 0);
		SetCraftState(0)
		return;
	end

	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClassByType(idSpace, recipeType);
	local resultlist = session.GetTempItemIDList();--session.GetItemIDList();
	local cntText = string.format("%s %s", recipecls.ClassID, totalCount);

	for index=1, 5 do
		local clsName = "Item_"..index.."_1";
		local itemName = recipecls[clsName];
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, clsName);
		local invItem = session.GetInvItemByName(itemName);
		if 0 ~= recipeItemCnt and 0 == IS_EQUIPITEM(itemName) then 
			if nil ~= invItem and invItem.count < (recipeItemCnt * totalCount) then
				ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
				CLEAR_CRAFT_QUEUE(queueFrame);
				frame:SetUserValue("MANUFACTURING", 0);
				SetCraftState(0)
				return;
			end
		end
	end

	item.DialogTransaction("SCR_ITEM_MANUFACTURE_" .. idSpace, resultlist, cntText);
end

--- about detail controlset
function CRAFT_RECIPE_FOCUS(page, ctrlSet)
	
	session.ResetItemList();
	page = tolua.cast(page, "ui::CPage");
	local row = page:GetObjectRow(ctrlSet);
	local curFocus = page:GetFocusedRow();
	local minimized = page:GetUserIValue("minimized");
	local slotHeight = 0;

	-- ����ó�� ���س��Ƽ� ������
	if nil ~= g_craftRecipe then
		slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;	
	end
	
	if row == curFocus and minimized == 0 then
		page:SetFocusedRowHeight(-1, slotHeight, 0.2, 0.7, 5);
		page:SetUserValue("minimized", 1);
		CRAFT_MINIMIZE_FOCUS(page);

		INVENTORY_SET_CUSTOM_RBTNDOWN("None");
		INVENTORY_SET_ICON_SCRIPT("None");
		
	else
		CRAFT_MINIMIZE_FOCUS(page);
		page:SetUserValue("minimized", 0);
		page:SetFocusedRow(row);
		local resultHeight = CRAFT_CRAFT_SET_DETAIL(ctrlSet, 1);
		if resultHeight ~= 0 then
			page:SetFocusedRowHeight(slotHeight, resultHeight, 0.15, 0.7, 5);
		end

		INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMCRAFT_INV_RBTN");
		INVENTORY_SET_ICON_SCRIPT("ITEMCRAFT_INV_ICON");
		ui.OpenFrame('inventory')

		CLOSE_ALL_ANOTHER_PAGE(page:GetName())
	end

	local invframe = ui.GetFrame('inventory')
	INVENTORY_UPDATE_ICONS(invframe)

end

function CRAFT_MINIMIZE_FOCUS(page)
	local curFocus = page:GetFocusedRow();
	local beforeFocus = page:GetObjectByRow(curFocus);	
	if beforeFocus ~= nil then
		CRAFT_CRAFT_SET_DETAIL(beforeFocus, 0);
	end
end

function CRAFT_CRAFT_SET_DETAIL(ctrlset, detailMode, ignoreUserValue)

	if nil == g_craftRecipe then
		return;
	end

	local curMode = ctrlset:GetUserIValue("DETAILMODE");
	if curMode == detailMode and ignoreUserValue ~= 1 then
		return 0;
	end
	ctrlset:SetUserValue("DETAILMODE", detailMode);
	local height = ui.GetControlSetAttribute(g_craftRecipe, 'height');
	if detailMode == 0 then
		ctrlset:Resize(ctrlset:GetWidth(), height);
		ctrlset:SetSkinName("test_skin_01");
		local icon = ctrlset:GetChild("icon");
		--UI_ANIM(icon, "ItemCraftIconSizeDown");
		local name = ctrlset:GetChild("name");
		--UI_ANIM(name, "ItemCraftIconTextLeft");
		local diff = ctrlset:GetChild("difficulty");
		--UI_ANIM(diff, "ItemCraftIconTextLeft");
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");
		return 0;
	else
		
		local frame = ui.GetFrame(g_itemCraftFrameName)
		frame:SetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME',ctrlset:GetName())
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");		
		local icon = ctrlset:GetChild("icon");
		--UI_ANIM(icon, "ItemCraftIconSizeUp");
		local name = ctrlset:GetChild("name");
		--UI_ANIM(name, "ItemCraftIconTextRight");
		local diff = ctrlset:GetChild("difficulty");
		--UI_ANIM(diff, "ItemCraftIconTextRight");
		local itemHeight = CRAFT_MAKE_DETAIL_REQITEMS(ctrlset);
		local resizeHeight = height + itemHeight;
		return resizeHeight;
	end
	
	return 0;
end

function CRAFT_DETAIL_CTRL_INIT(ctrl)
	ctrl:SetUserValue("DETAIL_CTRL", "YES");
end

function ITEMCRAFT_INV_ICON(slot, reinfItemObj, invItem, itemobj)
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();

	local someflag = 0
	local resultlist = session.GetItemIDList();
	
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);
		if tempitem.ItemID == iconInfo:GetIESID() then
			someflag = 1
			break;
		end
	end

	if someflag == 1 then
		slot:Select(1)
	else
		slot:Select(0)
	end

end

function ITEMCRAFT_INV_RBTN(itemObj, slot) -- ��Ŭ�� �߰� �Լ�
	local frame = ui.GetFrame(g_itemCraftFrameName)
	local ITEM_CRAFT_NOW_FOCUSED_CSET_NAME = frame:GetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME')

	local nowCset = GET_CHILD_RECURSIVELY(frame,ITEM_CRAFT_NOW_FOCUSED_CSET_NAME,'ui::CControlSet')

	if nowCset == nil then
		return
	end

	imcSound.PlaySoundEvent('inven_equip');

	local cnt = nowCset:GetChildCount();
	for i = 0, cnt - 1 do
		local eachcset = nowCset:GetChildByIndex(i);
		if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
			
			local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")

			if selected == 'nonselected' then
				local targetslot = GET_CHILD(eachcset, "slot", "ui::CSlot");
				local targeticon 	= targetslot:GetIcon();
				local targeticonInfo = targeticon:GetInfo();

				local icon 	= slot:GetIcon();
				local iconInfo = icon:GetInfo();

				local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);
				local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
				local needcount = tonumber(materialItemCnt)

				--��� �ȵ� IESID�� ���Ͽ�
				local resultlist = session.GetItemIDList();
	
				for i = 0, resultlist:Count() - 1 do
					local tempitem = resultlist:PtrAt(i);
					if tempitem.ItemID == iconInfo:GetIESID() then
						return
					end
				end
				
				if iconInfo.type == materialItemClassID and iconInfo.count >= needcount  then -- �̹� ����Ʈ�� ���� ies�� ��쿡��

					local tempinvitem = session.GetInvItemByGuid(iconInfo:GetIESID());
					if true == tempinvitem.isLockState then
						ui.SysMsg(ClMsg("MaterialItemIsLock"));
						return;
					end
					session.AddItemID(iconInfo:GetIESID(), needcount);
					local icon 		= targetslot:GetIcon();
					--���� �÷��� �� ��Ʈ ��� ����. 
					icon:SetColorTone('FFFFFFFF')
					SET_ITEM_TOOLTIP_BY_OBJ(icon, tempinvitem)

					eachcset:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
					

					local invframe = ui.GetFrame('inventory')
					INVENTORY_UPDATE_ICONS(invframe)

					local btn = GET_CHILD(eachcset, "btn", "ui::CButton");

					if btn ~= nil then
						btn:ShowWindow(0)
					end
					

					return;
				end

			end
					
		end
	end

end

function CRAFT_MAKE_DETAIL_REQITEMS(ctrlset)
	
	session.ResetItemList();
	
	local frame = ctrlset:GetTopParentFrame();
	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, ctrlset:GetName());
	local x = 140;
	local startY = 80;
	local y = startY;
	local labelBox = ctrlset:CreateOrGetControl("groupbox", "LABEL", 0, startY, ctrlset:GetWidth() , 30);	
	local cRicon = ctrlset:GetChild("icon");
	local minHeight = cRicon:GetHeight() + startY + 10;

	CRAFT_DETAIL_CTRL_INIT(labelBox);
	labelBox:SetSkinName("None");
	labelBox:ShowWindow(1);
	y = y + 10;

	local itemHeight = ui.GetControlSetAttribute(g_craftRecipe_detail_item, 'height');

	for i = 1 , 5 do --���� �ƴϸ� ��Ʈ�Ѽ��� �� �÷���� �Ѵ� �ڵ�����. 5���� ������ �ȵ�.
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if invItemlist ~= nil then
				for j = 0, recipeItemCnt - 1 do
					local itemSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_item, "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
					itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
					CRAFT_DETAIL_CTRL_INIT(itemSet);
					local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
					local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
					needcountTxt:SetTextByKey("count", recipeItemCnt)
					local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
					SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
					slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
					slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
					slot:SetEventScriptArgString(ui.DROP, 1)
					slot:EnableDrag(0);
					local icon 		= slot:GetIcon();
					icon:SetColorTone('33333333')
					itemtext:SetText(dragRecipeItem.Name);
					y = y + itemHeight;
					itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)

					slot:SetOverSound('button_cursor_over_2');
					slot:SetClickSound('button_click');
				end
			else
				local itemSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_item, "EACHMATERIALITEM_" .. i, x, y);
				itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
				CRAFT_DETAIL_CTRL_INIT(itemSet);
				local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
				local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
				needcountTxt:SetTextByKey("count",recipeItemCnt)--���ۿ� �ʿ��� ������ ī��Ʈ
				local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
				SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
				slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
				slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
				slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
				slot:EnableDrag(0);	
				local icon 		= slot:GetIcon();
				icon:SetColorTone('33333333')
				itemtext:SetText(dragRecipeItem.Name);
				y = y + itemHeight;
				itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)
				
				slot:SetOverSound('button_cursor_over_2');
				slot:SetClickSound('button_click');
			end
		end
	end

	if y < minHeight then
		y = minHeight;
	end;

	local verticalLine = GET_CHILD(ctrlset,'verticalLine','ui::CPicture')
	verticalLine:Resize(verticalLine:GetWidth(), y - verticalLine:GetY());
	y = y + 10;

	local gboxHeight = y - startY;
	labelBox:Resize(labelBox:GetWidth(), gboxHeight);
	
	local targetItem = GetClass("Item", recipecls.TargetItem);
	if IS_EQUIP(targetItem) == true then
		local memoSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_memo, "MEMO", 0, y);
		memoSet:SetSkinName('None');
		CRAFT_DETAIL_CTRL_INIT(memoSet);
		CRAFT_INIT_MEMO_SET(memoSet);
		--y = y + memoSet:GetHeight();
	end

	y = y + 10;

	ctrlset:MergeControlSet(g_craftRecipe_makeBtn, 100, y +5);
	RUNFUNC_TO_MERGED_CTRLSET(ctrlset, g_craftRecipe_makeBtn, CRAFT_DETAIL_CTRL_INIT);
	local make = GET_CHILD(ctrlset, "make", "ui::CButton");
	make:SetEventScript(ui.LBUTTONUP, 'CRAFT_BEFORE_START_CRAFT');
	make:SetOverSound('button_over');
	make:SetClickSound('button_click_big');
	make:SetEventScriptArgString(ui.LBUTTONUP, recipecls.ClassName);
	make:ShowWindow(1)

	ctrlset:MergeControlSet(g_craftRecipe_upDown, 357, y + 5);
	RUNFUNC_TO_MERGED_CTRLSET(ctrlset, g_craftRecipe_upDown, CRAFT_DETAIL_CTRL_INIT);
	y = y + ui.GetControlSetAttribute(g_craftRecipe_upDown, 'height');
	y = y + ui.GetControlSetAttribute(g_craftRecipe_makeBtn, 'height');
	local upDown = GET_CHILD(ctrlset, "upDown", "ui::CNumUpDown");
	upDown:SetNumChangeScp('ITMCRAFT_BUTTON_UP');
	upDown:SetNumberValue(1)--������ ���۽� ���� ���� ����Ʈ 1�� ����.
	upDown:ShowWindow(1)
	upDown:SetOverSound('button_cursor_over_2');
	upDown:SetClickSound('button_click');

	y = y + 10

	return y - 60;
end

function ITMCRAFT_BUTTON_UP(ctrl)
	local topFrame = ctrl:GetTopParentFrame();
	local frame = ctrl:GetParent();
	local idSpace = topFrame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, frame:GetName());
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");

	local number  = ctrl:GetNumber();
	if 0 >= number then
		ctrl:SetNumberValue(0);
		return;
	end

	for i = 1 , 5 do --���� �ƴϸ� ��Ʈ�Ѽ��� �� �÷���� �Ѵ� �ڵ�����. 5���� ������ �ȵ�.
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if nil ~= invItemlist then
				for j = 0, recipeItemCnt - 1 do
					local slot = frame:GetChild("EACHMATERIALITEM_" .. i ..'_'.. j);
					if nil ~= slot then
						local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
						needcountTxt:SetTextByKey("count", recipeItemCnt * number);
					end
				end
			else
				local slot = frame:GetChild("EACHMATERIALITEM_" .. i);
				if nil ~= slot then
					local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
					needcountTxt:SetTextByKey("count", recipeItemCnt * number);
				end
			end
		end
	end

end

function ITEMCRAFT_ON_DROP(cset, control, materialItemCnt, materialItemClassID)

	imcSound.PlaySoundEvent('inven_equip');
	--imcSound.PlaySoundItem('inven_equip'); --������

	local slot 	   		= tolua.cast(control, 'ui::CSlot');
	local needcount = tonumber(materialItemCnt)
	
	local itemname = cset:GetUserValue("ClassName")
	local invItem = session.GetInvItemByName(itemname);
	

	local liftIcon 				= ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();

	--��� �ȵ� IESID�� ���Ͽ�
	local resultlist = session.GetItemIDList();
	
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);
		if tempitem.ItemID == iconInfo:GetIESID() then
			return
		end
	end

	local itemObj = GetIES(invItem:GetObject())
	if IS_EQUIP(itemObj) == true then
		local frame = ui.GetFrame(g_itemCraftFrameName);
		frame:SetUserValue("TARGETSET", cset:GetName())
		local equip =	REGISTER_EQUIP(itemObj)
		if equip == 1 then
			return;
		end
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if iconInfo.type == materialItemClassID and iconInfo.count >= needcount  then -- �̹� ����Ʈ�� ���� ies�� ��쿡��

		session.AddItemID(iconInfo:GetIESID(), needcount);
		local icon 		= slot:GetIcon();
		--���� �÷��� �� ��Ʈ ��� ����. 
		icon:SetColorTone('FFFFFFFF')
		cset:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
	end

	local invframe = ui.GetFrame('inventory')
	INVENTORY_UPDATE_ICONS(invframe)

end

function RECIPE_TYPING_NAME(frame, ctrl)
	frame:GetTopParentFrame():SetUserValue("EQP_NAME", ctrl:GetText());
end

function RECIPE_TYPING_MEMO(frame, ctrl)
	frame:GetTopParentFrame():SetUserValue("EQP_MEMO", ctrl:GetText());
end

function CRAFT_INIT_MEMO_SET(memoSet)
	local name = GET_CHILD(memoSet, "name", "ui::CEditControl");
	local memo = GET_CHILD(memoSet, "memo", "ui::CEditControl");
	--name:SetMaxLen(ITEM_MEMO_LEN);
	--memo:SetMaxLen(RECIPE_ITEM_NAME_LEN);
	local frame = memoSet:GetTopParentFrame();
	local before_name = frame:GetUserValue("EQP_NAME");
	local before_memo = frame:GetUserValue("EQP_MEMO");
	if before_name ~= "None" then
		name:SetText(before_name);
	end
	if before_memo ~= "None" then
		memo:SetText(before_memo);
	end

end

function CRAFT_CRAFT_OPTION(frame, ctrl)
	frame = frame:GetTopParentFrame();
	CREATE_CRAFT_ARTICLE(frame);
end

function CRAFT_EXIT(frame, msg, argStr, argNum)
	packet.StopTimeAction();
	ui.CloseFrame("timeaction");
	ui.CloseFrame(frame:GetUserValue("UI_NAME"))
	ui.CloseFrame(g_itemCraftFrameName);
end

function INV_CRAFT_CHECK()
	local invItemList 		= session.GetInvItemList();
	local index = invItemList:Head();
	while index ~= invItemList:InvalidIndex() do
		local invItem			= invItemList:Element(index);
		if invItem ~= nil then
			local recipeCls = GetClass('Recipe', invItem.ClassName);
			if recipeCls ~= nil then
				-- ���ǿ� ��ϾȵǾ��ִٸ� ������ ���� �ѹ� �϶�� ��Ŷ�����ֱ�
				if GetWikiByName(invItem.ClassName) == nil then
					packet.ReqWikiRecipeUpdate();
					return;
				end
			end
		end
		index = invItemList:Next(index);
	end
end

function SORT_PURE_INVITEMLIST(a,b)

	-- ���� ClassID�� ���� ���� ��� ���� ���� �ۺ��� �ռ� �ϵ��� �����ϴ� �Լ�. 
	-- ���ļ��� : ������ķ� > �� �� ����ġ > �ո� ���� �� > ���� ��ȭ Ƚ�� > ���� ���ټ�

	local itemobj_a = GetIES(a:GetObject());
	local itemobj_b = GetIES(b:GetObject());
    
    if itemobj_a.GroupName ~= 'Gem' and itemobj_b.GroupName ~= 'Gem' then
    
    	local a_amuletcnt = 0
    	local b_amuletcnt = 0
    
    	for i = 0, 3-1 do
    		if itemobj_a['MagicAmulet_' .. i] ~= 0 then
    			a_amuletcnt = a_amuletcnt + 1
    		end
    		if itemobj_b['MagicAmulet_' .. i] ~= 0 then
    			b_amuletcnt = b_amuletcnt + 1
    		end
    	end
    
    	if a_amuletcnt ~= b_amuletcnt then
    		return a_amuletcnt < b_amuletcnt
    	end
    
    	local a_gemexp = 0
    	local b_gemexp = 0
    
    	for i = 0, 5-1 do
    		a_gemexp = a_gemexp +  itemobj_a['SocketItemExp_' .. i] 
    		b_gemexp = b_gemexp +  itemobj_b['SocketItemExp_' .. i] 
    	end
    
    	if a_gemexp ~= b_gemexp then
    		return a_gemexp < b_gemexp
    	end
    
    
    	local a_gemcnt = 0
    	local b_gemcnt = 0
    
    	for i = 0, 5-1 do
    		if itemobj_a['Socket_Equip_' .. i] ~= 0 then
    			a_gemcnt = a_gemcnt + 1
    		end
    		if itemobj_b['Socket_Equip_' .. i] ~= 0 then
    			b_gemcnt = b_gemcnt + 1
    		end
    	end
    
    	if a_amuletcnt ~= b_amuletcnt then
    		return a_amuletcnt < b_amuletcnt
    	end
    
    
    	local a_socketcnt = 0
    	local b_socketcnt = 0
    
    	for i = 0, 5-1 do
    		if itemobj_a['Socket_' .. i] > 0 then
    			a_socketcnt = a_socketcnt + 1
    		end
    		if itemobj_b['Socket_' .. i] > 0 then
    			b_socketcnt = b_socketcnt + 1
    		end
    	end
    
    	if a_socketcnt ~= b_socketcnt then
    		return a_socketcnt < b_socketcnt
    	end
    
    	if itemobj_a.Reinforce_2 ~= itemobj_b.Reinforce_2 then
    		return itemobj_a.Reinforce_2  < itemobj_b.Reinforce_2 
    	end
    
    	if itemobj_a.PR ~= itemobj_b.PR then
    		return itemobj_a.PR < itemobj_b.PR
    	end
    else
        local lv_a, curExp_a, maxExp_a = GET_ITEM_LEVEL_EXP(itemobj_a);
        local lv_b, curExp_b, maxExp_b = GET_ITEM_LEVEL_EXP(itemobj_b);
        
        if maxExp_a > maxExp_b then
            return maxExp_a < maxExp_b;
        elseif maxExp_a == maxExp_b then
            if curExp_a > curExp_b then
                return curExp_a < curExp_b;
            end
        end
        
    end
    
	return a:GetIESID() < b:GetIESID()
	
end

function GET_ONLY_PURE_INVITEMLIST(type)

	local resultlist = {}

	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();

	for i = 0, itemCount - 1 do
		
		local invItem = invItemList:Element(index);
		if invItem ~= nil then

			if invItem.type == type then
				local itemobj = GetIES(invItem:GetObject());			

				resultlist[#resultlist+1] = invItem

			end
		end

		index = invItemList:Next(index);
	end
	
	table.sort(resultlist, SORT_PURE_INVITEMLIST)

	return resultlist
end

function CRAFT_ITEM_ALL(itemSet, btn)

	local itemname = itemSet:GetUserValue("ClassName")
	local itemcls = GetClass("Item", itemname);
	local invItemlist = nil;
	local invItemadd = nil

	invItemlist = GET_ONLY_PURE_INVITEMLIST(itemcls.ClassID)

	if #invItemlist < 1 or invItemlist == nil then
		return;
	end

	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");
	local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	local needcount = tonumber(materialItemCnt)
	--IESID ������ ���� ������ ���̵� ����
	--DB����Ǵ� ��.
	--���ͳ�, �÷��̾ ������ �ִ� �������� �����ϱ� ���ؼ� ����ϴ� ID
	--��� �ȵ� IESID�� ���Ͽ�
	local resultlist = session.GetItemIDList();

	

	for i = 1, #invItemlist do

		local tempinvItem = invItemlist[i];

		local isAlreadyAdd = 0

		for j = 0, resultlist:Count() - 1 do

			local tempitem = resultlist:PtrAt(j);

			if tempitem.ItemID == tempinvItem:GetIESID() then
				isAlreadyAdd = 1
			end
		end

		if isAlreadyAdd == 0 then
			invItemadd = tempinvItem
			break
		end

	end

	if invItemadd == nil then
		return
	end
	
	local itemObj = GetIES(invItemadd:GetObject())
				
	if IS_EQUIP(itemObj) == true then
		
		local frame = ui.GetFrame(g_itemCraftFrameName);
		frame:SetUserValue("TARGETSET", itemSet:GetName())
		frame:SetUserValue("TARGET_GUID", GetIESID(itemObj))
		local equip =	REGISTER_EQUIP(itemObj)
		if equip == 1 then
			return;
		end
	end
	
	if true == invItemadd.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if invItemadd.type == materialItemClassID and invItemadd.count >= needcount then
		
		session.AddItemID(invItemadd:GetIESID(), needcount);
		local icon 		= targetslot:GetIcon();

		SET_ITEM_TOOLTIP_BY_OBJ(icon, invItemadd)

		--���� �÷��� �� ��Ʈ ��� ����. 
		icon:SetColorTone('FFFFFFFF')
		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		btn:ShowWindow(0)
		INVENTORY_UPDATE_ICONS(invframe)
	end
end

function ITEM_EQUIP_CRAFT()

	local frame = ui.GetFrame(g_itemCraftFrameName);
	local ITEM_CRAFT_NOW_FOCUSED_CSET_NAME = frame:GetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME')
	local nowCset = GET_CHILD_RECURSIVELY(frame,ITEM_CRAFT_NOW_FOCUSED_CSET_NAME,'ui::CControlSet')

	if nowCset == nil then
		return
	end
	local itemSetName = frame:GetUserValue("TARGETSET")
	local itemSet = nowCset:GetChild(itemSetName)
	local itemGuid = frame:GetUserValue("TARGET_GUID")

	local invItem = session.GetInvItemByGuid(itemGuid);

	if invItem == nil then
		return
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");
	local btn = GET_CHILD(itemSet, "btn", "ui::CButton");

	if btn ~= nil then
		btn:ShowWindow(0)
	end

	local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	local needcount = tonumber(materialItemCnt)

	if invItem.type == materialItemClassID and invItem.count >= needcount then
		session.AddItemID(invItem:GetIESID(), needcount);
		local icon 		= targetslot:GetIcon();
		icon:SetColorTone('FFFFFFFF')
		SET_ITEM_TOOLTIP_BY_OBJ(icon, invItem)
		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		INVENTORY_UPDATE_ICONS(invframe)
	end

end

function REGISTER_EQUIP(itemObj)
	
	if itemObj.Reinforce_2 ~= 0 then
			local yesScp = string.format("ITEM_EQUIP_CRAFT()");
			ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
			return 1
	else 
		
		for i = 0 , itemObj.MaxSocket	do
			if itemObj["Socket_"..i]  ~= 0 then
				local yesScp = string.format("ITEM_EQUIP_CRAFT()");
				ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
				return 1
			end
		end
	end

	return 0

end