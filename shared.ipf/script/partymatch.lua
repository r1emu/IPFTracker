
-- �� �� �׸��� ����
WEIGHT_MEMBER_COUNT = 200 -- �ο����� ���� ����
WEIGHT_DISTANCE = 500 -- �Ÿ��� ���� ����
WEIGHT_JOB_VALANCE = 100 -- ���� ������ ���� ����
WEIGHT_QUEST = 1000 -- ����Ʈ�� ���� ����
WEIGHT_LEVEL = 500 -- ������ ���� ����
WEIGHT_RELATION = 1300 -- ���ΰ��� ģ�е��� ���� ����(���� ����)
WEIGHT_ITEM_GRADE = 100 -- ������ ��޿� ���� ����
WEIGHT_REPUTATION = 200 -- ���ǿ� ���� ����

SUM_OF_ALL_WEIGHT = WEIGHT_MEMBER_COUNT + WEIGHT_DISTANCE + WEIGHT_JOB_VALANCE + WEIGHT_QUEST + WEIGHT_LEVEL + WEIGHT_RELATION + WEIGHT_ITEM_GRADE + WEIGHT_REPUTATION

-- ��Ÿ ��� ����
minus_infinity = -999999
DISTANCE_PENALTY_PER_WARPCOST = 2 -- ���ӻ��� ���� ���(�ǹ�)�� �������� ���. �Ÿ� �˻� �� ���
EACH_QUEST_BOUNS = WEIGHT_QUEST/5 -- �� ����Ʈ���� �߰���
RELATION_UP_BOUND = 2000 -- �� �̻��̸� ����
RELATION_DOWN_BOUND = -2000 -- �� ���ϸ� ������
REPUTATION_MAX_DIF = 2000 -- �� �̻� ���̳��� 0���ش�.

-- ����Ƽ �� ��� ����
ADD_MEMBER_PENALTY = 1000 -- �� ����� �߰����� �� �ȵ� ��Ƽ��� ���Ƽ ������ �ִ�.
GAP_OF_LAST_MEMBER_ADDED_MINUTE = 15  --�� ������ �Ǵ� �ð�.

-- ���߿� �α� ���
PARTY_MATCH_SHOWLOG = false



-- ��Ƽ ��ġ ����ŷ ���� �۷ι� ���� �Լ�
-- ��Ƽ ��� ������ ������Ʈ �ǰ� ���� ����. �ʿ��� ��� �ǵ��� �߰��ؼ� �� ��. ZS_PARTY_BROADCAST �Ҷ� �۷ι��� ���� ���ָ� �� ��.
function PARTY_MATCHMAKING_CALC(pSession, pParty) -- (��õ���� �˻��� ���� ����, for������ ������ �� ��Ƽ)

	local SUM_OF_MY_WEIGHT = 0
	
	-- 1. �ʱ�ȭ. Bind �� ������Ʈ �˻�
	local session, sessionPcObj, party, partyobj, partymemberlist = PARTY_MATCHMAKING_INIT_OBJ(pSession,pParty)
	if session == false then
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	-- ���� ����
	local SUM_OF_MY_WEIGHT = 0
	local mainreasonAddvalue = 0 
	local matchscore = 0 -- �� ���� ���� ����
	local mainreason = PARTY_RECOMMEND_TYPE_COUNT -- ���� ��õ Ÿ��
	

	-- 2. �� ���� �ݵ�� �������� �ϴ� ���ǵ� �˻�. ���⼭ ���ܵǸ� �ƿ� ��õ���� ����.
	if PARTY_MATCHMAKING_PRE_CONDITION_CHECK(session, sessionPcObj, party, partyobj, partymemberlist) == false then
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	--66
	--3. ��Ƽ�� ���� ���� ���� ���(+)
	if partyobj["PartyMatch_UseETC"] == 1 then -- 65
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_MEMBER_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_MEMBER_COUNT
	end

	--4. �Ÿ��� ���� ���� ���(+)
	if partyobj["PartyMatch_UseDistance"] == 1 then --63
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_DISTANCE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_DISTANCE
	end

	--5. ���� �뷱���� ���� ���� ���(+)
	if partyobj["PartyMatch_UseJob"] == 1 then -- 61
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_JOBVAL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_JOB_VALANCE
	end

	--6. ����Ʈ ���� ���¿� ���� ���� ���(+)
	if partyobj["PartyMatch_UseQuest"] == 1 then -- 41
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_QUEST_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_QUEST
	end

	--7. ���� ���̿� ���� ���� ���(+)
	if partyobj["PartyMatch_UseLevel"] == 1 then -- 62
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_LEVEL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_RELATION
	end

	--8. ������ ����ϴٸ� �߰� ��(+)
	if partyobj["PartyMatch_UseETC"] == 1 then -- 63
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_REPUTATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_REPUTATION
	end

	--9. ���� �� ������ ����� ����ϴٸ� �߰���(+)
	if partyobj["PartyMatch_UseETC"] == 1 then --66
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_ITEMGRADE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_ITEM_GRADE
	end

	--10. ���� ���� : ���� ���� ���� ���迴�ٸ� �߰�/���� (+-)
	if partyobj["PartyMatch_UseRelation"] == 1 then -- 65
		matchscore, mainreason, mainreasonAddvalue = PARTY_MATCHMAKING_CALC_RELATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  matchscore, mainreason, mainreasonAddvalue)
		SUM_OF_MY_WEIGHT = SUM_OF_MY_WEIGHT + WEIGHT_RELATION
	end
	
	if SUM_OF_MY_WEIGHT == 0 or mainreason == PARTY_RECOMMEND_TYPE_COUNT then
		if PARTY_MATCH_SHOWLOG == true then
			print('�� �ϳ��� �׸� üũ ���Ѵٸ� �н� : ')
		end
		return minus_infinity, PARTY_RECOMMEND_TYPE_COUNT
	end

	matchscore = SUM_OF_ALL_WEIGHT * matchscore / SUM_OF_MY_WEIGHT

	--11. �ֱٿ� �� ����� �߰��ߴٸ� ���� (-)
	local lasetMemberAddTime = partyobj["LastMemberAddedTime"]
	if lasetMemberAddTime < 0 then
		lasetMemberAddTime = 0
	end

	if GetFloatDBTime() < lasetMemberAddTime + GAP_OF_LAST_MEMBER_ADDED_MINUTE then
		matchscore = matchscore - ADD_MEMBER_PENALTY;
		if PARTY_MATCH_SHOWLOG == true then
			print('�ֱٿ� �� ����� �߰��ߴٸ� ����. ���� �� ���� : '..matchscore)
		end
	end
	
	--12. �ֱٿ� �� ����� �߰��ߴٸ� ���� (-)
	matchscore = matchscore + party:IsAlreadyRecommendAccount(session:GetAID());

	if party:IsAlreadyRecommendAccount(session:GetAID()) < 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('�̹� �� ��Ƽ�� ��õ�ߴ� ����̶�� Ƚ���� x���� ����. ���� �� ���� : '..matchscore)
		end
	end
	


	if PARTY_MATCH_SHOWLOG == true then
		print('���� ���� : '..matchscore..' / ���� ���� ���� : ' .. mainreason)
		print('=======================================================')
		print('')
		print('')
	end

	return matchscore, mainreason

end

function IS_CTRLTYPE_MATCHING_RECRUIT_WITH_PC(jobname, recruittype)

	local num = recruittype
	local calcresult={}
	local i = 0
	
	while num > 0 do -- ��Ʈ������ ���� 2���� ��ȯ.
		
		calcresult[i] = num%2
		num = math.floor(num/2)
		i = i + 1
		if num < 1 then
			break;
		end
	end

	local pcjobinfo = GetClass('Job', jobname)

	if pcjobinfo == nil then
		return 0
	end

	local ctrlType = 0;
	if pcjobinfo.CtrlType == 'Warrior' and calcresult[0] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Wizard' and calcresult[1] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Archer' and calcresult[2] == 1 then
		return 1
	elseif pcjobinfo.CtrlType == 'Cleric' and calcresult[3] == 1 then
		return 1
	end

	return 0
end


function PARTY_MATCHMAKING_INIT_OBJ(pSession, pParty)
	
	local session = tolua.cast(pSession, "USER_SESSION")

	if pParty == nil or session == nil then
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pParty == nil or session == nil');
		end
		return false
	end

	local party = tolua.cast(pParty, "CParty")
	local pPartyobj = party:GetObject()
	local partyobj = nil
	if pPartyobj ~= nil then
		partyobj = GetIES(pPartyobj)
		if partyobj == nil then
			if PARTY_MATCH_SHOWLOG == true then
				print('FAIL : partyobj == nil');
			end
			return false
		end
	else
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pPartyobj == nil');
		end
		return false
	end


	local sessionPcObj = nil

	local pSessionPcObj = session:GetPcObject()
	if pSessionPcObj ~= nil then
		sessionPcObj = GetIES(pSessionPcObj)
		if sessionPcObj == nil then
			if PARTY_MATCH_SHOWLOG == true then
				print('FAIL : pSessionPcObj == nil');
			end
			return false
		end
		
	else
		if PARTY_MATCH_SHOWLOG == true then
			print('FAIL : pSessionPcObj == nil');
		end
		return false
	end

	local memcount = party:GetMemberCount()
	local memlist = {}

	for i = 0 , memcount - 1 do
		local pMeminfo = party:GetMemberByIndex(i);

		if pMeminfo ~= nil then

			local meminfo = tolua.cast(pMeminfo, "PARTY_COMMANDER_INFO")

			memlist[i+1] = {}
			memlist[i+1]["Info"] = meminfo

			local memsession = GetSessionByFamilyName(meminfo:GetName());

			if memsession ~= nil then
				memlist[i+1]["Session"] = memsession
			else
				memlist[i+1]["Session"] = nil
			end

		end
		
	end



	return session, sessionPcObj, party, partyobj, memlist

end


function PARTY_MATCHMAKING_PRE_CONDITION_CHECK(session, sessionPcObj, party, partyobj, partymemberlist)	

	--����� ��Ƽ�� ����
	if partyobj["UsePartyMatch"] == 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('��Ƽ ��ġ �ɼ� ��� ���Ѵٸ� ����')
		end
		return false
	end

	-- �������� ����� ���ų� �ڸ��� �� á� ����
	if party:GetAliveMemberCount() <= 0 or party:IsFullParty() == true then
		if PARTY_MATCH_SHOWLOG == true then
			--print('�������� ����� ���ų� �ڸ��� �� á� ����')
		end
		return false
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� : '..session.familyName..' ��Ƽ���� : '..party:GetLeaderName())
	end

	-- ������ �������� �ƴ϶�� ����
	if party:GetLeaderInfo():GetMapID() == 0 then
		if PARTY_MATCH_SHOWLOG == true then
			print('������ �������� �ƴ϶�� ����')
		end
		return false
	end

	-- ��Ƽ �ɼǿ��� ���� ���� ��� ���̰� ��õ�� ������ �� ������ �������� ���Ѵٸ�
	if partyobj["UseLevelLimit"] == 1 then
		if sessionPcObj.Lv < partyobj["MinLv"] or sessionPcObj.Lv > partyobj["MaxLv"] then
			if PARTY_MATCH_SHOWLOG == true then
				print('��Ƽ �ɼǿ��� ���� ���� ��� ���̰� ��õ�� ������ �� ������ �������� ���Ѵٸ� ����')
			end
			return false
		end
	end

	-- ��Ƽ �ɼǿ��� ���� �迭 ������ ��� ���̰� ��õ�� ������ �� ���ǰ� ��߳��ٸ� ����
	if IS_CTRLTYPE_MATCHING_RECRUIT_WITH_PC(sessionPcObj.JobName, partyobj["RecruitClassType"]) ~= 1 then
		if PARTY_MATCH_SHOWLOG == true then
			print('��Ƽ �ɼǿ��� ���� �迭 ������ ��� ���̰� ��õ�� ������ �� ���ǰ� ��߳��ٸ� ����')
		end

		return false
	end

	local memcount = #partymemberlist

	--������ ��Ƽ������ ģ���̰ų� �� ���� ����
	for i = 1 , memcount do

		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		if memsession == nil or session == nil then
			return false
		end

		if session:IsFriendOrBlock(meminfo:GetAID()) == true or memsession:IsFriendOrBlock(session:GetAID()) then
			if PARTY_MATCH_SHOWLOG == true then
				print('������ ��Ƽ������ ģ���̰ų� �� ���� ����')
			end
			return false
		end

	end

	return true
end


function PARTY_MATCHMAKING_CALC_MEMBER_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local maxMemcountPoint = WEIGHT_MEMBER_COUNT;
	maxMemcountPoint = maxMemcountPoint - (((5 - 1) - memcount) * (maxMemcountPoint / (5 - 1))); --�Ѹ� �����ø��� 50���� ����
	maxMemcountPoint = maxMemcountPoint - ((memcount - party:GetAliveMemberCount()) * ((maxMemcountPoint / 2) / (5 - 1))); --�Ѹ� �����ӽø��� 25���� ����


	local matchscore = nowmatchscore + maxMemcountPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxMemcountPoint > mainreasonAddvalue then
		mainreasonAddvalue = maxMemcountPoint;
		mainreason = PARTY_RECOMMEND_TYPE_MEMCOUNT;
	end
	
	if PARTY_MATCH_SHOWLOG == true then
		print('��Ƽ�� ���� ���� �߰��� : '..maxMemcountPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_DISTANCE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local maxWarpCostPoint = WEIGHT_DISTANCE;
	local depmapcls = GetClassByType("Map", session.mapID);
	local dstmapcls = GetClassByType("Map", party:GetLeaderInfo():GetMapID());
	local warpCost = -999999;
	if depmapcls ~= nil and dstmapcls ~= nil then
		warpCost = CalcWarpCost(dstmapcls.ClassName, depmapcls.ClassName);
	end
	if warpCost < 0 then
		warpCost = -999999;
	end

	if warpCost >= 0 then
		maxWarpCostPoint = maxWarpCostPoint - (warpCost * DISTANCE_PENALTY_PER_WARPCOST);
	else
		maxWarpCostPoint = 0
	end

	if maxWarpCostPoint < 0 then
		maxWarpCostPoint = 0;
	end

	
	local matchscore = nowmatchscore + maxWarpCostPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxWarpCostPoint > mainreasonAddvalue then
		mainreasonAddvalue = maxWarpCostPoint;
		mainreason = PARTY_RECOMMEND_TYPE_DISTANCE;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� ��ġ�� ���� �߰��� : '..maxWarpCostPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_JOBVAL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local maxJobBalancePoint = WEIGHT_JOB_VALANCE;
	local jobBalanceFactor = maxJobBalancePoint * 5; -- �־��� ��� 0���� �ǵ���.
	maxJobBalancePoint = maxJobBalancePoint + (((1 / 2) - (2 / 3))*jobBalanceFactor); --�ְ��� ��츦 �̸� ������ �ִ� ������ ���ߵ���.
	local nowjobdiffcount = 0;
	local tempstring = "";

	for i = 1 , #partymemberlist do
		local meminfo = partymemberlist[i]["Info"]
		local jobclass = GetClassByType("Job", meminfo:GetIconInfo().job);
		 
		if jobclass ~= nil then
			if string.find(tempstring,jobclass.CtrlType) == nil then
				tempstring = tempstring .. jobclass.CtrlType
				nowjobdiffcount = nowjobdiffcount + 1
			end
		end
	end

	local nowBalancePoint = nowjobdiffcount / memcount;
	local sessionjobclass = GetClass("Job", sessionPcObj.JobName);

	if sessionjobclass == nil then
		maxJobBalancePoint = 0
	else
		if string.find(tempstring, sessionjobclass.CtrlType) == nil then
			tempstring = tempstring .. sessionjobclass.CtrlType
			nowjobdiffcount = nowjobdiffcount + 1
		end
		local newBalancePoint = nowjobdiffcount / (memcount + 1);

		maxJobBalancePoint = maxJobBalancePoint - ( (nowBalancePoint - newBalancePoint) *jobBalanceFactor);

		if maxJobBalancePoint < 0 then
			maxJobBalancePoint = 0;
		end
	end

	local matchscore = nowmatchscore + maxJobBalancePoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if maxJobBalancePoint > mainreasonAddvalue then
		mainreasonAddvalue = maxJobBalancePoint;
		mainreason = PARTY_RECOMMEND_TYPE_JOBVAL;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� �������� ���� �߰��� : '..maxJobBalancePoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_QUEST_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local maxQuestPoint = WEIGHT_QUEST;
	local nowQuestPoint = 0;
	local questPointFactor = EACH_QUEST_BOUNS; --1�� ���� ������ ���� 200��.

	if partyobj["IsQuestShare"] == 1 then

		local leadersession = GetSessionByFamilyName(party:GetLeaderName());
		if leadersession ~= nil then

			local leaderQGroup = {}
			local sessionQGroup = {}

			for i = 0, 10 -1 do
				local questid = session:GetCheckQuestByIndex(i)
				
				local questIES = GetClassByType("QuestProgressCheck", questid);
				if questIES ~= nil then

					local questclsName = questIES.ClassName
					
					if questclsName ~= "None" and questclsName ~= nil then

						local questGroupName = questIES.ClassName

						if questIES.QuestGroup ~= "None" then
							local strFindStart, strFindEnd = string.find(questIES.QuestGroup, "/");
							if strFindStart ~= nil then
								questGroupName  = string.sub(questclsName, 1, strFindStart-1);
							end
						end

						if sessionQGroup[questGroupName] == nil then
							sessionQGroup[questGroupName] = "Exist"
						end
								
					end

				end
			end

			for i = 0, 10 -1 do
				local questid = leadersession:GetCheckQuestByIndex(i)
				
				local questIES = GetClassByType("QuestProgressCheck", questid);
				if questIES ~= nil then

					local questclsName = questIES.ClassName

					if questclsName ~= "None" and questclsName ~= nil then

						local questGroupName = questIES.ClassName

						if questIES.QuestGroup ~= "None" then
							local strFindStart, strFindEnd = string.find(questIES.QuestGroup, "/");
							if strFindStart ~= nil then
								questGroupName  = string.sub(questclsName, 1, strFindStart-1);
							end
						end

						if leaderQGroup[questGroupName] == nil then
							leaderQGroup[questGroupName] = "Exist"
						end
								
					end

				end
			end

			for k,v in pairs(leaderQGroup) do
				if sessionQGroup[k] ~= nil then
					nowQuestPoint = nowQuestPoint + questPointFactor;
				end
			end

		end
	end

	if nowQuestPoint > maxQuestPoint then
		nowQuestPoint = 0;
	end

	local matchscore = nowmatchscore + nowQuestPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if nowQuestPoint > mainreasonAddvalue then
		mainreasonAddvalue = nowQuestPoint;
		mainreason = PARTY_RECOMMEND_TYPE_QUEST;
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('����Ʈ ���¿� ���� �߰��� : '..nowQuestPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_LEVEL_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local retleveldiff = 0

	for i = 1 , #partymemberlist do
	
		local meminfo = partymemberlist[i]["Info"]
		local memsession = GetSessionByFamilyName(meminfo:GetName());

		if memsession ~= nil then
			local pmemPcObj = memsession:GetPcObject()
			
			if pmemPcObj ~= nil and sessionPcObj ~= nil then
				
				local memsessionpcObj = GetIES(pmemPcObj)
				if memsessionpcObj ~= nil then
					
					local lvdiff = math.abs((memsessionpcObj.Lv*1.1) - sessionPcObj.Lv);

					local lvdiffscore = WEIGHT_LEVEL - (lvdiff/20 * WEIGHT_LEVEL) -- 20���� ���� ���� 0��.
					if lvdiffscore < 0  then
						lvdiffscore = 0
					end

					retleveldiff = retleveldiff + lvdiffscore
				end
			end
		end
	end

	local levelPoint = retleveldiff / memcount

	local matchscore = nowmatchscore + levelPoint
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if levelPoint > mainreasonAddvalue then
		mainreasonAddvalue = levelPoint
		mainreason = PARTY_RECOMMEND_TYPE_LEVEL
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� ���̿� ���� �߰��� : '..levelPoint)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_REPUTATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local YUYUrelationScoreAvg = 0
	for i = 1 , #partymemberlist do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionRScore = session:GetAvgRelationScore();
		local memRScore = memsession:GetAvgRelationScore(); 

		YUYUrelationScoreAvg = YUYUrelationScoreAvg + math.abs(sessionRScore - (memRScore*1.1))
	end
	YUYUrelationScoreAvg = YUYUrelationScoreAvg / memcount
	if YUYUrelationScoreAvg > REPUTATION_MAX_DIF then
		YUYUrelationScoreAvg = REPUTATION_MAX_DIF
	end

	local YUYUrelationScore = WEIGHT_REPUTATION - (WEIGHT_REPUTATION * YUYUrelationScoreAvg / REPUTATION_MAX_DIF)

	local matchscore = nowmatchscore + YUYUrelationScore
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if YUYUrelationScore > mainreasonAddvalue then
		mainreasonAddvalue = YUYUrelationScore
		mainreason = PARTY_RECOMMEND_TYPE_REPUTATION -- ��
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('������ ���� �� �θ��� ����ϴٸ� �߰��� : '..YUYUrelationScore)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_ITEMGRADE_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local totalItemGrade = 0

	local itemgradeavg = 0
	local itemStaravg = 0
	local itemReinforceavg = 0
	
	local itemGradeScore = 0
	local itemStarScore = 0
	local itemReinforceScore = 0

	for i = 1 , #partymemberlist do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionGrade = session:GetTotalItemGrade();
		local memGrade = memsession:GetTotalItemGrade(); 

		local sessionStar = session:GetTotalStarCount();
		local memStar = memsession:GetTotalStarCount(); 

		local sessionRein = session:GetTotaReinforce();
		local memRein = memsession:GetTotaReinforce(); 

		itemgradeavg = itemgradeavg + (math.abs((sessionGrade) - (memGrade*1.1)) / 8)
		itemStaravg = itemgradeavg + (math.abs((sessionStar) - (memStar*1.1)) / 8)
		itemReinforceavg = itemgradeavg + (math.abs((sessionRein) - (memRein*1.1)) / 8)
	end
	itemgradeavg = itemgradeavg / memcount
	itemStaravg = itemStaravg / memcount
	itemReinforceavg = itemReinforceavg / memcount

	if itemStaravg < 0.375 then
		itemStarScore = WEIGHT_ITEM_GRADE * 5/11
	else
		itemStarScore = 0
	end

	if itemgradeavg < 0.5 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 3/3
	elseif itemgradeavg < 1.0 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 2/3
	elseif itemgradeavg < 1.5 then
		itemGradeScore = WEIGHT_ITEM_GRADE * 3/11 * 1/3
	else
		itemGradeScore = 0
	end

	if itemReinforceavg < 3.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 3/3
	elseif itemReinforceavg < 4.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 2/3
	elseif itemReinforceavg < 5.25 then
		itemReinforceScore = WEIGHT_ITEM_GRADE * 3/11 * 1/3
	else
		itemReinforceScore = 0
	end

	totalItemGrade = itemStarScore + itemGradeScore + itemReinforceScore
	
	local matchscore = nowmatchscore + totalItemGrade
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if totalItemGrade > mainreasonAddvalue then
		mainreasonAddvalue = totalItemGrade
		mainreason = PARTY_RECOMMEND_TYPE_ITEM_GRADE -- ��� ������� �ٲ�� ��.
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� �� ������ ����� ����ϴٸ� �߰��� : '..totalItemGrade)
	end

	return matchscore, mainreason, mainreasonAddvalue
end


function PARTY_MATCHMAKING_CALC_RELATION_SCORE(session, sessionPcObj, party, partyobj, partymemberlist,  nowmatchscore, nowmainreason, nowmainreasonAddvalue)	

	local memcount = #partymemberlist
	local relationScoreAvg = 0
	for i = 1 , memcount do
		
		local meminfo = partymemberlist[i]["Info"]
		local memsession = partymemberlist[i]["Session"]

		local sessionToMemRScore = session:GetRelationScore(meminfo:GetAID());
		local memToSessionRScore = memsession:GetRelationScore(session:GetAID());

		local eachscore = ( sessionToMemRScore + memToSessionRScore ) / 2

		relationScoreAvg = relationScoreAvg + eachscore
	end
	relationScoreAvg = relationScoreAvg / memcount

	if relationScoreAvg > RELATION_UP_BOUND then
		relationScoreAvg = RELATION_UP_BOUND
	end

	if relationScoreAvg < RELATION_DOWN_BOUND then
		relationScoreAvg = RELATION_DOWN_BOUND
	end

	local relationScore = (relationScoreAvg * WEIGHT_RELATION) / (RELATION_UP_BOUND - RELATION_DOWN_BOUND) 

	local matchscore = nowmatchscore + relationScore -- ������ �� �� �ִ�.
	local mainreason = nowmainreason
	local mainreasonAddvalue = nowmainreasonAddvalue

	if relationScore > mainreasonAddvalue then
		mainreasonAddvalue = relationScore
		mainreason = PARTY_RECOMMEND_TYPE_RELATION_POINT
	end

	if PARTY_MATCH_SHOWLOG == true then
		print('���� ���� ���� ���迴�ٸ� �߰��� : '..relationScore)
	end

	return matchscore, mainreason, mainreasonAddvalue
en