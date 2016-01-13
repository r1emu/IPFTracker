--alchemist_shared.lua

function ALCHEMIST_MATERIAL_Alchemist_Briquetting(invItemList)
	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_catalyst_1" then
			count = count + invItem.count;
		end
	end

	return "misc_catalyst_1", count;
end

function ALCHEMIST_CHECK_Alchemist_Briquetting(self, item)
	if nil == item then
		return 0;
	end

	--���� �����ռ��Դϴ�.
	return ITEMBUFF_CHECK_Squire_WeaponTouchUp(sefl, item)
end

function ALCHEMIST_VALUE_Alchemist_Briquetting(skillLevel, itemValue)
	-- ���� 1�� ��, �⺻ �ʱ�ȭ
	local minPercent = 0.955 - skillLevel * 0.005;
	local maxPerCent = 1.045 + skillLevel * 0.005;
	-- �ּ�, �ִ�
	return math.floor(itemValue * minPercent), math.floor(itemValue * maxPerCent);
end

function ALCHEMIST_NEEDITEM_Alchemist_Briquetting(self, item)
	local needCount = (item.ItemLv / 5);
	needCount = math.max(1, needCount);
	return "misc_catalyst_1", math.floor(needCount);
en