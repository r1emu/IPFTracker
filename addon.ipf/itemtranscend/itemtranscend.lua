
function ITEMTRANSCEND_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMTRANSCEND", "ON_OPEN_DLG_ITEMTRANSCEND");

end

function ON_OPEN_DLG_ITEMTRANSCEND(frame)
	frame:ShowWindow(1);	
	ui.SetHoldUI(false);
end

function ITEMTRASCEND_OPEN(frame)
	
	local slot = GET_CHILD(frame, "slot");
	slot:StopActiveUIEffect();
	slot:ClearIcon();
	SET_TRANSCEND_RESET(frame);
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);

	UPDATE_TRANSCEND_ITEM(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMTRANSCEND_INV_RBTN")	
	ui.OpenFrame("inventory");	
	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	
	local slotTemp = GET_CHILD(frame, "slotTemp");
	slotTemp:StopActiveUIEffect();
	slotTemp:ShowWindow(0);	
end

function ITEMTRANSCEND_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:StopActiveUIEffect();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
 end

function TRANSCEND_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemtranscend");
	UPDATE_TRANSCEND_ITEM(frame);
	UPDATE_TRANSCEND_RESULT(frame, isSuccess);
end

function ITEM_TRANSEND_DROP(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();

	-- �巹�� ����� �κ��丮������ �����ϰ�
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end;
end;

function ITEM_TRANSCEND_REG_TARGETITEM(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if IS_TRANSCEND_ABLE_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotAbleToTranscend"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local slot = GET_CHILD(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	SET_TRANSCEND_RESET(frame);	
	ITEM_TRANSCEND_NEED_GUIDE(frame, obj);
	UPDATE_TRANSCEND_ITEM(frame);	
end

-- �ȳ��޼����� �ʿ��� �������� �����ֱ� ����. 
function ITEM_TRANSCEND_NEED_GUIDE(frame, obj)
	local mtrlName = GET_TRANSCEND_MATERIAL_ITEM(obj);	
	if string.len(mtrlName) <= 0 then
		return;		
	end;	
	local mtrlCls = GetClass("Item", mtrlName);
	if mtrlCls == nil then
		return;
	end		
		
	if obj.Transcend >= 10 then		
		SETTEXT_GUIDE(frame, 1, string.format("{@st43b}{s16}%s{/}", ScpArgMsg("CantTrasncendMore")));
		return;
	end
		
	local needTxt = "";
	needTxt = string.format("{img %s 30 30}{/}{@st43_green}{s16}%s{/}{@st43b}{s16}%s{nl}%s{/}", mtrlCls.Icon, mtrlCls.Name, ScpArgMsg("Need_Item"), GET_TRANSCEND_MAXCOUNT_TXT(obj));			
	SETTEXT_GUIDE(frame, 1, needTxt);
end;

-- �ʿ� ������ 100%�� �ʿ��� ���� ���
function GET_TRANSCEND_MAXCOUNT(obj)
	local transcend = obj.Transcend;
	local transcendCls = GetClass("ItemTranscend", transcend + 1);
	if transcendCls == nil then
		ui.MsgBox(ScpArgMsg("CantTrasncendMore"));
		return;
	end
	return transcendCls.ItemCount;
end;

-- �ʿ� ������ 100%�� �ʿ��� ���� ǥ��
function GET_TRANSCEND_MAXCOUNT_TXT(obj)
	local numColor = "{#FFE400}";
	local mtrl_num = ScpArgMsg("ITEMTRANSCEND_MTRL_NUM{color}{num}", "num", GET_TRANSCEND_MAXCOUNT(obj), "color", numColor);
	local guideTxt = string.format("{@st43b}{s16}{#FFE400}%s{/}{@st43b}{s16}%s{/}{@st43b}{s16}%s{/}", ScpArgMsg("TranscendSuccessRatio{P}%", "P", 100), mtrl_num, ScpArgMsg("ITEMTRANSCEND_MTRL_NUM"));
	return guideTxt;
end;

-- �ʿ� ������ �� ���� �ȳ��޼���.
function SETTEXT_GUIDE(frame, type, text)
	local title_result = frame:GetChildRecursively("title_result");
	local txt_result = frame:GetChildRecursively("txt_result");
	
	title_result:ShowWindow(0);
	txt_result:ShowWindow(0);
	if (type == 0) or (text == nil) or (string.len(text) <= 0) then
		return;
	end;

	if type == 1 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_PROCESS"));
		txt_result:SetTextByKey("value", text);
	elseif type == 2 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_RESULT"));	
		txt_result:SetTextByKey("value", text);	
	elseif type == 3 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_GUIDE"));	
		txt_result:SetTextByKey("value", text);		
	end
	title_result:ShowWindow(1);
	txt_result:ShowWindow(1);
end;

-- �ʿ� ������ ���Ž�
function REMOVE_TRANSCEND_TARGET_ITEM(frame)
	
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();
	SET_TRANSCEND_RESET(frame);
	UPDATE_TRANSCEND_ITEM(frame);
	
	local needTxt = string.format("{@st43b}{s18}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	
end

-- ��� ���԰� ������, ��ư�� �ʱ�ȭ ��Ŵ.
function SET_TRANSCEND_RESET(frame)
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:SetUserValue("MTRL_COUNT", 0);
	slot_material:StopActiveUIEffect();
	slot_material:ClearIcon();
	slot_material:SetText("");
		
	local text_successratio = frame:GetChild("text_successratio");	
	text_successratio:ShowWindow(0);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end;

-- �÷����ִ� ��� ������ Ŭ���� 
function REMOVE_TRANSCEND_MTRL_ITEM(frame, slot)
	local materialItem = GET_SLOT_ITEM(slot);	
	if materialItem == nil then
		return;
	end
	local count = slot:GetUserIValue("MTRL_COUNT");			if keyboard.IsPressed(KEY_SHIFT) == 1 then
		count = count - 5;	elseif keyboard.IsPressed(KEY_ALT) == 1 then
		count = 0;	else
		count = count - 1;
	end
	
	if count <= 0 then
		local frame = ui.GetFrame("itemtranscend");
		SET_TRANSCEND_RESET(frame);
		local slot = GET_CHILD(frame, "slot");
		local invItem = GET_SLOT_ITEM(slot);
		if invItem == nil then
			return;
		end
		ITEM_TRANSCEND_NEED_GUIDE(frame, GetIES(invItem:GetObject()));
		return;
	end;
	
		
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	text_itemtranscend:StopColorBlend();
	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(materialItem:GetIESID(), count);
end;

-- ��ῡ ���� �������� �������� �ʿ� �ܰ� ������Ʈ
function UPDATE_TRANSCEND_ITEM(frame)

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);

	local text_material = frame:GetChild("text_material");
	local text_successratio = frame:GetChild("text_successratio");	
	text_successratio:ShowWindow(0);
	local text_itemstar = frame:GetChild("text_itemstar");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	
	if invItem == nil then
		text_itemstar:ShowWindow(0);
		text_material:ShowWindow(0);
		text_itemtranscend:ShowWindow(0);	
	else
		local targetObj = GetIES(invItem:GetObject());
		text_itemstar:ShowWindow(1);
		local starTxt = GET_ITEM_GRADE_TXT(targetObj, 24);
		text_itemstar:ShowWindow(1);
		text_itemstar:SetTextByKey("value", starTxt);

		local lev = targetObj.Transcend;
		text_itemtranscend:SetTextByKey("value", string.format("{s20}%s", lev));
		text_itemtranscend:StopColorBlend();
		text_itemtranscend:ShowWindow(1);

		text_material:SetTextByKey("value", GET_FULL_NAME(targetObj));
		text_material:ShowWindow(1);
	end

	if materialItem == nil or invItem == nil then
		slot_material:StopActiveUIEffect();
		text_successratio:ShowWindow(0);
	else
		local targetObj = GetIES(invItem:GetObject());		
		local transcend = targetObj.Transcend;
		local transcendCls = GetClass("ItemTranscend", transcend + 1);
		if transcendCls == nil then
			return;
		end

		local materialCount = slot_material:GetIcon():GetInfo().count;
		local materialObj = GetIES(materialItem:GetObject());
		local successRatio = GET_TRANSCEND_SUCCESS_RATIO(transcendCls, materialCount);
		local ratioText = string.format("{s20}%s{/}", ScpArgMsg("TranscendSuccessRatio{P}%", "P", successRatio));
		local color1, color2 = GET_RATIO_FONT_COLOR(successRatio)
		text_successratio:SetTextByKey("value", ratioText);		
		text_successratio:ShowWindow(1);		
		text_successratio:StopColorBlend();
		text_successratio:SetColorBlend(2, color1, color2, true);
	end
end

-- �������� ���� ���� �� ��ȯ
-- ���� �ʿ� (������ �������� �ʾƼ� ���� �˸��� ������ �� �������. �켱 �ϵ��ڵ� �س�����.)
function GET_RATIO_FONT_COLOR(ratio)	
	local color1 = 0xFF0000;
	local color2 = 0xFFBB00;
	if ratio < 20 then
		color1 = 0x00D8FF;
		color2 = 0x0054FF;
	elseif ratio < 30 then
		color1 = 0x0054FF;
		color2 = 0x22741C;
	elseif ratio < 50 then
		color1 = 0x1DDB16;
		color2 = 0x5CD1E5;
	elseif ratio < 70 then
		color1 = 0x9FC93C;
		color2 = 0x998A00;
	elseif ratio < 90 then
		color1 = 0xFFE08C;
		color2 = 0xF15F5F;
	end;
	return color1, color2;		
end

-- ��� �������� ������
function ITEM_TRANSCEND_REG_MATERIAL(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end
	
	local obj = GetIES(invItem:GetObject());

	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	if targetItem == nil then
		return;
	end
	
	local targetObj = GetIES(targetItem:GetObject());
	
	local matItemName = GET_TRANSCEND_MATERIAL_ITEM(targetObj);
	if obj.ClassName ~= matItemName then
		local msgString = ScpArgMsg("PleaseDropItem{Name}", "Name", GetClass("Item", matItemName).Name);
		ui.MsgBox(msgString);
		return;
	end
	

	local transcend = targetObj.Transcend;
	local transcendCls = GetClass("ItemTranscend", transcend + 1);
	if transcendCls == nil then
		ui.MsgBox(ScpArgMsg("CantTrasncendMore"));
		return;
	end
	
	local maxItemCount = math.min(invItem.count, transcendCls.ItemCount);
	local slot_material = GET_CHILD(frame, "slot_material");
	local count = slot_material:GetUserIValue("MTRL_COUNT");	
	if count >= maxItemCount then
		if transcendCls.ItemCount > invItem.count then
			ui.MsgBox_NonNested(ScpArgMsg("ITEMTRANSCEND_TOO_LACK"), frame:GetName(), nil, nil);		
			return;
		end;
		ui.MsgBox_NonNested(ScpArgMsg("ITEMTRANSCEND_TOO_MANY"), frame:GetName(), nil, nil);		
		return;
	end;
	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		count = count + 5;	elseif keyboard.IsPressed(KEY_ALT) == 1 then		count = maxItemCount;	else
		count = count + 1;
	end
	
	if count >= maxItemCount then
		count = maxItemCount;
	end;

	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(invItem:GetIESID(), count);
	--[[	
	-- �޼����ڽ��� �������� �ִ� ���
	INPUT_NUMBER_BOX(frame, string.format("%s(%d ~ %d)", ScpArgMsg("InputCount"), 1, maxItemCount), "EXEC_INPUT_CNT_TRANSCEND_MATERIAL", maxItemCount, 1, maxItemCount, nil, tostring(invItem:GetIESID()));
	]]
end

-- ��Ḧ �巹�� ������� ���
function DROP_TRANSCEND_MATERIAL(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();
	
	-- �巹�� ����� �κ��丮������ �����ϰ�
	if FromFrame:GetName() == 'inventory' then
		ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID());
	end
end

-- ��Ḧ ������ ���� ���Կ� �ֱ�
function TRANSCEND_SET_MATERIAL_ITEM(frame, iesID, count)

	local invItem = GET_PC_ITEM_BY_GUID(iesID);
	if invItem == nil then
		return;
	end
	


	local slot_material = GET_CHILD(frame, "slot_material");
	-- ����ǥ�ø� ������ ���κ����� ���� 
	SET_SLOT_INVITEM(slot_material, invItem, count);
	slot_material:SetUserValue("MTRL_COUNT", count);
	slot_material:StopActiveUIEffect();
	slot_material:PlayActiveUIEffect();
	
	UPDATE_TRANSCEND_ITEM(frame);
	
	
	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	if targetItem == nil then
		return;
	end
	local targetObj = GetIES(targetItem:GetObject());
	local tooltipFont = "{@st43b}{s16}";

	local needTxt = string.format("{@st43b}{s16}%s{/}{nl}%s{/}{nl}%s{/}", ScpArgMsg("ITEMTRANSCEND_MTRL_NUM_TOOLTIP{font}", "font", tooltipFont), ScpArgMsg("ITEMTRANSCEND_GUIDE_SECOND"), GET_TRANSCEND_MAXCOUNT_TXT(targetObj));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(1);
end


function EXEC_INPUT_CNT_TRANSCEND_MATERIAL(iesid, count)
	local frame = ui.GetFrame("itemtranscend");	
	TRANSCEND_SET_MATERIAL_ITEM(frame, iesid, count)	
end

--[[
-- �޼����ڽ��� �������� �ִ� ���
function EXEC_INPUT_CNT_TRANSCEND_MATERIAL(frame, count, inputframe, fromFrame)
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");

	local frame = ui.GetFrame("itemtranscend");
	TRANSCEND_SET_MATERIAL_ITEM(frame, iesid, count)	
end
]]

function ITEMTRANSCEND_EXEC(frame)
	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if invItem == nil or materialItem == nil then
		ui.MsgBox(ScpArgMsg("DropItemPlz"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		return;
	end
	
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	ui.MsgBox_NonNested(ScpArgMsg("ReallyExecTranscend?"), frame:GetName(), "_ITEMTRANSCEND_EXEC", "_ITEMTRANSCEND_CANCEL");			
end

function _ITEMTRANSCEND_CANCEL()
	local frame = ui.GetFrame("itemtranscend");
end;

function _ITEMTRANSCEND_EXEC()

	local frame = ui.GetFrame("itemtranscend");
	if frame:IsVisible() == 0 then
		return;
	end
	
	ui.SetHoldUI(true);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if slot == nil or materialItem == nil then
		return;
	end
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);

	slot_material:StopActiveUIEffect();
	local materialCount = slot_material:GetIcon():GetInfo().count;	
	session.ResetItemList();	
	session.AddItemID(invItem:GetIESID());
	session.AddItemID(materialItem:GetIESID());	
	local resultlist = session.GetItemIDList();
	local cntText = string.format("%d", materialCount);
	item.DialogTransaction("ITEM_TRANSCEND_TX", resultlist, cntText);
	
	slot_material:SetUserValue("MTRL_COUNT", 0);
	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_ITEM(frame);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	
	
	SETTEXT_GUIDE(frame, 0, nil);
end

-- �κ����� ������ Ŭ���� 
function ITEMTRANSCEND_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("itemtranscend");

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local slot = GET_CHILD(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);
		
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	text_itemtranscend:StopColorBlend();

	if slotInvItem ~= nil then
		if ("Premium_itemUpgradeStone_Weapon" == obj.ClassName) or ("Premium_itemUpgradeStone_Armor" == obj.ClassName) or ("Premium_itemUpgradeStone_Acc" == obj.ClassName) then
		ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID());	-- ����� ���
			return;
		end;
	end;
		ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());  -- ��ᰡ �ƴ� ��, �ʿ� ���ϴ� ������
	end
	
-- �ִ������� �ִϸ��̼� ƽ�� ���� ��� UIeffect ����
function ITEMTRANSCEND_BG_ANIM_TICK(ctrl, str, tick)

	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();
		local slot_material = GET_CHILD(frame, "slot_material");
		slot_material:StopActiveUIEffect();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		ReserveScript("TRANSCEND_EFFECT()", 0.3);
	elseif tick == 15 then	
		local frame = ctrl:GetTopParentFrame();
	end
end

function TRANSCEND_EFFECT()
	local frame = ui.GetFrame("itemtranscend");
	_UPDATE_TRANSCEND_RESULT(frame, 1);	
end

function UPDATE_TRANSCEND_RESULT(frame, isSuccess)
	if isSuccess == 1 then
		local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
		animpic_bg:ShowWindow(1);
		animpic_bg:ForcePlayAnimation();
	else
		_UPDATE_TRANSCEND_RESULT(frame, 0);	
	end;
end

-- ������ �������ο� ���� UI����Ʈ�� ��� ������Ʈ 
function _UPDATE_TRANSCEND_RESULT(frame, isSuccess)			
	local slot = GET_CHILD(frame, "slot");

	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		ui.SetHoldUI(false);
		return;
	end
	
	local timesecond = 0;
	if isSuccess == 1 then
		ui.SysMsg(ScpArgMsg("SuccessToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_SUCCESS_SOUND"));
		slot:StopActiveUIEffect();
		slot:PlayActiveUIEffect();
		timesecond = 2;
	else
		ui.SysMsg(ScpArgMsg("FailedToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_FAIL_SOUND"));
		local slotTemp = GET_CHILD(frame, "slotTemp");
		slotTemp:ShowWindow(1);
		slotTemp:StopActiveUIEffect();
		slotTemp:PlayActiveUIEffect();
		timesecond = 1;
	end
			
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
	
	local obj = GetIES(invItem:GetObject());
	local transcend = obj.Transcend;
	local tempValue = transcend;
	local beforetranscend;

	if isSuccess == 0 then
		beforetranscend = transcend;
		transcend = transcend + 1;
	else
		beforetranscend = transcend - 1;
	end

	local transcendCls = GetClass("ItemTranscend", transcend  );
	if transcendCls == nil then
		ui.SetHoldUI(false);
		return;
	end

	local resultTxt = "";
	local afterNames, afterValues = GET_ITEM_TRANSCENDED_PROPERTY(obj);
	local upfont = "{@st43_green}";
	local operTxt = " + ";	
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	local text_color1 = 0xFF1DDB16;
	local text_color2 = 0xFF22741C;
	if isSuccess == 0 then
		upfont = "{@st43_red}";
		text_color1 = 0xFFFF0000;
		text_color2 = 0xFFFFBB00;
	end;
	text_itemtranscend:ShowWindow(0);
	text_itemtranscend:StopColorBlend();
	text_itemtranscend:SetColorBlend((11 - beforetranscend) * 0.2, text_color1, text_color2, true);
	text_itemtranscend:ShowWindow(1);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	local gbox = popupFrame:GetChild("gbox");
	gbox:RemoveAllChild();

	for i = 1 , #afterNames do
		local propName = afterNames[i];
		local addedValue = afterValues[i];

		if resultTxt ~= "" then
			resultTxt = resultTxt .. "{nl}";
		end

		resultTxt = string.format("%s%s%s%s%s", upfont, resultTxt, ScpArgMsg(propName), operTxt, addedValue);
		resultTxt = resultTxt .. "%{/}";
		local ctrlSet = gbox:CreateControlSet("transcend_result_text", "RV_" .. propName, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local text = ctrlSet:GetChild("text");
		text:SetTextByKey("propname", ScpArgMsg(propName));
		text:SetTextByKey("propoper", operTxt);
		text:SetTextByKey("propvalue", addedValue);
		
	
	end
		
	SETTEXT_GUIDE(frame, 2, resultTxt);
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true , true);
	
	ui.SetTopMostFrame(popupFrame);
	popupFrame:Resize(popupFrame:GetWidth(), gbox:GetHeight());

	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	frame:RunUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND", timesecond);
end

-------------------------
-- ����� ���� UIeffect�� �˾� ��� UI�� ������ ������ 
-- �ð����� �˾� ��� UI�� ����ֱ� ���� UpdateScript.
function TIMEWAIT_STOP_ITEMTRANSCEND()
	local frame = ui.GetFrame("itemtranscend");
	local slotTemp = GET_CHILD(frame, "slotTemp");
	slotTemp:ShowWindow(0);
	slotTemp:StopActiveUIEffect();
		
	local popupFrame = ui.GetFrame("itemtranscendresult");
	local gbox = popupFrame:GetChild("gbox");
	popupFrame:ShowWindow(1);	
	popupFrame:SetDuration(6.0);
	
	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	return 1;
end