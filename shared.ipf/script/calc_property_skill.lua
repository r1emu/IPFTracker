--- calc_property_skill.lua
function GET_SKL_VALUE(skill, startValue, maxValue)
	local maxLv = 100;
	local curLv = skill.Level;
	local rate = curLv / maxLv;
	rate = math.pow(rate, 0.7);
	return startValue + rate * (maxValue - startValue);
end

function SCR_GET_SKL_ATK(skill)

	local value = skill.SklATKValue;
	local propvalue = GetClassNumber('SklRankUp', skill.ATKRankType, 'IncreaseValue');
	value = value + skill.SklATK_BM * propvalue;
	return value;
	
end

function SCR_GET_SKL_CastTime(skill)

	local value = skill.CastTimeValue;
	value = value + skill.CastTime_BM;
	return value;

end

function SCR_GET_SKL_CoolDown(skill)

	local value = skill.CoolDownValue;
	local propvalue = GetClassNumber('SklRankUp', skill.CoolDownRankType, 'IncreaseValue');
	value = value + skill.CoolDown_BM * propvalue;
	return value;

end


function SCR_Get_SpendSP_Buff(skill)

	local basicsp = skill.BasicSP;
	local lv = skill.Level;
	local addsp = skill.LvUpSpendSp;
	local decsp = 0;
	
	if basicsp == 0 then
		return 0;
	end
	
	local pc = GetSkillOwner(skill);
    local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
	if zeminaLv > 0 then
		decsp = 2 + (zeminaLv * 2);
	end
		
	local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
	
	local value = basicsp + (lv - 1) * addsp + abilAddSP;
	
	local GHabil =  GetAbility(pc, 'Remain')
	if GHabil ~= nil then 
        value = value + (value * (GHabil.Level * 0.1))
	end
	
    value = value - decsp;
	if value < 1 then
		value = 1;
	end
	
    return math.floor(value);
	
end


function SCR_Get_SpendSP(skill)

	local basicsp = skill.BasicSP;
	local lv = skill.Level;
	local lvUpSpendSp = skill.LvUpSpendSp;
	local decsp = 0;
	
	if basicsp == 0 then
		return 0;
	end
	
	local pc = GetSkillOwner(skill);
	local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
	if zeminaLv > 0 then
		decsp = 2 + (zeminaLv * 2);
	end
	
	local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
	
	value = basicsp + (lv - 1) * lvUpSpendSp + abilAddSP;
	value = value - decsp;
	
	if value < 1 then
		value = 1;
	end
	
	return math.floor(value);
end

function SCR_Get_SpendSP_Soaring(skill)

	local basicsp = skill.BasicSP;
	local lv = skill.Level;
	local decsp = 0;
	
	if basicsp == 0 then
		return 0;
	end
	
	local pc = GetSkillOwner(skill);
	local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
	if zeminaLv > 0 then
		decsp = 2 + (zeminaLv * 2);
	end
	
	local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
	
	value = basicsp + (lv * 10) + abilAddSP;
	value = value - decsp;
	
	if value < 1 then
		value = 1;
	end
	
	return math.floor(value);
end

function SCR_Get_SpendSP_Magic(skill)

	local basicsp = skill.BasicSP;
	local lv = skill.Level;
	local lvUpSpendSp = skill.LvUpSpendSp;
	local decsp = 0;
	
	if basicsp == 0 then
		return 0;
	end
	
	local pc = GetSkillOwner(skill);
	local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
	if zeminaLv > 0 then
		decsp = 2 + (zeminaLv * 2);
	end

	local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
	local value = basicsp + (lv - 1) * lvUpSpendSp + abilAddSP;
	
	if IsBuffApplied(pc, 'Wizard_Wild_buff') == 'YES' then
	    value = value * 1.5 * spRatio;
	    return math.floor(value);
    end
    
	if IsBuffApplied(pc, 'MalleusMaleficarum_Debuff') == 'YES' then
	    value = value * 2
	    return math.floor(value);
    end    
    
    value = value - decsp;
    
    if value < 1 then
		value = 1;
	end
	
	return math.floor(value);

end

function SCR_Get_SpendSP_Bow(skill)

    local lv = skill.Level;
	local lvUpSpendSp = skill.LvUpSpendSp;
	local basicsp = skill.BasicSP + lvUpSpendSp * (lv - 1);
	local decsp = 0;
	
	if basicsp == 0 then
		return 0;
	end
	
	local pc = GetSkillOwner(skill);
	local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
	if zeminaLv > 0 then
		decsp = 2 + (zeminaLv * 2);
	end
	
	local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
	local value = basicsp + abilAddSP - decsp
	
	if value < 1 then
		value = 1;
	end
    
	return math.floor(value)

end


function SCR_Get_SpendPoison(skill)

    local lv = skill.Level;
	local lvUpSpendPoison = skill.LvUpSpendPoison;
	local basicsp = skill.BasicPoison + lvUpSpendPoison * (lv - 1);
	
	local pc = GetSkillOwner(skill)
	local abil = GetAbility(pc, "SavePoison")
	if abil ~= nil then 
	    basicsp = basicsp - (basicsp * (abil.Level * 0.01))
	end
	
	if basicsp == 0 then
        return 0;
    end
    
	return math.floor(basicsp)

end

function SCR_Skill_STA(skill)

	local basicsta = skill.BasicSta;
	if basicsta == 0 then
		return 0;
	end

	local pc = GetSkillOwner(skill);
	return basicsta * 1000;

end

function SCR_GET_SKL_CAST(skill)

	local pc = GetSkillOwner(skill);
	local basicCast = skill.BasicCast;
	if basicCast == 0 then
		return 0;
	end
	return basicCast * (100 - pc.SPEED_BM) / 100;

end

function SCR_GET_BonusSkilDam(skill)

	return skill.BonusDam;

end

function SCR_GET_SKL_CAST_ABIL(skill)

	local basicCast = skill.BasicCast;
	return basicCast;

end

function SCR_GET_SKL_READY(skill)

	local pc = GetSkillOwner(skill);
	local stnTime = GetStanceReadyTime(pc);
	local sklFix = skill.ReadyFix;
	local byItem = GetSumOfEquipItem(pc, "ReadyFix");
	local resultValue = stnTime + sklFix + byItem;
	resultValue = resultValue * skill.SkillASPD;
	
	return math.max(0, resultValue);

end

function SCR_GET_SKL_READY_ARC(skill)

	local pc = GetSkillOwner(skill);
	local stnTime = GetStanceReadyTime(pc);
	local sklFix = skill.ReadyFix;
	local resultValue = stnTime + sklFix;

	return math.max(0, resultValue);

end

function SCR_GET_SKL_HITCOUNT(skill)

	return skill.SklHitCount;

end

function SCR_GET_SKL_HITCOUNT_BOW(skill)

	local pc = GetSkillOwner(skill);
	local rItem  = GetEquipItem(pc, 'RH');
	local weaponType = rItem.ClassType;

	if weaponType == 'Bow' then
		if rItem.ArrowCount ~= 0 then
			return rItem.ArrowCount;
		end
	end

	return skill.SklHitCount;
end	  

function SCR_GET_SKL_READY_RF(skill)

	local pc = GetSkillOwner(skill);
	local stnTime = GetStanceReadyTime(pc);
	local sklFix = skill.ReadyFix;
	local resultValue = stnTime + sklFix + pc.ASPD;

	return math.max(0, resultValue);

end

function SCR_GET_SKL_COOLDOWN(skill)

	local pc = GetSkillOwner(skill);
	local basicCoolDown = skill.BasicCoolDown;
	local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
	
	basicCoolDown = basicCoolDown + abilAddCoolDown;
		
	if IsBuffApplied(pc, 'CarveLaima_Buff') == 'YES' then
		basicCoolDown = basicCoolDown * 0.8;
	elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
	    basicCoolDown = basicCoolDown * 1.2;
	end
	
	if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
	    basicCoolDown = basicCoolDown * 0.9;
	end
	
	if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
		if skill.ClassName ~= "Centurion_SpecialForceFormation" then
			basicCoolDown =	basicCoolDown * 0.5;
		end
	end

	return math.floor(basicCoolDown);

end

function SCR_GET_SKL_COOLDOWN_ABIL(skill)

	local basicCoolDown = skill.BasicCoolDown;
	return basicCoolDown;

end

function SCR_GET_SKL_COOLDOWN_MISTWIND(skill)

	local basicCoolDown = skill.BasicCoolDown;
	local pc = GetSkillOwner(skill);
	
	basicCoolDown = basicCoolDown - 100 * pc.INT;
	
	if pc.MistWind_BM > 0 then
		return basicCoolDown * (100 - pc.MistWind_BM) / 100;
	end
	
    if basicCoolDown < skill.MinCoolDown then
		return skill.MinCoolDown;
	end

	return basicCoolDown;

end

function SCR_GET_SKL_COOLDOWN_WIZARD(skill)

	local pc = GetSkillOwner(skill);
	local basicCoolDown = skill.BasicCoolDown;
	local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
	
	basicCoolDown = basicCoolDown + abilAddCoolDown;
	
	if IsBuffApplied(pc, 'CarveLaima_Buff') == 'YES' then
		basicCoolDown = basicCoolDown * 0.8;
	elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
	    basicCoolDown = basicCoolDown * 1.2;
	end
	
	if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
	    basicCoolDown = basicCoolDown * 0.9;
	end
	
    if basicCoolDown < skill.MinCoolDown then
		return skill.MinCoolDown;
	end
	
	return basicCoolDown;

end

function SCR_GET_SKL_COOLDOWN_Bloodletting(skill)

	local pc = GetSkillOwner(skill);
	local basicCoolDown = skill.BasicCoolDown;
	local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
	
	basicCoolDown = basicCoolDown + abilAddCoolDown;
		
	if IsBuffApplied(pc, 'CarveLaima_Buff') == 'YES' then
		basicCoolDown = basicCoolDown * 0.8;
	elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
	    basicCoolDown = basicCoolDown * 1.2;
	end
	
	if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
	    basicCoolDown = basicCoolDown * 0.9;
	end
	
	if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
		if skill.ClassName ~= "Centurion_SpecialForceFormation" then
			basicCoolDown =	basicCoolDown * 0.5;
		end
	end
	
	if IsPVPServer(pc) == 1 then
	    basicCoolDown = basicCoolDown + 20000;
	end

	return math.floor(basicCoolDown);

end

function SCR_GET_SKL_COOLDOWN_HealingFactor(skill)
	
	local pc = GetSkillOwner(skill);
	local basicCoolDown = skill.BasicCoolDown;
	local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
	
	basicCoolDown = basicCoolDown + abilAddCoolDown;
		
	if IsBuffApplied(pc, 'CarveLaima_Buff') == 'YES' then
		basicCoolDown = basicCoolDown * 0.8;
	elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
	    basicCoolDown = basicCoolDown * 1.2;
	end
	
	if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
	    basicCoolDown = basicCoolDown * 0.9;
	end
	
	if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
		if skill.ClassName ~= "Centurion_SpecialForceFormation" then
			basicCoolDown =	basicCoolDown * 0.5;
		end
	end
	
	if IsPVPServer(pc) == 1 then
	    basicCoolDown = basicCoolDown + 20000;
	end	

	return math.floor(basicCoolDown);
	
end

function SCR_GET_SKL_COOLDOWN_GravityPole(skill)
	
	local pc = GetSkillOwner(skill);
	local basicCoolDown = skill.BasicCoolDown;
	local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
	
	basicCoolDown = basicCoolDown + abilAddCoolDown;
		
	if IsBuffApplied(pc, 'CarveLaima_Buff') == 'YES' then
		basicCoolDown = basicCoolDown * 0.8;
	elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
	    basicCoolDown = basicCoolDown * 1.2;
	end
	
	if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
	    basicCoolDown = basicCoolDown * 0.9;
	end
	
	if IsPVPServer(pc) == 1 then
	    basicCoolDown = basicCoolDown + 15000;
	end	

	return math.floor(basicCoolDown);
	
end

function SCR_Get_WaveLength(skill)

	local pc = GetSkillOwner(skill);
	local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "WaveLength");
	if overWriteExist == 1.0 then
		return overWritedValue;
	end	
	
	local waveLength = skill.SklWaveLength;
	if skill.SplType == "Square" then
		waveLength = waveLength + pc.SkillRange + TryGet(pc, skill.AttackType .. "_Range");
	end
	
	return waveLength;	

end

function SCR_Get_Skl_SR(skill)

	local sklSR = skill.SklSR;
	local pc = GetSkillOwner(skill);
	local sumValue = GetSumValueByItem(pc, skill, "SR");
	return sklSR + sumValue;
		
end

function SCR_SPLANGLE(skill)

	local pc = GetSkillOwner(skill);
	local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "SplAngle");
	if overWriteExist == 1.0 then
		return overWritedValue;
	end
	
	local splType = skill.SplType;
	if splType ~= "Fan" then
		return skill.SklSplAngle;
	end
	
	return skill.SklSplAngle + pc.SkillAngle;

end

function SCR_Get_SplRange(skill)

	local pc = GetSkillOwner(skill);
	
	local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "SplRange");
	if overWriteExist == 1.0 then
		return overWritedValue;
	end	

	local splRange = skill.SklSplRange;
	local splType = skill.SplType;
	if splType == "Fan" then
		splRange = splRange + pc.SkillRange + TryGet(pc, skill.AttackType .. "_Range");
	elseif splType == "Square" then
		splRange = splRange + pc.SkillAngle;
	end
	
	return splRange;

end

function SCR_Get_Skl_BackHit(skill)

	local pc = GetSkillOwner(skill);
	local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "BackHitRange");
	if overWriteExist == 1.0 then
		return overWritedValue;
	end	
	
	return 0;

end


--[ Normal_Attack ]--
function SCR_Get_SkillFactor(skill)
    
    local sklFactor;
    local skillOwner = GetSkillOwner(skill);
    
    if skillOwner.ClassName == 'PC' then
        local atkType = skill.AttackType;
        local attribute = skill.Attribute;
        
        local atkTypebyItem = GetSumOfEquipItem(skillOwner, atkType);
        local attributebyItem = GetSumOfEquipItem(skillOwner, attribute);
        
        sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel + atkTypebyItem + attributebyItem;
    	return math.floor(sklFactor);
    else
        sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel;
    	return math.floor(sklFactor);
    end
end

function SCR_Get_SkillFactor_Molich_4(skill)
    
    local self = GetSkillOwner(skill);
    local buff = GetBuffByName(self, 'Melee_charging');
    local buffOver = 0;
    if buff ~= nil then
        buffOver = GetOver(buff);
    end
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel + buffOver;
    
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_Molich_5(skill)
    
    local self = GetSkillOwner(skill);
    local buff = GetBuffByName(self, 'Magic_charging');
    local buffOver = 0;
    if buff ~= nil then
        buffOver = GetOver(buff);
    end
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel + buffOver;
    
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_PC_summon_Canceril(skill)
    
    local self = GetSkillOwner(skill);
    local parent = GetOwner(self)
    --local etc_pc = GetETCObject(parent);
    --local itemGuid = etc_pc.Wugushi_bosscardGUID1;
    --local itembonus = item.Level * 10
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_pc_summon_Manticen(skill)
    
    local self = GetSkillOwner(skill);
    local parent = GetOwner(self)
    --local etc_pc = GetETCObject(parent);
    --local itemGuid = etc_pc.Wugushi_bosscardGUID1;
    --local itembonus = item.Level * 10
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    return math.floor(sklFactor);
end

function SCR_Get_SklAtkAdd(skill)

	local sklAtkAdd;
	local skillOwner = GetSkillOwner(skill);
    
    if skillOwner.ClassName == 'PC' then
    
        sklAtkAdd = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
        
    	return math.floor(sklAtkAdd);
    else
        return 0;
    end
end


function SCR_Get_ReinforceAtk(skill)
  
    local ReinforceAtkAdd
    local self = GetSkillOwner(skill);
    
	  local skillOwner = GetSkillOwner(skill);
  	  if skillOwner.ClassName == 'PC' then
  	  local jobObj = GetJobObject(self);
      local weapon = GetEquipItem(self, 'RH')
      local Transcend = weapon.Transcend

      ReinforceAtkAdd = skill.ReinforceAtkAdd + Transcend * skill.ReinforceAtkAddByLevel;
      
        return ReinforceAtkAdd
      else
        return 1;
      end

end

function SCR_Get_SklAtkAdd_Companion(skill)

	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    if skill.Level > 0 then
        return math.floor(value);
    else
        return 0;
    end

end


function SCR_Get_NormalAttack_Lv(skill)

	local pc = GetSkillOwner(skill);
	local value = pc.Lv
	
  return math.floor(value)
end

function SCR_Get_SklAtkAdd_Thrust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
	

  return math.floor(value)

end

function SCR_ABIL_ADD_SKILLFACTOR(abil, value)
    return value + value * (abil.Level * 0.01)
end

function SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil)
    return abil.Level * 1
end


function SCR_Get_SkillFactor_Thrust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor
	
	local abil = GetAbility(pc, "Swordman2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end
    
    return math.floor(value)
end


function SCR_GET_Thrust_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Swordman2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Bash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
	
	local abil = GetAbility(pc, "Swordman16")      -- Skill Damage add
    if abil ~= nil then
        value = value + abil.Level * 28;
    end	
	
	return math.floor(value)

end

function SCR_Get_SkillFactor_Bash(skill)
	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor
	
	local abil = GetAbility(pc, "Swordman1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end
    return math.floor(value)
end


function SCR_GET_Bash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Swordman1") 
	local value = 0
	if abil ~= nil then 
    return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
  end


end

function SCR_Get_SklAtkAdd_PommelBeat(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_PommelBeat(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Swordman25")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end


function SCR_GET_PommelBeat_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Swordman25") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PommelBeat_Ratio(skill)

    return 20 +  skill.Level * 5

end

function SCR_Get_SklAtkAdd_DoubleSlash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_DoubleSlash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Swordman27")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end


function SCR_GET_DoubleSlash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Swordman27") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_RimBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_RimBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end


function SCR_GET_RimBlow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_UmboBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_UmboBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_UmboBlow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SR_LV_ShieldLob(skill)

	local pc = GetSkillOwner(skill);
	local Peltasta4_abil = GetAbility(pc, 'Peltasta4')

	if Peltasta4_abil ~= nil and 1 == Peltasta4_abil.ActiveState then
	    return pc.SR + skill.SklSR + Peltasta4_abil.Level;
	end
	return pc.SR + skill.SklSR

end

function SCR_Get_SklAtkAdd_ShieldLob(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)
end

function SCR_Get_SkillFactor_ShieldLob(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ShieldLob_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_SR_LV_PommelBeat(skill)

	local pc = GetSkillOwner(skill);	
	return skill.SklSR

end

function SCR_Get_SklAtkAdd_ButterFly(skill)
	
	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)
end

function SCR_Get_SkillFactor_ButterFly(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta22")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ButterFly_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta22") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_UmboThrust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_UmboThrust_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Langort(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Peltasta27")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Langort_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Peltasta27") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SR_LV_HEX(skill)
  local value = skill.Level;
	return value

end


function SCR_Get_SklAtkAdd_Moulinet(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Moulinet(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Moulinet_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_CartarStroke(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_CartarStroke(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CartarStroke_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CartarStroke_Ratio2(skill)

    local value = 0.2 * skill.Level;
    return value

end

function SCR_Get_SklAtkAdd_WagonWheel(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_WagonWheel(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_WagonWheel_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Crown(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Crown(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Crown_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ScullSwing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_ScullSwing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander25")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ScullSwing_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander25") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_SkyLiner(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander29")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SkyLiner_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander29") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_CrossCut(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander30")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CrossCut_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander30") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_VerticalSlash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Highlander31")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_VerticalSlash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Highlander31") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Stabbing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Stabbing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Stabbing_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_LongStride(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_LongStride(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_LongStride_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_SynchroThrusting(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_SynchroThrusting(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SynchroThrusting_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Pierce(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Pierce(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Pierce_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ThrouwingSpear(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_ThrouwingSpear(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ThrouwingSpear_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_SpearLunge(skill)
	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hoplite26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)
end

function SCR_GET_SpearLunge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hoplite26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SklAtkAdd_Embowel(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Embowel(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Embowel_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_StompingKick(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_StompingKick(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_StompingKick_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Pouncing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Pouncing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian24")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Pouncing_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian24") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HelmChopper(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian25")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HelmChopper_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian25") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Seism(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Seism_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Cleave(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Barbarian27")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Cleave_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Barbarian27") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end



function SCR_Get_SklAtkAdd_ShieldCharge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_ShieldCharge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ShieldCharge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Montano(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Montano(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Montano_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_TargeSmash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_TargeSmash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_TargeSmash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ShieldPush(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_ShieldPush(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ShieldPush_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_ShieldShoving(skill)
	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)
end

function SCR_GET_ShieldShoving_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldShoving_Bufftime(skill)

    local value = 1.5
        if IsPVPServer(self) == 1 then
	        value = 3
	    end
    return value

end

function SCR_Get_SkillFactor_ShieldBash(skill)
	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero27")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)
end

function SCR_GET_ShieldBash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero27") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Slithering(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Slithering(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero24")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Slithering_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero24") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SklAtkAdd_ShootingStar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_ShootingStar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ShootingStar_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HighKick(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rodelero28")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HighKick_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rodelero28") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SklAtkAdd_Impaler(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Impaler(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cataphract14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Impaler_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cataphract14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Rush(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Rush(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cataphract11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Rush_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cataphract11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_EarthWave(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_EarthWave(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cataphract17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EarthWave_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cataphract17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_DoomSpike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_DoomSpike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cataphract23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DoomSpike_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cataphract23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_SteedCharge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_SteedCharge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cataphract20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SteedCharge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cataphract20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Keelhauling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Keelhauling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Corsair11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Keelhauling_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Corsair11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Keelhauling_Ratio(skill)
	local pc = GetSkillOwner(skill);
	
	local value = 2;
	
    return value
end

function SCR_Get_SkillFactor_DustDevil(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Corsair12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DustDevil_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Corsair12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HexenDropper(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Corsair13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HexenDropper_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Corsair13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_PistolShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Corsair16")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PistolShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Corsair16") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Cyclone(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Cyclone(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Cyclone_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Cyclone_Ratio2(skill)

 return 2.5 + skill.Level * 0.3

end

function SCR_Get_SklAtkAdd_Mordschlag(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Mordschlag(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Mordschlag_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Punish(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Punish(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Punish_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Zornhau(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Zornhau_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Redel(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner15")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Redel_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner15") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Zucken(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner16")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Zucken_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner16") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SkillFactor_AttaqueComposee(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_AttaqueComposee_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Lunge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Lunge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Lunge_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 10 * skill.Level
	
	return value;

end

function SCR_GET_Lunge_BuffTime(skill)

return 4
end

function SCR_Get_SkillFactor_SeptEtoiles(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SeptEtoiles_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_AttaqueCoquille(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_AttaqueCoquille_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_AttaqueCoquille_Ratio2(skill)

	local value = 4 + skill.Level * 1
  return value

end


function SCR_GET_Preparation_Ratio(skill)

	local value = 50 + skill.Level * 5
  return value

end


function SCR_GET_Preparation_Ratio2(skill)

	local value = 3 + skill.Level * 1
  return value

end

function SCR_Get_SkillFactor_EsquiveToucher(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EsquiveToucher_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_EsquiveToucher_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 10 * skill.Level
	
  return value

end

function SCR_Get_SkillFactor_Flanconnade(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Flanconnade_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Mijin_no_jutsu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Shinobi3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Mijin_no_jutsu_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Shinobi3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Mijin_no_jutsu_Ratio2(skill)


	local value = 7000 - skill.Level * 500

return value

end

function SCR_GET_Bunshin_no_jutsu_Ratio(skill)


	local value = 15 + skill.Level

  return value

end

function SCR_GET_SummonGuildMember_Ratio(skill)
    local value = 1 * skill.Level
    
  return value
end

function SCR_GET_BattleOrders_Ratio(skill)

	local value = 5 * skill.Level

  return value

end

function SCR_GET_BattleOrders_Ratio2(skill)

	local value = 30 + 5 * skill.Level

  return value

end

function SCR_GET_BuildForge_Ratio(skill)

    local value = skill.Level
    return value

end

function SCR_GET_BuildForge_Ratio2(skill)

    local value = 110
    return value

end

function SCR_GET_BuildForge_Time(skill)

    local value = 24
    return value

end

function SCR_GET_BuildShieldCharger_Ratio(skill)

    local value = skill.Level
    return value

end

function SCR_GET_ShareBuff_Ratio(skill)

    local value = 5 + skill.Level
    return value

end

function SCR_GET_ReduceCraftTime_Ratio(skill)

	local value = 5 * skill.Level

  return value

end

function SCR_GET_Bunshin_no_jutsu_Ratio2(skill)

	local value = skill.Level

  return value

end

function SCR_GET_Mokuton_no_jutsu_Ratio(skill)

	local value = 15 + skill.Level * 5

  return value

end
function SCR_Get_SkillFactor_Katon_no_jutsu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Shinobi2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Katon_no_jutsu_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Shinobi2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Kunai(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Shinobi1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Kunai_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Shinobi1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Dragontooth(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Dragontooth_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Serpentine(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Serpentine_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Gae_Bulg(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Gae_Bulg_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_Gae_Bulg_Ratio2(skill)

	local value = 5 + skill.Level * 0.5
  return value

end

function SCR_Get_SkillFactor_Dragon_Soar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Dragon_Soar_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Zwerchhau(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner18")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Zwerchhau_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner18") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Zwerchhau_Bufftime(skill)
	local value = 6.5
    return value
end

function SCR_Get_SkillFactor_Sturzhau(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Doppelsoeldner19")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Sturzhau_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Doppelsoeldner19") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Sturzhau_Ratio2(skill)
    local value = skill.Level * 75
    return value
end

function SCR_GET_Sturzhau_Ratio3(skill)
    local value = skill.Level * 5
    return value
end

function SCR_Get_SkillFactor_BalestraFente(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BalestraFente_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_AttaqueAuFer(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fencer9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_AttaqueAuFer_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fencer9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_AttaqueAuFer_Bufftime(skill)
	local value = 15
	return value
end

function SCR_GET_EpeeGarde_Ratio(skill)

	local value = skill.Level * 20;
	return value

end

function SCR_GET_EpeeGarde_Bufftime(skill)
	local value = 30 + skill.Level * 3
	return value

end

function SCR_Get_SkillFactor_Dethrone(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Dethrone_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Dethrone_Ratio2(skill)
	local value = 5
	return value
end

function SCR_GET_Dethrone_Bufftime(skill)
	local value = 4 * skill.Level
	return value
end

function SCR_Get_SkillFactor_DargonDive(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dragoon13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DargonDive_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dragoon13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_FlowDrill(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Templar1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FlowDrill_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Templar1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CassisCrista_Bufftime(skill)

    local value = 240
    
    return value

end

function SCR_GET_CassisCrista_Ratio(skill)

    local value = 10 * skill.Level;
    
    return value

end

function SCR_Get_SkillFactor_FrenziedSlash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FrenziedSlash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrenziedSlash_Ratio2(skill)

	local value = 4 + skill.Level * 1
	
	return value
end

function SCR_Get_SkillFactor_EvadeThrust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EvadeThrust_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Headbutt(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Headbutt_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Headbutt_Time(skill)
	local value = 3
	
	return value
end

function SCR_Get_SkillFactor_Takedown(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Takedown_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_FrenziedShoot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FrenziedShoot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_ScutumHit(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Murmillo9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ScutumHit_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Murmillo9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Crush(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Lancer2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Crush_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Lancer2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HeadStrike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Lancer4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HeadStrike_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Lancer4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HeadStrike_Ratio2(skill)
    local value = 30 + skill.Level * 2
    return value
end

function SCR_Get_SkillFactor_Joust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Lancer6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Joust_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Lancer6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Joust_Ratio2(skill)

	local value = 10 + skill.Level * 1

    return value

end

function SCR_Get_SkillFactor_SpillAttack(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Lancer7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SpillAttack_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Lancer7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Quintain(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Lancer8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Quintain_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Lancer8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Commence_Ratio(skill)

	local value = 50 + skill.Level * 5
    return value

end

function SCR_GET_Commence_Ratio2(skill)

	local value = skill.Level * 10
    return value

end

function SCR_GET_Commence_Bufftime(skill)

	local value = 10 + skill.Level * 3
    return value

end

function SCR_Get_SklAtkAdd_Multishot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Multishot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Archer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Multishot_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Archer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Fulldraw(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Fulldraw(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Archer12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Fulldraw_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Archer12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ObliqueShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_ObliqueShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Archer13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ObliqueShot_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Archer13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_KnockbackShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_KnockbackShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Archer26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_KnockbackShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Archer26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_DuelShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_DuelShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Archer28")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DuelShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Archer28") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Barrage(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
	
    return math.floor(value);

end

function SCR_Get_SkillFactor_Barrage(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Barrage_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_HighAnchoring(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_HighAnchoring(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HighAnchoring_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_BounceShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_BounceShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BounceShot_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_SpiralArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger30")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SpiralArrow_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger30") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ArrowSprinkle(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);
    
end

function SCR_Get_SkillFactor_ArrowSprinkle(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ArrowSprinkle_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_CriticalShot(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);
    
end

function SCR_Get_SkillFactor_CriticalShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger25")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CriticalShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger25") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_TimeBombArrow(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);
    
end

function SCR_Get_SkillFactor_TimeBombArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Ranger28")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_TimeBombArrow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Ranger28") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ScatterCaltrop(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_ScatterCaltrop(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "QuarrelShooter11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ScatterCaltrop_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "QuarrelShooter11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_StoneShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_StoneShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "QuarrelShooter12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_StoneShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "QuarrelShooter12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_RapidFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_RapidFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "QuarrelShooter13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_RapidFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "QuarrelShooter13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_RunningShot_Ratio(skill)

	local value = 40 * skill.Level
  return value

end

function SCR_Get_SklAtkAdd_DestroyPavise(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_DestroyPavise(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "QuarrelShooter20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DestroyPavise_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "QuarrelShooter20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_BroomTrap(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_BroomTrap(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BroomTrap_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Claymore(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);
    
end

function SCR_Get_SkillFactor_StakeStockades(skill)
	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper29")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)
end

function SCR_GET_StakeStockades_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper29") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Claymore(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Claymore_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_Claymore_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper2") 
	local value = 5
	if abil ~= nil then 
        return value + abil.Level
    end
  return value

end

function SCR_Get_SklAtkAdd_PunjiStake(skill)
	
	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_PunjiStake(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PunjiStake_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_PunjiStake_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 30 + skill.Level * 5
	    if IsPVPServer(self) == 1 then
	        value = 900
	    end
  return value

end

function SCR_Get_SklAtkAdd_DetonateTraps(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_DetonateTraps(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DetonateTraps_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_SpikeShooter(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_SpikeShooter(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SpikeShooter_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_HoverBomb(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_HoverBomb(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sapper27")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HoverBomb_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sapper27") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Coursing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hunter9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Coursing_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hunter9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Snatching(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hunter10")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Snatching_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hunter10") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_RushDog(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hunter11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end
    
    return math.floor(value)

end

function SCR_GET_RushDog_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hunter11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Retrieve(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hunter12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Retrieve_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hunter12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_NeedleBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_NeedleBlow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wugushi11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_NeedleBlow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wugushi11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_NeedleBlow_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 5 + skill.Level * 1

    return value;
end

function SCR_Get_SklAtkAdd_WugongGu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_WugongGu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wugushi14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_WugongGu_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wugushi14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_WugongGu_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 5 + skill.Level * 1

    return value;

end

function SCR_Get_SklAtkAdd_ThrowGuPot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_ThrowGuPot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wugushi17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ThrowGuPot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wugushi17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FluFlu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_FluFlu(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Scout11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FluFlu_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Scout11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FlareShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_FlareShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Scout14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FlareShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Scout14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FlareShot_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 10 + skill.Level * 1
  return value;
  
end

function SCR_Get_SkillFactor_SplitArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Scout17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SplitArrow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Scout17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SklAtkAdd_Vendetta(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Vendetta(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rogue11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Vendetta_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rogue11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Backstab(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Backstab(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Rogue16")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Backstab_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Rogue16") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_BroadHead(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_BroadHead(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BroadHead_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_BodkinPoint(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_BodkinPoint(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BodkinPoint_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_BarbedArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_BarbedArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BarbedArrow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_CrossFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_CrossFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CrossFire_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_MagicArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_MagicArrow(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_MagicArrow_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_MagicArrow_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 5 + skill.Level * 2
	return value 

end

function SCR_Get_SklAtkAdd_Singijeon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Singijeon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Fletcher25")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Singijeon_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Fletcher25") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_ConcentratedFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_ConcentratedFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Schwarzereiter11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ConcentratedFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Schwarzereiter11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Caracole(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Caracole(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Schwarzereiter12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Caracole_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Schwarzereiter12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Limacon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_Limacon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Schwarzereiter13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Limacon_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Schwarzereiter13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Limacon_BuffTime(skill)
    local value = 15 + skill.Level * 2
    return value
end

function SCR_Get_SklAtkAdd_RetreatShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value);

end

function SCR_Get_SkillFactor_RetreatShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Schwarzereiter14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_RetreatShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Schwarzereiter14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_WildShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Schwarzereiter15")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_WildShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Schwarzereiter15") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EvasiveAction_Ratio(skill)

	local value = skill.Level * 2
	return value

end

function SCR_GET_EvasiveAction_Ratio2(skill)

	local value = 5
	return value

end

function SCR_Get_SkillFactor_Hovering(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Falconer5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Hovering_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Falconer5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Pheasant(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Falconer6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Pheasant_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Falconer6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_BlisteringThrash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Falconer8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BlisteringThrash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Falconer8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_CannonShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cannoneer2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CannonShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cannoneer2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_ShootDown(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cannoneer3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ShootDown_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cannoneer3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_SiegeBurst(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cannoneer4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SiegeBurst_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cannoneer4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_CannonBlast(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cannoneer5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CannonBlast_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cannoneer5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SmokeGrenade_Time(skill)
	local value = 7 + skill.Level
    return value
end

function SCR_GET_Bazooka_Ratio(skill)
	local value = skill.Level * 10
    return value
end


function SCR_GET_Bazooka_Ratio2(skill)
	local value = skill.Level * 8;
    return value
end

function SCR_Get_SkillFactor_CoveringFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CoveringFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HeadShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HeadShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Snipe(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Snipe_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_PenetrationShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PenetrationShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_ButtStroke(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ButtStroke_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_BayonetThrust(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BayonetThrust_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Combination(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Falconer9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Combination_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Falconer9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FirstStrike_Ratio(skill)

	local value = 60
	return value

end

function SCR_Get_SkillFactor_CannonBarrage(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cannoneer9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_CannonBarrage_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cannoneer9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Volleyfire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Volleyfire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Birdfall(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Musketeer18")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Birdfall_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Musketeer18") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Skarphuggning(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hackapell1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Skarphuggning_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hackapell1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HakkaPalle_BuffTime(skill)
    local value = 20 + skill.Level * 2
    return value
end

function SCR_GET_HakkaPalle_Ratio(skill)
    local value = 2 + skill.Level
    return value
end

function SCR_Get_SkillFactor_BombardmentOrders(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hackapell2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BombardmentOrders_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hackapell2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BombardmentOrder_Time(skill)
	local value = 2 + skill.Level * 0.3
	return value
end

function SCR_Get_SkillFactor_HackapellCharge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hackapell3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HackapellCharge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hackapell3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HackapellCharge_BuffTime(skill)
	local value = 15 + skill.Level
	return value
end

function SCR_Get_SkillFactor_LegShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Hackapell4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_LegShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Hackapell4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_LegShot_Ratio2(skill)
	local pc = GetSkillOwner(skill);
	local value = 50
	
	local abil = GetAbility(pc, "Hackapell5")
	if abil ~= nil and 1 == abil.ActiveState then
	    value = value + abil.Level
	end
	
	return value
end

function SCR_GET_StormBolt_BuffTime(skill)
	local value = 6 * skill.Level
	return value
end

function SCR_Get_SkillFactor_Unload(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Unload_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Unload_Ratio2(skill)
	local value = 6
	return value
end

function SCR_Get_SkillFactor_FocusFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FocusFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_QuickFire(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_QuickFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_TrickShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_TrickShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_ArrowRain(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_ArrowRain_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_JumpShot(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Mergen7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_JumpShot_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_JumpShot_Ratio2(skill)
	local value = skill.Level * 3;
	return value
end

function SCR_Get_SklAtkAdd_EnergyBolt(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_EnergyBolt(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wizard11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EnergyBolt_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wizard11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_EarthQuake(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_EarthQuake(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wizard13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EarthQuake_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wizard13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SklAtkAdd_MagicMissile(skill)
	
	local pc = GetSkillOwner(skill);

	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value);

end

function SCR_Get_SkillFactor_MagicMissile(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Wizard12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_MagicMissile_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Wizard12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_MagicMissile_Ratio2(skill)

    local value = skill.Level
	return value

end

function SCR_Get_SklAtkAdd_FireBall(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_FireBall(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FireBall_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FireWall(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_FireWall(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FireWall_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Flare(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Flare(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Flare_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_FlameGround(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer26")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FlameGround_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer26") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FirePillar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_FirePillar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer15")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FirePillar_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer15") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_HellBreath(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_HellBreath(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pyromancer14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HellBreath_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pyromancer14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_IceBolt(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_IceBolt(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cryomancer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_IceBolt_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cryomancer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_IciclePike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_IciclePike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cryomancer12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_IciclePike_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cryomancer12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_IceBlast(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_IceBlast(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cryomancer13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_IceBlast_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cryomancer13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_SnowRolling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_SnowRolling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cryomancer20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SnowRolling_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cryomancer20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Telekinesis(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Telekinesis(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Psychokino11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Telekinesis_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Psychokino11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_PsychicPressure(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_PsychicPressure(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Psychokino12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PsychicPressure_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Psychokino12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_MagneticForce(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_MagneticForce(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Psychokino13")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_MagneticForce_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Psychokino13") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_GravityPole(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Psychokino8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_GravityPole_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Psychokino8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Meteor(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Meteor(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Meteor_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Prominence(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Prominence(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Prominence_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Hail(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Hail(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Hail_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Electrocute(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Electrocute(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Electrocute_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_FrostCloud(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FrostCloud_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrostCloud_Ratio2(skill)

    return 10 + skill.Level * 1

end

function SCR_Get_SkillFactor_FreezingSphere(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Elementalist24")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FreezingSphere_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Elementalist24") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_SummonFamiliar(skill)

    local pc = GetSkillOwner(skill);
    local value = (pc.MINMATK + pc.MAXMATK) / (3.5 - (skill.Level * 0.1))
    
    return math.floor(value)

end

function SCR_Get_SkillFactor_SummonFamiliar(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sorcerer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_SummonFamiliar_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sorcerer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Evocation(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sorcerer12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Evocation_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sorcerer12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Desmodus(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sorcerer14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Desmodus_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sorcerer14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_GatherCorpse(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;

    return math.floor(value)

end

function SCR_Get_SkillFactor_GatherCorpse(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Necromancer11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_GatherCorpse_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Necromancer11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FleshCannon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
    
    return math.floor(value)
    
end

function SCR_Get_SkillFactor_FleshCannon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Necromancer12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FleshCannon_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Necromancer12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_FleshHoop(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
    
    return math.floor(value)

end

function SCR_Get_SkillFactor_FleshHoop(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Necromancer15")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FleshHoop_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Necromancer15") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_RevengedSevenfold_Time(skill)
    local value = 60
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Kabbalist1")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    return value
end

function SCR_GET_RevengedSevenfold_Ratio(skill)
	local value = 10 * skill.Level
  return value

end

function SCR_GET_Ayin_sof_Time(skill)
    local value = 20 + skill.Level * 3
    return value
end

function SCR_GET_Ayin_sof_Ratio(skill)
	local value = 20 * skill.Level
  return value

end

function SCR_GET_Ayin_sof_Ratio2(skill)
    local value = 15
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, "Kabbalist6")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Gematria_Ratio(skill)
	local value = skill.Level
  return value

end


function SCR_GET_Notarikon_Ratio(skill)
	local value = skill.Level
  return value

end



function SCR_GET_Multiple_Hit_Chance_Ratio(skill)
	local value = skill.Level * 10
  return value

end


function SCR_GET_Reduce_Level_Ratio(skill)
	local value = skill.Level
  return value

end

function SCR_GET_Reduce_Level_Ratio2(skill)
	local value = 10 + skill.Level
  return value

end

function SCR_GET_Clone_Time(skill)
    local value = skill.Level
    return value
end


function SCR_GET_PoleofAgony_Bufftime(skill)
    local value = 7 + skill.Level * 1
    
    return value
end


function SCR_GET_PoleofAgony_Ratio2(skill)
	local value = 10
	    if IsPVPServer(self) == 1 then
	        value = 5
	    end
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock3")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 0.8;
    end
    return value

end

function SCR_GET_Ngadhundi_Ratio2(skill)
	local value = 10 + skill.Level * 3
  return value

end



function SCR_GET_Invocation_Bufftime(skill)
	local value = 20 + skill.Level * 5
  return value

end

function SCR_Get_Pass_Bufftime(skill)
	local value = skill.Level * 5
  return value

end


function SCR_Get_SklAtkAdd_Combustion(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
    
    return math.floor(value)

end

function SCR_Get_SkillFactor_Combustion(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Alchemist11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Combustion_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Alchemist11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_BloodBath(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Featherfoot3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BloodBath_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Featherfoot3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BloodBath_Ratio2(skill)
    local AddValue = skill.SkillAtkAdd * 0.3
	local value = AddValue
	return math.floor(value);

end

function SCR_Get_SkillFactor_BloodSucking(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Featherfoot4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BloodSucking_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Featherfoot4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_BloodSucking_Ratio2(skill)

  local value = 5 + skill.Level * 5
  return value;

end

function SCR_GET_BloodSucking_Ratio3(skill)

  local value = 42 + skill.Level * 7
  return value;

end


function SCR_GET_BonePointing_Ratio2(skill)

  local value = 30 + skill.Level * 5
  local pc = GetSkillOwner(skill);
  
  local abil = GetAbility(pc, "Featherfoot6")
  if abil ~= nil and 1 == abil.ActiveState then
    value = value + abil.Level
  end
  
  return value;
  
end



function SCR_GET_Kurdaitcha_Ratio(skill)

  local value = 5 + skill.Level * 1
  return value;
  
end

function SCR_GET_Kurdaitcha_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 15
    
    local abil = GetAbility(pc, 'Featherfoot14')
    if abil ~= nil and 1 == abil.ActiveState then
        value = 5
    end
    
    return value;
end

function SCR_GET_HeadShot_Ratio2(skill)
  local pc = GetSkillOwner(skill);
  local value = 5 * skill.Level
    if IsPVPServer(self) == 1 then
        value = (5 * skill.Level) + (pc.HR * 0.1)
    end
  return value;
  
end

function SCR_GET_HealingFactor_Time(skill)

  local value = 15 + skill.Level * 5
  
  local pc = GetSkillOwner(skill);
  if IsPVPServer(pc) == 1 then
    value = math.min(27, value);
  end
  
  return value;
  
end

function SCR_GET_HealingFactor_Ratio(skill)

  local value = 50 + skill.Level * 10
  return value;
  
end

function SCR_GET_Bloodletting_Time(skill)

  local value = 30 + skill.Level * 5
  
  local pc = GetSkillOwner(skill);
  if IsPVPServer(pc) == 1 then
    value = 15 + skill.Level * 2;
  end
   
  return value;
  
end

function SCR_GET_Bloodletting_Ratio(skill)

  local value = 6 - skill.Level
  
  if value <= 0 then
  value = 1
  end
  
  return value;
  
end

function SCR_GET_Fumigate_Ratio(skill)

  local value = 2 + skill.Level
  return value;
  
end

function SCR_GET_Pandemic_Ratio(skill)

  local value = 3 + skill.Level * 2
  return value;
  
end

function SCR_GET_BeakMask_Time(skill)

  local value = 20 + skill.Level * 5
  return value;
  
end

function SCR_GET_Disenchant_Ratio(skill)
    local value = math.min(skill.Level * 10, 100)
    return value;
end

function SCR_GET_Disenchant_Ratio2(skill)
    local value = 2 + skill.Level
    return value;
end

function SCR_Get_SkillFactor_BonePointing(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Featherfoot5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_Get_SkillFactor_BonePointing2(skill)

    local value = skill.SklFactor
    local owl = GetSkillOwner(skill);
    local pc = GetOwner(owl);
    if pc ~= nil then
        local bonePointingSkl = GetSkill(pc, "Featherfoot_BonePointing")
        value = bonePointingSkl.SkillFactor
    end

    return math.floor(value)

end

function SCR_GET_BonePointing_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Featherfoot5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Ngadhundi(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Featherfoot7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Ngadhundi_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Featherfoot7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_PoleofAgony(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Warlock2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PoleofAgony_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Warlock2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Invocation(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Warlock4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Invocation_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Warlock4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_DarkTheurge(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Warlock7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DarkTheurge_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Warlock7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Mastema(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Warlock9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Mastema_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Warlock9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Drain_Bufftime(skill)
    local value = skill.Level * 4.5
    return value
end

function SCR_GET_Drain_Ratio(skill)
    local value = skill.Level
    return value
end

function SCR_GET_Drain_Ratio2(skill)
    local value = 0.7
    return value
end

function SCR_Get_SkillFactor_Hagalaz(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "RuneCaster3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Hagalaz_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "RuneCaster3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Tiwaz(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "RuneCaster5")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Tiwaz_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "RuneCaster5") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_FleshStrike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Necromancer9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_FleshStrike_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Necromancer9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FleshStrike_Bufftime(skill)
    local value = skill.Level
    return value
end

function SCR_GET_FleshStrike_Ratio2(skill)
	local value = 100
    return value
end

function SCR_Get_SkillFactor_AlchemisticMissile(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Alchemist9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_AlchemisticMissile_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Alchemist9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_KundelaSlash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Featherfoot11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_KundelaSlash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Featherfoot11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_EnchantedPowder(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Enchanter1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EnchantedPowder_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Enchanter1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EnchantedPowder_Bufftime(skill)

    local value = 6 + skill.Level * 0.5;
    return value
    
end

function SCR_GET_Rewards_Ratio(skill)

    local value = skill.Level * 10;
    return value
    
end

function SCR_GET_Rewards_Ratio2(skill)

    local value = skill.Level * 10;
    return value
    
end

function SCR_GET_Agility_Ratio(skill)

    local value = skill.Level * 5;
    return value
    
end

function SCR_GET_Agility_Ratio2(skill)
    local value = skill.Level * 0.1
    return value
end

function SCR_GET_Agility_Bufftime(skill)

    local value = 27 + skill.Level * 3;
    return value
    
end

function SCR_GET_Enchantment_Ratio(skill)

    local value = 4 + skill.Level;
    return value
    
end

function SCR_GET_EnchantLightning_Bufftime(skill)

    local value = skill.Level;
    return value
    
end

function SCR_GET_EnchantLightning_Ratio(skill)

    local value = 100 * skill.Level
    return value
    
end

function SCR_GET_Empowering_Bufftime(skill)

    local value = skill.Level * 10 + 60
    return value
    
end

function SCR_GET_Empowering_Ratio(skill)

    local value = skill.Level;
    return value
    
end

function SCR_GET_Empowering_Ratio2(skill)

    local value = skill.Level * 5;
    return value
    
end

function SCR_GET_Portal_Ratio(skill)
	local value = 3
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sage1")
	if abil ~= nil and 1 == abil.ActiveState then
	    value = value + abil.Level
	end
	
	return value;
end

function SCR_GET_Portal_Time(skill)
	local value = 30 - (skill.Level - 1)
	return value;
end

function SCR_Get_SkillFactor_MicroDimension(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sage2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_MicroDimension_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sage2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_UltimateDimension(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sage3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_UltimateDimension_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sage3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Maze(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sage6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Maze_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sage6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Maze_Bufftime(skill)

    local value = 5 + skill.Level * 1;
    return value

end

function SCR_GET_Blink_Bufftime(skill)

    local value = skill.Level * 2;
    return value

end

function SCR_GET_MissileHole_Bufftime(skill)

    local value = 50 + skill.Level * 10;
    return value

end

function SCR_GET_Empowering_Bufftime(skill)

    local value = skill.Level;
    return value

end

function SCR_Get_SklAtkAdd_Heal(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel
    
    value = value + pc.INT;

    return math.floor(value)

end

function SCR_Get_SkillFactor_Heal(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cleric12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Heal_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cleric12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Heal_Time(skill)

	local pc = GetSkillOwner(skill);
	local value = 40;
	
	if IsPVPServer(pc) == 1 then
	    value = 10;
	end
	
	return value

end

function SCR_Get_SklAtkAdd_Cure(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    value = value + math.floor(pc.INT * 1.2);
    return math.floor(value)

end

function SCR_Get_SkillFactor_Cure(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Cleric11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Cure_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Cleric11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DivineMight_Ratio(skill)

	return skill.Level
end

function SCR_Get_SklAtkAdd_Zaibas(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    value = value + pc.INT

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Zaibas(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Kriwi11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Zaibas_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Kriwi11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Aspersion(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel
    
    value = value + pc.MNA

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Aspersion(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Priest11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Aspersion_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Priest11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Exorcise(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)

end

function SCR_Get_SkillFactor_Exorcise(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Priest20")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Exorcise_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Priest20") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Effigy(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Effigy(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Bokor11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Effigy_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Bokor11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Damballa(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Damballa(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Bokor12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Damballa_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Bokor12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Damballa_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.Level * 3
  return value

end

function SCR_Get_SklAtkAdd_BwaKayiman(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_BwaKayiman(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Bokor18")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BwaKayiman_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Bokor18") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Carve(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Carve(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dievdirbys11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Carve_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dievdirbys11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_CarveOwl(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_CarveOwl(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Dievdirbys12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_Get_SkillFactor_CarveOwl2(skill)

    local value = skill.SklFactor
    local owl = GetSkillOwner(skill);
    local pc = GetOwner(owl);
    if pc ~= nil then
        local carveOwlSkl = GetSkill(pc, "Dievdirbys_CarveOwl")
        value = carveOwlSkl.SkillFactor
    end

    return math.floor(value)

end

function SCR_GET_OwlStatue_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Dievdirbys12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_AstralBodyExplosion(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_AstralBodyExplosion(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sadhu11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_AstralBodyExplosion_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sadhu11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Possession(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Possession(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sadhu12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Possession_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sadhu12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_EctoplasmAttack(skill)

    local pc = GetSkillOwner(skill);
    local outofbody = GetSkill(pc, "Sadhu_OutofBody")
    local value = skill.SklAtkAdd;

    if outofbody ~= nil then
	    value = value + (outofbody.Level - 1) * skill.SklAtkAddByLevel
    end
    
    return math.floor(value)
    
end

function SCR_Get_SkillFactor_EctoplasmAttack(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Sadhu14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_Get_SklAtkAdd_Smite(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
	
    return math.floor(value)
    
end

function SCR_Get_Levitation_ratio(skill)

    local value = 30 + skill.Level * 2

	return value;
    
end

function SCR_Get_BloodCurse_ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 60
    
    local abil = GetAbility(pc, 'Featherfoot12')
    if abil ~= nil and 1 == abil.ActiveState then
        value = 80
    end
    
    return value;
end

function SCR_Get_BloodCurse_BuffTime(skill)

    local value = 7 + 0.5 * skill.Level
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, 'Featherfoot12')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 7
    end
    
    return value;
end

function SCR_Get_SkillFactor_Smite(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Paladin14")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Smite_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Paladin14") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Conviction(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Paladin17")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Conviction_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Paladin17") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Conviction_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = skill.Level * 20;
    
    return value

end

function SCR_GET_CorpseTower_Bufftime(skill)

    local value = 30 + skill.Level * 10
    
    return value

end


function SCR_Get_SklAtkAdd_IronSkin(skill)

    local pc = GetSkillOwner(skill);
	local value = 0
	local Monk2_abil = GetAbility(pc, "Monk2")
	if Monk2_abil ~= nil then
	    value = value + pc.MINPATK * (Monk2_abil.Level*0.2)
	end

    return math.floor(value)
    
end

function SCR_Get_SklAtkAdd_DoublePunch(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel
	
    return math.floor(value)
    
end

function SCR_Get_SkillFactor_DoublePunch(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk12")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_DoublePunch_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk12") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_PalmStrike(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_PalmStrike(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk15")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PalmStrike_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk15") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_HandKnife(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)

end

function SCR_Get_SkillFactor_HandKnife(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk18")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HandKnife_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk18") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Bunshin_no_jutsu_BuffTime(skill)


	local value = skill.Level * 10

 return value

end

function SCR_GET_Aspergillum_Time(skill)


	local value = skill.Level * 10

 return value

end

function SCR_GET_LastRites_Time(skill)


	local value = 150 + skill.Level * 30

 return value

end

function SCR_GET_MagnusExorcismus_Time(skill)


	local value = 10 + skill.Level * 1

 return value

end

function SCR_GET_BuildCappella_Ratio(skill)


	local value = 60

 return value

end

function SCR_GET_BuildCappella_Ratio2(skill)


	local value = 10 + skill.Level * 5

 return value

end


function SCR_Get_SklAtkAdd_1InchPunch(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_1InchPunch(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk21")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_1InchPunch_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk21") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_EnergyBlast(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_EnergyBlast(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk23")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_EnergyBlast_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk23") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_God_Finger_Flicking(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    local Monk24_abil = GetAbility(pc, "Monk24")  -- Skill Damage add
    if Monk24_abil ~= nil then
        value = value + Monk24_abil.Level
    end

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_God_Finger_Flicking(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Monk24")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_God_Finger_Flicking_Ratio3(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Monk24") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SklAtkAdd_Indulgentia(skill)
    local pc = GetSkillOwner(skill);
    
    local oblationSkill = GetSkill(pc, "Pardoner_Oblation")
    local oblationCurCount = 0;
    local oblationMaxCount = 0;
    
    local abil = GetAbility(pc, "Pardoner3")
    
    if oblationSkill ~= nil and abil ~= nil and 1 == abil.ActiveState then
        oblationCurCount = GetOblationShopCount(pc);
        oblationMaxCount = GET_OBLATION_MAX_COUNT(skill.Level)
        
        if oblationCurCount > oblationMaxCount then
            oblationCurCount = oblationMaxCount
        end
    end
    
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel + oblationCurCount;
    return math.floor(value)
	
end

function SCR_Get_SkillFactor_Indulgentia(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Pardoner1")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Indulgentia_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Pardoner1") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_IncreaseMagicDEF_Bufftime(skill)
	local pc = GetSkillOwner(skill);
    local value = 45
    
    local abil = GetAbility(pc, "Pardoner6")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
	return value
end


function SCR_GET_IncreaseMagicDEF_Ratio(skill)

	local pc = GetSkillOwner(skill);
    local value = 50 + (skill.Level - 1) * 15 + pc.MNA

	return value

end

function SCR_Get_SklAtkAdd_Carnivory(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel

    return math.floor(value)
    
end

function SCR_Get_SkillFactor_Carnivory(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Druid11")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Carnivory_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Druid11") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_Get_SkillFactor_Incineration(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "PlagueDoctor2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Incineration_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "PlagueDoctor2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end



function SCR_GET_Incineration_Ratio2(skill)


	local value = 1 * skill.Level

  return value


end
function SCR_Get_SkillFactor_Nachash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Kabbalist3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Nachash_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Kabbalist3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Merkabah(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Kabbalist8")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Merkabah_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Kabbalist8") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_MagnusExorcismus(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Chaplain3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_MagnusExorcismus_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Chaplain3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_PlagueVapours(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "PlagueDoctor9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PlagueVapours_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "PlagueDoctor9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PlagueVapours_Bufftime(skill)
	local value = 10 + skill.Level * 1.5
	return value
end

function SCR_Get_SkillFactor_IronMaiden(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Inquisitor2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_IronMaiden_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Inquisitor2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_HereticsFork(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Inquisitor3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_HereticsFork_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Inquisitor3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_IronBoots(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Inquisitor4")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_IronBoots_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Inquisitor4") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_PearofAnguish(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Inquisitor6")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_PearofAnguish_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Inquisitor6") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PearofAnguish_Ratio2(skill)

	local value = skill.Level * 1;
    return value

end

function SCR_GET_BreakingWheel_Bufftime(skill)

	local value = skill.Level * 2;
    return value

end

function SCR_GET_MalleusMaleficarum_Bufftime(skill)

	local value = 7 + skill.Level * 3
    return value

end

function SCR_Get_SkillFactor_GodSmash(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Inquisitor10")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_GodSmash_Ratio(skill)
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Inquisitor10")
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end



function SCR_Get_SkillFactor_Entrenchment(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Daoshi2")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Entrenchment_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi2") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Hurling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Daoshi3")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_Hurling_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi3") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_StormCalling(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Daoshi7")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_StormCalling_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi7") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_BegoneDemon(skill)

	local pc = GetSkillOwner(skill);
	local value = skill.SklFactor

	local abil = GetAbility(pc, "Daoshi9")      -- Skill Damage add
    if abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(abil, value);
    end

    return math.floor(value)

end

function SCR_GET_BegoneDemon_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi9") 
	local value = 0
	if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DarkSight_Time(skill)
    local value = skill.Level
    return value
end

function SCR_GET_DarkSight_Ratio(skill)
    local value = 40 * (1 + skill.Level * 0.1)
    return math.floor(value)
end

function SCR_GET_Hurling_Ratio2(skill)
    local value = skill.Level
    return value
end

function SCR_GET_HiddenPotential_Ratio(skill)
    local value = 10 * skill.Level
    
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi5")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_HiddenPotential_Ratio2(skill)
    local value = 50 * skill.Level
    return value
end

function SCR_GET_HiddenPotential_Time(skill)
    local value = 60
    
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Daoshi6")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 5;
    end
    
    return value
end

function SCR_GET_StormCalling_Ratio2(skill)
    local value = skill.Level * 20
    return value
end

function SCR_GET_StormCalling_Time(skill)
    local value = 4.5 + skill.Level * 0.5;
    return value
end

function SCR_GET_TriDisaster_Time(skill)
    local value = skill.Level
    return value;
end

function SCR_GET_TriDisaster_Ratio(skill)
    local value = skill.Level * 10
    return value;
end

function SCR_GET_CreepingDeath_Ratio(skill)
    local value = skill.Level * 4
    return value;
end

function SCR_GET_CreepingDeath_Ratio2(skill)
    local value = skill.SkillAtkAdd * (1.5 + 0.1 * skill.Level)
    return math.floor(value);
end

function SCR_GET_ShapeShifting_Bufftime(skill)
    local value = 50 + skill.Level * 10
    return value
end

function SCR_GET_Transform_Bufftime(skill)
    local value = 50 + skill.Level * 10
    return value
end

function SCR_Get_SklAtkAdd_Lycanthropy(skill)
	local pc = GetSkillOwner(skill);
	local value = 0
	
	local lycanthropySkl = GetSkill(pc, "Druid_Lycanthropy")
	if lycanthropySkl ~= nil then
	    value = value + lycanthropySkl.SkillAtkAdd
	end
	
    return value
end

function SCR_GET_Lycanthropy_Bufftime(skill)
    local value = skill.Level
    return value
end


--[BodkinPoint]]--

function SCR_Get_BodkinPoint_SkillFactor(skill)

	local value = 112 + skill.Level * 8;
	return value;
end

function SCR_GET_SR_LV_BodkinPoint(skill)

	local pc = GetSkillOwner(skill);
    return math.floor(1 + pc.SR + (skill.Level * 0.2))

end


function SCR_GET_SR_LV_Stabbing(skill)

    return 1

end

function SCR_Get_BodkinPoint_Ratio(skill)

    return 25 + skill.Level * 1;

end

function SCR_Get_DeployPavise_Time(skill)
    
    local value = 16 + skill.Level * 2;
        if IsPVPServer(pc) == 1 then
    	    value = 900;
	    end
    return math.floor(value);

end

function SCR_Get_DeployPavise_Ratio(skill)
    local value = 15 + skill.Level * 5;
    if IsPVPServer(pc) == 1 then
        value = 15;
    end
    return math.floor(value);
end

function SCR_Get_BounceShot_Ratio(skill)

    return 1 + skill.Level * 1;
    
end

function SCR_Get_SmokeBomb_Ratio(skill)

    return 50 + skill.Level * 0.5;

end

function SCR_Get_ArrowSprinkle_Ratio(skill)

    return 0 + skill.Level;

end


function SCR_Get_SteadyAim_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level

    return math.floor(value)

end

function SCR_Get_SteadyAim_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local value = 0
    
    local Ranger14_abil = GetAbility(pc, 'Ranger14');
    if Ranger14_abil ~= nil then
        value = value + Ranger14_abil.Level * 2;
    end
    
    return value

end


function SCR_Get_Retrieve_Bufftime(skill)
    return 4 + skill.Level;
end

function SCR_Get_Retrieve_Ratio(skill)

    return 10 + 6 * skill.Level;
    
end

function SCR_Get_Hounding_Ratio(skill)
    return skill.Level;
end

function SCR_Get_Snatching_Bufftime(skill)
    
    return 2 * skill.Level;
    
end


function SCR_Get_StoneCurse_Bufftime(skill)
    
    return 3 + 2 * skill.Level;
    
end




function SCR_Get_StoneCurse_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 5;
    
    local abil = GetAbility(pc, 'Elementalist2')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value
end

function SCR_Get_SummonFamiliar_Ratio(skill)
    return skill.Level
end

function SCR_Get_SummonSalamion_BuffTime(skill)
    local pc = GetSkillOwner(skill)
    return 50 + skill.Level * 10
end


function SCR_Get_SummonSalamion_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    return pc.Lv
end

function SCR_Get_SummonSalamion_Ratio(skill)
 local pc = GetSkillOwner(skill);
	local value = math.floor((0.3 + 0.1 * skill.Level) * pc.INT)

	return value;
end


function SCR_Get_SummonServant_Ratio(skill)
    local value = skill.Level
    
    if value > 5 then
        value = 5
    end
    
    return value
end

function SCR_Get_Hail_Bufftime(skill)

    local value = 5 + 1 * skill.Level
    return value
    
end

function SCR_Get_Rain_Bufftime(skill)
    local value = 8 + skill.Level * 2
    return value
end

function SCR_Get_Rain_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 0;
    
    local abil = GetAbility(pc, 'Elementalist9')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 5;
    end
    
    return value;
end

function SCR_GET_SafetyZone_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 2;
    
    local abil = GetAbility(pc, 'Cleric18')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 1;
    end
    
    return value;
end


function SCR_GET_Briquetting_Ratio(skill)
    local value = 4.5 + skill.Level * 0.5;
    return value
end

function SCR_GET_ItemAwakening_Ratio(skill)
    return skill.Level;
end

function SCR_GET_Arrest_Ratio(skill)
    local value = 1 + skill.Level * 1
    return value
end
function SCR_Get_Quicken_Ratio(skill)
    local value = 30 * skill.Level
    return value
end

function SCR_GET_Quicken_Bufftime(skill)
    return 30 + skill.Level * 5
end

function SCR_GET_Samsara_Bufftime(skill)
    return 5 + skill.Level * 1
end

function SCR_GET_Stop_Time(skill)
    return 5 + skill.Level * 1
end

function SCR_Get_Bodkin_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 5;
    
    local abil = GetAbility(pc, 'Fletcher2')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value;
end

function SCR_Get_Haste_Ratio(skill)
    return 5 + skill.Level * 1;
end

function SCR_Get_Haste_Bufftime(skill)
    return 30 + skill.Level * 5;
end

function SCR_Get_CreateShoggoth_Ratio(skill)
  local pc = GetSkillOwner(skill);
	local value = math.floor((0.3 + 0.1 * skill.Level) * pc.INT)
    return value
end

function SCR_Get_CreateShoggoth_Ratio2(skill)
  local pc = GetSkillOwner(skill);
	local value = math.floor((0.3 + 0.1 * skill.Level) * pc.MNA)
    return value
end

function SCR_Get_CreateShoggoth_Parts(skill)
  local pc = GetSkillOwner(skill);
	local value = 30
    return value
end

function SCR_Get_FleshCannon_Ratio(skill)
    local value = 15
    return value
end

function SCR_Get_FleshHoop_Ratio(skill)
    local value = 5
    return value
end

function SCR_GET_DirtyWall_Bufftime(skill)
    local value = 14 + skill.Level
    return value
end

function SCR_GET_DirtyWall_Ratio(skill)
    local value = 2 + skill.Level
    return value
end

function SCR_GET_DirtyWall_Ratio2(skill)
    local value = 30
    return value
end

function SCR_GET_DirtyPole_Time(skill)
    local value = 14 + skill.Level
    return value
end

function SCR_GET_DirtyPole_Ratio(skill)
    local value = 20 + skill.Level * 2
        if IsPVPServer(self) == 1 then
	        value = 900
	    end
    return value
end

function SCR_GET_DirtyPole_Ratio2(skill)
    local value = 5
    return value
end

function SCR_GET_Disinter_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 40;
    
    local abil = GetAbility(pc, 'Necromancer4')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 10;
    end
    
    return value
end


function SCR_Get_Cloaking_Bufftime(skill)
    
    return 20 + skill.Level * 3;
    
end



function SCR_Get_SwellBody_Bufftime(skill)
    
    return 5 + skill.Level;
    
end



function SCR_Get_ShrinkBody_Bufftime(skill)
    
    return 5 + skill.Level;
    
end


function SCR_Get_SwellBody_Ratio(skill)
    
    return math.floor(3 + skill.Level * 0.5)
    
end

function SCR_Get_ShrinkBody_Ratio(skill)
    
    return math.floor(3 + skill.Level * 0.5)
    
end

function SCR_Get_Praise_Bufftime(skill)
    return 60 + 10 * (skill.Level - 1)
end

function SCR_Get_Praise_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 25 + 5 * (skill.Level - 1)
    
    return value;
end

function SCR_Get_Pointing_Ratio(skill)
    
    return 15 + 2 * (skill.Level - 1)
    
end

function SCR_Get_Growling_Ratio(skill)
    
    return 3 + skill.Level * 1
    
end


function SCR_Get_Camouflage_Ratio(skill)

    local value = skill.Level * 5
    return math.floor(value);

end

function SCR_Get_Camouflage_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local spdrate = 1 - (skill.Level * 0.1)
    local value = math.max(30 * spdrate, pc.MSPD * spdrate)
    return math.floor(value);

end

function SCR_Get_FluFlu_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 5;
    
    local Scout6_abil =  GetAbility(pc, 'Scout6')
	if Scout6_abil ~= nil and 1 == Scout6_abil.ActiveState then 
        value = value + (Scout6_abil.Level * 1)
	end

    return value;
end

function SCR_Get_Beprepared_Ratio(skill)

    local value = 5 * skill.Level * 1;
    return math.floor(value);
    

end

function SCR_Get_Fluflu_Bufftime(skill)
    
    local value = 8 + skill.Level * 0.2;
    return math.floor(value);

end

function SCR_Get_StoneShot_Bufftime(skill)
    
    local value = 4 + skill.Level * 0.4
    
    if IsPVPServer(pc) == 1 then
        value = value / 2
    end
    
    return value;

end


function SCR_GET_IcePaster_Bufftime(skill)
    
    local value = 3 + skill.Level * 1
    return math.floor(value);

end



function SCR_GET_IcePaster_Ratio(skill)
    
    local value = 5 + skill.Level * 1
    return math.floor(value);

end

function SCR_GET_Barrier_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 30 + (20 * skill.Level) + pc.MNA
    
    return math.floor(value)
    
end

function SCR_Get_Undistance_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 3
    
    return math.floor(value)
    
end

function SCR_Get_Undistance_Ratio2(skill)

    local value = 10 + skill.Level * 1
    
    return value
    
end

function SCR_Get_Claymore_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5

    local abil = GetAbility(pc, "Sapper2")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end

    return math.floor(value)
end

function SCR_Get_DetonateTraps_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 4

    local abil = GetAbility(pc, "Sapper4")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end

    return math.floor(value)

end

function SCR_Get_Detoxify_Ratio(skill)

    local value = 3

    return math.floor(value)
    
end

function SCR_Get_daino_Ratio(skill)

    local value = 1 + skill.Level

    return value;
    
end

function SCR_Get_Coursing_Bufftime(skill)

    local value = 5 + skill.Level * 2;
    return math.floor(value)

end

function SCR_Get_Coursing_Ratio(skill)
    local value = 16 + (skill.Level - 1) * 4;
    return value
end

function SCR_Get_Scan_Time(skill)

    local value = 8 + skill.Level * 2
    return math.floor(value)
    
end

function SCR_Get_Surespell_Bufftime(skill)
    
    return 5 + skill.Level * 2;

end

function SCR_Get_Quickcast_Bufftime(skill)
    
    return 5 + skill.Level * 2;

end

function SCR_Get_Quickcast_Ratio(skill)
    
    return 10 * skill.Level

end


function SCR_GET_ScatterCaltrop_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 20;
    
    local abil = GetAbility(pc, "QuarrelShooter2")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value
end

function SCR_Get_ScatterCaltrop_Ratio2(skill)
    local value = skill.Level;
    
    if value > 15 then
        value = 15
    end
    
    return value
end

function SCR_Get_EnergyBolt_SkillFactor(skill)

	local value = 150 + skill.Level * 12;
	return value;

end


function SCR_GET_SR_LV_HighAnchoring(skill)

    local pc = GetSkillOwner(skill);
    return pc.SR + skill.SklSR + skill.Level * 1

end

--[Psychokino_Telekinesis]--
function SCR_Get_Telekinesis_SkillFactor(skill)

	local value = 110 + skill.Level * 3;
	return value;
end

function SCR_GET_Telekinesis_ThrowDist(skill)

	return 30 + skill.Level * 5;

end


function SCR_GET_PsychicPressure_Ratio(skill)
	return skill.Level + 4
end


function SCR_GET_PsychicPressure_Ratio2(skill)

	return 1
end

function SCR_GET_GravityPole_Ratio(skill)
    if IsPVPServer(self) == 1 then
        return skill.Level * 1
    end

	return 5 + skill.Level * 1
end


function SCR_GET_Telekinesis_ThrowCount(skill)
	
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, 'Psychokino1');
	if abil ~= nil and 1 == abil.ActiveState then
		return math.ceil(0.5 * skill.Level) + abil.Level;
	end

	return math.ceil(0.5 * skill.Level)
end

function SCR_GET_Telekinesis_Holdtime(skill)

	return 3 + skill.Level * 1;

end


--[Wizard_MagicMissile]--

function SCR_Get_MagicMissile_SkillFactor(skill)

	local value = 160 + skill.Level * 15;
	return value;
end


--[Pyromancer_FireBall]--

function SCR_Get_FireBall_SkillFactor(skill)

	local value = 180 + skill.Level * 14;
	return value;
end

function SCR_GET_SR_LV_FireBall(skill)

    return skill.Level

end

function SCR_GET_SR_LV_WoodCarve(skill)

    return 1;

end


--[Pyromancer_EnchantFire]--
function SCR_GET_EnchantFire_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 7.7 + 1.9 * (skill.Level - 1)
	
	local Pyromancer23_abil = GetAbility(pc, "Pyromancer23")    -- 2rank Skill Damage multiple
    local Pyromancer24_abil = GetAbility(pc, "Pyromancer24")    -- 3rank Skill Damage multiple
    if Pyromancer24_abil ~= nil then
        value = value * 1.44
    elseif Pyromancer24_abil == nil and Pyromancer23_abil ~= nil then
        value = value * 1.38
    end
	
    local Pyromancer16_abil = GetAbility(pc, 'Pyromancer16');
	if Pyromancer16_abil ~= nil then
	    value = value + Pyromancer16_abil.Level
	end

    return math.floor(value)

end

function SCR_GET_EnchantFire_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 7.7 + 1.9 * (skill.Level - 1)

    return math.floor(value)
  
end

function SCR_Get_FireBall_Bufftime(skill)

  return 20 + skill.Level * 5
  
end

function SCR_GET_HellBreath_Ratio(skill)

	local pc = GetSkillOwner(skill);
    local value = 2
    return value
end

function SCR_GET_Rapidfire_Bufftime(skill)

    local value = 1 + skill.Level*0.2
    
    return value
  
end


function SCR_GET_EnchantFire_Bufftime(skill)

  return 60 + skill.Level * 10;
  
end

--[Pyromancer_FirePillar]--
function SCR_Get_FirePillar_SkillFactor(skill)

	local value = 26 + skill.Level * 4;
	return value;
end
function SCR_GET_FirePillar_Time(skill)

	return 6 + skill.Level * 0.04;

end


function SCR_GET_FirePillar_HitCount(skill)

	return 5 + skill.Level;

end

function SCR_GET_FireWall_Ratio(skill)
    return math.floor(1 + skill.Level * 0.5)

end

function SCR_GET_FireWall_Ratio2(skill)
    return 2 + skill.Level;
end


function SCR_GET_IceWall_Ratio(skill)
    return 1 + skill.Level * 1
end

function SCR_GET_Blessing_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local statValue = math.floor((pc.MNA * 0.06 + pc.INT * 0.02) * (skill.Level-1))
	local value = 15.5 + (skill.Level-1) * 3.9 + statValue;
	
	
	local Priest18_abil = GetAbility(pc, "Priest18")    -- 2rank Skill Damage multiple
    local Priest19_abil = GetAbility(pc, "Priest19")    -- 3rank Skill Damage multiple
    if Priest19_abil ~= nil then
        value = value * 1.44
    elseif Priest19_abil == nil and Priest18_abil ~= nil then
        value = value * 1.38
    end
        
    local Priest13_abil = GetAbility(pc, "Priest13")
	if Priest13_abil ~= nil then
        value = value + Priest13_abil.Level * 2;
    end
    
    return math.floor(value);

end

function SCR_GET_Blessing_Ratio2(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.Level * 10
	
	local priest5_abil = GetAbility(pc, 'Priest5');
	if priest5_abil ~= nil and 1 == priest5_abil.ActiveState then
	    value = value + priest5_abil.Level * 10
	end
    
    return math.floor(value);

end

function SCR_GET_Blessing_AddCount(skill)
    local pc = GetSkillOwner(skill);
    local value = 2
    
	local Priest6_abil = GetAbility(pc, 'Priest6');
	if Priest6_abil ~= nil and 1 == Priest6_abil.ActiveState then
	    value = value + Priest6_abil.Level
	end
	
    return value
end



function SCR_GET_Carve_BuffTime(skill)

    local pc = GetSkillOwner(skill);
	local value = skill.Level * 5
	
	local Dievdirbys1_abil = GetAbility(pc, 'Dievdirbys1');
	if Dievdirbys1_abil ~= nil and 1 == Dievdirbys1_abil.ActiveState then
	    value = value + Dievdirbys1_abil.Level
	end
    
    return math.floor(value);

end

function SCR_GET_Sacrament_Bufftime(skill)

    return 200 + skill.Level * 20;

end



function SCR_GET_Sacrament_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 12.2 + 3.1 * (skill.Level - 1)
	
	local Priest16_abil = GetAbility(pc, "Priest16")    -- 2rank Skill Damage multiple
    local Priest17_abil = GetAbility(pc, "Priest17")    -- 3rank Skill Damage multiple
    if Priest17_abil ~= nil then
        value = value * 1.44
    elseif Priest17_abil == nil and Priest16_abil ~= nil then
        value = value * 1.38
    end
			
	local Priest12_abil = GetAbility(pc, 'Priest12');
	if Priest12_abil ~= nil then
	    value = value + Priest12_abil.Level
	end
    
    return math.floor(value)

end

function SCR_GET_Sacrament_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 12.2 + 3.1 * (skill.Level - 1)
    
    return math.floor(value)

end

function SCR_GET_Revive_Bufftime(skill)
	local pc = GetSkillOwner(skill);
	local value = 90
	    if IsPVPServer(pc) == 1 then
	        value = 30
	    end
	local Priest21_abil = GetAbility(pc, 'Priest21')
	if Priest21_abil ~= nil and 1 == Priest21_abil.ActiveState and IsPVPServer(pc) == 0 then
	    value = value + Priest21_abil.Level * 7
	end
	
    return value
end

function SCR_GET_Revive_Ratio(skill)
	local value = 5 * skill.Level
    return math.floor(value)
end

function SCR_GET_Revive_Ratio2(skill)
    return skill.Level;
end

function SCR_GET_Exorcise_Bufftime(skill)
	local value = 10
    return value
end

function SCR_GET_MassHeal_Ratio(skill)
    local value = 10 + (skill.Level - 1) * 2
    return value
end

function SCR_GET_MassHeal_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 100 + pc.INT + pc.MNA + (skill.Level - 1) * 35
    return value
end

function SCR_GET_StoneSkin_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 80 * skill.Level * 1
    
	if IsPVPServer(pc) == 1 then
	    value = value + pc.MNA * 0.5
	else
	    value = value + pc.MNA * 4
	end
	
    return math.floor(value)
end


function SCR_GET_MeteorSwarm_Count(skill)
    local meteorCount = 1 + (skill.Level - 1) / 2
    
    if meteorCount > 10 then
        meteorCount = 10;
    end
    return math.floor(meteorCount);
end

function SCR_GET_Burrow_Ratio(skill)
local value = 5 * skill.Level
return value
end

function SCR_Get_HellFire_SkillFactor(skill)

	local value = 57 + skill.Level * 3;
	return value;
end


function SCR_GET_Wizard_Wild_Ratio(skill)
	
    return 15 + skill.Level * 2;
    
end

function SCR_GET_Wizard_Wild_Ratio2(skill)
	
    return 60 - skill.Level * 10;
    
end

function SCR_GET_SwiftStep_Bufftime(skill)

    local pc = GetSkillOwner(skill);
    return 15 + skill.Level * 3;

end

function SCR_GET_SwiftStep_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 10 - skill.Level;
    
    if value <= 0 then
	    value = 1;
	end
	
    return value

end

function SCR_GET_SwiftStep_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level;
	
    return value

end

function SCR_Get_Fulldraw_BuffTime(skill)

    local pc = GetSkillOwner(skill);
    return 5 + 1 * skill.Level;

end

function SCR_Get_Lethargy_Bufftime(skill)

    local value = 30;
    local pc = GetSkillOwner(skill);
    
    local Wizard6_abil = GetAbility(pc, 'Wizard6')
    if Wizard6_abil ~= nil and 1 == Wizard6_abil.ActiveState then 
	    value = value + Wizard6_abil.Level * 2
	end
    
    return value

end

function SCR_GET_SpiralArrow_Ratio(skill)
    return skill.Level + 1;
end



function SCR_GET_Lethargy_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 6  + 3 * (skill.Level - 1)
    

    local Wizard14_abil = GetAbility(pc, "Wizard14")
    if Wizard14_abil ~= nil then
        value = value + Wizard14_abil.Level;
    end
    
    return math.floor(value)

end

function SCR_GET_Lethargy_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 4 + (skill.Level - 1) * 2
    
    return math.floor(value)

end

function SCR_GET_KneelingShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 15.4 + (skill.Level - 1) * 4.1
    
    local Archer21_abil = GetAbility(pc, "Archer21")    -- 2rank Skill Damage multiple
    local Archer22_abil = GetAbility(pc, "Archer22")    -- 3rank Skill Damage multiple
    if Archer22_abil ~= nil then
        value = value * 1.44
    elseif Archer22_abil == nil and Archer21_abil ~= nil then
        value = value * 1.38
    end

    local Archer14_abil = GetAbility(pc, 'Archer14')
    if Archer14_abil ~= nil then
        value = value + Archer14_abil.Level
    end

    return math.floor(value + pc.DEX)

end

function SCR_GET_KneelingShot_Ratio2(skill)

    local value = 10 + 2.5 * skill.Level
    
    return value

end

function SCR_GET_KneelingShot_BuffTime(skill)

    local value = 50 + skill.Level * 32.5
    
    return value

end

function SCR_GET_ObliqueShot_Ratio(skill)
    local value = 80 + skill.Level
    
    return value
end

function SCR_GET_Carve_Ratio(skill)

    local pc = GetSkillOwner(skill);
	local value = 100;
    
    return math.floor(value)

end

function SCR_GET_OwlStatue_Bufftime(skill)
    if IsPVPServer(self) == 1 then
        return 900
    end
    return 20 + skill.Level * 5;
    
end

function SCR_GET_OwlStatue_Ratio(skill)

    local pc = GetSkillOwner(skill);
    return 40 + skill.Level * 10;

end


function SCR_GET_SR_LV_Crown(skill)

	local pc = GetSkillOwner(skill);

	return pc.SR
end


function SCR_GET_CrossGuard_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 3.9 * (skill.Level * 1);    
    local Highlander22_abil = GetAbility(pc, "Highlander22")    -- 2rank Skill Damage multiple
    local Highlander23_abil = GetAbility(pc, "Highlander23")    -- 3rank Skill Damage multiple
    if Highlander23_abil ~= nil then
        value = value * 1.44
    elseif Highlander23_abil == nil and Highlander22_abil ~= nil then
        value = value * 1.38
    end

	local Highlander15_abil = GetAbility(pc, 'Highlander15');
	if Highlander15_abil ~= nil then
		value = value + Highlander15_abil.Level;
	end

    return math.floor(value);

end

function SCR_GET_CrossGuard_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.STR + pc.Lv * 3 + (45 * (skill.Level * 1))
    
    return math.floor(value);

end

function SCR_GET_CorpseTower_Ratio(skill)
    local value = 30 + skill.Level * 5
    return math.floor(value);

end

function SCR_GET_CorpseTower_Ratio2(skill)
    local value = 7
    return math.floor(value);

end

function SCR_GET_RaiseDead_Ratio(skill)
    local value = skill.Level
    return math.floor(value);

end

function SCR_GET_RaiseDead_Ratio2(skill)
   local value = skill.Level * 2
    return math.floor(value);

end

function SCR_GET_RaiseSkullarcher_Ratio(skill)
    local value = skill.Level
    return math.floor(value);

end

function SCR_GET_RaiseSkullarcher_Ratio2(skill)
   local value = skill.Level * 2
    return math.floor(value);

end

function SCR_GET_Trot_Bufftime(skill)

    local value = 20 + skill.Level * 2
    
    return math.floor(value);
end

function SCR_GET_Trot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level * 1
    
    return math.floor(value);
    
end

function SCR_Get_IceBolt_SkillFactor(skill)

	local value = 180 + skill.Level * 13;
	return value;
end

function SCR_GET_ReflectShield_Bufftime(skill)
    
	local value = 20 + skill.Level * 5;
    return math.floor(value);
    
end

function SCR_GET_ReflectShield_Ratio(skill)

  local pc = GetSkillOwner(skill);
	local value = 5 + (skill.Level - 1) * 5;

    
    local Wizard2_abil = GetAbility(pc, "Wizard2")      -- Skill Damage add
    if Wizard2_abil ~= nil and 1 == Wizard2_abil.ActiveState then
        value = value + Wizard2_abil.Level
    end

    return math.floor(value + pc.MNA)

end


function SCR_GET_ReflectShield_Ratio2(skill)
    local pc = GetSkillOwner(skill);
  
	return math.floor(2 + 0.5 * (skill.Level-1))

end

function SCR_GET_Exchange_Bufftime(skill)

	return 10 + skill.Level;

end

function SCR_GET_Exchange_Ratio(skill)

	return 25

end

function SCR_GET_IceWall_Bonus(skill)

	return 100 + 30 * skill.Level;

end

function SCR_GET_IceWall_Bufftime(skill)

	local lv = 5.5 - 0.5 * skill.Level;
	return math.max(3, lv);

end

function SCR_Get_IceTremor_SkillFactor(skill)

	local value = 233 + skill.Level * 31;
	return value;
end

function SCR_GET_SR_LV_IceTremor(skill)

    local pc = GetSkillOwner(skill);
    return skill.Level * 1

end

function SCR_GET_SR_LV_Fleche(skill)

    local pc = GetSkillOwner(skill);
    return 3

end

function SCR_GET_SubzeroShield_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 3;
    
    local abil = GetAbility(pc, "Cryomancer7")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 0.5
    end
    
    return value

end

function SCR_GET_SubzeroShield_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 10 + skill.Level * 5
    return value

end

function SCR_GET_Roasting_Ratio(skill)

    local value = skill.Level * 1
    return value

end

function SCR_GET_SubzeroShield_BuffTime(skill)

    local value = 15 + skill.Level * 3
    return value

end


function SCR_GET_SR_LV_Gust(skill)

	local pc = GetSkillOwner(skill);
	return pc.SR + math.floor(skill.Level / 5);

end

function SCR_GET_Gust_Distance(skill)

	return 200;

end

function SCR_GET_Gust_Ratio(skill)

	local value = 10 + skill.Level * 0.6;
	return math.floor(value);

end

function SCR_GET_Gust_Bufftime(skill)

	local value = 4 + skill.Level * 0.1;
	return math.floor(value);

end

function SCR_Get_IciclePike_SkillFactor(skill)

	local value = 238 + skill.Level * 12;
	return value;
end

--function SCR_GET_Hexing_Ratio(skill)
--	
--	return 30 + 5 * skill.Level;
--	
--end

function SCR_Get_Effigy_SkillFactor(skill)

	local value = 209 + skill.Level * 17;
	return value;
end

function SCR_Get_StabDoll_Dist(skill)

	return (50 + 10 * skill.Level);

end

function SCR_GET_Effigy_Bonus(skill)

    local min = 160 + 7 * (skill.Level-1)
    local max = 230 + 9 * (skill.Level-1)

	return IMCRandom(min, max)

end

function SCR_GET_Effigy_Ratio(skill)

    local value = (160 + 7 * (skill.Level-1)) / 100

	return value

end

function SCR_GET_Effigy_Ratio2(skill)

    local value = (230 + 9 * (skill.Level-1)) / 100

	return value

end

function SCR_GET_SamdiVeve_Bufftime(skill)

	return (7 + 3 * skill.Level);

end

function SCR_GET_OgouVeve_Bufftime(skill)

	return (7 + 3 * skill.Level);

end

function SCR_GET_SR_LV_Damballa(skill)
    return skill.Level * skill.SklSR
end

function SCR_GET_Barrier_Bufftime(skill)

    local value = skill.Level * 2.5 + 47.5
    return math.floor(value)
end

function SCR_GET_Restoration_Ratio(skill)

    local value = 100.7 + (skill.Level - 1) * 16.9
    local pc = GetSkillOwner(skill);

    local Paladin12_abil = GetAbility(pc, "Paladin12")  -- 2rank Skill Damage multiple
    local Paladin13_abil = GetAbility(pc, "Paladin13")  -- 3rank Skill Damage multiple
    if Paladin13_abil ~= nil then
        value = value * 1.44
    elseif Paladin13_abil == nil and Paladin12_abil ~= nil then
        value = value * 1.38
    end

    local Paladin11_abil = GetAbility(pc, "Paladin11")  -- 1rank Skill Damage add
    if Paladin11_abil ~= nil then
        value = value + Paladin11_abil.Level * 2
    end

    return math.floor(value)

end

function SCR_GET_ResistElements_Ratio(skill)
    
    local pc = GetSkillOwner(skill);
    local value = 24 + 6.3 * (skill.Level - 1)
    
    local abil = GetAbility(pc, "Paladin18")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return math.floor(value)
end

function SCR_GET_ResistElements_Ratio2(skill)
    
    local pc = GetSkillOwner(skill);
    local value = skill.Level
    
    local abil = GetAbility(pc, "Paladin1")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 0.8
    end
    
    return value
end

function SCR_GET_ResistElements_Ratio3(skill)
    
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 2.5;
    
    return value
end

function SCR_GET_ResistElements_Bufftime(skill)
    local value = 60 + skill.Level * 5
    return math.floor(value)
end

function SCR_GET_TurnUndead_Ratio(skill)
    return 3 + skill.Level
end

function SCR_Get_IronSkin_Time(skill)
    return 4 + skill.Level;
end

function SCR_Get_IronSkin_Ratio(skill)
	local pc = GetSkillOwner(skill);
	local value = 50 + skill.Level * 10
	
	local abil = GetAbility(pc, "Monk2")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 5
    end
	
	return value
end

function SCR_Get_Golden_Bell_Shield_Time(skill)
    return 3 + skill.Level;
end

function SCR_GET_1InchPunch_Bufftime(skill)
    return 5 + skill.Level * 1;
end

function SCR_GET_EnergyBlast_Ratio(skill)
	local pc = GetSkillOwner(skill);
    local value = pc.MSP * (0.06 - (skill.Level * 0.002))
    
    return math.floor(value)
end

function SCR_GET_God_Finger_Flicking_Ratio(skill)
    local value = 5 + skill.Level * 2
    return value
end

function SCR_GET_God_Finger_Flicking_Ratio2(skill)
    local value = 100
    return value
end

function SCR_GET_DiscernEvil_Ratio(skill)
    local value = skill.Level * 2
    return value
end

function SCR_GET_Indulgentia_Ratio(skill)
    local value = 3 + skill.Level
    return value
end

function SCR_Get_Oblation_Ratio(skill)
    local value = 100 * skill.Level
    return value
end

function SCR_Get_SpellShop_Ratio(skill)
    local value = 7 * skill.Level
    local pc = GetSkillOwner(skill)
    
	local abil = GetAbility(pc, "Pardoner4")
	if abil ~= nil and 1 == abil.ActiveState then
	    value = value + 5 * abil.Level;
	end
    
    return value
end

function SCR_GET_Telepath_Ratio(skill)
    local value = 10 + skill.Level * 1
    return value
end

function SCR_GET_Conversion_Bufftime(skill)
    local value = 10 + skill.Level * 1
    return value
end

function SCR_GET_Carnivory_Ratio(skill)
    local value = 20 + skill.Level * 2;
    return value
end

function SCR_GET_Carnivory_Time(skill)
    local value = 10
    
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Druid8")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_StereaTrofh_Ratio(skill)
    local value =  5 + skill.Level * 1
    return value
end

function SCR_GET_Chortasmata_Bufftime(skill)
    local value = 10 + skill.Level
    
    local pc = GetSkillOwner(skill)
    local Druid1_abil = GetAbility(pc, "Druid1")
    if Druid1_abil ~= nil and 1 == Druid1_abil.ActiveState then
        value = value + Druid1_abil.Level
    end
    
    return value
end

function SCR_GET_Chortasmata_Ratio(skill)
    local value = 2 + skill.Level;
    return value
end

function SCR_GET_ArcaneEnergy_Ratio(skill)
    local value = 3 * skill.Level;
    return value
end

function SCR_GET_ArcaneEnergy_Ratio2(skill)
    local value = 5 + skill.Level * 4
    return value
end

function SCR_GET_ArcaneEnergy_Bufftime(skill)
    local value = 30
    local pc = GetSkillOwner(skill)
    
    local Oracle7_abil = GetAbility(pc, "Oracle7")
    if Oracle7_abil ~= nil and 1 == Oracle7_abil.ActiveState then
        value = value + Oracle7_abil.Level
    end
    
    return value
end

function SCR_GET_CallOfDeities_Ratio(skill)
    local value = 1 + skill.Level * 2;
    return value
end

function SCR_GET_Change_Ratio(skill)
    local value = skill.Level;
    return value
end

function SCR_GET_Forecast_Ratio(skill)
    local value = 30;
    local pc = GetSkillOwner(skill)
    
    local Oracle3_abil = GetAbility(pc, "Oracle3")
    if Oracle3_abil ~= nil and 1 == Oracle3_abil.ActiveState then
        value = value + Oracle3_abil.Level * 2
    end
    
    return value
end

function SCR_GET_CounterSpell_Ratio(skill)
    return 3 + skill.Level * 2
end

function SCR_GET_DeathVerdict_Ratio(skill)
    local value = 60 - (skill.Level * 4);
    return math.max(1, value)
end

function SCR_GET_Prophecy_Bufftime(skill)
    return 5 + skill.Level * 5
end

function SCR_GET_Prophecy_Ratio(skill)
    return skill.Level * 2
end

function SCR_GET_Foretell_Time(skill)
    local value = 15
    return value
end

function SCR_GET_Foretell_Ratio(skill)
    local value = 20 - skill.Level
    return value
end

function SCR_GET_Foretell_Ratio2(skill)
    local value = 40 + skill.Level * 3
    return value
end

function SCR_GET_TwistOfFate_BuffTime(skill)
    local value = 30
    return value
end

function SCR_GET_TwistOfFate_Ratio(skill)
    local value = (skill.Level * 8) - 7
    return value
end

function SCR_GET_TwistOfFate_Ratio2(skill)
    local value = skill.Level * 8
    return value
end

function SCR_GET_HengeStone_Time(skill)
    local value = 4 + skill.Level * 1.5
    return math.floor(value)

end

function SCR_GET_ManaShield_Bufftime(skill)

	return 10 + skill.Level;

end

function SCR_GET_ManaShield_Ratio(skill)

	return 120

end

function SCR_GET_Sleep_Ratio(skill)
    local value = skill.Level
        if IsPVPServer(self) == 1 and value > 5 then
	        value = 5
	    end
	return value

end



function SCR_GET_SR_LV_Bash(skill)

	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, 'Penetration');
	
	if abil ~= nil and skill.ClassName == "Swordman_Bash" and 1 == abil.ActiveState then
	  return pc.SR + skill.SklSR + abil.Level;
	end
	return pc.SR + skill.SklSR

end

function SCR_GET_Crown_Bufftime(skill)

	return 3 + (2 * skill.Level);

end

function SCR_GET_SynchroThrusting_Ratio(skill)
	local pc = GetSkillOwner(skill);
	local equipWeapon = GetEquipItem(pc, 'LH');
	
	if equipWeapon ~= nil and IS_NO_EQUIPITEM(equipWeapon) == 0 then			
		leftHandAttribute	= equipWeapon.Attribute;
	end
	
	local def = equipWeapon.DEF;
	local value = def * 5 + skill.SkillAtkAdd
	
	return math.floor(value);

end


function SCR_GET_SR_LV_SynchroThrusting(skill)

	local pc = GetSkillOwner(skill);
	
	return pc.SR + skill.Level

end



function SCR_GET_Finestra_Bufftime(skill)

	return 30 + (3 * skill.Level);

end

function SCR_GET_Warcry_Bufftime(skill)

	return 30;

end

function SCR_GET_SR_LV_Pull(skill)

	local pc = GetSkillOwner(skill);
	return skill.SklSR;

end


function SCR_GET_Gungho_Bufftime(skill)

	return 60 + skill.Level * 5;

end


function SCR_GET_Gungho_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = 8.2 + (skill.Level - 1) * 3
    
    local Swordman20_abil = GetAbility(pc, "Swordman20")    -- 2rank Atk multiple
    local Swordman21_abil = GetAbility(pc, "Swordman21")    -- 3rank Atk multiple
    if Swordman21_abil ~= nil then
        value = value * 1.44
    elseif Swordman21_abil == nil and Swordman20_abil ~= nil then
        value = value * 1.38
    end
    
    local Swordman13_abil = GetAbility(pc, "Swordman13")
    if Swordman13_abil ~= nil then
        value = value + Swordman13_abil.Level * 1;
    end

    return math.floor(value);

end

function SCR_GET_Gungho_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local value = 2.5 + (skill.Level - 1) * 0.6
    
    local Swordman20_abil = GetAbility(pc, "Swordman20")    -- 2rank Atk multiple
    local Swordman21_abil = GetAbility(pc, "Swordman21")    -- 3rank Atk multiple
    if Swordman21_abil ~= nil then
        value = value * 1.44
    elseif Swordman21_abil == nil and Swordman20_abil ~= nil then
        value = value * 1.38
    end
    
    local Swordman13_abil = GetAbility(pc, "Swordman13")
    if Swordman13_abil ~= nil then
        value = value + Swordman13_abil.Level * 1;
    end
    
    return math.floor(value);
    
end



function SCR_GET_Guardian_Bufftime(skill)

	return 60 + skill.Level * 5;

end

function SCR_GET_Guardian_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = 10.2 + 1.8 * (skill.Level - 1);

    local Peltasta19_abil = GetAbility(pc, "Peltasta19")    -- 2rank Skill Damage multiple
    local Peltasta20_abil = GetAbility(pc, "Peltasta20")    -- 3rank Skill Damage multiple
    if Peltasta20_abil ~= nil then
        value = value * 1.44
    elseif Peltasta20_abil == nil and Peltasta19_abil ~= nil then
        value = value * 1.38
    end

    local Peltasta13_abil = GetAbility(pc, "Peltasta13")
    if Peltasta13_abil ~= nil then
        value = value + Peltasta13_abil.Level;
    end

    return math.floor(value);

end

function SCR_GET_Guardian_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local value = 2 + 0.9 * (skill.Level - 1);
    
    local Peltasta19_abil = GetAbility(pc, "Peltasta19")    -- 2rank Skill Damage multiple
    local Peltasta20_abil = GetAbility(pc, "Peltasta20")    -- 3rank Skill Damage multiple
    if Peltasta20_abil ~= nil then
        value = value * 1.44
    elseif Peltasta20_abil == nil and Peltasta19_abil ~= nil then
        value = value * 1.38
    end
    
    local Peltasta13_abil = GetAbility(pc, "Peltasta13")
    if Peltasta13_abil ~= nil then
        value = value + Peltasta13_abil.Level * 1.26;
    end

    return math.floor(value);
    
end


function SCR_GET_Concentrate_Bufftime(skill)

	return 45;

end


function SCR_GET_Concentrate_Ratio(skill)

	return skill.Level * 2;

end


function SCR_GET_Concentrate_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local statValue = math.floor((pc.STR * 0.04 + pc.DEX * 0.02) * (skill.Level-1))
    local value = 5.9 + (skill.Level - 1) * 1.5 + statValue;

    local Swordman22_abil = GetAbility(pc, "Swordman22")    -- 2rank Skill Damage multiple
    local Swordman23_abil = GetAbility(pc, "Swordman23")    -- 3rank Skill Damage multiple
    if Swordman23_abil ~= nil then
        value = value * 1.44
    elseif Swordman23_abil == nil and Swordman22_abil ~= nil then
        value = value * 1.38
    end
    
    local Swordman14_abil = GetAbility(pc, "Swordman14")
	if Swordman14_abil ~= nil then
        value = value + Swordman14_abil.Level * 2;
    end

	return math.floor(value);

end

function SCR_GET_ShieldPush_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local value = 5;
    
    local abil = GetAbility(pc, 'Rodelero25')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value;

end


function SCR_GET_ShieldPush_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = 15 * skill.Level

	  return value;

end

function SCR_GET_Restrain_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local value = 30 + skill.Level * 3;

	  return value;

end

function SCR_GET_Restrain_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = skill.Level * 6
    
	return math.floor(value);

end


function SCR_GET_Restrain_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local value = 164.4 + (skill.Level - 1) * 41.1
    
    local Swordman24_abil = GetAbility(pc, "Swordman24")    -- 3rank Skill Damage multiple
    if Swordman24_abil ~= nil then
        value = value * 1.44
    end
    
    local abil = GetAbility(pc, "Swordman15")
    if abil ~= nil then
        value = value + abil.Level * 10
    end

	return math.floor(value);

end


function SCR_GET_Frenzy_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local statValue = math.floor(pc.STR * 0.025)
    local value = statValue + 10 + skill.Level;

	return math.floor(value)

end


function SCR_GET_Frenzy_Bufftime(skill)
    return 30 + skill.Level * 2
end

function SCR_GET_Aggressor_Ratio(skill)

	return math.floor(10 + skill.Level * 5)

end


function SCR_GET_Aggressor_Bufftime(skill)


	return 20 + skill.Level * 2

end

function SCR_GET_Frenzy_Buff_Ratio2(skill, pc)

	if nil ~= pc then
		local abil = GetAbility(pc, 'Barbarian22');
		if nil ~= abil and 1 == abil.ActiveState then
			return skill.Level
		end
	end
	  return skill.Level * 2

end

function SCR_GET_BackMasking_Ratio(skill, pc)

	  return 50 + skill.Level * 10

end


function SCR_GET_Warcry_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local Warcry_abil = GetAbility(pc, 'Barbarian1')
    local value = 5;

    if Warcry_abil ~= nil and 1 == Warcry_abil.ActiveState then 
        value = 5 + Warcry_abil.Level;
    end
    
    return value;

end

function SCR_GET_Warcry_Ratio2(skill)

    local defadd = 10 + (skill.Level-1) * 2.3
    return math.floor(defadd);

end


function SCR_GET_Savagery_Bufftime(skill)

	return 40

end


function SCR_GET_Parrying_Bufftime(skill)

	return 50 + 10 * skill.Level

end

function SCR_GET_Parrying_Ratio(skill)

  return  9 + skill.Level

end

function SCR_Get_Zhendu_Ratio(skill)

  return  5 + skill.Level * 2

end

function SCR_GET_JollyRoger_Bufftime(skill)
    local value = 20 + skill.Level * 10;
    
    return value
end

function SCR_GET_SubweaponCancel_Bufftime(skill)
    return 34 + skill.Level * 2
end

function SCR_GET_Looting_Bufftime(skill)
    return 9 + skill.Level
end


function SCR_GET_WeaponTouchUp_Ratio(skill)
    return skill.Level
end

function SCR_GET_WeaponTouchUp_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 2500 + skill.Level * 250 + pc.INT
    local Squire3 = GetAbility(pc, 'Squire3');
	
	if Squire3 ~= nil and 1 == Squire3.ActiveState then
	    value = value + Squire3.Level * 20
	end
	
    return value
end

function SCR_GET_ArmorTouchUp_Ratio(skill)
    return skill.Level
end

function SCR_GET_ArmorTouchUp_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 500 + skill.Level * 50 + pc.INT
    local Squire4 = GetAbility(pc, 'Squire4');
	
	if Squire4 ~= nil and 1 == Squire4.ActiveState then
	    value = value + Squire4.Level * 5
	end
	
    return value
end

function SCR_GET_Repair_Ratio(skill)
    return skill.Level;
end


function SCR_GET_UnlockChest_Ratio(skill)
    
    return skill.Level;

end


function SCR_GET_Conscript_Ratio(skill)
    
    local value = 3 + skill.Level;
    
    if value > 8 then
        value = 8
    end
    
    return value
end


function SCR_GET_Tercio_Ratio(skill)

    local pc = GetSkillOwner(skill)
    return skill.Level * 10

end

function SCR_GET_Phalanx_Ratio(skill)

    local pc = GetSkillOwner(skill)
    return skill.Level * 10

end



function SCR_GET_Wingedformation_Ratio(skill)
    local value = 50 + (3 * skill.Level)
    return value;  
end

function SCR_GET_Wedgeformation_Ratio(skill)

    return 4

end


function SCR_GET_Wedgeformation_Ratio2(skill)
    local value = 50 + skill.Level * 5
    return value

end

function SCR_GET_Testudo_Ratio(skill)
    return 50
end


function SCR_GET_Testudo_Ratio2(skill)
    return skill.Level * 30
end

function SCR_GET_DeedsOfValor_Bufftime(skill)
    return 20 + skill.Level * 3
end

function SCR_GET_DeedsOfValor_Ratio(skill)
    return 10
end

function SCR_GET_DeedsOfValor_Ratio2(skill)
    return skill.Level
end

function SCR_GET_PainBarrier_Bufftime(skill)
    return 14 + skill.Level * 1
end

function SCR_GET_Double_pay_earn_Ratio(skill)
    return skill.Level
end

function SCR_GET_Camp_Ratio(skill)
    return 1 + skill.Level * 0.5
end


function SCR_GET_SR_LV_TEST(skill)

	local pc = GetSkillOwner(skill);
  return skill.SklSR

end

function SCR_Peltasta_SwashBuckling(self)

  return 1;
  
end


function SCR_Get_SwashBuckling_SkillFactor(skill)

	local value = 19 + skill.Level * 38;
	return value;
end


function SCR_GET_SR_LV_SwashBuckling(skill)

    local pc = GetSkillOwner(skill);
    return 6 + skill.Level

end


function SCR_GET_SwashBuckling_Ratio(skill)

	return skill.Level * 2;

end

function SCR_GET_SwashBuckling_Ratio2(skill)


    local pc = GetSkillOwner(skill)
    local Diffuseabil = GetAbility(pc, 'Diffuse')
    local value = 50;

    if Diffuseabil ~= nil then
        value = 50 + 10 * Diffuseabil.Level;
    end
	return value;

end



function SCR_GET_SwashBuckling_Bufftime(skill)

	return 30;

end

function SCR_Get_CrescentWing_SkillFactor(skill)
   	local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
	local value = 185 + skill.Level * 49 + byItem;
	return value;
end

function SCR_GET_SR_LV_CrescentWing(skill)

	local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_GET_Provoke_Ratio(skill)

	return 300

end


function SCR_GET_Provoke_Bufftime(skill)

	return 12 + (skill.Level * 3)

end

function SCR_Get_EarthTremor_SkillFactor(skill)
	local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Strike');
	local value = 202 + skill.Level * 49 + byItem;
	return value;
end

function SCR_Get_EarthTremor_SklAtkAdd(skill)
	
	--local value = 9 + skill.Level * 5;
	local value = 0;
	return value;
end

function SCR_GET_SR_LV_EarthTremor(skill)

	local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_GET_Earthtremor_Bufftime(skill)

	return 3

end

function SCR_GET_Earthtremor_Ratio(skill)

	return 5 + skill.Level * 5;

end

function SCR_Get_Moulinet_SkillFactor(skill)
	local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
	local value = 77 + skill.Level * 3 + byItem;
	return value;
end

function SCR_Get_Moulinet_SklAtkAdd(skill)

	return 0;
end

function SCR_GET_SR_LV_Moulinet(skill)

	local pc = GetSkillOwner(skill);
	local value = pc.SR / 2 + math.floor(skill.Level/5);
	
	if value < 1 then
	    value = 1;
	end
	
    return value;

end

function SCR_Get_Cyclone_SkillFactor(skill)
	local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
	local value = 63 + skill.Level * 23 + byItem;
	return value;
	
end

function SCR_Get_Cyclone_SklAtkAdd(skill)
	
	--local value = 3 + skill.Level * 2;
	local value = 0;
	return value;
end

function SCR_GET_SR_LV_WhirlWind(skill)

	local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_Get_BroadHead_SkillFactor(skill)

	local value = 92 + skill.Level * 8
	return value;
end

function SCR_Get_BroadHead_Ratio(skill)
    local caster = GetSkillOwner(skill);
    local evgDmg = (caster.MINPATK + caster.MAXPATK) / 2;
	local addDmg = 4 + (skill.Level - 1) * 3;
	
	if skill.Level > 5 then
	    addDmg = 4 + (skill.Level - 1) * 5 + (skill.Level - 5) * 6.3
	end
    
    local value = math.floor(evgDmg * 0.3 + addDmg);
    return value;

end

function SCR_Get_BroadHead_Bufftime(skill)
    return 5 + skill.Level * 0.5
end

function SCR_Get_CrossFire_Ratio(skill)
    return 75 + skill.Level * 5;
end


function SCR_Get_Multishot_Ratio(skill)

    local value = 1 + skill.Level;
    
    return value
end

function SCR_Get_BarbedArrow_SkillFactor(skill)

	local value = 140 + skill.Level * 25
	return value;
end

function SCR_GET_SR_LV_MultiShot(skill)

    local pc = GetSkillOwner(skill);
    return pc.SR + math.floor(skill.Level / 5) + skill.SklSR;

end


function SCR_Get_BuildRoost_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 100;
    
    local Falconer1_abil = GetAbility(pc, "Falconer1");
	if Falconer1_abil ~= nil and 1 == Falconer1_abil.ActiveState then
        value = value + Falconer1_abil.Level * 20
	end
    
    return value
end

function SCR_Get_BuildRoost_Ratio2(skill)
    local value = 120;
    return value
end

function SCR_Get_Hovering_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 10;
    
    local abil = GetAbility(pc, "Falconer3")
	if abil ~= nil and 1 == abil.ActiveState then
	    value = value + abil.Level * 3
	end
    
    return value
end

function SCR_Get_Circling_Ratio(skill)
    return skill.Level
end

function SCR_Get_HangingShot_Ratio(skill)
    return 14 + skill.Level
end

function SCR_GET_Aiming_Bufftime(skill)
    local value = skill.Level * 15;
    return value;
end

function SCR_GET_FirstStrike_Bufftime(skill)
    local value = skill.Level;
    return value;
end

function SHOOTMOVE_CYCLONE(skill)

	local pc = GetSkillOwner(skill);
	local ablLevel = GET_ABIL_LEVEL(pc, "DustDevil");

	if ablLevel > 0 then
		return 0;
	end
	
	return 0;
end


function SCR_GET_RimBlow_Bonus(skill)

	return 25 + skill.Level * 30;

end


function SCR_GET_UmboBlow_Bonus(skill)

	return 25 + skill.Level * 30;

end

function SCR_GET_DreadWorm_Bonus(skill)

	return 25 + skill.Level * 50;

end

function SCR_GET_Rage_Bufftime(skill)

	return (12000 + 4000 * skill.Level)/1000;

end

function SCR_GET_Conviction_AttackRatio(skill)

	return 25 + skill.Level * 25;

end


function SCR_GET_Conviction_AttackRatio(skill)

	return 25 + skill.Level * 25;

end

function SCR_GET_Conviction_DefenceRatio(skill)

	return 20 + skill.Level * 15;

end

function SCR_GET_Soaring_Bufftime(skill)

	return 20;

end

function SCR_GET_Conviction_Bufftime(skill)

	return (50000 + 10000 * skill.Level)/1000;

end

function SCR_GET_EnergyBolt_Bonus(skill)

	return 25 + skill.Level * skill.SklFactor * 50;

end

function SCR_GET_EnergyBolt_HitSplRange(skill)

	return 30;

end

function SCR_GET_EnergyBolt_Splash(skill)

	local lv = skill.Level;
	local splCnt = math.min(3, lv) + skill.Splash_BM + 1;
	
	return splCnt;	

end

function SCR_GET_Fog_Bufftime(skill)

	return 4 + skill.Level;

end


function SCR_GET_Heal_Bufftime(skill)
    
    local cnt = skill.Level;
    if skill.Level > 10 then
        cnt = 10;
    end
    
	return cnt;

end

function SCR_GET_Heal_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = ((50 + skill.SkillAtkAdd) * 1.5) * 1.1

	return math.floor(value);

end

function SCR_GET_Heal_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = ((50 + skill.SkillAtkAdd) * 1.5) * 1.3

	return math.floor(value);

end

function SCR_GET_Cure_Ratio(skill)

	local pc = GetSkillOwner(skill);

	return 8 + skill.Level * 2;

end


function SCR_GET_Bless_Bufftime(skill)
    
	return 45 + 10 * skill.Level;

end

function SCR_GET_Bless_Ratio(skill)

	return 12 + 5 * skill.Level;

end

function SCR_GET_Bless_Ratio2(skill)
    
    local value = 20 + skill.Level * 0.3;
    return math.floor(value);

end

function SCR_GET_SafetyZone_Bufftime(skill)

	return 5 + skill.Level;

end

function SCR_GET_DeprotectedZone_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local buffTime = skill.Level * 2 + 4;
    
    local Cleric5_abil = GetAbility(pc, "Cleric5");
    if Cleric5_abil ~= nil and 1 == Cleric5_abil.ActiveState then
        buffTime = buffTime + Cleric5_abil.Level;
    end
	
    return math.floor(buffTime);

end

function SCR_GET_DeprotectedZone_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = 2.8 + (skill.Level - 1) * 0.7 + pc.MNA;
    
    return math.floor(value);

end

function SCR_GET_DeprotectedZone_Ratio2(skill)
    
    local value = 1 + (skill.Level - 1) * 0.5;

    return math.floor(value);

end

function SCR_GET_Fade_Bufftime(skill)
    local value = 10 + skill.Level * 2
    return math.floor(value);
end

function SCR_GET_PatronSaint_Bufftime(skill)
    local value = 60
    return math.floor(value);
end

function SCR_GET_PatronSaint_Raito(skill)
    local value = skill.Level * 3
    return math.floor(value);
end

function SCR_GET_Daino_Bufftime(skill)

    local value = 200;
    local pc = GetSkillOwner(skill);
    local Kriwi5_abil = GetAbility(pc, 'Kriwi5');
    if Kriwi5_abil ~= nil and 1 == Kriwi5_abil.ActiveState then
        value = value + (Kriwi5_abil.Level * 40);
    end

    return value;

end

function SCR_GET_Mackangdal_Bufftime(skill)

    local value = 10 + skill.Level
	return value;

end

function SCR_GET_Hexing_Bufftime(skill)

    local value = skill.Level * 1 + 14;
	return value;

end

function SCR_GET_SpecialForceFormation_Ratio(skill)

    local value = 35 + skill.Level * 5
	return value;

end

function SCR_GET_SpecialForceFormation_Ratio2(skill)

    local value = 55 + skill.Level * 5
	return value;

end

function SCR_GET_Zombify_Bufftime(skill)

    local value = 5 + skill.Level * 5
	return value;

end

function SCR_GET_Zombify_ratio(skill)
	local pc = GetSkillOwner(skill);
	local value = 3 + skill.Level
	local bookor8_abil = GetAbility(pc, 'Bokor8');
	if bookor8_abil ~= nil and 1 == bookor8_abil.ActiveState then
		value = value + bookor8_abil.Level;
	end
	
	return value

end


function SCR_GET_CrossGuard_Bufftime(skill)
	local pc = GetSkillOwner(skill);

	return math.floor(pc.STR * 0.1);

end


function SCR_GET_Finestra_Ratio(skill)

	local pc = GetSkillOwner(skill);

	local value = 10 * skill.Level
	return math.floor(value)

end

function SCR_GET_Finestra_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	
	local value = 8.8 + (skill.Level - 1) * 2.2
	
	local abil = GetAbility(pc, 'Hoplite9');
	if abil ~= nil and 1 == abil.ActiveState then
		value = value * 2;
	end
	
	return math.floor(value)

end

function SCR_GET_HighGuard_Ratio(skill)

	local pc = GetSkillOwner(skill);

	local value = 150 + (skill.Level - 1) * 10
	
	return math.floor(value)

end

function SCR_GET_HighGuard_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	
	local value = skill.Level * 10
	
	return math.floor(value)

end

function SCR_GET_HighGuard_AtkDown(skill)
	
	local pc = GetSkillOwner(skill);
	
	local value = 15
	
	return math.floor(value)

end


function SCR_GET_HolyEnchant_Bufftime(skill)

    return 60 + 0.5 * skill.Level;

end

function SCR_GET_HolyEnchant_Ratio(skill)

    return 20 + 2 * skill.Level;

end


function SCR_GET_Haste_Bufftime(skill)

    return 55 + 5 * skill.Level;

end

function SCR_GET_Haste_Ratio(skill)

    local value = 5 + skill.Level * 0.2;
    return math.floor(value);

end

function SCR_GET_Cure_Bufftime(skill)
    
    local value = 5 + skill.Level;
    return math.floor(value);

end

function SCR_GET_Aukuras_Bufftime(skill)

	return 90 + skill.Level * 10;

end



function SCR_GET_Aukuras_Ratio(skill)

    local value = 21 + (skill.Level - 1) * 6
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Kriwi14');
	if abil ~= nil then
		value = value + abil.Level * 1.5;
	end

	return math.floor(value)

end

function SCR_GET_Aukuras_Ratio2(skill)

    local value = 8 + (skill.Level - 1) * 0.5

	return value

end

function SCR_GET_DivineStigma_Ratio(skill)
    local value = 15 + (skill.Level - 1) * 7;
    return math.floor(value);
end

function SCR_GET_DivineStigma_Ratio2(skill)

    local value = 5 + skill.Level

    return math.floor(value);
end




function SCR_GET_Limitation_Bufftime(skill)

    return 180;

end

function SCR_GET_Limitation_Ratio(skill)

    local value =  10 + 0.9 * skill.Level;
    return math.floor(value);
end

function SCR_Get_Melstis_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 5;

	return value

end

function SCR_Get_Melstis_Ratio2(skill)

	local pc = GetSkillOwner(skill);
	local value = 10 + skill.Level * 5

	return value

end

function SCR_Get_Zalciai_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 12.5 + (skill.Level - 1) * 6.3;

	if pc ~= nil then
        value = value + pc.MNA
	end
	
	local Kriwi17_abil = GetAbility(pc, "Kriwi17")
	if Kriwi17_abil ~= nil then
	    value = value + Kriwi17_abil.Level
	end

    return math.floor(value)

end

function SCR_Get_Zalciai_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 6.3 + (skill.Level - 1) * 1.6
    
	if pc ~= nil then
        value = value + pc.MNA * 0.8
	end

    return math.floor(value)

end

function SCR_GET_Zaibas_Ratio(skill)

    return 4 + skill.Level * 1;

end

function SCR_Get_Aspersion_Ratio(skill)

	local value =  20 + (skill.Level - 1) * 2

    return math.floor(value);

end

function SCR_Get_Resurrection_Ratio(skill)

    return math.floor(skill.Level * 5);

end

function SCR_Get_Resurrection_Time(skill)
    local value = math.max(1, 7 - skill.Level);
    return value
end

function SCR_Get_Monstrance_Bufftime(skill)
	local pc = GetSkillOwner(skill);
	local value = 20
	
	local abil = GetAbility(pc, "Priest22")
    if abil ~= nil and abil.ActiveState == 1 then
	    value = value + abil.Level
	end
	
    return math.floor(value);
end


function SCR_Get_Monstrance_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 6.3 + (skill.Level - 1) * 2.4
	
    if pc ~= nil then
	    value = value + pc.MNA * 0.4
	end
	
    return math.floor(value);
    
end

function SCR_Get_Aspersion_Bufftime(skill)

	local pc = GetSkillOwner(skill);

    return 120;

end

function SCR_Get_OutofBody_Ratio(skill)
    return 140 + skill.Level * 10
end

function SCR_Get_OutofBody_Ratio3(skill)
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Sadhu14") 
	local value = 0
	if abil ~= nil and 1 == abil.ActiveState then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end

function SCR_GET_TransmitPrana_Ratio(skill)

	local pc = GetSkillOwner(skill);
  local value = skill.Level * 10
    return value
end

function SCR_Get_VashitaSiddhi_Ratio(skill)

    return skill.Level * 5;

end

function SCR_Get_VashitaSiddhi_Ratio2(skill)

    local value = 2;
    local pc = GetSkillOwner(skill)
    
    local abil = GetAbility(pc, "Sadhu6")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value - 0.5 * abil.Level;
    end
    
    return value

end

function SCR_Get_Physicallink_Bufftime(skill)

    return 60 + skill.Level * 10

end

function SCR_GET_Isa_Bufftime(skill)

    return 10 * skill.Level

end

function SCR_GET_Isa_Ratio(skill)

    return 10 * skill.Level

end


function SCR_GET_Algiz_Bufftime(skill)

    return 10 * skill.Level

end

function SCR_GET_Algiz_Ratio(skill)

    return 10 * skill.Level

end


function SCR_GET_Thurisaz_Bufftime(skill)

    return 30 * skill.Level

end

function SCR_GET_Thurisaz_Ratio(skill)

    return 100

end

function SCR_GET_Thurisaz_Ratio2(skill)

    return 20

end

function SCR_Get_Bewitch_Ratio(skill)

    return 2 + skill.Level 

end
function SCR_Get_Physicallink_Ratio(skill)

    return skill.Level

end
function SCR_GET_ShieldBash_Ratio2(skill)

    return 5 + skill.Level * 1

end

function SCR_Get_JointPenalty_Bufftime(skill)

    return 10 + skill.Level * 5

end

function SCR_Get_JointPenalty_Ratio(skill)
    local value = 3 + skill.Level * 0.5
    return math.floor(value)
end

function SCR_Get_JointPenalty_Ratio2(skill)
    local value = skill.Level * 10
    return math.floor(value)
end

function SCR_Get_HangmansKnot_Bufftime(skill)
    return 1 + skill.Level * 0.2;
end


function SCR_Get_UmbilicalCord_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 0;

    if pc ~= nil then
        value = pc.DEF
    end

    return value;

end

function SCR_Get_UmbilicalCord_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 0;

    if pc ~= nil then
        value = pc.RHP
    end

    return value;

end


function SCR_GET_Scud_Ratio(skill)

	return 10 + skill.Level * 10

end

function SCR_Get_Slow_Ratio(skill)

	return math.floor(8 + skill.Level * 1.5);

end

function SCR_Get_Slow_Ratio2(skill)
    return 14 + skill.Level * 0.5
end

function SCR_GET_MagnumOpus_Ratio(skill)
    local value = 2 + skill.Level;
    
    if value > 10 then
        value = 10;
    end
    
    return math.floor(value)
end

function SCR_Get_RunningShot_Bufftime(skill)
    return skill.Level * 2 + 13;
end

function SCR_GET_CoverTraps_Ratio(skill)
    return 1 * skill.Level
end

function SCR_GET_SpikeShooter_Ratio(skill)
    return 2 * skill.Level
end

function SCR_GET_SpikeShooter_Ratio2(skill)
    return 50 + skill.Level * 20;
end

function SCR_GET_HoverBomb_Ratio(skill)
    return skill.Level
end

function SCR_GET_SneakHit_Ratio(skill)
    return 60 + skill.Level * 2;
end

function SCR_GET_SneakHit_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local value = 30 + skill.Level * 4;
    
	local Rogue1_abil = GetAbility(pc, 'Rogue1');
	if Rogue1_abil ~= nil and 1 == Rogue1_abil.ActiveState then
	    value = value + 2 * Rogue1_abil.Level
	end

    return value
end

function SCR_GET_Feint_Ratio(skill)
    return 10 * skill.Level;
end

function SCR_GET_Feint_Ratio2(skill)
    return 2 + skill.Level * 1
end

function SCR_GET_Feint_Bufftime(skill)
    return 10 + skill.Level * 2
end

function SCR_GET_Spoliation_Ratio(skill)
    return skill.Level
end

function SCR_GET_Evasion_Ratio(skill)
    return 10 * skill.Level
end

function SCR_GET_Evasion_Bufftime(skill)
    return 15 + skill.Level * 1;
end

function SCR_GET_Vendetta_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 * skill.Level

    return math.floor(value)
end

function SCR_GET_ZombieCapsule_Ratio(skill)
    local value = skill.Level

    return value
end

function SCR_GET_Vendetta_Bufftime(skill)
    return 10 + skill.Level * 2
end

function SCR_GET_Lachrymator_Bufftime(skill)
    return 7 + skill.Level * 1
end

function SCR_GET_Backstab_Ratio(skill)
    return 50 + skill.Level * 2
end

function SCR_Get_Slow_Bufftime(skill)

	return 14 + skill.Level * 0.5;

end

function SCR_GET_Fog_IceRatio(skill)

	return 13 + skill.Level * 2;

end

function SCR_GET_SplitArrow_Ratio2(skill)

	return 200;

end

function SCR_GET_FireBall_Bonus(skill)

	return 30 + skill.Level * 35;

end

function SCR_GET_FireBall_HitSplRange(skill)

	return 50;

end

function SCR_GET_MitigatePenalty_Ratio(skill)

	return 2 * skill.Level

end

function SCR_GET_MitigatePenalty_Ratio2(skill)

	return 0.4 * skill.Level

end

function SCR_GET_MitigatePenalty_BuffTime(skill)

	return 15 * skill.Level

end

function SCR_GET_FirePillar_Bufftime(skill)

    local value = 7 + skill.Level;
    return math.floor(value)
end

function SCR_GET_Kako_Count(skill)

	return 2;

end

function SCR_GET_Kako_Ratio(skill)

	return 8 + 2 * skill.Level;

end


function SCR_Get_FrostCloud_Bufftime(skill)

	return 10

end


function SCR_Get_FlameGround_Bufftime(skill)

	return 15 + skill.Level * 1

end


function SCR_GET_Holy_Baptism_Ratio(skill)

    local value = 10 + skill.Level * 0.4;
    return math.floor(value);

end


function SCR_Get_Raise_Ratio(skill)

    local value = 3 + skill.Level * 2
    return value

end


function SCR_Get_Raise_Ratio2(skill)

    local value = 5 + skill.Level * 1
    return value

end


function SCR_GET_Holy_Baptism_Bufftime(skill)

    return 30;

end


function SCR_GET_REFRIGER_SPLASH(skill)

	local splCnt = 10;
	
	return splCnt;	

end

function SCR_GET_GUST_SPLASH(skill)

	local splCnt = math.ceil(skill.Level / 2);

	
	return splCnt;	

end


function SCR_GET_SPLASH_ICESHATTERING(skill)

	local splCnt = 10;
	
	return splCnt;	

end

function SCR_GET_ICEBOLT_HITSPLRANGE(skill)

	return 20;

end

function SCR_GET_IceBolt_Bonus(skill)

	return 40 + skill.Level * 40;

end


function SCR_GET_IcePillar_Bonus(skill)

	local value = 10 + 0.9 * skill.Level;
	return 1;

end



function SCR_Get_Swap_Ratio(skill)

	local value = skill.Level
	return value;

end


function SCR_Get_Teleportation_Ratio(skill)

	return 100 + skill.Level * 10;

end

function SCR_GET_IcePillar_Bufftime(skill)

	local value = 5 + skill.Level * 1;
	return value

end

function SCR_Get_SwellLeftArm_Ratio(skill)

	local pc = GetSkillOwner(skill);
	local value = 34.4 + (skill.Level -1) * 8.6

    local Thaumaturge12_abil = GetAbility(pc, "Thaumaturge12")  -- 2rank Skill Damage multiple
    local Thaumaturge13_abil = GetAbility(pc, "Thaumaturge13")  -- 3rank Skill Damage multiple
    if Thaumaturge13_abil ~= nil then
        value = value * 1.44
    elseif Thaumaturge13_abil == nil and Thaumaturge12_abil ~= nil then
        value = value * 1.38
    end

    local Thaumaturge11_abil = GetAbility(pc, "Thaumaturge11")  -- 1rank Skill Damage add
    if Thaumaturge11_abil ~= nil then
        value = value + Thaumaturge11_abil.Level * 3    -- Temporary Value
    end

	return math.floor(value)

end

function SCR_Get_SwellRightArm_Ratio(skill)

	local value = 40 + (skill.Level -1) * 9
	local pc = GetSkillOwner(skill);
	
	local Thaumaturge14_abil = GetAbility(pc, "Thaumaturge14")
    if Thaumaturge14_abil ~= nil and 1 == Thaumaturge14_abil.ActiveState then
        value = value + Thaumaturge14_abil.Level * 3
    end
    
	return math.floor(value)

end

function SCR_Get_SwellRightArm_Ratio2(skill)
	local value = 34.4 + (skill.Level - 1) * 8.6;
	local pc = GetSkillOwner(skill);
	
	local Thaumaturge14_abil = GetAbility(pc, "Thaumaturge14")
    if Thaumaturge14_abil ~= nil then
        value = value + Thaumaturge14_abil.Level * 3
    end

	return math.floor(value)
end

function SCR_Get_SwellBrain_Ratio(skill)

    local value = 25 + (skill.Level -1) * 5
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Thaumaturge15')
    if abil ~= nil then
        value = value + abil.Level * 2
    end
    
    return math.floor(value)

end

function SCR_Get_SwellBrain_Ratio2(skill)

    local value = 12.5 + (skill.Level - 1) * 2.5
    
    return math.floor(value)

end

function SCR_Get_SpiritualChain_Bufftime(skill)

    local pc = GetSkillOwner(skill);
    local value = 30 + skill.Level * 5
    
    local abil = GetAbility(pc, 'Linker4')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
	return value
end

function SCR_Get_UmbilicalCord_Bufftime(skill)

    local value = 15 + skill.Level * 3
    
	return value
	
end

function SCR_Get_SwellLeftArm_Bufftime(skill)

    local value = skill.Level * 5 + 25
	return value

end

function SCR_Get_SwellRightArm_Bufftime(skill)

    local value = skill.Level * 5 + 25
	return value

end

function SCR_Get_SwellBrain_Bufftime(skill)

    local value = skill.Level * 5 + 25
	return value

end

function SCR_Get_Transpose_Bufftime(skill)

	local value = 50 + skill.Level * 10

	return value;

end

function SCR_Get_Meteor_Casttime(skill)
	local value = skill.Level * 1

	return value;
end

function SCR_Get_Summoning_Ratio(skill)
 local pc = GetSkillOwner(skill);
	local value = math.floor((0.3 + 0.1 * skill.Level) * pc.INT)

	return value;
end

function SCR_Get_Summoning_Ratio2(skill)
    local pc = GetSkillOwner(skill);
	local value = math.floor((0.3 + 0.1 * skill.Level) * pc.MNA)

	return value;
end

function SCR_Get_Electrocute_Ratio(skill)
    local value = 2 + skill.Level * 0.5
    return math.floor(value);
end


function SCR_GET_IceTremor_Bonus(skill)

	return set_LI(skill.Level, 10, 90)

end

  
function SCR_GET_TEST3_Bonus(skill)

  local lv = skill.Level;
  
  if lv >= 1 then
  	return skill.BonusDam + 100;
	end
	return skill.BonusDam;
end

function SCR_GET_KDOWNPOWER(skill) 

	local pc = GetSkillOwner(skill);
  
  return skill.KDownValue;
  
end

function SCR_GET_KDOWNPOWER_Thrust(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "DeepStraight")

    if abil == nil then
        return skill.KDownValue;
    else
        return skill.KDownValue + (abil.Level * 50);
    end

end

function SCR_GET_KDOWNPOWER_WagonWheel(skill) 

    return skill.KDownValue + skill.Level * 25;

end


function SCR_GET_KDOWNPOWER_CartarStroke(skill) 
    
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, "Highlander28")
    if abil ~= nil and 1 == abil.ActiveState then
        return 0;
    end
    
    local abil = GetAbility(pc, "Highlander3")
    if abil ~= nil and 1 == abil.ActiveState then
        return skill.KDownValue + (abil.Level * 50);
    else
        return skill.KDownValue;
    end
    
end

--function SCR_GET_KDOWNPOWER_UmboBlow(skill)
--
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, "Peltasta8")
--
--    if abil == nil then
--        return skill.KDownValue;
--    else
--        return skill.KDownValue + (abil.Level * 20);
--    end
--
--end

function SCR_GET_KDOWNPOWER_Fulldraw(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Overwhelming")

    if abil ~= nil and 1 == abil.ActiveState then
        return skill.KDownValue + (abil.Level * 50);
    else
        return skill.KDownValue;
    end

end


function SCR_NORMAL_PUNISH(self, from, skill, splash, ret)	
	if OnKnockDown(self) == "YES" then
		SCR_NORMAL_ATTACK(self, from, skill, splash, ret);
	else
		NO_HIT_RESULT(ret);
	end
end

function SCR_NORMAL_SYNCHROTHRUSTING(self, from, skill, splash, ret)

	local rhDamage = SCR_LIB_ATKCALC_RH(from, skill)

	local leftHandAttribute = "Melee"
	local rightHandAttribute = "Melee"	
	
	local rhEquipWeapon = GetEquipItem(from, 'RH');
	if rhEquipWeapon ~= nil and IS_NO_EQUIPITEM(rhEquipWeapon) == 0 then
		rightHandAttribute = rhEquipWeapon.Attribute;
	end
	
	local lhEquipWeapon = GetEquipItem(from, 'LH');
	if lhEquipWeapon ~= nil and IS_NO_EQUIPITEM(lhEquipWeapon) == 0 then
		leftHandAttribute = lhEquipWeapon.Attribute;
	end
	
	local def = lhEquipWeapon.DEF;
	local strikeDamage = def * 5 + skill.SkillAtkAdd
	local ariesDamage = rhDamage + skill.SkillAtkAdd;
	
	local abil = GetAbility(from, 'Hoplite7');
	if abil ~= nil then
		strikeDamage = strikeDamage * (1 - abil.Level * 0.1);
		ariesDamage = ariesDamage * (1 + abil.Level * 0.1);
	end
	
	local key = GetSkillSyncKey(from, ret);
	StartSyncPacket(from, key);
	RunScript('SCR_SYNCHROTHRUSTING_TAKEDAMAGE', self, from, skill, ariesDamage, strikeDamage, rightHandAttribute, leftHandAttribute)
	EndSyncPacket(from, key, 0);

	NO_HIT_RESULT(ret);
end

function SCR_SYNCHROTHRUSTING_TAKEDAMAGE(self, from, skill, ariesDamage, strikeDamage, rightHandAttribute, leftHandAttribute)
    TakeDamage(from, self, "None", ariesDamage * skill.SkillFactor/100, rightHandAttribute, "Aries", "Melee", HIT_BASIC, 0);
	sleep(200)
	TakeDamage(from, self, "None", strikeDamage * skill.SkillFactor/100, leftHandAttribute, "Strike", "Melee", HIT_BASIC, 0);
end


function SCR_SKILL_FoldingFan(self, from, skill, splash, ret)
	NO_HIT_RESULT(ret);

	local angle = GetSkillDirByAngle(from);
	    AddBuff(from, self, 'FoldingFan_Buff', 1, 0, 1300, 1);
	    KnockBack(self, from, 200, angle, 30, 0.9);

	
end


function SCR_SKILL_BubbleStick(self, from, skill, splash, ret)
	NO_HIT_RESULT(ret);
	
end



function SCR_NOHIT_ATTACK(self, from, skill, splash, ret)

	NO_HIT_RESULT(ret);

    SCR_SKILL_SPECIAL_CALC(self, from, ret, skill);


end




function SCR_GET_SR_LV_TurnUndead(skill)

	local value = 3 + skill.Level

	return value
	
end

function SCR_GET_SR_LV(skill)

	local pc = GetSkillOwner(skill);
	local value = pc.SR + skill.SklSR;
	
	if value < 1 then
	    value = 1
	end
	
	return value
	
end


function SCR_GET_SR_LV_MagicMissile(skill)

	return 1;
	
end



function SCR_Get_SkillASPD(skill)

	local pc = GetSkillOwner(skill);
	local stc = GetStance(pc);
	if stc == nil then
		return 1.0;
	end

	return stc.SkillASPD;
end

function SCR_GET_USEOVERHEAT(skill)	
	local pc = GetSkillOwner(skill);
	--local reduce_OH_value = SCR_GET_ADDOVERHEAT(pc, skill);
	--skill.	
	local skillScale = 0.4; -- ????-- skill.xml????????
--	local byStat = math.pow(math.log(pc.MNA + 2.718282), skillScale);

	local value = skill.SklUseOverHeat;	
	value = value * ((100 + pc.OverHeat_BM) / 100);
	if value < 0 then
		value = 0;
	end
	
--	value = value / byStat;
	
	return math.floor(value);
end

function SCR_GET_Tackle_Bonus(skill)
  
  	return skill.BonusDam + 84;
  	
end

function SCR_SKILL_MAXR(skill)
	
	local pc = GetSkillOwner(skill);
	return skill.MaxRValue + pc.MaxR_BM;
	
end

function SCR_NORMALSKILL_MAXR(skill)
	
	local pc = GetSkillOwner(skill);
	local abil = GetAbility(pc, "Mergen1")
	
	local abilBonus = 0
	if abil ~= nil and 1 == abil.ActiveState then
	    abilBonus = abilBonus + abil.Level;
	end
	
	return skill.MaxRValue + pc.MaxR_BM + abilBonus;
	
end

function SCR_SKILL_ITEM_MAXR(skill)

	
	local pc = GetSkillOwner(skill);

	local maxr = skill.MaxRValue + pc.MaxR_BM;

	local rItem  = GetEquipItem(pc, 'RH');
	if rItem ~= nil then
		maxr = maxr + rItem.AddSkillMaxR;
	end
	
	return maxr;
end

function SCR_GET_SKILLLV_WITH_BM(skill)
	local fixedLevel = GetExProp(skill, "FixedLevel");
	if fixedLevel > 0 then
		return fixedLevel;
	end

    local value = skill.LevelByDB + skill.Level_BM;
	if skill.GemLevel_BM > 0 then
		value = value + 1;	-- ?????? ?????????? ??ø????? ?????? +1?? ????????.
	end

	if skill.HitType == 'Pad' then
		local owner = GetSkillOwner(skill);
			local jobObj = GetJobObject(owner);
			if jobObj ~= nil and jobObj.CtrlType == 'Cleric' then
				local isHengeStone = GetExProp(owner, 'HENGE_STONE_SATE');
				if isHengeStone > 0 then
					value = value + 1;
				end
			end
		end

    if skill.LevelByDB == 0 then
        return 0;
    end
    
    if value < 1 then
        value = 1;
    end

	return value;
end

function SCR_GET_SR_LV_WagonWheel(skill)
    local pc = GetSkillOwner(skill);
	local byAbil = 0;
	local abil = GetAbility(pc, 'Highlander6');
	if abil ~= nil and 1 == abil.ActiveState then
		byAbil = abil.Level * 1;
	end

	return pc.SR + skill.SklSR + byAbil
end


function SCR_GET_SPENDITEM_COUNT(skill)
	return skill.SpendItemBaseCount;
end

function SCR_GET_Dekatos_Ratio(skill)
	return 1500
end




function SCR_GET_SPENDITEM_COUNT_Aspersion(skill)

	local count = skill.SpendItemBaseCount;
	local pc = GetSkillOwner(skill);
	if GetAbility(pc, 'Priest1') ~= nil then
		count = count + 1;
	end

	 return count;
end


function SCR_GET_SPENDITEM_COUNT_Blessing(skill)

	local count = skill.SpendItemBaseCount;
	local pc = GetSkillOwner(skill);

	return count;
end

function SCR_GET_Hexing_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 12.9 + (skill.Level - 1) * 3.2 + pc.MNA * 0.3
    
    return math.floor(value);
    
end

function SCR_GET_IronHook_Ratio(skill)
    
    local pc = GetSkillOwner(skill);
    
    return 4 + skill.Level * 1
end

function SCR_GET_Ogouveve_Ratio(skill)
    
    local pc = GetSkillOwner(skill);
    local value = (pc.INT * 0.5) + 2 + 1.2 * (skill.Level - 1)
    
    return math.floor(value);
end

function SCR_GET_Ogouveve_BuffTime(skill)
    
    local pc = GetSkillOwner(skill);
    local value = 60 + skill.Level * 10
    
    return math.floor(value);
end


function SCR_GET_Ogouveve_Ratio2(skill)
    
    local value = 1 + skill.Level * 0.5
    
    return math.floor(value);
end

function SCR_GET_Samdiveve_Ratio(skill)

    local value = 298.6 + (skill.Level - 1) * 74.6
    return math.floor(value)

end

function SCR_GET_Samdiveve_Ratio2(skill)

    local value = 3 + skill.Level * 1
    return value
     
end

function SCR_GET_Samdiveve_BuffTime(skill)

    local value = 60 + skill.Level * 10
    return value
     
end

function SCR_GET_CarveAustrasKoks_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 12 + skill.Level * 3
    
    local abil = GetAbility(pc, "Dievdirbys5")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level * 10
    end
    
    return value
end


function SCR_GET_CarveAustrasKoks_Ratio2(skill)
    local count = skill.SpendItemBaseCount;
    
    count = count - math.floor(skill.Level / 5);
    return count;
end

function SCR_GET_CarveVakarine_Ratio(skill)
    return skill.Level
end

function SCR_GET_CarveZemina_Ratio(skill)
    return 2 + (skill.Level * 2);
end

function SCR_GET_CarveZemina_Ratio2(skill)
    return 25 + (skill.Level * 5);
end

function SCR_GET_CarveLaima_Ratio(skill)
    return 20
end

function SCR_GET_CarveLaima_Ratio2(skill)
    return 25 + (skill.Level * 5)
end

function SCR_GET_CarveLaima_Ratio3(skill)
    local value = 20
        if IsPVPServer(self) == 1 then
	        value = 10
	    end
	return value;
end

function SCR_GET_CarveAusirine_Ratio(skill)
    return 8 + (skill.Level * 2)
end
function SCR_GET_DELAY_TIME(skill)
	local actor = GetSkillOwner(skill);
	if actor ~= nil then
		if actor.ClassName ~= "PC" and actor.Faction == "Monster" then
		    if skill.ClassType == 'Missile' or skill.UseType == 'FORCE' or skill.UseType == 'FORCE_GROUND' then
		        if actor.Lv < 75 then
    		        return 3000;
    			elseif actor.Lv < 170 then
    			    return 2500;
    			elseif actor.Lv < 220 then
    			    return 2000;
    			else
    			    return 1500;
    			end
		    else
    		    if actor.Lv < 40 then
    		        return 3000;
    		    elseif actor.Lv < 75 then
    			    return 2500;
    			elseif actor.Lv < 120 then
    			    return 2000;
    			elseif actor.Lv < 170 then
    			    return 1500;
    			elseif actor.Lv < 220 then
    			    return 1000;
    			else
    			    return 500;
    			end
    		end
		end
	end
	return skill.DelayTime;
end

function SCR_USE_DELAY_TIME(skill)
	return skill.DelayTime;
end

function SCR_GET_Dig_Ratio(skill)
	local value = skill.Level;
	return value;
end