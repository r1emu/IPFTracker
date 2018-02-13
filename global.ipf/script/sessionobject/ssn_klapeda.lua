﻿function SCR_SSN_KLAPEDA_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if SHARE_QUEST_PROP(self, party_pc) == true then
        if GetLayer(self) ~= 0 then
            if GetLayer(self) == GetLayer(party_pc) then
                SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
            end
        else
            SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
        end
    end

    --EVENT_STEAM_SECRET_NIGHT_MARKET
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_EVENT_SECRET_MARKET_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
    end
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    CHECK_CHALLENGE_MODE(self, argObj);

    --EVENT_STEAM_SECRET_NIGHT_MARKET
    SCR_EVENT_SECRET_MARKET_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
end