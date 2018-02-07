-- Event Special Blue orb
function SCR_PRECHECK_CONSUME_EMISSION(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local hour = now_time['hour']
    local min = now_time['min']
    local ymin = (yday * 24 * 60) + hour * 60 + min
    local aObj = GetAccountObj(self)

    if mapCls.ClassName == 'c_firemage_event' and aObj.EVENT_VALUE_AOBJ03 < ymin then
        return 1;
    end
    
    return 0;
end

function SCR_PRECHECK_CONSUME_EMISSION2(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);

    if mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 and IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
        return 1;
    end
    
    return 0;
end

function SCR_USE_SPECIAL_BLUEORB(pc)
    local moncls_info = {
        {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
        {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
        {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
    }
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local hour = now_time['hour']
    local min = now_time['min']
    local ymin = (yday * 24 * 60) + hour * 60 + min
    local aObj = GetAccountObj(pc)
    
    if aObj.EVENT_VALUE_AOBJ03 > ymin then
        return;
    end
    
    local createMon = ''
    for i = 1, table.getn(moncls_info) do
        if aObj[moncls_info[i][1]] ~= 'None' then
            local iesObj = CreateGCIES('Monster', aObj[moncls_info[i][1]]);
        	if iesObj ~= nil then
        	    iesObj.Lv = aObj[moncls_info[i][2]] + 1
        	    iesObj.Faction = 'Summon';
        		local x, y, z = GetPos(pc);
        		
        		local mon = CreateMonster(pc, iesObj, x, y, z, 0, 10);
        
        		SetOwner(iesObj, pc, 0);
        		SetHookMsgOwner(iesObj, pc);
        		SetLifeTime(mon, 600);
                ChangeScale(mon, 0.8, 0);
        		RunSimpleAI(iesObj, 'alche_summon');

                if mon ~= nil then
                    local tx = TxBegin(pc)
                    TxSetIESProp(tx, aObj, 'EVENT_VALUE_AOBJ03', ymin);
                    local ret = TxCommit(tx)
                    if createMon == '' then
                        createMon = mon.ClassName..':'..aObj[moncls_info[i][2]] + 1
                    else
                        createMon = createMon..'/'..mon.ClassName..':'..aObj[moncls_info[i][2]] + 1
                    end
                end
        	end
    	end
	end
	if createMon ~= '' then
    	CustomMongoLog(pc, "EVENT_BLUEORB_USEORB", "MonList", createMon)
    end
end

function SCR_USE_SPECIAL_TRAP(pc)
    local x, y, z = GetPos(pc)
    --CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog)
    local STrap = CREATE_NPC(pc, "pilgrim_trap_01", x, y, z, 0, "Summon", GetLayer(pc), pc.Name, nil, nil, 60, 1, nil, "SPECIAL_TRAP");
    SetLifeTime(STrap, 60);
	SetOwner(STrap, pc, 0);
end

function SCR_SPECIAL_TRAP_TS_BORN_ENTER(self)
end
function SCR_SPECIAL_TRAP_TS_BORN_UPDATE(self)
    local owner = GetOwner(self)
    if owner ~= nil then
    	local objList, objCount = SelectObjectNear(GetOwner(self), self, 15, "ENEMY");
    	if objCount > 0 then
        	for i = 1, objCount do
        		local obj = objList[i];
        
        		if obj.ClassName == 'PC' or GetOwner(obj) ~= nil then
        
        		elseif obj.ClassName ~= 'pilgrim_trap_01' and obj ~= nil and obj.MonRank == 'Normal' then
                    local HPper = GetHpPercent(obj)
                    local succ = 100 - math.floor(HPper * 100)
                    local owner = GetOwner(self)
                    
                    if IMCRandom(1, 100) <= succ then
                        RunScript("SCR_MONCLS_SAVE", self, owner, obj)
                    else
                        SendAddOnMsg(owner, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG6'), 5)
                        Kill(self)
                    end
        		end
        	end
        end
    end
end
function SCR_SPECIAL_TRAP_TS_BORN_LEAVE(self)
end
function SCR_SPECIAL_TRAP_TS_DEAD_ENTER(self)
end
function SCR_SPECIAL_TRAP_TS_DEAD_UPDATE(self)
end
function SCR_SPECIAL_TRAP_TS_DEAD_LEAVE(self)
end

function SCR_MONCLS_SAVE(self, owner, obj)
    local moncls_name = {
        'EVENT_MYMON01', 'EVENT_MYMON02', 'EVENT_MYMON03'
    }
    
    local aObj = GetAccountObj(owner)
    local overlap = 0

    for j = 1, table.getn(moncls_name) do
        if aObj[moncls_name[j]] == obj.ClassName then
            overlap = 1;
            break;
        end
    end

    if overlap ~= 0 then
        return;
    end

    for i = 1, table.getn(moncls_name) do
        if aObj[moncls_name[i]] == 'None' then
          local tx = TxBegin(owner)
          TxSetIESProp(tx, aObj, moncls_name[i], obj.ClassName);
          local ret = TxCommit(tx)

          if ret == "SUCCESS" then
            SendAddOnMsg(owner, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG5'), 5)
            PlayEffect(self, "F_buff_basic025_white_line", 1)
            Kill(obj)
            Kill(self)
            CustomMongoLog(owner, "EVENT_BLUEORB_TRAPPING","MonClassName", obj.ClassName,"Index", moncls_name[i])
          end
          break;
        end
    end
end

-- buff
function SCR_BUFF_ENTER_Event_Penalty_3(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Event_Penalty_3(self, buff, arg1, arg2, over)
end

-- indun enter
function INIT_PCDEBUFF_EVENT_STAT(pc)
    if pc.ClassName == 'PC' then
      if IsDummyPC(pc) == 1 then
        return;
      end
      
      AddBuff(pc, pc, "Event_Penalty_3")
    elseif pc.ClassName == 'magicsquare_1_mini' then
    
    else
        local petlist = {
          'Velhider',
          'pet_dog',
          'hoglan_Pet',
          'pet_hawk',
          'Piggy',
          'Lesser_panda',
          'Toucan',
          'Guineapig',
          'barn_owl',
          'Piggy_baby',
          'Lesser_panda_baby',
          'guineapig_baby',
          'penguin',
          'parrotbill',
          'parrotbill_dummy',
          'Pet_Rocksodon',
          'penguin_green',
          'PetHanaming',
          'penguin_marine',
          'guineapig_white',
          'Lesser_panda_gray',
          'Zombie_Overwatcher',
          'summons_zombie',
          'Zombie_hoplite'
        }
        
        for i = 1, table.getn(petlist) do
            if pc.ClassName == petlist[i] then
                AddBuff(pc, pc, "Event_Penalty_3")
                break;
            end
        end
	end
end

function GET_EVENT_STAGELV_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
end

function SCR_SELCT_BOSSLV_DIALOG(self, pc)
    local boss_claname = {
        'M_random_boss_sparnas',
        'M_random_boss_Gremlin',
        'M_random_boss_Mothstem',
        'M_random_boss_bebraspion',
        'M_random_boss_Shnayim',
        'M_random_boss_Achat',
        'M_random_boss_Harpeia'
    }
    
    local monCnt = 0
    sleep(1000)
    for i = 1, table.getn(boss_claname) do
        monCnt = GetWorldMonsterCountByClsName(GetZoneInstID(self), boss_claname[i]);
        
        if monCnt > 0 then
            monCnt = monCnt + 1
            break;
        end
    end
    
    if monCnt >= 1 then
        return;
    end
    
    local aObj = GetAccountObj(pc)
    local bossLV_input = ShowTextInputDlg(pc, 0, 'EVENT_SELECT_BOSSLV_01')
    local bossLV = tonumber(bossLV_input)
    local overlv = 0;

    local moncls_info = {
        {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
        {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
        {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
    }

    for i = 1, 3 do
        if aObj[moncls_info[i][2]] + 100 >= bossLV then
            overlv = 1;
            break;
        end
    end

    if bossLV ~= nil and bossLV > 1 and overlv == 1 then
        local zoneObj = GetLayerObject(self);
        local mon = CREATE_MONSTER(pc, boss_claname[IMCRandom(1, table.getn(boss_claname))], -63, 7, -19, 0, nil, 0, bossLV, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'None')
        AddHP(mon, mon.MHP_BM)
        EnableAIOutOfPC(mon)
        SetExProp(zoneObj, "bossLV", bossLV);
        Kill(self)
    else
        ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_09', 1)
    end
end

-- main dialog
function SCR_BLUEORB_MONLVUP_DIALOG(self,pc)
    
    if pc.Lv < 30 then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG8','LV',30), 10)
        return
    end
--    local moncls_info = {
--        {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
--        {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
--        {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
--    }
--    local mon_sel = 0;
--    local mon_name = { 'None', 'None', 'None' }
--    local aObj = GetAccountObj(pc)
--    
--     if aObj.EVENT_VALUE_AOBJ01 ~= 171121 then -- basic item
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'EVENT_VALUE_AOBJ01', 171121);
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON01_LV', 1);
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON02_LV', 1);
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON03_LV', 1);
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON01', 'None');
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON02', 'None');
--        TxSetIESProp(tx, aObj, 'EVENT_MYMON03', 'None');
--        TxSetIESProp(tx, aObj, 'BLUEORB_MISSION_CLEAR', 0);
--        TxGiveItem(tx, 'Event_Special_Blueorb', 1, "BLUEORB_REWARD");
--        TxGiveItem(tx, 'Event_Special_Trap', 1, "BLUEORB_REWARD");
--    	local ret = TxCommit(tx)
--    end
--
--    if aObj.EVENT_VALEN_R1 ~= 171123 then
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'EVENT_VALEN_R1', 171123);
--        TxSetIESProp(tx, aObj, 'EVENT_VALEN_R2', 3);
--    	local ret = TxCommit(tx)
--    end
--
--    local now_time = os.date('*t')
--    local yday = now_time['yday']
--    
--    if aObj.EVENT_VALUE_AOBJ02 ~= yday then -- event indun enter count reset
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'EVENT_VALUE_AOBJ02', yday);
--        TxSetIESProp(tx, aObj, 'BLUEORB_MISSION_COUNT', 0);
--    	local ret = TxCommit(tx)
--    end
    local select = ShowSelDlg(pc, 0, 'EVENT_1801_ORB_DLG3', ScpArgMsg("Cancel"), ScpArgMsg("EventShop"))
    if select == 2 then
        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP2_OPEN()")
    end
--    local select = ShowSelDlg(pc, 0, 'EVENT_1801_ORB_DLG3', ScpArgMsg("Cancel"), ScpArgMsg("Event_Steam_Together_Master_1"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL1"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL4"), ScpArgMsg("EventShop"), ScpArgMsg('EVENT_1801_ORB_MSG3'))
--    
--    if select == 1 or select == nil then
--        return;
--    elseif select == 2 then
--        if GetMyCompanion(pc) == nil then
--            AUTOMATCH_INDUN_DIALOG(pc, nil, 'c_firemage_event')
--        else
--            SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG7'), 10)
--        end
--    elseif select == 3 then
--        
--        local result = 0;
--        
--        for i = 1, table.getn(moncls_info) do
--            if aObj[moncls_info[i][1]] ~= 'None' then
--                result = result + 1;
--            end
--        end
--        local mon_name_KOR = {}
--        if result == 0 then
--            ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_02', 1)
--        else
--            if aObj[moncls_info[1][1]] ~= 'None' then
--                mon_name[1] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", GetClassString('Monster', aObj.EVENT_MYMON01, 'Name')..' Lv'..aObj[moncls_info[1][2]])
--                mon_name_KOR[1] = GetClassString('Monster', aObj.EVENT_MYMON01, 'Name')
--            else
--                mon_name[1] = nil
--            end
--            if aObj[moncls_info[2][1]] ~= 'None' then
--                mon_name[2] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", GetClassString('Monster', aObj.EVENT_MYMON02, 'Name')..' Lv'..aObj[moncls_info[2][2]])
--                mon_name_KOR[2] = GetClassString('Monster', aObj.EVENT_MYMON02, 'Name')
--            else
--                mon_name[2] = nil
--            end
--            if aObj[moncls_info[3][1]] ~= 'None' then
--                mon_name[3] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME",GetClassString('Monster', aObj.EVENT_MYMON03, 'Name')..' Lv'..aObj[moncls_info[3][2]])
--                mon_name_KOR[3] = GetClassString('Monster', aObj.EVENT_MYMON03, 'Name')
--            else
--                mon_name[3] = nil
--            end
--            if aObj[moncls_info[1][1]] == 'None' and aObj[moncls_info[2][1]] == 'None' and aObj[moncls_info[3][1]] == 'None' then
--                ShowOkDlg(pc, 'EVENT_1801_ORB_DLG4', 1)
--                return
--            end
--            mon_sel = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_03', ScpArgMsg("Cancel"), mon_name[1],  mon_name[2], mon_name[3] )
--        end
--        
--        if mon_sel == nil or mon_sel == 0 or aObj[moncls_info[mon_sel - 1][1]] == 'None' then
--            return;
--        end
--
--        if mon_sel ~= 0 then
--            if aObj[moncls_info[mon_sel-1][2]] >= 300 then
--                ShowOkDlg(pc, 'EVENT_1801_ORB_DLG1', 1)
--                return
--            end
--            local lvup_input = ShowTextInputDlg(pc, 0, 'EVENT_SELECT_BOSSLV_03\\'..ScpArgMsg("EVENT_SELECT_BOSSLV_SEL3", "NAME", mon_name_KOR[mon_sel - 1], "LV", aObj[moncls_info[mon_sel-1][2]]))
--            local lvup = tonumber(lvup_input)
--            if lvup == nil or lvup <= 0 then
--                return;
--            end
--            
--            if GetInvItemCount(pc, 'Event_Special_Etcitem') < lvup then
--                ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--                return;
--            end
--            
--            local targetLv = 0
--            local targetCount = 0
--            local lastCount = 0
--            for i = aObj[moncls_info[mon_sel-1][2]] + 1, 300 do
--                local lvTakeCount = math.floor(i / 5) + 1
--                lastCount = lvTakeCount
--                if targetCount + lvTakeCount <= lvup then
--                    targetCount = targetCount + lvTakeCount
--                    targetLv = i
--                else
--                    break
--                end
--            end
--            
--            if targetLv > 0 and targetLv > aObj[moncls_info[mon_sel-1][2]] then
--                local tx = TxBegin(pc)
--                TxSetIESProp(tx, aObj, moncls_info[mon_sel - 1][2], targetLv);
--                TxTakeItem(tx, 'Event_Special_Etcitem', targetCount, 'blueorb_event');
--            	local ret = TxCommit(tx)
--            	if ret == 'SUCCESS' then
--            	    PlayEffect(pc, "F_buff_basic025_white_line", 1)
--            	    SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG1','COUNT', targetCount,'NAME', mon_name_KOR[mon_sel - 1],'LV', targetLv), 10)
--            	end
--            else
--                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG2','COUNT', lastCount), 10)
--                return;
--            end
--        end
--    elseif select == 4 then
--        if aObj[moncls_info[1][1]] ~= 'None' then
--            mon_name[1] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", GetClassString('Monster', aObj.EVENT_MYMON01, 'Name')..' Lv'..aObj[moncls_info[1][2]])
--        else
--            mon_name[1] = nil
--        end
--        if aObj[moncls_info[2][1]] ~= 'None' then
--            mon_name[2] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", GetClassString('Monster', aObj.EVENT_MYMON02, 'Name')..' Lv'..aObj[moncls_info[2][2]])
--        else
--            mon_name[2] = nil
--        end
--        if aObj[moncls_info[3][1]] ~= 'None' then
--            mon_name[3] = ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", GetClassString('Monster', aObj.EVENT_MYMON03, 'Name')..' Lv'..aObj[moncls_info[3][2]])
--        else
--            mon_name[3] = nil
--        end
--        if aObj[moncls_info[1][1]] == 'None' and aObj[moncls_info[2][1]] == 'None' and aObj[moncls_info[3][1]] == 'None' then
--            ShowOkDlg(pc, 'EVENT_1801_ORB_DLG4', 1)
--            return
--        end
--            
--        local sel = ShowSelDlg(pc, 0, 'EVENT_1801_ORB_DLG5', ScpArgMsg("Cancel"), mon_name[1], mon_name[2], mon_name[3] )
--        
--        if sel == 1 or sel == nil then
--            return;
--        else
--            local sel2 = ShowSelDlg(pc, 0, 'EVENT_1801_ORB_DLG6', ScpArgMsg("Cancel"), ScpArgMsg('NUMBER_MIXING_VALUE_MSG1') )
--            if sel2 == 2 then
--                if aObj[moncls_info[sel-1][1]] == 'None' then
--                    ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_02', 1)
--                    return;
--                end
--                
--                if GetInvItemCount(pc, 'Event_Special_Etcitem') < 30 then
--                    ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--                    return;
--                end
--    
--                local tx = TxBegin(pc)
--                TxSetIESProp(tx, aObj, moncls_info[sel - 1][1], 'None');
--                TxTakeItem(tx, 'Event_Special_Etcitem', 30, 'blueorb_event_reset');
--            	local ret = TxCommit(tx)
--            	
--            	if ret == 'SUCCESS' then
--            	    ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_06', 1)
--            	    PlayEffect(pc, "F_buff_basic025_white_line", 1)
--            	end
--            end
--        end
--    elseif select == 5 then
--        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP2_OPEN()")
--    elseif select == 6 then
--        local year = now_time['year']
--        local month = now_time['month']
--        local day = now_time['day']
--        local nowDate = year..'/'..month..'/'..day
--        if aObj.EVENT_1801_ORB_GIVE_DATE ~= nowDate then
--            local tx = TxBegin(pc)
--            TxSetIESProp(tx, aObj, 'EVENT_1801_ORB_GIVE_DATE', nowDate);
--            TxGiveItem(tx, 'EVENT_1801_ORB_MISSION_KEY', 12, 'blueorb_event');
--        	local ret = TxCommit(tx)
--        else
--            ShowOkDlg(pc, 'EVENT_1801_ORB_DLG2', 1)
--        end
--    end
end

function SCR_BLUEORB_REWARD(cmd, curStage, eventInst, obj)
	-- local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    -- local result = 0;

	-- for i = 1 , cnt do
    --     local zoneObj = GetLayerObject(list[i]);
    --     local aObj = GetAccountObj(list[i])
    --     local bossLV = GetExProp(zoneObj, "bossLV");
    --     local mymon_level = {'EVENT_MYMON01_LV', 'EVENT_MYMON02_LV', 'EVENT_MYMON03_LV'}

    --     for i = 1, 3 do
    --         if aObj[mymon_level[i]] + 100 >= bossLV then
    --             result = 1
    --             break;
    --         end
    --     end

    --     if result == 1 then
	--         RunScript('SCR_BLUEORB_REWARD_PLAY', list[i], zoneObj, aObj, bossLV)
    --     end
	-- end
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
        local zoneObj = GetLayerObject(list[i]);
        local aObj = GetAccountObj(list[i])
        local bossLV = GetExProp(zoneObj, "bossLV");
	    RunScript('SCR_BLUEORB_REWARD_PLAY', list[i], zoneObj, aObj, bossLV)
	end
end

function SCR_BLUEORB_REWARD_PLAY(pc, zoneObj, aObj, bossLV)
    local moncls_info = {
        {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
        {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
        {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
    }
    local mymon_maxlv = 0;

    for a = 1, 3 do -- 1
        if aObj[moncls_info[a][2]] > mymon_maxlv then
            mymon_maxlv = aObj[moncls_info[a][2]]
        end
    end

    if mymon_maxlv > bossLV then -- 2
        mymon_maxlv = bossLV
    end

    local reward_blueorb_piece = math.floor(mymon_maxlv / 10)
    
    if reward_blueorb_piece <= 0 then
        reward_blueorb_piece = 1
    end
    
    local indunCls = GetClass('Indun', 'c_firemage_event');
    local takeCount = GET_ADMISSION_ITEM_TAKE_COUNT(pc, indunCls);
    local pcetc = GetETCObject(pc);
    local enterCountPropName = 'InDunCountType_'..indunCls.PlayPerResetType;
    local nowItemCount = GetInvItemCount(pc, 'EVENT_1801_ORB_MISSION_KEY')
    
    if nowItemCount < takeCount then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG4','COUNT',takeCount), 10)
        return;
    end
    
    local tx = TxBegin(pc)
    TxEnableInIntegrate(tx)
    TxGiveItem(tx, 'Event_BlueCube_Lv6', 1, "BLUEORB_REWARD");
    TxGiveItem(tx, 'Event_Special_Etcitem2', reward_blueorb_piece, "BLUEORB_REWARD");
    if aObj.EVENT_VSMON_STAGE < bossLV then
        TxSetIESProp(tx, aObj, 'EVENT_VSMON_STAGE', bossLV)
    end
    TxAddIESProp(tx, aObj, 'BLUEORB_MISSION_CLEAR', 1)
    TxAddIESProp(tx, aObj, 'BLUEORB_MISSION_COUNT', 1)
    
    TxTakeItem(tx, 'EVENT_1801_ORB_MISSION_KEY', takeCount, "BLUEORB_REWARD");
    TxAddIESProp(tx, pcetc, enterCountPropName, 1)
	local ret = TxCommit(tx)
	
	
	if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('JP_Event_Daily'), 5)
	end
end

function SCR_BLUEORB_CLEAR_DIALOG(self,pc)
    local boss_claname = {
        'M_random_boss_sparnas',
        'M_random_boss_Gremlin',
        'M_random_boss_Mothstem',
        'M_random_boss_bebraspion',
        'M_random_boss_Shnayim',
        'M_random_boss_Achat',
        'M_random_boss_Harpeia'
    }
    
    local monCnt = 0
    
    for i = 1, table.getn(boss_claname) do
        monCnt = GetWorldMonsterCountByClsName(GetZoneInstID(self), boss_claname[i]);
        
        if monCnt > 0 then
            monCnt = monCnt + 1
            break;
        end
    end
    
    if monCnt == 0 then
        PlayAnim(self, 'OPEN', 1)
        sleep(4000)
        Kill(self)
    else
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG9'), 5)
    end
end

--function SCR_EVENTITEM_DROP_BLUEORB(self, sObj, msg, argObj, argStr, argNum) 
--    if IMCRandom(1, 100) <= 9 then
--        local curMap = GetZoneName(self);
--        local mapCls = GetClass("Map", curMap);
--        
--        if self.Lv >= 30 and (mapCls.WorldMap ~= 'None' and mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 and IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1) and argObj.MonRank == 'Normal' then
--            if self.Lv <= argObj.Lv + 20 then
--                local x, y, z = GetPos(argObj);
--                local itemObj = CreateGCIES('Monster', 'Event_Special_Etcitem');
--                CreateItem(self, itemObj, x, y, z, 0, 5);
--            end
--        end
--    end
--end