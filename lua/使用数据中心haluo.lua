require "TSLib"
local ts = require("ts")

function clear(i)
	for var= 1, i do
		inputText("\b")
	end
end

function sogo(haluo_url)
	mSleep(500)
	runApp("com.sogou.SogouExplorerMobile")
	mSleep(1000)
	for var= 1, 50 do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "37|-1|0x007aff,-206|-183|0x000000,-215|-2|0x007aff,-120|11|0xd6dade", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			toast("允许",1)
			mSleep(1000)
		end

		mSleep(500)
		x1,y1 = findMultiColorInRegionFuzzy( 0x3697ff, "-157|0|0x3697ff,142|2|0x3697ff,-15|-38|0x3697ff,-8|34|0x3697ff,-32|-7|0xffffff", 90, 0, 0, 749, 1333)
		if x1~=-1 and y1~=-1 then
			mSleep(500)
			tap(x1,y1)
			mSleep(500)
			toast("进入浏览器",1)
			break
		end

	end
	for var= 1, 50 do
		mSleep(500)
		x0,y0 = findMultiColorInRegionFuzzy( 0x007aff, "37|-1|0x007aff,-206|-183|0x000000,-215|-2|0x007aff,-120|11|0xd6dade", 90, 0, 0, 749, 1333)
		if x0~=-1 and y0~=-1 then
			mSleep(500)
			tap(x0,y0)
			mSleep(500)
			toast("允许",1)
			mSleep(1000)
		end

		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "84|-11|0xb0b0b0,113|7|0xb0b0b0,195|1|0xb0b0b0,240|-1|0xb0b0b0,293|0|0xb0b0b0,604|-1|0xe5e5e5,566|18|0x6a6a6a,641|17|0x6a6a6a,643|-16|0x6a6a6a", 90, 0, 0, 749, 530)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x+150,y)
			mSleep(500)
			for var= 1, 20 do
				mSleep(500)
				if getColor(676, 86) == 0x000000 then
					mSleep(500)
					inputText(haluo_url)
					mSleep(1000)
					keyDown("ReturnOrEnter")
					mSleep(100)
					keyUp("ReturnOrEnter")
					mSleep(500)
					toast("输入网址",1)
					break
				else
					mSleep(500)
					tap(x+150,y)
					mSleep(500)
				end
			end
			break
		end
	end
end

function tencent_qq(haluo_url)
	mSleep(500)
	runApp("com.tencent.mttlite")
	mSleep(1000)
	for var= 1, 50 do
		mSleep(500)
		if getColor(153, 1151) == 0x00b2fb and getColor(423, 1145) == 0x03dd6c then
			mSleep(500)
			tap(655,   69)
			mSleep(500)
			toast("跳过",1)
			mSleep(2000)
			break
		end

	end
	for var= 1, 50 do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x4c9afa, "45|17|0x4c9afa,-135|-259|0x4ca5ff,-136|-134|0x4ca5ff,-124|-383|0x242424,-35|-380|0x242424,204|-368|0x242424,35|33|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			toast("知道了",1)
			mSleep(1000)
		end
		mSleep(500)
		x1,y1 = findMultiColorInRegionFuzzy( 0x007aff, "9|4|0x007aff,31|-1|0x007aff,46|3|0x007aff,-292|-171|0x000000,-267|-172|0x000000,95|-177|0x000000,104|-177|0x000000", 90, 0, 0, 749, 1333)
		if x1~=-1 and y1~=-1 then
			mSleep(500)
			tap(x1,y1)
			mSleep(500)
			toast("允许",1)
			mSleep(1000)
		end
		mSleep(500)
		x2,y2 = findMultiColorInRegionFuzzy( 0x8d8e90, "13|2|0x8d8e90,6|26|0x8d8e90,60|11|0x8d8e90,101|10|0x8d8e90,-587|7|0x136dea,-137|12|0xf9fcfe", 90, 0, 0, 749, 1333)
		if x2~=-1 and y2~=-1 then
			mSleep(500)
			tap(x2+200,y2)
			mSleep(1000)
			inputText(haluo_url)
			mSleep(1000)
			keyDown("Spacebar")
			mSleep(100)
			keyUp("Spacebar")
			mSleep(500)
			inputText("\b")
			mSleep(500)
			keyDown("ReturnOrEnter")
			mSleep(100)
			keyUp("ReturnOrEnter")
			mSleep(500)
			toast("输入网址",1)
			break
		end
	end
end

function get_mess(id)
	::login::
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request("http://api.fxhyd.cn/UserInterface.aspx?action=login&username=gaidian&password=615615615")
	if code == 200 then
		mSleep(500)
		if res == "1002" then
			toast("参数action不能为空",1)
			goto login
		elseif res == "1003" then
			toast("参数action错误",1)
			goto login
		elseif res == "1005" then
			toast("用户名或密码错误",1)
			goto login
		elseif res == "1006" then
			toast("用户名不能为空",1)
			goto login
		elseif res == "1007" then
			toast("密码不能为空",1)
			goto login
		elseif res == "1009" then
			toast("账户被禁用",1)
			goto login
		elseif res == "1013" then
			dialog("你尚未开启API接口",0)
		else
			mSleep(500)
			messages = strSplit(res,"|")
			token = messages[2]
			toast(token,1)
		end

	end

	::name_report::
	local sz = require("sz")        --获取账号状态
	local http = require("szocket.http")
	local res, code = http.request("http://api.fxhyd.cn/UserInterface.aspx?action=getaccountinfo&token="..token)
	if code == 200 then
		mSleep(500)
		if res == "1002" then
			toast("参数action不能为空",1)
			goto name_report
		elseif res == "1003" then
			toast("参数action错误",1)
			goto name_report
		elseif res == "1004" then
			toast("token失效",1)
			lua_restart()
		else
			mSleep(500)
			report = strSplit(res,"|")
			if report[1] == "success" then
				if tonumber(report[5]) < 0.1 then
					dialog("账号余额不足", 0)
				else
					toast("余额："..report[5],1)
				end
			else
				goto name_report
			end

		end
	end

	::get_phone::
	local sz = require("sz")        --获取手机号码
	local http = require("szocket.http")
	local res, code = http.request("http://api.fxhyd.cn/UserInterface.aspx?action=getmobile&token="..token.."&itemid="..id)
	if code == 200 then
		mSleep(500)
		if res == "1002" then
			toast("参数action不能为空",1)
			goto get_phone
		elseif res == "1003" then
			toast("参数action错误",1)
			goto get_phone
		elseif res == "1004" then
			toast("token失效",1)
			lua_restart()
		elseif res == "2001" then
			toast("参数itemid不能为空",1)
			goto get_phone
		elseif res == "2002" then
			toast("项目不存在",1)
			goto get_phone
		elseif res == "2003" then
			toast("项目未启用",1)
			goto get_phone
		elseif res == "2004" then
			toast("暂时没有可用的号码",1)
			goto get_phone
		elseif res == "2005" then
			toast("获取号码数量已达到上限",1)
			goto get_phone
		elseif res == "2007" then
			toast("号码已被释放",1)
			goto get_phone
		elseif res == "2008" then
			toast("号码已离线",1)
			goto get_phone
		else
			mSleep(500)
			phone = strSplit(res,"|")
			return phone
		end
	else
		goto get_phone
	end

end

function get_phone_mess(id,phone)
	::login::
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request("http://api.fxhyd.cn/UserInterface.aspx?action=login&username=gaidian&password=615615615")
	if code == 200 then
		mSleep(500)
		if res == "1002" then
			toast("参数action不能为空",1)
			goto login
		elseif res == "1003" then
			toast("参数action错误",1)
			goto login
		elseif res == "1005" then
			toast("用户名或密码错误",1)
			goto login
		elseif res == "1006" then
			toast("用户名不能为空",1)
			goto login
		elseif res == "1007" then
			toast("密码不能为空",1)
			goto login
		elseif res == "1009" then
			toast("账户被禁用",1)
			goto login
		elseif res == "1013" then
			dialog("你尚未开启API接口",0)
		else
			mSleep(500)
			messages = strSplit(res,"|")
			token = messages[2]
--			toast(token,1)
		end

	end

	vpntime = 1
	::get_mess::
	local sz = require("sz")        --获取手机号码短信
	local http = require("szocket.http")
	local res, code = http.request("http://api.fxhyd.cn/UserInterface.aspx?action=getsms&token="..token.."&itemid="..id.."&mobile="..phone)
	if code == 200 then
		mSleep(500)
		if res == "1002" then
			toast("参数action不能为空",1)
			goto get_mess
		elseif res == "1003" then
			toast("参数action错误",1)
			goto get_mess
		elseif res == "1004" then
			toast("token失效",1)
			lua_restart()
		elseif res == "2001" then
			toast("参数itemid不能为空",1)
			goto get_mess
		elseif res == "2002" then
			toast("项目不存在",1)
			goto get_mess
		elseif res == "2003" then
			toast("项目未启用",1)
			goto get_mess
		elseif res == "2004" then
			toast("暂时没有可用的号码",1)
			goto get_mess
		elseif res == "2005" then
			toast("获取号码数量已达到上限",1)
			goto get_mess
		elseif res == "2007" then
			toast("号码已被释放",1)
			goto get_mess
		elseif res == "2008" then
			toast("号码已离线",1)
			goto get_mess
		elseif res == "3001" then
			toast("尚未收到短信"..vpntime,1)
			mSleep(3000)
			vpntime = vpntime + 1
			if vpntime > 15 then
				return false
			else
				goto get_mess
			end
		else
			toast(res, 1)
			yzm = string.match(res, "%d+")
			return yzm
		end
	end
end

setRotationLockEnable(true)
vpntime = 1
math.randomseed(getRndNum())
driver_type = math.random(1,3)
--car_type = 3
setVPNEnable(false)
mSleep(2000)
old_data = getNetIP() --获取IP  
toast(old_data,1)

haluo_id = 25342
sogou_bid = "com.sogou.SogouExplorerMobile"
qqllq_bid = "com.tencent.mttlite"
safari_bid = "com.apple.mobilesafari"
haluo_url = "https://m.hellobike.com/AppHelloBikeHitchH5/latest/index.html#/pre-certification-activity/440428092667580417/a"

if driver_type == 1 then
	new_app = safari_bid
elseif driver_type == 2 then
	new_app = sogou_bid
elseif driver_type == 3 then
	new_app = qqllq_bid
end
::status::
mSleep(500)
closeApp("cn.tinyapps.RST")
mSleep(2000)
runApp("cn.tinyapps.RST")
mSleep(5000)

--一键新机
local sz = require("sz")
local http = require("szocket.http")
local json = sz.json
local http = sz.i82.http
local code, header, body = http.get("http://127.0.0.1:361/cmd?fun=newDevice&bid="..new_app)
if code == 200 then
	mSleep(500)
	tmp = sz.json.totable(body)   --json转table
else
	mSleep(500)
	lua_restart()
end

if tmp["status"] == -1 then
	mSleep(500)
	goto status
elseif tmp["status"] == 0 then
	mSleep(500)
	goto status
elseif tmp["status"] == 1 then
	toast("一键新机成功",1)
end

::vpn::     --vpn判断
::newvpn::
flag = getVPNStatus()
if flag.active == false then
	mSleep(3000)
	setVPNEnable(true)
	mSleep(15000)
	new_data = getNetIP() --获取IP
	toast(new_data,1)
	mSleep(2000)
	if new_data == old_data then
		mSleep(500)
		openURL("prefs:root=General&path=VPN");  --打开 VPN 界面
		mSleep(3000)
		for vv= 1, 10 do
			mSleep(500)
			if getColor(20, 84) == 0x007aff then
				mSleep(500)
				if vv == 1 then
					mSleep(500)
					tap(381,20)   --返回顶部
				end
				if vpntime > 9 then
					if bool then
						mSleep(2000)
						moveTo(39, 1298, 39, 1178)
						bool = false
					end
					mSleep(3000)
					tap(282, 833+(vpntime-10)*100)
				else
					mSleep(1000)
					tap(282,462+(vpntime-1)*100)
					mSleep(1000)
				end
				break
			else
				mSleep(500)    --vpn连接失败
				x2,y2 = findMultiColorInRegionFuzzy( 0x000000, "8|20|0x000000,16|0|0x000000,25|1|0x000000,24|22|0x000000,38|8|0x000000,46|21|0x000000,47|0|0x000000,62|21|0x000000,63|-1|0x0b0b0b", 90, 0, 0, 749, 1333)
				if x2~=-1 and y2~=-1 then
					mSleep(500)
					x3,y3 = findMultiColorInRegionFuzzy( 0x007aff, "-3|16|0x007aff,7|25|0x007aff,5|7|0x007aff,10|2|0x007aff,23|3|0x007aff,18|14|0x007aff,13|28|0x007aff", 90, 0, 0, 749, 1333)
					if x3~=-1 and y3~=-1 then
						mSleep(500)
						tap(x3,y3)
						toast("全部vpn连接",1)
					end
				end
			end
		end

		vpntime = vpntime +1
		if vpntime > 15 then
			lua_exit()
		else
			mSleep(500)
			setVPNEnable(false)
			mSleep(1000)
			goto vpn
		end

	else
		toast("vpn正常使用", 1)
		mSleep(1000)
	end
end

if driver_type == 1 then
	mSleep(500)
	openURL(haluo_url)
elseif driver_type == 2 then
	mSleep(500)
	sogo(haluo_url)
elseif driver_type == 3 then
	mSleep(500)
	tencent_qq(haluo_url)
end

::restart_getphone::
mSleep(1000)
for var= 1, 50 do
	mSleep(500)
	if getColor(382,  235) == 0xffffff and getColor(257,  906) == 0xffffff then
		mSleep(2000*var)
	elseif getColor(395,  902) ~= 0x9a9a9a and getColor(257,  906) ~= 0x9a9a9a then
		mSleep(500)
		moveTo(374,  485, 370, 643)
		mSleep(1000)
	else
		toast("链接显示正常",1)
		mSleep(1000)
		break
	end

end

for var= 1, 100 do
	mSleep(500)
	if getColor(395,  902) == 0x9a9a9a and getColor(257,  906) == 0x9a9a9a or 
	getColor(395,  917) == 0x9a9a9a and getColor(257,  920) == 0x9a9a9a then
		mSleep(500)
		tap(257,  906)
		mSleep(500)
		get_phone = get_mess(haluo_id)
		inputText(get_phone[2])
		mSleep(1000)
		tap(374,  535)
		mSleep(500)
		toast("立即领取",1)
		mSleep(1000)
		break
	end

end

for var= 1, 50 do
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0x333333, "87|-8|0x333333,106|-1|0x333333,147|3|0x333333,347|-3|0xc1c1c1,-42|221|0xbfbfbf,279|222|0xbfbfbf,83|295|0xfffdff", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(500)
		get_phone_messages = get_phone_mess(haluo_id,get_phone[2])
		if get_phone_messages == false then
			mSleep(500)
			tap(641,  552)
			mSleep(500)
			x1,y1 = findMultiColorInRegionFuzzy( 0xffffff, "567|-5|0xffffff,-21|123|0xfe9322,553|116|0xff8217", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x1,y1)
				mSleep(500)
				clear(15)
				mSleep(500)
				tap(363,  188)
				mSleep(500)
			end
			goto restart_getphone
		else
			mSleep(1000)
			tap(x-78,  y+222)
			mSleep(1000)
			inputText(get_phone_messages)
			mSleep(4000)
			break
		end
	else
		mSleep(500)
		tap(375, 1024)
		mSleep(4000)
	end

end

infor = false
--again_infor = false
write_rstart = false
::infomation::
--读取数据中心留存信息
local ts_enterprise_lib = require("ts_enterprise_lib")
local category = "driver-infomation"
local plugin_ok,api_ok,all_data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
if plugin_ok and api_ok then
	toast(all_data, 1)
	mSleep(1000)
	success_data = all_data
	--	all_data1 = trim(value)
	--	all_data = TryRemoveUtf8BOM(all_data1)
	name = strSplit(success_data,"--")
else
	dialog("no data", 0)
end
--all_data = "粤AN080U--彭福荫--440111194503220019"
--name = strSplit(all_data,"--")

::again::
for var= 1, 50 do
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0xcccccc, "312|23|0xcccccc,600|-28|0xcccccc,537|-434|0xf5f5f5,536|-324|0xf5f5f5,539|-204|0xf5f5f5", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(500)
		tap(x+317,y-389)
		mSleep(1000)
		if write_rstart then
			clear(30)
			mSleep(500)
		end
		inputText(name[2]:atrim())
		mSleep(1500)
		tap(x+317,y-273)
		mSleep(1000)
		if write_rstart then
			clear(25)
			mSleep(500)
		end
		inputText(name[3]:atrim())
		mSleep(1500)
		tap(x+317,y-155)
		mSleep(1000)
		if write_rstart then
			clear(10)
			mSleep(500)
		end
		inputText(name[1]:atrim())
		mSleep(1000)
		break
	end
	mSleep(500)
	x1,y1 = findMultiColorInRegionFuzzy( 0x0b82f1, "294|54|0x0b82f1,599|-6|0x0b82f1,530|-401|0xf5f5f5,528|-289|0xf5f5f5,520|-178|0xf5f5f5", 90, 0, 0, 749, 1333)
	if x1~=-1 and y1~=-1 then
		mSleep(500)
		tap(x1+317,y1-389)
		mSleep(1000)
		if infor then
			clear(30)
			mSleep(500)
		end
		inputText(name[2]:atrim())
		mSleep(1500)
		tap(x1+317,y1-273)
		mSleep(1000)
		if infor then
			clear(25)
			mSleep(500)
		end
		inputText(name[3]:atrim())
		mSleep(1500)
		tap(x1+317,y1-155)
		mSleep(1000)
		if infor then
			clear(10)
			mSleep(500)
		end
		inputText(name[1]:atrim())
		mSleep(1000)
		break
	end

end

for var= 1, 50 do
	mSleep(500)
	if getColor(256,  645) == 0x0b82f1 then
		mSleep(500)
		tap(256,  645)
		mSleep(500)
		toast("提交预认证",1)
		break
	elseif getColor(258,  583) == 0x0b82f1 then
		mSleep(500)
		tap(258,  583)
		mSleep(500)
		toast("提交预认证",1)
		break
	elseif getColor(256,  645) == 0xcccccc then
		mSleep(500)
		tap(256,  645)
		write_rstart = true
		goto again
	end

end

for var= 1, 100 do
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0x08bb5c, "-33|77|0x08bb5c,49|76|0x08bb5c,-304|375|0x0b82f1,1|342|0x0b82f1,312|398|0x0b82f1", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(500)
		toast("你已通过预认证",1)
		mSleep(1000)
		setVPNEnable(false)
		mSleep(1000)
		::success::
		--插入成功信息
		local ts_enterprise_lib = require("ts_enterprise_lib")
		local category = "success-information"
		local insert_ok,insert_ret1,insert_ret2 = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,success_data)
		if insert_ok then
			if insert_ret1 then
				toast("insert_data成功信息成功", 1)
			else
				toast("insert_data成功信息失败:"..insert_ret2, 1)
				goto success
			end
		else
			toast("insert_data成功信息失败:"..insert_ret1, 1)
			goto success
		end

		::restart_insert::
		local ts_enterprise_lib = require("ts_enterprise_lib")
		local category = "all_data"
		local plugin_ok,api_ok,value = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
		if plugin_ok and api_ok then
			toast(value, 1)
			mSleep(1000)
			time = value
			::delete::
			local del_ok,del_ret1,del_ret2= ts_enterprise_lib:plugin_api_call("DataCenter","delete_data",category,time)
			if del_ok then
				if del_ret1 then
					mSleep(500)
					toast("删除成功", 1)
					mSleep(1000)
					data = tonumber(time) + 1
					::insert::
					local insert_ok,insert_ret1,insert_ret2 = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
					if insert_ok then
						if insert_ret1 then
							toast("insert_data 成功")
						else
							toast("insert_data 失败:"..insert_ret2)
							goto insert
						end
					else
						toast("insert_data 失败:"..insert_ret1)
						goto insert
					end
				else
					toast("del_ret1 失败:"..del_ret1)
					goto delete
				end
			else
				toast("ok 失败:"..del_ret1)
				goto delete
			end
		else
			dialog("no data", 5)
			goto restart_insert
		end
		break
	end

	if var > 8 then
		mSleep(500)
		x1,y1 = findMultiColorInRegionFuzzy( 0x0b82f1, "1|-432|0xf5f5f5,13|-320|0xf5f5f5,-3|-196|0xf5f5f5", 90, 0, 0, 749, 1333)
		if x1~=-1 and y1~=-1 then
			mSleep(500)
			::errors::
			--插入失败信息
			local ts_enterprise_lib = require("ts_enterprise_lib")
			local category = "error-information"
			local insert_ok,insert_ret1,insert_ret2 = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,success_data)
			if insert_ok then
				if insert_ret1 then
					toast("insert_data错误信息成功", 1)
				else
					toast("insert_data错误信息失败:"..insert_ret2, 1)
					goto errors
				end
			else
				toast("insert_data错误信息失败:"..insert_ret1, 1)
				goto errors
			end
			mSleep(1000)
			moveTo(374,  485, 370, 643)
			mSleep(1000)
			infor = true
--			if again_infor then
--				again_infor = false
			mation = true
			goto infomation
--			else
--				write_rstart = true
--				again_infor = true
--				goto again
--			end
		end
	else
		toast("预认证"..var,1)
		mSleep(1000)
	end

end