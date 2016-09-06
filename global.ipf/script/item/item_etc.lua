function DLC_BOX1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_650', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_PremiumToken_60d', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_JOB_HOGLAN_COUPON', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629003', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'Premium_SkillReset', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Premium_StatReset', 1, 'DLC_BOX1');
    local ret = TxCommit(tx);
end

function DLC_BOX2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_380', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX2');
    local ret = TxCommit(tx);
end

function DLC_BOX3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_160', 1, 'DLC_BOX3');
    local ret = TxCommit(tx);
end

function GIVE_MIC_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Mic', 10, 'TPSHOP_MIC_50');
    local ret = TxCommit(tx);
end

function GIVE_ENCHANTSCROLL_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'TPSHOP_ENCHANTSCROLL_20');
    local ret = TxCommit(tx);
end

function DLC_BOX4(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_650', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_PremiumToken_60d', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_JOB_HOGLAN_COUPON', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Hat_629003', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'Premium_SkillReset', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Premium_StatReset', 1, 'DLC_BOX4');
    local ret = TxCommit(tx);
end

function DLC_BOX5(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_380', 1, 'DLC_BOX5');
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX5');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX5');
    local ret = TxCommit(tx);
end

function DLC_BOX6(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_190', 1, 'DLC_BOX6');
    TxGiveItem(tx, 'PremiumToken_15d', 1, 'DLC_BOX6');
    TxGiveItem(tx, 'RestartCristal', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Premium_boostToken', 5, 'DLC_BOX6');
    TxGiveItem(tx, 'Mic', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Premium_WarpScroll', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Drug_Premium_HP1', 20, 'DLC_BOX6');
    TxGiveItem(tx, 'Drug_Premium_SP1', 20, 'DLC_BOX6');
    local ret = TxCommit(tx);
end

function DLC_BOX7(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX7');
    TxGiveItem(tx, 'Premium_Enchantchip_10', 4, 'DLC_BOX7');
    TxGiveItem(tx, 'Premium_indunReset', 5, 'DLC_BOX7');
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_BUYPOINT(self, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(self);
	TxAddWorldPVPProp(tx, "ShopPoint", Numarg1);
	local ret = TxCommit(tx);
end

function SCR_USE_PENGUINPACK_2016(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_006', 1, 'PENGUINPACK_2016');
    TxGiveItem(tx, 'food_penguin', 50, 'PENGUINPACK_2016');
    local ret = TxCommit(tx);
end

function SCR_USE_ADVENTURERPACK_2016(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_indunReset', 1, 'ADVENTURERPACK_2016');
    TxGiveItem(tx, 'Premium_boostToken', 3, 'ADVENTURERPACK_2016');
    TxGiveItem(tx, 'Event_drug_steam_1h', 2, 'ADVENTURERPACK_2016');
    local ret = TxCommit(tx);
end

function DLC_BOX8(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PremiumToken_15d', 1, 'DLC_BOX8');
    TxGiveItem(tx, 'Premium_eventTpBox_65', 1, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Premium_HP1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Premium_SP1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'RestartCristal', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Mic', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Premium_WarpScroll', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_STA1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Haste2_DLC', 30, 'DLC_BOX8');
    local ret = TxCommit(tx);
end

function SCR_USE_SET01_COMPANION_STEAM(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_009', 1, 'EGG009_PACK');
    TxGiveItem(tx, 'food_cereal', 50, 'EGG009_PACK');
    local ret = TxCommit(tx);
end
