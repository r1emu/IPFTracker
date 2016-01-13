
function GUILDEVENTPOPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("GUILD_PROPERTY_UPDATE", "ON_UPDATE_GUILDEVENT_POPUP");
	addon:RegisterMsg("GUILD_INFO_UPDATE", "ON_UPDATE_GUILDEVENT_POPUP");

end

function UPDATE_GUILD_EVENT_POPUP()

	local frame = ui.GetFrame("guildeventpopup");
	ON_UPDATE_GUILDEVENT_POPUP(frame);

end

function ON_UPDATE_GUILDEVENT_POPUP(frame)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());
	local guildInDunSelectInfo = partyObj.GuildInDunSelectInfo;
	local GuildBossSummonFlag = partyObj.GuildBossSummonFlag;
	local GuildRaidFlag = partyObj.GuildRaidFlag;
	
	if guildInDunSelectInfo == 0 and GuildBossSummonFlag == 0 and GuildRaidFlag == 0 then
		return;
	end

	local guildInDunLocInfo = nil

	local guildEventCls = nil
	
	if guildInDunSelectInfo ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", guildInDunSelectInfo);
		guildInDunLocInfo = partyObj.GuildInDunLocInfo;
	elseif GuildBossSummonFlag ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", GuildBossSummonFlag);
		guildInDunLocInfo = partyObj.GuildBossSummonLocInfo;
	elseif GuildRaidFlag ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", GuildRaidFlag);
		--guildInDunLocInfo = partyObj.GuildInDunLocInfo;
	end
	
	frame:SetUserValue("STARTWAITSEC", guildEventCls.StartWaitSec);

	
	local sysTime = geTime.GetServerSystemTime();
	local endTime = imcTime.GetSysTimeByStr(partyObj.GuildEventStartTime);
	local difSec = imcTime.GetDifSec(sysTime, endTime);
	if difSec >= guildEventCls.StartWaitSec then
		return;
	end

	frame:SetUserValue("ELAPSED_SEC", difSec);
	frame:SetUserValue("START_SEC", imcTime.GetAppTime());
		
	local sList = StringSplit(guildInDunLocInfo, ":");
	local mapID = sList[1];
	local genType = sList[2];
	local genListIndex = sList[3];
	local mapID = tonumber(sList[1]);
	local genType = tonumber(sList[2]);
	local genListIndex = tonumber(sList[3]);

	local mapCls = GetClassByType("Map", mapID);
	local mapprop = geMapTable.GetMapProp(mapCls.ClassName);
	local genTypeProp = mapprop:GetMongen(genType);
	local genList = genTypeProp.GenList;
	local posInfo;
	if genListIndex < genList:Count() then
		posInfo = genList:Element(genListIndex);
	end

	local isLeader = AM_I_LEADER(PARTY_GUILD);

	if isLeader == 1 then
		REQ_JOIN_GUILDEVENT(nil, nil)
		return;
	end

	frame:ShowWindow(1);

	local txt_goal = frame:GetChild("txt_goal");
	local goalTxt = ScpArgMsg("QuestDescBasicTxt");
	goalTxt = goalTxt .. " " .. guildEventCls.SummaryInfo;
	local mapLinktext = MAKE_LINK_MAP_TEXT(mapCls.ClassName, posInfo.x, posInfo.z);
	goalTxt = goalTxt .. "{nl}" .. ScpArgMsg("Location") .. " : " .. mapLinktext;
	txt_goal:SetTextByKey("value", goalTxt);
	
	frame:RunUpdateScript("GUILDEVENTPOPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)

	local btn_join = GET_CHILD(frame, "btn_join");
	local etcObj = GetMyEtcObject();
	if etcObj.GuildEventSeq == partyObj.GuildEventSeq then
		btn_join:ShowWindow(0);
	else
		btn_join:SetTextByKey("value", ScpArgMsg("Join"));
		btn_join:ShowWindow(1);
		
	end

end

function REQ_JOIN_GUILDEVENT(parent, ctrl)

	control.CustomCommand("GUILDEVENT_JOIN", 0);	

end

function GUILDEVENTPOPUP_UPDATE_STARTWAITSEC(frame)

	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local elapsedSec = frame:GetUserIValue("ELAPSED_SEC");
	local startSec = frame:GetUserIValue("START_SEC");
	local curSec = imcTime.GetAppTime() -  startSec + elapsedSec;
	local remainSec = startWaitSec - curSec;
	remainSec = math.floor(remainSec);
	if remainSec < 0 then
		frame:ShowWindow(0);
		return 0;
	end

	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(remainSec, startWaitSec);
	local txt_startwaittime = frame:GetChild("txt_startwaittime");	

	local remainMin = math.floor(remainSec / 60);
	local remainSec = remainSec % 60;
	local timeText = string.format("%d : %02d", remainMin, remainSec);
	txt_startwaittime:SetTextByKey("value", timeText);

	return 1;
end
