function ABILITYSHOP_ON_INIT(addon, frame)

	addon:RegisterMsg('ABILSHOP_OPEN', 'ON_ABILITYSHOP_OPEN');
	addon:RegisterMsg('RESET_ABILITY_UP', 'ON_RESET_ABILITY_UP');
end

function ON_ABILITYSHOP_OPEN(frame, msg, abilGroupName, argNum)

	frame:SetUserValue("ABIL_GROUP_NAME",abilGroupName)

	frame:ShowWindow(1);
	REFRESH_ABILITYSHOP(frame, msg);


	local abilityFrame = ui.GetFrame('skilltree');
	if abilityFrame:IsVisible() == 0 then
		abilityFrame:ShowWindow(1);
	end
end

function ABILITYSHOP_CLOSE(addon, frame)
	ui.CloseFrame('skilltree');
	ui.CloseFrame('abilityshop');
end

function ON_RESET_ABILITY_UP(frame, msg, abilGroupName, learnAbilID)

	frame:SetUserValue("ABIL_GROUP_NAME",abilGroupName)
	REFRESH_ABILITYSHOP(frame, msg);
end

function REFRESH_ABILITYSHOP(frame, msg)

	local frame = ui.GetFrame("abilityshop") -- 체크박스?�서???�동?�서 ?��?�?
	
	local abilGroupName = frame:GetUserValue("ABIL_GROUP_NAME")

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local gbox = GET_CHILD_RECURSIVELY(frame, 'abilityshopGBox');
	DESTROY_CHILD_BYNAME(gbox, 'ABILSHOP_');
	local posY = 5;

	-- abilGroupName?�로 xml?�서 ?�당?�는 구입가?�한 ?�성리스??가?�오�?
	local abilList, abilListCnt = GetClassList("Ability");
	local abilGroupList, abilGroupListCnt = GetClassList(abilGroupName);

	for i = 0, abilGroupListCnt-1 do

		local groupClass = GetClassByIndexFromList(abilGroupList, i);
		if groupClass ~= nil then
			local abilClass = GetClassByNameFromList(abilList, groupClass.ClassName);
			if abilClass ~= nil then
				posY = MAKE_ABILITYSHOP_ICON(frame, pc, gbox, abilClass, groupClass, posY);
			end
		end
	end

	--grid:Resize(grid:GetOriginalWidth(),posY + 80)

	local invenZeny = GET_CHILD_RECURSIVELY(frame, 'invenZeny', 'ui::CRichText');
	invenZeny:SetText("{@st41b}".. GET_TOTAL_MONEY())

	local abilityshopGBox = GET_CHILD_RECURSIVELY(frame, 'abilityshopGBox');
	abilityshopGBox:UpdateData();
	frame:Invalidate();
end

function MAKE_ABILITYSHOP_ICON(frame, pc, grid, abilClass, groupClass, posY)

	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local abilLv = 1;
	if abilIES ~= nil then
		abilLv = abilIES.Level + 1;
	end

	local isMax = 0;
	-- ?�성 구입 버튼.  ?�재 배우???�성???�으�??�른 ?�성?� ??막기
	local maxLevel = tonumber(groupClass.MaxLevel)
	if maxLevel < abilLv then
		isMax = 1;
	end

	
	local onlyShowLearnable = GET_CHILD_RECURSIVELY(frame,"onlyShowLearnable")

	-- 배울 ???�는 ?�성�??�시
	if onlyShowLearnable:IsChecked() == 1 then
	
		if isMax == 1 then
			return posY
		end

		local unlockFuncName = groupClass.UnlockScr;
		if unlockFuncName ~= 'None' then
			local scp = _G[unlockFuncName];
			local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
			if ret ~= 'UNLOCK' then

				if ret == 'LOCK_GRADE' then
					return posY
				
				elseif ret == 'LOCK_LV' then
					return posY
			
				end
			end
		end

	end

	local classCtrl = grid:CreateOrGetControlSet('abilityshop_set', 'ABILSHOP_'..abilClass.ClassName, 20, posY);
	classCtrl:ShowWindow(1);
	

	if maxLevel >= abilLv then
		classCtrl:SetEventScript(ui.LBUTTONUP, "REQUEST_BUY_ABILITY");
		classCtrl:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		classCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		classCtrl:SetOverSound('button_over');
		classCtrl:SetClickSound('button_click_big');
	else
		abilLv = groupClass.MaxLevel;
	end

	-- abilClass관???�보 ?�팅
	-- ?�성 ?�이�?
	local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
	classSlot:EnableHitTest(0);
	local icon = CreateIcon(classSlot);	
	icon:SetImage(abilClass.Icon);

	-- ?�성 ?�름
	local nameCtrl = GET_CHILD(classCtrl, "abilName", "ui::CRichText");
	nameCtrl:SetText("{@st42}".. abilClass.Name);

	-- ?�성 ?�벨
	local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
	levelCtrl:SetText("Lv.".. abilLv);

	-- ?�성 ?�명
	local descCtrl = GET_CHILD(classCtrl, "abilDesc", "ui::CRichText");
	descCtrl:SetText("{@st66b}".. abilClass.Desc);


	-- groupClass관???�보 ?�팅
	local price = 0;
	local totalTime = 0;
	local funcName = groupClass.ScrCalcPrice;
	if funcName ~= 'None' then
		local scp = _G[funcName];
		price, totalTime = scp(pc, abilClass.ClassName, abilLv, groupClass.MaxLevel);
	else
		abilLv = tonumber(abilLv)
		price = groupClass["Price" .. abilLv];
		totalTime = groupClass["Time" .. abilLv];
	end

	local priceCtrl = GET_CHILD(classCtrl, "abilPrice", "ui::CRichText");	
	priceCtrl:SetText("{img Silver 24 24} {@st42b}{s16}".. price ..ScpArgMsg("Auto__{@st42b}SilBeo"));
	classCtrl:SetUserValue("PRICE_"..abilClass.ClassName, price);
	
	local timeCtrl = GET_CHILD(classCtrl, "abilTime", "ui::CRichText");	
	local hour = math.floor( totalTime / 60 );
	local min = totalTime % 60;
	if hour > 0 then
		timeCtrl:SetText("".. hour ..ScpArgMsg("Auto_SiKan_") .. min .. ScpArgMsg("Auto_Bun_Soyo"));
	else
		if min < 1 then

			if min == 0 then
				timeCtrl:SetText(ScpArgMsg("AbilClicker"));
			else
				local sec = math.floor(min * 100);
				timeCtrl:SetText(sec .. ScpArgMsg("Auto_Cho_Soyo"));
			end
		else
			timeCtrl:SetText(min .. ScpArgMsg("Auto_Bun_Soyo"));
		end
	end


	if isMax == 1 then
		priceCtrl:ShowWindow(0);
		timeCtrl:SetText(ScpArgMsg("Auto_{@st}_ChoeKo_LeBel_MaSeuTeo!"));
		levelCtrl:SetText("Lv.".. groupClass.MaxLevel);
	end
	
	local unlockFuncName = groupClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
		if ret ~= 'UNLOCK' then

			if ret == 'LOCK_GRADE' then
				priceCtrl:ShowWindow(0);
				timeCtrl:SetText(groupClass.UnlockDesc);
				classCtrl:SetGrayStyle(1);
			elseif ret == 'LOCK_LV' then
				priceCtrl:ShowWindow(0);
				timeCtrl:SetText(ScpArgMsg('NeedMorePcLevel'));
				classCtrl:SetGrayStyle(1);
			end
		end
	end

	if pc.LearnAbilityID > 0 then
		if pc.LearnAbilityID == abilClass.ClassID then

			classCtrl:SetGrayStyle(0);

			priceCtrl:SetText(ScpArgMsg("Auto_{@st}TeugSeong_HagSeup_Jung"));

		else
			-- ?�성??배우?�중?�라�?배우???�킬???�외?�고???��? ?�색?�로 변경해?�함.
			classCtrl:SetGrayStyle(1);
		end
		classCtrl:EnableHitTest(0);
	end

	classCtrl:Resize(classCtrl:GetOriginalWidth(), descCtrl:GetY() + descCtrl:GetHeight() + 50)

	if classCtrl:GetHeight() < classCtrl:GetOriginalHeight() then
		classCtrl:Resize(classCtrl:GetOriginalWidth(), classCtrl:GetOriginalHeight())
	end

	return posY + classCtrl:GetHeight();
end


s_buyAbilName = 'None';

function REQUEST_BUY_ABILITY(frame, control, abilName, abilID)

	-- 구입가?�한지 ?�버 체크?�기
	local price = tonumber( control:GetUserValue("PRICE_"..abilName) );
	if GET_TOTAL_MONEY() < price then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	-- ?�건지 ?�인�??�우�?
	s_buyAbilName = abilName;
	local yesScp = string.format("EXEC_BUY_ABILITY()");
	ui.MsgBox(ClMsg('ExecLearnAbility'), yesScp, "None");

end

function EXEC_BUY_ABILITY()

	-- ?�단?� ?�성 바로 배워지?�걸�??�팅. DB?�간관?�해?�는 ?�일 ?�업?�정.
	pc.ReqExecuteTx("SCR_TX_ABIL_REQUEST", s_buyAbilName);
end

