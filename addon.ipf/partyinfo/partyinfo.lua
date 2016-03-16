function PARTYINFO_ON_INIT(addon, frame)
	addon:RegisterMsg("PARTY_UPDATE", "ON_PARTYINFO_UPDATE");
	addon:RegisterMsg("PARTY_BUFFLIST_UPDATE", "ON_PARTYINFO_BUFFLIST_UPDATE");
	addon:RegisterMsg("PARTY_INST_UPDATE", "ON_PARTYINFO_INST_UPDATE");
	addon:RegisterMsg("PARTY_OUT", "ON_PARTYINFO_DESTROY");

	addon:RegisterMsg("PARTY_INVITE_CANCEL", "ON_PARTY_INVITE_CANCEL");
end

function ON_PARTYINFO_INST_UPDATE(frame, msg, argStr, argNum)
	
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return;
	end
	
	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();

	local myAid = session.loginInfo.GetAID();
	-- ������ ��Ƽ��
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetMapID() > 0 then
			local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. partyMemberInfo:GetAID());
			if partyInfoCtrlSet ~= nil then
				UPDATE_PARTY_INST_SET(partyInfoCtrlSet, partyMemberInfo);
			end
		end

	end	

end

function ON_PARTYINFO_UPDATE(frame, msg, argStr, argNum)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
		frame:ShowWindow(0);
		return;
	end
	
	frame:ShowWindow(1);
	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	local memberIndex = 0;

	local myAid = session.loginInfo.GetAID();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetAID() ~= myAid then
			local ret = nil;
			-- ������ ��Ƽ��
			if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then
				ret = SET_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType, false);
			else-- ���Ӿ��� ��Ƽ��
				ret = SET_LOGOUT_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType);
				end
		else -- ��������
			local headsup = ui.GetFrame("headsupdisplay");
			local leaderMark = GET_CHILD(headsup, "Isleader", "ui::CPicture");
			if partyInfo:GetLeaderAID() ~= myAid then-- ���� ���� �ƴϸ�
				leaderMark:SetImage('None_Mark');
			else
				leaderMark:SetImage('party_leader_mark');
			end
		end
	end	

	for i = 0 , frame:GetChildCount() - 1 do
		local ctrlSet = frame:GetChildByIndex(i);
		if nil ~= ctrlSet then
		local ctrlSetName = ctrlSet:GetName();
		if string.find(ctrlSetName, "PTINFO_") ~= nil then
			local aid = string.sub(ctrlSetName, 8, string.len(ctrlSetName));
			local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, aid);
			if memberInfo == nil then
				frame:RemoveChildByIndex(i);
				i = i - 1;
			end
		end
		end
	end
	-- DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
	GBOX_AUTO_ALIGN(frame, 10, 0, 0, true, false);
	frame:Invalidate();
end

function ON_PARTYINFO_BUFFLIST_UPDATE(frame)
	
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
		frame:ShowWindow(0);
		return;
	end

	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(0);
	local count = list:Count();
	local memberIndex = 0;

	local myInfo = session.party.GetMyPartyObj();

	-- ������ ��Ƽ�� ��������Ʈ
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then

			local buffCount = partyMemberInfo:GetBuffCount();
			local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. partyMemberInfo:GetAID());
			if partyInfoCtrlSet ~= nil then
	
				local buffListSlotSet = GET_CHILD(partyInfoCtrlSet, "buffList", "ui::CSlotSet");
				local debuffListSlotSet = GET_CHILD(partyInfoCtrlSet, "debuffList", "ui::CSlotSet");
				
				-- �ʱ�ȭ
				for j=0, buffListSlotSet:GetSlotCount() - 1 do
					local slot = buffListSlotSet:GetSlotByIndex(j);
					slot:SetKeyboardSelectable(false);
					if slot == nil then
						break;
					end
					slot:ShowWindow(0);
				end
				
				for j=0, debuffListSlotSet:GetSlotCount() - 1 do
					local slot = debuffListSlotSet:GetSlotByIndex(j);
					if slot == nil then
						break;
					end
					slot:ShowWindow(0);				
				end

				-- ������ ����
				if buffCount > 0 then
					local buffIndex = 0;
					local debuffIndex = 0;
					for j=0, buffCount - 1 do
						
						local buffID = partyMemberInfo:GetBuffIDByIndex(j);
						local cls = GetClassByType("Buff", buffID);											
						if cls ~= nil and cls.ShowIcon ~= "FALSE" and cls.ClassName ~= "TeamLevel" then
							local buffOver = partyMemberInfo:GetBuffOverByIndex(j);
							local buffTime = partyMemberInfo:GetBuffTimeByIndex(j);							
							local slot = nil;
							if cls.Group1 == 'Buff' then
								slot = buffListSlotSet:GetSlotByIndex(buffIndex);
								buffIndex = buffIndex + 1;
							
							elseif cls.Group1 == 'Debuff' then
								slot = debuffListSlotSet:GetSlotByIndex(debuffIndex);
								debuffIndex = debuffIndex + 1;
							end
														
							if slot ~= nil then
								local icon = slot:GetIcon();
								if icon == nil then
									icon = CreateIcon(slot);
								end

								local handle = 0;
								if myInfo ~= nil then
									if myInfo:GetMapID() == partyMemberInfo:GetMapID() and myInfo:GetChannel() == partyMemberInfo:GetChannel() then
										handle  = partyMemberInfo:GetHandle();
									end
										
								end
								handle = tostring(handle);
								icon:SetDrawCoolTimeText( math.floor(buffTime/1000) );
								icon:SetTooltipType('buff');
								icon:SetTooltipArg(handle, buffID, "");

								local imageName = 'icon_' .. cls.Icon;
								icon:Set(imageName, 'BUFF', buffID, 0);

								if buffOver > 1 then
									slot:SetText('{s13}{ol}{b}'..buffOver, 'count', 'right', 'bottom', 1, 2);
								else
									slot:SetText("");
								end
								
								slot:ShowWindow(1);
							end
						end
					end
				end
			end
		end
	end
end

function OPEN_PARTY_INFO()
	ui.ToggleFrame("party");
end

function OUT_PARTY()

	if session.GetCurrentMapProp():GetUsePartyOut() == "NO" then
		ui.SysMsg(ScpArgMsg("ThatMapCannotPartyOut"));
		return;
	end

	ui.Chat("/partyout");	
	local headsup = ui.GetFrame("headsupdisplay");
	local leaderMark = GET_CHILD(headsup, "Isleader", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
end

function BAN_PARTY_MEMBER(name)
	ui.Chat("/partyban " .. PARTY_NORMAL.. " " .. name);	
end

function GIVE_PARTY_LEADER(name)
	
	if session.GetCurrentMapProp():GetUsePartyOut() == "NO" then
		ui.SysMsg(ScpArgMsg("ThatMapCannotChangePartyLeader"));
		return;
	end

	ui.Chat("/partyleader " .. name);	
end

function OPEN_PARTY_MEMBER_INFO(name)

	party.ReqMemberDetailInfo(name)
	
end

function CONTEXT_PARTY(frame, ctrl, aid)

	if session.world.IsIntegrateServer() == true then
		return;
	end
	
	local myAid = session.loginInfo.GetAID();
	
	local pcparty = session.party.GetPartyInfo();
	local iamLeader = false;

	if pcparty.info:GetLeaderAID() == myAid then
		iamLeader = true;
	end

	local myInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, myAid);	
	local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, aid);	
	local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);

	if aid == myAid then
		-- 1. ������ �ڱ� �ڽ�.
		ui.AddContextMenuItem(context, ScpArgMsg("WithdrawParty"), "OUT_PARTY()");			
	elseif iamLeader == true then
		-- 2. ��Ƽ���� ��Ƽ�� ��Ŭ��
		-- ��ȭ�ϱ�. ������������. ��Ƽ�� ����. �߹�.
		ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", memberInfo:GetName()));	
		local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", memberInfo:GetName());
		ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
		ui.AddContextMenuItem(context, ScpArgMsg("ShowInfomation"), string.format("OPEN_PARTY_MEMBER_INFO(\"%s\")", memberInfo:GetName()));	
		ui.AddContextMenuItem(context, ScpArgMsg("GiveLeaderPermission"), string.format("GIVE_PARTY_LEADER(\"%s\")", memberInfo:GetName()));	
		ui.AddContextMenuItem(context, ScpArgMsg("Ban"), string.format("BAN_PARTY_MEMBER(\"%s\")", memberInfo:GetName()));	
		if myInfo:GetMapID() == memberInfo:GetMapID() and memberInfo.isAlchmist == 1 then
			ui.AddContextMenuItem(context, ScpArgMsg("RequestItemDungeon"), string.format("Alchemist.RequestItemDungeon('%s')", memberInfo:GetName()));	
		end
	else
		-- 3. ��Ƽ���� ��Ƽ�� ��Ŭ��
		-- ��ȭ�ϱ�. ���� ���� ����.
		ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", memberInfo:GetName()));	
		local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", memberInfo:GetName());
		ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
		ui.AddContextMenuItem(context, ScpArgMsg("ShowInfomation"), string.format("OPEN_PARTY_MEMBER_INFO(\"%s\")", memberInfo:GetName()));	
		if myInfo:GetMapID() == memberInfo:GetMapID() and memberInfo.isAlchmist == 1 then
			ui.AddContextMenuItem(context, ScpArgMsg("RequestItemDungeon"), string.format("Alchemist.RequestItemDungeon('%s')",memberInfo:GetName()));	
		end
	end
	
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo)
-- ��Ƽ�� hp / sp ǥ�� --
	local hpGauge = GET_CHILD(partyInfoCtrlSet, "hp", "ui::CGauge");
	local spGauge = GET_CHILD(partyInfoCtrlSet, "sp", "ui::CGauge");
	
	local stat = partyMemberInfo:GetInst();
	hpGauge:SetPoint(stat.hp, stat.maxhp);
	spGauge:SetPoint(stat.sp, stat.maxsp);

	local hpRatio = stat.hp / stat.maxhp;

	if  hpRatio <= 0.3 and hpRatio > 0 then
		hpGauge:SetBlink(0.0, 1.0, 0xffff3333); -- (duration, 주기, ?�상)
	else
		hpGauge:ReleaseBlink();
	end

end

function PARTY_HP_UPDATE(actor, partyMemberInfo)
	local frame = ui.GetFrame("partyinfo"); 
	if frame == nil then
	return;
	end
	local apc = actor:GetPCApc();
	local ctrlName = 'PTINFO_'.. apc:GetAID();
	local ctrlSet = frame:GetChild(ctrlName);
	if ctrlSet ~= nil then
		UPDATE_PARTYINFO_HP(ctrlSet, partyMemberInfo);
	end

end

function UPDATE_PARTY_INST_SET(partyInfoCtrlSet, partyMemberInfo)
	UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo);
end

function SET_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, makeLogoutPC, leaderFID, isCorsairType, ispipui)

	local partyinfoFrame = ui.GetFrame('partyinfo')
	local FAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("FAR_MEMBER_FACE_COLORTONE")
	local NEAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("NEAR_MEMBER_FACE_COLORTONE")
	local FAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("FAR_MEMBER_NAME_FONT_COLORTAG")
	local NEAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("NEAR_MEMBER_NAME_FONT_COLORTAG")

	local mapName = geMapTable.GetMapName(partyMemberInfo:GetMapID());
	local partyMemberName = partyMemberInfo:GetName();
	
	local myHandle		= session.GetMyHandle();
	local ctrlName = 'PTINFO_'.. partyMemberInfo:GetAID();
	if mapName == 'None' and makeLogoutPC == false then
		frame:RemoveChild(ctrlName);
		return nil;
	end	

	--if partyMemberInfo:GetHandle() == myHandle then
	--	frame:RemoveChild(ctrlName);
	--	return nil;
	--end
	
		local partyInfoCtrlSet = frame:CreateOrGetControlSet('partyinfo', ctrlName, 10, count * 100);
		
	UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo);

	local leaderMark = GET_CHILD(partyInfoCtrlSet, "leader_img", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
	leaderMark:ShowWindow(0)
	
	-- �Ӹ�
	local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
	local nameObj = partyInfoCtrlSet:GetChild('name_text');
	local nameRichText = tolua.cast(nameObj, "ui::CRichText");	
	local hpGauge = GET_CHILD(partyInfoCtrlSet, "hp", "ui::CGauge");
	local spGauge = GET_CHILD(partyInfoCtrlSet, "sp", "ui::CGauge");

	if jobportraitImg ~= nil then
		local jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
		local iconinfo = partyMemberInfo:GetIconInfo();
		local jobCls  = GetClassByType("Job", iconinfo.job);
		if nil ~= jobCls then
			jobIcon:SetImage(jobCls.Icon);
		end
			
			
		local tooltipID = jobIcon:GetTooltipIESID();		
		if nil == tooltipID then		
			jobIcon:SetTextTooltip(jobCls.name);
		end

		local stat = partyMemberInfo:GetInst();
		local pos = stat:GetPos();

		local dist = info.GetDestPosDistance(pos.x, pos.y, pos.z, myHandle);
		local sharedcls = GetClass("SharedConst",'PARTY_SHARE_RANGE');

		local mymapname = session.GetMapName();

		local partymembermapName = GetClassByType("Map", partyMemberInfo:GetMapID()).ClassName;
		local partymembermapUIName = GetClassByType("Map", partyMemberInfo:GetMapID()).Name;

		if ispipui == true then
			partyMemberName = ScpArgMsg("PartyMemberMapNChannel","Name",partyMemberName,"Mapname",partymembermapUIName,"ChNo",partyMemberInfo:GetChannel() + 1)
		end
			

		if dist < sharedcls.Value and mymapname == partymembermapName then
			jobportraitImg:SetColorTone(NEAR_MEMBER_FACE_COLORTONE)
			partyMemberName = NEAR_MEMBER_NAME_FONT_COLORTAG..partyMemberName;
			nameRichText:SetTextByKey("name", partyMemberName);
			hpGauge:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
			spGauge:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
		else
			jobportraitImg:SetColorTone(FAR_MEMBER_FACE_COLORTONE)
			partyMemberName = FAR_MEMBER_NAME_FONT_COLORTAG..partyMemberName;
			nameRichText:SetTextByKey("name", partyMemberName);
			hpGauge:SetColorTone(FAR_MEMBER_FACE_COLORTONE);
			spGauge:SetColorTone(FAR_MEMBER_FACE_COLORTONE);
		end

	end
		
	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "CONTEXT_PARTY");
	partyInfoCtrlSet:SetEventScriptArgString(ui.RBUTTONUP, partyMemberInfo:GetAID());

	if partyMemberInfo:GetAID() == leaderFID then
		leaderMark:ShowWindow(1)
		if isCorsairType == true then
			leaderMark:SetImage('party_corsair_mark');
		else
			leaderMark:SetImage('party_leader_mark');
		end
	end

	partyInfoCtrlSet:SetUserValue("MEMBER_NAME", partyMemberName);

	if hpGauge:GetStat() == 0 then
		hpGauge:AddStat("%v / %m");
		hpGauge:SetStatOffset(0, 0, -1);
		hpGauge:SetStatAlign(0, 'center', 'center');
		hpGauge:SetStatFont(0, 'white_12_ol');
	end
	
	if spGauge:GetStat() == 0 then
		spGauge:AddStat("%v / %m");
		spGauge:SetStatOffset(0, 0, -1);
		spGauge:SetStatAlign(0, 'center', 'center');
		spGauge:SetStatFont(0, 'white_12_ol');
	end
			
	-- ��Ƽ�� ���� ǥ�� -- 
	local lvbox = partyInfoCtrlSet:GetChild('lvbox');
	local levelObj = partyInfoCtrlSet:GetChild('lvbox');
	local levelRichText = tolua.cast(levelObj, "ui::CRichText");
	local level = partyMemberInfo:GetLevel();	
	levelRichText:SetTextByKey("lv", level);
	levelRichText:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
	lvbox:Resize(levelRichText:GetWidth(), lvbox:GetHeight());
		
	if frame:GetName() == 'partyinfo' then
		frame:Resize(20 + frame:GetOriginalWidth(), (count+1) * 100);
	else
		frame:Resize(frame:GetOriginalWidth(),frame:GetOriginalHeight());
	end

	return 1;
end

function SET_LOGOUT_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, makeLogoutPC, leaderFID, isCorsairType)

	local partyinfoFrame = ui.GetFrame('partyinfo')
	local FAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("FAR_MEMBER_FACE_COLORTONE")
	local FAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("FAR_MEMBER_NAME_FONT_COLORTAG")

	local mapName = geMapTable.GetMapName(partyMemberInfo:GetMapID());
	local partyMemberName = partyMemberInfo:GetName();

	local ctrlName = 'PTINFO_'.. partyMemberInfo:GetAID();
	local partyInfoCtrlSet = frame:CreateOrGetControlSet('partyinfo', ctrlName, 10, count * 60);
	
	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "None");
	AUTO_CAST(partyInfoCtrlSet);
	-- able ban logout pc;
	--partyInfoCtrlSet:EnableHitTestSet(0);
		
	-- ��Ƽ�� hp / sp ǥ�� --
	local hpObject 				= partyInfoCtrlSet:GetChild('hp');
	local hpGauge 				= tolua.cast(hpObject, "ui::CGauge");
	local spObject 				= partyInfoCtrlSet:GetChild('sp');
	local spGauge 				= tolua.cast(spObject, "ui::CGauge");
	
	hpGauge:SetPoint(0, 0);
	spGauge:SetPoint(0, 0);
	
	local nameObj = partyInfoCtrlSet:GetChild('name_text');
	local nameRichText = tolua.cast(nameObj, "ui::CRichText");		
	nameRichText:SetTextByKey("name", FAR_MEMBER_NAME_FONT_COLORTAG .. partyMemberName);		
	partyInfoCtrlSet:SetUserValue("MEMBER_NAME", partyMemberName);

	local leaderMark = GET_CHILD(partyInfoCtrlSet, "leader_img", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
	leaderMark:ShowWindow(0)
	
	if partyMemberInfo:GetAID() == leaderFID then
		leaderMark:ShowWindow(1)
		if isCorsairType == true then
			leaderMark:SetImage('party_corsair_mark');
		else
			leaderMark:SetImage('party_leader_mark');
		end	
	end
				
	-- �Ӹ�
	local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
	if jobportraitImg ~= nil then
		jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
		local iconinfo = partyMemberInfo:GetIconInfo();
		local jobCls  = GetClassByType("Job", iconinfo.job);
		if nil ~= jobCls then
			jobIcon:SetImage(jobCls.Icon);
	end
	end
		
	-- ��Ƽ�� ���� ǥ�� -- 
	local lvbox = partyInfoCtrlSet:GetChild('lvbox');
	local levelObj = partyInfoCtrlSet:GetChild('lvbox');
	local levelRichText = tolua.cast(levelObj, "ui::CRichText");

	levelRichText:SetTextByKey("lv", 'Out');
	lvbox:Resize(levelRichText:GetWidth(), lvbox:GetHeight());

	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "CONTEXT_PARTY");
	partyInfoCtrlSet:SetEventScriptArgString(ui.RBUTTONUP, partyMemberInfo:GetAID());

	local color = FAR_MEMBER_FACE_COLORTONE
	jobportraitImg:SetColorTone(color);
	levelRichText:SetColorTone(color);
	hpGauge:SetColorTone(color);
	spGauge:SetColorTone(color);

	frame:Resize(20 + frame:GetWidth(), (count+1) * 100);
	
	
	return 1;
end

-- party relation grade
PARTY_RELATION_VAN		= 0
PARTY_RELATION_NONE		= 1;
PARTY_RELATION_BASIC	= 2;
PARTY_RELATION_EXP		= 3;
PARTY_RELATION_QUEST	= 4;
PARTY_RELATION_EXP_QUEST= 5;
PARTY_RELATION_LEADER	= 6;
PARTY_RELATION_GUILD	= 7;

function ON_PARTYINFO_DESTROY(frame)

	frame:RemoveAllChild();	
	frame:ShowWindow(0);
end

-- ReqChangeRelation  reqType
PARTY_ADD_MEMBER = 0
PARTY_REQ_KICK = 1
PARTY_SHARE_EXP = 2
PARTY_SHARE_QUEST = 3
PARTY_DIST_LOCK = 4
PARTY_ADD_VANLIST = 5
PARTY_RELATION_INIT = 6

function PARTYMEMBER_JOIN(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_ADD_MEMBER);
end

function PARTYMEMBER_OUT(ctrlset, ctrl)
	
	if GetLayer(GetMyPCObject()) == 0 then
		local name = ctrlset:GetUserValue("MEMBER_NAME");
		party.ReqChangeRelation(name, PARTY_REQ_KICK);
	end
end

function PARTYMEMBER_EXP_SHARE(ctrlset, ctrl)

	local name = ctrlset:GetUserValue("MEMBER_NAME");
	party.ReqChangeRelation(name, PARTY_SHARE_EXP);
end

function PARTYMEMBER_QUEST_SHARE(ctrlset, ctrl)

	local name = ctrlset:GetUserValue("MEMBER_NAME");
	party.ReqChangeRelation(name, PARTY_SHARE_QUEST);
end

function PARTYMEMBER_LOCK(ctrlset, ctrl)

	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_DIST_LOCK);
end

function PARTYMEMBER_VAN(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_ADD_VANLIST);
end

function RECEIVE_PARTY_INVITE(partyType, familyName)

	local msg = "";
	if partyType == PARTY_NORMAL then
		msg = "{Inviter}InviteYouToParty_DoYouAccept?";
	else
		msg = "{Inviter}InviteYouToGuild_DoYouAccept?";
	end

	local str = ScpArgMsg(msg, "Inviter", familyName);
	local yesScp = string.format("party.AcceptInvite(%d, \"%s\", 0)", partyType, familyName);
	local noScp = string.format("party.CancelInvite(%d, \"%s\", 0)", partyType, familyName);
	ui.MsgBox(str, yesScp, noScp);
end

function PARTY_AUTO_REFUSE_INVITE(familyName)

	local noScp = string.format("PARTY_AUTO_REFUSE_INVITE_EXEC(\"%s\")", familyName);
	ReserveScript(noScp, 5);

end

function PARTY_AUTO_REFUSE_INVITE_EXEC(familyName)

	party.CancelInvite(0, familyName, 0);
end

function ON_PARTY_INVITE_CANCEL(frame, msg, familyName, arg2)

	ui.SysMsg('['..familyName..'] '.. ClMsg("PartyInviteCancelMsg"));
end

function SET_PARTY_JOB_TOOLTIP(cid)	
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return 0;
	end	
	local partyInfo = pcparty.info;
	local info = session.otherPC.GetByStrCID(cid);		
	
	if info == nil then
		return 0 ;
	end;

	local frame = ui.GetFrame("partyinfo");	
	PARTY_JOB_TOOLTIP_CTRLSET(frame, cid, info);
	
	local partyFrame = ui.GetFrame('party');
	local gbox = partyFrame:GetChild("gbox");
	frame = gbox:GetChild("memberlist");		
	PARTY_JOB_TOOLTIP_CTRLSET(frame, cid, info);
end
	
function PARTY_JOB_TOOLTIP_CTRLSET(frame, cid, info)
	if frame == nil then
		return 0;
	end;
	local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. info:GetAID());
		if partyInfoCtrlSet ~= nil then	
			local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
			if jobportraitImg ~= nil then
				local jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
			PARTY_JOB_TOOLTIP(frame, cid, jobIcon, info.JobName);
				end;
			end;	
		end;	


function PARTY_JOB_TOOLTIP(frame, cid, uiChild, nowJobName)
	if (nil == session.otherPC.GetByStrCID(cid)) or (nil == uiChild) then 
		return;
	end		 
	
	local otherpcinfo = session.otherPC.GetByStrCID(cid);

	local jobhistory = otherpcinfo.jobHistory;
	local clslist, cnt  = GetClassList("Job");
	
	local nowjobinfo = jobhistory:GetJobHistory(jobhistory:GetJobHistoryCount()-1);
	local nowjobcls;
	if nil == nowjobinfo then
		nowjobcls = nowJobName; 
	else
		nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
	end; 

	local OTHERPCJOBS = {}
	for i = 0, jobhistory:GetJobHistoryCount()-1 do
		local tempjobinfo = jobhistory:GetJobHistory(i);

		if OTHERPCJOBS[tempjobinfo.jobID] == nil then
			OTHERPCJOBS[tempjobinfo.jobID] = tempjobinfo.grade;
		else
			if tempjobinfo.grade > OTHERPCJOBS[tempjobinfo.jobID] then
				OTHERPCJOBS[tempjobinfo.jobID] = tempjobinfo.grade;
			end
		end
	end
	
	local startext = ("");
	for jobid, grade in pairs(OTHERPCJOBS) do
		-- Ŭ���� �̸�{@st41}
		local cls = GetClassByTypeFromList(clslist, jobid);

		if cls.Name == nowjobcls.Name then
			startext = startext .. ("{@st41_yellow}").. cls.Name;		
		else
			startext = startext .. ("{@st41}").. cls.Name;				
		end
		
		-- Ŭ���� ���� (�ڷ� ǥ��)				
		for i = 1 , 3 do
			if i <= grade then
				startext = startext ..('{img star_in_arrow 20 20}');
			else
				startext = startext ..('{img star_out_arrow 20 20}');
			end
		end
		startext = startext ..('{nl}');
	end
	uiChild:SetTextTooltip(startext);
	uiChild:EnableHitTest(1);
en