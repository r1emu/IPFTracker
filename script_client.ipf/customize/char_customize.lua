function CUSTOMIZE(UserData)



end



function CUSTOMIZE_BODY_TYPE1(UserData, ClassID, Min, Max, Value, Gender)

	--[[
	local Rootclasslist				= imcIES.GetClassList('CreatePcInfo');
	local Selectclass					= Rootclasslist:GetClass(ClassID);
	local HasSubClassList			= Selectclass:HasSubClassList();
	
	if HasSubClassList ~=nil then
		
		local Selectclasslist		= Selectclass:GetSubClassList();
		local Changecount		= Selectclasslist:Count();

		for i = 1, Changecount do
		
			local Changeclass						= Selectclasslist:GetByIndex(i - 1);	
			local NodeName						= imcIES.GetString(Changeclass, 'BaseNode');
			local EndNode							= imcIES.GetString(Changeclass, 'EndNode');
			local EndLevel							= imcIES.GetINT(Changeclass, 'EndChildLevel');
			local ChildModifyCheck				= imcIES.GetString(Changeclass, 'ChildModify');
			local SelectChangeClassList		= Changeclass:GetSubClassList();	
			local ChildModify;
			
			if ChildModifyCheck == 'FALSE' then
				ChildModify			= 1;
			else
				ChildModify			= 0;
			end
		
			local SelectChangeClass;
			local EditGender		= imcIES.GetString(Changeclass, 'EditGender');	
		
			if EditGender == 'All' then
				SelectChangeClass	= SelectChangeClassList:GetClass(1)
			else
				if Gender == 1 then
					SelectChangeClass	= SelectChangeClassList:GetClass(2)
				elseif Gender == 2 then
					SelectChangeClass	= SelectChangeClassList:GetClass(3)
				else
					--print(ScpArgMsg("Auto_oLyu_Kapeul_Chajeul_Su_eopeum"));
				end 	
			end
		
			local Multiplier			= imcIES.GetFloat(SelectChangeClass, 'Multiplier');
			local MinLimit			= imcIES.GetFloat(SelectChangeClass, 'MinLimit');
			local MaxLimit			= imcIES.GetFloat(SelectChangeClass, 'MaxLimit');
			
			local QueryScale		= {}
			QueryScale[1]			= imcIES.GetString(SelectChangeClass, 'QueryX');
			QueryScale[2]			= imcIES.GetString(SelectChangeClass, 'QueryY');
			QueryScale[3]			= imcIES.GetString(SelectChangeClass, 'QueryZ');
			
			local PreScaleData		= customize.GetNodeScale(UserData, NodeName);
			local PreScale			= {}
			PreScale[1]				= PreScaleData.x;
			PreScale[2]				= PreScaleData.y;
			PreScale[3]				= PreScaleData.z;

			if Value * Multiplier < MinLimit then
				Value = MinLimit
			end
			
			if Value * Multiplier > MaxLimit then
				Value = MaxLimit
			end
			
			local Scale				= {}
			for i = 1, 3 do 
				if QueryScale[i] == 'TRUE' then
					Scale[i]		= (100 + ((Value - 100 )) * Multiplier ) * 0.01;
				else
					Scale[i]		= PreScale[i];
				end
			end
			
			customize.SetNodeScale(UserData, NodeName, Scale[1], Scale[2], Scale[3], ChildModify);
		end
		customize.NodeScaleEnd(UserData);
	end
	]]--
end


function CREATE_CHAR_COLOR1(userData, ClassID, Value)
	--[[
	if Value ~= nil then
		-- --print ( ScpArgMsg('Auto_KiBon_DeiTeo_ClassID_:_') .. ClassID ..  ' / Value : ' .. Value);

		-- �����͸� ������ ���� ���� �⺻ ����� ������
		local CreatePcInfo				= imcIES.GetClassList('CreatePcInfo');
		local CreateClassID			= CreatePcInfo:GetClass(ClassID);							-- �ش� ClassID�� Line �����͸� �о� �´�
		local CreateSetColorIndex	= imcIES.GetINT(CreateClassID, 'ColorClassID');		-- Line �����ͷκ��� ColorClassID �÷��� �����͸� �о�´�
		local CreatePartType			= imcIES.GetINT(CreateClassID, 'parttype');			-- Line �����ͷκ��� parttype �÷��� �����͸� �о�´�
		
		
		-- --print ( ScpArgMsg('Auto_ColorSeteuLoBuTeo_DeiTeo_Jeogyong______ClassID_:_') .. CreateSetColorIndex .. ScpArgMsg('Auto__/_Jeogyong_Buwi_:_') .. CreatePartType )
		
		-- ColorSet���κ��� ���������� �����͸� ������ ���� ���� ������
		local ColorIES				= imcIES.GetClassList('ColorVariation');				-- SettingCharacter IES�� ������ �´�
		local ColorIESLine			= ColorIES:GetClass(CreateSetColorIndex);			-- ȣ��� ClassID�� ���� ������ �´�
		
		local test						= imcIES.GetString(ColorIESLine, 'ClassName');
		
		-- --print ( ScpArgMsg('Auto__KeolLeo_Sesui_ClassName_:_') ..  test );
		
		local ColorSubData		= ColorIESLine:GetSubClassList();				-- ���� Data1�� �����͸� ������ �´�
		local ColorLineData		= ColorSubData:GetClass(Value);
		
		-- �÷��� �⺻ ���� ������ �´�
		local Red				= imcIES.GetINT(ColorLineData, 'ColorR');
		local Green			= imcIES.GetINT(ColorLineData, 'ColorG');
		local Blue				= imcIES.GetINT(ColorLineData, 'ColorB');
		local Density		= imcIES.GetINT(ColorLineData, 'Density');
		
		--print(ScpArgMsg('Auto_RedKeolLeoui_Kap_:_') .. Red .. ScpArgMsg('Auto__/_Greenui_Kap_:_') .. Green .. ScpArgMsg('Auto__/_Blueui_Kap') .. Blue);
		
		
		-- �÷��� ���� �Ѵ�
		customize.SetColor( userData, CreatePartType, Red / 255, Green / 255, Blue / 255, Density / 100 )
	end
	]]--
end

function CREATE_CHAR_COLOR2(userData, ClassID, Value)
	
	
end

function CREATE_CHAR_COLOR3(userData, ClassID, Value)
	
	
end


function CREATE_CHAR_HAIR_COLOR_CHANNEL(userData, ClassID, Value)
	--[[
	--print( ScpArgMsg('Auto_KeolLeoLeul_ByeonKyeong_Ham._inJa_Kap_ClassID_:') .. ClassID .. ' / Value : ' .. Value )
	if Value ~= nil then
		-- �����͸� ������ ���� ���� �⺻ ����� ������
		local CreatePcInfo					= imcIES.GetClassList('CreatePcInfo');
		local CreateClassID				= CreatePcInfo:GetClass(ClassID);							-- �ش� ClassID�� Line �����͸� �о� �´�

		local CreatePartType				= imcIES.GetINT(CreateClassID, 'parttype');			-- Line �����ͷκ��� parttype �÷��� �����͸� �о�´�
		local Sub1_Parttype				= imcIES.GetINT(CreateClassID, 'Sub1parttype');			-- Line �����ͷκ��� Sub1parttype �÷��� �����͸� �о�´�
		local Sub2_Parttype				= imcIES.GetINT(CreateClassID, 'Sub2parttype');			-- Line �����ͷκ��� Sub1parttype �÷��� �����͸� �о�´�

		local ColorChannel				= imcIES.GetString(CreateClassID, 'ClassName');			-- Line �����ͷκ��� parttype �÷��� �����͸� �о�´�
		
		if ColorChannel == 'ChannelRed' then
			customize.SetColorR( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'ChannelGreen' then
			customize.SetColorG( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'ChannelBlue' then
			customize.SetColorB( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'ChannelDensity' then
			customize.SetColorA( userData, CreatePartType, Value / 100 );
		else
			--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
		end
		
		if Sub1_Parttype ~= 255 then
			--print(ScpArgMsg("Auto_Kapeul_Chajasseum"))
			if ColorChannel == 'ChannelRed' then
				customize.SetColorR( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelGreen' then
				customize.SetColorG( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelBlue' then
				customize.SetColorB( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelDensity' then
				customize.SetColorA( userData, Sub1_Parttype, Value / 100 );
			else
				--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
			end
		end
		
		if Sub2_Parttype ~= 255 then
			if ColorChannel == 'ChannelRed' then
				customize.SetColorR( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelGreen' then
				customize.SetColorG( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelBlue' then
				customize.SetColorB( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'ChannelDensity' then
				customize.SetColorA( userData, Sub2_Parttype, Value / 100 );
			else
				--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
			end
		end
	end
	]]--
end



function CREATE_CHAR_BODY_COLOR_CHANNEL(userData, ClassID, Value)
	--print( ScpArgMsg('Auto_KeolLeoLeul_ByeonKyeong_Ham._inJa_Kap_ClassID_:') .. ClassID .. ' / Value : ' .. Value )
	--[[
	if Value ~= nil then
		-- �����͸� ������ ���� ���� �⺻ ����� ������
		local CreatePcInfo					= imcIES.GetClassList('CreatePcInfo');
		local CreateClassID				= CreatePcInfo:GetClass(ClassID);							-- �ش� ClassID�� Line �����͸� �о� �´�

		local CreatePartType				= imcIES.GetINT(CreateClassID, 'parttype');			-- Line �����ͷκ��� parttype �÷��� �����͸� �о�´�
		local Sub1_Parttype				= imcIES.GetINT(CreateClassID, 'Sub1parttype');			-- Line �����ͷκ��� Sub1parttype �÷��� �����͸� �о�´�
		local Sub2_Parttype				= imcIES.GetINT(CreateClassID, 'Sub2parttype');			-- Line �����ͷκ��� Sub1parttype �÷��� �����͸� �о�´�

		local ColorChannel				= imcIES.GetString(CreateClassID, 'ClassName');			-- Line �����ͷκ��� parttype �÷��� �����͸� �о�´�
		
		if ColorChannel == 'BodyChannelRed' then
			customize.SetColorR( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'BodyChannelGreen' then
			customize.SetColorG( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'BodyChannelBlue' then
			customize.SetColorB( userData, CreatePartType, Value / 255 );
		elseif ColorChannel == 'BodyChannelDensity' then
			customize.SetColorA( userData, CreatePartType, Value / 100 );
		else
			--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
		end
		
		if Sub1_Parttype ~= 255 then
			--print(ScpArgMsg("Auto_BoDi_Kapeul_Chajasseum"))
			if ColorChannel == 'BodyChannelRed' then
				customize.SetColorR( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelGreen' then
				customize.SetColorG( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelBlue' then
				customize.SetColorB( userData, Sub1_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelDensity' then
				customize.SetColorA( userData, Sub1_Parttype, Value / 100 );
			else
				--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
			end
		end
		
		if Sub2_Parttype ~= 255 then
			if ColorChannel == 'BodyChannelRed' then
				customize.SetColorR( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelGreen' then
				customize.SetColorG( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelBlue' then
				customize.SetColorB( userData, Sub2_Parttype, Value / 255 );
			elseif ColorChannel == 'BodyChannelDensity' then
				customize.SetColorA( userData, Sub2_Parttype, Value / 100 );
			else
				--print(ScpArgMsg("Auto_Jeogyong_DoeNeun_KeulLaeSeuKa_eopeum"));
			end
		end
	end
	]]--
end



