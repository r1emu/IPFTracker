---- lib_ENCHANTCHIP.lua

function ENCHANTCHIP_ABLIE(item)
	
	if item.GroupName ~= "Armor" then
		return 0;
	end

	if item.ClassType ~= 'Hat' then
		return 0;
	end

	return 1;
end

function IS_ENCHANT_ITEM(item)
	if item.ClassName == "Premium_Enchantchip" then
		return 1;
	end

	return 0;
end