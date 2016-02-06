-- equip_tooltip.lua

function ITEM_TOOLTIP_WEAPON(tooltipframe, invitem, strarg, usesubframe)

	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)
end

function ITEM_TOOLTIP_ARMOR(tooltipframe, invitem, strarg, usesubframe)

	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe) 
end

function ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'equip_main'
	local addinfoframename = 'equip_main_addinfo'
	local drawnowequip = 'true'
	
	if usesubframe == "usesubframe" then
		mainframename = 'equip_sub'
		addinfoframename = 'equip_sub_addinfo'
	elseif usesubframe == "usesubframe_recipe" then
		mainframename = 'equip_sub'
		addinfoframename = 'equip_sub_addinfo'
		drawnowequip = 'false'
	end

	local ypos = DRAW_EQUIP_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, drawnowequip); -- 장비라면 공통적으로 그리는 툴팁들
	
	ypos = DRAW_ITEM_TYPE_N_WEIGHT(tooltipframe, invitem, ypos, mainframename) -- 타입, 무게.

    if invitem.BasicTooltipProp ~= 'None' then
        ypos = DRAW_EQUIP_ATK_N_DEF(tooltipframe, invitem, ypos, mainframename, strarg) -- 공격력, 방어력, 타입 아이콘 
    end

	local addinfoGBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox') -- 젬 툴팁 위치 삽입
	addinfoGBox:SetOffset(addinfoGBox:GetX(),ypos)
	addinfoGBox:Resize(addinfoGBox:GetOriginalWidth(),0)
	
	ypos = DRAW_EQUIP_PROPERTY(tooltipframe, invitem, ypos, mainframename) -- 각종 프로퍼티
	ypos = DRAW_EQUIP_SET(tooltipframe, invitem, ypos, mainframename) -- 세트아이템
	ypos = DRAW_EQUIP_MEMO(tooltipframe, invitem, ypos, mainframename) -- 제작 템 시 들어간 메모
	ypos = DRAW_EQUIP_DESC(tooltipframe, invitem, ypos, mainframename) -- 각종 프로퍼티
	ypos = DRAW_AVAILABLE_PROPERTY(tooltipframe, invitem, ypos, mainframename) -- 장착제한, 거래제한, 소켓, 레벨 제한 등등
	ypos = DRAW_EQUIP_PR_N_DUR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 및 내구도
	ypos = DRAW_EQUIP_ONLY_PR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 만 있는 애들은 여기서 그림 (그릴 아이템인지 검사는 내부에서)
	ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);

	local subframeypos = 0

	--서브프레임쪽.
	if IS_NEED_DRAW_GEM_TOOLTIP(invitem) == true then
		subframeypos = DRAW_EQUIP_SOCKET(tooltipframe, invitem, subframeypos, addinfoframename) -- 소켓 및 옵션
	end

	if IS_NEED_DRAW_MAGICAMULET_TOOLTIP(invitem) == true then
		subframeypos = DRAW_EQUIP_MAGICAMULET(tooltipframe, invitem, subframeypos, addinfoframename) -- 매직어뮬렛
	end

	--tooltipframe:Resize(tooltipframe:GetOriginalWidth(), ypos);

end

-- 기본 정보
function DRAW_EQUIP_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, drawnowequip)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()

    if invitem.ItemGrade == 0 then -- 유료 프리미엄 아이템 등급: 2~3만원 헤어
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('premium_skin');
    else
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('test_Item_tooltip_equip');
    end

	local equipCommonCSet = gBox:CreateControlSet('tooltip_equip_common', 'equip_common_cset', 0, 0);
	tolua.cast(equipCommonCSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = equipCommonCSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 아이템 배경 이미지 : grade기준
	local item_bg = GET_CHILD(equipCommonCSet, "item_bg", "ui::CPicture");
	local gradeBGName = GET_ITEM_BG_PICTURE_BY_GRADE(invitem.ItemGrade)
	item_bg:SetImage(gradeBGName);

	-- 아이템 이미지
	local itemPicture = GET_CHILD(equipCommonCSet, "itempic", "ui::CPicture");
	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
	
    	if invitem.ClassType ~= 'Outer' then
    		itemPicture:SetImage(invitem.TooltipImage);
    		itemPicture:ShowWindow(1);
    	else -- 코스튬은 남녀공용, 남자PC는 남자 코스튬 툴팁이미지, 여자PC는 여자 코스튬 툴팁이미지가 보임
            local gender = 0;
            if GetMyPCObject() ~= nil then
                local pc = GetMyPCObject();
                gender = pc.Gender;
            else
                gender = barrack.GetSelectedCharacterGender();
            end

			local tempiconname = string.sub(invitem.TooltipImage,string.len(invitem.TooltipImage)-1);

			if tempiconname ~= "_m" and tempiconname ~= "_f" then
    	    if gender == 1 then
        	    tooltipImg = invitem.TooltipImage.."_m"
        		itemPicture:SetImage(tooltipImg);
        	else
        	    tooltipImg = invitem.TooltipImage.."_f"
        		itemPicture:SetImage(tooltipImg);
        	end
			else
				itemPicture:SetImage(invitem.TooltipImage);
			end

    	    
    	end
	else
		itemPicture:ShowWindow(0);
	end


	-- 장착중 아이콘 
	local itemNowEquip = GET_CHILD(equipCommonCSet, "nowequip");
	if mainframename == 'equip_sub' and drawnowequip == 'true' then
		itemNowEquip:ShowWindow(1)
	else
		itemNowEquip:ShowWindow(0)
	end

	
	-- 거래불가 아이콘 (일단 거래불가 아이콘 표시하지 않음)
	local itemCantSoldPicture = GET_CHILD(equipCommonCSet, "cantsold", "ui::CPicture");
	local itemCantSoldText = GET_CHILD(equipCommonCSet, "cantsold_text", "ui::CRichText");
	if invitem.UserTrade == "NO" then
		itemCantSoldPicture:ShowWindow(1);
		itemCantSoldText:ShowWindow(1);
	else
		itemCantSoldPicture:ShowWindow(0);
		itemCantSoldText:ShowWindow(0);
	end

	-- 강화불가 
	local itemCantRFPicture = GET_CHILD(equipCommonCSet, "cantreinforce", "ui::CPicture");
	local itemCantRFText = GET_CHILD(equipCommonCSet, "cantrf_text", "ui::CPicture");
	if invitem.Reinforce_Type == "None" then
		itemCantRFPicture:ShowWindow(1);
		itemCantRFText:ShowWindow(1);
	else
		itemCantRFPicture:ShowWindow(0);
		itemCantRFText:ShowWindow(0);
	end

	-- 별 그리기
	SET_GRADE_TOOLTIP(equipCommonCSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(equipCommonCSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+equipCommonCSet:GetHeight())

	local retypos = equipCommonCSet:GetHeight();

	return retypos;
end


--아이템 타입 및 무게
function DRAW_ITEM_TYPE_N_WEIGHT(tooltipframe, invitem, yPos, mainframename)
	
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')

	-- 아이템 타입 설정
	gBox:RemoveChild('tooltip_equip_type_n_weight');

--	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
--	if classtype ~= nil then
--		if classtype == "Outer" then
--			return yPos;
--		end
--	end

	local tooltip_equip_type_n_weight_Cset = gBox:CreateOrGetControlSet('tooltip_equip_type_n_weight', 'tooltip_equip_type_n_weight', 0, yPos);

	local typeChild = GET_CHILD(tooltip_equip_type_n_weight_Cset,'type','ui::CRichText');
	typeChild:SetText(GET_REQ_TOOLTIP(invitem));
	typeChild:ShowWindow(1);

	local weightChild = GET_CHILD(tooltip_equip_type_n_weight_Cset,'weight','ui::CRichText');
	weightChild:SetTextByKey("weight",invitem.Weight..' ');
	weightChild:ShowWindow(1);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+tooltip_equip_type_n_weight_Cset:GetHeight())
	return tooltip_equip_type_n_weight_Cset:GetHeight() + tooltip_equip_type_n_weight_Cset:GetY();
end


--공격력 및 방어력
function DRAW_EQUIP_ATK_N_DEF(tooltipframe, invitem, yPos, mainframename, strarg)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_atk_n_def');
	local tooltip_equip_atk_n_def_Cset = gBox:CreateOrGetControlSet('tooltip_equip_atk_n_def', 'tooltip_equip_atk_n_def', 0, yPos);
    
	local typeiconname = nil
	local typestring = nil
	local arg1 = nil
	local arg2 = nil
	local reinforceaddvalue = 0

	-- 무기 타입 아이콘
	local basicProp = invitem.BasicTooltipProp;
	
	if basicProp == 'ATK' then
        typeiconname = 'test_sword_icon'
    	typestring = ScpArgMsg("Melee_Atk")
    	reinforceaddvalue = math.floor( GET_REINFORCE_ADD_VALUE_ATK(invitem) )
    	arg1 = invitem.MINATK - reinforceaddvalue
    	arg2 = invitem.MAXATK - reinforceaddvalue
    elseif basicProp == 'MATK' then
        typeiconname = 'test_sword_icon'
    	typestring = ScpArgMsg("Magic_Atk")
    	reinforceaddvalue = math.floor( GET_REINFORCE_ADD_VALUE_ATK(invitem) )
    	arg1 = invitem.MATK - reinforceaddvalue
    	arg2 = invitem.MATK - reinforceaddvalue
    else
    	typeiconname = 'test_shield_icon'
    	typestring = ScpArgMsg(basicProp);
		SCR_REFRESH_ARMOR(invitem);
    	reinforceaddvalue = GET_REINFORCE_ADD_VALUE(basicProp, invitem);
    	arg1 = TryGetProp(invitem, basicProp) - reinforceaddvalue;
        arg2 = TryGetProp(invitem, basicProp) - reinforceaddvalue;
    end
	
	SET_DAMAGE_TEXT(tooltip_equip_atk_n_def_Cset, typestring, typeiconname, arg1, arg2, 1, reinforceaddvalue);
	yPos = yPos + tooltip_equip_atk_n_def_Cset:GetHeight();

	yPos = SET_BUFF_TEXT(gBox, invitem, yPos, strarg);

	yPos = SET_REINFORCE_TEXT(gBox, invitem, yPos);
	
	gBox:Resize(gBox:GetWidth(),  yPos);
	return yPos;
end

-- 아이템에 의한 추가 속성 정보 (광역공격 +1)
function DRAW_EQUIP_PROPERTY(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe,mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_property');

	local baseicList = GET_EQUIP_TOOLTIP_PROP_LIST(invitem);

	local list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(baseicList, invitem.BasicTooltipProp)
	local list2 = GET_EUQIPITEM_PROP_LIST();

	local cnt = 0
	for i = 1 , #list do
		local propName = list[i];
		local propValue = invitem[propName];
		
		if propValue ~= 0 then 
			if  invitem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					cnt = cnt +1
				end
			elseif  invitem.GroupName == 'Armor' then
				if invitem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						cnt = cnt +1
					end
				elseif invitem.ClassType == 'Boots' then
					if propName ~= "DR" then
						cnt = cnt +1
					end
				else
					if propName ~= "DEF" then
						cnt = cnt +1
					end
				end
			else
				cnt = cnt +1
			end
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = invitem[propName];
		if propValue ~= 0 then

			cnt = cnt +1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			cnt = cnt +1
		end
	end

	if cnt <= 0 and (invitem.OptDesc == nil or invitem.OptDesc == "None") then -- 일단 그릴 프로퍼티가 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		return yPos
	end
	
	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	local class = GetClassByType("Item", invitem.ClassID);

	local inner_yPos = 0;

	for i = 1 , #list do
		local propName = list[i];
		local propValue = invitem[propName];
		if class[propName] ~= 0 then
			if  invitem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
					inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
				end
			elseif  invitem.GroupName == 'Armor' then
				if invitem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				elseif invitem.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				end
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(invitem[propName]));
			local strInfo = ABILITY_DESC_PLUS(opName, invitem[propValue], 0);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = invitem[propName];
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), class[propName], invitem[propName]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	if invitem.OptDesc ~= nil and invitem.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, invitem.OptDesc, 0, inner_yPos);
	end

	if invitem.IsAwaken == 1 then
		local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(invitem.HiddenProp));
		local strInfo = ABILITY_DESC_PLUS(opName, invitem.HiddenPropValue, invitem[invitem.HiddenProp]);
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 제작 시 넣은 메모
function DRAW_EQUIP_MEMO(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_memo');

	local memo = invitem.Memo
	if memo == "None" then -- 일단 메모가 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		return yPos
	end
	
	memo = ScpArgMsg("ItIsMemo") ..memo
	
	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_memo', 'tooltip_equip_memo', 0, yPos);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')
		
	local inner_yPos = 0;
	inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, memo, 0, inner_yPos);
	
	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 아이템에 의한 추가 속성 정보 (광역공격 +1 둥등)
function DRAW_EQUIP_DESC(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_desc');

	local desc = GET_ITEM_TOOLTIP_DESC(invitem);
	if desc == "" then -- 일단 그릴 소켓이 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		return yPos
	end
	
	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_desc', 'tooltip_equip_desc', 0, yPos);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')
		
	local inner_yPos = 0;
	inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, desc, 0, inner_yPos);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 소켓 정보
function DRAW_EQUIP_SOCKET(tooltipframe, invitem, yPos, addinfoframename)
	local gBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_socket');
	
	local tooltip_equip_socket_CSet = gBox:CreateOrGetControlSet('tooltip_equip_socket', 'tooltip_equip_socket', 0, yPos);
	local socket_gbox= GET_CHILD(tooltip_equip_socket_CSet,'socket_gbox','ui::CGroupBox')

	local inner_yPos = 0;


	for i=0, invitem.MaxSocket-1 do
		if invitem['Socket_' .. i] > 0 then
			inner_yPos = ADD_ITEM_SOCKET_PROP(socket_gbox, invitem, 
												invitem['Socket_' .. i], 
												invitem['Socket_Equip_' .. i], 
												invitem['SocketItemExp_' .. i],
												invitem['Socket_JamLv_' ..i],
												inner_yPos);
		end
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_socket_CSet:Resize(tooltip_equip_socket_CSet:GetWidth(),tooltip_equip_socket_CSet:GetHeight() + socket_gbox:GetHeight() + socket_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_socket_CSet:GetHeight())
	return tooltip_equip_socket_CSet:GetHeight() + tooltip_equip_socket_CSet:GetY();
end

-- 매직어뮬렛 정보
function DRAW_EQUIP_MAGICAMULET(subframe, invitem, yPos,addinfoframename)

	local gBox = GET_CHILD(subframe, addinfoframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_magicamulet');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_equip_magicamulet', 'tooltip_equip_magicamulet', 0, yPos);
	local amulet_gbox= GET_CHILD(CSet,'magicamulet_gbox','ui::CGroupBox')

	local inner_yPos = 0;


	for i=0, invitem.MaxSocket_MA-1 do
		if invitem['MagicAmulet_' .. i] > 0 then

			local amuletitemclass = GetClassByType('Item',invitem['MagicAmulet_' .. i]);

			local each_amulet_cset = amulet_gbox:CreateControlSet('tooltip_item_prop_magicamulet', 'tooltip_item_prop_magicamulet'..i, 0, inner_yPos);
			local amulet_image = GET_CHILD(each_amulet_cset,'amulet_image','ui::CPicture')
			local amulet_name = GET_CHILD(each_amulet_cset,'amulet_name','ui::CRichText')
			local amulet_desc = GET_CHILD(each_amulet_cset,'amulet_desc','ui::CRichText')
			local labelline = each_amulet_cset:GetChild("labelline")
			
			if yPos == 0 and i == 0 then
				labelline:ShowWindow(0)
			else
				labelline:ShowWindow(1)
			end

			amulet_image:SetImage(amuletitemclass.Icon)
			amulet_name:SetText(amuletitemclass.Name)
			amulet_desc:SetText(amuletitemclass.Desc)

			inner_yPos = inner_yPos + each_amulet_cset:GetHeight()

		end
	end

	amulet_gbox:Resize(amulet_gbox:GetOriginalWidth(),inner_yPos);

	local BOTTOM_MARGIN = subframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + amulet_gbox:GetHeight() + amulet_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--세트 아이템
function DRAW_EQUIP_SET(tooltipframe, invitem, ypos, mainframename)

	local gBox = GET_CHILD(tooltipframe,mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_set');

	local itemProp = geItemTable.GetProp(invitem.ClassID);
	local set = itemProp.setInfo;
	if set == nil then
		return ypos;
	end
	
	local tooltip_CSet = gBox:CreateControlSet('tooltip_set', 'tooltip_set', 0, ypos);
	tolua.cast(tooltip_CSet, "ui::CControlSet");
	local set_gbox_img= GET_CHILD(tooltip_CSet,'set_gbox_img','ui::CGroupBox')
	local set_gbox_prop= GET_CHILD(tooltip_CSet,'set_gbox_prop','ui::CGroupBox')

	local cnt =	set:GetItemCount();


	-- 세트아이템 이미지 그려주는 부분
	local inner_yPos = 0;
	local inner_xPos = 0;
	local set_gbox_img_new_height = 0;

	local a_image_height = tooltip_CSet:GetUserConfig("SET_IMAGE_HEIGHT")
	local a_image_margin = tooltip_CSet:GetUserConfig("SET_IMAGE_MARGIN_BETWEEN_EACH_IMAGE")
	
	local COUNT_OF_EACHLINE = 3;

	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		local cls = GetClass("Item", clsName);

		if cls ~= nil then
			local name = set:GetItemName(i);
		
			local each_img_CSet = set_gbox_img:CreateControlSet('tooltip_set_each_img', 'each_img_CSet'..i, inner_xPos, inner_yPos);
			tolua.cast(each_img_CSet, "ui::CControlSet");
			local set_image = GET_CHILD(each_img_CSet,'set_image','ui::CPicture')
			local imgName = GET_ICON_BY_NAME(cls.ClassName);

			set_image:SetImage(imgName)			

			if GET_EQP_ITEM_CNT(cls.ClassID) > 0 then
				set_image:SetColorTone(tooltip_CSet:GetUserConfig("HAVE_ITEM_TONE"));
			else
				set_image:SetColorTone(tooltip_CSet:GetUserConfig("HAVENT_ITEM_TONE"));
			end

			if i == COUNT_OF_EACHLINE and cnt -1 ~= COUNT_OF_EACHLINE then
				inner_yPos = a_image_height;
				inner_xPos = 0
			else
				inner_xPos = inner_xPos + each_img_CSet:GetWidth() + a_image_margin
			end

		end
		
	end
	set_gbox_img:Resize( set_gbox_img:GetWidth() ,a_image_height + inner_yPos)

	-- 세트아이템 세트 효과 텍스트 표시 부분
	inner_yPos = 0;
	inner_xPos = 0;
	local curCnt = GET_EQUIPED_SET_COUNT(set);

	local AVAIABLE_EFT_FONT_COLOR = tooltip_CSet:GetUserConfig("AVAIABLE_EFT_FONT_COLOR")
	local UNAVAIABLE_EFT_FONT_COLOR = tooltip_CSet:GetUserConfig("UNAVAIABLE_EFT_FONT_COLOR")
	
	for i = 0, cnt -1 do
		
		local setEffect = set:GetSetEffect(i);
		if setEffect ~= nil then

			local color = AVAIABLE_EFT_FONT_COLOR
			if curCnt >= i + 1 then
				color = UNAVAIABLE_EFT_FONT_COLOR
			end

			local setTitle = ScpArgMsg("Auto_{s16}{Auto_1}{Auto_2}_SeTeu_HyoKwa_:_", "Auto_1",color, "Auto_2",i + 1);
			local setDesc = string.format("{s16}%s%s", color, setEffect:GetDesc());
	
			local each_text_CSet = set_gbox_prop:CreateControlSet('tooltip_set_each_prop_text', 'each_text_CSet'..i, inner_xPos, inner_yPos);
			tolua.cast(each_text_CSet, "ui::CControlSet");
			local set_text = GET_CHILD(each_text_CSet,'set_prop_Text','ui::CRichText')
			set_text:SetTextByKey("setTitle",setTitle)
			set_text:SetTextByKey("setDesc",setDesc)

			each_text_CSet:Resize(each_text_CSet:GetWidth(), set_text:GetHeight());

			inner_yPos = inner_yPos + set_text:GetHeight();
		end		
	end
	set_gbox_prop:Resize( set_gbox_prop:GetWidth() ,inner_yPos)
	set_gbox_prop:SetOffset(set_gbox_prop:GetX(),set_gbox_img:GetY()+set_gbox_img:GetHeight())

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_CSet:Resize(tooltip_CSet:GetWidth(), set_gbox_prop:GetHeight() + set_gbox_prop:GetY() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_CSet:GetHeight())

	return tooltip_CSet:GetHeight() + tooltip_CSet:GetY();

end


--각종 제한사항(렙제, 직업제한, 소켓 등등)
function DRAW_AVAILABLE_PROPERTY(tooltipframe, invitem, yPos,mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_available_property');
	
	local tooltip_available_property_CSet = gBox:CreateControlSet('tooltip_available_property', 'tooltip_available_property', 0, yPos);
	tolua.cast(tooltip_available_property_CSet, "ui::CControlSet");

	local levelNusejob_text = GET_CHILD(tooltip_available_property_CSet,'levelNusejob','ui::CRichText')
	local maxSocekt_text = GET_CHILD(tooltip_available_property_CSet,'maxSocket','ui::CRichText')
	--local usertradeNshoptrade_text = GET_CHILD(tooltip_available_property_CSet,'usertradeNshoptrade','ui::CRichText')

	--local AVAIABLE_PROP_FONT_COLOR = tooltip_available_property_CSet:GetUserConfig("AVAIABLE_PROP_FONT_COLOR")
	--local UNAVAIABLE_PROP_FONT_COLOR = tooltip_available_property_CSet:GetUserConfig("UNAVAIABLE_PROP_FONT_COLOR")

	--레벨제한 표시
	if invitem.UseLv > 1 then
		levelNusejob_text:SetTextByKey("level",invitem.UseLv..ScpArgMsg("EQUIP_LEVEL"));
	else
		levelNusejob_text:SetTextByKey("level",ScpArgMsg("UNLIMITED_ITEM_LEVEL"));
	end

	--장착제한 표시
	levelNusejob_text:SetTextByKey("usejob",GET_USEJOB_TOOLTIP(invitem));

	maxSocekt_text:SetOffset(maxSocekt_text:GetX(),levelNusejob_text:GetY() + levelNusejob_text:GetHeight() + 5)

	--소켓제한 표시
	if invitem.MaxSocket <= 0 then
		maxSocekt_text:SetText(ScpArgMsg("CantAddSocket"))
	else
		maxSocekt_text:SetTextByKey("socketcount",invitem.MaxSocket);
	end

	--유저간 거래 제한 표시 : 아이콘만 표시하고 문구는 표시하지 않도록 바꿨다. (140718)
	--[[
	if invitem.UserTrade == "YES" then
		usertradeNshoptrade_text:SetTextByKey("usertrade",ScpArgMsg("Auto_Kaein_KeoLae_KaNeung"));
	elseif invitem.UserTrade == "NO" then
		usertradeNshoptrade_text:SetTextByKey("usertrade",ScpArgMsg("Auto_Kaein_KeoLae_BulKaNeung"));
	else
		usertradeNshoptrade_text:SetTextByKey("usertrade","ERROR! check item.UserTrade");
	end

	--상점 거래 제한 표시
	if invitem.ShopTrade == "YES" then
		usertradeNshoptrade_text:SetTextByKey("shoptrade",ScpArgMsg("Auto_SangJeom_PanMae_KaNeung"));
	elseif invitem.ShopTrade == "NO" then
		usertradeNshoptrade_text:SetTextByKey("shoptrade",ScpArgMsg("Auto_SangJeom_PanMae_BulKaNeung"));
	else
		usertradeNshoptrade_text:SetTextByKey("shoptrade","ERROR! check item.ShopTrade");
	end
	]]


	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_available_property_CSet:Resize(tooltip_available_property_CSet:GetWidth(),maxSocekt_text:GetY() + maxSocekt_text:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_available_property_CSet:GetHeight())
	return tooltip_available_property_CSet:GetHeight() + tooltip_available_property_CSet:GetY();
end


--포텐 및 내구도
function DRAW_EQUIP_PR_N_DUR(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_pr_n_dur');

	local itemClass = GetClassByType("Item", invitem.ClassID);
	if invitem.GroupName ~= "Armor" and invitem.GroupName ~= "Weapon" then -- 내구도 개념이 없는 템

	    if invitem.BasicTooltipProp == "None" then
    		return yPos;
		end
	end

	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
	if classtype ~= nil then
		if classtype == "Outer" or classtype == "Hat" or classtype == "Hair" then
			return yPos;
		end
	end
	
	local CSet = gBox:CreateControlSet('tooltip_pr_n_dur', 'tooltip_pr_n_dur', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	local inf_value = CSet:GetUserConfig("INF_VALUE")

	local pr_gauge = GET_CHILD(CSet,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(invitem.PR, itemClass.PR);

	local dur_gauge = GET_CHILD(CSet,'dur_gauge','ui::CGauge')
	local temparg1 = math.floor(invitem.Dur/100);
	local temparg2 = math.floor(invitem.MaxDur/100);
	if  invitem.MaxDur == -1 then
		dur_gauge:SetPoint(inf_value, inf_value);
	else
		dur_gauge:SetPoint(temparg1, temparg2);
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--악세서리 등 포텐만 존재하는 녀석 들
function DRAW_EQUIP_ONLY_PR(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_only_pr');

	local itemClass = GetClassByType("Item", invitem.ClassID);

	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
	if classtype ~= nil then
		if classtype == "Outer" or classtype == "Hat" then
			
		else
			return yPos;
		end
	end
	
	local CSet = gBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	local inf_value = CSet:GetUserConfig("INF_VALUE")

	local pr_gauge = GET_CHILD(CSet,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(invitem.PR, itemClass.PR);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
en