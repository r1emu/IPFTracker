function SCR_EVENT_NRU2_315GUIDE_DIALOG(self, pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local aObj = GetAccountObj(pc);
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    if ((month >= 10 and day >= 17) or (month >= 11)) and year >= 2017 then
        if aObj.EV171017_STEAM_NRU_AOBJ == 0 then
           local tx = TxBegin(pc)
           TxGiveItem(tx, 'costume_simple_festival_m', 1, 'EV170711_NRU2');
           TxGiveItem(tx, 'costume_simple_festival_f', 1, 'EV170711_NRU2');
           TxSetIESProp(tx, aObj, 'EV171017_STEAM_NRU_AOBJ', 1);
           local ret = TxCommit(tx) 
        end
            if aObj.EV171017_STEAM_NRU_AOBJ < 5 then
                if sObj.EV171017_STEAM_NRU_SOBJ == 0 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'Event_Nru2_Box_1', 1, 'EV170711_NRU2');
                    TxSetIESProp(tx, aObj, 'EV171017_STEAM_NRU_AOBJ', aObj.EV171017_STEAM_NRU_AOBJ + 1);
                    TxSetIESProp(tx, sObj, 'EV171017_STEAM_NRU_SOBJ', sObj.EV171017_STEAM_NRU_SOBJ + 1);
                    local ret = TxCommit(tx)
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("steam_Nru_Always_2", "NRUCOUNT", 5 - aObj.EV171017_STEAM_NRU_AOBJ), 5)
                 else
                    ShowOkDlg(pc,'NPC_EVENT_NRU_ALWAYS_1', 1)
                end
            else
                ShowOkDlg(pc,'NPC_EVENT_NRU_ALWAYS_2', 1)
            end
    else
        ShowOkDlg(pc,'NPC_EVENT_NRU2_1', 1)
    end
end

function SCR_USE_EVENT_NRU2_BOX_1(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_2', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_2(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken02_event01', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'NECK99_107', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Scroll_Warp_Klaipe', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_SWD04_106', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_TSW04_106', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_MAC04_108', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_TSF04_106', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_STF04_107', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_SPR04_103', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_TSP04_107', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BOW04_106', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_TBW04_106', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_SHD04_102', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_3', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_3(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_4', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_4(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'BRC99_103', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'BRC99_104', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_5', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_5(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv50', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'PremiumToken_3d', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_6', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_6(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv80', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_7', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_7(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_8(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv110', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_SkillReset_14d', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_9', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_9(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv120', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_Enchantchip14', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_10', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_10(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv140', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP2', 20, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_11', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_11(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
    TxGiveItem(tx, 'RestartCristal', 10, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv150', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BRC04_101', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BRC02_109', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_12', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_12(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv170', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv170_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_13', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_13(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv190', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP2', 20, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_14', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_14(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv200', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_15', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_15(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv210_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BRC03_108', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BRC04_103', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_16', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_16(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv230', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv230_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'E_BRC03_120', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_17', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_17(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP3', 20, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv240_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_18', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_18(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv260', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv260_2', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru2_Box_19', 1, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_19(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv290', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_Enchantchip14', 4, 'EV170711_NRU2');
    TxGiveItem(tx, 'Premium_StatReset14', 1, 'EV170711_NRU2');
    TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
    local ret = TxCommit(tx)
end