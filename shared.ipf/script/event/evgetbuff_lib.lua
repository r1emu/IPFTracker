function SCR_GETBOXBUFF(self, pc, argNum, evt)
-- �߰��� ���� �߰� ��, Map.xmld�� ����ġ�� Ư�� �÷����� �����Ͽ� �з��ϴ� ��� ���
        local box_pos = GetZoneName(self)
        
        if box_pos == "f_siauliai_west" or box_pos == "f_siauliai_est" then
            local bufferking = GetClassString("Buff", "beginner_ExpUp_20", "Name");
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll', bufferking..ScpArgMsg("Auto__BeoPeu_HoegDeug"), 4)
    		AddBuff(pc, pc, 'beginner_ExpUp_20');
    	else
            local bufferking = GetClassString("Buff", "Colletor_Etc_Low", "Name");
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll', bufferking..ScpArgMsg("Auto__BeoPeu_HoegDeug"), 4)
    		AddBuff(pc, pc, 'Colletor_Etc_Low');
    	end
end
