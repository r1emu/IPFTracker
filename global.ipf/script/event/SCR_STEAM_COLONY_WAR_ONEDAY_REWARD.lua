--일일 참여 기본 보상 스크립트
function SCR_STEAM_COLONY_WAR_ONEDAY_REWARD(self)
    local aObj = GetAccountObj(self);
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    local lastDate = aObj.STEAM_COLONY_WAR_ONEDAY_REWARD_CHECK
    local count = aObj.STEAM_COLONY_WAR_ONEDAY_REWARD_COUNT
    local limitCount = 1; --일일 보상 아이템 지급 제한 카운트
    
    --보상아이템 목록
    local rewardList = { {'Premium_repairPotion', 10}

    }
    local itemName = "None"
    local itemCount = 0

    if lastDate ~= nowDate then
        local tx = TxBegin(self)
        TxSetIESProp(tx, aObj, 'STEAM_COLONY_WAR_ONEDAY_REWARD_CHECK', nowDate)
        TxSetIESProp(tx, aObj, 'STEAM_COLONY_WAR_ONEDAY_REWARD_COUNT', 1)
        for i = 1, #rewardList do
            itemName = GetClassString('Item', rewardList[i][1], 'Name')
            itemCount = rewardList[i][2]
            TxGiveItem(tx, rewardList[i][1], rewardList[i][2], 'STEAM_COLONY_WAR_ONEDAY_REWARD');
        end
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            count = aObj.STEAM_COLONY_WAR_ONEDAY_REWARD_COUNT
            SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("STEAM_COLONY_WAR_ONEDAY_REWARD_MSG{itemName}{itemCount}{nowCount}{limitCount}", "itemName", itemName, "itemCount", itemCount, "nowCount", count, "limitCount", limitCount), 15);
        end
    else
        if count < limitCount then
            local tx = TxBegin(self)
            TxSetIESProp(tx, aObj, 'STEAM_COLONY_WAR_ONEDAY_REWARD_COUNT', count + 1)
            for i = 1, #rewardList do
                itemName = GetClassString('Item', rewardList[i][1], 'Name')
                itemCount = rewardList[i][2]
                TxGiveItem(tx, rewardList[i][1], rewardList[i][2], 'STEAM_COLONY_WAR_ONEDAY_REWARD');
            end
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                count = aObj.STEAM_COLONY_WAR_ONEDAY_REWARD_COUNT
                SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("STEAM_COLONY_WAR_ONEDAY_REWARD_MSG{itemName}{itemCount}{nowCount}{limitCount}", "itemName", itemName, "itemCount", itemCount, "nowCount", count, "limitCount", limitCount), 15);
            end
        end
    end
end
