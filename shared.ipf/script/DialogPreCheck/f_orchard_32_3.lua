function SCR_ORCHARD323_HIDDEN_OBJ2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND28_1_HQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
