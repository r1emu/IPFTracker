-- lib_warehouse.lua --

function REGISTER_WAREHOUSE_MSG(addon, frame)
	addon:RegisterMsg("WAREHOUSE_ITEM_LIST", "ON_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("WAREHOUSE_ITEM_ADD", "ON_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("WAREHOUSE_ITEM_REMOVE", "ON_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("WAREHOUSE_ITEM_CHANGE_COUNT", "ON_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("WAREHOUSE_ITEM_IN", "ON_WAREHOUSE_ITEM_LIST");

end
