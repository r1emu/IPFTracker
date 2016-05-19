-- gacha_cube.lua --

function GACHA_CUBE_ON_INIT(addon, frame)

end

-- ť�� �̱� ��� ��� �κ�
function CANCEL_GACHA_CUBE()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.SetEscapeScp("");

	CancelGachaCube();												-- �̱� ��Ҹ� ������ �˸�.

	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);							-- UI ����		
end

-- ��ư Ŭ�� (2, 3��° �̱�)
function GACHA_CUBE_OK_BTN(frame, ctrl)
	item.DoPremiumItemGachaCube();	-- 1��°�� �ٸ��� ������ null�� ���� ����
end

-- �̱� ���� ��, ��� UIâ �����Ͽ� ���� 
function GACHA_CUBE_SUCEECD(invItemClsID, rewardItem, btnVisible)
	-- UIâ ���ͼ�	 �ʱ�ȭ
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);	
	
	-- UIâ�� ȣ���� ť�� ���� ������
	local cubeItem = GetClassByType("Item", invItemClsID);

	-- UIâ�� ��ġ ����
	local invframe = ui.GetFrame("inventory");

	-- ��� UI â�� ���������� ������ �������� ��� �� ����.
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_LOCK");
	
	-- UIâ�� ��� ����
	ui.SetEscapeScp("CANCEL_GACHA_CUBE()");
	
	-- �������� ȣ���� ������ �̸� �� ��ư�� ��� ����	
	local CubeNameFrame = gachaCubeFrame:GetChild("richtext_1");	
	local sucName = string.format("{@st41b}%s", cubeItem.Name);	

	CubeNameFrame:SetTextByKey("value", sucName);
	local BtnFrame = gachaCubeFrame:GetChild("button_1");	
	local price = TryGet(cubeItem, "NumberArg1");
	if price ~= nil then
		price = GetCommaedText(price);
	end

	local sucValue = string.format("{@st41b}%s{nl}{img icon_item_silver 20 20 }%s", ScpArgMsg("ONE_MORE_TIME"), price);
	BtnFrame:SetTextByKey("value", sucValue);	
	BtnFrame:SetVisible(btnVisible);
	
	local EndFrame = gachaCubeFrame:GetChild("richtext_4");	
	EndFrame:SetVisible(0);
	
	-- ���� ��ǰ �̸����� ������Ʈ ���� ã��
	local reward = GetClass("Item", rewardItem);
		
	-- ���� ���� ���Կ� ����
	local slot  = gachaCubeFrame:GetChild("slot");
	SET_SLOT_ITEM_OBJ(slot, reward);							-- ������ �̸����� ������ ����
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), reward.ClassID);	-- ������ ���� Ÿ������ ����
	
	-- ���� �� �̸� ����
	local rewardNameFrame = gachaCubeFrame:GetChild("itemName");
	rewardNameFrame:SetTextByKey("value", reward.Name);	
	
	-- ������ ���� UIâ ���̱�
	gachaCubeFrame:ShowWindow(1);
end


-- �̱� ���� ��, ��� UIâ ��� �ٲٱ�
function GACHA_CUBE_SUCEECD_EX(invItemClsID, rewardItem, btnVisible)	
	-- UIâ ���ͼ�	 �ʱ�ȭ
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
		
	-- UIâ�� ȣ���� ť�� ���� ������
	local cubeItem = GetClassByType("Item", invItemClsID);

	-- �������� ȣ���� ������ �̸� �� ��ư�� ��� ����	
	local CubeNameFrame = gachaCubeFrame:GetChild("richtext_1");	
	local sucName = string.format("{@st41b}%s", cubeItem.Name);
	CubeNameFrame:SetTextByKey("value", sucName);
	local BtnFrame = gachaCubeFrame:GetChild("button_1");	

	local price = TryGet(cubeItem, "NumberArg1");
	if price ~= nil then
		price = GetCommaedText(price);
	end

	local sucValue = string.format("{@st41b}%s{nl}{img icon_item_silver 20 20 }%s", ScpArgMsg("ONE_MORE_TIME"), price);
	BtnFrame:SetTextByKey("value", sucValue);	
	BtnFrame:SetVisible(btnVisible);

	-- ��ȸ�� ��� ����������
	if btnVisible == '0'  then
		local EndFrame = gachaCubeFrame:GetChild("richtext_4");	
		EndFrame:SetVisible(1);
	end

	-- ���� ��ǰ �̸����� ������Ʈ ���� ã��
	local reward = GetClass("Item", rewardItem);
		
	-- ���� ���� ���Կ� ����
	local slot  = gachaCubeFrame:GetChild("slot");
	SET_SLOT_ITEM_OBJ(slot, reward);							-- ������ �̸����� ������ ����
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), reward.ClassID);	-- ������ ���� Ÿ������ ����
	
	-- ���� �� �̸� ����
	local rewardNameFrame = gachaCubeFrame:GetChild("itemName");
	rewardNameFrame:SetTextByKey("value", reward.Name);	
	
	-- ������ ���� UIâ ���̱�
	gachaCubeFrame:ShowWindow(1);
end

-- UI ����
function GHACHA_CUBE_UI_RESET(frame)	
	frame:SetUserValue("GACHA_CUBE", "None");		-- ȣ���� ������ ���� �ʱ�ȭ
	local itemName = frame:GetChild("itemName");	-- ����� �̸� ������ �޾ƿ���
	itemName:SetTextByKey("value", "");				-- �̸� �ʱ�ȭ
		
	local slot  = frame:GetChild("slot");			-- ����� ���� ������ �޾ƿ���
	slot  = tolua.cast(slot, 'ui::CSlot');			
	slot:ClearIcon();								-- �� �������� �ʱ�ȭ

	frame:ShowWindow(0);							-- ������ �����
	
	local invframe = ui.GetFrame("inventory");		-- �κ��丮 ������ �޾ƿ���
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_UNLOCK");
	SET_SLOT_APPLY_FUNC(invframe, "None");			-- �κ� ���� ���� ���� �ʱ�ȭ
end

-- Inven ���� GHACHA_CUBE ���� ITEM�� �� ��Ű�� 
function GHACHA_CUBE_ITEM_LOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE ���� ITEM��
		slot:GetIcon():SetGrayStyle(1);						-- �ش� ������ ���� �˰�.
		slot:ReleaseBlink();
	end	
end

-- Inven ���� GHACHA_CUBE ���� ITEM�� ��� ��Ű��
function GHACHA_CUBE_ITEM_UNLOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE ���� ITEM��
	end	
end

