require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

----sec_uid=MS4wLjABAAAAiRqZ36GT_Wu0U1aO0UFU93w3j1BXYhSi22bQcJHMXNY
--function userInfo(uid)
--	::get_user::
--	code,header_resp,body_resp = ts.httpsGet("https://www.iesdouyin.com/web/api/v2/user/info/?sec_uid="..uid, header_send, body_send)
--	if code == 200 then
--		return body_resp
--	else
--		goto get_user
--	end
--end

--data = userInfo(uid)
--local tmp = json.decode(data)
--dialog(tmp["user_info"]["total_favorited"],0)
--dialog(tmp["user_info"]["following_count"],0)
--dialog(tmp["user_info"]["follower_count"],0)



function getData()  ----获取火山uid
	dataPath = appDataPath("com.ss.iphone.ugc.Aweme"); 
	local getList = function(path)
		local a = io.popen("ls "..path)
		local f = {};
		for l in a:lines() do
			table.insert(f,l)
		end
		return f
	end 

	local file = io.open(dataPath.."/Library/Preferences/com.ss.iphone.ugc.Aweme.plist","rb")
	if file then 
		local ts = require("ts")
		local plist = ts.plist
		local plfilename = dataPath.."/Library/Preferences/com.ss.iphone.ugc.Aweme.plist" --设置plist路径
		local tmp2 = plist.read(plfilename)                --读取 PLIST 文件内容并返回一个 TABLE
		for k, v in pairs(tmp2) do
			if k == "kDYAAllLoginUserPersistenceKey" then
				dialog(type(v), time)
				nLog(v)
				break
			end
			
--			if type(v) == "table" then
--				for k1, v1 in pairs(v) do
--					if type(v1) == "table" then
--						for k2, v2 in pairs(v1) do
--							if type(v2) == "table" then
--								for k3, v3 in pairs(v2) do
--									if type(v3) == "table" then
--										value2 = "table????"..table.concat(v3)
--									else
--										value2 = v3
--									end
--									nLog(k3.."===="..value2)
--									mSleep(500)
--									if string.match(k3,"Key(%d+)") then
--										k33=string.match(k3,"%d+")

--										toast(k33,1)
--										dialog(k33, time)
--										return k33
--									end
--								end
--							else
--								value1 = v2
--							end
--							nLog(k1.."===="..value1)
--							mSleep(500)
--							if string.match(k2,"Key(%d+)") then
--								k22=string.match(k2,"%d+")

--								toast(k22,1)
--								dialog(k22, time)
--								return k22
--							end
--						end
--					end
--					nLog(k1.."===="..value)
--					mSleep(500)
--					if string.match(k1,"Key(%d+)") then
--						k11=string.match(k1,"%d+")
--						toast(k11,1)
--						dialog(k11, time)
--						return k11
--					end
--				end
--			else
--				val = v
--			end
			mSleep(500)
			if string.match(k,"Key(%d+)") then
				k=string.match(k,"%d+")

				toast(k,1)
				dialog(k, time)
				return k
			end
		end 
	end 
end

getData()


function writeData(data) --写入数据（62数据）

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

		local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/wx.dat","w+")

		if file then

			file:write(data)

			file:close()

			return true

		end

	end

end


--data = "62706c6973743030d4010203040506090a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a2070855246e756c6c5f102033366664393830343131653765366634306163383633376333643531663731655f100f4e534b657965644172636869766572d10b0c54726f6f74800108111a232d32373a406375787d0000000000000101000000000000000d0000000000000000000000000000007f"

--writeData(data)