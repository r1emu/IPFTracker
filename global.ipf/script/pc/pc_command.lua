
function SCR_PC_CMD(pc, cmd, arg1, arg2, arg3, arg4)

	if cmd == "/cp" then
		PartyCreate(pc, arg1);
		return 1;
	elseif cmd == '/changePVPObserveTarget' then
		SCR_MCY_CHANGE_SELECT_OBSERVER(pc, arg1);
		return 1;
	elseif cmd == "/sendMasterEnter" then
		local partyObj = GetGuildObj(pc);
		if nil == partyObj then
			return 0;
		end
		local isLeader = IsPartyLeaderPc(partyObj, pc);
		if 1 ~= isLeader then
			return 0;
		end
		local partyID = GetGuildID(pc);
		local msg = ScpArgMsg("MasterStartGuildBattle");
		BroadcastToPartyMember(PARTY_GUILD, partyID, msg, "{@st55_a}");
		return 1;
	elseif cmd == "/retquest" then
        if IsJoinColonyWarMap(pc) == 1 then
            return 0;
        end
        
		if IsPVPServer(pc) == 1 then
			SendSysMsg(pc, "CantUseThisInIntegrateServer");
			return 0;
		end
		local isSit = IsRest(pc);
		if 1 == isSit then
			return 0;
		end

		local questIES = GetClassByType("QuestProgressCheck", arg1);
		if questIES == nil then
			return 0;
		end
		
		local mapName, x, y, z = GET_QUEST_RET_POS(pc, questIES)
		if mapName == nil then
			return 0;
		end
		
		MoveZone(pc, mapName, x, y, z, 'QuestEnd');
		return 1;
	elseif cmd == "/reqpartyquest" then
		if IsPVPServer(pc) == 1 then
			SendSysMsg(pc, "CantUseThisInIntegrateServer");
			return 0;
		end

		local fid = arg1;
		local questIES = GetClassByType("QuestProgressCheck", arg2);
		if questIES == nil then
			return 0;
		end

		local partyObj = GetPartyObj(pc);
		if partyObj == nil or arg3 == nil then
			return 0;
		end
		local memberObj = GetMemberObj(partyObj, arg3);
		if memberObj == nil then
			return 0;
		end

		-- arg3에서 npc 스테이트를 보내는게 아니라, 멤버의 이름을 보내서 멤버의 퀘스트 상태를 대신 체크할 수 있게 변경했습니다.
		if questIES.ClassID ~= memberObj.Shared_Quest then
			return 0;
		end
		local result = GET_PROGRESS_STRING_BY_VALUE(memberObj.Shared_Progress);
		if result ~= 'POSSIBLE' and result ~= 'SUCCESS' and result ~= 'PROGRESS' then
			return 0;
		end
		local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
		local mapName, x, y, z = GET_QUEST_RET_POS(pc, questIES, questnpc_state);
		if mapName == nil then
			return 0
		end
		MoveZone(pc, mapName, x, y, z, 'QuestEnd');
		return 1;
	elseif cmd == "/intewarp" then

		local nowposx,nowposy,nowposz = Get3DPos(pc);
		local etc = GetETCObject(pc);
		local mapname, x, y, z, uiname = GET_LAST_UI_OPEN_POS(etc)

		if mapname == nil then
			return 0;
		end

		if uiname ~= 'worldmap' or GET_2D_DIS(x,z,nowposx,nowposz) > 100 or GetZoneName(pc) ~= mapname then
			IMC_LOG("INFO_NORMAL","[warp fail log] uiname:"..uiname.." distance:" .. GET_2D_DIS(x,z,nowposx,nowposz) .. " pczone:"..GetZoneName(pc).." mapname:"..mapname);
			return 0;
		end

		local movezoneClassID = arg1;
		doPortal(pc,movezoneClassID, 0, arg2, "None");

		return 1;

	elseif cmd == "/intewarpByItem" then		

		if arg1 == nil or arg2 == nil or arg3 == nil then
			return;
		end

		local movezoneClassID = arg1;
		local warpToItemUsedPos = arg2;
		local itemname = arg3;

		local warpscrolllistcls = GetClass("warpscrolllist", itemname);
		if warpscrolllistcls == nil then
			return;
		end

        if IsJoinColonyWarMap(pc) == 1 then
            return;
        end
		
		doPortal(pc, movezoneClassID, 1, warpToItemUsedPos, itemname);
		return 1;

	elseif cmd == "/pethire" then
		SCR_ADOPT_COMPANION(pc, arg1, arg2);
		return 1;
	elseif cmd == "/petstat" then
		PET_STAT_UP_SERV(pc, arg1, arg2, arg3);
		return 1;
	elseif cmd == "/pmp" then	
		local partyObj = GetPartyObj(pc, arg1);
		local my = GetMemberObj(partyObj, GetTeamName(pc));
		local to = GetMemberObj(partyObj, arg2);
		
		if my == nil or to == nil then
			return 0;
		end		
		
		if IsPartyLeaderPc(partyObj, pc) == 0 then
			return 0;
		end
		
		if StrNSame(arg3, "Auth_", 5) == 0 then
			return 0;
		end
		
		ChangePartyMemberProp(pc, partyObj, arg2, arg3, arg4);
		return 1;
	elseif cmd == "/pmyp" then	
		local partyObj = GetPartyObj(pc, arg1);
		local my = GetMemberObj(partyObj, GetTeamName(pc));
		
		if my == nil then
			return 0;
		end		
		
		if arg3 ~= "Shared_Quest" and arg3 ~= "Before_Quest" and arg3 ~= "Before_Quest_State" and arg3 ~= "Shared_Progress" then
			return 0;
		end

		ChangePartyMemberProp(pc, partyObj, arg2, arg3, arg4);
		return 1;
	elseif cmd == "/readcollection" then
		
		local etc = GetETCObject(pc);
		local tempprop = 'CollectionRead_'..arg1

		if etc[tempprop] == 1  then
			return 0 
		end

		etc[tempprop] = 1;
		InvalidateEtc(pc, tempprop);

		SendAddOnMsg(pc, "UPDATE_READ_COLLECTION_COUNT");

		return 1;
		
	elseif cmd == "/lastuiopenpos" then

		local lastUIOpenFrameList = {}
		lastUIOpenFrameList["buffseller_target"] = 1
		lastUIOpenFrameList["camp_ui"] = 1
		lastUIOpenFrameList["cardbattle"] = 1
		lastUIOpenFrameList["foodtable_ui"] = 1
		lastUIOpenFrameList["itembuffrepair"] = 1
		lastUIOpenFrameList["itembuffgemroasting"] = 1
		lastUIOpenFrameList["itembuffopen"] = 1
		lastUIOpenFrameList["propertyshop"] = 1
        lastUIOpenFrameList['adventure_book'] = 1;

		if lastUIOpenFrameList[arg1] ~= 1 then
			return 0
		end

		local regret = REGISTERR_LASTUIOPEN_POS_SERVER(pc, arg1)

		if regret == 0 then
			return 0
		end
		
		return 1;
	
	elseif cmd == "/learnpcabil" then
		RunScript("SCR_TX_ABIL_REQUEST", pc, arg1, tonumber(arg2));
		return 1;

    elseif cmd == '/buyabilpoint' then
        if IsRunningScript(pc, 'SCR_TX_BUY_ABILITY_POINT') == 1 then
            return 0;
        end
        RunScript('SCR_TX_BUY_ABILITY_POINT', pc, tonumber(arg1));
        return 1;

	elseif cmd == "/guildexpup" then
		
		local currentCount = tonumber(arg2);
		local item, cnt = GetInvItemByGuid(pc, arg1);

		if item == nil or cnt == nil then
			SendSysMsg(pc, "REQUEST_TAKE_ITEM");
			return 0;
		end
		
		if currentCount > cnt then
			SendSysMsg(pc, "REQUEST_TAKE_ITEM");
			return 0;
		end

		RunScript("GUILD_EXP_UP", pc, arg1, currentCount);

		return 1;

	elseif cmd == "/learnguildabil" then
		
		LEARN_GUILD_ABILITY(pc, tonumber(arg1));

		return 1;

	elseif cmd == "/learnguildskl" then
		LEARN_GUILD_SKL(pc, arg1);

		return 1;

	elseif cmd == "/requpdateequip" then

		if pc == nil then
			return 0
		end

		FlushItemDurability(pc)

		return 1;

	elseif cmd == '/hairgacha' then    
        if IsPlayingPairAnimation(pc) == 0 then
		    RunScript('SCR_USE_GHACHA_TPCUBE', pc, arg1)
        end
		return 1;        
    elseif cmd == '/leticia_gacha' then        
		RunScript('EXECUTE_LETICIA_GACHA', pc, arg1);
		return 1;
        
    elseif cmd == '/ingameuiopen' then
    
        if pc == nil then
			return 0
		end

        if arg1 ~= nil then
            CustomMongoLog(pc, "IngamePurchase", "Type", "UIOpen", "Info", arg1)
        else
            CustomMongoLog(pc, "IngamePurchase", "Type", "UIOpen")
        end        

		return 1;

    elseif cmd == '/ingameuilog' then

        if pc == nil then
			return 0
		end

        if arg1 ~= nil then
            CustomMongoLog(pc, "IngamePurchase", "Type", "UILog", "Info", arg1)
        end

		return 1;

	elseif cmd == "/marketreport" then

		if pc == nil or arg1 == nil then
			return 0
		end
		
		ReportMarketItem(pc, arg1)

		return 1;

	elseif cmd == '/hmunclusSkl' then
		SCR_HOUMCLUS_SKL_ACQUIRE(pc, arg1);

		return 1;
    elseif cmd == '/upgradeFishingItemBag' then
        if true then
            return; -- 일단 막아달라고 하심
        end

        if IsRunningScript(pc, 'TX_UPGRADE_FISHING_ITEM_BAG') == 0 then
		    RunScript('TX_UPGRADE_FISHING_ITEM_BAG', pc)
        end
		return 1;
	elseif cmd == '/BounsCount' then
		local aObj = GetAccountObj(pc);
		local count, bouns, cubetype, next_count, next_bouns, rewardlist, rewardtext = SCR_GACHA_BOUNS_VALUE(nil, pc)
		local cube_name = 'Leticia Secret Cube'
		if cubetype == 2 then
			cube_name = 'Goddess Blessed Cube'
		end
		SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('GACHA_BOUNS_SEL2', "CUBE", cube_name, "SUM", count, "COUNT", next_count, "BOUNS", next_bouns), 10)
		return 1;
	end

	if string.find(cmd, "sage") ~= nil then
		SCR_PC_SKL_SAGE_COMMAND(pc, cmd, arg1);

		return 1;
	end

	return 0;

end