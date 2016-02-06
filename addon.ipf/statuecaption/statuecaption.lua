
-- statuscaption.lua


function StatueCaption_PVPStatue(handle, funcArg, familyName, pcName)

	local frame = ui.CreateNewFrame("statuecaption", "STATUE_CAPTION" .. handle);
	if frame == nil then
		return nil;
	end

	funcArg = tonumber(funcArg);
	local pvpType = math.floor(funcArg / 100);
	local ranking = math.mod(funcArg, 100);
	local title = GET_CHILD(frame, "title");
	if ranking == 1 then
		title:SetTextByKey("title", ScpArgMsg("TeamBattleLeagueChampion"));
	else
		title:SetTextByKey("title", ScpArgMsg("TeamBattleLeagueRank{Rank}", "Rank", ranking));
		
	end
	local nameText = string.format("%s (%s)", familyName, pcName);
	title:SetTextByKey("name", nameText);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, - frame:GetWidth() * 0.35, 20, 0, 1, 1);
	return 1.8 - ranking * 0.1;

end