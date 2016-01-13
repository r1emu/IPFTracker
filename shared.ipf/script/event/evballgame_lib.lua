function SCR_EVBALLGAME_DIALOG(self,pc, target_item_classid)
    if GetMapNPCState(pc, GetGenType(self)) >= 1 then
        ChatLocal(self, pc, ScpArgMsg("Auto_Bin_SangJa"))
        PlayAnimLocal(self, pc,'ON',1)
    else
        local target_item = GetClassByNumProp('Item', 'ClassID',target_item_classid)
        ChatLocal(self, pc, target_item.Name..ScpArgMsg("Auto__DeuLap"))
    end 
end     
        
function SCR_EVBALLGAME_COND(pc, npc, evt)
    if GetMapNPCState(pc, evt.genType) == 0 then
        if GetInvItemCount(pc, 'PuzzleBoxKey') > 0 then
            return 1;
        else
            local target_item = GetClass('Item', 'PuzzleBoxKey')
            ChatLocal(npc, pc, target_item.Name..ScpArgMsg("Auto__BuJog"))
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_'PeoJeul_SangJa_yeolSoe'Ka_inBenToLie_isseuMyeon_Sayong_KaNeung!"), 5);
        end
    else
        local ssn_name = 'ssn_'..GET_EVENT_NAME(npc)
        local sObj = GetSessionObject(pc, ssn_name) 
        if sObj ~= nil then
            ChatLocal(npc, pc, ScpArgMsg("Auto_ChaeTingChange_SeoLoDaLeun_SeJaLi_SusJa_ipLyeog"))
        else
            ChatLocal(npc, pc, ScpArgMsg("Auto_Bin_SangJa"))
            PlayAnimLocal(npc, pc,'ON',1)
        end
    end

	return 0;
end

function SCR_EVBALLGAME_ACT(self,pc, target_item_classid, drop_item_classid)
--    local target_item = GetClassByNumProp('Item', 'ClassID',target_item_classid)
    local ssn_name = 'ssn_'..GET_EVENT_NAME(self)
--    if drop_item_classid == target_item_classid then
    local sObj = GetSessionObject(pc, ssn_name) 
    if sObj == nil then
        CreateSessionObject(pc, ssn_name, 1)
--        target_item = GetClassByNumProp('Item', 'ClassID',target_item_classid)
        TAKE_ITEM_TX(pc, 'PuzzleBoxKey', 1)
        ChatLocal(self, pc, ScpArgMsg("Auto_ChaeTingChange_SeoLoDaLeun_SeJaLi_SusJa_ipLyeog"))
    else
        ChatLocal(self, pc, ScpArgMsg("Auto_DongJag_Jung,_ChaeTingChange_SeoLoDaLeun_SeJaLi_SusJa_ipLyeog"))
    end
        
--    else
--        ChatLocal(self, pc, target_item.Name..ScpArgMsg("Auto__DeuLap"))   
--    end
end

function SCR_CREATE_ssn_evballgame(self, sObj)
    local num1 = IMCRandom(1,9)
	local num2 = IMCRandom(0,9)
	local num3 = IMCRandom(0,9)
	
	while num1 == num2 do
	    num2 = IMCRandom(0,9)
	end
	
	while num1 == num3 or num2 == num3 do
	    num3 = IMCRandom(0,9)
	end
	
	sObj.Goal1 = num1
	sObj.Goal2 = num2
	sObj.Goal3 = num3
	
	RegisterHookMsg(self, sObj, "Chat", "SCR_"..sObj.Script.."_Chat", "NO")
end


function SCR_ssn_evballgame_Chat(self, sObj, argStr, event_name, reward_itemname,reward_itemcount)
    local fndList, fndCount = SelectObject(self, 40, 'ALL');
    local flag = 0
    
    if fndCount <= 0 then
        return
    end
    
	for index = 1, fndCount do
		if fndList[index].ClassName ~= 'PC' then
			if GET_EVENT_NAME(fndList[index]) == event_name then
			    local chat_num = tonumber(argStr)
			    if chat_num ~= nil and chat_num >= 100 and chat_num <= 999 then
			        local result_s = 0
			        local result_b = 0
			        
			        local chat_num_list = {}
			        chat_num_list[1] = tonumber(string.sub(chat_num,1,1))
			        chat_num_list[2] = tonumber(string.sub(chat_num,2,2))
			        chat_num_list[3] = tonumber(string.sub(chat_num,3,3))
			        if chat_num_list[1] ~= chat_num_list[2] and chat_num_list[1] ~= chat_num_list[3] and chat_num_list[2] ~= chat_num_list[3] then
			            sObj.Count = sObj.Count + 1
			            
			            local i, j
			            for i = 1, 3 do
			                if chat_num_list[i] == sObj['Goal'..i] then             -- ��Ʈ����ũ üũ
			                    result_s = result_s + 1
			                else
			                    for j = 1, 3 do
			                        if chat_num_list[i] == sObj['Goal'..j] then     -- �� üũ
			                            result_b = result_b + 1
			                        end
			                    end
			                end
			            end
			            if result_s == 3 then
			                
			                local reward_item
			                
			                if GetClass('Recipe', reward_itemname) == nil then
			                    reward_item = GetClass('Item', reward_itemname)
			                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', reward_item.Name..ScpArgMsg("Auto__HoegDeug"), 4)
			                end
			                
			                PlayAnimLocal(fndList[index], self,'ON',1)
                        	ChatLocal(fndList[index],self,sObj.Count..ScpArgMsg("Auto_Hoe_")..ScpArgMsg("Auto_SeongKong"))
                        	RunScript('SCR_NPCSTATE_CHANGE', self, fndList[index], sObj.Count)
			                RunScript('GIVE_EVENTEXPUP_ITEM_TX', fndList[index], self, reward_itemname, reward_itemcount, 'EVENT')
			                DestroySessionObject(self, sObj)
			            else
--                            if sObj.Count == 10 then
--                                SendAddOnMsg(self, 'NOTICE_Dm_!', sObj.Count..ScpArgMsg("Auto_Hoe_SilPae,_aiTem_DeuLap_Si_JaeSiJag_KaNeung"), 4)
--                                RunScript('SCR_NPCSTATE_CHANGE', self, fndList[index], 0)
--                                DestroySessionObject(self, sObj)
--                                return
--                            end

    			            ChatLocal(fndList[index],self,sObj.Count..ScpArgMsg("Auto_Hoe_")..result_s.."S : "..result_b.."B")
    			        end
			        else
			            ChatLocal(fndList[index],self,ScpArgMsg("Auto_SeJaLi_SusJaKa_KagKag_DalLayaHam"))
			            -- ���ڸ� ���ڰ� ���� �޶����
			        end
			    else
			        ChatLocal(fndList[index],self,ScpArgMsg("Auto_SeJaLi_SusJaKa_aNim"))
			        -- ���ڸ� ���ڰ� �ƴ�
			    end
			    
			    flag = flag + 1
			    
			    return
			end
		end
	end
	
	if flag == 0 then
	    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("Auto_JuByeone_SusJa_MajChuKi_SangJa_eopeum"), 4)
	end
end


