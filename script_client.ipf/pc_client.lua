-- pc_clinet.lua

function GET_CASH_TOTAL_POINT_C()
	local aobj = GetMyAccountObj();
	-- PremiumMedal : ���� ���� TP, Medal : ����TP, GiftMedal : �ؽ� service TP
	return aobj.Medal + aobj.GiftMedal + aobj.PremiumMedal;
en