function SCR_REMAIN37_WILDFLOWER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_REMAIN37_MQ03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end




function SCR_REMAIN37_MQ04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_REMAIN37_MQ05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAIN37_MQ05_MON_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end




function SCR_REMAIN37_SQ04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
en