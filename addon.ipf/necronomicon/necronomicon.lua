
function NECRONOMICON_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("UPDATE_NECRONOMICON_UI", "NECRONOMICON_MSG");
	addon:RegisterMsg("DO_OPEN_NECRONOMICON_UI", "NECRONOMICON_MSG");
end

function NECRONOMICON_MSG(frame, msg, argStr, argNum)

	if msg == "UPDATE_NECRONOMICON_UI" then
		UPDATE_NECRONOMICON_UI(frame)		
	elseif msg == "DO_OPEN_NECRONOMICON_UI" then
		frame:ShowWindow(1);
	end
end

function SET_NECRO_CARD_STATE(frame, bosscardcls, i)
	local necoGbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	if nil == necoGbox then
		return;
	end

	local descriptGbox = GET_CHILD(necoGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	local gbox = GET_CHILD(descriptGbox,'desc_name',"ui::CRichText")
	if nil ~= gbox then
		gbox:SetTextByKey("bossname",bosscardcls.Name);
	end

	local bossMonID = bosscardcls.NumberArg1;
	local monCls = GetClassByType("Monster", bossMonID);
	if nil == monCls then
		return;
	end

	-- ������� �����սô�.
	local tempObj = CreateGCIES("Monster", monCls.ClassName);
	if nil == tempObj then
		return;
	end

	local skl = session.GetSkillByName('Necromancer_CreateShoggoth');

	if nil ~= skl then
		CLIENT_SORCERER_SUMMONING_MON(tempObj, GetMyPCObject(), GetIES(skl:GetObject()), bosscardcls);
	end

	-- ü��
	local myHp = GET_CHILD(descriptGbox,'desc_hp',"ui::CRichText")
	if nil ~= skl then
		local hp = math.floor(SCR_Get_MON_MHP(tempObj));
		myHp:SetTextByKey("value", hp);
	else
		myHp:SetTextByKey("value", 0);
	end

	-- ���� ���ݷ�
	local richText = GET_CHILD(descriptGbox,'desc_fower',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.MAXPATK));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ����
	richText = GET_CHILD(descriptGbox,'desc_defense',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.DEF));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ��
	richText = GET_CHILD(descriptGbox,'desc_Str',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "STR"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ü��
	richText = GET_CHILD(descriptGbox,'desc_Con',"ui::CRichText")

	if nil ~= skl then
	 -- �⺻������ GET_MON_STAT�� ������ ü���� �����ش޶�� �������� ��û
		local con = math.floor(GET_MON_STAT_CON(tempObj, tempObj.Lv, "CON"));
		richText:SetTextByKey("value", con);
	else
		richText:SetTextByKey("value", 0);
	end

	-- ����
	richText = GET_CHILD(descriptGbox,'desc_Int',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "INT"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ��ø
	richText = GET_CHILD(descriptGbox,'desc_Dex',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "DEX"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ����
	richText = GET_CHILD(descriptGbox,'desc_Mna',"ui::CRichText")
	if nil~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "MNA"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- ������ ������� ��������
	DestroyIES(tempObj);
end

function UPDATE_NECRONOMICON_UI(frame)
		
	local etc_pc = GetMyEtcObject();

	local MAX_CARD_COUNT = 4; -- ���� �� ���ڰ� �þ����. ����� ī�� ��. 1�� ���� ī��.(��ȯ) 2,3,4�� ����ī��


	--������������ ������Ʈ
	-- ��ũ�� ���� 1��
	local deadPartsCnt = etc_pc.Necro_DeadPartsCnt

	local deadpartsGbox = GET_CHILD(frame,'deadpartsGbox',"ui::CGroupBox")
	if nil == deadpartsGbox then
		return;
	end
	
	local part_gaugename = 'part_gauge1'
	local part_gauge = GET_CHILD(deadpartsGbox, part_gaugename,"ui::CGauge")
	part_gauge:SetPoint(deadPartsCnt,300) -- ��ȹ �������� 100�� �� 3���ִ��� 300���� ����



	local gbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	for i = 1, MAX_CARD_COUNT do
		local slotname = 'subboss'..i
		--local slottextname = 'subbosstext'..i
		local nowcard_classname = 'Necro_bosscard'..i
		local nowcard_guidname = 'Necro_bosscardGUID'..i;
		
		local bosscardid = etc_pc[nowcard_classname]
		local nowcard_guid = etc_pc[nowcard_guidname];

		local invitem = session.GetInvItemByGuid(nowcard_guid);
		if nil ~= invitem then
			local itemobj = GetIES(invitem:GetObject());
			print(itemobj.ClassName);
			local slotchild = GET_CHILD(gbox,slotname,"ui::CSlot");
			--local slotchild_text= GET_CHILD(gbox, slottextname,"ui::CRichText");
			if itemobj ~= nil then
				SET_SLOT_ICON(slotchild, itemobj.TooltipImage);		
				SET_ITEM_TOOLTIP_BY_OBJ(slotchild:GetIcon(), invitem);
				SET_NECRO_CARD_STATE(frame, itemobj, i);
				--slotchild_text:SetText(itemobj.Name)
			else
				SET_SLOT_ICON(slotchild, 'monster_card');			
			end
		end

		--slotchild_text:SetText('');
	end

	local necoGbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	if nil == necoGbox then
		return;
	end

	local descriptGbox = GET_CHILD(necoGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	local desc_needparts = GET_CHILD(descriptGbox,'desc_needparts',"ui::CRichText")
	if nil ~= desc_needparts then
		desc_needparts:SetTextByKey("value", "30");
	end
	
	-- ��ũ�� ���� 1��
	local deadPartsCnt = etc_pc.Necro_DeadPartsCnt

	local gbox = GET_CHILD(frame,'deadpartsGbox',"ui::CGroupBox")
	if nil == gbox then
		return;
	end

	local part_gaugename = 'part_gauge1'
	local part_gauge = GET_CHILD(gbox, part_gaugename,"ui::CGauge")
	part_gauge:SetPoint(deadPartsCnt,300) -- ��ȹ �������� 100�� �� 3���ִ��� 300���� ����

	
end

function NECRONOMICON_FRAME_OPEN(frame)
	UPDATE_NECRONOMICON_UI(frame)
end

function NECRONOMICON_FRAME_CLOSE(frame)
	
end

function NECRONOMICON_SLOT_DROP(frame, control, argStr, argNum) 

	local liftIcon 					= ui.GetLiftIcon();
	local iconParentFrame 			= liftIcon:GetTopParentFrame();
	local slot 						= tolua.cast(control, 'ui::CSlot');
	
	local iconInfo = liftIcon:GetInfo();
	local invenItemInfo = session.GetInvItem(iconInfo.ext);

	local tempobj = invenItemInfo:GetObject()
	local cardobj = GetIES(invenItemInfo:GetObject());

	if cardobj.GroupName ~= 'Card' then
		return 
	end

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());

	SET_NECRO_CARD_COMMIT(slot:GetName())

end


function SET_NECRO_CARD_COMMIT(slotname)

	local resultlist = session.GetItemIDList();

	local slotnumber = GET_NEC_SLOT_NUMBER(slotname)
	item.DialogTransaction("SET_NECRO_CARD", resultlist, slotnumber); -- ������ SCR_SET_CARD()�� ȣ��ȴ�.

end

function GET_NEC_SLOT_NUMBER(slotname)

	if slotname == 'subboss1' then
		return 1;
	elseif slotname == 'subboss2' then
		return 2;
	elseif slotname == 'subboss3' then
		return 3;
	elseif slotname == 'subboss4' then
		return 4;
	end

	return 0;

end

function SET_NECRO_CARD_ROTATE()
	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("SET_NECRO_CARD_ROTATE", resultlist);
end
