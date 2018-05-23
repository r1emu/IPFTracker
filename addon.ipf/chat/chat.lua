

-- ���� �ִ� �Լ��鵵 �����˻� �ؾ� ��


CHAT_LINE_HEIGHT = 100;

function CHAT_ON_INIT(addon, frame)	
	
	-- ���콺 ȣ������ ���� ���콺 ���Ҷ� �ݱ� �̺�Ʈ ���� �κ�.
	local btn_emo = GET_CHILD(frame, "button_emo");
	btn_emo:SetEventScript(ui.MOUSEMOVE, "CHAT_OPEN_EMOTICON");

	local btn_type = GET_CHILD(frame, "button_type");
	btn_type:SetEventScript(ui.MOUSEMOVE, "CHAT_OPEN_TYPE");	

end

--ä�ùٸ� Open�Ҷ����� �ҷ������.
function CHAT_OPEN_INIT()
	--'ä�� Ÿ��'�� ���� ä�ù��� 'ä��Ÿ�� ��ư ���'�� �����ȴ�.
	if config.GetServiceNation() == "JP" or config.GetServiceNation() == "GLOBAL" or config.GetServiceNation() == "IDN" then
		local frame = ui.GetFrame('chat');	
		local chatEditCtrl = frame:GetChild('mainchat');
		local btn_emo = GET_CHILD(frame, "button_emo");
		local titleCtrl = GET_CHILD(frame,'edit_to_bg');	
		chatEditCtrl:Resize(chatEditCtrl:GetOriginalWidth() - btn_emo:GetWidth() - titleCtrl:GetWidth() - 28, chatEditCtrl:GetOriginalHeight());
	end
end;

function CHAT_CLOSE_SCP()
	CHAT_CLICK_CHECK();
end;

function CHAT_WHISPER_INVITE(ctrl, ctrlset, roomID, artNum)
	ctrl:SetUserValue("ROOM_ID",roomID)
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER2", "",nil,roomID,20);
end

function CHAT_NOTICE(msg)
	session.ui.GetChatMsg():AddNoticeMsg(ScpArgMsg("NoticeFrameName"), msg, true); 
end

function CHAT_SYSTEM(msg)
	session.ui.GetChatMsg():AddSystemMsg(msg, true); 
end


--ä��Ÿ�Կ� ���� 'ä�ù��� �Է±�' ��ġ�� ũ�� ����. 
function CHAT_SET_TO_TITLENAME(chatType, targetName)
	local frame = ui.GetFrame('chat');
	local chatEditCtrl = frame:GetChild('mainchat');
	local titleCtrl = GET_CHILD(frame,'edit_to_bg');
	local editbg = GET_CHILD(frame,'edit_bg');
	local name  = GET_CHILD(titleCtrl,'title_to');		
	local btn_ChatType = GET_CHILD(frame,'button_type');

	-- �ӼӸ� ctrl�� ������ġ�� type btn ���ʿ�.
	titleCtrl:SetOffset(btn_ChatType:GetOriginalWidth(), titleCtrl:GetOriginalY());
	local offsetX = btn_ChatType:GetOriginalWidth(); -- ���� offset�� type btn ���� ��������.
	local titleText = '';
	local isVisible = 0;

	-- �Ӹ��� �׷�ä�ÿ� ���� ��븦 ǥ���ؾ� �� ��� 
	if chatType == CT_WHISPER then

		isVisible = 1;
		titleText = ScpArgMsg('WhisperChat','Who',targetName);

	elseif chatType == CT_GROUP then
		
		isVisible = 1;
		titleText = session.chat.GetRoomConfigTitle(targetName)
		if titleText == "" or titleText == nil then
			return
		end

	end
		
	-- �̸��� ���� ��������� ũ��� ��ġ ������ �̷������.
	name:SetText(titleText);	
	if titleText ~= '' then
		titleCtrl:Resize(name:GetWidth() + 20, titleCtrl:GetOriginalHeight())
	else
		titleCtrl:Resize(name:GetWidth(), titleCtrl:GetOriginalHeight())
	end
		
	if isVisible == 1 then
		titleCtrl:SetVisible(1);
		offsetX = offsetX + titleCtrl:GetWidth();
	else
		titleCtrl:SetVisible(0);
	end;
		
	local width = chatEditCtrl:GetOriginalWidth() - titleCtrl:GetWidth() - btn_ChatType:GetWidth();
	chatEditCtrl:Resize(width, chatEditCtrl:GetOriginalHeight())
	chatEditCtrl:SetOffset(offsetX, chatEditCtrl:GetOriginalY());			
end


-- ä��â�� �̸�Ƽ�ܼ���â�� �ɼ�â�� Open ��ũ��Ʈ
--{
function CHAT_OPEN_OPTION(frame)
	CHAT_SET_OPEN(frame, 1);
end

function CHAT_OPEN_EMOTICON(frame)
	CHAT_SET_OPEN(frame, 0);
end
--}

-- ä��â�� �̸�Ƽ�ܼ���â�� �ɼ�â�� �������� ��쿡 �ٸ� �� Ŭ���� �ش� â���� Close
function CHAT_CLICK_CHECK(frame)
	local type_frame = ui.GetFrame('chattypelist');
	local emo_frame = ui.GetFrame('chat_emoticon');
	local opt_frame = ui.GetFrame('chat_option');
	emo_frame:ShowWindow(0);
	opt_frame:ShowWindow(0);
	type_frame:ShowWindow(0);
end;

--�̸�Ƽ�ܼ���â�� �ɼ�â�� ��ġ�� ä�ùٿ� ���� �����ϰ� Open ����
function CHAT_SET_OPEN(frame, numFrame)
	local opt_frame = ui.GetFrame('chat_option');
	opt_frame:SetPos(frame:GetX() + frame:GetWidth() - 35, frame:GetY() - opt_frame:GetHeight());

	local emo_frame = ui.GetFrame('chat_emoticon');
	emo_frame:SetPos(frame:GetX() + 35, frame:GetY() - emo_frame:GetHeight());

	if numFrame == 0 then	
		opt_frame:ShowWindow(0);
		emo_frame:ShowWindow(1);
	elseif numFrame == 1 then
		opt_frame:ShowWindow(1);
		emo_frame:ShowWindow(0);
	end;
end;

-- ä��â�� 'Ÿ�� ��� ���� ��ư'�� Ŭ���� 'Ÿ�� ���'�� ��ġ�� ä�ùٿ� ���� �����ϰ� Open
function CHAT_OPEN_TYPE()
	local chatFrame = ui.GetFrame('chat');
	local frame = ui.GetFrame('chattypelist');
	frame:SetPos(chatFrame:GetX() + 3, chatFrame:GetY() - frame:GetHeight());	
	frame:ShowWindow(1);	
	frame:SetDuration(3);
end;