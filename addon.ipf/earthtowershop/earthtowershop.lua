local local_parent = nil
local local_control = nil
local local_dragrecipeitem = nil

function EARTHTOWERSHOP_ON_INIT(addon, frame)
    addon:RegisterMsg('EARTHTOWERSHOP_BUY_ITEM', 'EARTHTOWERSHOP_BUY_ITEM');
end

function EARTHTOWERSHOP_BUY_ITEM(itemName,itemCount)
    local ctrlset = local_control:GetParent();
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    local exchangeCountText = GET_CHILD(ctrlset, "exchangeCount");
	if recipecls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
		local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
		local cntText = string.format("%d", sCount).. ScpArgMsg("Excnaged_Count_Remind");
		local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
		if sCount <= 0 then
			cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
		end;
		exchangeCountText:SetTextByKey("value", cntText);
	end;
	
	if recipecls.AccountNeedProperty ~= 'None' then
	    local aObj = GetMyAccountObj()
		local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
		local cntText = ScpArgMsg("Excnaged_AccountCount_Remind","COUNT",string.format("%d", sCount))
		local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
		if sCount <= 0 then
			cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
		end;
		exchangeCountText:SetTextByKey("value", cntText);
	end

end
function REQ_EARTH_TOWER_SHOP_OPEN()

    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EarthTower');
    ui.OpenFrame('earthtowershop');
end

function REQ_EARTH_TOWER2_SHOP_OPEN()

    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EarthTower2');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP2_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop2');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP3_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop3');
    ui.OpenFrame('earthtowershop');
end

function REQ_KEY_QUEST_TRADE_HETHRAN_LV1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'KeyQuestShop1');
    ui.OpenFrame('earthtowershop');
end

function REQ_KEY_QUEST_TRADE_HETHRAN_LV2_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'KeyQuestShop2');
    ui.OpenFrame('earthtowershop');
end

function HALLOWEEN_EVENT_ITEM_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'HALLOWEEN');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP8_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop8');
    ui.OpenFrame('earthtowershop');
end

function REQ_PVP_MINE_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'PVPMine');
    ui.OpenFrame('earthtowershop');
end

function REQ_MASSIVE_CONTENTS_SHOP1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'MCShop1');
    ui.OpenFrame('earthtowershop');
end

function REQ_SoloDungeon_Bernice_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'Bernice');
    ui.OpenFrame('earthtowershop');
end

function REQ_DAILY_REWARD_SHOP_1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'DailyRewardShop');
    ui.OpenFrame('earthtowershop');
end

function REQ_VIVID_CITY2_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'VividCity2_Shop');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP9_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop9');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP10_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop10');
    ui.OpenFrame('earthtowershop');
end

function EARTH_TOWER_SHOP_OPEN(frame)
    if frame == nil then
        frame = ui.GetFrame("earthtowershop")
    end
    
    local shopType = frame:GetUserValue("SHOP_TYPE");
    if shopType == 'None' then
        shopType = "EarthTower";
        frame:SetUserValue("SHOP_TYPE", shopType);
    end

    EARTH_TOWER_INIT(frame, shopType)

    local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
    bg:ShowWindow(1);

    local article = GET_CHILD(frame, 'recipe', "ui::CGroupBox");
    if article ~= nil then
        article:ShowWindow(0)
    end

    local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
    bg:ShowWindow(0);
    
    local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')
    group:ShowWindow(1)
    imcSound.PlaySoundEvent('button_click_3');

    session.ResetItemList();
end

function  EARTH_TOWER_SHOP_OPTION(frame, ctrl)
    session.ResetItemList();
    frame = frame:GetTopParentFrame();
    local shopType = frame:GetUserValue("SHOP_TYPE");
    EARTH_TOWER_INIT(frame, shopType);
end

function EARTH_TOWER_INIT(frame, shopType)

    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
    RESET_INVENTORY_ICON();

    local title = GET_CHILD(frame, 'title', 'ui::CRichText')
    local close = GET_CHILD(frame, 'close');
    if shopType == 'EarthTower' then
        title:SetText('{@st43}'..ScpArgMsg("EarthTowerShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EarthTowerShop")));
    elseif shopType == 'EventShop' or shopType == 'EventShop2' or shopType == 'EventShop3' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'KeyQuestShop1' then
        title:SetText('{@st43}'..ScpArgMsg("KeyQuestShopTitle1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("KeyQuestShopTitle1")));
    elseif shopType == 'KeyQuestShop2' then
        title:SetText('{@st43}'..ScpArgMsg("KeyQuestShopTitle2"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("KeyQuestShopTitle2")));
    elseif shopType == 'HALLOWEEN' then
        title:SetText('{@st43}'..ScpArgMsg("EVENT_HALLOWEEN_SHOP_NAME"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EVENT_HALLOWEEN_SHOP_NAME")));
    elseif shopType == 'PVPMine' then
        title:SetText('{@st43}'..ScpArgMsg("pvp_mine_shop_name"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("pvp_mine_shop_name")));
    elseif shopType == 'MCShop1' then
        title:SetText('{@st43}'..ScpArgMsg("MASSIVE_CONTENTS_SHOP_NAME"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("MASSIVE_CONTENTS_SHOP_NAME")));
    elseif shopType == 'EventShop8' then
        local taltPropCls = GetClassByType('Anchor_c_Klaipe', 5187);
        title:SetText('{@st43}'..taltPropCls.Name);
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', taltPropCls.Name));
    elseif shopType == 'DailyRewardShop' then
        title:SetText('{@st43}'..ScpArgMsg("DAILY_REWARD_SHOP_1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("DAILY_REWARD_SHOP_1")));
    elseif shopType == 'Bernice' then
        title:SetText('{@st43}'..ScpArgMsg("SoloDungeonSelectMsg_5"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("SoloDungeonSelectMsg_5")));
    elseif shopType == 'VividCity2_Shop' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'EventShop9' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'EventShop10' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    end


    local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

    local slotHeight = ui.GetControlSetAttribute('earthTowerRecipe', 'height') + 5;

    local tree_box = GET_CHILD(group, 'recipetree_Box','ui::CGroupBox')
    local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')

    if nil == tree then
        return;
    end
    tree:Clear();
    tree:EnableDrawTreeLine(false)
    tree:EnableDrawFrame(false)
    tree:SetFitToChild(true,200)
    tree:SetFontName("brown_18_b");
    tree:SetTabWidth(5);



    local clslist = GetClassList("ItemTradeShop");
    if clslist == nil then return end

    local i = 0;
    local cls = GetClassByIndexFromList(clslist, i);

    local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");   
    local checkHaveMaterial = showonlyhavemat:IsChecked();  
    
    while cls ~= nil do

        if cls.ShopType == shopType then
            local haveM = CRAFT_HAVE_MATERIAL(cls);     
            if checkHaveMaterial == 1 then
                if haveM == 1 then
                   INSERT_ITEM(cls, tree, slotHeight,haveM, shopType);
                end
            else
                INSERT_ITEM(cls, tree, slotHeight,haveM, shopType);
            end
        end
        
        i = i + 1;
        cls = GetClassByIndexFromList(clslist, i);
    end

    tree:OpenNodeAll();

end


function INSERT_ITEM(cls, tree, slotHeight, haveMaterial, shopType)

    local item = GetClass('Item', cls.TargetItem);
    local groupName = item.GroupName;
    local classType = nil;
    if GetPropType(item, "ClassType") ~= nil then
        classType = item.ClassType;
        if classType == 'None' then
            classType = nil
        end
    end

    EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls, shopType);
end


function EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls, shopType)
    local hGroup = tree:FindByValue(groupName);
    if tree:IsExist(hGroup) == 0 then
        hGroup = tree:Add(ScpArgMsg(groupName), groupName);
        tree:SetNodeFont(hGroup,"brown_18_b")
    end

    local hParent = nil;
    if classType == nil then
        hParent = hGroup;
    else
        local hClassType = tree:FindByValue(hGroup, classType);
        if tree:IsExist(hClassType) == 0 then
            hClassType = tree:Add(hGroup, ScpArgMsg(classType), classType);
            tree:SetNodeFont(hClassType,"brown_18_b")
            
        end

        hParent = hClassType;
    end
    
    local pageCtrlName = "PAGE_" .. groupName;
    if classType ~= nil then
        pageCtrlName = pageCtrlName .. "_" .. classType;
    end

    --DESTROY_CHILD_BY_USERVALUE(tree, "EARTH_TOWER_CTRL", "YES");

    --local page = tree:GetChild(pageCtrlName);
    --if page == nil then
    --page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);
    --CreateOrGetControl('groupbox', "upbox", 0, 0, detailView:GetWidth(), 0);
    --local groupbox = tree:CreateOrGetControlSet('groupbox_sub', tree:GetName(), 0, 0)
    --local groupbox = CreateOrGetControl('groupbox', 'questreward', 10, 10, frame:GetWidth()-70, frame:GetHeight());
    --print(tree:GetName())
    
    local page = tree:GetChild(pageCtrlName);
    if page == nil then
        page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);

        tolua.cast(page, 'ui::CPage')
        page:SetSkinName('None');
        page:SetSlotSize(415, slotHeight);
        page:SetFocusedRowHeight(-1, slotHeight);
        page:SetFitToChild(true, 10);
        page:SetSlotSpace(0, 0)
        page:SetBorder(5, 0, 0, 0)
        CRAFT_MINIMIZE_FOCUS(page);
        tree:Add(hParent, page);    
        tree:SetNodeFont(hParent,"brown_18_b")      
    end
    
    local ctrlset = page:CreateOrGetControlSet('earthTowerRecipe', cls.ClassName, 10, 10);
    local groupbox = ctrlset:CreateOrGetControl('groupbox', pageCtrlName, 0, 0, 530, 200);
    
    groupbox:SetSkinName("None")
    groupbox:EnableHitTest(0);
    groupbox:ShowWindow(1);
    tree:Add(hParent, groupbox);    
    tree:SetNodeFont(hParent,"brown_18_b")

    local x = 180;
    local startY = 80;
    local y = startY; 
    y = y + 10;
    local itemHeight = ui.GetControlSetAttribute('craftRecipe_detail_item', 'height');
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    local targetItem = GetClass("Item", recipecls.TargetItem);
    local itemName = GET_CHILD(ctrlset, "itemName")
    local itemIcon = GET_CHILD(ctrlset, "itemIcon")
    local minHeight = itemIcon:GetHeight() + startY + 10;

    if recipecls["Item_2_1"]~= "None" then
        local itemCountGBox = GET_CHILD_RECURSIVELY(ctrlset, "gbox");
        if itemCountGBox ~= nil then
            itemCountGBox:ShowWindow(0);
        end
    end
    
    itemName:SetTextByKey("value", targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
    if targetItem.StringArg == "EnchantJewell" then
        itemName:SetTextByKey("value", "[Lv. "..cls.TargetItemAppendValue.."] "..targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
    end
    
    itemIcon:SetImage(targetItem.Icon);
    itemIcon:SetEnableStretch(1);
    
    if targetItem.StringArg == "EnchantJewell" then
        SET_ITEM_TOOLTIP_BY_CLASSID(itemIcon, targetItem.ClassName, 'ItemTradeShop', cls.ClassName);
    else  
        SET_ITEM_TOOLTIP_ALL_TYPE(itemIcon, nil, targetItem.ClassName, '', targetItem.ClassID, 0);
    end
    
    local itemCount = 0;
    for i = 1, 5 do
        if recipecls["Item_"..i.."_1"] ~= "None" then
        local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
            if invItemlist ~= nil then
                for j = 0, recipeItemCnt - 1 do
                    local itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
                    itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
                    local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
                    local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
                    needcountTxt:SetTextByKey("count", recipeItemCnt)

                    SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                    slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                    slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                    slot:SetEventScriptArgString(ui.DROP, 1)
                    slot:EnableDrag(0);
                    slot:SetOverSound('button_cursor_over_2');
                    slot:SetClickSound('button_click');

                    local icon      = slot:GetIcon();
                    icon:SetColorTone('33333333')
                    itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName);
                    
                    local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
                    itemtext:SetText(dragRecipeItem.Name);

                    y = y + itemHeight;
                    itemCount = itemCount + 1;              
                end
            else            
                local itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i, x, y);
                itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
                local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
                local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
                needcountTxt:SetTextByKey("count", recipeItemCnt);

                SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
                slot:EnableDrag(0); 
                slot:SetOverSound('button_cursor_over_2');
                slot:SetClickSound('button_click');

                local icon      = slot:GetIcon();
                icon:SetColorTone('33333333')
                itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)

                local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
                itemtext:SetText(dragRecipeItem.Name);

                y = y + itemHeight;
                itemCount = itemCount + 1;
            end

            if dragRecipeItem ~= nil then
                local_dragrecipeitem = dragRecipeItem;
            end
        end
    end

    -- edittext Reset
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlset, "itemcount");
    if edit_itemcount ~= nil then
        edit_itemcount:SetText(recipecls.TargetItemCnt);
    end

    local height = 0;   
    if y < minHeight then
        height = minHeight;
    else
        height = 120 + (itemCount * 55);
    end;
        
    local lableLine = GET_CHILD(ctrlset, "labelline_1");
    local exchangeCountText = GET_CHILD(ctrlset, "exchangeCount");  
    
    local exchangeCountTextFlag = 0
    if recipecls.NeedProperty ~= 'None' then
        local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
        local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
        local cntText = string.format("%d", sCount).. ScpArgMsg("Excnaged_Count_Remind");
        local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
        if sCount <= 0 then
            cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
        end;
        exchangeCountText:SetTextByKey("value", cntText);

        lableLine:SetPos(0, height);
        height = height + 10 + lableLine:GetHeight();
        exchangeCountText:SetPos(0, height);
        height = height + 10 + exchangeCountText:GetHeight() + 15;
        lableLine:SetVisible(1);
        exchangeCountText:SetVisible(1);
        exchangeCountTextFlag = 1
    end;
    
    if recipecls.AccountNeedProperty ~= 'None' then
        local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
        local cntText = ScpArgMsg("Excnaged_AccountCount_Remind","COUNT",string.format("%d", sCount))
        local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
        if sCount <= 0 then
            cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
        end;
        
        exchangeCountText:SetTextByKey("value", cntText);

        lableLine:SetPos(0, height);
        height = height + 10 + lableLine:GetHeight();
        exchangeCountText:SetPos(0, height);
        height = height + 10 + exchangeCountText:GetHeight() + 15;
        lableLine:SetVisible(1);
        exchangeCountText:SetVisible(1);
        exchangeCountTextFlag = 1
    end
    
    if exchangeCountTextFlag == 0 then
        height = height+ 20;
        lableLine:SetVisible(0);
        exchangeCountText:SetVisible(0);
    end;

    ctrlset:Resize(ctrlset:GetWidth(), height);
    GBOX_AUTO_ALIGN(groupbox, 0, 0, 10, true, false);

    groupbox:SetUserValue("HEIGHT_SIZE", groupbox:GetUserIValue("HEIGHT_SIZE") + ctrlset:GetHeight())
    groupbox:Resize(groupbox:GetWidth(), groupbox:GetUserIValue("HEIGHT_SIZE"));
    page:SetSlotSize(ctrlset:GetWidth(), ctrlset:GetHeight() + 40)
end

function EARTH_TOWER_SHOP_EXEC(parent, ctrl)
    local_parent = parent;
    local_control = ctrl;

    local parentcset = ctrl:GetParent();
    local edit_itemcount = GET_CHILD_RECURSIVELY(parentcset, "itemcount");
    if edit_itemcount == nil then 
        return; 
    end

    local itemCountGBox = GET_CHILD_RECURSIVELY(parentcset, "gbox");
    local resultCount = tonumber(edit_itemcount:GetText());
    if itemCountGBox:IsVisible() == 0 then
        resultCount = 1;
    end

    local recipecls = GetClass('ItemTradeShop', parent:GetName());
    if recipecls ~= nil then
        local isExceptionFlag = false;
        for index = 1, 5 do
            local clsName = "Item_"..index.."_1";
            local itemName = recipecls[clsName];
            local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist = GET_RECIPE_MATERIAL_INFO(recipecls, index);

            if dragRecipeItem ~= nil then
                local itemCount = GET_TOTAL_ITEM_CNT(dragRecipeItem.ClassID);
                if itemCount < recipeItemCnt * resultCount then
                    ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
                    isExceptionFlag = true;
                    break;
                end
            end
        end

        if isExceptionFlag == true then
            isExceptionFlag = false;
            return;
        end
    end
    local frame = local_parent:GetTopParentFrame();
    local shopType = frame:GetUserValue("SHOP_TYPE");
    if recipecls==nil or recipecls["Item_2_1"] ~='None' then
        AddLuaTimerFuncWithLimitCountEndFunc("EARTH_TOWER_SHOP_TRADE_ENTER", 100, resultCount - 1, "EARTH_TOWER_SHOP_TRADE_LEAVE");
    else
        AddLuaTimerFuncWithLimitCountEndFunc("EARTH_TOWER_SHOP_TRADE_ENTER", 100, 0, "EARTH_TOWER_SHOP_TRADE_LEAVE");
    end
end

function EARTH_TOWER_SHOP_TRADE_ENTER()
    local frame = local_parent:GetTopParentFrame();
    if frame:GetName() == 'legend_craft' then
        LEGEND_CRAFT_EXECUTE(local_parent, local_control);
        return;
    end

    local parentcset = local_control:GetParent()
    local frame = local_control:GetTopParentFrame(); 
    
    if frame:GetName() == 'legend_craft' then
       LEGEND_CRAFT_EXECUTE(local_parent, local_control);
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

    session.ResetItemList();

    local pc = GetMyPCObject();
    if pc == nil then
        return;
    end

    local recipeCls = GetClass("ItemTradeShop", parentcset:GetName())
    for index = 1, 5 do
        local clsName = "Item_"..index.."_1";
        local itemName = recipeCls[clsName];
        local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist = GET_RECIPE_MATERIAL_INFO(recipeCls, index);

        if dragRecipeItem ~= nil then
            local itemCount = GET_TOTAL_ITEM_CNT(dragRecipeItem.ClassID);
            if itemCount < recipeItemCnt then
                ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
                break;
            end
        end

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
    end

    local resultlist = session.GetItemIDList();
    local cntText = string.format("%s %s", recipeCls.ClassID, 1);
    
    local edit_itemcount = GET_CHILD_RECURSIVELY(parentcset, "itemcount");
    if edit_itemcount == nil then 
        return; 
    end

    local itemCountGBox = GET_CHILD_RECURSIVELY(parentcset, "gbox");
    local resultCount = tonumber(edit_itemcount:GetText());
    if itemCountGBox:IsVisible() == 0 then
        resultCount = 1;
    end
    cntText = string.format("%s %s", recipeCls.ClassID, resultCount);
    local shopType = frame:GetUserValue("SHOP_TYPE");
    if shopType == 'EarthTower' then
        item.DialogTransaction("EARTH_TOWER_SHOP_TREAD", resultlist, cntText);
    elseif shopType == 'EarthTower2' then
        item.DialogTransaction("EARTH_TOWER_SHOP_TREAD2", resultlist, cntText);
    elseif shopType == 'EventShop' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD", resultlist, cntText);
    elseif shopType == 'EventShop2' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD2", resultlist, cntText);
    elseif shopType == 'KeyQuestShop1' then
        item.DialogTransaction("KEYQUESTSHOP1_SHOP_TREAD", resultlist, cntText);
    elseif shopType == 'KeyQuestShop2' then
        item.DialogTransaction("KEYQUESTSHOP2_SHOP_TREAD", resultlist, cntText);
    elseif shopType == 'HALLOWEEN' then
        item.DialogTransaction("HALLOWEEN_SHOP_TREAD", resultlist, cntText);
    elseif shopType == 'EventShop3' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD3", resultlist, cntText);  
    elseif shopType == 'EventShop4' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD4", resultlist, cntText);
    elseif shopType == 'EventShop8' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD8", resultlist, cntText);
    elseif shopType == 'PVPMine' then
        item.DialogTransaction("PVP_MINE_SHOP", resultlist, cntText);
    elseif shopType == 'MCShop1' then
        item.DialogTransaction("MASSIVE_CONTENTS_SHOP_TREAD1", resultlist, cntText);
    elseif shopType == 'DailyRewardShop' then
        item.DialogTransaction("DAILY_REWARD_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'Bernice' then
        item.DialogTransaction("SoloDungeon_Bernice_SHOP", resultlist, cntText);
    elseif shopType == 'VividCity2_Shop' then
        item.DialogTransaction("EVENT_VIVID_CITY2_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'EventShop9' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD9", resultlist, cntText);
    elseif shopType == 'EventShop10' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD10", resultlist, cntText);
    end
end

function EARTH_TOWER_SHOP_TRADE_LEAVE()
    session.ResetItemList();

    local ctrlSet = local_control:GetParent();
    local recipecls = GetClass('ItemTradeShop', ctrlSet:GetName());
    if recipecls == nil then
        return;
    end

    local targetItem = GetClass("Item", recipecls.TargetItem);

    -- itemName Reset
    local itemName = GET_CHILD_RECURSIVELY(ctrlSet, "itemName");
    if itemName ~= nil then
        itemName:SetTextByKey("value", targetItem.Name.." ["..recipecls.TargetItemCnt..ScpArgMsg("Piece").."]");
    end

    for i = 1, 5 do
        if recipecls["Item_"..i.."_1"] ~= "None" then
            local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
            local eachSet = GET_CHILD_RECURSIVELY(ctrlSet, "EACHMATERIALITEM_"..i);
            if invItemlist == nil and eachSet~=nil then
               -- needCount Reset
               local needCount = GET_CHILD_RECURSIVELY(eachSet, "needcount");
               needCount:SetTextByKey("count", recipeItemCnt)
                
               -- material icon Reset
               eachSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');

               local slot = GET_CHILD_RECURSIVELY(eachSet, "slot");
               if slot ~= nil then
                   SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                   slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                   slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                   slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
                   slot:EnableDrag(0); 
                   slot:SetOverSound('button_cursor_over_2');
                   slot:SetClickSound('button_click');

                   local icon = slot:GetIcon();
                   icon:SetColorTone('33333333')
                   eachSet:SetUserValue("ClassName", dragRecipeItem.ClassName)
               end

               -- btn Reset
               local btn = GET_CHILD_RECURSIVELY(eachSet, "btn");
               if btn ~= nil then
                    btn:ShowWindow(1);
               end
            end
        end
    end

    -- edittext Reset
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlSet, "itemcount");
    if edit_itemcount ~= nil then
        edit_itemcount:SetText(recipecls.TargetItemCnt);
    end

    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
    RESET_INVENTORY_ICON();

    ctrlSet:Invalidate();
end

function EARTHTOWERSHOP_UPBTN(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end

    if frame == nil then
        return
    end
        
    local topFrame = frame:GetTopParentFrame()
    if topFrame == nil then
        return
    end

    EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, 1);
end

function EARTHTOWERSHOP_DOWNBTN(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end

    if frame == nil then
        return
    end
        
    local topFrame = frame:GetTopParentFrame()
    if topFrame == nil then
        return
    end

    EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, -1);
end

function EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, change)
    if ctrl == nil then return; end

    local gbox = ctrl:GetParent(); if gbox == nil then return; end
    local parentCtrl = gbox:GetParent(); if parentCtrl == nil then return; end
    local ctrlset = parentCtrl:GetParent(); if ctrlset == nil then return; end
    local cnt = ctrlset:GetChildCount();

    -- item count increase
    local countText = EARTHTOWERSHOP_CHANGECOUNT_NUM_CHANGE(ctrlset,change)
    if cnt ~= nil then
        for i = 0, cnt - 1 do
            local eachSet = ctrlset:GetChildByIndex(i);
            if string.find(eachSet:GetName(), "EACHMATERIALITEM_") ~= nil then
                local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
                local targetItem = GetClass("Item", recipecls.TargetItem);
                
                -- item Name Setting
                local targetItemName_text = GET_CHILD_RECURSIVELY(ctrlset, "itemName");
                if targetItem.StringArg == "EnchantJewell" then
                    targetItemName_text:SetTextByKey("value", "[Lv. "..recipecls.TargetItemAppendValue.."] "..targetItem.Name .. " [" .. countText .. ScpArgMsg("Piece") .. "]");
                else
                    targetItemName_text:SetTextByKey("value", targetItem.Name.."["..countText..ScpArgMsg("Piece").."]");
                end            

                for j = 1, 5 do
                    if recipecls["Item_"..j.."_1"] ~= "None" then
                       local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, "Item_"..j.."_1");

                       -- needCnt Setting
                       local needcountText = GET_CHILD_RECURSIVELY(eachSet, "needcount", "ui::CSlot");
                       needcountText:SetTextByKey("count", countText * recipeItemCnt);
                    end
                end
            end

            eachSet:Invalidate();
        end
    end
end

function UPDATE_EARTHTOWERSHOP_CHANGECOUNT(parent, ctrl)
    EARTHTOWERSHOP_CHANGECOUNT(parent,ctrl,0)
end

function EARTHTOWERSHOP_CHANGECOUNT_NUM_CHANGE(ctrlset,change)
    
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlset, "itemcount");
    local countText = tonumber(edit_itemcount:GetText());
    if countText == nil then
        countText = 0
    end
    countText = countText + change
    if countText < 0 then
        countText = 0
    elseif countText>9999 then
        countText = 9999
    end
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    if recipecls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
        local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
        if sCount < countText then
            countText = sCount
        end
    end
    if recipecls.AccountNeedProperty ~= 'None' then
        local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
        if sCount < countText then
            countText = sCount
        end
    end
    edit_itemcount:SetText(countText);
    return countText;
end