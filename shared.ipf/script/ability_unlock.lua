-- ability_unlock.lua

function UNLOCK_ABIL_CIRCLE(pc, jobName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, jobName);
	if jobGrade >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";
end

function UNLOCK_ABIL_SKILL(pc, sklName, limitLevel, abilIES)

	local skl = GetSkill(pc, sklName)
	if skl ~= nil and skl.LevelByDB >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";
	
end

function UNLOCK_ABIL_LEVEL(pc, pcLevel, levelFix, abilIES)

	local abilLv = levelFix;
	if abilIES ~= nil then
		abilLv = abilLv + abilIES.Level;
	end

	if pc.Lv >= abilLv then
		return "UNLOCK";
	end
	
	return "LOCK_LV";
	
end

function UNLOCK_PRIEST21(pc, sklName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, 'Char4_2');
	local skl = GetSkill(pc, sklName)
	if skl ~= nil and skl.LevelByDB >= limitLevel and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_FEATHERFOOT_BLOOD(pc, sklName, limitLevel, abilIES)

	local bloodbathSkl = GetSkill(pc, "Featherfoot_BloodBath")
	local bloodsuckingSkl = GetSkill(pc, "Featherfoot_BloodSucking")
	if bloodbathSkl ~= nil and bloodbathSkl.LevelByDB >= limitLevel and bloodsuckingSkl ~= nil and bloodsuckingSkl.LevelByDB >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end
