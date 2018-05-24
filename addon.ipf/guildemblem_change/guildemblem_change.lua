local emblemFolderPath = nil
local selectPngName = nil

function GUILDEMBLEM_CHANGE_ON_INIT(addon, frame)

end

function GUILDEMBLEM_CHANGE_INIT(frame)
   IMC_LOG("INFO_NORMAL", "GUILDEMBLEM_CHANGE_INIT ST");
    local frame = ui.GetFrame('guildemblem_change')
    IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_INIT", " frame:", frame );
     
    if frame ~= nil then
    
        selectPngName = nil
        emblemFolderPath = filefind.GetBinPath("UploadEmblem"):c_str()
        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_INIT 1 : ", emblemFolderPath);

        GUILDEMBLEM_CHANGE_UPDATE_TITLE(frame)
        IMC_LOG("INFO_NORMAL", "GUILDEMBLEM_CHANGE_INIT 2");

        GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST(frame) -- 컨테이너에 로드
        IMC_LOG("INFO_NORMAL", "GUILDEMBLEM_CHANGE_INIT 3");

        frame:ShowWindow(1)
    end
    IMC_LOG("INFO_NORMAL", "GUILDEMBLEM_CHANGE_INIT");

end

function GUILDEMBLEM_CHANGE_UPDATE_TITLE(frame)
   if frame ~= nil then
        local gb_top = GET_CHILD_RECURSIVELY(frame, 'gb_top'); 
        local tilte_text = GET_CHILD_RECURSIVELY(gb_top, 'title_text'); 
        local isRegisteredEmblem = session.party.IsRegisteredEmblem();
        if isRegisteredEmblem == true then
            tilte_text:SetTextByKey('register', ClMsg("GuildEmblemChange"));
        else
            tilte_text:SetTextByKey('register', ClMsg("GuildEmblemRegister"));
        end
    end	 
end

function GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST(frame)

IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST ST");
    -- body gbox
	local body = GET_CHILD_RECURSIVELY(frame, "gb_body", "ui::CGroupBox")
	if body == nil then
		return
	end    
IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 1");
    -- 그룹박스내의 DECK_로 시작하는 항목들을 제거
	DESTROY_CHILD_BYNAME(body, 'DECK_')

IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 2");
	local fileList = filefind.FindDirWithConstraint(emblemFolderPath, '[a-zA-Z0-9]+','png')
	IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 3");
    local cnt = fileList:Count()
    IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 4");
    

    -- 정렬
    local sortList = {};
    local sortListIndex = 1;
    IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 5");
    for index = cnt -1 , 0, -1 do
        sortList[sortListIndex] = { fullPathName = emblemFolderPath .. '//' .. fileList:Element(index):c_str(), 
                                    fileName = fileList:Element(index):c_str()};
		sortListIndex = sortListIndex +1;
    end
        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 6");
    table.sort(sortList, SORT_BY_NAME);
        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 7");
    -- 정렬된 리스트 중 비정상 파일 필터하고 10개 출력
    local posY = 0
    local count = 0
    for index , v in pairs(sortList) do
        -- 정상 이미지만 넣는다.
        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] ST");
        if session.party.IsValidGuildEmblemImage(v.fullPathName) == true then
            IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] 1");
            local ctrlSet = body:CreateOrGetControlSet('guild_emblem_deck', "DECK_" .. index, 0, posY)
            IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] 2");
            ctrlSet:ShowWindow(1)
                        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] 3");
            posY = SET_PRIVIEW_ITEM(frame, ctrlSet, v.fileName, posY)
                        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] 4");
            posY = posY -tonumber(frame:GetUserConfig("DECK_SPACE")) -- 가까이 붙이기 위해 좀더 위쪽으로땡김
                        IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST 8[", index, "] 5");
            count = count + 1
            if count >= 10 then
                break
            end
        end
    end    
            IMCLOG_CONTENT("AAAA", "GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST ED");
end

function SORT_BY_NAME(a,b)
	local aName = a.fileName;
	local bName = b.fileName;
	return aName < bName;
end

function GUILDEMBLEM_CHANGE_SELECT(parent, ctrl)
    local frame = parent:GetTopParentFrame()
	if frame == nil then
	 return 
	end

    local gb_items = GET_CHILD(parent,"gb_items", "ui::CGroupBox")
	if gb_items == nil then
		return 
	end
	
	local fileName = gb_items:GetUserValue("FILE_NAME")
    selectPngName = nil
    if fileName ~= nil then
        selectPngName = fileName
    end

    if emblemFolderPath ~= nil and selectPngName ~= nil then
        local fullPath = emblemFolderPath .. "\\" .. selectPngName
        GUILDEMBLEM_CHANGE_PREVIEW(frame, fullPath)
    end
end

function GUILDEMBLEM_CHANGE_PREVIEW(frame, emblemName)
    GUILDEMBLEM_LIST_UPDATE(frame)
    DRAW_GUILD_EMBLEM(frame, true, false, emblemName)
end

function GUILDEMBLEM_CHANGE_EXCUTE(isNewRegist, useItem)
    
    if isNewRegist == true then
    -- 최초 등록
        local fullPath = emblemFolderPath .. "\\" .. selectPngName        
        local result = session.party.RegisterGuildEmblem(fullPath,false)
        if result == EMBLEM_RESULT_ABNORMAL_IMAGE then
            ui.SysMsg(ClMsg("AbnormalImageData"))    
            ui.CloseFrame('guildemblem_change')
        end
    else
    -- 변경
        if emblemFolderPath ~= nil and selectPngName ~= nil then
            -- 아이템 사용이 아닐 때는 조건 검사.
            if useItem == false then
                -- 길드 자산 확인
                local guildObj = GET_MY_GUILD_OBJECT()
                local guildAsset = guildObj.GuildAsset  
                if guildAsset == nil or guildAsset == 'None' then
                    guildAsset = 0
                end

                if tonumber(GUILD_EMBLEM_COST_AMOUNT) > tonumber(guildAsset) then
                    ui.SysMsg(ClMsg("NotEnoughGuildAsset"))
                    ui.CloseFrame('guildemblem_change')
                    GUILDEMBLEM_CHANGE_CANCEL(frame)
                    return
                end
            end
            
             -- 길드이미지 변경 가능 시간 확인
            if session.party.IsPossibleRegistGuildEmblem(useItem) == false and session.party.IsRegisteredEmblem() == true then
                ui.SysMsg(ClMsg("NotReachToReRegisterTime"))
                ui.CloseFrame('guildemblem_change')
                GUILDEMBLEM_CHANGE_CANCEL(frame)
                return
            end

            -- 등록 요청
            local fullPath = emblemFolderPath .. "\\" .. selectPngName     
            local result = session.party.RegisterGuildEmblem(fullPath,useItem)
            if result == EMBLEM_RESULT_ABNORMAL_IMAGE then
                ui.SysMsg(ClMsg("AbnormalImageData"))    
                ui.CloseFrame('guildemblem_change')
            end
        end
    end
    GUILDEMBLEM_CHANGE_CANCEL(frame)
end

function GUILDEMBLEM_CHANGE_ACCEPT(frame)
    if selectPngName == nil then
        ui.SysMsg(ClMsg("NoImagesAvailable"))
        GUILDEMBLEM_CHANGE_CANCEL(frame)
        return
    end

    -- 길드 엠블럼을 변경하는 경우(이미 등록이 되어있었다면) 인벤에 길드 엠블럼 변경권을 확인한다.
    if session.party.IsRegisteredEmblem() == true then
    -- 인벤에 변경권이 있으면 물어본다.
        local invItem = session.GetInvItemByName("Premium_Change_Guild_Emblem");
        if invItem ~= nil then 
            local yesScp = string.format("GUILDEMBLEM_CHANGE_EXCUTE(false,true)");
            local noScp = string.format("GUILDEMBLEM_CHANGE_EXCUTE(false,false)");
            ui.MsgBox(ScpArgMsg("UseGuildEmblemChangeItem"), yesScp, noScp);
            return
        end
    end
    -- 최초 길드 엠블럼 등록.
    GUILDEMBLEM_CHANGE_EXCUTE(true,false)
end

function GUILDEMBLEM_CHANGE_CANCEL(frame)
    local guildinfo = ui.GetFrame('guildinfo');
    GUILDINFO_PROFILE_INIT_EMBLEM(guildinfo);
    ui.CloseFrame('guildemblem_change')
end

function GUILDEMBLEM_CHANGE_OPEN_SAVE_FOLDER(frame)
    OpenUploadEmblemFolder(emblemFolderPath)
end

function GUILDEMBLEM_CHANGE_RELOAD(frame)
    GUILDEMBLEM_CHANGE_INIT(frame)
end


function GUILDEMBLEM_LIST_UPDATE(frame)
    
    if frame == nil then
	 return 
	end

    local gb_body = GET_CHILD(frame, "gb_body", "ui::CGroupBox")
    if gb_body == nil then
	 return 
	end

    -- 업데이트 목록 작성
    local update_list_cnt = 0
    local update_list = {}
    local cnt = gb_body:GetChildCount()
    for i = 0 , cnt - 1 do
        local ctrlSet = gb_body:GetChildByIndex(i)
        local name = ctrlSet:GetName()
        if string.find(name, "DECK_") ~= nil then
           update_list[update_list_cnt] = ctrlSet
           update_list_cnt = update_list_cnt +1
        end 
    end

    -- 갱신
    for index , v in pairs(update_list) do
        local gb_items = GET_CHILD(v, "gb_items", "ui::CGroupBox")
        if gb_items ~= nil then
            local name =  gb_items:GetUserValue("FILE_NAME")
            if(selectPngName == name ) then
                gb_items:SetSkinName(frame:GetUserConfig("SELECT_IMAGE_NAME"))
            else
                gb_items:SetSkinName(frame:GetUserConfig("NOT_SELECT_IMAGE_NAME"))
            end
        end
	end
    
end

function SET_PRIVIEW_ITEM(frame, ctrlSet, fileName, posY)
 local test = nil;
  IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM ST : ",test);
    local pngFullPath =  emblemFolderPath .. "\\" .. fileName
  IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 1 :", pngFullPath );
    -- 아이콘을 설정한다
	local gb_items = GET_CHILD(ctrlSet, "gb_items", "ui::CGroupBox") 
	IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 2 :", gb_items );
    local rich_fileName = GET_CHILD(gb_items, "file_name", "ui::CRichText")
    IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 3 :", rich_fileName );
	local pic_icon = GET_CHILD(gb_items, "preview_icon", "ui::CPicture")
	IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 4 :", pic_icon );

    -- 선택 이벤트에 사용할 파일 이름 설정
    gb_items:SetUserValue("FILE_NAME",fileName)
    IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 5 :", fileName );
    
    -- 이미지 로드 
    pic_icon:SetImage("") -- clear clone image
    IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 6");
    pic_icon:SetFileName(pngFullPath)
    IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM 7:",pngFullPath );
    -- 텍스트 설정
    rich_fileName:SetTextByKey("value", fileName)
    IMCLOG_CONTENT("AAAA", "SET_PRIVIEW_ITEM ED:",fileName );
	
    return posY + ctrlSet:GetHeight()
end