function SCR_BEAUTY_SHOP_FASHION_DIALOG(self,pc) --
--    -- EVENT_1805_BEAUTY_NPC
--    EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, 1)
    local genderChk = pc.Gender;
    if genderChk == 1 then
        local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_3'), ScpArgMsg('Close'));
        if select == 1 then        
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
        elseif select == 2 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
        elseif select == 3 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PACKAGE", 0);
        -- elseif select == 4 then
        --     SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW", 0);
        end
    elseif genderChk ~= 1 then
        local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_3'), ScpArgMsg('Close'));
        if select == 1 then        
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
        elseif select == 2 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
        elseif select == 3 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PACKAGE", 0);
        -- elseif select == 4 then
        --     SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW", 0);
        end
    end
end
