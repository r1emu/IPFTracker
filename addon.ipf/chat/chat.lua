CHAT_LINE_HEIGHT = 100;

function CHAT_ON_INIT(addon, frame)	

end

function CHAT_ROOM_UPDATE(roomID) -- �׷� ä�� ����Ʈ ������Ʈ. �Ӹ� ��� �װ���

	local frame = ui.GetFrame("chatframe")

	local chatRoom = GET_CHILD(frame, 'chatgbox_'..roomID)	

	local info = session.chat.GetByStringID(roomID);

	local group = GET_CHILD(frame, "grouplist")
	if group ~= nil then
		local queue = GET_CHILD_RECURSIVELY(group, 'queue')
		local newMsgCount = info:GetNewMessageCount();
		local btn = GET_CHILD(queue, 'btn_'..roomID, "ui::CControlSet");
		if btn ~= nil then
			local text = GET_CHILD(btn, "text", "ui::CRichText");
			local notReadCount = info:GetNewMessageCount();

			if notReadCount > 0 then
				text:SetTextByKey("newmsg", string.format("(%d) ", newMsgCount));
			else
				text:SetTextByKey("newmsg", "");
			end
		end

	end


	--�׷� ��ü noticecountǥ��
	local whisper_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper") 
	SET_COUNT_NOTICE(whisper_btn, session.chat.GetAllGroupChatNotReadMsgCount() );
	local whisper_pic_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper_pic") 
	SET_COUNT_NOTICE(whisper_pic_btn, session.chat.GetAllGroupChatNotReadMsgCount() );

	frame:Invalidate();

end

function SET_COUNT_NOTICE(ctrl, count)

	if count <= 0 then
		ctrl:RemoveChild("COUNTNOTICE");
		return;
	end

	local ctrlSet = ctrl:CreateOrGetControlSet('countnotice', "COUNTNOTICE", 0, 0);

	ctrlSet:GetChild("count"):SetTextByKey("value", count);
	ctrlSet:ShowWindow(1)
	ctrl:Invalidate()
end


function CHAT_GROUP_REMOVE(roomID) 

	local frame = ui.GetFrame('chatframe');
	local child = frame:GetChild('chatgbox_'..roomID);
	if child == nil then
		return;
	end
	local visible = child:IsVisible();
	frame:RemoveChild('chatgbox_'..roomID);

	local group = GET_CHILD(frame, 'grouplist', 'ui::CGroupBox')
	local queue = GET_CHILD_RECURSIVELY(group, 'queue', 'ui::CQueue')
	queue:RemoveChild('btn_'..roomID);

	if visible == 1 then
		CHAT_WHISPER_ON_BTN_UP()
	end

	local popupframe = ui.GetFrame('chatpopup_'..roomID);
	if popupframe ~= nil then
		CLOSE_CHAT_POPUP(popupframe)
	end
end


function CHAT_WHISPER_TARGET_ON_BTN_UP(ctrl, ctrlset, argStr, artNum) 

	ui.SetChatGroupBox(CT_WHISPER,argStr);

end

function MAKE_POPUP_CHAT_BY_XML(roomid, titleText, width, height, x, y)
	
	titleText = string.sub(titleText, 8, string.len(titleText) - 3  )

	local newFrame = ui.CreateNewFrame("chatpopup", "chatpopup_" .. roomid);
	newFrame:SetOffset(x, y)
	newFrame:Resize(width, height)
	newFrame:ShowWindow(1);

	local name = newFrame:GetChild("name");
	name:SetTextByKey("title", titleText);

	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", "chatgbox_" .. roomid, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)


	chat.UpdateReadFlag(roomid);
	chat.CheckNewMessage(roomid);

	ui.RedrawGroupChat(roomid)
end

function MAKE_POPUP_CHAT(parent, ctrl, roomid)

	local info = session.chat.GetByStringID(roomid);
	if info == nil then
		return;
	end

	local oldframe = ui.GetFrame("chatpopup_" .. roomid )

	if oldframe ~= nil then

		oldframe:ShowWindow(1)

		chat.UpdateReadFlag(roomid);
		chat.CheckNewMessage(roomid);
		ui.RedrawGroupChat(roomid)

		return;
	end

	MAKE_POPUP_CHAT_BY_BTN(roomid)
end

g_popupframeinitx = 50
g_popupframeinity = 200

function MAKE_POPUP_CHAT_BY_BTN(roomid)
	
	local newFrame = ui.CreateNewFrame("chatpopup", "chatpopup_" .. roomid);
	newFrame:SetOffset(g_popupframeinitx,g_popupframeinity)
	newFrame:ShowWindow(1);

	g_popupframeinitx = g_popupframeinitx + 15
	g_popupframeinity = g_popupframeinity + 15

	local info = session.chat.GetByStringID(roomid);
	local titleText = GET_GROUP_TITLE(info);
	titleText = 'From. '..titleText;
	local name = newFrame:GetChild("name");
	name:SetTextByKey("title", titleText);

	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", "chatgbox_" .. roomid, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)


	chat.UpdateReadFlag(roomid);
	chat.CheckNewMessage(roomid);

	ui.RedrawGroupChat(roomid);

	ui.SaveChatConfig();
end


function SEND_POPUP_FRAME_CHAT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local guid = string.sub(parent:GetName() , 11, string.len(parent:GetName() ))

	local text = ctrl:GetText();
	local sendText = "/r " .. guid .. " " .. text;

	ctrl:SetText("");
	ui.Chat(sendText);

end


function GET_GROUP_TITLE(info)

	local memberString = "";

	if info == nil then
		return memberString
	end

	--[[
	if info:GetMemberCount() > 2 then
		memberString = ScpArgMsg('TargetNameandOthers','TargetName',info:GetMember(0),'Count',info:GetMemberCount()-1)
		return memberString;
	end
	]]

	for i = 0 , info:GetMemberCount() - 1 do
		if memberString ~= "" then
			memberString = memberString .. ", ";
		end

		memberString = memberString .. info:GetMember(i);
	end

	return memberString;
end

function CHAT_CREATE_GROUP_LIST(frame, roomID)

	local info = session.chat.GetByStringID(roomID);
	
	
	local queue = GET_CHILD_RECURSIVELY(frame, 'queue')



	local btn = queue:CreateOrGetControlSet("chatlist", 'btn_'..roomID, 0, 0);
	tolua.cast(btn, "ui::CControlSet");
	local newMsgCount = info:GetNewMessageCount();
	local text = GET_CHILD(btn, "text", "ui::CRichText");

	if newMsgCount > 0 then
		text:SetTextByKey("newmsg", string.format("(%d) ", newMsgCount));
	else
		text:SetTextByKey("newmsg", "");
	end

	local memberString = GET_GROUP_TITLE(info);
	text:SetTextByKey("title", memberString);
	btn:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_TARGET_ON_BTN_UP');
	btn:SetEventScriptArgString(ui.LBUTTONUP, roomID);

	local btn_popup = btn:GetChild("btn_popup");
	btn_popup:SetEventScript(ui.LBUTTONUP, 'MAKE_POPUP_CHAT');
	btn_popup:SetEventScriptArgString(ui.LBUTTONUP, roomID);

	local btn_invite = btn:GetChild("btn_invite");
	btn_invite:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_INVITE');
	btn_invite:SetEventScriptArgString(ui.LBUTTONUP, roomID);

	local btn_exit = btn:GetChild("btn_exit");
	btn_exit:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_LEAVE');
	btn_exit:SetEventScriptArgString(ui.LBUTTONUP, roomID);



	local groupboxname = "chatgbox_"..roomID
	local groupbox = GET_CHILD(frame, groupboxname);
	if groupbox == nil then

		local gboxleftmargin = frame:GetUserConfig("GBOX_LEFT_MARGIN")
		local gboxrightmargin = frame:GetUserConfig("GBOX_RIGHT_MARGIN")
		local gboxtopmargin = frame:GetUserConfig("GBOX_TOP_MARGIN")
		local gboxbottommargin = frame:GetUserConfig("GBOX_BOTTOM_MARGIN")
		
		groupbox = frame:CreateControl("groupbox", groupboxname, frame:GetWidth() - (gboxleftmargin + gboxrightmargin), frame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);

		_ADD_GBOX_OPTION_FOR_CHATFRAME(groupbox)
		groupbox:SetUserValue("CHAT_ID", roomID);
		groupbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
	end

	--�׷� ��ü noticecountǥ��
	local whisper_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper") 
	SET_COUNT_NOTICE(whisper_btn, session.chat.GetAllGroupChatNotReadMsgCount() );
	local whisper_pic_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper_pic") 
	SET_COUNT_NOTICE(whisper_pic_btn, session.chat.GetAllGroupChatNotReadMsgCount() );

	local eachheight = ui.GetControlSetAttribute("chatlist", 'height');
	local queueparent = GET_CHILD_RECURSIVELY(frame, 'queueparent')
	queueparent:Resize( queueparent:GetWidth(), queue:GetChildCount() * eachheight)

	return groupbox;
end

function CHAT_WHISPER_INVITE(ctrl, ctrlset, roomID, artNum)
	ctrl:SetUserValue("ROOM_ID",roomID)
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER2", "",nil,roomID,20);
end

function EXED_GROUPCHAT_ADD_MEMBER2(text,frame)
	
	local roomID = frame:GetUserValue("ArgString");
	ui.GroupChatInviteSomeone(roomID, text)
end

function CHAT_WHISPER_LEAVE(ctrl, ctrlset, argStr, artNum)
	ui.LeaveGroupChat(argStr);
end




function CHAT_GROUP_CREATE(roomID, autoFocusToRoom)
	
	local frame = ui.GetFrame('chatframe');
	if frame == nil then
		return;
	end

	local groupbox = CHAT_CREATE_GROUP_LIST(frame, roomID);

	ui.OnGroupChatCreated(roomID);

	if autoFocusToRoom == 1 then
		ui.SetChatGroupBox(CT_WHISPER,roomID);
	end

	local popupframe = ui.GetFrame("chatpopup_"..roomID);
	if (popupframe ~= nil and popupframe:IsVisible() == 1) or groupbox:IsVisible() == 1 then -- �̹� �޽����� ǥ�� ���̸� �ٷ� ������Ʈ
		chat.UpdateReadFlag(roomID);
		chat.CheckNewMessage(roomID);
	end
	
end

function GET_CHAT_FONT_SIZE()

	local fontSize = config.GetConfigInt("CHAT_FONTSIZE", 100) - 100;
	if fontSize < 0 then
		fontSize = fontSize * 0.8;
	else
		fontSize = fontSize * 4;
	end

	local size = math.floor(16 * (1 + fontSize / 100));

	if size < 10 then
		size = 10
	end

	if size > 50 then
		size = 50
	end

	return size 
			
end

function CHAT_SYSTEM(msg)
	session.ui.GetChatMsg():AddSystemMsg(msg, true); 
end



function CHAT_SET_TO_TITLENAME(chatType, targetName, count)
	local frame = ui.GetFrame('chat');
	local chatEditCtrl = frame:GetChild('mainchat');
	local titleCtrl = GET_CHILD(frame,'edit_to_bg');
	local editbg = GET_CHILD(frame,'edit_bg');

	local titleText = ''
	
	if chatType == 'generalchat' then
		titleText = ScpArgMsg('NormalChat');
	elseif chatType == 'partychat' then
		titleText = ScpArgMsg('PartyChat');
	elseif chatType == 'guildchat' then
		titleText = ScpArgMsg('guild');
	elseif chatType == 'shoutchat' then
		titleText = ScpArgMsg('Auto_oeChiKi');
	elseif chatType == 'whisperchat' or chatType == 'whisperFromchat' or chatType == 'whisperTochat' then
		titleText = ScpArgMsg('WhisperChat','Who',targetName);
	elseif chatType == 'groupchat' then
		if count > 1 then
			titleText = ScpArgMsg('GroupChat','Who',targetName,'Count',count-1);
		else
			titleText = ScpArgMsg('WhisperChat','Who',targetName);
		end
	end

	local name  = GET_CHILD(titleCtrl,'title_to');

	name:SetText(titleText);
	
	titleCtrl:Resize(name:GetWidth() + 20,titleCtrl:GetOriginalHeight())
	chatEditCtrl:Resize(chatEditCtrl:GetOriginalWidth() - titleCtrl:GetWidth(), chatEditCtrl:GetOriginalHeight())
	chatEditCtrl:SetOffset(chatEditCtrl:GetOriginalX() + titleCtrl:GetWidth(), chatEditCtrl:GetOriginalY())

end



function CHAT_OPEN_OPTION(frame)
	ui.ToggleFrame("chat_option");
end

function CHAT_OPEN_EMOTICON(frame)
	ui.ToggleFrame("chat_emoticon");
end










































