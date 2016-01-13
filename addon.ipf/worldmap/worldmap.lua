
function WORLDMAP_ON_INIT(addon, frame)


end


function UI_TOGGLE_WORLDMAP()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('worldmap')
end

function CLAMP_WORLDMAP_POS(frame, cx, cy)

	local maxY = frame:GetUserIValue("MAX_Y");
	local minX = frame:GetUserIValue("MIN_X");
	cx = CLAMP(cx, minX, 0);
	cy = CLAMP(cy, 0, maxY);
	if maxY < 0 then
		cy = maxY;
	end

	return cx, cy;	

end

function WORLDMAP_SIZE_UPDATE(frame)
	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end

function WORLDMAP_UPDATE_PICSIZE(frame, currentDirection)

	local curMode = frame:GetUserValue("Mode");

	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local pic = GET_CHILD(frame, "pic");
	local size = ui.GetSkinImageSize(imgName);

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;
	local t_scale = frame:GetChild("t_scale");
	t_scale:SetTextByKey("value", string.format("%.2f", sizeRatio));

	local picWidth = size.x * sizeRatio;
	local picHeight = size.y * sizeRatio;
	
	pic:Resize(picWidth, picHeight);
	local frameWidth = frame:GetWidth();
	local frameHeight = frame:GetHeight();
	local horzAlign;
	local vertAlign;
	if picWidth < frameWidth then
		horzAlign = ui.CENTER_HORZ;
	else
		horzAlign = ui.LEFT;
	end

	if picHeight < frameHeight then
		vertAlign = ui.CENTER_VERT;
	else
		vertAlign = ui.TOP;
	end

	pic:SetGravity(horzAlign, vertAlign);
	
	local gbox = pic:CreateOrGetControl("groupbox", "GBOX_".. curMode, 0, 0, picWidth, picHeight);
	gbox:SetSkinName("None");
	gbox:Resize(picWidth, picHeight);
	gbox:EnableHitTest(1);
	gbox = AUTO_CAST(gbox);
	gbox:EnableScrollBar(0);
	gbox:EnableHittestGroupBox(false);	

	WORLDMAP_UPDATE_CLAMP_MINMAX(frame);

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);
	
	WORLDMAP_SETOFFSET(frame, cx, cy);

end

function OPEN_WORLDMAP(frame)

	frame:SetUserValue("Mode", "WorldMap");
	_OPEN_WORLDMAP(frame);

end

function WORLDMAP_UPDATE_CLAMP_MINMAX(frame)

	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local maxY = picHeight - frameHeight;
	frame:SetUserValue("MAX_Y", maxY);

	local frameWidth = frame:GetWidth();
	local picWidth = pic:GetWidth();

	local minX = picWidth - frameWidth;
	if minX < 0 then
		minX = 0;
	end

 	frame:SetUserValue("MIN_X", -minX);

end

function _OPEN_WORLDMAP(frame)

	WORLDMAP_SIZE_UPDATE(frame);
	frame:Invalidate();
	
	local pic = frame:GetChild("pic");

	UPDATE_WORLDMAP_CONTROLS(frame);
	
	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);	

	WORLDMAP_SETOFFSET(frame, cx, cy);
	
end

function UPDATE_WORLDMAP_CONTROLS(frame, changeDirection)

	if frame:GetName() == "worldmap" then
		CREATE_ALL_ZONE_TEXT(frame, changeDirection);
	else
		ON_INTE_WARP(frame, changeDirection);		
	end

end

function PRELOAD_WORLDMAP()

	local frame = ui.GetFrame("worldmap");
	OPEN_WORLDMAP(frame);

end

function CREATE_ALL_ZONE_TEXT(frame, changeDirection)

	local clsList, cnt = GetClassList('Map');	
	if cnt == 0 then
		return;
	end

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
		
	local currentDirection = config.GetConfig("WORLDMAP_DIRECTION", "s");
	currentDirection = "s";

	if changeDirection == true or ui.GetImage("worldmap_" .. currentDirection .. "_current") == nil then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);
	
	local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
	
	local picHeight = pic:GetHeight();
	local frameHeight = frame:GetHeight();
	local bottomY = picHeight;
	
	local imgSize = ui.GetSkinImageSize("worldmap_" .. currentDirection .. "_bg");

	local startX = - 80;
	local startY = bottomY - 30;
	local pictureStartY = imgSize.y - 30;

	local spaceX = 130.5;
	local spaceY = 130.5;

	local mapName = session.GetMapName();
	
	ui.ClearBrush();
	
	local curMode = frame:GetUserValue("Mode");
	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local parentGBox = pic:GetChild("GBOX_".. curMode);
	if changeDirection == true then
		DESTROY_CHILD_BYNAME(parentGBox, "ZONE_GBOX_");
	end

	CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY);

	if makeWorldMapImage == true then
		ui.CreateCloneImageSkin("worldmap_" .. currentDirection .. "_fog", "worldmap_" .. currentDirection .. "_current");
		ui.DrawBrushes("worldmap_" .. currentDirection .. "_current", "worldmap_" .. currentDirection .. "_bg")
	end

	pic:SetImage("worldmap_" .. currentDirection .. "_current");

end

function GET_WORLDMAP_GROUPBOX(frame)
	if frame:GetName() == "worldmap" then
		local curMode = frame:GetUserValue("Mode");
		local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
		return pic:GetChild("GBOX_".. curMode);
	end

	return GET_CHILD(frame, "pic" ,"ui::CPicture");
end

function CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY)

	local clsList, cnt = GetClassList('Map');	
	if cnt == 0 then
		return;
	end

	local nowMapIES = GetClass('Map',mapName)
	local nowMapWorldPos = SCR_STRING_CUT(nowMapIES.WorldMap)

	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	local questPossible = {}
	if sObj ~= nil then
		sObj = GetIES(sObj:GetIESObject());
		if sObj.MQ_POSSIBLE_LIST ~= 'None' then
		    questPossible = SCR_STRING_CUT(sObj.MQ_POSSIBLE_LIST)
		end
	end

	for i=0, cnt-1 do
		local mapCls = GetClassByIndexFromList(clsList, i);
		if mapCls.WorldMap ~= "None" then

			local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
			
			if currentDirection == dir then
			
				local etc = GetMyEtcObject();
            
				if etc['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0 then
                
					local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
				
					if changeDirection ~= true or parentGBox:GetChild(gBoxName) == nil then
				    
						CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY);

					end
				end
			end
		end
	end


end

function MAPNAME_FONT_CHECK(mapLvValue)
    local pc = GetMyPCObject();
    local pcLv = pc.Lv
    local mapNameFont = ''
	if mapLvValue < pcLv - 10 then
	    mapNameFont = '{#99cc66}'
	elseif mapLvValue > pcLv + 10 then
	    mapNameFont = '{#ff9955}'
	end
	
	return mapNameFont
end

function CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY)
	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	local picX = startX + x * spaceX * sizeRatio;
	local picY = startY - y * spaceY * sizeRatio;

	if changeDirection == false then
		local gbox = parentGBox:GetChild(gBoxName);
		if gbox ~= nil then
			gbox:SetOffset(picX, picY);
			return;
		end
	end
	local gbox = parentGBox:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 120)
	gbox:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
	gbox:SetSkinName("None");
	gbox:ShowWindow(1);
	local ctrlSet = gbox:CreateOrGetControlSet('worldmap_zone', "ZONE_CTRL_" .. mapCls.ClassID, ui.LEFT, ui.TOP, 0, 0, 0, 0);
	ctrlSet:ShowWindow(1);
	local text = ctrlSet:GetChild("text");
	if mapName == mapCls.ClassName then
		text:SetTextByKey("font", "{@st57}");
	end
			        
	local mainName = mapCls.MainName;
	local mapLv = mapCls.QuestLevel
	local nowGetTypeIES = SCR_GET_XML_IES('camp_warp','Zone', nowMapIES.ClassName)
	local warpGoddessIcon_now = ''
	local questPossibleIcon = ''
					
	if #questPossible > 0 then
		if table.find(questPossible, tostring(mapCls.ClassID)) > 0 then
			questPossibleIcon = '{img minimap_1_MAIN 24 24}'
		end
	end
					
        if #nowGetTypeIES > 0 then
		warpGoddessIcon_now = '{img minimap_goddess 24 24}'
	end
					
	local getTypeIES = SCR_GET_XML_IES('camp_warp','Zone', mapCls.ClassName)
	local warpGoddessIcon = ''
        if #getTypeIES > 0 then
		warpGoddessIcon = '{img minimap_goddess 24 24}'
	end
	local mapLvValue = mapLv
	if mapLv == nil or mapLv == 'None' or mapLv == '' or mapLv == 0 then
		mapLv = ''
	else
		mapLv = '{nl}Lv.'..mapLv
	end
	
	local mapNameFont = MAPNAME_FONT_CHECK(mapLvValue)
	
	if mainName ~= "None" then
		text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mapNameFont..mainName..mapLv..'{/}{nl}'..GET_STAR_TXT(20,mapCls.MapRank));
	else
		if mapName ~= mapCls.ClassName and nowMapWorldPos[1] == x and nowMapWorldPos[2] == y then
			local nowmapLv = nowMapIES.QuestLevel
			if nowmapLv == nil or nowmapLv == 'None' or nowmapLv == '' or nowmapLv == 0 then
        		nowmapLv = ''
        	else
        		nowmapLv = '{nl}Lv.'..nowmapLv
        	end
			text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mapNameFont..mapCls.Name..mapLv..'{nl}'..warpGoddessIcon_now..questPossibleIcon..'{@st57}'..nowMapIES.Name..nowmapLv..'{/}'.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank))
		else
    		text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mapNameFont..mapCls.Name..mapLv.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank));						
    	end
	end
					
--	local gbox_bg = ctrlSet:GetChild("gbox_bg");
--	gbox_bg:Resize(text:GetWidth() + 10, text:GetHeight() + 10);
	ctrlSet:SetEventScript(ui.LBUTTONDOWN, "WORLDMAP_LBTNDOWN");
	ctrlSet:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
				
	ctrlSet:SetTooltipType('worldmap');
	ctrlSet:SetTooltipArg(mapCls.ClassName);

	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	local memberIndex = 0;
	local suby = text:GetY() + text:GetHeight();
	
	DESTROY_CHILD_BYNAME(ctrlSet, "WMAP_PMINFO_");

	for j = 0 , count - 1 do
				
		local partyMemberInfo = list:Element(j);
		local partyMemberName = partyMemberInfo:GetName();

		if partyMemberInfo:GetMapID() == mapCls.ClassID and partyMemberName ~= info.GetFamilyName(session.GetMyHandle()) then
					
			local memberctrlSet = ctrlSet:CreateOrGetControlSet('worldmap_partymember_iconset', "WMAP_PMINFO_" .. partyMemberName, 0, suby );
		
			local pm_namertext = GET_CHILD(memberctrlSet,'pm_name','ui::CRichText')
			pm_namertext:SetTextByKey('pm_fname',partyMemberName)

			if suby > ctrlSet:GetHeight() then
				ctrlSet:Resize(ctrlSet:GetOriginalWidth(),suby)
			end

			memberIndex = memberIndex + 1;
			suby = suby + (memberIndex+1 * 25)
						
		end
	end	

	if makeWorldMapImage == true then
		local addSpace = 40;

		local brushX = startX + x * spaceX;
		local brushY = pictureStartY - y * spaceY;

		ui.AddBrushArea(brushX + ctrlSet:GetWidth() / 2, brushY + ctrlSet:GetHeight() / 2, ctrlSet:GetWidth() + addSpace);
	end
	 
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, false);

end

function WORLDMAP_SETOFFSET(frame, x, y)

	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local startY = frameHeight - picHeight;

	pic:SetOffset(x, startY + y);

end

function WORLDMAP_MOUSEWHEEL(parent, ctrl, s, n)
	
	--[[
	local dx = 0;
	local dy = n;
	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	cx = cx + dx;
	cy = cy + dy;

	cx, cy = CLAMP_WORLDMAP_POS(ctrl:GetTopParentFrame(), cx, cy);

	config.SetConfig("WORLDMAP_X", cx);	
	config.SetConfig("WORLDMAP_Y", cy);
	WORLDMAP_SETOFFSET(ctrl:GetTopParentFrame(), cx, cy);
	]]


	local frame = parent:GetTopParentFrame();
	if n > 0 then
		WORLDMAP_CHANGESIZE(frame, nil, nil, 1);
	else
		WORLDMAP_CHANGESIZE(frame, nil, nil, -1);
	end

end

function WORLDMAP_LBTNDOWN(parent, ctrl)
		
	local frame = parent:GetTopParentFrame();
	local pic = frame:GetChild("pic");
	local x, y = GET_MOUSE_POS();
	pic:SetUserValue("MOUSE_X", x);
	pic:SetUserValue("MOUSE_Y", y);
	
	ui.EnableToolTip(0);
	mouse.ChangeCursorImg("MOVE_MAP", 1);
	pic:RunUpdateScript("WORLDMAP_PROCESS_MOUSE");

end

function WORLDMAP_PROCESS_MOUSE(ctrl)

	if mouse.IsLBtnPressed() == 0 then
		mouse.ChangeCursorImg("BASIC", 0);
		ui.EnableToolTip(1);
		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	local x = ctrl:GetUserIValue("MOUSE_X");
	local y = ctrl:GetUserIValue("MOUSE_Y");
	local dx = mx - x;
	local dy = my - y;
	dx = dx * 2;
	dy = dy * 2;

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	cx = cx + dx;
	cy = cy + dy;

	cx, cy = CLAMP_WORLDMAP_POS(ctrl:GetTopParentFrame(), cx, cy);

	config.SetConfig("WORLDMAP_X", cx);	
	config.SetConfig("WORLDMAP_Y", cy);
	WORLDMAP_SETOFFSET(ctrl:GetTopParentFrame(), cx, cy);
	

	ctrl:SetUserValue("MOUSE_X", mx);
	ctrl:SetUserValue("MOUSE_Y", my);

	return 1;
end

function WORLDMAP_SHOW_DIRECTION(frame, ctrl, str, num)

	config.SetConfig("WORLDMAP_DIRECTION", str);
	UPDATE_WORLDMAP_CONTROLS(frame, true);

end

function WORLDMAP_CHANGESIZE(frame, ctrl, str, isAmplify)

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;
	curSize = curSize + isAmplify;
	curSize = CLAMP(curSize, -3, 3);
	config.SetConfig("WORLDMAP_SCALE", curSize);
	local afterSizeRatio = 1 + curSize * 0.25;
	if sizeRatio == afterSizeRatio then
		return;
	end

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	local multiPlyRatio = afterSizeRatio / sizeRatio;
	cx = cx * multiPlyRatio;
	cy = cy * multiPlyRatio;
	config.SetConfig("WORLDMAP_X", cx);
	config.SetConfig("WORLDMAP_Y", cy);

	UPDATE_WORLDMAP_CONTROLS(frame);
	

end

function WORLDMAP_LOCATE_LASTWARP(parent, ctrl)

	local etcObj = GetMyEtcObject();
	local mapCls = GetClassByType("Map", etcObj.LastWarpMapID);
	if mapCls ~= nil then
	LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), mapCls.ClassName);
	end
	
end

function WORLDMAP_LOCATE_NOWPOS(parent, ctrl)

	local mapName= session.GetMapName();
	LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), mapName);

end

function LOCATE_WORLDMAP_POS(frame, mapName)

	local gBox = GET_WORLDMAP_GROUPBOX(frame);
	local mapCls = GetClass("Map", mapName);
	local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
	local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

	local childCtrl = gBox:GetChild(gBoxName);

	if childCtrl == nil then
		return; -- ��ϵ� ���Ż��� ������ nil�ΰ�?
	end

	local x = childCtrl:GetX();
	local y = childCtrl:GetY();

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	local pic = GET_CHILD(frame, "pic");

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	local destX = - x + frame:GetWidth() / 2;
	local destY = pic:GetHeight() - (frame:GetHeight() / 2)  - y;

	destX, destY = CLAMP_WORLDMAP_POS(frame, destX, destY);	
	WORLDMAP_SETOFFSET(frame, destX, destY);
	
	config.SetConfig("WORLDMAP_X", destX);	
	config.SetConfig("WORLDMAP_Y", destY);
	
	x = x + 0.5 * childCtrl:GetWidth() + 5;
	y = y + 0.5 * childCtrl:GetHeight() + 5;
	
	local emphasize = gBox:CreateOrGetControlSet('worldmap_emphasize', "EMPHASIZE", x, y);
	emphasize:EnableHitTest(0);
	x = x - emphasize:GetWidth() / 2;
	y = y - emphasize:GetHeight() / 2;

	emphasize:SetOffset(x, y);
	emphasize:MakeTopBetweenChild();
	emphasize:ShowWindow(1);
	local animpic = GET_CHILD(emphasize, "animpic");
	animpic:ShowWindow(1);
	animpic:PlayAnimation();

end



