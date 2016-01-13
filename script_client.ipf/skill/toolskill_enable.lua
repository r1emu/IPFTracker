-- toolskill_enable.lua

function SKL_CHECK_ISJUMPING_C(actor, skl)
	if 1 == actor:IsOnGround() then
		return 0;
	end

	return 1;
end

function SKL_CHK_OOBE_C(actor, skl)

	local oobeActor = geMCC.GetOOBEActor();
	if oobeActor == nil then
		return 0;
	end
	
	return 1;
end

function SKL_CHECK_FORMATION_STATE_C(actor, skl, checkValue)
	
	if actor:GetUserSValue("FORMATION_NAME") == "None" then
		if checkValue == 1 then
			return 0;
		end

		return 1;
	end

	if checkValue == 1 then
		return 1;
	end

	return 0;
end

function SKL_CHECK_RIDING_COMPANION_C(actor, skl)

	local myActor = GetMyActor();
	if myActor:GetVehicleState() == true then
		return 1;
	end

	return 0;

end

function SKL_CHECK_FORMATION_NAME_C(actor, skl, checkName)
	
	local name = actor:GetUserSValue("FORMATION_NAME");
	if name == "None" or name == "" or checkName == name then
		return 0;
	end

	return 1;
end

function SKL_CHECK_EXPROP_OBJ_RANGE_C(actor, skl, propName, propValue, range)
	
	local obj = world.GetMonsterByUserValue(propName, propValue, range);
	if obj == nil then
		return 0;
	end

	return 1;

end

function SKL_CHECK_CHECK_BUFF_C(actor, skl, buffName)

	if actor:GetBuff():GetBuff(buffName) == nil then
		return 0;
	end
	
	if buffName == 'IronHook' then
		local abil = session.GetAbilityByName('Corsair7')
		if nil == abil then
			return 1;
		end
		local obj = GetIES(abil:GetObject());
		if 1 == obj.ActiveState then
			return 0;
		end
	end

	return 1;
end

function SKL_CHECK_NEAR_PAD_C(actor, skl, padName, isExist, range, padStyle)
	local pos = actor:GetPos();
	local padCount = SelectPadCount_C(actor, padName, pos.x, pos.y, pos.z, range, padStyle);

	if isExist == 0 then
		if padCount == 0 then
			return 1;
		end

		return 0;
	else
		if padCount > 0 then
			return 1;
		end

		return 0;
	end

	return 0;
end

function SKL_CHECK_EXARGOBJECT_C(self, skl, objName)
	if 0 == geClientSkill.GetExArgObject(objName) then
		return 0;
	end

	return 1;
end


function SKL_CHECK_ITEM_C(self, skill, item, spend)

	local invItem = session.GetInvItemByName(item);
	local itemCnt = 0
	if invItem ~= nil then
		itemCnt = invItem.count;
	end

	if itemCnt  < spend then
		--SysMsg(self, "Item", ScpArgMsg("Auto__aiTemi_PilyoLyange_MoJaLapNiDa"));
		return 0;
	end
		
	return 1;
end


function SKL_CHECK_VIS_C(self, skill, spend)
	local MyMoneyCount = 0;
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		MyMoneyCount = invItem.count;
	end

	if MyMoneyCount < spend then
		--SysMsg(self, "Item", ScpArgMsg("NOT ENOUGH MONEY"));
		return 0;
	end
	
	--RunScript('SKL_SPEND_MONEY', self, spend)
	
	return 1;

end


function SKL_CHK_CLAYMORE(self, skill)

	local d = geClientSkill.GetCondSkillIndex(30302);
	
	if d > 0 then
		return 1;
	end

	local invItem = session.GetInvItemByName("misc_claymore");
	if nil == invItem then
		return 0;
	end

	if true == invItem.isLockState then
		return 0;
	end

	local itemCnt = 0
	if invItem ~= nil then
		itemCnt = invItem.count;
	end

	if itemCnt  < 1 then
		--SysMsg(self, "Item", ScpArgMsg("Auto__aiTemi_PilyoLyange_MoJaLapNiDa"));
		return 0;
	end
		
	return 1;
en