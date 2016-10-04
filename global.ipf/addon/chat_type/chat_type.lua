
--채팅 타입 목록에서 5가지 타입들에 대하여 버튼목록들을 만들어준다. 
function CHAT_TYPE_LISTSET(selected)
	if selected == 0 then
		return;
	end;
	
	local frame = ui.GetFrame('chat');		
	frame:SetUserValue("CHAT_TYPE_SELECTED_VALUE", selected);
	local chattype_frame = ui.GetFrame('chattypelist');
	local chattype_frame_width = chattype_frame:GetWidth();
	
	local j = 1;
	for i = 1, 5 do

		local color = frame:GetUserConfig("COLOR_BTN_" .. i);	
		if selected ~= i then	
			
		-- 선택되지 않은 타입들은 목록화
		local btn_Chattype = GET_CHILD(chattype_frame, "button_type" .. j);
			if btn_Chattype == nil then
				return;
			end						
			-- 버튼 크기를 rect의 width height 값으로 고정
			btn_Chattype:Resize(btn_Chattype:GetOriginalWidth(), btn_Chattype:GetOriginalHeight()); -- SetText 전에 해줘야 정렬됨.

			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i)  .. "{/}";
			btn_Chattype:SetText(msg);	
			btn_Chattype:SetTextTooltip( ScpArgMsg("ChatType_" .. i .. "_ToolTip") );
			btn_Chattype:SetPosTooltip(btn_Chattype:GetWidth() + 10 , (btn_Chattype:GetHeight() /2));
			btn_Chattype:SetColorTone( "FF".. color);

			--다른 프레임에서의 버튼다운이 되었을때도 비주얼상 반응하는 것처럼 보이게 하기 위한 설정
			btn_Chattype:SetIsUpCheckBtn(true);

			--나중에 목록 중에서 선택되었을때에 해당 타입을 전달하기 위한 심볼 설정. 
			btn_Chattype:SetUserValue("CHAT_TYPE_CONFIG_VALUE", i);

			--채팅창의 버튼과 목록들은 서로 다른 프레임으로서 해당 번호는 서로 달리 카운트된다.
			j = j + 1;

			
			
		else

		--선택된 타입은 채팅바의 버튼으로
			local btn_type = GET_CHILD(frame, "button_type");
			if btn_type == nil then
				return;
			end			

			-- 버튼 크기를 rect의 width height 값으로 고정
			btn_type:Resize(btn_type:GetOriginalWidth(), btn_type:GetOriginalHeight());

			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i) .. "{/}";
			btn_type:SetText(msg);	
			btn_type:SetColorTone("FF".. color);
			config.SetConfig("ChatTypeNumber", i);
			
		end;
	end;
end;
