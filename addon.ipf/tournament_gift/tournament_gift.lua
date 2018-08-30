
function TOURNAMENT_GIFT_ON_INIT(addon, frame)
	
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'TOURNA_GIFT_ITEM_CNT');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'TOURNA_GIFT_ITEM_CNT');
	addon:RegisterOpenOnlyMsg('GIVE_ITEM_COMPLETE', 'ON_GIVE_ITEM_COMPLETE');
	
end

function ON_GIVE_ITEM_COMPLETE(frame)
	local cid = frame:GetUserValue("CID");

	local info = session.otherPC.GetByStrCID(cid);
	if info == nil or info:GetAge() >= 10 then
		ui.PropertyCompare(handle, 0);
	end
	OPEN_TNMT_COMPARE(cid);	

end

function TOURNAMENT_GIFT_OPEN(handle, name)
	local frame = ui.GetFrame("tournament_gift");
	frame:ShowWindow(0);
	TOURNAMENT_GIFT_FIRST_OPEN(frame, handle, name);
	frame:ShowWindow(1);
	return frame;
end

function CLOSE_TOURNAMENT_GIFT(frame)
	local cid = frame:GetUserValue("CID");
	CLOSE_TNMT_COMPARE(cid);
end

function TOURNA_GIFT_ITEM_CNT(frame)
	TOURNAMENT_GIFT_UPDATE_CTRLS(frame);
end

function TOURNAMENT_GIFT_UPDATE_CTRLS(frame)

end

function TOURNAMENT_GIFT_FIRST_OPEN(frame, handle, name)

	local nameCtrl = frame:GetChild("name");
	if handle ~= nil then
		frame:SetUserValue("HANDLE", handle);
	end

	nameCtrl:SetTextByKey("value", name);

	TOURNAMENT_GIFT_UPDATE_CTRLS(frame);
	
end

function GIVE_TOUR_GIFT(set, btn)
	local frame = set:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");

	local clsName = set:GetUserValue("CLSNAME");
	local itemCls = GetClass("Item", clsName);

	_EXEC_GIVE_TOUR_GIFT(handle, clsName);
	--local execScp = string.format("_EXEC_GIVE_TOUR_GIFT(%d, \'%s\')", handle, clsName);
	--local msg = ClMsg("ReallyBuy?") .. GET_MONEY_IMG(24) .. " " ..itemCls.Price;
	--ui.MsgBox(msg, execScp, "None");
end

function _EXEC_GIVE_TOUR_GIFT(handle, clsName)
	local cls = GetClass("Tournament_Gift", clsName);
	geMGame.ReqTournamentGift(handle, cls.ClassID);
end

