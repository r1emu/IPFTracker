-- pc�� �ٲ�
function EV_TREE_ATK_LIB(pc, x, y, z, xacClassName, xacModelName)
	
    local pc_usingskill = GetUsingSkill(pc)
    if GetXacState(pc, xacClassName) == 0 then
        if pc_usingskill.ClassName == 'Normal_Attack' or pc_usingskill.ClassName == 'Magic_Attack' or pc_usingskill.ClassName == 'Bow_Attack' then
            PlayEffectToGround(pc, 'F_namu', x, y, z, 0.5, 1.3);
            return 1;
        end
    end
    return 0;
end

function EV_TREE_ATK_REWARD(pc, x, y, z, xacClassName, xacModelName)
    RunScript('EV_TREE_ATK_RUN', pc, x, y, z, xacClassName, xacModelName)

end

function EV_TREE_ATK_RUN(pc, x, y, z, xacClassName, xacModelName)
    local pc_x, pc_y, pc_z = GetPos(pc)

    local tx = TxBegin(pc);
    
    PlaySound(pc, 'money_jackpot')
    
    XAC_EVENTEXPUP(pc, pc_x, pc_y, pc_z, tx)
    
    TxSetXacState(tx, xacClassName, 1)
    
    local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	   DROP_XACEVENT(pc, pc_x, pc_y, pc_z, 'Vis', IMCRandom(13, 18))
	end

end

--
--function SCR_SKILL_TENT(self, x, y, z, xacClassName, xacModelName)
--
--  -- ���� �����ϸ��ϸ� 1����. ����ũ��Ʈ ����Ѱ� �����Ŵ.
--  return 1;
--  
--  -- ���� �Ҹ����ϸ� 0����
----  return 0;
--end
--
--function SCR_TEST(self, x, y, z, xacClassName, xacModelName)
--
--end
