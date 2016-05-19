function BOSSINTRO_ON_INIT(addon, frame)
    
end

function UI_BOSS_INTRO(frame, addon, handle, bossID)

	local mapClassName = session.GetMapName();
    local mapIES = GetClass('Map', mapClassName)

	handle = tonumber(handle);
	local funcStr = string.format("BOSS_INTRO_EFT(%d)", handle);
	ReserveScript(funcStr, 0.2);

	local bossCls = GetClassByType("Monster", bossID);
	if mapIES.Mission == 'YES' then
		frame:ShowWindow(1);
		frame:SetDuration(3);
		frame:SetTextByKey("BossName", bossCls.Name);
		frame:SetTextByKey("BossIntroMsg", ClMsg("BossMonsterAppeared"));
	end

	-- Ÿ�� ������ HP UI�� ���������� ������ �ȵǾ intro�� �ѹ� ������Ʈ �����Ŵ.
	local bossUIframe = ui.GetFrame('targetinfotoboss')
	TARGETINFOTOBOSS_ON_MSG(bossUIframe, 'TARGET_UPDATE');
end

function BOSS_INTRO_EFT(handle)

	debug.TestBossIntro(handle, 3, 4.0, 0.5, 0.5);
	world.ShockWave(nil, 2, 999, 4.0, 2, 80, 0);

end