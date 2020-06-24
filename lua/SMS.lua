--wechat version 7.0.7
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json
local model 				= {}

model.awz_bid 			= "AWZ"
model.wc_bid 			= "com.tencent.xin"
math.randomseed(getRndNum()) -- 随机种子初始化真随机数

--随机字符串
function model:randomStr(str, num)
	local ret =''
	for i = 1, num do
		local rchr = math.random(1, string.len(str))
		ret = ret .. string.sub(str, rchr, rchr)
	end
	return ret
end

--[[随机内容(UTF-8中文字符占3个字符)]]
function model:Rnd_Word(strs,i,Length)
	local ret=""
	local z
	if Length == nil then Length = 1 end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6)+State["随机常量"])  
	math.random(string.len(strs)/Length)
	for i=1, i do
		z=math.random(string.len(strs)/Length)
		ret = ret..string.sub(strs,(z*Length)-(Length-1),(z*Length))
	end
	return(ret)
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动",1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 33, 503, 711, 892)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	mSleep(500)
	if self:file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333);   
		mSleep(math.random(500, 1000))
		if type(point) == "table"  and #point ~=0  then
			mSleep(500)
			x_len = point[1].x
			toast(x_len,1)
			return x_len
		else
			x_len = 0
			return x_len
		end
	else
		dialog("文件不存在",1)
		mSleep(math.random(1000, 1500))
	end
end

function model:change_vpn()
	mSleep(500)
	openURL("prefs:root=General&path=VPN")
	while true do
		mSleep(500)
		if getColor(367,89) == 0 then
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x000000, "30|3|0x000000,51|-1|0x000000,101|4|0x000000,150|-4|0x000000,172|0|0x000000,188|1|0x000000", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y)
				mSleep(2000)
				setVPNEnable(true)
				mSleep(5000)
				runApp(self.wc_bid)
				mSleep(1000)
				break
			end
		end
	end
end

function model:change_GNvpn()
	mSleep(500)
	openURL("prefs:root=General&path=VPN")
	while true do
		mSleep(500)
		if getColor(367,89) == 0 then
			mSleep(500)
			tap(216,  504)
			mSleep(1500)
			runApp(self.wc_bid)
			mSleep(1000)
			break
		end
	end
end

function model:vpn()
	mSleep(math.random(1000, 1500))
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(math.random(2000, 2500))
	old_data = getNetIP() --获取IP  
	toast(old_data,1)

	::get_vpn::
	mSleep(math.random(500, 700))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态",1)
		setVPNEnable(false)
		for var= 1, 10 do
			mSleep(math.random(500, 700))
			toast("等待vpn切换"..var,1)
			mSleep(math.random(500, 700))
		end
		goto get_vpn
	else
		toast("关闭状态",1)
	end

	setVPNEnable(true)
	mSleep(1000*math.random(10, 15))
	
	new_data = getNetIP() --获取IP  
	toast(new_data,1)
	if new_data == old_data then
		toast("vpn切换失败",1)
		mSleep(math.random(500, 700))
		setVPNEnable(false)
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "3|15|0x007aff,19|10|0x007aff,-50|-128|0x000000,-34|-147|0x000000,3|-127|0x000000,37|-132|0x000000,59|-135|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,10)
			mSleep(math.random(500, 700))
			toast("vpn连接失败1",1)
		end

		--好
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "1|20|0x007aff,11|0|0x007aff,18|17|0x007aff,14|27|0x007aff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,10)
			mSleep(math.random(500, 700))
			toast("vpn连接失败2",1)
		end
		goto get_vpn
	else
		toast("vpn正常使用", 1)
	end

end

function model:readFileBase64(path) 
	f = io.open(path,"rb")
	if f == null then
		toast("no file")
		mSleep(3000);
		return null;
	end 
	bytes = f:read("*all");
	f:close();
	return bytes:base64_encode();

end

function model:clear_App()
	::run_again::
	mSleep(500)
	closeApp(self.awz_bid)
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(3, 6))
	
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
			toast("新机成功，但是ip重复了",1)
		elseif result == 1 then
			toast("新机成功",1)
		else 
			dialog("失败，请手动查看问题", 0)
		end
	end 
end

function model:get_hkUrl(country_num)
	filepath=appDataPath('com.tencent.xin')..'/Documents/MMappedKV/maycrashcpmap_v2'
	local file = io.open(filepath,'r')
	local text = file:read("*all")
	file:close()
	if text then
		local link='https%3a%2f%2fweixin110.qq.com%2fsecurity%2freadtemplate%3ft%3dsignup%5Fverify%2fw%5Fintro%26regcc%3d'..country_num..'%26regmobile%3d'..text:match('mobile=(%d+)&regid')..'%26regid%3d'..text:match('regid=(%d%p%d+)&scen')..'%26scene%3dget_reg_verify_code%26wechat_real_lang%3dzh_CN'
		return urlDecoder(link)
	else
		toast('文件不存在',1)
	end
end

function model:ewm(phone_help,skey,tiaoma_bool,fz_bool,fz_type,phone,phone_token,api_change,SMS_country,pid,pay_id,ewm_url,provinceId,tzid,getPhone_key,sumbit_key)
	if fz_type == "0" or fz_type == "7" then
		if fz_type == "0" then
			--下单
			::down_ewm::
			local sz = require("sz");
			local http = require("szocket.http")
			local res, code = http.request("http://api.004461.cn/create.action?url="..ewm_url.."&merchant="..sumbit_key.."&provinceId="..provinceId)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.code == "200" then
					toast(tmp.message, 1)
					order_sn = tmp.data.order_sn
				end
			else
				goto down_ewm
			end 
		end
	
		--查询订单状态
		status_time = 0
		while (true) do
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				self:change_vpn()
				mSleep(500)
				randomsTap(373, 1099,10)
				mSleep(math.random(500, 700))
				status = 1
				break
			else
				toast(status_time,1)
				status_time = status_time + 1
				mSleep(4500)
			end

			if status_time > 72 then
				status = 2
				break
			end
		end
	end
	
	yzm_mess = ""
	restart_time = 0
	get_time = 0
	wait = 0
	mess_time = 0
	gn = true
	::get_code_again::
	yzm_error = false
	if status == 1 or fz_bool or tiaoma_bool or phone_help then
		while true do
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1500, 2700))
				setVPNEnable(false)
				if gn and not tiaoma_bool then
					mSleep(2000)
					self:change_GNvpn()
					mSleep(1000)
					gn = false
				end
				randomsTap(412, 489,5)
				mSleep(math.random(500, 700))
				toast("接收短信中",1)
				break
			end
			
			mSleep(math.random(500,700))
			if getColor(390,822) == 0x576b95 and getColor(363,822) == 0x576b95 then
				mSleep(500)
				randomsTap(390,822,5)
				mSleep(500)
				toast("拒收微信登录",1)
				yzm_error = true
				break
			end
		end
	end
	
	if yzm_error then
		return false
	else
		if status == 1 or fz_bool or tiaoma_bool or phone_help then
			if api_change == "0" then
				while (true) do
					mSleep(math.random(500, 700))
					local sz = require("sz");
					local http = require("szocket.http")
					local res, code = http.request("http://47.104.246.33/onlinesim.php?cmd=getsms&apikey="..getPhone_key.."&tzid="..tzid)
					
					if code == 200 then
						tmp = json.decode(res)
						if tmp.response == "TZ_NUM_ANSWER" then
							toast(tmp.msg,1)
							yzm_mess = tmp.msg
							break
						else
							wait = wait + 1
							toast("验证码获取失败"..wait,1)
							mSleep(1000)
						end
					else
						wait = wait + 1
						toast("验证码获取失败"..wait,1)
						mSleep(1000)
					end

					if wait > 23 then
						mSleep(math.random(1000, 1500))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(1000, 1500))
						wait = 1
						restart_time = restart_time + 1
						toast("重新获取验证码",1)
					end
					
					if restart_time > 2 then
						status = 2
						--标记订单
						local sz = require("sz");
						local http = require("szocket.http")
						local res, code = http.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)

						if code == 200 then
							tmp = json.decode(res)
							if tmp.code == "200" then
								toast(tmp.message, 1)
								mSleep(3000)
							end
						end
					else
						goto get_code_again
					end
				end
				
			elseif api_change == "1" then
				while true do
					mSleep(500)
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://simsms.org/priemnik.php?metod=get_sms&country="..SMS_country.."&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv&id="..pay_id)

					if code == 200 then
						tmp = json.decode(res)
						if tmp.response == "1" then
							toast(tmp.sms, 1)
							yzm_mess = tmp.sms
							break
						else
							toast("获取不到验证码"..mess_time,1)
							mess_time = mess_time + 1
							mSleep(30000)
						end
					else
						toast("获取验证码失败，重新获取",1)
						mess_time = mess_time + 1
						mSleep(30000)
					end
					
					if mess_time > 20 then
						status = 2
						::black::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request("http://simsms.org/priemnik.php?metod=ban&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv&id="..pay_id)

						if code == 200 then
							tmp = json.decode(res)
							if tmp.response == "1" then
								toast("手机号码拉黑成功", 1)
							else
								toast("拉黑失败",1)
								goto black
							end
						else
							toast("拉黑失败",1)
							goto black
						end
					end
				end
			
			elseif api_change == "2" then
				::get_mess::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						yzm_mess = data[2]
					elseif data[1] == "0" then
						toast("暂无短信"..get_time,1)
						mSleep(15000)
						get_time = get_time + 1
						if get_time > 6 then
							mSleep(math.random(1000, 1500))
							randomsTap(372,  749, 3)
							mSleep(math.random(1000, 1500))
							randomsTap(368, 1039,5)
							mSleep(math.random(1000, 1500))
							get_time = 1
							restart_time = restart_time + 1
							toast("重新获取验证码",1)
						end
						
						if restart_time > 2 then
							status = 2
							::addblack::
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid)
							mSleep(500)
							if code == 200 then
								data = strSplit(res, "|")
								if data[1] == "1" then
									toast("释放手机号码",1)
								else
									goto addblack
								end
							end
						else
							goto get_code_again
						end
						
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif api_change == "3" then
				::get_mess::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.56.103.47/api.php?action=GetCode&token="..tokens.."&pid="..work_id.."&number="..phone)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						yzm_mess = data[2]
					elseif data[1] == "no" then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						if get_time > 20 then
							mSleep(math.random(1000, 1500))
							randomsTap(372,  749, 3)
							mSleep(math.random(1000, 1500))
							randomsTap(368, 1039,5)
							mSleep(math.random(1000, 1500))
							get_time = 1
							restart_time = restart_time + 1
							toast("重新获取验证码",1)
						end
						
						if restart_time > 2 then
							status = 2
							::addblack::
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://47.56.103.47/api.php?action=AddBlackNumber&token="..tokens.."&pid="..kn_id.."&number="..telphone)
							mSleep(500)
							if code == 200 then
								data = strSplit(res, ",")
								if data[1] == "ok" then
									toast("加黑手机号码",1)
								else
									goto addblack
								end
							end
						else
							goto get_code_again
						end
					else
						toast("请求接口或者参数错误,脚本重新运行",1)
						lua_restart()
					end

				else
					toast("获取验证码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif api_change == "4" then
				::get_mess::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://129.204.138.57:11223/api/Camel/getmessage?token="..tokens.."&skey="..skey)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.Status == 201 then
						yzm_mess = string.match(tmp.Data.SMS, '%d+%d+%d+%d+%d+%d+')
					elseif tmp.Status == 202 then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						if get_time > 20 then
							mSleep(math.random(1000, 1500))
							randomsTap(372,  749, 3)
							mSleep(math.random(1000, 1500))
							randomsTap(368, 1039,5)
							mSleep(math.random(1000, 1500))
							get_time = 1
							restart_time = restart_time + 1
							toast("重新获取验证码",1)
						end
						
						if restart_time > 2 then
							status = 2
							::addblack::
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://129.204.138.57:11223/api/Camel/addblack?token="..tokens.."&skey="..skey)
							mSleep(500)
							if code == 200 then
								tmp = json.decode(res)
								if tmp.Status == 200 then
									toast("加黑手机号码",1)
								else
									goto addblack
								end
							end
						else
							goto get_code_again
						end
					else
						toast("请求接口或者参数错误,脚本重新运行",1)
						lua_restart()
					end

				else
					toast("获取验证码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif api_change == "5" then
				::get_mess::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://opapi.lemon9191.com/out/ext_api/getMsg?name="..username.."&pwd="..user_pass.."&pn="..telphone.."&pid=0006&&serial=2")
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == 200 then
						yzm_mess = tmp.data
						toast(yzm_mess,1)
					elseif tmp.code == 908 then
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 20 then
							status = 2
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://opapi.lemon9191.com/out/ext_api/passMobile?name="..username.."&pwd="..user_pass.."&pn="..telphone.."&pid=0006&serial=2")
							mSleep(500)
							if code == 200 then
								tmp = json.decode(res)
								if tmp.code == 200 then
									toast("释放号码成功",1)
								end
							end
						else
							goto get_mess
						end
					elseif tmp.code == 405 then
						dialog("验证码获取失败",5)
						mSleep(2000)
						lua_restart()
					end
				else
					toast("获取手机号码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif api_change == "6" then
				::get_mess::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.104.246.33/api.php?cmd=code&token="..getPhone_key.."&src=tl&app=WeChat&username="..username.."&mobile="..telphone)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if #(tmp.data:atrim()) > 0 then
						yzm_mess = tmp.data
					else
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						if get_time > 15 then
							mSleep(500)
							randomsTap(372,  749, 3)
							mSleep(math.random(1000, 1500))
							randomsTap(368, 1039,5)
							mSleep(math.random(2000, 3000))
							get_time = 1
							restart_time = restart_time + 1
						end
						
						if restart_time > 2 then
							status = 2
						end
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			end
			
			mSleep(500)
			if #yzm_mess > 0 then
				mSleep(math.random(500, 700))
				randomsTap(390,  472,9)
				mSleep(math.random(1000, 1500))
				for i = 1, #(yzm_mess) do
					mSleep(math.random(500, 700))
					num = string.sub(yzm_mess,i,i)
					if num == "0" then
						randomsTap(373, 1281, 8)
					elseif num == "1" then
						randomsTap(132,  955, 8)
					elseif num == "2" then
						randomsTap(377,  944, 8)
					elseif num == "3" then
						randomsTap(634,  941, 8)
					elseif num == "4" then
						randomsTap(128, 1063, 8)
					elseif num == "5" then
						randomsTap(374, 1061, 8)
					elseif num == "6" then
						randomsTap(628, 1055, 8)
					elseif num == "7" then
						randomsTap(119, 1165, 8)
					elseif num == "8" then
						randomsTap(378, 1160, 8)
					elseif num == "9" then
						randomsTap(633, 1164, 8)
					end
				end
				mSleep(math.random(500, 700))
				randomsTap(546,  623,11)
				mSleep(math.random(500, 700))
			
				if fz_type == "0" then
					--标记订单
					local sz = require("sz");
					local http = require("szocket.http")
					local res, code = http.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)

					if code == 200 then
						tmp = json.decode(res)
						if tmp.code == "200" then
							toast(tmp.message, 1)
							mSleep(3000)
						end
					end
				end
				return true
			else
				return false
			end
		else
			if fz_type == "0" then
				--标记订单
				local sz = require("sz");
				local http = require("szocket.http")
				local res, code = http.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)

				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == "200" then
						toast(tmp.message, 1)
						mSleep(3000)
					end
				end
			end
			return false
		end
	end
end


function model:wchat(login_times,login_times_set,skey,wc_version,hk_way,fz_key, fz_type, phone, country_num, phone_token, api_change, SMS_country,username, user_pass, work_id, phone_country, country_id,nickName,password,provinceId,getPhone_key, sumbit_key)
	account_len = 0
	next_again_time_bool = false
	old = ""
	::run_app::
	mSleep(500)
	closeApp(self.wc_bid)
	::nexts::
	mSleep(math.random(1000, 1500))
	runApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(549, 1240,10)
			mSleep(math.random(500, 700))
			toast("注册",1)
			break
		end
		
		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
		
	end
	
	::start::
	while (true) do
		--10系统
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xf2f2f2,"458|9|0xf2f2f2,291|-94|0x576b95",100,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("注册页面",1)
			break
		end
		
		--11系统
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"194|0|0xd7f5e5,530|-7|0x9ce6bf,234|-36|0x9ce6bf,229|28|0x9ce6bf",90,0,831,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			toast("注册页面",1)
			mSleep(1000)
			break
		end
		
		--点击模态框10
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a,"11|2|0x1a1a1a,44|1|0x1a1a1a,79|-1|0x1a1a1a,114|-1|0x1a1a1a,153|3|0x1a1a1a,187|3|0x1a1a1a", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,10)
			mSleep(math.random(500, 700))
		end
		
		--点击模态框11
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0,"10|7|0,22|7|0,45|4|0,80|3|0,117|3|0,153|8|0,178|8|0", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(367,1042,10)
			mSleep(math.random(500, 700))
		end
	end
	
	
	next_again_time_bool = false
	if api_change == "0" then
		if country_id == "0" then		--乌克兰
			country_num = "380"
		elseif country_id == "1" then		--英国
			country_num = "44"
		elseif country_id == "2" then		--波兰
			country_num = "48"
		end
		
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.104.246.33/onlinesim.php?cmd=getphone&apikey="..getPhone_key.."&service=WeChat&country="..country_num)

		if code == 200 then
			tmp = json.decode(res)
			if tmp.country and #tmp.country > 0 then
				tzid = tmp.tzid
				toast(tmp.number, 1)
				toast(tmp.country, 1)
				toast(tmp.tzid, 1)
			else
				toast("获取不到国家取号，重新取号:"..res,1)
				mSleep(2000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(3000)
			goto get_phone
		end
		
	elseif api_change == "1" then
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://simsms.org/priemnik.php?metod=get_number&country="..SMS_country.."&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv")

		if code == 200 then
			tmp = json.decode(res)
			if tmp.response == "1" then
				toast(tmp.number, 1)
				toast(tmp.CountryCode, 1)
				toast(tmp.id, 1)
				pay_id = tmp.id
			else
				toast("获取不到国家取号，重新取号:"..res,1)
				mSleep(30000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(30000)
			goto get_phone
		end
	elseif api_change == "2" then
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..work_id)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "1" then
				telphone = data[5]
				pid = data[2]
				toast(telphone,1)
			else
				toast("获取手机号码失败，重新获取:"..res,1)
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(1000)
			goto get_phone
		end
	elseif api_change == "3" then
		::get_token::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=Login&user="..username.."&pwd="..user_pass)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				tokens = data[2]
			else
				toast("请求接口或者参数错误,脚本重新运行:"..res,1)
				lua_restart()
			end
		else
			toast("获取token失败，重新获取:"..res,1)
			mSleep(1000)
			goto get_token
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=GetNumber&token="..tokens.."&pid="..work_id)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				telphone = data[2]
			elseif data[1] == "no" then
				toast("暂无号码",1)
				mSleep(1000)
				goto get_phone
			else
				toast("请求接口或者参数错误，脚本重新运行:"..res,1)
				lua_restart()
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(1000)
			goto get_phone
		end
	
	elseif api_change == "4" then
		::get_token::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://129.204.138.57:11223/api/Camel/login?uname="..username.."&upwd="..user_pass)

		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.Status == 200 then
				tokens = tmp.Data.TOKEN
			else
				toast("请求接口或者参数错误,脚本重新运行:"..tmp.Msg,1)
				lua_restart()
			end
		else
			toast("获取token失败，重新获取:"..res,1)
			mSleep(1000)
			goto get_token
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://129.204.138.57:11223/api/Camel/getphone?token="..tokens.."&rid="..work_id.."&idn="..SMS_country)

		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.Status == 200 then
				telphone = tmp.Data[1].PN
				skey = tmp.Data[1].SKEY
			elseif tmp.Status == 906 then
				toast(tmp.Msg,1)
				mSleep(5000)
				goto get_phone
			else
				toast("请求接口或者参数错误，脚本重新运行:"..tmp.Msg,1)
				lua_restart()
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(1000)
			goto get_phone
		end
	elseif api_change == "5" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://opapi.lemon9191.com/out/ext_api/getMobile?name="..username.."&pwd="..user_pass.."&cuy="..SMS_country.."&pid=0006&num=1&noblack=0&serial=2&secret_key=bfcd1412722c6fc2007bdd4a")
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.code == 200 then
				telphone = tmp.data
				toast(telphone,1)
			elseif tmp.code == 906 then
				toast(tmp.msg,1)
				mSleep(5000)
				goto get_phone
			else
				toast(tmp.msg,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "6" then
		::get_user::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.104.246.33/api.php?cmd=balance&token="..getPhone_key.."&username="..username)
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.msg == "success" then
				mSleep(200)
				if tonumber(tmp.data) > 20 then
					toast("当前余额:"..tmp.data,1)
					mSleep(2000)
				else
					toast("当前余额低于20元",1)
					mSleep(3000)
					goto get_user
				end
			else
				mSleep(500)
				toast("获取信息，重新获取:"..res,1)
				mSleep(5000)
				goto get_user
			end
		else
			toast("获取信息，重新获取:"..res,1)
			mSleep(10000)
			goto get_user
		end
		
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.104.246.33/api.php?cmd=mobile&token="..getPhone_key.."&src=tl&app=WeChat&username="..username)
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.msg == "success" then
				mSleep(200)
				telphone = tmp.data
				toast(telphone,1)
			else
				mSleep(500)
				toast("获取手机号码失败，重新获取:"..res,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..res,1)
			mSleep(10000)
			goto get_phone
		end
	end
	
	if country_id == "0" then
		--昵称
		while true do
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0,"7|2|0,20|-2|0,22|-9|0,40|15|0,55|3|0,58|-5|0", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x+300,y+3)
				mSleep(math.random(500, 700))
				break
			end
		end

		if nickName == "0" then  --符号
			mSleep(math.random(500, 700))
			randomsTap(48, 1284, 5)
			mSleep(math.random(1000, 1500))
			randomsTap(635,1072,6)

		elseif nickName == "1" then  --中文
			State={
				["随机常量"] = 0,
				["姓氏"]="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
				"姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍" ..
				"史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾" ..
				"孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈" ..
				"项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡" ..
				"田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸" ..
				"左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄曲家封芮羿储靳汲邴糜松井" ..
				"段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎" ..
				"祖武符刘景詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲邰从鄂索咸籍赖卓蔺屠" ..
				"蒙池乔阴鬱胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛" ..
				"寿通边扈燕冀郟浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈" ..
				"廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂" ..
				"晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权" ..
				"逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台" ..
				"公冶宗政濮阳淳于单于太叔申屠公孙仲孙轩辕令狐钟离宇文长孙慕容鲜" ..
				"于闾丘司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良" ..
				"拓拔夹谷宰父谷粱晋楚闫法汝鄢涂钦段干百里东郭南门呼延归海羊舌微" ..
				"生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱" ..
				"阳佟第五言福百家姓终",
				["名字"]="安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
				"濮存罡禄瑛瑛嗣嫚朵寅添渟黎臻舞绢城骥彰渺禾教祖剑黎莞咸浓芦澹帅臻渟添禾亭添亭霖深策臻稷辞" ..
				"悟悟澄涉城鸥黎悟乔恒黎鲲涉莞霖甲深婕乔程澹男岳深涉益澹悟箫乔多职适芦瑛澄婕朵适祖霖瑛坤嫚" ..
				"涉男珂箫芦黎珹绢芦程识嗣珂瑰枝允黎庸嗣赐罡纵添禄霖男延甲彰咸稷箫岳悟职祖恒珂庸琅男莞庸浓" ..
				"多罡延瑛濮存爵添剑益骥澄延迪寅婕程霖识瑰识程群教朵悟舞岳浓箫城适程禾嫚罡咸职铃爵渺添辞嫚" ..
				"浓寅鲲嗣瑛鸥多教瑛迪坤铃珹群黎益澄程莞深坤澹禄职澹赩澄藉群箫骥定彰寅臻渟枝允珹深群黎甲鲲" ..
				"亭黎藏浓涤渟莞寅辞嗣坤迪嫚添策庸策藉瑰彰箫益莞渺乔彰延舞祖婕澹渺鸥纵嗣瑛藏濮存婕职程芦群" ..
				"禾嫚程辞祖黎职浓桦藏渟禾彰帅辞铃铃黎允绢濮存剑辞禾瑰添延添悟赐祖咸莞男绢策婕藉禾浓珹涤祖" ..
				"汉骥舞瑛多稷赐莞渟黎舞桦黎群藏渺黎坤桦咸迪澈舞允稷咸剑定亭澄濮存鲲臻全鸥多赐程添瑛亭帅悟" ..
				"甲男帅涤适纵渟鲲亭悟琅亭添允舞禾庸咸瑛教鲲允箫芦允瑛咸鸥帅悟延珂黎珹箫爵剑霖剑霖禄鸥悟涉" ..
				"彰群悟辞帅渺莞澄桦瑛适臻益霖珹亭澹辞坤程嗣铃箫策澈枝赐莞爵渟禄群枝添芦群浓赐职益城澄赩琅" ..
				"延群乔珹鲲祖群悟黎定庸澄芦延霖罡鲲咸渺纵亭禄鸥赩涤剑澹藏纵濮存澄芦剑延瑰稷黎益赩澄允悟澈" ..
				"甲嗣绢朵益甲悟涤婕群咸臻箫鲲寅鸥桦益珂舞允庸芦藉寅渺咸赐澄程剑瑰霖瑰铃帅男铃悟识瑰仕仕城" ..
				"允莞全朵涤铃剑渺稷剑珂铃箫全仕益纵芦桦珂濮存城朵朵咸程剑澄定澈爵寅庸定莞瑛教彰黎箫仕黎桦" ..
				"赩深赩爵迪悟珹涤琅添箫桦帅瑛黎黎策识寅嫚涉迪策汉舞定彰允男祖教澄群瑛濮存男禾教莞禾鸥澈濮" ..
				"存岳城嫚深舞教岳澄亭禾坤朵亭职莞稷寅瑰城庸亭舞禾瑛恒坤浓彰莞澄澈鸥臻稷教琅辞益剑藉黎添瑛" ..
				"延舞坤仕岳多婕骥迪帅黎悟全澄识益甲桦纵适罡彰澄禾婕程黎城涤浓枝箫咸渟岳渟澹臻珹识珹澄箫辞" ..
				"浓鲲识悟允悟禾识群祖迪渟鲲群庸莞珹悟澹瑰悟鸥汉群甲莞庸职琅莞桦鲲朵深乔辞允彰渺朵瑰亭瑰朵" ..
				"定深男识群职霖益男舞城允舞爵赩枝罡罡群澹芦藉爵悟渟澹禾多庸箫坤乔芦甲濮存多渟藉珹赐汉纵亭" ..
				"禾城枝剑露以玉春飞慧娜悠亦元晔曜霜宁桃彦仪雨琴青筠逸曼代菀孤昆秋蕊语莺丝红羲盛静南淑震晴" ..
				"彭祯山霞凝柔隽松翠高骊雅念皓双洛紫瑞英思歆蓉娟波芸荷笑云若宏夏妍嘉彩如鹏寄芝柳凌莹蝶舒恬" ..
				"虹清爽月巧乾勋翰芳罗刚鸿运枫阳葳杰怀悦凡哲瑶凯然尚丹奇弘顺依雪菡君畅白振馨寻涵问洁辉忆傲" ..
				"伟经润志华兰芹修晨木宛俊博韶天锐溪燕家沈放明光千永溶昊梅巍真尔馥莲怜惜佳广香宇槐珺芷帆秀" ..
				"理柏书沛琪仙之竹向卉欣旻晓冬幻和雁淳浩歌荣懿文幼岚昕牧绿轩工旭颜醉玑卓觅叶夜灵胜晗恨流佁" ..
				"乐火音采睿翎萱民画梦寒泽怡丽心石邵玮佑旺壮名一学谷韵宜冰赫新蕾美晖项琳平树又炳骏气海毅敬" ..
				"曦婉爰伯珊影鲸容晶婷林子昌梧芙澍诗星冉初映善越原茂国腾孟水烟半峯莉绮德慈敏才戈梓景智盼霁" ..
				"琇苗熙姝从谊风发钰玛忍婀菲昶可荌小倩妙涛姗方图迎惠晤宣康娅玟奕锦濯穆禧伶丰良祺珍曲喆扬拔" ..
				"驰绣烁叡长雯颖辰慕承远彬斯薇成聪爱朋萦田致世实愫进瀚朝强铭煦朗精艺熹建忻晏冷佩东古坚滨菱" ..
				"囡银咏正儿瑜宝蔓端蓓芬碧人开珠昂琬洋璠桐舟姣琛亮煊信今年庄淼沙黛烨楠桂斐胤骄兴尘河晋卿易" ..
				"愉蕴雄访湛蓝媛骞娴儒妮旋友娇泰基礼芮羽妞意翔岑苑暖玥尧璇阔燎偲靖行瑾资漪晟冠同齐复吉豆唱" ..
				"韫素盈密富其翮熠绍澎淡韦诚滢知鹍苒抒艳义婧闳琦壤杨芃洲阵璟茵驹涆来捷嫒圣吟恺璞西旎俨颂灿" ..
				"情玄利痴蕙力潍听磊宸笛中好任轶玲螺郁畴会暄峻略琼琰默池温炫季雰司杉觉维饮湉许宵茉贤昱蕤珑" ..
				"锋纬渊超萍嫔大霏楚通邈飙霓谧令厚本邃合宾沉昭峰业豪达彗纳飒壁施欢姮甫湘漾闲恩莎祥启煜鸣品" ..
				"希融野化钊仲蔚生攸能衍菁迈望起微鹤荫靓娥泓金琨筱赞典勇斌媚寿喜飇濡宕茜魁立裕弼翼央莘绚焱" ..
				"奥萝米衣森荃航璧为跃蒙庆琲倚穹武甜璐俏茹悌格穰皛璎龙材湃农福旷童亘苇范寰瓃忠虎颐蓄霈言禹" ..
				"章花健炎籁暮升葛贞侠专懋澜量纶布皎源耀鸾慨曾优栋妃游乃用路余珉藻耘军芊日赡勃卫载时三闵姿" ..
				"麦瑗泉郎怿惬萌照夫鑫樱琭钧掣芫侬丁育浦磬献苓翱雍婵阑女北未陶干自作伦珧溥桀州荏举杏茗洽焕" ..
				"吹甘硕赋漠颀妤诺展俐朔菊秉苍津空洮济尹周江荡简莱榆贝萧艾仁漫锟谨魄蔼豫纯翊堂嫣誉邦果暎珏" ..
				"临勤墨薄颉棠羡浚兆环铄"
			}
			State["随机常量"] = tonumber(self:Rnd_Word("0123456789",5))

			Nickname = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],2,3)
			mSleep(math.random(500, 700))
			inputStr(Nickname)
			mSleep(math.random(500, 700))

		elseif nickName == "2" then  --英文
			for var= 1, 8 do
				num = math.random(1, 26) 
				mSleep(math.random(500, 700))
				if num > 0 and num < 11 then
					randomsTap(37+(num-1)*80,  967,8)
				elseif num > 10 and num < 20 then
					randomsTap(73+(num-11)*80, 1073,8)
				elseif num > 19 and num < 27 then
					randomsTap(147+(num-20)*80, 1179,8)
				end
				mSleep(math.random(500, 700))
			end

		elseif nickName == "3" then  --数字
			Nickname = tmp.number
			nickname = string.sub(Nickname,5,#Nickname)
			mSleep(math.random(500, 700))
			randomsTap(49, 1283,8)
			mSleep(math.random(500, 700))
			for i = 1, #nickname do
				mSleep(math.random(500, 700))
				num = string.sub(nickname,i,i)
				if num == "0" then
					randomsTap(713,  965, 8)
				elseif num == "1" then
					randomsTap(38,  964, 8)
				elseif num == "2" then
					randomsTap(112,  965, 8)
				elseif num == "3" then
					randomsTap(185,  965, 8)
				elseif num == "4" then
					randomsTap(264,  963, 8)
				elseif num == "5" then
					randomsTap(338,  964, 8)
				elseif num == "6" then
					randomsTap(414,  962, 8)
				elseif num == "7" then
					randomsTap(495,  964, 8)
				elseif num == "8" then
					randomsTap(566,  966, 8)
				elseif num == "9" then
					randomsTap(642,  961, 8)
				end
			end
		
		elseif nickName == "4" then  --RFG
			mSleep(math.random(500, 700))
			inputStr("Really fun game")
			
		elseif nickName == "5" then  --特殊符号
			mSleep(math.random(500, 700))
			inputStr("르㸏مฬ้๊سمرًς.έل")
			
		end
		
	end
	
	--国家／地区
	while (true) do
		--10
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1a1a1a,"22|0|0x1a1a1a,27|27|0x1a1a1a,0|24|0x1a1a1a,14|12|0x1a1a1a,36|5|0x1a1a1a,64|4|0x1a1a1a", 90, 0, 0, 749, 431)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+60,y+90, 6)
			mSleep(math.random(500, 700))
			break
		end
		--11
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0,"27|26|0,3|25|0,17|-2|0,14|6|0,35|2|0,63|1|0", 90, 0, 0, 749, 701)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+60,y+90, 6)
			mSleep(math.random(500, 700))
			break
		end
	end


	--删除区号
	for var= 1, 10 do
		mSleep(100)
		keyDown("DeleteOrBackspace")
		mSleep(100)
		keyUp("DeleteOrBackspace")
	end
	
	--输入国家区号
	mSleep(math.random(500, 700))
	if api_change == "0" then
		country_num = tmp.country
	elseif api_change == "1" then
		country_num = tmp.CountryCode
	elseif api_change == "2" or api_change == "3" or api_change == "4" or api_change == "5" or api_change == "6" then
		country_num = phone_country
	end
	
	mSleep(math.random(500, 700))
	for i = 1, #(country_num) do
		mSleep(math.random(500, 700))
		num = string.sub(country_num,i,i)
		if num == "0" then
			randomsTap(373, 1281, 8)
		elseif num == "1" then
			randomsTap(132,  955, 8)
		elseif num == "2" then
			randomsTap(377,  944, 8)
		elseif num == "3" then
			randomsTap(634,  941, 8)
		elseif num == "4" then
			randomsTap(128, 1063, 8)
		elseif num == "5" then
			randomsTap(374, 1061, 8)
		elseif num == "6" then
			randomsTap(628, 1055, 8)
		elseif num == "7" then
			randomsTap(119, 1165, 8)
		elseif num == "8" then
			randomsTap(378, 1160, 8)
		elseif num == "9" then
			randomsTap(633, 1164, 8)
		end
	end

	--密码
	while (true) do
		mSleep(math.random(500, 1000))
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "15|-4|0x1a1a1a,28|0|0x1a1a1a,14|17|0x1a1a1a,3|20|0x1a1a1a,25|18|0x1a1a1a,37|15|0x1a1a1a,53|-5|0x1a1a1a,58|16|0x1a1a1a,83|9|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+400,y-70,8)
			mSleep(math.random(1000, 1500))
			break
		end
		
		mSleep(math.random(500, 1000))
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+400,y-70,8)
			mSleep(math.random(1000, 1500))
			break
		end
	end
	
	mSleep(math.random(500, 700))
	if api_change == "0" then
		if country_id == "0" then
			phone = string.sub(tmp.number,5,#tmp.number)
		else
			phone = string.sub(tmp.number,4,#tmp.number)
		end
	elseif api_change == "1" then
		phone = tmp.number
	elseif api_change == "2" then
		if country_num ~= "86" then
			b,c = string.find(telphone,phone_country)
			if c ~= nil then
				phone = string.sub(telphone,#phone_country + 1,#telphone)
			else
				phone = telphone
			end
		else
			phone = telphone
		end
	elseif api_change == "3" then
		phone = telphone
	elseif api_change == "4" then
		b,c = string.find(string.sub(telphone,1,#country_num),country_num)
		if c ~= nil then
			phone = string.sub(telphone,c+1,#telphone)
		else
			phone = telphone
		end
	elseif api_change == "5" then
		phone = string.sub(telphone, #country_num + 2,#telphone)
	elseif api_change == "6" then
		phone = string.sub(telphone, #country_num + 1 ,#telphone)
	end
	
	toast(phone,1)
	mSleep(1200)
	for i = 1, #phone do
		mSleep(math.random(500, 700))
		num = string.sub(phone,i,i)
		if num == "0" then
			randomsTap(373, 1281, 8)
		elseif num == "1" then
			randomsTap(132,  955, 8)
		elseif num == "2" then
			randomsTap(377,  944, 8)
		elseif num == "3" then
			randomsTap(634,  941, 8)
		elseif num == "4" then
			randomsTap(128, 1063, 8)
		elseif num == "5" then
			randomsTap(374, 1061, 8)
		elseif num == "6" then
			randomsTap(628, 1055, 8)
		elseif num == "7" then
			randomsTap(119, 1165, 8)
		elseif num == "8" then
			randomsTap(378, 1160, 8)
		elseif num == "9" then
			randomsTap(633, 1164, 8)
		end
	end
	
	if password == "0" then
		mSleep(500)
		password = "vip"..string.sub(phone,#phone-4,#phone)
	elseif password == "1" then
		mSleep(500)
		password = "hang"..string.sub(phone,#phone-3,#phone)
	end
	toast(password,1)
	mSleep(1000)
	
	--密码
	while (true) do
		mSleep(math.random(1000, 1500))
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "15|-4|0x1a1a1a,28|0|0x1a1a1a,14|17|0x1a1a1a,3|20|0x1a1a1a,25|18|0x1a1a1a,37|15|0x1a1a1a,53|-5|0x1a1a1a,58|16|0x1a1a1a,83|9|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+400,y,8)
			mSleep(math.random(1000, 1500))
			inputStr(password)
			mSleep(math.random(500, 700))
			break
		end
		
		mSleep(math.random(500, 1000))
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+400,y,8)
			mSleep(math.random(1000, 1500))
			inputStr(password)
			mSleep(math.random(500, 700))
			break
		end
	end
	
	self:vpn()
	
	if wc_version == "1" then
		--点击协议
		while (true) do
			mSleep(math.random(500, 1000))
			x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(x+19,y+164,4)
				mSleep(math.random(1000, 1500))
				break
			end
		end
	end
	
	next_again_time = 1
	::next_again::
	--协议后下一步
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-63|12|0x07c160,128|13|0x07c160,54|13|0xffffff,295|-2|0x07c160,-262|6|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,10)
			mSleep(math.random(500, 700))
			break
		end
		
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"540|-7|0x9ce6bf,270|30|0x9ce6bf,270|-89|0x576b95",90,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+100,y,10)
			mSleep(math.random(500, 700))
			break
		end
	end

	erweima_bool = false
	::erweima::
	if erweima_bool then
		if country_id == "0" then
			mSleep(math.random(1000, 1700))
			randomsTap(373, 1035,10)
			mSleep(math.random(500, 700))
		else
			mSleep(math.random(1000, 1700))
			randomsTap(373, 769,10)
			mSleep(math.random(500, 700))
		end
		erweima_bool = false
	end

	--隐秘政策
	time = 0
	while (true) do
		if country_num == "86" then
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0xd8f0d8,"-254|21|0x9ed99d,368|13|0x9ed99d,61|-20|0x9ed99d,49|46|0x9ed99d",100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x-277, y-100,1)
				mSleep(math.random(3000, 5000))
				break
			else
				time = time + 1
				toast("等待隐秘政策"..time,1)
				mSleep(math.random(2000, 3000))
			end
		else
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x-240, y-98,1)
				mSleep(math.random(3000, 5000))
				break
			else
				time = time + 1
				toast("等待隐秘政策"..time,1)
				mSleep(math.random(1000, 1500))
			end
		end
		
		--欧盟国家需要多下一步
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xffffff,"37|5|0xffffff,-108|11|0x7c160,37|-16|0x7c160,182|8|0x7c160,42|34|0x7c160", 100, 0, 1000, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y,5)
			mSleep(math.random(500, 700))
			toast("欧盟国家下一步",1)
		end
		
		if time > 40 then
			mSleep(math.random(500, 700))
			randomsTap(56,   81,8)
			mSleep(math.random(500, 700))
			goto next_again
			time = 0
		end
	end
	
	ys_next = 0
	--隐秘政策：下一步
	while (true) do
		if country_num == "86" then
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0xd8f0d8,"-254|21|0x9ed99d,368|13|0x9ed99d,61|-20|0x9ed99d,49|46|0x9ed99d",100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x-277, y-100,1)
				mSleep(math.random(3000, 5000))
			end
		else
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x-240, y-98,1)
				mSleep(math.random(3000, 5000))
			end
		end
		
		--86   272,1235,0x1aad19}
		mSleep(math.random(500, 700))
		if getColor(272,1235) == 0x1aad19 then
			mSleep(math.random(2500, 4700))
			randomsTap(272,1235,10)
			mSleep(math.random(1000, 1700))
			toast("隐秘政策同意，下一步",1)
			mSleep(1000)
			ys_next = ys_next + 1
		end
		
		mSleep(math.random(500, 700))
		if getColor(300, 1201) == 0x07c160 then
			mSleep(math.random(1000, 1700))
			randomsTap(370, 1204,10)
			mSleep(math.random(1000, 1700))
			toast("下一步",1)
			mSleep(1000)
			ys_next = ys_next + 1
		end
		
		--欧盟国家
		mSleep(math.random(500, 700))
		if getColor(289,1106) == 0x7c160 and getColor(372,1107) == 0xffffff then
			mSleep(math.random(1000, 1700))
			randomsTap(289,1108,10)
			mSleep(math.random(1000, 1700))
			toast("下一步2",1)
			ys_next = ys_next + 1
		end
		
		mSleep(math.random(500, 700))
		if getColor(353,  287) == 0x10aeff and getColor(304, 1105) == 0x07c160 then
			toast("准备安全验证",1)
			mSleep(2000)
			break
		end
		
		if ys_next > 3 then
			mSleep(500)
			mSleep(math.random(500, 700))
			randomsTap(56, 81, 8)
			mSleep(math.random(500, 700))
			goto next_again
		else
			mSleep(1000)
			toast("隐私下一步："..ys_next,1)
			mSleep(6000)
		end
	end
	
	fz_bool = false
	tiaoma_bool = false
	phone_help = false
	fm_bool = false
	out_login = false
	send_fm_bool = false
	
	if fz_type == "5" then
		hk_url = self:get_hkUrl(country_num)
		regid = string.match(hk_url, '%d+_%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+%d+')
		hk_url = urlEncoder(hk_url)
		toast(hk_url,1)
		::put_work::
		header_send = {
		}
		body_send = string.format("key=%s&url=%s&tel=%s&area=%s&scanType=%s&regid=%s",fz_key, hk_url, phone, country_num,2,regid)
		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/tj", header_send, body_send, true)
		mSleep(1000)
		if status_resp == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.success then
				old = tmp.data.oId
				toast("滑块链接发布成功:"..old,1)
				mSleep(5000)
			else
				mSleep(500)
				toast("发布失败，6秒后重新发布",1)
				mSleep(6000)
				goto put_work
			end
		else
			goto put_work
		end
	elseif fz_type == "6" then
		hk_url = self:get_hkUrl(country_num)
		hk_url = urlEncoder(hk_url)
		toast(hk_url,1)
		::put_work::
		header_send = {
		}
		body_send = string.format("url=%s&mark=%s&merchant=%s",hk_url, phone, fz_key)
		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/create.action", header_send, body_send, true)
		mSleep(1000)
		if status_resp == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.code == "200" then
				order_sn = tmp.data.order_sn
				toast("滑块链接发布成功:"..order_sn,1)
				mSleep(5000)
			else
				mSleep(500)
				toast("发布失败，6秒后重新发布",1)
				mSleep(6000)
				goto put_work
			end
		else
			goto put_work
		end
	end
	
	--安全验证
	::get_pic::
	while (true) do
		mSleep(math.random(700, 900))
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if hk_way == "1" then
				mSleep(math.random(1000, 1500))
				randomsTap(372, 1105,10)
			end
			mSleep(math.random(1000, 1500))
			toast("安全验证=="..phone.."=="..country_num,1)
			mSleep(1000)
			randomsTap(372, 1105,10)
			mSleep(math.random(1000, 1500))
			break
		end
	end
	
	::hk::
	if hk_way == "0" then
		--滑块
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(118,  948) == 0x007aff then
				x_lens = self:moves()
				if tonumber(x_lens) > 0 then
					mSleep(math.random(500, 700))
					moveTowards( 108,  952, 0, x_len-75)
					mSleep(3000)
				else
					mSleep(math.random(500, 1000))
					randomsTap(689, 1032,10)
					mSleep(math.random(3000, 6000))
					goto get_pic
				end
				break
			end
			
			mSleep(math.random(700, 900))
			x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1000, 1500))
				randomsTap(372, 1105,10)
				mSleep(math.random(1000, 1500))
				toast("安全验证",1)
			end
		end
	end
	
	if fz_type == "0" then
		--二维码识别
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(132,  766) == 0x000000 then
				mSleep(math.random(500, 700))
				snapshot("1.png", 109,  691, 442, 1073)
				mSleep(math.random(1000, 1500))
				base_six_four = self:readFileBase64(userPath().."/res/1.png") 
				::ewm_go::
				token = "c97f4c3afad288a06d092df40ab77dc2"
				header_send = {
					typeget = "ios"
				}
				body_send = string.format("qr=%s&token=%s",base_six_four,token)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://sj.golddak.com/qr", header_send, body_send, true)
				mSleep(1000)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.status then
						ewm_url = tmp.url  
						toast(ewm_url,1)
						mSleep(1000)
						ewm_url_bool =  true
						break
					else
						mSleep(math.random(500, 700))
						randomsTap(54, 79, 5)
						mSleep(math.random(1000, 1500))
						erweima_bool = true
						goto erweima
					end
				else
					toast(body_resp,1)
					goto ewm_go
				end
				break
			end
			
			if hk_way == "0" then
				mSleep(math.random(500, 700))
				if getColor(118,  948) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomsTap(603, 1032,10)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end
		end
	elseif fz_type == "3" then
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(132, 766) == 0x000000 and getColor(54,648) == 0x808080 then
				mSleep(500)
				next_again_time = next_again_time + 1
				if next_again_time > 3 then
					mSleep(500)
					randomsTap(56,83,3)
					mSleep(500)
					while true do
						mSleep(math.random(500, 700))
						if getColor(79,88) == 0x2bb00 then
							mSleep(math.random(500, 700))
							randomsTap(79,88,3)
							mSleep(math.random(2000, 2700))
						end
						
						mSleep(math.random(500, 700))
						if getColor(561,1265) == 0x576b95 then
							mSleep(math.random(500, 700))
							randomsTap(542,1273,3)
							mSleep(math.random(500, 700))
						end
						
						mSleep(math.random(500, 700))
						if getColor(393,1170) == 0 then
							mSleep(math.random(500, 700))
							randomsTap(393,1170,3)
							mSleep(math.random(500, 700))
							toast("重新获取号码注册",1)
							mSleep(1000)
							out_login = true
							break
						end
					end
					next_again_time = 1
					next_again_time_bool = true
					if api_change == "4" then
						::addblack::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request("http://129.204.138.57:11223/api/Camel/addblack?token="..tokens.."&skey="..skey)
						mSleep(500)
						if code == 200 then
							tmp = json.decode(res)
							if tmp.Status == 200 then
								toast("跳马失败加黑手机号码",1)
								mSleep(1000)
							else
								goto addblack
							end
						end
					end
					
					toast("重新获取号码注册",1)
					mSleep(1000)
					if out_login then
						goto start
					else
						goto nexts
					end
				else
					mSleep(500)
					randomsTap(56,83,3)
					mSleep(500)
					toast("跳马失败："..next_again_time,time)
					goto next_again
				end
			end
			
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("短信界面",1)
				ewm_url_bool = true
				tiaoma_bool = true
				break
			end
			
			if hk_way == "0" then
				mSleep(math.random(500, 700))
				if getColor(118,  948) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomsTap(603, 1032,10)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end
		end
	elseif fz_type == "1" or fz_type == "2" or fz_type == "4" or fz_type == "5" or fz_type == "6" then
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(132,  766) == 0x000000 or getColor(256,  639) == 0x9ce6bf then
				mSleep(500)
				if fz_type == "1" then
					::put_work::
					header_send = {
					}
					body_send = string.format("userKey=%s&phone=%s&region=%s&receiveProvinceId=%s",fz_key, phone, country_num, fz_province)
					ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://ymka.ymassist.com/assist/api/order/submitPhone", header_send, body_send, true)
					mSleep(1000)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.success then
							toast("发布成功，等待20秒查询",1)
							mSleep(20000)
						else
							goto put_work
						end
					else
						goto put_work
					end
					
					::push_work::
					header_send = {
						typeget = "ios"
					}
					body_send = string.format("phone=%s&region=%s",phone,country_num)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://ymka.ymassist.com/assist/api/order/queryPhone", header_send, body_send, true)
					mSleep(1000)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.success then
							if tmp.object.status == 3 then
								ewm_url_bool = true
								fz_bool = true
								toast("辅助成功",1)
								mSleep(1200)
							elseif tmp.object.status == 2 then
								toast("辅助失败",1)
								mSleep(1000)
								goto over
							else
								toast(body_resp,1)
								mSleep(5000)
								goto push_work
							end
						else
							toast("查询辅助状态",1)
							mSleep(5000)
							goto push_work
						end
					else
						goto push_work
					end
				elseif fz_type == "2" then
					::put_work::
					header_send = {
					}
					body_send = string.format("merchant=%s&phone=%s&area=%s", fz_key, phone, country_num)

					ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/phone.action", header_send, body_send, true)
					mSleep(1000)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.code == "200" then
							toast("发布成功，20秒后开始查询",1)
							mSleep(20000)
						else
							goto put_work
						end
					else
						goto put_work
					end
					
					::push_work::
					header_send = {
					}
					body_send = string.format("merchant=%s&phone=%s",fz_key, phone)

					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/inquiry.action", header_send, body_send, true)
					
					mSleep(1000)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.data.status == 2 then
							ewm_url_bool = true
							fz_bool = true
							toast("辅助成功",1)
							mSleep(1000)
						elseif tmp.data.status == 1 then
							toast("等待辅助中："..tmp.message,1)
							mSleep(5000)
							goto push_work
						elseif tmp.data.status == 3 or tmp.data.status == 4 or tmp.data.status == 5 or tmp.data.status == 6 then
							mSleep(500)
							toast("辅助超时，失败了",1)
							mSleep(1000)
							goto over
						elseif tmp.data.status == 0 then
							toast("未接单",1)
							mSleep(5000)
							goto push_work
						end
					else
						goto push_work
					end
				elseif fz_type == "4" then
					::put_work::
					header_send = {
					}
					body_send = string.format("key=%s&tel=%s&area=%s", fz_key, phone, country_num)

					ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/phonetj", header_send, body_send, true)
					mSleep(1000)
					nLog(body_resp)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.success then
							id = tmp.data.id
							toast("发布成功，20秒后开始查询",1)
							mSleep(20000)
						else
							goto put_work
						end
					else
						goto put_work
					end
					
					::push_work::
					header_send = {
					}
					body_send = string.format("key=%s&id=%s", fz_key, id)

					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/phonecx", header_send, body_send, true)
					nLog(body_resp)
					mSleep(1000)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.success then
							if tmp.data.status == 3 then
								ewm_url_bool = true
								fz_bool = true
								toast("辅助成功",1)
								mSleep(1000)
							elseif tmp.data.status == 2 or tmp.data.status == 0 then
								toast("等待辅助中："..tmp.data.showString,1)
								mSleep(5000)
								goto push_work
							elseif tmp.data.status == 4 or tmp.data.status == 9 then
								mSleep(500)
								toast("辅助超时，失败了:"..tmp.data.showString,1)
								mSleep(1000)
								goto over
							else
								toast(tmp.data.showString,1)
								mSleep(5000)
								goto push_work
							end
						end
					else
						goto push_work
					end
				elseif fz_type == "5" or fz_type == "6" then
					time = os.time() + 310
					while true do
						mSleep(math.random(500, 700))
						x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
						if x~=-1 and y~=-1 then
							mSleep(math.random(500, 700))
							self:change_vpn()
							toast("返回注册流程",1)
							break
						end
						
						mSleep(500)
						if getColor(256,  639) == 0x9ce6bf then
							break
						end
						
						new_time = os.time()
						if new_time >= time then
							ewm_url_bool = false
							toast("辅助超时，进入标记失败订单",1)
							goto bj_fail
						end
					end
				end
				
				while true do
					mSleep(math.random(500, 700))
					x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						tap(x + 150, y)
						mSleep(math.random(1200, 1700))
						toast("返回注册流程",1)
					end
					
					mSleep(math.random(500, 700))
					x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						toast("辅助成功，短信界面",1)
						ewm_url_bool = true
						phone_help = true
						mSleep(1000)
						break
					end
					
					mSleep(math.random(500, 700))
					x, y = findMultiColorInRegionFuzzy(0,"136|3|0,-73|686|0x7c160,330|683|0x7c160,170|683|0xffffff,116|826|0x6ae56,205|815|0x6ae56",100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						toast("辅助成功，发码界面",1)
						mSleep(1000)
						ewm_url_bool = false
						fm_bool = true
						mSleep(1000)
						break
					end
				end
				break
			end
			
		end
		
		if fm_bool then
			while true do
				mSleep(math.random(500, 700))
				x, y = findMultiColorInRegionFuzzy(0,"136|3|0,-73|686|0x7c160,330|683|0x7c160,170|683|0xffffff,116|826|0x6ae56,205|815|0x6ae56",100, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					if api_change == "2" then
						local m = TSVersions()
						local a = ts.version()
						local API = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
						local Secret  = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"
						local tp = getDeviceType()
						if m <= "1.2.7" then
							dialog("请使用 v1.2.8 及其以上版本 TSLib",0)
							lua_exit()
						end

						if  tp >= 0  and tp <= 2 then
							if a <= "1.3.9" then
								dialog("请使用 iOS v1.4.0 及其以上版本 ts.so",0)
								lua_exit()
							end
						elseif  tp >= 3 and tp <= 4 then
							if a <= "1.1.0" then
								dialog("请使用安卓 v1.1.1 及其以上版本 ts.so",0)
								lua_exit()
							end
						end

						local code1,access_token = getAccessToken(API,Secret)
						if code1 then
							local content_name1 = userPath() .. "/res/baiduAI_content_name1.jpg"
							local content_name2 = userPath() .. "/res/baiduAI_content_name2.jpg"
							local phone_name = userPath() .. "/res/baiduAI_phone_name.jpg"
							--内容
							snapshot(content_name1, 21,592,98,649) 
							mSleep(100)
							snapshot(content_name2, 96,592,167,658) 
							mSleep(100)
							--号码
							snapshot(phone_name, 20,765,601,835)  
							local code2, body = baiduAI(access_token,content_name1)
							if code2 then
								local tmp = json.decode(body)
								for i=1,#tmp.words_result,1 do
									mSleep(200)
									content_num1 = string.lower(tmp.words_result[i].words)
								end
								if #content_num1 > 2 then
									content_num1 = string.sub(content_num1,1,2)
								end
								
							else
								dialog("识别失败\n" .. body,5)
								goto over
							end 
							
							local code2, body = baiduAI(access_token,content_name2)
							if code2 then
								local tmp = json.decode(body)
								for i=1,#tmp.words_result,1 do
									mSleep(200)
									content_num2 = string.lower(tmp.words_result[i].words)
									if #content_num2 > 2 then
										content_num2 = string.sub(content_num2,#content_num2 - 1,#content_num2)
									end
								end
							else
								dialog("识别失败\n" .. body,5)
								goto over
							end 
							
							local code2, body = baiduAI(access_token,phone_name)
							if code2 then
								local tmp = json.decode(body)
								for i=1,#tmp.words_result,1 do
									mSleep(200)
									phone_num = string.lower(tmp.words_result[i].words)
								end
							else
								dialog("识别失败\n" .. body,5)
								goto over
							end
						else
							dialog("识别失败\n" .. access_token,5)
							goto over
						end
						
						toast(phone_num.."\r\n"..content_num1.."\r\n"..content_num2,1)
						mSleep(1000)
						::send_message::
						mSleep(500)
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=sendCode&token="..phone_token.."&pid="..pid.."&receiver="..phone_num.."&smscontent="..content_num1..content_num2)
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								mSleep(10000)
								randomsTap(384,1131,6)
								mSleep(5000)
								toast("发送短信成功",1)
								mSleep(1000)
								send_fm_bool = true
							elseif data[1] == "0" then
								mSleep(500)
								if data[2] == "-3" then
									toast("接收号码不能为空",1)
									mSleep(1000)
									goto over
								elseif data[2] == "-4" then
									toast("提交短信不能为空",1)
									mSleep(1000)
									goto over
								elseif data[2] == "-10" then
									toast("发送内容不符合规则",1)
									mSleep(1000)
									goto over
								end
								toast("发送短信失败，重新发送",1)
								mSleep(1000)
								goto send_message
							end
						else
							toast("获取手机号码失败，重新获取",1)
							mSleep(1000)
							goto send_message
						end
					end
					ewm_url_bool = false
					country_id = "0"
					break
				end
			end
		end
	elseif fz_type == "7" then
		toast("手动上传辅助二维码",1)
		mSleep(20000)
		ewm_url_bool = true
	end
	
	::bj_fail::
	if ewm_url_bool then
		fz_success_bool = self:ewm(phone_help,skey,tiaoma_bool,fz_bool,fz_type,phone,phone_token,api_change,SMS_country,pid,pay_id,ewm_url,provinceId,tzid,getPhone_key,sumbit_key)
		if fz_type == "0" or fz_type == "1" or fz_type == "2" or fz_type == "5" or fz_type == "4" or fz_type == "6" then
			if fz_success_bool then
				toast("辅助成功",1)
				if fz_type == "5" then
					--标记订单
					::bj::
					local sz = require("sz");
					local http = require("szocket.http")
					local res, code = http.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=success")

					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							toast("订单标记："..tmp.data, 1)
							mSleep(3000)
						else
							toast("标记失败",1)
							mSleep(2000)
							goto bj
						end
					end
				elseif fz_type == "6" then
					::push_work::
					header_send = {
					}
					body_send = string.format("order_sn=%s&status=%s&merchant=%s",order_sn,"1",fz_key)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/change.action", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.code == "200" then
							toast("标记成功",1)
						else
							goto push_work
						end
					else
						goto push_work
					end
				end
			else
				if fz_type == "5" then
					--标记订单
					::bj::
					local sz = require("sz");
					local http = require("szocket.http")
					local res, code = http.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=fail")

					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							toast("订单标记："..tmp.data, 1)
							mSleep(3000)
						else
							toast("标记失败",1)
							mSleep(2000)
							goto bj
						end
					end
				elseif fz_type == "6" then
					::push_work::
					header_send = {
						typeget = "ios"
					}
					body_send = string.format("order_sn=%s&status=%s&merchant=%s",order_sn,"2",fz_key)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/change.action", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.code == "200" then
							toast("标记成功",1)
						else
							goto push_work
						end
					else
						goto push_work
					end
				end
				goto over
			end
		elseif fz_type == "3" then
			if fz_success_bool then
				toast("辅助成功",1)
			else
				mSleep(500)
				randomsTap(56,83,3)
				mSleep(500)
				while true do
					mSleep(math.random(500, 700))
					if getColor(79,88) == 0x2bb00 then
						mSleep(math.random(500, 700))
						randomsTap(79,88,3)
						mSleep(math.random(500, 700))
						break
					end
				end
				next_again_time_bool = true
				goto nexts
			end
		elseif fz_type == "7" then
			if fz_success_bool then
				toast("辅助成功",1)
			else
				goto over
			end
		end
	else
		if fz_type == "5" then
			--标记订单
			if send_fm_bool then
				::bj::
				local sz = require("sz");
				local http = require("szocket.http")
				local res, code = http.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=success")

				if code == 200 then
					tmp = json.decode(res)
					if tmp.success then
						toast("订单标记："..tmp.data, 1)
						mSleep(3000)
					else
						toast("标记失败",1)
						mSleep(2000)
						goto bj
					end
				end
			else
				goto over
			end
		elseif fz_type == "6" then
			if send_fm_bool then
				::push_work::
				header_send = {
					typeget = "ios"
				}
				body_send = string.format("order_sn=%s&status=%s&merchant=%s",order_sn,"1",fz_key)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/change.action", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.code == "200" then
						toast("标记成功",1)
					else
						goto push_work
					end
				else
					goto push_work
				end
			else
				goto over
			end
		else
			mSleep(500)
			if not fm_bool then
				mSleep(math.random(500, 700))
				randomsTap(54, 79, 5)
				mSleep(math.random(1000, 1500))
				erweima_bool = true
				toast(ewm_url,1)
				goto erweima
			end
		end
	end
	
	--欧盟国家输入昵称
	if country_id ~= "0" then
		mSleep(500)
		while true do
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x343434,"49|-24|0x343434,2|547|0x9de7bf,326|537|0x9de7bf", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(355,590,8)
				mSleep(math.random(500, 700))
				toast("昵称",1)
				break
			end
		end
		
		if nickName == "0" then  --符号
			mSleep(math.random(500, 700))
			randomsTap(48, 1284, 5)
			mSleep(math.random(1000, 1500))
			randomsTap(635,1072,6)
		elseif nickName == "1" then  --中文
			State={
				["随机常量"] = 0,
				["姓氏"]="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
				"姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍" ..
				"史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾" ..
				"孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈" ..
				"项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡" ..
				"田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸" ..
				"左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄曲家封芮羿储靳汲邴糜松井" ..
				"段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎" ..
				"祖武符刘景詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲邰从鄂索咸籍赖卓蔺屠" ..
				"蒙池乔阴鬱胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛" ..
				"寿通边扈燕冀郟浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈" ..
				"廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂" ..
				"晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权" ..
				"逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台" ..
				"公冶宗政濮阳淳于单于太叔申屠公孙仲孙轩辕令狐钟离宇文长孙慕容鲜" ..
				"于闾丘司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良" ..
				"拓拔夹谷宰父谷粱晋楚闫法汝鄢涂钦段干百里东郭南门呼延归海羊舌微" ..
				"生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱" ..
				"阳佟第五言福百家姓终",
				["名字"]="安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
				"濮存罡禄瑛瑛嗣嫚朵寅添渟黎臻舞绢城骥彰渺禾教祖剑黎莞咸浓芦澹帅臻渟添禾亭添亭霖深策臻稷辞" ..
				"悟悟澄涉城鸥黎悟乔恒黎鲲涉莞霖甲深婕乔程澹男岳深涉益澹悟箫乔多职适芦瑛澄婕朵适祖霖瑛坤嫚" ..
				"涉男珂箫芦黎珹绢芦程识嗣珂瑰枝允黎庸嗣赐罡纵添禄霖男延甲彰咸稷箫岳悟职祖恒珂庸琅男莞庸浓" ..
				"多罡延瑛濮存爵添剑益骥澄延迪寅婕程霖识瑰识程群教朵悟舞岳浓箫城适程禾嫚罡咸职铃爵渺添辞嫚" ..
				"浓寅鲲嗣瑛鸥多教瑛迪坤铃珹群黎益澄程莞深坤澹禄职澹赩澄藉群箫骥定彰寅臻渟枝允珹深群黎甲鲲" ..
				"亭黎藏浓涤渟莞寅辞嗣坤迪嫚添策庸策藉瑰彰箫益莞渺乔彰延舞祖婕澹渺鸥纵嗣瑛藏濮存婕职程芦群" ..
				"禾嫚程辞祖黎职浓桦藏渟禾彰帅辞铃铃黎允绢濮存剑辞禾瑰添延添悟赐祖咸莞男绢策婕藉禾浓珹涤祖" ..
				"汉骥舞瑛多稷赐莞渟黎舞桦黎群藏渺黎坤桦咸迪澈舞允稷咸剑定亭澄濮存鲲臻全鸥多赐程添瑛亭帅悟" ..
				"甲男帅涤适纵渟鲲亭悟琅亭添允舞禾庸咸瑛教鲲允箫芦允瑛咸鸥帅悟延珂黎珹箫爵剑霖剑霖禄鸥悟涉" ..
				"彰群悟辞帅渺莞澄桦瑛适臻益霖珹亭澹辞坤程嗣铃箫策澈枝赐莞爵渟禄群枝添芦群浓赐职益城澄赩琅" ..
				"延群乔珹鲲祖群悟黎定庸澄芦延霖罡鲲咸渺纵亭禄鸥赩涤剑澹藏纵濮存澄芦剑延瑰稷黎益赩澄允悟澈" ..
				"甲嗣绢朵益甲悟涤婕群咸臻箫鲲寅鸥桦益珂舞允庸芦藉寅渺咸赐澄程剑瑰霖瑰铃帅男铃悟识瑰仕仕城" ..
				"允莞全朵涤铃剑渺稷剑珂铃箫全仕益纵芦桦珂濮存城朵朵咸程剑澄定澈爵寅庸定莞瑛教彰黎箫仕黎桦" ..
				"赩深赩爵迪悟珹涤琅添箫桦帅瑛黎黎策识寅嫚涉迪策汉舞定彰允男祖教澄群瑛濮存男禾教莞禾鸥澈濮" ..
				"存岳城嫚深舞教岳澄亭禾坤朵亭职莞稷寅瑰城庸亭舞禾瑛恒坤浓彰莞澄澈鸥臻稷教琅辞益剑藉黎添瑛" ..
				"延舞坤仕岳多婕骥迪帅黎悟全澄识益甲桦纵适罡彰澄禾婕程黎城涤浓枝箫咸渟岳渟澹臻珹识珹澄箫辞" ..
				"浓鲲识悟允悟禾识群祖迪渟鲲群庸莞珹悟澹瑰悟鸥汉群甲莞庸职琅莞桦鲲朵深乔辞允彰渺朵瑰亭瑰朵" ..
				"定深男识群职霖益男舞城允舞爵赩枝罡罡群澹芦藉爵悟渟澹禾多庸箫坤乔芦甲濮存多渟藉珹赐汉纵亭" ..
				"禾城枝剑露以玉春飞慧娜悠亦元晔曜霜宁桃彦仪雨琴青筠逸曼代菀孤昆秋蕊语莺丝红羲盛静南淑震晴" ..
				"彭祯山霞凝柔隽松翠高骊雅念皓双洛紫瑞英思歆蓉娟波芸荷笑云若宏夏妍嘉彩如鹏寄芝柳凌莹蝶舒恬" ..
				"虹清爽月巧乾勋翰芳罗刚鸿运枫阳葳杰怀悦凡哲瑶凯然尚丹奇弘顺依雪菡君畅白振馨寻涵问洁辉忆傲" ..
				"伟经润志华兰芹修晨木宛俊博韶天锐溪燕家沈放明光千永溶昊梅巍真尔馥莲怜惜佳广香宇槐珺芷帆秀" ..
				"理柏书沛琪仙之竹向卉欣旻晓冬幻和雁淳浩歌荣懿文幼岚昕牧绿轩工旭颜醉玑卓觅叶夜灵胜晗恨流佁" ..
				"乐火音采睿翎萱民画梦寒泽怡丽心石邵玮佑旺壮名一学谷韵宜冰赫新蕾美晖项琳平树又炳骏气海毅敬" ..
				"曦婉爰伯珊影鲸容晶婷林子昌梧芙澍诗星冉初映善越原茂国腾孟水烟半峯莉绮德慈敏才戈梓景智盼霁" ..
				"琇苗熙姝从谊风发钰玛忍婀菲昶可荌小倩妙涛姗方图迎惠晤宣康娅玟奕锦濯穆禧伶丰良祺珍曲喆扬拔" ..
				"驰绣烁叡长雯颖辰慕承远彬斯薇成聪爱朋萦田致世实愫进瀚朝强铭煦朗精艺熹建忻晏冷佩东古坚滨菱" ..
				"囡银咏正儿瑜宝蔓端蓓芬碧人开珠昂琬洋璠桐舟姣琛亮煊信今年庄淼沙黛烨楠桂斐胤骄兴尘河晋卿易" ..
				"愉蕴雄访湛蓝媛骞娴儒妮旋友娇泰基礼芮羽妞意翔岑苑暖玥尧璇阔燎偲靖行瑾资漪晟冠同齐复吉豆唱" ..
				"韫素盈密富其翮熠绍澎淡韦诚滢知鹍苒抒艳义婧闳琦壤杨芃洲阵璟茵驹涆来捷嫒圣吟恺璞西旎俨颂灿" ..
				"情玄利痴蕙力潍听磊宸笛中好任轶玲螺郁畴会暄峻略琼琰默池温炫季雰司杉觉维饮湉许宵茉贤昱蕤珑" ..
				"锋纬渊超萍嫔大霏楚通邈飙霓谧令厚本邃合宾沉昭峰业豪达彗纳飒壁施欢姮甫湘漾闲恩莎祥启煜鸣品" ..
				"希融野化钊仲蔚生攸能衍菁迈望起微鹤荫靓娥泓金琨筱赞典勇斌媚寿喜飇濡宕茜魁立裕弼翼央莘绚焱" ..
				"奥萝米衣森荃航璧为跃蒙庆琲倚穹武甜璐俏茹悌格穰皛璎龙材湃农福旷童亘苇范寰瓃忠虎颐蓄霈言禹" ..
				"章花健炎籁暮升葛贞侠专懋澜量纶布皎源耀鸾慨曾优栋妃游乃用路余珉藻耘军芊日赡勃卫载时三闵姿" ..
				"麦瑗泉郎怿惬萌照夫鑫樱琭钧掣芫侬丁育浦磬献苓翱雍婵阑女北未陶干自作伦珧溥桀州荏举杏茗洽焕" ..
				"吹甘硕赋漠颀妤诺展俐朔菊秉苍津空洮济尹周江荡简莱榆贝萧艾仁漫锟谨魄蔼豫纯翊堂嫣誉邦果暎珏" ..
				"临勤墨薄颉棠羡浚兆环铄"
			}
			State["随机常量"] = tonumber(self:Rnd_Word("0123456789",5))

			Nickname = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],2,3)
			mSleep(math.random(500, 700))
			inputStr(Nickname)
			mSleep(math.random(500, 700))

		elseif nickName == "2" then  --英文
			for var= 1, 8 do
				num = math.random(1, 26) 
				mSleep(math.random(500, 700))
				if num > 0 and num < 11 then
					randomsTap(37+(num-1)*80,  967,8)
				elseif num > 10 and num < 20 then
					randomsTap(73+(num-11)*80, 1073,8)
				elseif num > 19 and num < 27 then
					randomsTap(147+(num-20)*80, 1179,8)
				end
				mSleep(math.random(500, 700))
			end

		elseif nickName == "3" then  --数字
			Nickname = tmp.number
			nickname = string.sub(Nickname,5,#Nickname)
			mSleep(math.random(500, 700))
			randomsTap(49, 1283,8)
			mSleep(math.random(500, 700))
			for i = 1, #nickname do
				mSleep(math.random(500, 700))
				num = string.sub(nickname,i,i)
				if num == "0" then
					randomsTap(713,  965, 8)
				elseif num == "1" then
					randomsTap(38,  964, 8)
				elseif num == "2" then
					randomsTap(112,  965, 8)
				elseif num == "3" then
					randomsTap(185,  965, 8)
				elseif num == "4" then
					randomsTap(264,  963, 8)
				elseif num == "5" then
					randomsTap(338,  964, 8)
				elseif num == "6" then
					randomsTap(414,  962, 8)
				elseif num == "7" then
					randomsTap(495,  964, 8)
				elseif num == "8" then
					randomsTap(566,  966, 8)
				elseif num == "9" then
					randomsTap(642,  961, 8)
				end
			end
		
		elseif nickName == "4" then  --RFG
			mSleep(math.random(500, 700))
			inputStr("Really fun game")
			
		elseif nickName == "5" then  --特殊符号
			mSleep(math.random(500, 700))
			inputStr("르㸏مฬ้๊سمرًς.έل")
			
		end
		
		mSleep(math.random(500, 700))
		randomsTap(369,740,8)
		mSleep(math.random(500, 700))
		
		while true do
			--填写生日
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0,"49|-16|0,-5|344|0x9ed99d,365|339|0x9ed99d", 100, 0, 0, 749, 800)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1000, 1700))
				randomsTap(384,447,8)
				mSleep(math.random(500, 700))
				toast("点击生日",1)
			end
			
			mSleep(math.random(500, 700))
			if getColor(701,813) == 0x1aad19 then
				mSleep(math.random(1000, 1700))
				randomsTap(685,813,3)
				mSleep(math.random(500, 700))
				toast("确定",1)
			end
			
			mSleep(math.random(500, 700))
			if getColor(276,660) == 0x1aad19 then
				mSleep(math.random(1000, 1700))
				randomsTap(378,659,8)
				mSleep(math.random(500, 700))
				toast("下一步",1)
				break
			end
		end
	end
	
	not_get_code = 0
	while (true) do
		--通讯录匹配
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|13|0x576b95,14|-4|0x576b95,14|6|0x576b95,18|18|0x576b95", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			toast("通讯录匹配,等待8秒",1)
			break
		end
		
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			toast("通讯录匹配,等待8秒",1)
			break
		end
		
		--不是我的，继续注册
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x6ae56,"38|-2|0x6ae56,136|6|0x6ae56,182|-5|0x6ae56,261|-7|0x6ae56,290|-5|0x6ae56,-131|-11|0xf2f2f2,433|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(375,782,8)
			mSleep(math.random(500, 700))
			toast("不是我的，继续注册",1)
		end
		
		mSleep(math.random(500, 700))
		if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
			toast("封号1",1)
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
			toast("封号2",1)
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			toast("账号状态异常",1)
			break
		end
		
		mSleep(math.random(500,700))
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-27|-1|0x576b95,-261|-189|0,-225|-188|0,173|-182|0,-218|219|0x36030,158|207|0x36030", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,8)
			mSleep(math.random(1500, 2700))
			randomsTap(384,1131,6)
			mSleep(4000)
			not_get_code = not_get_code + 1
			if not_get_code > 2 then
				goto over
			else
				toast("尚未收到短信"..not_get_code,1)
			end
		end
	end
	mSleep(12000)
	error_bool = false
	get_wechatError_six = false
	while (true) do
		--通讯录匹配
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|13|0x576b95,14|-4|0x576b95,14|6|0x576b95,18|18|0x576b95", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			get_six_two = true
			toast("账号存活",1)
			break
		end
		
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			get_six_two = true
			toast("账号存活",1)
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
			mSleep(500)
			randomsTap(362,797,4)
			mSleep(500)
			toast("封号1",1)
			error_bool = true
			get_wechatError_six = true
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
			mSleep(500)
			randomsTap(362,797,4)
			mSleep(500)
			toast("封号2",1)
			error_bool = true
			get_wechatError_six = true
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			mSleep(500)
			randomsTap(362,797,4)
			mSleep(500)
			toast("账号状态异常",1)
			error_bool = true
			get_wechatError_six = true
			break
		end
	end
	
	if get_six_two or get_wechatError_six then
		function getData()  ----单线程提取
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
							for i = 3 ,5 do
								if tonumber(v[i]) then
									wx = v[i]
									wxid = v[i-1]
									break
								end	
							end	
						end	
					end	
					--dialog(wxid.."\r\n"..wx, time)
					nLog(Wildcard[var])
					local str = file:read("*a")
					file:close()
					require"sz"
					local str = string.tohex(str) --16进制编码
					return str
				end 
			end 
		end
		
		function _追加写入(path,nr1,nr2,nr3,nr4,nr5,nr6,nr7)     ---以追加的方式写入文本，path是路径，nr是要写入的内容，自动换行
			local path = userPath().."/res/"..path
			if nr1 == nil then
				dialog("没有要存入的内容", time)
			end	
			local nr2 = nr2 or ""
			local nr3 = nr3 or ""
			local nr4 = nr4 or ""
			local nr5 = nr5 or ""
			local nr6 = nr6 or ""
			local nr7 = nr7 or ""
			local 文件句柄 = io.open(path,"a")
			local 文件 = 文件句柄:write(nr1,nr2,nr3,nr4,nr5,nr6,nr7)   
			local 文件 = 文件句柄:write("\n")   
			文件句柄:close()
			local 文件句柄 = io.open(path,"r")
			local 文件 = 文件句柄:read("*all")
			toast(文件,5)
			文件句柄:close()
		end
		
		function _自定义提取62数据流程()
			local data = getData()
			if data then
				if wx_id == "提取wx_id" then
					_追加写入("备用读取62数据.txt",wxid,"----",data)
					mSleep(math.random(1000, 1500))
					toast("提取成功！",1)
				else
					_追加写入("备用读取62数据.txt",wx,"----",data)
					mSleep(math.random(1000, 1500))
					toast("提取成功！",1)
				end	
			else
				dialog("提取失败！", 1)
			end	
			local ts = require("ts")
			time = getNetTime()    
			now = os.date("%Y年%m月%d日%H点%M分%S秒",time) 
			mSleep(math.random(500, 700))
			if get_wechatError_six then
				toast("写入异常数据",1)
				all_data = wx.."----"..password.."----"..data.."======MiaoFeng"
	--			dialog(all_data,0)
				status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSprite/res/秒封62数据") --新建文件夹
				writeFileString(userPath().."/res/秒封62数据/62数据wxid.txt",wxid.."----"..password.."----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				writeFileString(userPath().."/res/秒封62数据/62数据手机号.txt",all_data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				mSleep(1000)
			else
				toast("写入正常数据",1)
				all_data = wx.."----"..password.."----"..data
	--			dialog(all_data,0)
				status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSprite/res/62数据") --新建文件夹
				writeFileString(userPath().."/res/62数据/62数据wxid.txt",wxid.."----"..password.."----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				writeFileString(userPath().."/res/62数据/62数据手机号.txt",all_data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				mSleep(1000)
			end
			::send::
			local sz = require("sz")       
			local http = require("szocket.http")
			local res, code = http.request("http://47.104.246.33/account.php?time="..time.."&info="..all_data)

			if code == 200 then
				mSleep(500)
				toast("数据上传"..res,1)
				mSleep(1000)
			else
				toast("重新上传",1)
				mSleep(1000)
				goto send
			end
		end
		
		_自定义提取62数据流程(get_wechatError_six)
		get_six_two = false
		if login_times == "1" then
			account_len = account_len + 1
			if account_len == tonumber(login_times_set) then
				toast(login_times_set.."个注册完成",1)
				goto over
			else
				toast("第"..account_len.."个注册完成",1)
				mSleep(500)
				if not get_wechatError_six then
					while true do
						mSleep(math.random(500, 700))
						x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 749, 1333)
						if x~=-1 and y~=-1 then
							mSleep(500)
							randomsTap(x,y,5)
							mSleep(500)
						end
						
						mSleep(math.random(500, 700))
						if getColor(363,813) == 0x576b95 and getColor(382,820) == 0x576b95 then
							mSleep(500)
							randomsTap(363,813,4)
							mSleep(500)
						end
						
						mSleep(500)
						if getColor(654,1279) == 0x7c160 then
							mSleep(500)
							randomTap(353,1030,2)
							mSleep(1000)
							toast("我的",1)
							break
						else
							mSleep(500)
							randomTap(654,1279,2)
							mSleep(500)
						end
						
						mSleep(math.random(500, 700))
						if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
							mSleep(500)
							randomsTap(362,797,4)
							mSleep(500)
							toast("封号1,超过判断12秒时间，账号写入正常列表",1)
							goto fh
						end
						
						mSleep(math.random(500, 700))
						if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
							mSleep(500)
							randomsTap(362,797,4)
							mSleep(500)
							toast("封号2,超过判断12秒时间，账号写入正常列表",1)
							goto fh
						end
						
						mSleep(math.random(500, 700))
						if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
							mSleep(500)
							randomsTap(362,797,4)
							mSleep(500)
							toast("账号状态异常,超过判断12秒时间，账号写入正常列表",1)
							goto fh
						end
						
					end
					
					while true do
						mSleep(500)
						if getColor(356,1167) == 0x191919 then
							mSleep(500)
							tap(356,1167)
							mSleep(500)
						end
						
						mSleep(500)
						if getColor(356,1172) == 0xe64340 then
							mSleep(500)
							tap(356,1172)
							mSleep(500)
							break
						end
						
					end
					get_wechatError_six = false
				end
				
				::fh::
				while true do
					mSleep(math.random(500, 700))
					if getColor(561,1265) == 0x576b95 then
						mSleep(math.random(500, 700))
						randomsTap(542,1273,3)
						mSleep(math.random(500, 700))
					end
					
					if getColor(393,1170) == 0 then
						mSleep(math.random(500, 700))
						randomsTap(393,1170,3)
						mSleep(math.random(500, 700))
						break
					end
				end
				next_again_time_bool = true
				goto start
			end
		end
	end
	
	::over::
	if fz_type == "5" then
		::check::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://www.tvnxl.com/xd/cx?key="..fz_key.."&oId="..old)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.success then
				if tmp.data.sts == 4 then
					wjd_bool = true
				else
					wjd_bool = false
				end
			else
				mSleep(2000)
				goto check
			end
		end
			
		--标记订单
		if not send_fm_bool and not ewm_url_bool and not wjd_bool then
			::bj::
			local sz = require("sz");
			local http = require("szocket.http")
			local res, code = http.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=fail")
			if code == 200 then
				tmp = json.decode(res)
				if tmp.success then
					toast("订单标记："..tmp.data, 1)
					mSleep(3000)
				else
					toast("标记失败",1)
					mSleep(2000)
					goto bj
				end
			end
		end
	elseif fz_type == "6" then
		::check::
		header_send = {
		}
		body_send = string.format("order_sn=%s&merchant=%s",order_sn,fz_key)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/query.action", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.code == "200" then
				if tmp.data.status == 4 then
					wjd_bool = true
				else
					wjd_bool = false
				end
			else
				mSleep(2000)
				goto check
			end
		else
			mSleep(2000)
			goto check
		end
			
		if not send_fm_bool and not ewm_url_bool and not wjd_bool then
			::push_work::
			header_send = {
			}
			body_send = string.format("order_sn=%s&status=%s&merchant=%s",order_sn,"2",fz_key)
			ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
			status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/change.action", header_send, body_send, true)
			if status_resp == 200 then
				local tmp = json.decode(body_resp)
				if tmp.code == "200" then
					toast("标记成功",1)
				else
					toast("标记失败",1)
					mSleep(2000)
					goto push_work
				end
			else
				toast("标记失败",1)
				mSleep(2000)
				goto push_work
			end
		end
	end
	setVPNEnable(false)
end


function model:main()
	local w,h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 100,
		views = {
			{
				["type"] = "Label",
				["text"] = "注册脚本",
				["size"] = 25,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "选择注册次数",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "单次,多次",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入注册次数",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择微信版本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "7.0.3,7.0.7",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择滑块方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "脚本,手动",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择辅助平台",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",       
				["list"] = "二维码辅助,go下单,蚂蚁手机辅助,跳马注册,fz,showdoc滑块辅助,蚂蚁滑块辅助,手动辅助",
				["select"] = "0",  
				["countperline"] = "3",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入手机号辅助key",
				["text"] = "默认值",       
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入手机号辅助省份",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择接码平台",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "自己服务器,SMS,奥迪,卡农,香蕉,柠檬,东帝汶",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "SMS/香蕉国家代码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入SMS/香蕉/柠檬的国家代码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "奥迪,卡农,香蕉,柠檬,东帝汶设置",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入奥迪/卡农/香蕉/柠檬/东帝汶的账号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入奥迪/卡农/香蕉/柠檬的密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入奥迪/卡农/香蕉的项目id",
				["text"] = "默认值",       
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入奥迪/卡农/香蕉/柠檬的号码区号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Label",
				["text"] = "设置国家",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "乌克兰,英国,波兰",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设置昵称",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "符号,中文,英文,数字,RFG,特殊符号",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设置密码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "3+5,4+4",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设置辅助订单省份",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要的省份编号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置接码平台key(／东帝汶)",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的接码平台key(／东帝汶)",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置辅助平台key",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的辅助平台key",
				["text"] = "默认值",       
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, login_times, login_times_set, wc_version, hk_way, fz_type, fz_key, fz_province, api_change, SMS_country, username, user_pass, work_id, phone_country, country_id, nickName, password, provinceId, getPhone_key, sumbit_key = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
	
	if fz_type == "1" then
		if fz_key == "" or fz_key == "默认值" then
			dialog("设置正确的辅助key", 3)
			lua_restart()
		end
		if fz_province == "" or fz_province == "默认值" then
			dialog("设置正确的辅助省份", 3)
			lua_restart()
		end
	end
	
	if api_change == "1" then
		if SMS_country == "" or SMS_country == "默认值" then
			dialog("设置正确的SMS国家代码", 3)
			lua_restart()
		end
	end
	
	if api_change == "2" or api_change == "3" then
		if username == "" or username == "默认值" then
			dialog("账号不能为空", 3)
			lua_restart()
		end
		if user_pass == "" or user_pass == "默认值" then
			dialog("密码不能为空", 3)
			lua_restart()
		end
		if work_id == "" or work_id == "默认值" then
			dialog("项目id不能为空", 3)
			lua_restart()
		end
	end
	
	if password == "" or password == "默认值" then
		dialog("密码不能为空，请重新运行脚本设置密码", 3)
		lua_restart()
	end
	
	if getPhone_key == "" or getPhone_key == "默认值" then
		dialog("接码key不能为空，请设置key", 3)
		lua_restart()
	end
	
	if sumbit_key == "" or sumbit_key == "默认值" then
		dialog("辅助key不能为空，请设置key", 3)
		lua_restart()
	end
	
	if api_change == "2" then
		::get_token::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=login&ApiName="..username.."&PassWord="..user_pass)
		if code == 200 then
			data = strSplit(res,"|")
			if data[1] == "1" then
				phone_token = data[2]
				toast(phone_token,1)
			else
				goto get_token
			end
		else
			goto get_token
		end
	end
	
	get_six_two = false
	while true do
		self:clear_App()
		self:wchat(login_times,login_times_set,skey,wc_version,hk_way,fz_key, fz_type, phone, country_num, phone_token, api_change, SMS_country, username, user_pass, work_id, phone_country, country_id,nickName,password,provinceId,getPhone_key, sumbit_key)
		mSleep(1000)
	end
end

model:main()