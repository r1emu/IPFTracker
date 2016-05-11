

function GUILDBATTLE_SCORE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("MGAME_VALUE_UPDATE", "GUILDBATTLE_SCORE_MGAME_VALUE_UPDATE");
	
end

function GUILDTOWER_BATTLE_INIT_UI()

	TARGET_INFO_OFFSET_Y = 20;
	TARGET_INFO_OFFSET_X = 1350;

	local targetBuff = ui.GetFrame("targetbuff");
	targetBuff:MoveFrame(1400, targetBuff:GetY());

	local channel = ui.GetFrame("channel");
	channel:ShowWindow(0);

end

function GET_TEAM_ID_FROM_PROP_NAME(propName)
	local underBarPos = string.find(propName, "_");
	local subString = string.sub(propName, underBarPos + 1, string.len(propName));
	return tonumber(subString);
end

function GUILDBATTLE_SCORE_MGAME_VALUE_UPDATE(frame, msg, key, value)
	
	local scorePos = string.find(key, "KillCount_");
	if scorePos ~= nil then
		local teamID = GET_TEAM_ID_FROM_PROP_NAME(key);
		local etcObj = GetMyEtcObject();
		local myTeamID = etcObj.Team_Mission;
		local killScoreUI = nil;
		if teamID == myTeamID then
			killScoreUI = frame:GetChild("kill_" .. 1);
		else
			killScoreUI = frame:GetChild("kill_" .. 2);
		end

		killScoreUI:SetTextByKey("value", value);
	end

	if string.find(key, "TowerHP_") ~= nil then
		local teamID = GET_TEAM_ID_FROM_PROP_NAME(key);
		local etcObj = GetMyEtcObject();
		local myTeamID = etcObj.Team_Mission;
		local gaugeUI = nil;
		if teamID == myTeamID then
			gaugeUI = GET_CHILD(frame, "g_team_" .. 1);
		else
			gaugeUI = GET_CHILD(frame, "g_team_" .. 2);
		end

		local cur = gaugeUI:GetDestPoint();
		gaugeUI:SetPointWithTime(value, 0.25, 0.5);
		if cur > value then
			UI_PLAYFORCE(gaugeUI, "gauge_damage");
		end
		
	end
	

end

function GUILDBATTLE_SCORE_FIRST_OPEN(frame)

	local info = session.mgame.GetPVPAdditionalInfo();
		
	local etcObj = GetMyEtcObject();
	local myTeamID = etcObj.Team_Mission;
	local myName = "";
	local targetName = "";
	local myGroupID = "";
	local targetGroupID ="";
	if myTeamID == 1 then
		myName = info:GetGuildName(0);
		targetName = info:GetGuildName(1);
		myGroupID = info:GetGuildGroupID(0);
		targetGroupID = info:GetGuildGroupID(1);
	else
		myName = info:GetGuildName(1);
		targetName = info:GetGuildName(0);
		myGroupID = info:GetGuildGroupID(1);
		targetGroupID = info:GetGuildGroupID(0);
	end

	local txt_guildname_1 = frame:GetChild("txt_guildname_1");
	local txt_guildname_2 = frame:GetChild("txt_guildname_2");
	txt_guildname_1:SetTextByKey("value", myName);
	txt_guildname_2:SetTextByKey("value", targetName);

	local txt_guildserver_1 = frame:GetChild("txt_guildserver_1");
	local txt_guildserver_2 = frame:GetChild("txt_guildserver_2");
	txt_guildserver_1:SetTextByKey("value", "["..GetServerNameByGroupID(myGroupID).."]");
	txt_guildserver_2:SetTextByKey("value", "["..GetServerNameByGroupID(targetGroupID).."]");

	
	

end


function GUILDBATTLE_BATTLE_START_C(actor)

	local mgameInfo = session.mission.GetMGameInfo();
	local startTime = mgameInfo:GetUserValue("ToEndBattle_START");
	local maxTime = mgameInfo:GetUserValue("ToEndBattle");
	local elapsedTime = GetServerAppTime() - startTime;
	local remainTime = maxTime - elapsedTime;
	
	local frame = ui.GetFrame("guildbattle_score");
	local timer = GET_CHILD(frame, "timer");
	START_TIMER_CTRLSET_BY_SEC(timer, remainTime, maxTime);
	

end


