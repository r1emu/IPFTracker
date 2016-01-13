
function INTE_WARP_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('INTE_WARP', 'ON_INTE_WARP');
	--addon:RegisterOpenOnlyMsg("GAME_START", "ON_INTE_WARP");
end


function INTE_WARP_ON_RELOAD(frame)
	
end

function INTE_WARP_SIZE_UPDATE(frame)
	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end

function INTE_WARP_OPEN(frame)

	INTE_WARP_SIZE_UPDATE(frame);
	frame:Invalidate();

	if frame:GetUserValue('SCROLL_WARP') == 'NO' or frame:GetUserValue('SCROLL_WARP') == 'None' then
		REGISTERR_LASTUIOPEN_POS(frame)
	end

	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local maxY = picHeight  - frameHeight;
	frame:SetUserValue("MAX_Y", maxY);

	local frameWidth = frame:GetWidth();
	local picWidth = pic:GetWidth();

	local minX = picWidth - frameWidth;
 	frame:SetUserValue("MIN_X", -minX);

	local x = config.GetConfigInt("WORLDMAP_X");
	local y = config.GetConfigInt("WORLDMAP_Y");
	WORLDMAP_SETOFFSET(frame, x, y);
	
	ON_INTE_WARP(frame)

	frame:Invalidate()

	local nowZoneName = GetZoneName(pc);
	LOCATE_WORLDMAP_POS(frame, nowZoneName);

	SetKeyboardSelectMode(1)
	

end

function INTE_WARP_OPEN_NORMAL()

   	local frame = ui.GetFrame('inte_warp');
	frame:ShowWindow(1);
	frame:Invalidate();

end

function INTE_WARP_OPEN_FOR_QUICK_SLOT()
   	local frame = ui.GetFrame('inte_warp');
	frame:SetUserValue('SCROLL_WARP', 'YES')
	frame:ShowWindow(1);
	frame:Invalidate()
end

function INTE_WARP_CLOSE(frame)

	frame:SetUserValue('SCROLL_WARP', 'NO')
	UNREGISTERR_LASTUIOPEN_POS(frame)

	SetKeyboardSelectMode(0)
	
end

function GET_INTE_WARP_LIST()
	local sObj_main = GET_MAIN_SOBJ();
	if sObj_main == nil then
		return nil;
	end
	
	local gentype_classcount = GetClassCount('camp_warp')
    local result = {}
    if gentype_classcount > 0 then
        for i = 0 , gentype_classcount-1 do
            local cls = GetClassByIndex('camp_warp', i);
    		if sObj_main[cls.ClassName] == 300 then
                result[#result + 1] = cls
            end
        end
    end
    
    return result
end

function WARP_INFO_ZONE(zoneName)
	local gentype_classcount = GetClassCount('camp_warp')
	if gentype_classcount > 0 then
		for i = 0 , gentype_classcount-1 do
			local cls = GetClassByIndex('camp_warp', i);
			if cls.Zone == zoneName then
				return cls;
			end
		end
	end
end

function ON_INTE_WARP(frame, changeDirection)

	frame:SetUserValue("Mode", "InteWarp");
	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);
	local gbox = frame:GetChild("gbox");
	DESTROY_CHILD_BYNAME(gbox, "WARP_CTRLSET_");

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
	local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
	if changeDirection == true then
		DESTROY_CHILD_BYNAME(pic, "ZONE_GBOX_");
	end

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
	local currentDirection = config.GetConfig("INTEWARP_DIRECTION", "s");
	currentDirection = "s";

	if changeDirection == true or ui.GetImage("worldmap_" .. currentDirection .. "_current") == nil then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);	

	local picHeight = pic:GetHeight();
	local frameHeight = frame:GetHeight();
	local bottomY = picHeight;


	local imgSize = ui.GetSkinImageSize("worldmap_" .. currentDirection .. "_bg");
	local startX = - 80;
	local startY = bottomY - 30;
	local pictureStartY = imgSize.y - 30;
	local spaceX = 130.5;
	local spaceY = 130.5;

	local nowlocationtext =  GET_CHILD_RECURSIVELY(frame, "nowLocation", "ui::CRichText")
	local nowMapCls = GetClass("Map", nowZoneName);
	nowlocationtext:SetTextByKey("mapname", nowMapCls.Name)

	local etc = GetMyEtcObject();
	local mapCls = GetClassByType("Map", etc.ItemWarpMapID)

	ui.ClearBrush();

	local curMode = frame:GetUserValue("Mode");
	local imgName = "worldmap_" .. currentDirection .. "_bg";
	
	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	if mapCls ~= nil and mapCls.WorldMap ~= "None" then
		
		local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);

			if currentDirection == dir then

			local warpInfo = WARP_INFO_ZONE(mapCls.ClassName)
			local picX = startX + x * spaceX * sizeRatio;
			local picY = startY - y * spaceY * sizeRatio;
			local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
			local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
			local gbox = nil;
			if changeDirection ~= true then
				gbox = pic:GetChild(gBoxName);
				if gbox ~= nil then
					gbox:SetOffset(picX, picY);
				end
			end

			if gbox == nil then
				gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
				gbox:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
				gbox:SetEventScript(ui.LBUTTONDOWN, "WORLDMAP_LBTNDOWN");
				gbox:SetSkinName("downbox");
				gbox:ShowWindow(1);
			
				if  tonumber(index) <= 1 then
					local setName = "WARP_CTRLSET_0"
					local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
					set = tolua.cast(set, "ui::CControlSet");
					set:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
					set:SetEnableSelect(1);
					set:SetOverSound('button_over');
					set:SetClickSound('button_click_stats');
					local nameRechText = GET_CHILD(set, "areaname", "ui::CRichText");
					nameRechText:SetTextByKey("mapname","{#ffff00}"..ScpArgMsg('Auto_(woPeuJuMunSeo)'));
					set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
					if warpInfo ~= nil then --���Ż� �ִ� ������ ���.
						set:SetEventScriptArgString(ui.LBUTTONUP, warpInfo.ClassName);
					else
						set:SetEventScriptArgString(ui.LBUTTONUP, mapCls.ClassName);
					end

					set:SetEventScriptArgNumber(ui.LBUTTONUP, 1);

					local warpcost;
					warpcost = 0

					set:SetTooltipType('warpminimap');
					if warpInfo ~= nil then  --���Ż� �ִ� ������ ���.
						set:SetTooltipStrArg(warpInfo.ClassName);
					else
						set:SetTooltipStrArg(mapCls.ClassName);
					end
					set:SetTooltipNumArg(warpcost)
					if nameRechText:GetWidth() > 130 then
						nameRechText:SetTextFixWidth(1);
						nameRechText:Resize(125 , set:GetHeight())
					end
						if makeWorldMapImage == true then
				
							local brushX = startX + x * spaceX;
							local brushY = pictureStartY - y * spaceY;
							ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
						end
				end
			end
		end
	end

	local result = GET_INTE_WARP_LIST();
	if result ~= nil then
		for index = 1, #result do
			local info = result[index];
			local mapCls = GetClass("Map", info.Zone);
			local warpcost = geMapTable.CalcWarpCostBind(nowZoneName,info.Zone);
			if nowZoneName == 'infinite_map' then
				warpcost = 0;
			end
			if mapCls.WorldMap ~= "None" then
				local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
				
				if currentDirection == dir then
					local picX = startX + x * spaceX * sizeRatio;
					local picY = startY - y * spaceY * sizeRatio;
					local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
					local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

					if (warpcost < 1000000) then
						local calcOnlyPosition = false;
						if changeDirection ~= true then
							gbox = pic:GetChild(gBoxName);
							if gbox ~= nil then
								gbox:SetOffset(picX, picY);
								calcOnlyPosition = true;
							end
						end

							if pic:GetChild(gBoxName) == nil then 
								local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
								gbox:SetSkinName("downbox");
								gbox:ShowWindow(1);
			
								if  tonumber(index) <= 1 then
									local setName = "WARP_CTRLSET_" .. index;
									if calcOnlyPosition == false or gbox:GetChild(setName) == nil then
										local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
										set = tolua.cast(set, "ui::CControlSet");
										set:SetEnableSelect(1);
										set:SetOverSound('button_over');
										set:SetClickSound('button_click_stats');
										local nameRechText = GET_CHILD(set, "areaname", "ui::CRichText");
								
										nameRechText:SetTextByKey("mapname", GET_WARP_NAME_TEXT(mapCls, info, nowZoneName));
										set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
										set:SetEventScriptArgString(ui.LBUTTONUP, info.ClassName);
										set:SetTooltipType('warpminimap');
										set:SetTooltipStrArg(info.ClassName);
										set:SetTooltipNumArg(warpcost)
										if nameRechText:GetWidth() > 130 then
											nameRechText:SetTextFixWidth(1);
											nameRechText:Resize(125 , set:GetHeight())
										end
										if makeWorldMapImage == true then
											local brushX = startX + x * spaceX;
											local brushY = pictureStartY - y * spaceY;
											ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
										end
									end
								else
									local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
									local setName = "WARP_CTRLSET_" .. index;
									if calcOnlyPosition == false or gbox:GetChild(setName) == nil then
										local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
										set = tolua.cast(set, "ui::CControlSet");
										set:SetEnableSelect(1);
										set:SetOverSound('button_over');
										set:SetClickSound('button_click_stats');
										local nameRechText = GET_CHILD(set, "areaname", "ui::CRichText");
										nameRechText:SetTextByKey("mapname",GET_WARP_NAME_TEXT(mapCls, info, nowZoneName));
										set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
										set:SetEventScriptArgString(ui.LBUTTONUP, info.ClassName);
										set:SetTooltipType('warpminimap');
										set:SetTooltipStrArg(info.ClassName);
										set:SetTooltipNumArg(warpcost)
										if nameRechText:GetWidth() > 130 then
											nameRechText:SetTextFixWidth(1);
											nameRechText:Resize(125 , set:GetHeight())
										end
										if makeWorldMapImage == true then
											local brushX = startX + x * spaceX;
											local brushY = pictureStartY - y * spaceY;
											ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
										end
									end
								end
							else				
								local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
								local setName = "WARP_CTRLSET_" .. index;
								if calcOnlyPosition == false or gbox:GetChild(setName) == nil then
									local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
									set = tolua.cast(set, "ui::CControlSet");
									set:SetEnableSelect(1);
									set:SetOverSound('button_over');
									set:SetClickSound('button_click_stats');
									local nameRechText = GET_CHILD(set, "areaname", "ui::CRichText");
									nameRechText:SetTextByKey("mapname",GET_WARP_NAME_TEXT(mapCls, info, nowZoneName));
									set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
									set:SetEventScriptArgString(ui.LBUTTONUP, info.ClassName);
									set:SetTooltipType('warpminimap');
									set:SetTooltipStrArg(info.ClassName);
									set:SetTooltipNumArg(warpcost)
									if nameRechText:GetWidth() > 130 then
										nameRechText:SetTextFixWidth(1);
										nameRechText:Resize(125 , set:GetHeight())
									end
									if makeWorldMapImage == true then
										local brushX = startX + x * spaceX;
										local brushY = pictureStartY - y * spaceY;
										ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
									end
								end
							end
							local gbox = pic:GetChild(gBoxName)
							GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);
						end
				
				end
			end
		end

		if makeWorldMapImage == true then
			ui.CreateCloneImageSkin("worldmap_" .. currentDirection .."_fog", "worldmap_" .. currentDirection .."_current");
			ui.DrawBrushes("worldmap_" .. currentDirection .."_current", "worldmap_" .. currentDirection .."_bg")
		end

	end



	pic:SetImage("worldmap_" .. currentDirection .. "_current");

	frame:Invalidate()

end

function GET_WARP_NAME_TEXT(mapCls, info, nowZoneName)

	if mapCls.ClassName == nowZoneName then
		return "{#FFFF00}" .. info.Name;
	end

	return info.Name;

end
--[[
function INTEWARP_CLICK_INFO(frame, slot, argStr, argNum)


	local xPos = frame:GetWidth() -50;
	INTE_WARP_DETAIL_INFO(argNum, argStr, xPos);
	return;

end
]]

function CREATE_WARP_CTRL(gbox, setName, info, warpcost)

end

function UPDATE_WARP_MINIMAP_TOOLTIP(tooltipframe, strarg, strnum)

	local camp_warp_class = GetClass('camp_warp', strarg)
	--���Ż� �ִ� ������ ���.
	if camp_warp_class ~= nil then
		local nameRichText = GET_CHILD(tooltipframe, "richtext_mapname", "ui::CRichText");
		nameRichText:SetTextByKey("mapname",camp_warp_class.Name);

		world.PreloadMinimap(camp_warp_class.Zone);
		local pic = GET_CHILD(tooltipframe, "picture_minimap", "ui::CPicture");
		pic:SetImage(camp_warp_class.Zone);

		local costRichText = GET_CHILD(tooltipframe, "richtext_cost", "ui::CRichText");
		costRichText:SetTextByKey("costname",strnum);

		local mapprop = geMapTable.GetMapProp(camp_warp_class.Zone);

		if mapprop == nil then
			return;
		end

		local genList = mapprop.mongens;
		local genCnt = genList:Count()

		local worldPos;

		for i = 0,  genCnt - 1 do
			local element = genList:Element(i)
			if	string.find(element:GetClassName(), "statue") ~= nil then
				local genPointlist = element.GenList;
				worldPos = genPointlist:Element(0)
				break;
			end
		end

		if worldPos == nil then
			return;
		end

		local offsetX = pic:GetX();
		local offsetY = pic:GetY();

		local width = pic:GetWidth();
		local height = pic:GetHeight();

		local mapPos = mapprop:WorldPosToMinimapPos(worldPos.x, worldPos.z, width, height);
	
		local XC = offsetX + mapPos.x - iconW/2;	
		local YC = offsetY + mapPos.y - iconH/2;

		local statuePic = tooltipframe:CreateOrGetControl('picture', "picture_statue", XC, YC, iconW, iconH);
		tolua.cast(statuePic, "ui::CPicture");
		statuePic:SetImage("minimap_goddess")
	statuePic:ShowWindow(1)
	end
	
	camp_warp_class = GetClass("Map", strarg)
	-- ���Ż� ���� ����.
	if camp_warp_class ~= nil then 
		local nameRichText = GET_CHILD(tooltipframe, "richtext_mapname", "ui::CRichText");
		nameRichText:SetTextByKey("mapname",camp_warp_class.Name);

		world.PreloadMinimap(camp_warp_class.ClassName);
		local pic = GET_CHILD(tooltipframe, "picture_minimap", "ui::CPicture");
		pic:SetImage(camp_warp_class.ClassName);

		local costRichText = GET_CHILD(tooltipframe, "richtext_cost", "ui::CRichText");
		costRichText:SetTextByKey("costname",strnum);

		local mapprop = geMapTable.GetMapProp(camp_warp_class.ClassName);

		if mapprop == nil then
			return;
		end

		local etc = GetMyEtcObject();

		local genList = mapprop.mongens;
		local genCnt = genList:Count()

		local offsetX = pic:GetX();
		local offsetY = pic:GetY();
		local width = pic:GetWidth();
		local height = pic:GetHeight();

		local mapPos = mapprop:WorldPosToMinimapPos( etc.ItemWarpPosX, etc.ItemWarpPosZ, width, height);
		local XC = offsetX + mapPos.x - iconW/2;	
		local YC = offsetY + mapPos.y - iconH/2;

		local statuePic = tooltipframe:CreateOrGetControl('picture', "picture_statue", XC, YC, iconW, iconH);
		tolua.cast(statuePic, "ui::CPicture");
		statuePic:ShowWindow(0)
		--statuePic:SetImage("minimap_goddess")
	end
	
	tooltipframe:Invalidate()
	

end

function WARP_TO_AREA(frame, cset, argStr, argNum)
	local warpFrame = ui.GetFrame('inte_warp');
	
--	if warpFrame:IsVisible() == 1 then
--		ui.CloseFrame('inte_warp')
--	end
	local camp_warp_class = GetClass('camp_warp', argStr)

	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);
	local myMoney = GET_TOTAL_MONEY();
	local warpcost
	local targetMapName;
	if camp_warp_class ~= nil then
		targetMapName = camp_warp_class.Zone;
    	warpcost = geMapTable.CalcWarpCostBind(nowZoneName, camp_warp_class.Zone);
    elseif argStr ~= nil then
        warpcost = geMapTable.CalcWarpCostBind(nowZoneName, argStr);
		targetMapName = argStr;
    end

	if targetMapName == nowZoneName then
		ui.SysMsg(ScpArgMsg("ThatCurrentPosition"));
		return;
	end	

	if warpcost < 0 then
		warpcost = 0
	end
	
	local warpitemname = warpFrame:GetUserValue('SCROLL_WARP');

	if (warpitemname == 'NO' or warpitemname == 'None') and myMoney < warpcost then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end
    
    local dest_mapClassID
    if camp_warp_class ~= nil then
	    dest_mapClassID = camp_warp_class.ClassID
	else
	    local mapcls = GetClass('Map',argStr)
	    dest_mapClassID = mapcls.ClassID
	end
	local cheat = string.format("/intewarp %d %d", dest_mapClassID, argNum);

--	local warpFrame = ui.GetFrame('inte_warp');	

	if warpitemname ~= 'NO' and warpitemname ~= 'None' then
		cheat = string.format("/intewarpByItem %d %d %s", dest_mapClassID, argNum, warpitemname);
	end

	movie.InteWarp(session.GetMyHandle(), cheat);

	packet.ClientDirect("InteWarp");
    
    if warpFrame:IsVisible() == 1 then
		ui.CloseFrame('inte_warp')
	end
end

function RUN_INTE_WARP(actor)

	movie.InteWarp(actor:GetHandleVal(), 'None');

	packet.ClientDirect("InteWarp");
end

function INTEWARP_SHOW_DIRECTION(frame, ctrl, str, num)

	config.SetConfig("INTEWARP_DIRECTION", str);
	ON_INTE_WARP(frame, true);

end

