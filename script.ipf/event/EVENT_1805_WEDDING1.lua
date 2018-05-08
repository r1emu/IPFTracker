function SCR_EVENT_1805_WEDDING1_DROP(self, sObj, msg, argObj, argStr, argNum)
    if IMCRandom(1, 100) <= 9 then
        if EVENT_1805_WEDDING1_NOW_TIME() == 'YES' then
            local curMap = GetZoneName(self);
            local mapCls = GetClass("Map", curMap);
            
            if self.Lv >= 50 and mapCls.WorldMap ~= 'None' and mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 and IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
                if self.Lv - 30 <= argObj.Lv and self.Lv + 30 >= argObj.Lv then
                    RunScript('GIVE_ITEM_TX',self, 'EVENT_1805_WEDDING1_PIECE', 1, 'EVENT_1805_WEDDING1')
                end
            end
        end
    end
end

function EVENT_1805_WEDDING1_NOW_TIME()
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
    local index = 0
    
    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 5, 17) then
        return 'YES'
    end
    
    return 'NO'
end

function SCR_EVENT_1805_WEDDING1_NPC_DIALOG(self, pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    local rewardList = {{'Adventure_Reward_Seed', 2},
                        {'RestartCristal', 3},
                        {'Premium_boostToken03_event01', 1},
                        {'EVENT_1712_SECOND_CHALLENG_14d', 2},
                        {'Premium_StatReset14', 1},
                        {'Premium_Enchantchip14', 3},
                        {'misc_gemExpStone_randomQuest4_14d', 1},
                        {'Drug_Event_Looting_Potion_14d', 5},
                        {'misc_BlessedStone', 3},
                        {'Premium_RankReset_14d', 1}
                        }
    
    if aObj.EVENT_1805_WEDDING1_COUNT >= 10 then
        ShowOkDlg(pc, 'EVENT_1805_WEDDING1_DLG2', 1)
    else
        local nowIndex = aObj.EVENT_1805_WEDDING1_COUNT + 1
        local addMsg = ''
        local rewardItemIES = GetClass('Item', rewardList[nowIndex][1])
        if rewardItemIES.TeamTrade ~= 'YES' then
            addMsg = ScpArgMsg('EVENT_1805_WEDDING1_MSG5')
        end
        local select = ShowSelDlg(pc, 0, 'EVENT_1805_WEDDING1_DLG1\\'..ScpArgMsg('EVENT_1805_WEDDING1_MSG1','DAYCOUNT',nowIndex,'ITEM',GetClassString('Item', rewardList[nowIndex][1],'Name'),'COUNT',rewardList[nowIndex][2])..addMsg, ScpArgMsg('EVENT_1805_WEDDING1_MSG2'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
        if select == 1 then
            if aObj.EVENT_1805_WEDDING1_DATE ~= nowday then
                if addMsg ~= '' then
                    local select2 = ShowSelDlg(pc, 0, 'EVENT_1805_WEDDING1_DLG1\\'..ScpArgMsg('EVENT_1805_WEDDING1_MSG6'),ScpArgMsg('EVENT_1707_USERWEDDING_MSG1'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
                    if select2 ~= 1 then
                        return
                    end
                end
                local takeCount = 50
                if GetInvItemCount(pc, 'EVENT_1805_WEDDING1_PIECE') < takeCount then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_WEDDING1_MSG4"), 10)
                else
                    local tx = TxBegin(pc)
                    TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING1_DATE', nowday)
                    TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING1_COUNT', nowIndex)
                    TxGiveItem(tx, rewardList[nowIndex][1], rewardList[nowIndex][2], 'EVENT_1805_WEDDING1')
                    TxTakeItem(tx, 'EVENT_1805_WEDDING1_PIECE', takeCount, 'EVENT_1805_WEDDING1')
                    local ret = TxCommit(tx)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_WEDDING1_MSG3"), 10)
            end
        end
    end
end
