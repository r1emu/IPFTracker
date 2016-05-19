function WIKIADD_ON_INIT(addon, frame)
	--�޽���
	addon:RegisterMsg('WIKI_LIST_ADD', 'ADD_WIKI');
	addon:RegisterMsg('ACHIEVE_NEW', 'ADD_ACHIEVE');
end

function ADD_WIKI(frame, msg, argStr, argNum)
	local wikicls = GetClassByType("Wiki", argNum);
	if wikicls == nil then
		return;
	end

	if wikicls.Category == "Item" then -- �������� sequentialpickitem���� ó���Ѵ�.
		return;
	end

	local pickitemText 	= frame:GetChild('pickitemtext');
	local targetCls = GetClass(wikicls.Category, wikicls.ClassName);
	local name;
	if GetPropType(targetCls, "Name") ~= nil then
		name = targetCls.Name;
	else
		name = wikicls.Name;
	end
	
	local msg = string.format("{a WIKI %d}{#050505}{s24}%s{nl}{s20}%s{/}{/}", argNum, name, ScpArgMsg("WIKI_ADDED"));
	pickitemText:SetText(msg);
	frame:ShowWindow(1);
	frame:SetDuration(3.0);

	--imcSound.PlaySoundItem('travel_diary_1');
end

function ADD_ACHIEVE(frame, msg, argStr, argNum)
	local cls = GetClassByType("Achieve", argNum);
	if cls == nil then
		return;
	end

	local pickitemText 	= frame:GetChild('pickitemtext');

	local msg = ScpArgMsg("Auto_{a_OPEN_ACHIEVE_0}{#050505}{s24}[{Auto_1}]{nl}{s20}eopJeogeul_HoegDeugHayeossSeupNiDa.{/}{/}", "Auto_1", cls.DescTitle);
	pickitemText:SetText(msg);
	frame:ShowWindow(1);
	frame:SetDuration(3.0);
end

function OPEN_ACHIEVE()
	ui.OpenFrame("achieve");
end
