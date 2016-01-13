

function GET_MAP_POS(frame, mapprop, x, y, width, height)
	
	if frame:GetName() == "map" then
		local MapPos = mapprop:WorldPosToMinimapPos(x, y, m_mapWidth, m_mapHeight);
		 return m_offsetX + MapPos.x, m_offsetY + MapPos.y, width, height;
	else
		
		local cursize = GET_MINIMAPSIZE();
		local pictureui  = GET_CHILD(frame:GetTopParentFrame(), "map", "ui::CPicture");	
		local minimapw = pictureui:GetImageWidth() * (100 + cursize) / 100;
		local minimaph = pictureui:GetImageHeight() * (100 + cursize) / 100;
		local dd = (100 + cursize) / 100;
		local MapPos = mapprop:WorldPosToMinimapPos(x, y, minimapw, minimaph);
		return MapPos.x, MapPos.y, width * dd, height * dd;
	end
end

function MAP_MON_MINIMAP(frame, msg, argStr, argNum, info)

	if frame:GetName() == "minimap" then
		frame = GET_CHILD(frame, 'npclist', 'ui::CGroupBox');
	end

	local ctrlName = "_MONPOS_" .. info.handle;
	local monPic = frame:GetChild(ctrlName);
	if monPic ~= nil then
		MAP_MON_MINIMAP_SETPOS(frame, info);
		return;
	end

	local mapprop = session.GetCurrentMapProp();
	
	local isPC = info.type == 0;
	local monCls = nil;
	if false == isPC then
		monCls = GetClassByType("Monster", info.type);
	end

	local width;
	local height;
	if isPC then
		width = 80;
		height = 80;
	else
		if monCls.MonRank == "Boss" then
			width = 200;
			height = 200;
		else
			width = 15;
			height = 15;
		end
	end

	local ctrlName = "_MONPOS_" .. info.handle;
	monPic = frame:CreateOrGetControl('picture', ctrlName, 0, 0, width, height);
	tolua.cast(monPic, "ui::CPicture");
	if false == monPic:HaveUpdateScript("_MONPIC_AUTOUPDATE") then
		monPic:RunUpdateScript("_MONPIC_AUTOUPDATE", 0);
	end

	monPic:SetUserValue("W", width);
	monPic:SetUserValue("H", height);
	monPic:SetUserValue("HANDLE", info.handle);
	monPic:SetUserValue("EXTERN", "YES");
	monPic:SetUserValue("EXTERN_PIC", "YES");
	
	if isPC then
		monPic:SetEnableStretch(1);
		monPic:ShowWindow(1);

		local myTeam = GET_MY_TEAMID();
		local outLineColor;
		if myTeam == info.teamID then
			outLineColor = "CCFFFFFF";
		else
			outLineColor = "CCCC0000";
		end

		local imgName = ui.CaptureModelHeadImage_BGColor(info.gender, outLineColor);
		monPic:SetImage(imgName);
		monPic:ShowWindow(1);

	else
		if monCls.MonRank == "Boss" then
			--�ʵ庸�� ��ġ �˷��ִ°� �ּ�
			--SET_PICTURE_QUESTMAP(monPic, 30);
			--ctrlName = "_MONPOS_T_" .. info.handle;
			--local textC = frame:CreateOrGetControl('richtext', ctrlName, 0, 0, width, height);
			--tolua.cast(textC, "ui::CRichText");
			--textC:SetTextAlign("center", "bottom");
			--textC:SetText("{@st42_yellow}" .. ClMsg("FieldBossAppeared!") .. "{nl}{@st42}" .. monCls.Name);
			--textC:ShowWindow(1);
			--textC:SetUserValue("EXTERN", "YES");
		else
			local myTeam = GET_MY_TEAMID();
			if info.teamID == 0 then
				monPic:SetImage("fullyellow");
			elseif info.teamID ~= myTeam then
				monPic:SetImage("fullred");
			else
				monPic:SetImage("fullblue");
			end
			
			monPic:SetEnableStretch(1);
			monPic:ShowWindow(1);
		end
	end

	MAP_MON_MINIMAP_SETPOS(frame, info);
end

function MAP_MON_MINIMAP_SETPOS(frame, info)
	
	_MAP_MON_MINIMAP_SETPOS(frame, info.handle, info.x, info.z);

	local ctrlName = "_MONPOS_" .. info.handle;
	local monPic = frame:GetChild(ctrlName);
	monPic:SetUserValue("POS_X", info.x);
	monPic:SetUserValue("POS_Z", info.z);	
	
end

function _MAP_MON_MINIMAP_SETPOS(frame, handle, x, z)

	local ctrlName = "_MONPOS_" .. handle;
	local monPic = frame:GetChild(ctrlName);
	local mapprop = session.GetCurrentMapProp();
	local width = monPic:GetUserIValue("W");
	local height = monPic:GetUserIValue("H");
	local XC, YC, sx, sy = GET_MAP_POS(frame, mapprop, x, z, width, height);
	
	XC = XC - sx / 2;
	YC = YC - sy / 2;
	monPic:SetOffset(XC, YC);
	monPic:Resize(sx, sy);

	ctrlName = "_MONPOS_T_" .. handle;
	local textC = frame:GetChild(ctrlName);
	if textC ~= nil then
		textC:SetOffset(XC + 0, YC + 0);
		textC:Resize(sx, sy);
	end

end

function ON_MON_MINIMAP_END(frame, msg, argStr, handle)

	if frame:GetName() == "minimap" then
		frame = GET_CHILD(frame, 'npclist', 'ui::CGroupBox');
	end

	frame:RemoveChild(string.format("_MONPOS_%d", handle));
	frame:RemoveChild(string.format("_MONPOS_T_%d", handle));
	frame:Invalidate();

end

function _MONPIC_AUTOUPDATE(ctrl)

	local handle = ctrl:GetUserIValue("HANDLE");	
	local actor = world.GetActor(handle);
	if actor ~= nil then
		local actorPos = actor:GetPos();
		ctrl:SetUserValue("POS_X", actorPos.x);
		ctrl:SetUserValue("POS_Y", actorPos.z);
		_MAP_MON_MINIMAP_SETPOS(ctrl:GetParent(), handle, actorPos.x, actorPos.z);
		return 1;
	end

	if ctrl:GetTopParentFrame():GetName() == "minimap" then
		local lastSize = ctrl:GetUserIValue("LASTSIZE");
		local cursize = GET_MINIMAPSIZE();
		if lastSize ~= cursize then
			ctrl:SetUserValue("LASTSIZE", cursize);
			
			local x = ctrl:GetUserIValue("POS_X");
			local y = ctrl:GetUserIValue("POS_Y");
			_MAP_MON_MINIMAP_SETPOS(ctrl:GetParent(), handle, x, y);
			ctrl:GetTopParentFrame():Invalidate();
		end
	end

	return 1;
end

function MAP_MON_MINIMAP_START(frame, msg, argStr, type)

	local bossCls = GetClassByType("Monster", type);
	
	local bossIntro = ui.GetFrame("bossintro");
	bossIntro:ShowWindow(1);
	bossIntro:SetDuration(3);
	bossIntro:SetTextByKey("BossName", bossCls.Name);
	bossIntro:SetTextByKey("BossIntroMsg", ClMsg("BossMonsterAppearedInField"));
	

en