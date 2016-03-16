-- weaponswap.lua

function WEAPONSWAP_ON_INIT(addon, frame)

	addon:RegisterMsg('WEAPONSWAP', 'WEAPONSWAP_SWAP_UPDATE');
	addon:RegisterMsg('WEAPONSWAP_FAIL', 'WEAPONSWAP_FAIL');
	addon:RegisterMsg('WEAPONSWAP_SUCCESS', 'WEAPONSWAP_SLOT_SUCCESS');
	addon:RegisterMsg('ABILITY_LIST_GET', 'WEAPONSWAP_SHOW_UI');
	addon:RegisterMsg('GAME_START', 'WEAPONSWAP_SHOW_UI');

	WEAPONSWAP_SLOT_UPDATE();
end 

function TH_WEAPON_CHECK(obj, bodyGbox, slotIndex)

	if obj == nil then
		return;
	end
	
	-- �������̰�, ��չ�����
	-- ����ĭ�� ����������
	if 0 == (slotIndex % 2) then	
		if obj.EquipGroup ~= 'THWeapon' then
			return;
		end
		
		local etcSlot = bodyGbox:GetChild("slot"..slotIndex+1);
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot')
		local icon = etcSlot:GetIcon();
		etcSlot:ClearIcon();
		session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
	else
		if 0 == slotIndex then
			slotIndex = slotIndex + 1;
		else
			slotIndex = slotIndex -1;
		end
		-- �װԾƴ϶�� ��ĭ�� ������� Ȯ���ϰ�, ����� ������
		local etcSlot = bodyGbox:GetChild("slot"..slotIndex);
		if nil == etcSlot then
			return;
		end
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot')
		local icon = etcSlot:GetIcon();
		if nil == icon then
		
			return
		end
		
		local iconInfo = icon:GetInfo();
		local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
		
		if nil == invItem then
			return;
		end

		local itemObj = GetIES(invItem:GetObject());
		if itemObj.EquipGroup ~= 'THWeapon' then
			return;
		end

		etcSlot:ClearIcon();
		session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
	end

end

function WEAPONSWAP_ITEM_DROP(parent, ctrl, argStr, argNum)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();

	if liftIcon == nil then
		return;
	end

	local iconInfo			= liftIcon:GetInfo();
	if iconInfo == nil then
		return;
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	if invItem == nil then
		return;
	end
	
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	
	if nil == slot then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if	obj.DefaultEqpSlot ~= "RH" and obj.DefaultEqpSlot ~= "LH" then
		return
	end

	-- ������ �¿� �ΰ��Ƿ�
	local offset = 2;
	-- �ϴ� ���� ��ġ��, ���ʿ����������� Ȯ��
	if slot:GetSlotIndex() % offset == 0 and
		obj.DefaultEqpSlot ~= "RH" then
		return;
	end

	if slot:GetSlotIndex() % offset == 1 and
		obj.DefaultEqpSlot ~= "LH" then
		return;
	end
	
	local bodyGbox = frame:GetChild("bodyGbox");
	if nil == bodyGbox then
		return;
	end
	
	-- ��չ��⸦ üũ����
	TH_WEAPON_CHECK(obj, bodyGbox, slot:GetSlotIndex());
	session.SetWeaponQuicSlot(slot:GetSlotIndex(), invItem:GetIESID());
	SET_SLOT_ITEM_IMANGE(slot, invItem);
end

function WEAPONSWAP_ITEM_POP(parent, ctrl)
	local slot 	= tolua.cast(ctrl, 'ui::CSlot');
	slot:ClearIcon();
	session.SetWeaponQuicSlot(slot:GetSlotIndex(), "");
end

function WEAPONSWAP_SWAP_EQUIP(update)

	--���۽ÿ��� ���⽺�� �ȵǰ� ��..
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	
	-- ����Ű�� ������ call�� nil,
	-- Ŭ�󿡼� add������ �θ��� frame�� ��
	-- ��, nil�� �ƴ�
	if nil == update then
		-- ���� �ٲ���ٰ� �˸���
		session.SetWeaponSwap(1);
	else
		-- ������� �����������
		WEAPONSWAP_SLOT_UPDATE();
	end

end

function WEAPONSWAP_RBTN_DOWN(frame, object)
	--local invitem = GET_SLOT_ITEM(object);
	--
    --if invitem == nil then
	--	return;
	--end
	--print(invitem:GetIESID());
	--ITEM_EQUIP_MSG(session.GetInvItemByGuid(invitem:GetIESID()));
end

function WEAPONSWAP_UI_UPDATE()
	local frame = ui.GetFrame("weaponswap");
	local bodyGbox = frame:GetChild("bodyGbox");
	for i=0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil== etcSlot then
			return;
		end

		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				SET_SLOT_ITEM_IMANGE(etcSlot, item);
			else
				etcSlot:ClearIcon();
			end
		else
			etcSlot:ClearIcon();
		end;
	end
end

function WEAPONSWAP_SWAP_UPDATE(frame)
	local bodyGbox = frame:GetChild("bodyGbox");
	for i=0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil== etcSlot then
			return;
		end

		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				SET_SLOT_ITEM_IMANGE(etcSlot, item);
			else
				etcSlot:ClearIcon();
			end
		else
			etcSlot:ClearIcon();
		end;
	end


	WEAPONSWAP_SWAP_EQUIP(frame);
end

function WEAPONSWAP_FAIL()

	local lowDur = 0;
	for i=0, 3 do
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				local itemobj = GetIES(item:GetObject());
				if nil ~= itemobj then 
					if itemobj.Dur <= 0 then
						ui.MsgBox(ScpArgMsg("YouCantEquipDur0Item"));
						lowDur = 1;
						break;
					end;
				end;
			end
		end;
	end;
	
	session.SetWeaponSwap(0);
	if 0 == lowDur then
	ui.SysMsg(ClMsg("TryLater"));
	WEAPONSWAP_SLOT_UPDATE();
	end;
end

function WEAPONSWAP_SLOT_SUCCESS()
	imcSound.PlaySoundEvent("sys_weapon_swap");
	WEAPONSWAP_SLOT_UPDATE()
end

function WEAPONSWAP_SLOT_UPDATE()

	local frame = ui.GetFrame("weaponswap");
	if frame == nil then
		return;
	end

	local bodyGbox = frame:GetChild("bodyGbox");
	if nil == bodyGbox then
		return;
	end
	
	-- ũ�⸦ ��� �ٲܱ�?
	local slotLine = bodyGbox:GetChild("readyWeapon");
	local smailLine = bodyGbox:GetChild("currWeapon");
	
	if nil == slotLine or nil == smailLine then
		return;
	end
	
	slotLine 	= tolua.cast(slotLine, 'ui::CGroupBox');
	smailLine 	= tolua.cast(smailLine, 'ui::CGroupBox');
	
		--���ǿ��� ���� ��ϵ� ���� ������ �˾ƿ���,
	local start = session.GetWeaponCurrentSlotLine();
	-- �ι�°��
	if 1 == start then
		start = 2;
	end
			
	local cposX = 0;
	local sposX = 0;
	
	for i =0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil == etcSlot then
			return;
		end
	
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		
		if i == start or i == start+1 then
			etcSlot:SetMargin( ((slotLine:GetWidth()/2) * cposX) + 15, slotLine:GetY(), 0, 0);
			etcSlot:Resize(slotLine:GetWidth()/2, slotLine:GetHeight());
			cposX = cposX + 1;
	
		else
			etcSlot:SetMargin( ((smailLine:GetWidth()/2) * sposX), smailLine:GetY() + 5, 0, 0);
			etcSlot:Resize(smailLine:GetWidth()/2, smailLine:GetHeight());
			sposX = sposX + 1;
		end
	end
end


function WEAPONSWAP_SHOW_UI(frame)

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	local abil = GetAbility(pc, "SwapWeapon");
	
	if abil ~= nil then
		frame:ShowWindow(1)
	else
		frame:ShowWindow(0)
	end
en