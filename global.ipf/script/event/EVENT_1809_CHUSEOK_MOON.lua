function SCR_EVENT_CHUSEOK_MOON_NPC_SETTIME(self, sObj, remainTime)
   SCR_EVENT_1809_CHUSEOK_MOON_NPC_CREATE(self)
end

function SCR_EVENT_CHUSEOK_MOON_TS_BORN_ENTER(self)
end

function SCR_EVENT_CHUSEOK_MOON_TS_BORN_UPDATE(self)
   local nowSec = math.floor(os.clock())
   local x,y,z = GetPos(self)
   
   local moveTime = GetExProp(self, 'MOVE_TIME')
   local pc = GetExArgObject(self, 'OWNER_PC')
   if pc == nil then
       Kill(self)
       return
   end
   
   if moveTime <= nowSec or GetDistance(pc,self) >= 50 then
       local pos_list = SCR_CELLGENPOS_LIST(pc, 'Front2', 180)
       if GetDistance(pc,self) >= 200 then
           SetPos(self,pos_list[1][1], pos_list[1][2], pos_list[1][3])
       else
           MoveEx(self, pos_list[1][1], pos_list[1][2], pos_list[1][3], 1)
       end
       SetExProp(self, 'MOVE_TIME', nowSec + IMCRandom(2,4))
   end
end

function SCR_EVENT_CHUSEOK_MOON_TS_BORN_LEAVE(self)
end

function SCR_EVENT_CHUSEOK_MOON_TS_DEAD_ENTER(self)
end

function SCR_EVENT_CHUSEOK_MOON_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_CHUSEOK_MOON_TS_DEAD_LEAVE(self)
end

function SCR_SSN_EVENT_1809_CHUSEOK_MOON_KillMonster(self, sObj, msg, argObj, argStr, argNum, party_pc)
   local monType = TryGetProp(argObj, 'MonRank', 'None')
   if monType == 'Boss' and argObj.ClassName ~= 'd_raid_velcoffer_fallen_statue_gray' and argObj.ClassName ~= 'd_raid_boss_RytaSwort_minimal' and GetExProp(argObj, 'SORCERER_SUMMONING') ~= 1 then
       local cardBoss = GetExProp(argObj, 'CARDSUMMON_BOSS')
       local isLastAttack = 0
       if party_pc == nil then
           isLastAttack = 1
       end
       local zoneInst = GetZoneInstID(self);
       local layer = GetLayer(self);
       local layerObj = GetLayerObject(zoneInst, layer);
       
       local challengelevel = GetExProp(layerObj, "ChallengeModeLevel");
       
       CustomMongoLog(self, "EVENT_1809_CHUSEOK_MOON_BOSSKILL", "PC_LV",self.Lv,"BOSS_LV",argObj.Lv,"BOSS_LAYER",GetLayer(argObj),"IS_CARD_SUMMON",cardBoss, "IS_LAST_ATTACK", isLastAttack, "Challengelevel", challengelevel)
       
       if self.Lv >= 50 and (GetLayer(argObj) == 0 or challengelevel >= 1) then
           if self.Lv - 30 <= argObj.Lv and self.Lv + 30 >= argObj.Lv then
               if cardBoss == 1 and party_pc ~= nil then
                   return
               end
               RunScript('SSN_EVENT_1809_CHUSEOK_MOON_ITEM_GIVE',self, 2)
           end
       end
   end
end

function SSN_EVENT_1809_CHUSEOK_MOON_ITEM_GIVE(pc, count)
   local aObj = GetAccountObj(pc);
   if aObj == nil then
       return
   end
   if GetZoneName(pc) == 'd_solo_dungeon' then
       return
   end
   
   if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 1 or aObj.EVENT_1809_CHUSEOK_MOON_STATE == 3 then
       local tx = TxBegin(pc);
   	TxEnableInIntegrate(tx);
   	TxGiveItem(tx,'EVENT_1809_CHUSEOK_MOON_PIECE', count, "EVENT_1809_CHUSEOK_MOON")
   	local ret = TxCommit(tx);
   	if ret == 'SUCCESS' then
   	end
   end
end

function SCR_EVENT_1809_CHUSEOK_MOON_QUEST_SUCCESS(pc,questname)
   if pc.Lv >= 50 then
       SSN_EVENT_1809_CHUSEOK_MOON_ITEM_GIVE(pc, 1)
   end
end

function SCR_EVENT_1809_CHUSEOK_MOON_NPC_CREATE(pc)
   local aObj = GetAccountObj(pc);
   if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 1 or aObj.EVENT_1809_CHUSEOK_MOON_STATE == 3 then
       local npc = GetExArgObject(pc, 'EVENT_1809_CHUSEOK_MOON_NPC')
       if npc == nil then
           local pos_list = SCR_CELLGENPOS_LIST(pc, 'Front2', 180)
           npc = CREATE_NPC(pc, 'npc_moon', pos_list[1][1], pos_list[1][2], pos_list[1][3], 0, nil, GetLayer(pc), ScpArgMsg('EVENT_1809_CHUSEOK_MOON_MSG13','NAME',GetTeamName(pc)), nil, nil, 1, 1, nil, 'EVENT_CHUSEOK_MOON', nil, nil, nil, nil, nil, nil)
           if npc ~= nil then
               SetExArgObject(npc, 'OWNER_PC', pc)
               SetExArgObject(pc, 'EVENT_1809_CHUSEOK_MOON_NPC', npc)
               if aObj ~= nil then
                   local scaleValue = 1
                   if aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT > 1 then
                       scaleValue = 1 + math.floor(aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT / 50) * 0.1
                   end
                   if scaleValue > 4 then
                       scaleValue = 4
                   end
                   ChangeScale(npc, scaleValue, 0, 1, 0, 0, 1)
                   AttachEffect(npc, 'F_archer_scarecrow_loop_ground', scaleValue/(scaleValue*1.5+1), 'BTN')
               end
           end
       elseif GetLayer(pc) ~= GetLayer(npc) then
           SetLayer(npc, GetLayer(pc))
       end
   end
end

function SCR_EVENT_1809_CHUSEOK_MOON_NPC_KILL(pc)
   local npc = GetExArgObject(pc, 'EVENT_1809_CHUSEOK_MOON_NPC')
   if npc ~= nil then
       SetExArgObject(pc, 'EVENT_1809_CHUSEOK_MOON_NPC', nil)
       
       Kill(npc)
   end
end

function SCR_EVENT_1809_CHUSEOK_MOON_DIALOG(self, pc)
   if pc.Lv < 50 then
       SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
       return
   end
   
   local aObj = GetAccountObj(pc);
   if aObj == nil then
       return
   end
   local itemObj, invItemCount = GetInvItemByName(pc, 'EVENT_1809_CHUSEOK_MOON_PIECE');
   local islock = 0
   if itemObj ~= nil then
       islock = IsFixedItem(itemObj)
   end
   
   if islock == 1 then
       SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("{Item}LockSuccess","Item",GetClassString('Item','EVENT_1809_CHUSEOK_MOON_PIECE','Name')), 10);
       return
   end
   
   local now_time = os.date('*t')
   local year = now_time['year']
   local month = now_time['month']
   local day = now_time['day']
   local nowday = year..'/'..month..'/'..day
   
   local addRewardIndex = 0
   local addRewardSelMsg
   local addRewardList = {{'Event_160908_6_14d',5},{'Premium_SkillReset_14d',1},{'EVENT_1809_CHUSEOK_MOON_ACHIEVE_BOX',1},{'wing_inspector_bundle',1}}
   local addRewardCount = {5, 10, 15, 20}    
   for i = 1, #addRewardCount do
       if aObj.EVENT_1809_CHUSEOK_MOON_COUNT >= addRewardCount[i] then
           if aObj.EVENT_1809_CHUSEOK_MOON_ADDREWARD < i then
               addRewardIndex = i
               addRewardSelMsg = ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG2")..' : '..GetClassString('Item', addRewardList[i][1], 'Name')
               break
           end
       end
   end

   local rank, score, totalRankerCnt = GetRankerInfo(pc, 'EVENT_1809_CHUSEOK_MOON', 'SEASON1', 0);
   
   local select = ShowSelDlg(pc, 0, 'EVENT_1809_CHUSEOK_MOON_DLG1', ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG1"), addRewardSelMsg, ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG3"), ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG4"), ScpArgMsg("Auto_JongLyo"))
   
   local itemObj, invItemCount = GetInvItemByName(pc, 'EVENT_1809_CHUSEOK_MOON_PIECE');
   local islock = 0
   if itemObj ~= nil then
       islock = IsFixedItem(itemObj)
   end
   
   if islock == 1 then
       SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("{Item}LockSuccess","Item",GetClassString('Item','EVENT_1809_CHUSEOK_MOON_PIECE','Name')), 10);
       return
   end
   
   if select == 1 then
       if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 1 then
           if invItemCount < 20 then
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG5"), 10);
               return
           end
           local tx = TxBegin(pc);
       	TxEnableInIntegrate(tx);
       	
       	TxGiveItem(tx,'Point_Stone_100', 5, "EVENT_1809_CHUSEOK_MOON")
       	TxGiveItem(tx,'misc_BlessedStone', 2, "EVENT_1809_CHUSEOK_MOON")
       	TxGiveItem(tx,'Event_160908_5', 2, "EVENT_1809_CHUSEOK_MOON")
       	TxGiveItem(tx,'EVENT_1712_SECOND_CHALLENG_14d', 1, "EVENT_1809_CHUSEOK_MOON")
       	TxTakeItem(tx,'EVENT_1809_CHUSEOK_MOON_PIECE', 20, "EVENT_1809_CHUSEOK_MOON")
           TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_COUNT", aObj.EVENT_1809_CHUSEOK_MOON_COUNT + 1)
           TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_STATE", 2)
       	local ret = TxCommit(tx);
       	if ret == 'SUCCESS' then
           	SCR_EVENT_1809_CHUSEOK_MOON_NPC_KILL(pc)
           end
       else
           if aObj.EVENT_1809_CHUSEOK_MOON_DATE == nowday then
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1705_CORSAIR_MSG4"), 10)
               return
           end
           if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 0 or aObj.EVENT_1809_CHUSEOK_MOON_STATE == 2 then
               local tx = TxBegin(pc);
           	TxEnableInIntegrate(tx);
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_STATE", 1)
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_DATE", nowday)
           	local ret = TxCommit(tx);
           	if ret == 'SUCCESS' then
           	    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG15"), 10);
           	    SCR_EVENT_1809_CHUSEOK_MOON_NPC_CREATE(pc)
               end
           elseif aObj.EVENT_1809_CHUSEOK_MOON_STATE == 3 then
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG9"), 10);
               return
           else
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG6"), 10);
               return
           end
       end
   elseif select == 2 then
       local tx = TxBegin(pc);
   	TxEnableInIntegrate(tx);
   	for i = 1, #addRewardList[addRewardIndex]/2 do -- 1 --
   	    TxGiveItem(tx,addRewardList[addRewardIndex][i*2-1], addRewardList[addRewardIndex][i*2], "EVENT_1809_CHUSEOK_MOON")
   	end
   	
       TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_ADDREWARD", addRewardIndex)
   	local ret = TxCommit(tx);
   elseif select == 3 then
       if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 3 then
           local select2 = ShowSelDlg(pc, 0, 'EVENT_1809_CHUSEOK_MOON_DLG2', ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG10")..' : '..ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG17","COUNT", invItemCount), ScpArgMsg("Auto_JongLyo"))
           if select2 == 1 then
               local itemObj, invItemCount = GetInvItemByName(pc, 'EVENT_1809_CHUSEOK_MOON_PIECE');
               local islock = 0
               if itemObj ~= nil then
                   islock = IsFixedItem(itemObj)
               end
               
               if islock == 1 then
                   SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("{Item}LockSuccess","Item",GetClassString('Item','EVENT_1809_CHUSEOK_MOON_PIECE','Name')), 10);
                   return
               end
               
               local tx = TxBegin(pc);
           	TxEnableInIntegrate(tx);
           	TxTakeItem(tx,'EVENT_1809_CHUSEOK_MOON_PIECE', invItemCount, "EVENT_1809_CHUSEOK_MOON")
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_STATE", 0)
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT", aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT + invItemCount)
           	local ret = TxCommit(tx);
           	if ret == 'SUCCESS' then
               --이벤트 프로퍼티 추가하고 여기서 aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT 100 이상이고 칭호 안받았으면 then 칭호 1회 기브 --
           	    local rank, score, totalRankerCnt = GetRankerInfo(pc, 'EVENT_1809_CHUSEOK_MOON', 'SEASON1', 0);
           	    local aid = GetPcAIDStr(pc)
           	    SaveRedisPropValue(pc, 'EVENT_1809_CHUSEOK_MOON', 'SEASON1', aid, invItemCount, 1, 0)
--            	    print('AAAAAAAAAAAAAAAAAAAAA',rank, score, totalRankerCnt,invItemCount,aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT)
           	    CustomMongoLog(pc, "EVENT_1809_CHUSEOK_MOON_RANK", "BEFORE_COUNT", score,"ADD_COUNT",invItemCount, "ALL_COUNT", aObj.EVENT_1809_CHUSEOK_MOON_RANK_GIVECOUNT)
               	SCR_EVENT_1809_CHUSEOK_MOON_NPC_KILL(pc)
               end
           end
       else
           if aObj.EVENT_1809_CHUSEOK_MOON_RANK_DATE == nowday then
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG7"), 10);
               return
           end
           if aObj.EVENT_1809_CHUSEOK_MOON_STATE == 2 then
               local tx = TxBegin(pc);
           	TxEnableInIntegrate(tx);
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_STATE", 3)
               TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_MOON_RANK_DATE", nowday)
           	local ret = TxCommit(tx);
           	if ret == 'SUCCESS' then
           	    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG16"), 10);
           	    SCR_EVENT_1809_CHUSEOK_MOON_NPC_CREATE(pc)
               end
           elseif aObj.EVENT_1809_CHUSEOK_MOON_STATE == 0 or aObj.EVENT_1809_CHUSEOK_MOON_STATE == 1 then
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG14"), 10);
               return
           else
               SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG8"), 10);
               return
           end
       end
   elseif select == 4 then
       SEND_REDIS_RANKING_INFO(pc, ScpArgMsg('EVENT_1809_CHUSEOK_MOON_MSG4'), 'EVENT_1809_CHUSEOK_MOON', 'SEASON1', 1, 10, 0);
   end
end
