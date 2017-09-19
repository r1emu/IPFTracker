function SCR_EVENT_TOGETHER_MASTER_REWARD(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
	    local result = SCR_EVENT_TOGETHER_MASTER_REWARD_PRECHECK(list[i])
	    if result ~= 'NO' then
    		RunScript('SCR_EVENT_TOGETHER_MASTER_REWARD_PLAY', list[i])
    	end
	end
end

function SCR_EVENT_TOGETHER_MASTER_REWARD_PRECHECK(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDay = year..'/'..month..'/'..day
    if aObj.EVENT_TOGETHER_MASTER_DATE ~= nowDay then
        return 'YES'
    else
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('Event_Together_Master_1'), 10)
        return 'NO'
    end
end

function SCR_EVENT_TOGETHER_MASTER_REWARD_PLAY(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDay = year..'/'..month..'/'..day
        
    if aObj.EVENT_TOGETHER_MASTER_DATE ~= nowDay then
        local tx = TxBegin(pc)
        TxEnableInIntegrate(tx)
        TxSetIESProp(tx, aObj, 'EVENT_TOGETHER_MASTER_DATE', nowDay)
        TxGiveItem(tx, 'Event_Steam_Master_Item', 1, "EVENT_TOGETHER_MASTER");
    	local ret = TxCommit(tx)
    	if ret == 'SUCCESS' then
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('Event_Together_Master_2'), 10)
    	end
	end
end

function SCR_EVENT_TOGETHER_MASTER_DIALOG(self, pc)  
    local aObj = GetAccountObj(pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    if pc.Lv < 50 then
        return
    end
    
    if aObj.EV170613_STEAM_WEDDING_1 ~= 170919 then -- ���� �������� �̺�Ʈ
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_1', 170919);
        TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_3', 0);
        local ret = TxCommit(tx)
    end
    if aObj.EV170613_STEAM_WEDDING_3 == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Steam_Master_Item', 2, 'EVENT_TOGETHER_MASTER');
        TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_3', 1);
        local ret = TxCommit(tx)
    end
    
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_STEAM_TOGETHER_MASTER_1', ScpArgMsg("Event_Steam_Together_Master_1"), ScpArgMsg("Event_Steam_Together_Master_2"), ScpArgMsg("Cancel"))
    
    if select == 1 then
        AUTOMATCH_INDUN_DIALOG(pc, nil, 'E_f_katyn_12_Mission')
    elseif select == 2 then
        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP2_OPEN()")
    end     
end