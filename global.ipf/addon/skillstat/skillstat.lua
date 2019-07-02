local function IS_SKILLRESET_ITEM(itemClsName)
	if itemClsName == 'Premium_SkillReset' or itemClsName == 'Premium_SkillReset_14d' or itemClsName == 'Premium_SkillReset_1d' or itemClsName == 'Premium_SkillReset_60d' or itemClsName == 'Premium_SkillReset_Trade' or itemClsName == 'PC_Premium_SkillReset' or itemClsName == 'Premium_SkillReset_14d_Team' or itemClsName == 'steam_Premium_SkillReset_1' or itemClsName == 'steam_Premium_SkillReset' then
		return true;
	end
	return false;
end
