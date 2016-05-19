function CASTINGBAR_ON_INIT(addon, frame)
 
	-- �⺻ ĳ���ù� (��ų�����ϸ� �� �ɽ��ýð���ŭ �������� Ǯ�� ���� ��ų����. ���ۺҰ�)
	addon:RegisterMsg('CAST_BEGIN', 'CASTINGBAR_ON_MSG');
	addon:RegisterMsg('CAST_ADD', 'CASTINGBAR_ON_MSG');
	addon:RegisterMsg('CAST_END', 'CASTINGBAR_ON_MSG');

	-- ���̳��� ĳ���ù� (��ųŰ �������ִ� ���¿����� ����������. ��ųŰ���� ��ų����)
	addon:RegisterMsg('DYNAMIC_CAST_BEGIN', 'DYNAMIC_CASTINGBAR_ON_MSG');
	addon:RegisterMsg('DYNAMIC_CAST_END', 'DYNAMIC_CASTINGBAR_ON_MSG');

end 

function CASTINGBAR_ON_MSG(frame, msg, argStr, argNum)

	if msg == 'CAST_BEGIN' then		-- ���� ����
	 
		local castingObject = frame:GetChild('casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");		

		local time = argNum / 1000;   -- �̺κ� �ʿ��� ������ ����
			
		castingGauge:SetTotalTime(time);	
		castingGauge:SetText(argStr, 'normal', 'center', 'bottom', 0, 0);

		local sklObj = GetSkill(GetMyPCObject(), argStr);
		if nil ~= sklObj then
			local sklName = argStr;
			local skillName = frame:GetChild("skillName");
			local translatedData = dictionary.ReplaceDicIDInCompStr(sklObj.Name);
			if sklObj.EngName == translatedData then
				sklName = sklObj.EngName;
			end
			skillName:SetTextByKey("name", sklName);
		end

		local animpic = GET_CHILD_RECURSIVELY(frame, "animpic");
		animpic:SetUserValue("LINKED_GAUGE", 0);
		LINK_OBJ_TO_GAUGE(frame, animpic, castingGauge, 1);
		
		frame:ShowWindow(1);
	end 

	if msg == 'CAST_ADD' then		-- ���� �� ���� �Ǵ� ���� �ð�
	 
		local castingObject = frame:GetChild('casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		local time	= argNum / 1000;   -- �̺κ� �ʿ��� ������ ����
			
		castingGauge:AddTotalTime(time);
	end 

	if msg == 'CAST_END' then		-- ������ ������� �޽��� ó��
	    local animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		animpic:SetUserValue("LINKED_GAUGE", 0);
		frame:ShowWindow(0);
	end 

	-- �������� 2������ �ٸ� 1���� ����
	frame:GetChild('dynamic_casting'):ShowWindow(0);
end 

function DYNAMIC_CASTINGBAR_ON_MSG(frame, msg, argStr, maxTime, isVisivle)

	if msg == 'DYNAMIC_CAST_BEGIN' and maxTime > 0 then		-- ���� ����
	 
		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		
		castingGauge:SetTotalTime(maxTime);
		frame:SetUserValue("MAX_CHARGE_TIME", maxTime);
		castingGauge:SetText("1", 'normal', 'center', 'bottom', 0, 0);
		
		local timer = frame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_CASTTIME");
		timer:SetValue( imcTime.GetDWTime() );
		timer:Start(0.01);
		if isVisivle == nil then
			isVisivle = 0;
		end
		
		local sList = StringSplit(argStr, "#");
		local sklName = argStr;
		if 1 < #sList then
			sklName = sList[1];
		end

		local sklObj = GetSkill(GetMyPCObject(), sklName);
		if nil ~= sklObj then
			local skillName = frame:GetChild("skillName");
			sklName = sklObj.Name;
			local translatedData = dictionary.ReplaceDicIDInCompStr(sklObj.Name);
			if sklObj.Name ~= translatedData then
				sklName = translatedData;
			end
			skillName:SetTextByKey("name", sklName);
		end

		frame:ShowWindow(isVisivle);

		frame:SetSkinName('skill-charge_gauge_bg');
		castingGauge:SetSkinName('skill-charge_gauge2');
		castingGauge:SetInverse(0);
		frame:Invalidate();
		frame:SetUserValue('LOOPING_CHARGE', 0);

		if 1 < #sList then
			frame:SetUserValue('LOOPING_CHARGE', 1);			
		end

		local dynamic_animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		LINK_OBJ_TO_GAUGE(frame, dynamic_animpic, castingGauge, 1);
	end 

	if msg == 'DYNAMIC_CAST_END' then		-- ������ ������� �޽��� ó��

		local castingGauge = GET_CHILD(frame, 'dynamic_casting', "ui::CGauge");
		castingGauge:StopTimeProcess();	 
		local timer = frame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:Stop();
		frame:ShowWindow(0);
		frame:SetUserValue('LOOPING_CHARGE', 0);

		local dynamic_animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		dynamic_animpic:SetUserValue("LINKED_GAUGE", 0);
	end 

	-- �������� 2������ �ٸ� 1���� ����
	frame:GetChild('casting'):ShowWindow(0);
end 

function UPDATE_CASTTIME(frame)
	
	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");		
	
	local time = (imcTime.GetDWTime() - timer:GetValue()) / 1000;
	local maxTime = tonumber( frame:GetUserValue("MAX_CHARGE_TIME") );
	

	local chargeType = tonumber( frame:GetUserValue('LOOPING_CHARGE') );

	if chargeType == 0 then

		if maxTime < time then
			-- uiEffect�� useExternal�� �ȸԾ ����UI����Ʈ�� ���°� ���ϰ���. �׷��� �Ʒ�ó�� ó����.
			-- full charge ���°��Ǹ� ĳ���ýð� üũ�ϴ� �Լ��� �����ϰ� ����Ʈ ������ �Լ��� �ٽ� ����.
			timer:Stop();
			timer:SetUpdateScript("PLAY_FULL_CHARGING");		
			timer:Start(1);
			frame:Invalidate();
		end		

	elseif chargeType == 1 then
		
		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		castingGauge:SetPoint(time, maxTime);

		if maxTime < time then
			frame:SetUserValue('LOOPING_CHARGE', 2);
			timer:SetValue( imcTime.GetDWTime() );
		end

	elseif chargeType == 2 then

		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		castingGauge:SetPoint(maxTime-time, maxTime);

		if maxTime < time then
			frame:SetUserValue('LOOPING_CHARGE', 1);
			timer:SetValue( imcTime.GetDWTime() );
		end
	end

end

function PLAY_FULL_CHARGING(frame)

	local posX, posY = GET_SCREEN_XY(frame);
	movie.PlayUIEffect('I_sys_fullcharge', posX, posY, 6.2);
	imcSound.PlaySoundEvent("sys_alarm_fullcharge");
end