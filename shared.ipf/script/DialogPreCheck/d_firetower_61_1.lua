function SCR_FD_FTOWER611_TYPE_B_ROAMER_NPC_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'FD_FIRETOWER611_T02_ROMER_CK');
    if buff ~= nil then
        return 'NO'
    end
    return 'YES'
en