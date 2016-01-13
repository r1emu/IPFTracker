
function RANK_OPEN_ATTACKTOP(ctrl, ctrlset, argStr, argNum)

	local frame = ui.GetFrame('rank')
	rank = GET_CHILD(frame, 'group_attackTop', 'ui::CObject')
	rank:ShowWindow(1)

	RANK_SHOW_BACK_BUTTON(frame)

	imcSound.PlaySoundEvent('button_click_3');
	imc.client.statistics.api.lua.sync_rank_attack('RANK_ATTACKTOP_DRAW', '')
end

function RANK_PAGE_CHANGE_ATTACKTOP(ctrl, ctrlset, argStr, argNum)
	local frame = ui.GetFrame('rank')
	local group = GET_CHILD(frame, 'group_attackTop', 'ui::CGroupBox')
	local page = GET_CHILD(group, 'page', 'ui::CPage')
	if page ~= nil then
		local control = GET_CHILD(group, 'control', 'ui::CPageController')
		local index = control:GetCurPage();
		page:SetCurPage(index);
		imcSound.PlaySoundEvent('button_click');
	end
end

function RANK_ATTACKTOP_DRAW(str)


	local frame = ui.GetFrame('rank')
	local group = GET_CHILD(frame, 'group_attackTop', 'ui::CGroupBox')
	local page = GET_CHILD(group, 'page', 'ui::CPage')

	local ranklist = imc.client.statistics.api.lua.get_ranklist('skill_attack_monster_total')
	local myrank = imc.client.statistics.api.lua.get_my_rank('skill_attack_monster_total')
	local count = imc.client.statistics.api.lua.get_data('skill', 'attack', 'monster', 'total')




	tolua.cast(page, 'ui::CPage')
	local element

	local element = group:CreateOrGetControlSet('RankScoreAvg', 'rankAvg', ui.LEFT, ui.TOP, 0, 90, 0, 0);
	local icon = GET_CHILD(element, 'icon', 'ui::CPicture')
	icon:SetImage('icon_item_Misc_00019')

	local name = GET_CHILD(element, 'name', 'ui::CRichText')
	name:SetText(ScpArgMsg('Auto_{@st41}{#f0dcaa}PyeongKyun_DeMiJi'))

	local score = GET_CHILD(element, 'score', 'ui::CRichText')
	score:SetText('{@st41}{#f0dcaa}'..imc.client.statistics.api.lua.get_attack_top_avg())

	element = group:CreateOrGetControlSet('myRankElement', 'myrank', ui.LEFT, ui.TOP, 0, 160, 0, 0);
	if myrank ~= nil then


		-- �� ��ũ �����ֱ�.
		local name = GET_CHILD(element, 'name', 'ui::CRichText')
		name:SetText(ScpArgMsg('Auto_{@st41b}Nae_Sunwi'))

		local score = GET_CHILD(element, 'score', 'ui::CRichText')
		score:SetText('{@st41b}'..count)

		local rank = GET_CHILD(element, 'rank', 'ui::CRichText')
		rank:SetText('{@st41b}'..myrank.score..ScpArgMsg('Auto__wi'))

	end
	if ranklist ~= nil then

		local size = ranklist:size();
		local beforeScore = 0;
		local beforeRank = 1;

		for i = 0, size - 1 do
			local data = ranklist:at(i)

			element = page:CreateOrGetControlSet('rankElement', i, ui.NONE_HORZ, ui.TOP, 0, 0, 0, 0);
			tolua.cast(element, 'ui::CControlSet')
			local icon = GET_CHILD(element, 'icon', 'ui::CPicture')
			local rank = GET_CHILD(element, 'rank', 'ui::CRichText')
			local name = GET_CHILD(element, 'name', 'ui::CRichText')
			local desc = GET_CHILD(element, 'desc', 'ui::CRichText')
			local score = GET_CHILD(element, 'score', 'ui::CRichText')



			-- �� ��ũ ������ ������ ��ŷ�� ����ǥ��.
			if beforeScore ~= data.score then
				beforeRank = i + 1
			end


			if beforeRank == 1 then
				-- �ݸ޴� �̹���
				icon:SetImage('icon_item_annycoin_3')
				icon:SetEnableStretch(1)
			elseif beforeRank == 2 then
				-- ���޴� �̹���
				icon:SetImage('icon_item_annycoin_2')
				icon:SetEnableStretch(1)
			elseif beforeRank == 3 then
				-- ���޴� �̹���
				icon:SetImage('icon_item_annycoin_1')
				icon:SetEnableStretch(1)
			else
				-- ¼�� �̹���
				icon:SetImage('icon_item_Misc_00019')
				icon:SetEnableStretch(1)
			end

			rank:SetText('{@st43}'..beforeRank)
			name:SetText('{@st41b}'..data.name)
			score:SetText('{@st41b}{#f0dcaa}'..data.score)
			desc:SetText('')

			--data.desc �� ��ų id�̴�. �ϴ� ���������� �Ⱥ�����.
			--desc:SetText('{@st18}Skill : '..data.desc)

			beforeScore = data.score;

		end
	end
	page:Invalidate();
	page:UpdateData();
	local control = GET_CHILD(group, 'control', 'ui::CPageController')
	control:SetMaxPage(page:GetEndPage() + 1)

end
