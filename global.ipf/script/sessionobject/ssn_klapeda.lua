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
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    CHECK_CHALLENGE_MODE(self, argObj);
---- ID_WHITETREES1
    if GetZoneName(self) == 'id_whitetrees1' then
        if argObj.ClassName == 'ID_umblet' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_01', 1, 'INDUN_330')
            end
        elseif argObj.ClassName == 'ID_kucarry_Tot' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_02', 1, 'INDUN_330')
            end
        elseif argObj.ClassName == 'ID_kucarry_lioni' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_03', 1, 'INDUN_330')
            end
        end
    end
end
