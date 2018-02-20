--HIDDEN QUEST PRE CHECK FUNCTION
--UNDERFORTRESS67_HQ1 condition check
function UNDERFORTRESS67_HIDDENQ1_STEP1(pc, questname, scriptInfo)
    local map_Search1 = GetMapFogSearchRate(pc, "d_underfortress_65")
    local map_Search2 = GetMapFogSearchRate(pc, "d_underfortress_66")
    local map_Search3 = GetMapFogSearchRate(pc, "d_underfortress_67")
    local map_Search4 = GetMapFogSearchRate(pc, "d_underfortress_68")
    local map_Search5 = GetMapFogSearchRate(pc, "d_underfortress_69")
    
    if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil and map_Search4 ~= nil and map_Search5 ~= nil then
        if map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100 and map_Search4 >= 100 and map_Search5 >= 100 then
            return "YES"
        else 
            return "NO"
        end
    end
end

--FLASH63_HQ1 condition check
function FLASH63_HQ1_PRE_CHECK_FUNC(pc, questname, scriptInfo)
    local sObj = GetSessionObject(pc, "SSN_FLASH63_CONDI_CHECK") 
    if sObj ~= nil then
        if sObj.Goal1 == 1 then
            return 'YES'
        end
    end
end

--BRACKEN632_HQ1 condition check
function SCR_BRACKEN632_HQ1_PREFUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    if sObj ~= nil then
    --print(sObj.Step2, sObj.Goal2)
        if sObj.Step1 == 1 and sObj.Goal1 == 1 and
           sObj.Step2 == 1 and sObj.Goal2 == 1 and
           sObj.Step3 == 1 and sObj.Goal3 == 1 and
           sObj.Step4 == 1 and sObj.Goal4 == 1 then
           --print("22222")
           return 'YES'
        end
    end
end

--SIAULIAI16_HQ1 condition check
function SIAULIAI16_HQ1_STEP1(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI16_HQ1_UNLOCK1")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--ORSHA_HQ2 condition check
function ORSHA_HIDDENQ2_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--TABLELAND28_1_HQ1 condition check
function TABLELAND28_1_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_TABLELAND28_1_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--FLASH64_HQ1 condition check
function FLASH64_HQ1_STEP1(pc)
    local sObj = GetSessionObject(pc, "SSN_FLASH64_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--CASTLE65_3_HQ1 condition check
function CASTLE65_3_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_CASTLE65_3_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return "YES"
        end
    end
end

--UNDERFORTRESS69_HQ1 condition check
function UNDER69_HIDDENQ1_PRECHECK(pc, questname, scriptInfo)
    local sObj = GetSessionObject(pc, "SSN_UNDER69_HQ1_UNLOCK")
    if sObj == nil then
        return 'NO'
    elseif sObj ~= nil then
        if sObj.Step1 >= 1 then
            return 'YES'
        end
    end
end

--SIAULIAI15_HQ1 condition check
function SIAULIAI15_HIDDENTQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI15_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--KATYN12_HQ1 condition check
function KATYN12_HIDDENQ1_PRECHECK(pc)
    if isHideNPC(pc, "KATYN12_HQ1_NPC") == "NO" then
        return "YES"
    end
end

--PRISON62_2_HQ1 condition check
function SCR_PRISON622_HIDDENQ1_PRECHEKC(pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    if sObj~= nil then
        if sObj.Goal5 == 1 then
            return "YES"
        end
    end
end

--ORCHARD32_3_HQ1 condition check
function ORCHARD323_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_ORCHARD323_HQ1_UNLOCK") 
    if sObj ~= nil then
        if sObj.Step1  >= 1 then
            return 'YES'
        end
    end
end


--ABBEY64_2_HQ1 condition check
function ABBEY64_2_HIDDENQ1_PRECHECK(pc)
    local map_Search1 = GetMapFogSearchRate(pc, "d_abbey_64_1")
    local map_Search2 = GetMapFogSearchRate(pc, "d_abbey_64_2")
    local map_Search3 = GetMapFogSearchRate(pc, "d_abbey_64_3")

    if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil then
        if map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100 then
            return "YES"
        end
    end
end

--PILGRIM31_3_HQ1 condition check
function PILGRIM31_3_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM313_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--PILGRIMROAD362_HQ1 condition check
function PILGRIMROAD362_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--PILGRIM48_HQ1 condition check
function PILGRIM48_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--REMAINS38_HQ1 condition check
function REMAINS38_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_REMAINS38_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--THORN22_HQ1 condition check
function THORN22_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_THORN22_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end


--CHATHEDRAL54_HQ1 condition check
function CHATHEDRAL54_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_CHATHEDRAL54_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--SIAULIAI462_HQ1 condition check
function SIAULIAI462_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--REMAINS373_HQ1 condition check
function REMAINS373_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_REMAINS373_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--CATHEDRAL1_HQ1 condition check
function CATHEDRAL1_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_CATHEDRAL1_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--CATACOMB38_2_HQ1 condition check
function CATACOMB38_2_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_CATACOMB382_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--FLASH29_1_HQ1 condition check
function FLASH29_1_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--SIAULIAI_351_HQ1 condition check


--ABBEY353_HQ1 condition check


--ORCHARD343_HQ1 condition check
function ORCHARD343_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_ORCHARD343_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--TABLELAND70_HQ1 condition check
function TABLELAND70_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_TABLELAND70_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--WTREES22_1_SQ1 is not HiddenQuest. This quset is Normal sub qeust
function WTREES22_1_SQ1_PRECHECK(pc)
    if GetZoneName(pc) == "f_whitetrees_22_1" then
--        local quest = SCR_QUEST_CHECK(pc, "WTREES22_1_SQ1")
        local sObj = GetSessionObject(pc, "SSN_WTREES221_SUBQ1_PRECHECK")
--        if quest == "IMPOSSIBLE" then
            if sObj ~= nil then
                if sObj.Goal1 >= 1 then
                    return "YES"
                end
            end
--        end
    end
end


----GELE_57_3_HQ_01_QUEST CHECK FUNCTION
function GELE_57_3_HQ_01_OPEN(pc, questname, scriptInfo)
--    local main_ssn = GetSessionObject(pc, "ssn_klapeda")
    
    local MonWiki_Point = GET_ADVENTURE_BOOK_MONSTER_POINT(pc)
    
    local item1 = GetInvItemCount(pc, "misc_0013")
    local item2 = GetInvItemCount(pc, "misc_0018")
    local item3 = GetInvItemCount(pc, "misc_0048")
    local item4 = GetInvItemCount(pc, "misc_0061")
    
--    if main_ssn.GELE_57_3_HQ_01 ~= 0 then
--        return "YES"
--    end
    
    if MonWiki_Point >= 100 and item1 >= 60 and item2 >= 60 and item3 >= 60 and item4 >= 60 then
        return "YES"
    else
        return "NO"
    end
end