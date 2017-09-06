function GUILDINFO_INIT_MEMBER_TAB(frame, msg)
    local memberBox = GET_CHILD_RECURSIVELY(frame, 'memberBox');    
    if memberBox:IsVisible() == 0 then
        return;
    end

    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end

    local memberCtrlBox = GET_CHILD_RECURSIVELY(memberBox, 'memberCtrlBox');
    DESTROY_CHILD_BYNAME(memberCtrlBox, 'MEMBER_');

    local leaderAID = guild.info:GetLeaderAID();

    local onlineCnt = 0;
    local MEMBER_TEXT_LIMIT_BYTE = tonumber(frame:GetUserConfig('MEMBER_TEXT_LIMIT_BYTE'));    
    local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);        
        local aid = partyMemberInfo:GetAID();
        local memberCtrlSet = memberCtrlBox:CreateOrGetControlSet('guild_memberinfo', 'MEMBER_'..aid, 0, 0);
        memberCtrlSet = AUTO_CAST(memberCtrlSet);
        memberCtrlSet:SetUserValue('AID', aid);

        local isOnline = true;
        local pic_online = GET_CHILD(memberCtrlSet, 'pic_online');
        local txt_location = memberCtrlSet:GetChild('txt_location');
        local ONLINE_IMG = memberCtrlSet:GetUserConfig('ONLINE_IMG');
        local OFFLINE_IMG = memberCtrlSet:GetUserConfig('OFFLINE_IMG');
        local MY_CHAR_BG_SKIN = memberCtrlSet:GetUserConfig('MY_CHAR_BG_SKIN');

        -- bg
        if aid == session.loginInfo.GetAID() then
            local bg = memberCtrlSet:GetChild('bg');
            bg:SetSkinName(MY_CHAR_BG_SKIN);
        end

        -- on/off & location
        local locationText = "";
        if partyMemberInfo:GetMapID() > 0 then
			local mapCls = GetClassByType("Map", partyMemberInfo:GetMapID());
			if mapCls ~= nil then
                pic_online:SetImage(ONLINE_IMG);
                locationText = string.format("[%s%d] %s", ScpArgMsg("Channel"), partyMemberInfo:GetChannel() + 1, mapCls.Name);
                onlineCnt = onlineCnt + 1;
                memberCtrlSet:SetUserValue('IS_ONLINE', 'YES');
            end
        else
            isOnline = false;
            pic_online:SetImage(OFFLINE_IMG);
            local logoutSec = partyMemberInfo:GetLogoutSec();
			if logoutSec >= 0 then
				locationText = GET_DIFF_TIME_TXT(logoutSec);
			else				
				locationText = ScpArgMsg("Logout");
			end
            memberCtrlSet:SetUserValue('IS_ONLINE', 'NO');
        end
        txt_location:SetTextByKey("value", locationText);
        txt_location:SetTextTooltip(locationText);

        -- name
        local txt_teamname = memberCtrlSet:GetChild('txt_teamname');
        local name = partyMemberInfo:GetName();
        txt_teamname:SetTextByKey('value', partyMemberInfo:GetName());
        txt_teamname:SetTextTooltip(partyMemberInfo:GetName());
        txt_teamname:SetVisibleByte(MEMBER_TEXT_LIMIT_BYTE);

        -- job
        local jobID = partyMemberInfo:GetIconInfo().job;
        local jobCls = GetClassByType('Job', jobID);
        local jobName = TryGetProp(jobCls, 'Name');        
        if jobName ~= nil then
            local jobText = memberCtrlSet:GetChild('jobText')
            jobText:SetTextByKey('job', jobName);
        end
        
        -- level
        if isOnline == true then
            local levelText = memberCtrlSet:GetChild('levelText');
            levelText:SetTextByKey('level', partyMemberInfo:GetLevel());
        end

        -- duty
        local txt_duty = memberCtrlSet:GetChild('txt_duty');
        txt_duty:SetVisibleByte(MEMBER_TEXT_LIMIT_BYTE);
        local grade = partyMemberInfo.grade;        
		if leaderAID == partyMemberInfo:GetAID() then
			local dutyName = "{ol}{#FFFF00}" .. ScpArgMsg("GuildMaster") .. "{/}{/}";
			dutyName = dutyName .. " " .. guild:GetDutyName(grade);
			txt_duty:SetTextByKey("value", dutyName);
		else
			local dutyName = guild:GetDutyName(grade);
			txt_duty:SetTextByKey("value", dutyName);
		end

        -- contribution
        local memberObj = GetIES(partyMemberInfo:GetObject());
        local contributionText = memberCtrlSet:GetChild('contributionText');
        contributionText:SetTextByKey('contribution', memberObj.Contribution);

        SET_EVENT_SCRIPT_RECURSIVELY(memberCtrlSet, ui.RBUTTONDOWN, "POPUP_GUILD_MEMBER");
    end
    GUILDINFO_MEMBER_ONLINE_CLICK(frame);
    memberCtrlBox:SetEventScript(ui.SCROLL, 'SET_AUTHO_MEMBERS_SCROLL');

    -- on/off
    local memberCountText = GET_CHILD_RECURSIVELY(memberBox, 'memberCountText');
    memberCountText:SetTextByKey('online', onlineCnt);
    memberCountText:SetTextByKey('offline', count - onlineCnt);

    memberBox:ShowWindow(1);

    GUILDINFO_MEMBER_LEADER_ON_TOP(frame, leaderAID);

    local inviteBtn = GET_CHILD_RECURSIVELY(frame, 'inviteBtn');
    if IS_GUILD_AUTHORITY(1, session.loginInfo.GetAID()) == 1 or AM_I_LEADER(PARTY_GUILD) == 1 then
        inviteBtn:SetEnable(1);
    else
        inviteBtn:SetEnable(0);
    end
end

function GUILDINFO_MEMBER_LEADER_ON_TOP(frame, leaderAID)
    local memberCtrlBox = GET_CHILD_RECURSIVELY(frame, 'memberCtrlBox');
    local memberBoxChildCount = memberCtrlBox:GetChildCount();
    local firstMember = nil;
    for i = 0, memberBoxChildCount - 1 do
        local child = memberCtrlBox:GetChildByIndex(i);        
        if string.find(child:GetName(), 'MEMBER_') ~= nil then
            firstMember = child;
            break;
        end
    end

    local leader = GET_CHILD_RECURSIVELY(frame, 'MEMBER_'..leaderAID);
    if leader ~= nil then
        local leaderOffsetY = leader:GetY();
        leader:SetOffset(leader:GetX(), firstMember:GetY());
        firstMember:SetOffset(firstMember:GetX(), leaderOffsetY);
    end
end

function GUILDINFO_MEMBER_ONLINE_CLICK(parent, checkBox)
    local topFrame = parent:GetTopParentFrame();
    local memberCtrlBox = GET_CHILD_RECURSIVELY(topFrame, 'memberCtrlBox');
    if checkBox == nil then
        checkBox = GET_CHILD_RECURSIVELY(topFrame, 'memberFilterCheck');
    end

    local childCount = memberCtrlBox:GetChildCount();
    local showOnlyOnline = checkBox:IsChecked();
    for i = 0, childCount - 1 do
        local child = memberCtrlBox:GetChildByIndex(i);
        if string.find(child:GetName(), 'MEMBER_') ~= nil then
            if showOnlyOnline == 1 and child:GetUserValue('IS_ONLINE') == 'NO' then
                child:ShowWindow(0);
            else
                child:ShowWindow(1);
            end
        end
    end
    GBOX_AUTO_ALIGN(memberCtrlBox, 0, 0, 0, true, false, true);
end

function POPUP_GUILD_MEMBER(parent, ctrl)
	local aid = parent:GetUserValue("AID");
	if aid == "None" then
		aid = ctrl:GetUserValue("AID");
	end
	
	local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, aid);
	local isLeader = AM_I_LEADER(PARTY_GUILD);
	local myAid = session.loginInfo.GetAID();

	local name = memberInfo:GetName();

	local contextMenuCtrlName = string.format("{@st41}%s{/}", name);
	local context = ui.CreateContextMenu("PC_CONTEXT_MENU", name, 0, 0, 170, 100);
	
	if isLeader == 1 and aid ~= myAid then
		ui.AddContextMenuItem(context, ScpArgMsg("ChangeDuty"), string.format("GUILD_CHANGE_DUTY('%s')", name));
	end

	if (isLeader == 1 or IS_GUILD_AUTHORITY(2) == 1) and aid ~= myAid then
		ui.AddContextMenuItem(context, ScpArgMsg("Ban"), string.format("GUILD_BAN('%s')", aid));
	end

	
	if isLeader == 1 and aid ~= myAid then
		local mapName = session.GetMapName();
		if mapName == 'guild_agit_1' then
			ui.AddContextMenuItem(context, ScpArgMsg("GiveGuildLeaderPermission"), string.format("SEND_REQ_GUILD_MASTER('%s')", name));
		end
	end

	if isLeader == 1 then

		local list = session.party.GetPartyMemberList(PARTY_GUILD);
		if list:Count() == 1 then
			ui.AddContextMenuItem(context, ScpArgMsg("Disband"), "ui.Chat('/destroyguild')");
		end
	else
		if aid == myAid then
			ui.AddContextMenuItem(context, ScpArgMsg("GULID_OUT"), "OUT_GUILD()");
		end
	end

	ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", name));
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function GUILDINFO_MEMBER_INVITE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameForGuildInvite"), "GUILDINFO_INVITE_GUILD", "", nil, nil, 20);
end

function GUILDINFO_INVITE_GUILD(frame, teamName)
    if teamName == nil or teamName == '' then
        return;
    end
    ui.Chat('/guild '..teamName);
end

function GUILDINFO_MEMBER_SORT_NAME(parent, ctrl)    
    local topFrame = parent:GetTopParentFrame();
    local sortFuncNameTail = GUILDINFO_MEMBER_SET_SORT_IMG(topFrame, ctrl);

    -- sort
    local sortFunc = _G['SORT_GUILDINFO_MEMBER_NAME'..sortFuncNameTail];
    local memberCtrlBox = GET_CHILD_RECURSIVELY(topFrame, 'memberCtrlBox');
    local childNameTable = GET_MEMBER_CTRLSET_NAME_TABLE(memberCtrlBox);
    table.sort(childNameTable, sortFunc);

    -- realign 
    GUILDINFO_MEMBER_REALIGN(topFrame, memberCtrlBox, childNameTable);
end

function GUILDINFO_MEMBER_REALIGN(topFrame, memberCtrlBox, childNameTable)
    local isShowOnlyOnline = IS_SHOW_ONLY_ONLINE_GUILD_MEMBER(topFrame);    
    local yPos = 0;
    for i = 1, #childNameTable do
        local child = memberCtrlBox:GetChild(childNameTable[i]);
        if isShowOnlyOnline == 0 or child:IsVisible() == 1 then
            child:SetOffset(child:GetX(), yPos);
            yPos = yPos + child:GetHeight();
        end
    end    
    ui.CloseFrame('guild_authority_popup');
end

function GUILDINFO_MEMBER_SET_SORT_IMG(topFrame, selectedSortCtrl)
    local MEMBER_SORT_IMG_ON = topFrame:GetUserConfig('MEMBER_SORT_IMG_ON');
    local MEMBER_SORT_IMG_OFF = topFrame:GetUserConfig('MEMBER_SORT_IMG_OFF');
    local prevSort = topFrame:GetUserValue('MEMBER_SORT_CRITERIA');    
    if prevSort ~= 'None' then
        local prevChild = GET_CHILD_RECURSIVELY(topFrame, prevSort);
        prevChild:SetTextByKey('arrow', MEMBER_SORT_IMG_OFF);
    end

    if prevSort == selectedSortCtrl:GetName() then
        topFrame:SetUserValue('MEMBER_SORT_CRITERIA', 'None');
        return '_REVERSE';
    end
    topFrame:SetUserValue('MEMBER_SORT_CRITERIA', selectedSortCtrl:GetName());    
    selectedSortCtrl:SetTextByKey('arrow', MEMBER_SORT_IMG_ON);
    return '';
end

function IS_SHOW_ONLY_ONLINE_GUILD_MEMBER(frame)
    local memberFilterCheck = GET_CHILD_RECURSIVELY(frame, 'memberFilterCheck');
    return memberFilterCheck:IsChecked();
end

function GET_MEMBER_CTRLSET_NAME_TABLE(memberCtrlBox)
    local table = {};
    local childCount = memberCtrlBox:GetChildCount();
    for i = 0, childCount - 1 do
        local child = memberCtrlBox:GetChildByIndex(i);
        local name = child:GetName();
        if string.find(name, 'MEMBER_') ~= nil then
            table[#table + 1] = child:GetName();
        end
    end
    return table;
end

function SORT_GUILDINFO_MEMBER_NAME(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('txt_teamname');
    local bNameCtrl = bChild:GetChild('txt_teamname');
    
    return aNameCtrl:GetTextByKey('value') < bNameCtrl:GetTextByKey('value');
end

function SORT_GUILDINFO_MEMBER_NAME_REVERSE(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('txt_teamname');
    local bNameCtrl = bChild:GetChild('txt_teamname');
    
    return aNameCtrl:GetTextByKey('value') > bNameCtrl:GetTextByKey('value');
end

function GUILDINFO_MEMBER_SORT_LEVEL(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local sortFuncNameTail = GUILDINFO_MEMBER_SET_SORT_IMG(topFrame, ctrl);

    -- sort
    local sortFunc = _G['SORT_GUILDINFO_MEMBER_LEVEL'..sortFuncNameTail];
    local memberCtrlBox = GET_CHILD_RECURSIVELY(topFrame, 'memberCtrlBox');
    local childNameTable = GET_MEMBER_CTRLSET_NAME_TABLE(memberCtrlBox);
    table.sort(childNameTable, sortFunc);

    GUILDINFO_MEMBER_REALIGN(topFrame, memberCtrlBox, childNameTable);
end

function SORT_GUILDINFO_MEMBER_LEVEL(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('levelText');
    local bNameCtrl = bChild:GetChild('levelText');
    
    return aNameCtrl:GetTextByKey('level') < bNameCtrl:GetTextByKey('level');
end

function SORT_GUILDINFO_MEMBER_LEVEL_REVERSE(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('levelText');
    local bNameCtrl = bChild:GetChild('levelText');
    
    return aNameCtrl:GetTextByKey('level') > bNameCtrl:GetTextByKey('level');
end

function GUILDINFO_MEMBER_SORT_DUTY(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local sortFuncNameTail = GUILDINFO_MEMBER_SET_SORT_IMG(topFrame, ctrl);

    -- sort
    local sortFunc = _G['SORT_GUILDINFO_MEMBER_DUTY'..sortFuncNameTail];
    local memberCtrlBox = GET_CHILD_RECURSIVELY(topFrame, 'memberCtrlBox');
    local childNameTable = GET_MEMBER_CTRLSET_NAME_TABLE(memberCtrlBox);
    table.sort(childNameTable, sortFunc);

    GUILDINFO_MEMBER_REALIGN(topFrame, memberCtrlBox, childNameTable);
end

function SORT_GUILDINFO_MEMBER_DUTY(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('txt_duty');
    local bNameCtrl = bChild:GetChild('txt_duty');
    
    return aNameCtrl:GetTextByKey('value') < bNameCtrl:GetTextByKey('value');
end

function SORT_GUILDINFO_MEMBER_DUTY_REVERSE(a, b)
    local guildinfo = ui.GetFrame('guildinfo');
    local aChild = GET_CHILD_RECURSIVELY(guildinfo, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinfo, b);
    local aNameCtrl = aChild:GetChild('txt_duty');
    local bNameCtrl = bChild:GetChild('txt_duty');
    
    return aNameCtrl:GetTextByKey('value') > bNameCtrl:GetTextByKey('value');
end

function SEND_REQ_GUILD_MASTER(name)
    local yesscp = string.format("_SEND_REQ_GUILD_MASTER('%s')", name);
    ui.MsgBox(ClMsg('YouMustUpdateTowerLevel'), yesscp, 'None');
end

function _SEND_REQ_GUILD_MASTER(name)
	ui.Chat("/guildleader " .. name);
end

function OUT_GUILD()
	ui.Chat("/outguild");
    ui.CloseFrame('guildinfo');
end

function GUILD_CHANGE_DUTY(name)
	local memberInfo = session.party.GetPartyMemberInfoByName(PARTY_GUILD, name);
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	local grade = memberInfo.grade;
	local dutyName = pcparty:GetDutyName(grade);

	local inputFrame = INPUT_STRING_BOX("", "EXEC_GUILD_CHANGE_DUTY", dutyName, nil, 64);
	inputFrame:SetUserValue("InputType", "InputNameForChange");
	inputFrame:SetUserValue("NAME", name);	
end

function EXEC_GUILD_CHANGE_DUTY(frame, ctrl)
	if ctrl:GetName() == "inputstr" then
		frame = ctrl;
	end

	local duty = GET_INPUT_STRING_TXT(frame);
	local name = frame:GetUserValue("NAME");
	local memberInfo = session.party.GetPartyMemberInfoByName(PARTY_GUILD, name);		
	party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_DUTY, duty, memberInfo:GetAID());
	frame:ShowWindow(0);
end

function GUILD_BAN(name)
	ui.Chat("/partybanByAID " .. PARTY_GUILD.. " " .. name);	
end