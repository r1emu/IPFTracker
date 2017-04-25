

function CHAT_TYPE_INIT(addon, frame)	
	
end

function CHAT_TYPE_CLOSE(frame)
	local chattype_frame = ui.GetFrame('chattypelist');
	chattype_frame:ShowWindow(0);
end

--ä�� Ÿ�� ��Ͽ��� ���ý� ä��Ÿ���� �ٲ��ְ� ����� �ݾ��ش�. 
function CHAT_TYPE_SELECTION(frame, ctrl)
	-- ������ �ɺ��� ���õ� Ÿ���� �˾ƺ���.
	local typeIvalue = ctrl:GetUserIValue("CHAT_TYPE_CONFIG_VALUE");
	if (nil == typeIvalue) or (0 == typeIvalue) or (typeIvalue > 6) then
		return;
	end;

	ui.SetChatType(typeIvalue-1);
	CHAT_TYPE_CLOSE(frame);
end;

--ä�� Ÿ�� ��Ͽ��� 6���� Ÿ�Ե鿡 ���Ͽ� ��ư��ϵ��� ������ش�. 
function CHAT_TYPE_LISTSET(selected)
	if selected == 0 then
		return;
	end;

	if ui.GetWhisperTargetName() == nil and selected == 5 then
		return;
	end

	if (ui.GetGroupChatTargetID() == nil or ui.GetGroupChatTargetID() == "") and selected == 6 then
		return;
	end


	local frame = ui.GetFrame('chat');		
	frame:SetUserValue("CHAT_TYPE_SELECTED_VALUE", selected);
	local chattype_frame = ui.GetFrame('chattypelist');
    local chattype_frame_width = chattype_frame:GetWidth();

	local j = 1;
	for i = 1, 6 do

		local color = frame:GetUserConfig("COLOR_BTN_" .. i);	
		if selected ~= i then	
			
			-- ���õ��� ���� Ÿ�Ե��� ���ȭ
			local btn_Chattype = GET_CHILD(chattype_frame, "button_type" .. j);
			if btn_Chattype == nil then
				return;
			end			

            -- ��ư ũ�⸦ rect�� width height ������ ����
			btn_Chattype:Resize(btn_Chattype:GetOriginalWidth(), btn_Chattype:GetOriginalHeight()); -- SetText ���� ����� ���ĵ�.
			
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i)  .. "{/}";
			btn_Chattype:SetText(msg);	
			btn_Chattype:SetTextTooltip( ScpArgMsg("ChatType_" .. i .. "_ToolTip") );
			btn_Chattype:SetPosTooltip(btn_Chattype:GetWidth() + 10 , (btn_Chattype:GetHeight() /2));
			btn_Chattype:SetColorTone( "FF".. color);

			--�ٸ� �����ӿ����� ��ư�ٿ��� �Ǿ������� ���־�� �����ϴ� ��ó�� ���̰� �ϱ� ���� ����
			btn_Chattype:SetIsUpCheckBtn(true);

			--���߿� ��� �߿��� ���õǾ������� �ش� Ÿ���� �����ϱ� ���� �ɺ� ����. 
			btn_Chattype:SetUserValue("CHAT_TYPE_CONFIG_VALUE", i);

			--ä��â�� ��ư�� ��ϵ��� ���� �ٸ� ���������μ� �ش� ��ȣ�� ���� �޸� ī��Ʈ�ȴ�.
			j = j + 1;
		else

		--���õ� Ÿ���� ä�ù��� ��ư����
			local btn_type = GET_CHILD(frame, "button_type");
			if btn_type == nil then
				return;
			end	
            
            -- ��ư ũ�⸦ rect�� width height ������ ����
			btn_type:Resize(btn_type:GetOriginalWidth(), btn_type:GetOriginalHeight());
            		
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i) .. "{/}";
			btn_type:SetText(msg);	
			btn_type:SetColorTone("FF".. color);
			
		end;
	end;
end;


