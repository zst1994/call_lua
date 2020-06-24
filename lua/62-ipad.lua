require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 				= {}

model.awz_bid 			= "AWZ"
model.wc_bid 			= "com.tencent.xin"

function model:clear_App()
	::run_again::
	closeApp(self.awz_bid)
	mSleep(math.random(200, 500))
	runApp(self.awz_bid)
	mSleep(math.random(500, 1500))

	while true do
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				break
			end
		else
			goto run_again
		end
	end

	::new_phone::
	local sz = require("sz");
	local http = require("szocket.http")
	local res, code = http.request("http://127.0.0.1:1688/cmd?fun=newrecord")
	if code == 200 then
		local resJson = sz.json.decode(res)
		local result = resJson.result
		if result == 3 then
			toast("新机成功，不过ip重复了",1)
			mSleep(1000)
		elseif result == 1 then
			toast("成功",1)
		else 
			toast("失败，请手动查看问题", 1)
			mSleep(4000)
			goto new_phone
		end
	end
end

function run_wechat()
	
end

function model:write_data(inifile,key)
	F=io.open(userPath().."/res/"..inifile,"a")
	F:write(key,'\n')
	F:close()
end

function model:getData() --获取62数据 (可以用的)
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
			local ts = require("ts")
			local plist = ts.plist
			local plfilename = "/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/LocalInfo.lst" --设置plist路径
			local tmp2 = plist.read(plfilename)                --读取 PLIST 文件内容并返回一个 TABLE
			for k, v in pairs(tmp2) do
				if k == "$objects" then
					for i = 11 ,12 do
						if tonumber(v[i]) then
							wx = v[i]
							break
						end	
					end	
				end	
			end	
			local str = file:read("*a") 
			file:close() 
			require"sz" 
			local str = string.tohex(str) --16进制编码 
			return str 
		end 
	end 
end 

function model:main()
	self:clear_App()
--	six_data = getData()
--	mSleep(500)
--	nLog(wx.."----"..six_data)
end

model:main()