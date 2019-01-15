local json = require "json_imc"

function GUILDINFO_INFO_INIT(parent, infoBox)
    local guildObj = GET_MY_GUILD_OBJECT();
    GUILDINFO_INFO_INIT_EXP(infoBox, guildObj);
    GUILDINFO_INFO_INIT_TOWER(infoBox, guildObj);
    GUILDINFO_INFO_INIT_BENEFIT(infoBox, guildObj);
    GUILDINFO_INFO_INIT_ABILITY(infoBox, guildObj);
    ui.CloseFrame('guild_authority_popup');
end

function SET_INTRO_TXT()
    local frame = ui.GetFrame("guildinfo")
    local introduceText = GET_CHILD_RECURSIVELY(frame, 'regPromoteText');
    SetGuildProfile("RECV_INTRO_TXT", introduceText:GetText())
end

function RECV_INTRO_TXT(code, ret_json)
    if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "RECV_INTRO_TXT");
        return;
    end
    ui.SysMsg(ClMsg("GuildIntroUpdated"))
end

function GUILDINFO_INFO_INIT_EXP(infoBox, guildObj)
    -- level and exp guage
    local levelText = GET_CHILD_RECURSIVELY(infoBox, 'levelText');
    local guildLevel = guildObj.Level;
    levelText:SetTextByKey('level', guildLevel);

    local exp = guildObj.Exp;
    local curLevelCls = GetClass("GuildExp", guildLevel);
    local nextLevelCls = GetClass("GuildExp", guildLevel + 1);
    local curExp = exp - curLevelCls.Exp;
    local expGuage = GET_CHILD_RECURSIVELY(infoBox, 'expGuage');
    if nextLevelCls ~= nil then
        expGuage:SetPoint(curExp, nextLevelCls.Exp - curLevelCls.Exp);
    else -- max level
        expGuage:SetPoint(1000, 1000);
    end
end

function GUILDINFO_INFO_INIT_TOWER(infoBox, guildObj)
    local towerInfoText = GET_CHILD_RECURSIVELY(infoBox, 'towerInfoText');
    local towerMapText = GET_CHILD_RECURSIVELY(infoBox, 'towerMapText');
    local towerTimeText = GET_CHILD_RECURSIVELY(infoBox, 'towerTimeText');
    local towerPosition = guildObj.HousePosition;
    if towerPosition == 'None' then
        towerInfoText:SetTextByKey('current', 0);
        towerMapText:ShowWindow(0);
        towerTimeText:ShowWindow(0);
    else
        towerInfoText:SetTextByKey('current', 1);
        local towerInfo = StringSplit(towerPosition, "#");
		if #towerInfo == 3 then -- destroy by other guild
            local destroyPartyName = towerInfo[2];
			local destroyedTime = towerInfo[3];			
			if destroyPartyName == "None" then
				destroyPartyName = ScpArgMsg("Enemy");
			end

			local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
			towerMapText:SetTextByKey("map", positionText);

			local timeText = ScpArgMsg("ToRebuildableTime") .. " " ;
			towerTimeText:SetUserValue("PARTYNAME", destroyPartyName);	
			towerTimeText:SetUserValue("DESTROYTIME", destroyedTime);
			towerTimeText:RunUpdateScript("UPDATE_TOWER_DESTROY_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_DESTROY_TIME(towerTimeText);
        else
            local mapID = towerInfo[1];
			local towerID = towerInfo[2];
			local x = towerInfo[3];
			local y = towerInfo[4];
			local z = towerInfo[5];
			local builtTime = towerInfo[6];
			local mapCls = GetClassByType("Map", mapID);
			towerMapText:SetTextByKey('map', MAKE_LINK_MAP_TEXT(mapCls.ClassName, x, z));
			towerTimeText:SetUserValue("BUILTTIME", builtTime);
			towerTimeText:RunUpdateScript("UPDATE_TOWER_REMAIN_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_REMAIN_TIME(towerTimeText);
        end
    end
end

function UPDATE_TOWER_REMAIN_TIME(towerTimeText)
	local builtTime = towerTimeText:GetUserValue("BUILTTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_LIFE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	local difSecString = GET_TIME_TXT_DHM(difSec);
	towerTimeText:SetTextByKey("time", difSecString);
	return 1;
end

function GUILDINFO_INFO_INIT_BENEFIT(infoBox, guildObj)
    local benefitBox = GET_CHILD_RECURSIVELY(infoBox, 'benefitbox');    
    DESTROY_CHILD_BYNAME(benefitBox, 'BENEFIT_');
   
    local yPos = 40;
    local currentLevel = guildObj.Level;    
    
    local function _SET_INFO_CTRLSET(benefitBox, name, yPos, currentLevel, level, infoStr, imgConfigName)
        local towerCtrlSet = benefitBox:CreateOrGetControlSet('guild_benefit', name, 0, yPos);
        towerCtrlSet = AUTO_CAST(towerCtrlSet);
        local DISABLE_COLOR = towerCtrlSet:GetUserConfig('DISABLE_COLOR');
        towerCtrlSet = AUTO_CAST(towerCtrlSet);
        towerCtrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP)
        local IMG_NAME = towerCtrlSet:GetUserConfig(imgConfigName);    
        local infoPic = GET_CHILD(towerCtrlSet, 'infoPic');
        local infoText = towerCtrlSet:GetChild('infoText');
        local infoStr = string.format('%s %s %d: %s', ClMsg('ChatType_4'), ClMsg('Level'), level, infoStr);
        infoPic:SetImage(IMG_NAME);
        infoText:SetText(infoStr);
        if currentLevel < level then        
            towerCtrlSet:SetColorTone(DISABLE_COLOR);
        end
        yPos = yPos + towerCtrlSet:GetHeight();
        return yPos;
    end
    
    yPos = _SET_INFO_CTRLSET(benefitBox, 'BENEFIT_WARP', yPos, currentLevel, 1, ClMsg('Warp'), 'WARP_IMG');
    yPos = _SET_INFO_CTRLSET(benefitBox, 'BENEFIT_WAREHOUSE', yPos, currentLevel, 1, ClMsg('WareHouse'), 'WAREHOUSE_IMG');
    yPos = _SET_INFO_CTRLSET(benefitBox, 'BENEFIT_GROWTH', yPos, currentLevel, 1, ClMsg('GuildGrowth'), 'GROWTH_IMG');
    yPos = _SET_INFO_CTRLSET(benefitBox, 'BENEFIT_AGIT', yPos, currentLevel, 2, ClMsg('MoveToAgit'), 'AGIT_IMG');
    yPos = _SET_INFO_CTRLSET(benefitBox, 'BENEFIT_EVENT', yPos, currentLevel, 4, ClMsg('GuildEvent'), 'EVENT_IMG');
end

function GUILDINFO_INFO_INIT_ABILITY(infoBox, guildObj)
    local pointText = GET_CHILD_RECURSIVELY(infoBox, 'pointText');
    local currentPoint = GET_GUILD_ABILITY_POINT(guildObj);
    pointText:SetTextByKey('point', currentPoint);

    local yPos = 40;
    local abilityBox = GET_CHILD_RECURSIVELY(infoBox, 'abilityBox');
    local clsList, cnt = GetClassList("Guild_Ability");
    for i = 0, cnt - 1 do
        local abilityCls = GetClassByIndexFromList(clsList, i);
        local ctrlSet = abilityBox:CreateOrGetControlSet('guild_benefit', 'ABILITY_'..abilityCls.ClassName, 0, yPos);
        ctrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP)
        ctrlSet = AUTO_CAST(ctrlSet);

        local DISABLE_COLOR = ctrlSet:GetUserConfig('DISABLE_COLOR');
        local infoPic = GET_CHILD(ctrlSet, 'infoPic');
        local infoText = ctrlSet:GetChild('infoText');
        local abilLevel = guildObj["AbilLevel_" .. abilityCls.ClassName];
        local infoStr = string.format('Lv. %d %s: %s', abilLevel, abilityCls.Name, abilityCls.Desc);
        infoPic:SetImage(abilityCls.Icon);
        infoText:SetText(infoStr);
        
        if abilLevel < 1 then
            ctrlSet:SetColorTone(DISABLE_COLOR);
        end
        yPos = yPos + ctrlSet:GetHeight();
    end
end

function UPDATE_TOWER_DESTROY_TIME(towerTimeText)
	local builtTime = towerTimeText:GetUserValue("DESTROYTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_DESTROY_REBUILD_ABLE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	if difSec > 0 then
		local difSecString = GET_TIME_TXT_DHM(difSec);
		towerTimeText:SetTextByKey("remaintime", difSecString);
	else
		local destroyPartyName = towerTimeText:GetUserValue("PARTYNAME");
		local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
		towerTimeText:SetTextByKey("time", positionText);
		return 0;
	end
	return 1;
end

function GUILDINFO_INFO_UPDATE_WAREHOUSE(frame, ctrl)
	party.RequestReloadInventory(PARTY_GUILD);
	DISABLE_BUTTON_DOUBLECLICK("guildinfo", ctrl:GetName(), 0.1);
end

function IS_EXIST_JOB_IN_HISTORY(jobID)
    local mySession = session.GetMySession();
    local jobHistory = mySession.pcJobInfo;
    local jobHistoryCnt = jobHistory:GetJobCount();
    for i = 0, jobHistoryCnt - 1 do
		local jobInfo = jobHistory:GetJobInfoByIndex(i);
        if jobID == jobInfo.jobID then
            return true;
        end
    end
    return false;
end


function save_guild_notice_call_back(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "save_guild_notice_call_back")
        return
    end

    ui.SysMsg(ClMsg("UpdateSuccess"))
    -- 여기에서 해당 ui에 글자 채워주기
end

function SAVE_GUILD_NOTICE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local noticeEdit = GET_CHILD_RECURSIVELY(frame, 'noticeEdit')
	local noticeText = noticeEdit:GetText();
	local guild = GET_MY_GUILD_INFO();
	local nowNotice = guild.info:GetNotice();
	local badword = IsBadString(noticeText);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
	if nowNotice ~= noticeText then		
        SetGuildNotice('save_guild_notice_call_back', noticeText)
	end
	noticeEdit:ReleaseFocus();
end

function IS_EXIST_GUILD_TOWER()
    local guildObj = GET_MY_GUILD_OBJECT();    
    if guildObj == nil then
        return false;
    end

    local towerPosition = guildObj.HousePosition;
    local sList = StringSplit(towerPosition, '#');
    if #sList ~= 6 then
        return false;
    end
    return true;
end