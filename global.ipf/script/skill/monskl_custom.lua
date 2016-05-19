function SKL_HIT_SQUARE(self, skl, dist1, angle1, height1, dist2, angle2, height2, width, getTarget)

	if getTarget == nil then
		getTarget = 0;
	end

	if getTarget == 0 then
		local x, y, z = GetPos(self);
		local sx, sz = GetAroundPos(self, math.deg(angle1), dist1);
		local ex, ez = GetAroundPos(self, math.deg(angle2), dist2);
		local list, cnt = SelectObjectBySquareCoor(self, "ENEMY", sx, y, sz, ex, y, ez, width, 50);
	
		for i = 1, cnt do
			local obj = list[i];
			local damage = GET_SKL_DAMAGE(self, obj, skl.ClassName);
			TakeDamage(self, obj, skl.ClassName, damage);
		end
	
	elseif getTarget == 1 then
		
		local tgtList = GetHardSkillTargetList(self);
		for i = 1 , #tgtList do
			local tgt = tgtList[i];
			local damage = GET_SKL_DAMAGE(self, tgt, skl.ClassName);
			TakeDamage(self, tgt, skl.ClassName, damage);
		end	
	end

end

function SKL_TAKEDAMAGE_CIRCLE(self, skl, x, y, z, range, damRate, kdPower, damageFunc)

	if damageFunc ~= nil and damageFunc ~= "None" then
		damageFunc = _G[damageFunc];
	else
		damageFunc = nil;
	end	

	local remainSR = 1
	if skl ~= nil then
	    InvalidateObjectProp(skl, "SkillSR");
	    remainSR = skl.SkillSR
	end
	
	local list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY');
	for i = 1, cnt do
		local target = list[i];
		local damage = SCR_LIB_ATKCALC_RH(self, skl);
		damage = damage * damRate;
		if damageFunc ~= nil then
			damage = damageFunc(self, target, damage);
		end

		TakeDamage(self, target, skl.ClassName, damage);
		if kdPower > 0 then
			local angle = GetAngleFromPos(target, x, z);
			KnockDown(target, target, kdPower, angle, 45.0, 2, 1, 1);
		end
		
		remainSR = remainSR - target.SDR;
		
		if remainSR <= 0 then
		    break;
		end
	end

	if cnt > 0 and skl.ClassName == 'Barbarian_StompingKick' then
		CanLoopJump(self);
	end
end