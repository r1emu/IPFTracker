function IS_ENCHANT_ITEM(item)
	if item.ClassName == "Premium_Enchantchip" or item.ClassName == "Premium_Enchantchip14" or item.ClassName == "Premium_Enchantchip_CT" or item.ClassName == "Premium_Enchantchip14_NoStack" then
		return 1;
	end

	return 0;
end