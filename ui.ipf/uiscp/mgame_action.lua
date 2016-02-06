--- mgame_action.lua --

function MGAME_MSG(actor, msgStr)
    addon.BroadMsg("NOTICE_Dm_!", msgStr, 3);
end

function DEFENCE_FAIL_MSG(arg)

	local failTeamID = tonumber(arg);
	local mgameInfo = session.mission.GetMGameInfo();
	local etcObj = GetMyEtcObject();
	local teamID = etcObj.Team_Mission;
	local currentRound = mgameInfo:GetUserValue( string.format("Round_%d",teamID) );

	if failTeamID == teamID then
		return ScpArgMsg("OurTeamFailedToDefendTheStatueAt{Round}Round", "Round", currentRound);
	else
		return ScpArgMsg("EnemyTeamFailedToDefendTheStatueAt{Round}Round", "Round", currentRound );
	end
	

end

function MGAME_SCRIPT_MSG(actor, funcStr, arg, time)
	local func = _G[funcStr];
	local msgStr = func(arg);
    addon.BroadMsg("NOTICE_Dm_!", msgStr, time);
end

function MGAME_EXEC_OPEN_UI(actor, addonName, isOpen)
	local frame = ui.GetFrame(addonName);
	frame:ShowWindow(isOpen);
end

function MGAME_EVT_SCRIPT_CLIENT(actor, scriptName)
	local func = _G[scriptName];
	func(actor);
end
   
function MGAME_MSG_ICON(actor, msgStr, icon,  sec)
    local msg_int = "NOTICE_Dm_"..icon
	addon.BroadMsg(msg_int, msgStr, sec);
end

--function MGAME_MSG_ICON(actor, obj, msgStr, icon,  sec, range)
--    
--    local list, cnt = SelectObjectByClassName(obj, range, 'PC')
--    local i
--    for i = 1, cnt do
--        
--        SendAddOnMsg(list[i], "NOTICE_Dm_"..icon, msgStr, sec);
--    end
--end

function MGAME_CAMERA_TO(actor, x, y, z, watchTime, moveTime, easing)
	camera.WatchPos(x, y, z, watchTime, moveTime, easing);
end

function MGAME_MAKE_GUIDE(actor, x, y, z, key)
	geQuestGuide.MakeGuide(key, x, y, z);
end

function MGAME_REMOVE_GUIDE(actor, key)
	geQuestGuide.RemoveGuide(key);
end

function MGAME_SHOCKWAVE(actor, intensity, time, freq, range)
	world.ShockWave(actor, 2, range, intensity, time, freq, 0);
end
