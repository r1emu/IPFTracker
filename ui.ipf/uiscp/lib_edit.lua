---- lib_edit.lua

function SET_EDIT_LENGTH(edit, minLen, maxLen, enableControl)
	edit = tolua.cast(edit, "ui::CEditControl");
	edit:SetTypingScp("CHECK_EDIT_LENGTH");
	edit:SetMaxLen(maxLen);
	edit:SetUserValue("EDIT_MIN_LEN", minLen);
	edit:SetUserValue("ENABLE_CTRL_NAME", enableControl);
	local parent = edit:GetParent();
	CHECK_EDIT_LENGTH(parent, edit);
end

function CHECK_EDIT_LENGTH(parent, ctrl)
	local curText = ctrl:GetText();
	local minLen = ctrl:GetUserIValue("EDIT_MIN_LEN");
	local curLen = GetUTF8Len(curText);
	local enableControlName = ctrl:GetUserValue("ENABLE_CTRL_NAME");
	local btn = parent:GetChild(enableControlName);
	if btn ~= nil then
		if curLen >= minLen then
			btn:SetEnable(1);
		else
			btn:SetEnable(0);
		end
	end

end
