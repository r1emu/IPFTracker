-- toolskill_quickslot.lua

function SKL_QUICKSLOT_LIGHTCELL(actor, obj, slot, minValue, maxValue)

	slot = tolua.cast(slot, "ui::CObject");

	local pos = actor:GetPos();
	local lightValue = geCell.GetCellByteValue(pos, CELL_BYTE_LIGHT, minValue, maxValue);
	
	
	-- ���̾��ʶ� �ֺ��� ������ ���� + 10.  �ִ� 5��������.   �������� ����. �����⽺ų �����Ҷ� �ҷ��ּ�.
	local firePillarCount = SelectPadCount_C(actor, 'Wizard_New_FirePillar', pos.x, pos.y, pos.z, 50, 'ALL');
	if firePillarCount > 5 then
		firePillarCount = 5;
	end
	lightValue = lightValue + firePillarCount * 10;

	local centerText = slot:GetChild("CENTER_TEXT");
	centerText:SetText("{@st57}" .. lightValue);

end

function SKL_CAPTURE_PAD(actor, obj, slot)

	slot = tolua.cast(slot, "ui::CObject");
	local cnt = session.bindFunc.GetPadCaptureStackCount();
	local centerText = slot:GetChild("CENTER_TEXT");
	if cnt == 0 then
		centerText:SetText("");
	else
		local val = ScpArgMsg("ChargeValue:{Value}", "Value", cnt);
		centerText:SetText("{@st50}" .. val);
	end

end

