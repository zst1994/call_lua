require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

function write_data(inifile,key)
	F=io.open(userPath().."/res/"..inifile,"a")
	F:write(key,'\n')
	F:close()
end

function getData() --获取62数据 (可以用的)
	local getList = function(path) 
		local a = io.popen("ls "..path) 
		local f = {}; 
		for l in a:lines() do 
			table.insert(f,l) 
		end 
		return f 
	end 
	local Wildcard = getList("/var/mobile/Containers/Data/Application") 
	for var = 1,#Wildcard do 
		local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/wx.dat","rb") 
		if file then 
			local str = file:read("*a") 
			file:close() 
			require"sz" 
			local str = string.tohex(str) --16进制编码 
			return str 
		end 
	end 
end 

six_data = getData()
mSleep(500)
toast(six_data);
mSleep(500)
file_path = "62数据手机号.txt"

write_data(file_path,six_data)