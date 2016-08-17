-- minigameover.lua --
function MINIGAME_ON_INIT(addon, frame)
end

-- �̴ϰ��� ���� UI ���� 
function MINIGAME_OVER_FRAME_OPEN(tip1, tip2)
	
	local restart = ui.GetFrame('restart');	
	if restart:IsVisible() == 1 then
		restart:ShowWindow(0);
	end;

	local minigameover = ui.GetFrame('minigameover');	
	local bgPic_name = minigameover:GetChild('bgPic_name');
	bgPic_name:SetColorTone("FFFF0000");	
	local bgPic_box = minigameover:GetChild('bgPic_box');
	
	if (tip1 ~= nil) and string.len(tip1) > 0 then
		bgPic_box:GetChild('tip1'):SetTextByKey("string", tip1);
	end;
	
	if (tip2 ~= nil) and string.len(tip2) > 0 then
		bgPic_box:GetChild('tip2'):SetTextByKey("string", tip2);
	end;

	local getOut_btn = bgPic_box:GetChild('getOut_btn');
	getOut_btn:SetEventScript(ui.LBUTTONUP, "MINIGAME_OVER_FRAME_CLOSE");	

	minigameover:ShowWindow(1);
end

-- �̴ϰ��� ���� UI ���� ��ư�� ���� UI �ݱ�
function MINIGAME_OVER_FRAME_CLOSE()
	local minigameover = ui.GetFrame('minigameover');	

	-- �̴ϰ��� ���п� ���Ͽ� �ٽ� �κ������� �ǵ��ư���. 
	restart.ReqReturn();

	minigameover:ShowWindow(0);	
end
