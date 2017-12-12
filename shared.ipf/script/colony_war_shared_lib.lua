function GET_COLONY_MAP_GRADE_AND_PERCENTAGE(mapLevel)
--정식에서는 해당 로직 이용
--    if mapLevel < 200 then
--        return 'B', 4;
--    elseif mapLevel < 300 then
--        return 'A', 5;
--    end
--    return 'S', 6;

--Beta에서는 해당 로직 이용
    if mapLevel < 200 then
        return 'B', 0;
    elseif mapLevel < 300 then
        return 'A', 0;
    end
    return 'S', 0;
end

function GET_COLONY_WAR_DAY_OF_WEEK()
    local guild_colony_rule = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    local dayOfWeek = TryGetProp(guild_colony_rule, 'ColonyStartDayOfWeek');    
    return dayOfWeek;
end

function GET_COLONY_REWARD_ITEM()
    local guild_colony_rule = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    local rewardItem = TryGetProp(guild_colony_rule, 'RewardItem');
    if rewardItem == nil then
        return 'None';
    end
    return rewardItem;
end

function IS_COLONY_SPOT(mapClassName)
    local colonyClsList, cnt = GetClassList('guild_colony');    
    for i = 0, cnt - 1 do
        local colonyCls = GetClassByIndexFromList(colonyClsList, i);
        local mapClsName = TryGetProp(colonyCls, 'ZoneClassName');
        if mapClsName ~= nil and mapClsName == mapClassName then
            return true;
        end
    end
    return false;
end

function IS_COLONY_MONSTER(monID)
    local monCls = GetClass('Monster', GET_COLONY_MONSTER_CLASS_NAME());
    if monCls ~= nil and monCls.ClassID == monID then
        return true;
    end
    return false;
end

function GET_COLONY_CLASS(zoneName)
    local clsList, cnt = GetClassList('guild_colony');
    for i = 0, cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        if cls.ZoneClassName == zoneName then
            return cls;
        end
    end
    return nil;
end

function GET_COLONY_TOWER_RANGE(zoneName)
    local colonyCls = GET_COLONY_CLASS(zoneName);
    if colonyCls == nil then
        return 0;
    end
    return colonyCls.TowerRange;
end

function GET_COLONY_MONSTER_CLASS_NAME()
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    return ruleCls.GuildColonyBossClassName;
end

function GET_COLONY_TOWER_CLASS_NAME()
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    return ruleCls.GuildColonyTowerClassName;
end