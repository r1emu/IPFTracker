-- toolskill_input.lua

function SKL_KEY_DYNAMIC_CASTING(actor, obj, dik, movable, rangeChargeTime, maxChargeTime, autoShot, rotateAble, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockwave, intensity, time, frequency, angle, quickCast, checkState)

	if isVisivle == nil then
		isVisivle = 1;
	end

	if isFullCharge == nil then
		isFullCharge = 0;
	end

	if effectName == nil then
		effectName = "None"
	end

	if scale == nil then
		scale = 1.0;
	end

	if nodeName == nil then
		nodeName = "None"
	end

	if lifeTime == nil then
		lifeTime = 0;
	end

	if shockwave == nil then
		shockwave = 0
	end

	if intensity == nil then 
		intensity = 0
	end
	
	if time == nil then
		time = 0
	end	
	if	frequency == nil then
		frequency = 0;
	end 

	if angle == nil then
		angle = 0;
	end

	if quickCast == nil then
		quickCast = 1
	end

	geSkillControl.DynamicCastingSkill(actor, obj.type, dik, movable, rotateAble, rangeChargeTime, maxChargeTime, autoShot, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, isVisivle, useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, scale,1,1,1, shockwave, intensity, time, frequency, angle, quickCast);
	if gotoSkillUse == 1 then
		return 0, 0;
	end
	
	return 1, 0;
end

function SKL_KEY_SELECT_CELL(actor, obj, dik, cellCount, cellSize, chargeTime, autoShot, cellEft, cellEftScale, selCellEft, selCellEftScale, selectionEft, selectionEftScale, backSelect, drawSelectablePos)
	geSkillControl.CellSelectCasting(actor, obj.type, dik, cellCount, cellSize, chargeTime, autoShot, cellEft, cellEftScale, selCellEft, selCellEftScale, selectionEft, selectionEftScale, backSelect, drawSelectablePos);
	return 1;
end

function SKL_KEY_GROUND_EVENT(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, 
	shockWave, shockPower, shockTime, shockFreq, shockAngle, onlyMouseMode, quickCast)
	
	if onlyMouseMode == 1 and session.config.IsMouseMode() == false then
		geSkillControl.SendGizmoPosByCurrentTarget(actor, obj.type);
		return 0, 1;
	end

	if useDynamicLevel == nil then
		useDynamicLevel = 1.0;
	end

	if isVisivle == nil then
		isVisivle = 1;
	end

	if isFullCharge == nil then
		isFullCharge = 0;
	end

	if effectName == nil then
		effectName = "None"
	end

	if scale == nil then
		scale = 1.0;
	end

	if nodeName == nil then
		nodeName = "None"
	end

	if lifeTime == nil then
		lifeTime = 0;
	end

	if shockwave == nil then
		shockwave = 0
	end

	if intensity == nil then 
		intensity = 0
	end
	
	if time == nil then
		time = 0
	end	
	if	frequency == nil then
		frequency = 0;
	end 
	if angle == nil then
	angle = 0;
	end
	
	if quickCast == nil then
		quickCast = 1;
	end

	geSkillControl.GroundSelecting(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, isVisivle, useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, scale,1,1,1, shockwave, intensity, time, frequency, angle, nil, quickCast);
	return 1, 0;
end

function SKL_KEY_SNIPE(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockWave, shockPower, shockTime, shockFreq, shockAngle, onlyMouseMode)

	local time = 0;
	local frequency = 0;
	local angle = 0;
	local intensity = 0;
		if shockwave == nil then
		shockwave = 0
	end


	geSkillControl.GroundSelecting(actor, obj.type, dik, chargeTime, autoShot, 
		shotCasting, lookTargetPos, selRange, upAbleSec, isVisivle, 
		useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, 
		scale,1,1,1, shockwave, 
		intensity, time, frequency, angle, "Snipe");
	return 1, 0;
end

function SKL_KEY_GROUND_ARC(actor, obj, dik, chargeTime,  autoShot, shotCasting, lookTargetPos, upAbleSec, rotatable, minRange, maxRange, linkName, dummyName, eft, eftScale)
	geSkillControl.GroundSelectByArc(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, upAbleSec, rotatable, minRange, maxRange, linkName, dummyName, eft, eftScale);
	return 1, 0;
end

function SKL_KEY_GROUND_CONNECTION(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, x, y, z, moveSpd)
	geSkillControl.GroundConnection(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, x, y, z, moveSpd);
	return 1, 0;
end

function SKL_KEY_PRESS(actor, obj, dik, startDelay, pressSpd, duration)
	geSkillControl.KeyPress(actor, obj.type, dik, startDelay, pressSpd, duration);
	return 0, 0;
end

function SKL_SKILL_REUSE_ON_BTN_UP(actor, obj, dik, buffName)
	geSkillControl.SkillReuseOnDikUp(actor, obj.type, dik, buffName);
	return 0;
end