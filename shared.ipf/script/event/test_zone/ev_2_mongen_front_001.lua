

g_table_test_zone_ev_2_mongen_front_001 = 
{
		{
		},


		{
			
		},


		{
			"Skrik", -15.206596, -0.024069, 219.778885, 147.842300, 

		},


		{
			"CheckAttack", "1", "GenType", "1102005", 
		},
};


function test_zone_ev_2_mongen_front_001_init(self)

	local sObj = CREATE_SOBJ(self, 'ssn_bgevent')
	RegisterHookMsg(self, sObj, 'TakeDamage', 'TAKEDAMAGE_TEST_ZONE_EV_2_MONGEN_FRONT_001', 'NO');

end

function TAKEDAMAGE_TEST_ZONE_EV_2_MONGEN_FRONT_001(self, sObj, msg, argObj, argStr, argNum)

	ExecBGEvent(self, argObj, 'test_zone_ev_2_mongen_front_001', argNum);

end

function test_zone_ev_2_mongen_front_001_cond(pc, npc, argNum, evt)

		if

		GetMapNPCState(pc, evt.genType) == 0

		

then

			return 1;

		

end;

		return 0;



end

function test_zone_ev_2_mongen_front_001_act(self, pc, argNum, evt)

		local tx = TxBegin(pc);

		TxChangeNPCState(tx, evt.genType, 1);

		local ret = TxCommit(tx);

		SCR_EVENT_AROUND_MONGEN(self, pc, evt, 4)



end


