require "TSLib"
local ts 				= require('ts')

bid = "com.tencent.mm"
dataPath = appDataPath(bid)


function getData() --获取six-two-data (可以用的)

	local file = io.open(dataPath .. "/files/wasae.dat","rb") 
	if file then 
		local str = file:read("*a") 
		file:close() 
		require"sz" 
		local str = string.tohex(str) --16进制编码 
		return str 
	end 

end 


six_data = getData()
dialog(six_data, 0)