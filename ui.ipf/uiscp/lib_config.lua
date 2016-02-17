---- lib_config.lua

function UPDATE_CONTROL_MODE()

	SetLockKeyboardSelectMode(0);
	local controlmodeType = tonumber(config.GetXMLConfig("ControlMode"));
	if controlmodeType == 0 then
		--자동
		SetChangeUIMode(0)
	elseif controlmodeType == 1 then
		--조이패드
		SetChangeUIMode(1)
		SetJoystickMode(1)
		UI_MODE_CHANGE(1)
	elseif controlmodeType == 2 then
		--키보드
		SetChangeUIMode(2)
		SetJoystickMode(0)
		UI_MODE_CHANGE(2)
	elseif controlmodeType == 3 then
		SetLockKeyboardSelectMode(1);
		SetChangeUIMode(3);
		SetJoystickMode(0);
		UI_MODE_CHANGE(2)
	end

	if controlmodeType == 3 then
		session.config.SetMouseMode(true);
	else
		session.config.SetMouseMode(false);
	end

	local modetime = session.GetModeTime();
	if modetime > 0 then
		local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
		QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(quickSlotFrame);
		quickSlotFrame:Invalidate();
	end
end

function UPDATE_SNAP()
	config.UpdateSnap()
end

function UPDATE_OTHER_PC_EFFECT(value)
	config.EnableOtherPCEffect(tonumber(value));
end

