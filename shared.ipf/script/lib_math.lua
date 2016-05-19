---- lib_math.lua

-- ���� ���� ���� (Linear Interpolation)
-- ��) 1Lv �϶� 30, 100Lv �϶� 100�� ��ġ�� �������� �ϰ� �ʹ�.
-- set_LI(value, 30, 100, 1, 100) �Ǵ� set_LI(value, 30, 100) (1�� 100�� �⺻������ ������ �־ ���� ����)
function set_LI(value, min, max, s, e)
    
    s = s and s or 1
    e = e and e or 100
    local x = value<s and s or (value>e and e or value)
    
    local ret = min + ((x-s) / (e-s) * (max-min))
    --print(s.."  "..e.."  "..x.."  "..ret)
    
    return ret
    
end

function CLAMP(v, minv, maxv)
	if v < minv then
		return minv;
	end

	if v > maxv then
		return maxv;
	end

	return v;
end

