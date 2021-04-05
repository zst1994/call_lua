--wechat version 7.0.7
require "TSLib"
require "tsnet"
local sz                = require("sz")       
local http              = require("szocket.http")
local image 			= require("tsimg")  
local ts 				= require('ts')
local json 				= ts.json
local model 			= {}

model.awz_bid 			= "AWZ"
model.axj_bid 			= "YOY"
model.wc_bid 			= "com.tencent.xin"
model.phoneDevice       = ""

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
	mSleep(200)
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
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333)
		if type(point) == "table"  and #point ~=0  then
			mSleep(200)
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
	mSleep(200)
	runApp("com.liguangming.Shadowrocket")
	while true do
		mSleep(200)
		if getColor(547,101) == 0x2473bd then
			mSleep(500)
			tap(365,670)
			mSleep(2000)
			setVPNEnable(true)
			mSleep(5000)
			runApp(self.wc_bid)
			mSleep(1000)
			break
		end

		mSleep(200)
		if getColor(547,101) == 0x4386c5 then
			mSleep(500)
			tap(365,710)
			mSleep(2000)
			setVPNEnable(true)
			mSleep(5000)
			runApp(self.wc_bid)
			mSleep(1000)
			break
		end
	end
end

function model:change_GNvpn()
	mSleep(200)
	runApp("com.liguangming.Shadowrocket")
	while true do
		mSleep(200)
		if getColor(547,101) == 0x2473bd then
			mSleep(500)
			tap(365,579)
			mSleep(3000)
			runApp(self.wc_bid)
			mSleep(1000)
			break
		end

		mSleep(200)
		if getColor(547,101) == 0x4386c5 then
			mSleep(500)
			tap(365,630)
			mSleep(3000)
			runApp(self.wc_bid)
			mSleep(1000)
			break
		end
	end
end

function model:changeGWIP(ip_userName,ip_country)
	while true do
		mSleep(200)
		list = readFile(userPath().."/res/phone_num.txt")
		toast(list[1],1)
		mSleep(100)
		status_resp, header_resp,body_resp = ts.httpGet("http://refresh.rola-ip.co/refresh?user="..ip_userName..tonumber(list[1]).."&country="..ip_country)
		toast(body_resp,1)
		if status_resp == 200 then--打开网站成功
			local 返回号 = json.decode(body_resp)["Ret"]
			if 返回号 == "SUCCESS" then
				mSleep(200)
				toast(body_resp)
				mSleep(1000)
				break
			else
				toast("获取失败"..json.decode(body_resp)["Msg"])
				mSleep(2000)
			end
		else
			toast("打开网站失败等待2秒")
			mSleep(3000)
		end

		if (status_resp==502) then--打开网站失败
			toast("打开网站失败等待3秒")
			mSleep(3000)
		end
	end
end

function model:changeGNIP(ip_userName,place_id,iptimes)
	while true do
		mSleep(200)
		list = readFile(userPath().."/res/phone_num.txt")
		toast(list[1],1)
		mSleep(100)
		status_resp, header_resp,body_resp = ts.httpGet("http://refresh.come-ip.site/refresh?token=4bf88e14&time="..iptimes.."&protocol=socks5&isp=0&user="..ip_userName..tonumber(list[1]).."&province="..place_id)
		if (status_resp==200) then--打开网站成功
			local 返回号=json.decode(body_resp)["Msg"]
			if (返回号=="成功") then
				mSleep(200)
				toast(body_resp)
				mSleep(1000)
				break
			else
				toast("获取失败"..json.decode(body_resp)["Msg"])
				mSleep(2000)
			end
		else
			toast("打开网站失败等待2秒")
			mSleep(3000)
		end

		if (status_resp==502) then--打开网站失败
			toast("打开网站失败等待3秒")
			mSleep(3000)
		end
	end
end

function model:service_GWvpn()
	mSleep(200)
	toast("更换国外vpn")
	mSleep(1000)
	r = runApp("com.apple.Preferences");    --运行设置
	mSleep(2000)
	setVPNEnable(false); --关闭VPN
	mSleep(500)
	while true do
		toast("寻找vpn")
		mSleep(200)
		local tab = {
			"e0000fc0007f8000fe0001fc0003f80007f0000f0000300000000030001f000fe007f001fc00fe007f000fc000e000000000000000000000000fffffffffffffffe0060e0060e0060e0060e0060e0060e0060e0060600e0701c03c3c03ff800ff0001000000000000000000fffffffffffffff7c0001e0000f00007c0001e0000f80003c0001e0000780003c0001f0000700003fffffffffffffff$vpn$414$20$62",
		}
		local index = addTSOcrDictEx(tab)
		x, y = tsFindText(index, "vpn", 0,  447, 722, 1293, "262626 , 272727", 98)
		mSleep(200)
		if x == -1 then 
		else
			mSleep(100)
			tap(x,  y,230) --点击跳辅助成功
		end

		mSleep(200)
		local tab = {
			"01fff01fff003800060000c0001c000180001800018000000000000000ff003ff007ff00f0000e0001c000180001800018000180001c0000e0000f00007ff003ff000ff000000000000000000ff001ff007ff00f0000e0001c000180001800018000180001c0000e0000f00007000030000000000000000000000ffffffffff0003e00018000380007c000fe001cf003870070100e0001c00018000000000000000000007f001ff007ff00f1800c1801c180181801818018180181801c1800e1800798003f8001f80000000000000000180001800018001ffff1ffff1ffff01800018000180000800$国外$427$20$93",
		}
		local index = addTSOcrDictEx(tab)
		x, y = tsFindText(index, "国外", 1,  131, 739, 1092, "262626 , 272727", 98)
		mSleep(200)
		if x == -1 then 
		else
			mSleep(100)
			tap(x,  y,230) --点击跳辅助成功
			mSleep(500)
--			setVPNEnable(true); --打开VPN
--			mSleep(3000)
--			r = runApp("com.tencent.xin");    --运行微信
			mSleep(2500)
			break;
		end
	end
end

function model:service_GNvpn()
	mSleep(200)
	toast("更换国内vpn")
	mSleep(1000)
	r = runApp("com.apple.Preferences");    --运行设置
	mSleep(2000)
	setVPNEnable(false); --关闭VPN
	mSleep(500)
	while true do
		toast("寻找vpn")
		mSleep(200)
		local tab = {
			"e0000fc0007f8000fe0001fc0003f80007f0000f0000300000000030001f000fe007f001fc00fe007f000fc000e000000000000000000000000fffffffffffffffe0060e0060e0060e0060e0060e0060e0060e0060600e0701c03c3c03ff800ff0001000000000000000000fffffffffffffff7c0001e0000f00007c0001e0000f80003c0001e0000780003c0001f0000700003fffffffffffffff$vpn$414$20$62",
		}
		local index = addTSOcrDictEx(tab)
		x, y = tsFindText(index, "vpn", 0,  447, 722, 1293, "262626 , 272727", 98)
		mSleep(200)
		if x == -1 then 
		else
			mSleep(100)
			tap(x,  y,230) 
		end

		local tab = {
			"3ffff3ffff300003000030000300003180031830318303183031830318303183031fff31fff31830318303183031833318333183031800300003000030000300003ffff3ffff0000000000000000000000000000000000003fff03fff030000300003000030000300103003030070300f0303c033f87ffe0fffe043070030380301c0300e03007030030300103000030000300003fff03fff$国内$367$20$61",
		}
		local index = addTSOcrDictEx(tab)
		x, y = tsFindText(index, "国内", 1,  131, 739, 1092, "262626 , 272727", 98)
		if x == -1 then 
		else
			mSleep(100)
			tap(x,  y,230) 
			mSleep(1000)
--			setVPNEnable(true); --打开VPN
--			mSleep(3000)
--			r = runApp("com.tencent.xin");    --运行微信
			mSleep(2500)
			break;
		end
	end
end


function model:vpn()
	mSleep(200)
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(math.random(2000, 2500))
--	old_data = getNetIP() --获取IP  
--	toast(old_data,1)

	::get_vpn::
	mSleep(200)
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态",1)
		setVPNEnable(false)
		for var= 1, 10 do
			mSleep(200)
			toast("等待vpn切换"..var,1)
			mSleep(math.random(500, 700))
		end
		goto get_vpn
	else
		toast("关闭状态",1)
		mSleep(1000)
	end

	setVPNEnable(true)
	mSleep(1000*5)

	header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60) 
	code,header_resp, body_resp = ts.httpsGet("http://myip.ipip.net/", header_send,body_send)
	if code == 200 then
		return body_resp
-- 	else
-- 		toast("请求ip位置失败："..tostring(body_resp),1)
-- 		mSleep(1000)
-- 		setVPNEnable(false)
-- 		mSleep(math.random(2000, 2500))
-- 		self:changeGWIP(ip_userName,ip_country)
-- 		mSleep(1000)
-- 		goto get_vpn
	end

--	new_data = getNetIP() --获取IP 
--	toast(new_data,1)
--	if new_data == old_data then
--		toast("vpn切换失败",1)
--		mSleep(math.random(500, 700))
--		setVPNEnable(false)
--		mSleep(math.random(500, 700))
--		x,y = findMultiColorInRegionFuzzy( 0x007aff, "3|15|0x007aff,19|10|0x007aff,-50|-128|0x000000,-34|-147|0x000000,3|-127|0x000000,37|-132|0x000000,59|-135|0x000000", 90, 0, 0, 749, 1333)
--		if x~=-1 and y~=-1 then
--			mSleep(math.random(500, 700))
--			randomTap(x,y,10)
--			mSleep(math.random(500, 700))
--			toast("vpn连接失败1",1)
--		end

--		--好
--		mSleep(math.random(500, 700))
--		x,y = findMultiColorInRegionFuzzy( 0x007aff, "1|20|0x007aff,11|0|0x007aff,18|17|0x007aff,14|27|0x007aff", 90, 0, 0, 749, 1333)
--		if x~=-1 and y~=-1 then
--			mSleep(math.random(500, 700))
--			randomTap(x,y,10)
--			mSleep(math.random(500, 700))
--			toast("vpn连接失败2",1)
--		end
--		goto get_vpn
--	else
--		::ip_addresss::
--		local sz = require("sz");
--		local szhttp = require("szocket.http")
--		local res, code = szhttp.request("http://myip.ipip.net/")
--		if code == 200 then
--			toast("vpn正常使用:"..tostring(res),1)
--			mSleep(1000)
--		else
--			goto ip_addresss
--		end
--		return new_data
--	end
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
	name = getAppName(self.awz_bid) 
	if #name > 0 then
		clear_bid = self.awz_bid 
	else 
		clear_bid = self.axj_bid
	end

	::run_again::
	closeApp(clear_bid)
	mSleep(500)
	runApp(clear_bid)
	mSleep(1000)

	while true do
		mSleep(200)
		flag = isFrontApp(clear_bid)
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
	local szhttp = require("szocket.http")
	local res, code = szhttp.request("http://127.0.0.1:1688/cmd?fun=newrecord")
	if code == 200 then
		local resJson = sz.json.decode(res)
		local result = resJson.result
		if result == 3 then
			toast("新机成功，但是ip重复了",1)
		elseif result == 1 then
			toast("新机成功",1)
		else 
			toast("失败，请手动查看问题", 1)
			mSleep(3000)
			goto run_again
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

function model:imgupload2(_url,path,imageName)
	local sz 				= require("sz")
	local socket 			= require ("socket");
	local szhttp 			= require("szocket.http")
	local respbody 			= {}
	local _file 			= imageName
	local _end 				='\r\n'..[[--abcd--]]..'\r\n'
	local reqfile			= io.open(path)

	if reqfile == nil then
		toast("file not found",1)
		return
	end
	local size = io.open(path):seek("end")
	if  size ==  0 then
		toast("empty file",1)
		return
	end
	local info = "[*] uploading "..path.." to url : ".._url.."  size:  "..tostring(size).."bytes"    
	toast(info,1)
	local  res , code , rsp_body = szhttp.request {
		method = "POST",
		url = _url,
		headers = {
			["Content-Type"] =  "multipart/form-data;boundary=abcd",
			["Content-Length"] = #_file + size + #_end,
			["origin"] = "https://cli.im",
		},
		source = ltn12.source.cat(ltn12.source.string(_file),ltn12.source.file(reqfile),ltn12.source.string(_end)),
		sink = ltn12.sink.table(respbody)
	}
	if code  == 200 then
		return table.concat(respbody)
	else
		return nil
	end
end

function model:ewm(ip_userName,ip_country,login_times,phone_help,skey,tiaoma_bool,fz_bool,fz_type,phone,phone_token,api_change,SMS_country,pid,pay_id,ewm_url,provinceId,tzid,getPhone_key,sumbit_key,codeUrl,messGetTime,messSendTime,ewm_id,localNetwork)
	if fz_type == "0" or fz_type == "7" or fz_type == "9" or fz_type == "10" or fz_type == "11" or fz_type == "12" then
		if fz_type == "0" then
			--下单
			::down_ewm::
			local sz = require("sz");
			local szhttp = require("szocket.http")
			local res, code = szhttp.request("http://api.004461.cn/create.action?url="..ewm_url.."&merchant="..sumbit_key.."&provinceId="..provinceId)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.code == "200" then
					toast(tmp.message, 1)
					order_sn = tmp.data.order_sn
				end
			else
				goto down_ewm
			end
		elseif fz_type == "9" then
			::put_work::
			header_send = {}
			body_send = string.format("userKey=%s&qrCodeUrl=%s&phone=%s&provinceId=%s",sumbit_key,ewm_url,phone,"210000")
			ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
			status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/submit", header_send, body_send, true)
			if status_resp == 200 then
				local tmp = json.decode(body_resp)
				if tmp.success then
					taskId = tmp.obj.orderId
					toast("发布成功,id:"..tmp.obj.orderId,1)
				else
					goto put_work
				end
			else
				goto put_work
			end
		elseif fz_type == "10" then
			list = readFile(userPath().."/res/phone_num.txt")
--			toast(list[1],1)
			::put_work::
			header_send = {}
			body_send = string.format("key=%s&url=%s&tel=%s&area=%s&mark=%s",sumbit_key, hk_url, phone, country_num,list[1])
			ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
			status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/tj", header_send, body_send, true)
			if status_resp == 200 then
				local tmp = json.decode(body_resp)
				if tmp.success then
					oId = tmp.data.oId
					toast("二维码辅助发布成功:"..oId,1)
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
		elseif fz_type == "11" then
			::put_work::
			header_send = {
				["Content-Type"] = "application/x-www-form-urlencoded",
			}
			body_send = {
				["userKey"] = sumbit_key,
				--	["qrCodeImg"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
				["qrCodeUrl"] = urlEncoder(ewm_url),
				["phone"] = phone,
			}
			ts.setHttpsTimeOut(60)
			code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send,body_send)
			if code == 200 then
				local tmp = json.decode(body_resp)
				if tmp.success then
					orderId = tmp.obj.orderId
					toast("二维码辅助发布成功:"..orderId,1)
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
		elseif fz_type == "12" then
			::put_work::
			-- 请求header添加token
			header_send = {token=string.format("%s", sumbit_key)}
			body_send = string.format("qr=%s&phone=%s", ewm_url, phone)
			ts.setHttpsTimeOut(60) -- 安卓不支持设置超时时间
			status_resp, header_resp, result = ts.httpPost("https://ctpu.chitutask.com/api/task/add", header_send, body_send)
			if status_resp == 200 then
				local tmp = json.decode(result)
				if tmp.code == 200 then
					taskId = tmp.data.taskId
					toast("二维码辅助发布成功:"..taskId,1)
					mSleep(5000)
				else
					mSleep(500)
					toast("发布失败，6秒后重新发布:"..tostring(result),1)
					mSleep(6000)
					goto put_work
				end
			else
				goto put_work
			end
		end

		--查询订单状态
		backLogin = false
		::backLogin::
		status_time = 0
		while (true) do
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				toast("辅助成功",1)
				mSleep(2000)
				if not backLogin then
					if localNetwork == "0" then
						self:changeGWIP(ip_userName,ip_country)
					end

					if vpn_country == "0" or vpn_country == "1" then
						self:change_vpn()
					elseif vpn_country == "2" or vpn_country == "3" then
						self:service_GWvpn()
						setVPNEnable(true); --打开VPN
						mSleep(3000)
						runApp("com.tencent.xin")    --运行微信
						mSleep(2500)
					end
					backLogin = true
					mSleep(3000)
					goto backLogin
				else
					toast("返回注册按钮页面",1)
					mSleep(2000)
				end
				mSleep(1000)
				randomTap(x + 100, y + 10, 4)
				mSleep(math.random(500, 700))
				status = 1
				break
			else
				toast("辅助倒计时:"..status_time,1)
				status_time = status_time + 1
				mSleep(4500)
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xfa5151, "49|1|0xfa5151,-154|787|0x07c160,180|843|0x07c160,186|795|0x07c160,-130|847|0x07c160", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				setVPNEnable(false)
				toast("系统繁忙，稍后再试",1)
				status = 2
				break
			end

			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0xf9514e,"45|4|0xf9514e,-117|815|0x5c160,161|819|0x5c160", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				setVPNEnable(false)
				toast("验证信息缺失",1)
				status = 2
				break
			end

			if status_time > 60 then
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
	yzm_error = false
	::get_code_again::
	if status == 1 or fz_bool or tiaoma_bool or phone_help then
		while true do
			--返回注册流程
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x + 150, y)
				mSleep(math.random(1200, 1700))
			end

			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1500, 2700))
				if fz_type ~= "3" then
					if vpn_country == "0" or vpn_country == "1" then
						self:change_GNvpn()
					elseif vpn_country == "2" or vpn_country == "3" then
						self:service_GNvpn()
						setVPNEnable(true); --打开VPN
						mSleep(3000)
						runApp("com.tencent.xin");    --运行微信
						mSleep(2500)
					end
				end
				setVPNEnable(false)
				mSleep(5000)
				randomTap(412, 489,5)
				mSleep(math.random(500, 700))
				toast("接收短信中",1)
				break
			end

			mSleep(200)
			if getColor(390,822) == 0x576b95 and getColor(363,822) == 0x576b95 then
				mSleep(500)
				randomTap(390,822,5)
				mSleep(500)
				toast("拒收微信登录",1)
				yzm_error = true
				break
			end
		end

		if fz_type == "7" then
			::push_work::
			header_send = {
				["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
			}
			body_send = {
				["id"] = ewm_id,
				["state"] = "1",
			}
			ts.setHttpsTimeOut(60)
			code,header_resp, body_resp = ts.httpsPost("http://106.15.248.73/index.php/api/qr/up", header_send,body_send)
			if code == 200 then
				local tmp = json.decode(body_resp)
				if tmp.msg == "up_success" then
					toast("状态成功，更新成功",1)
					if localNetwork == "1" then
						setVPNEnable(true)
						mSleep(1000)
					end
				end
			else
				toast("状态更新失败:"..tostring(body_resp),1)
				setVPNEnable(false)
				mSleep(6000)
				goto push_work
			end
		end
	end

	if yzm_error then
		for i = 1, 5 do
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x576b95,"12|-6|0x576b95,-20|-7|0x576b95,-24|-10|0x576b95,-298|-5|0x181819,-306|1|0x181819", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1000, 1700))
				randomTap(x, y,5)
				mSleep(math.random(500, 700))
				break
			end
		end
		return false
	else
		if status == 1 or fz_bool or tiaoma_bool or phone_help then
			old_yzm = ""
			aodi_bool = false
			::reset_codes::
			if api_change == "0" then
				while (true) do
					mSleep(200)
					local sz = require("sz");
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://47.104.246.33/onlinesim.php?cmd=getsms&apikey="..getPhone_key.."&tzid="..tzid)
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
					--messGetTime,messSendTime
					if wait > tonumber(messGetTime) then
						restart_time = restart_time + 1
						if restart_time > tonumber(messSendTime) then
							status = 2
							--标记订单
							local sz = require("sz");
							local szhttp = require("szocket.http")
							local res, code = szhttp.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)
							if code == 200 then
								tmp = json.decode(res)
								if tmp.code == "200" then
									toast(tmp.message, 1)
									mSleep(3000)
								end
							end
							yzm_mess = ""
							lua_restart()
						else
							mSleep(500)
							if fz_type ~= "3" then
								self:change_vpn()
							else
								setVPNEnable(true)
							end
							mSleep(math.random(2000, 3000))
							randomTap(372,  749, 3)
							mSleep(math.random(1000, 1500))
							randomTap(368, 1039,5)
							mSleep(math.random(3000, 5000))
							while (true) do
								mSleep(500)
								if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
									break
								else
									toast("等待验证码重新发送",1)
									mSleep(3000)
								end
							end

							if fz_type ~= "3" then
								setVPNEnable(true)
							else
								setVPNEnable(false)
							end
							wait = 1
							toast("重新获取验证码",1)
							mSleep(2000)
							goto get_code_again
						end
					end
				end
			elseif api_change == "1" then
				while true do
					mSleep(200)
					local sz = require("sz")        --登陆
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://simsms.org/priemnik.php?metod=get_sms&country="..SMS_country.."&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv&id="..pay_id)
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
					--messGetTime,messSendTime
					if mess_time > tonumber(messGetTime) then
						status = 2
						::black::
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://simsms.org/priemnik.php?metod=ban&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv&id="..pay_id)
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
						yzm_mess = ""
						lua_restart()
					end
				end
			elseif api_change == "2" or api_change == "10" or api_change == "12" then
				--				if aodi_bool then
				--				::file_bool::
				--				bool = self:file_exists(userPath().."/res/phone_data.txt")
				--				if bool then
				--					phone_data = readFile(userPath().."/res/phone_data.txt")
				--					toast(phone_data[1],1)
				--					if type(phone_data[1]) ~= "nil" then
				--						mobile = phone_data[1]
				--						toast("号码文件有号码",1)
				--						::get_phone::
				--						local sz = require("sz")        --登陆
				--						local szhttp = require("szocket.http")
				--						local res, code = szhttp.request("http://api.ma37.com/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..work_id.."&mobile="..mobile)
				--						mSleep(500)
				--						if code == 200 then
				--							data = strSplit(res, "|")
				--							if data[1] == "1" then
				--								telphone = data[5]
				--								pid = data[2]
				--							else
				--								toast("获取手机号码失败，重新获取:"..tostring(res),1)
				--								mSleep(1000)
				--								goto get_phone
				--							end
				--						else
				--							toast("获取手机号码失败，重新获取:"..tostring(res),1)
				--							mSleep(1000)
				--							goto get_phone
				--						end
				--					end
				--				else
				--					toast("文件不存在，创建文件",1)
				--					writeFileString(userPath().."/res/phone_data.txt","","w",0)
				--					goto file_bool
				--				end
				--				end

				if api_change == "10" then
					getPhoneCode_url = "http://web.jiemite.com/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&iid="..work_id.."&mobile="..telphone
				elseif api_change == "2" then
					getPhoneCode_url = "http://api.ma37.com/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid
				elseif api_change == "12" then
					getPhoneCode_url = "http://27.124.4.13/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid
				end

				::get_mess::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(getPhoneCode_url)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						yzm_mess = data[2]
					elseif data[1] == "0" then
						toast("暂无短信"..get_time,1)
						mSleep(15000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								if api_change == "10" then
									black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
								elseif api_change == "2" then
									black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
								elseif api_change == "12" then
									black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
								end

								status = 2
								::addblack::
								local sz = require("sz")        --登陆
								local szhttp = require("szocket.http")
								local res, code = szhttp.request(black_url)
								if code == 200 then
									data = strSplit(res, "|")
									if data[1] == "1" then
										toast("拉黑手机号码",1)
									elseif data[2] == "-5" then
										if api_change == "12" then
											black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
											goto addblack
										elseif api_change == "2" then
											black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
											goto addblack
										end
									else
										toast(res,1)
										mSleep(2000)
										goto addblack
									end
								end
								yzm_mess = ""
								writeFileString(userPath().."/res/phone_data.txt","","w",0)
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end

								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								get_time = 1
								toast("重新获取验证码",1)
								mSleep(2000)
								goto get_code_again
							end
						else
							goto get_mess
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
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.56.103.47/api.php?action=GetCode&token="..tokens.."&pid="..work_id.."&number="..phone)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						yzm_mess = data[2]
					elseif data[1] == "no" then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								status = 2
								::addblack::
								local sz = require("sz")        --登陆
								local szhttp = require("szocket.http")
								local res, code = szhttp.request("http://47.56.103.47/api.php?action=AddBlackNumber&token="..tokens.."&pid="..kn_id.."&number="..telphone)
								mSleep(500)
								if code == 200 then
									data = strSplit(res, ",")
									if data[1] == "ok" then
										toast("加黑手机号码",1)
									else
										goto addblack
									end
								end
								yzm_mess = ""
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end

								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								get_time = 1
								toast("重新获取验证码",1)
								mSleep(2000)
								goto get_code_again
							end
						else
							goto get_mess
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
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://129.204.138.57:11223/api/Camel/getmessage?token="..tokens.."&skey="..skey)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.Status == 201 then
						yzm_mess = string.match(tmp.Data.SMS, '%d+%d+%d+%d+%d+%d+')
					elseif tmp.Status == 202 then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								status = 2
								::addblack::
								local sz = require("sz")        --登陆
								local szhttp = require("szocket.http")
								local res, code = szhttp.request("http://129.204.138.57:11223/api/Camel/addblack?token="..tokens.."&skey="..skey)
								mSleep(500)
								if code == 200 then
									tmp = json.decode(res)
									if tmp.Status == 200 then
										toast("加黑手机号码",1)
									else
										goto addblack
									end
								end
								yzm_mess = ""
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end

								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								get_time = 1
								toast("重新获取验证码",1)
								mSleep(2000)
								goto get_code_again
							end
						else
							goto get_mess
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
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://opapi.sms-5g.com/out/ext_api/getMsg?name="..username.."&pwd="..user_pass.."&pn="..telphone.."&pid="..work_id.."&&serial=2")
				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == 200 then
						yzm_mess = tmp.data
						toast(yzm_mess,1)
					elseif tmp.code == 908 then
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								status = 2
								local sz = require("sz")        --登陆
								local szhttp = require("szocket.http")
								local res, code = szhttp.request("http://opapi.sms-5g.com/out/ext_api/passMobile?name="..username.."&pwd="..user_pass.."&pn="..telphone.."&pid="..work_id.."&serial=2")
								mSleep(500)
								if code == 200 then
									tmp = json.decode(res)
									if tmp.code == 200 then
										toast("释放号码成功",1)
									end
								end
								yzm_mess = ""
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end
								
								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								
								get_time = 1
								toast("重新获取验证码",1)
								mSleep(2000)
								goto get_code_again
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
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/api.php?cmd=code&token="..getPhone_key.."&src=tl&app=WeChat&username="..username.."&mobile="..telphone)
				toast(res, 1)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if #(tmp.data:atrim()) > 0 then
						yzm_mess = tmp.data
					else
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								status = 2
								yzm_mess = ""
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end

								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								get_time = 1
								mSleep(2000)
								goto get_code_again
							end
						else
							goto get_mess
						end
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif api_change == "7" then
				yzm_bool = false
				newstatus = "失败"
				::get_mess::
				toast(codeUrl,1)

				if get_time > tonumber(messGetTime) then
					restart_time = restart_time + 1
					if restart_time > tonumber(messSendTime) then
						status = 2
						yzm_mess = ""
						::push::
						mSleep(500)
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=poststatus&phone="..phone.."&status="..newstatus)
						mSleep(500)
						if code == 200 then
							if reTxtUtf8(res) == "反馈成功" then
								toast("号码状态标记成功",1)
							else
								goto push
							end
						else
							toast("号码标记失败，重新标记:"..tostring(res),1)
							mSleep(3000)
							goto push
						end
						lua_restart()
					else
						mSleep(500)
						if fz_type ~= "3" then
							self:change_vpn()
						else
							setVPNEnable(true)
						end
						mSleep(math.random(2000, 3000))
						randomTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomTap(368, 1039,5)
						mSleep(math.random(3000, 5000))
						while (true) do
							mSleep(500)
							if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
								break
							else
								toast("等待验证码重新发送",1)
								mSleep(3000)
							end
						end

						if fz_type ~= "3" then
							setVPNEnable(true)
						else
							setVPNEnable(false)
						end
						get_time = 1
						mSleep(2000)
						goto get_code_again
					end
				end

				local ts = require("ts")
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpsGet(codeUrl:atrim(), header_send,body_send)
				if code == 200 then
					yzm_mess = string.match(body_resp, '%d+%d+%d+%d+%d+%d+')
					if type(yzm_mess) == "nil" then
						toast("获取验证码失败",1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					elseif #yzm_mess == 6 then
						toast(yzm_mess,1)
						yzm_bool = true
						newstatus = "成功"
					else
						toast("获取验证码失败"..code..tostring(body_resp),1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败"..code..tostring(body_resp),1)
					mSleep(5000)
					get_time = get_time + 1
					goto get_mess
				end

				if yzm_bool then
					toast(phone..newstatus,1)
					::push::
					mSleep(500)
					local sz = require("sz")        --登陆
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=poststatus&phone="..phone.."&status="..newstatus)
					toast(res, 1)
					mSleep(500)
					if code == 200 then
						if reTxtUtf8(res) == "反馈成功" then
							toast("号码状态标记成功",1)
						else
							goto push
						end
					else
						toast("号码标记失败，重新标记:"..tostring(res),1)
						mSleep(3000)
						goto push
					end
				end
			elseif api_change == "8" then
				yzm_bool = false
				newstatus = "失败"
				::get_mess::
				toast(codeUrl,1)

				if get_time > tonumber(messGetTime) then
					restart_time = restart_time + 1
					if restart_time > tonumber(messSendTime) then
						status = 2
						yzm_mess = ""
						::push::
						mSleep(500)
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=poststatus&phone="..phone.."&status="..newstatus)
						mSleep(500)
						if code == 200 then
							if reTxtUtf8(res) == "反馈成功" then
								toast("号码状态标记成功",1)
							else
								goto push
							end
						else
							toast("号码标记失败，重新标记:"..tostring(res),1)
							mSleep(3000)
							goto push
						end
						lua_restart()
					else
						mSleep(500)
						if fz_type ~= "3" then
							self:change_vpn()
						else
							setVPNEnable(true)
						end
						mSleep(math.random(2000, 3000))
						randomTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomTap(368, 1039,5)
						mSleep(math.random(3000, 5000))
						while (true) do
							mSleep(500)
							if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
								break
							else
								toast("等待验证码重新发送",1)
								mSleep(3000)
							end
						end

						if fz_type ~= "3" then
							setVPNEnable(true)
						else
							setVPNEnable(false)
						end
						get_time = 1
						mSleep(2000)
						goto get_code_again
					end
				end

				local ts = require("ts")
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpsGet(codeUrl:atrim(), header_send,body_send)
				if code == 200 then
					yzm_mess = string.match(body_resp, '%d+%d+%d+%d+%d+%d+')
					if type(yzm_mess) == "nil" then
						toast("获取验证码失败",1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					elseif #yzm_mess == 6 then
						toast(yzm_mess,1)
						yzm_bool = true
						newstatus = "成功"
					else
						toast("获取验证码失败"..code..body_resp,1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败"..code..body_resp,1)
					mSleep(5000)
					get_time = get_time + 1
					goto get_mess
				end

				if yzm_bool then
					toast(phone..newstatus,1)
					::push::
					mSleep(500)
					local sz = require("sz")        --登陆
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=poststatus&phone="..phone.."&status="..newstatus)
					toast(res, 1)
					mSleep(500)
					if code == 200 then
						if reTxtUtf8(res) == "反馈成功" then
							toast("号码状态标记成功",1)
						else
							goto push
						end
					else
						toast("号码标记失败，重新标记:"..tostring(res),1)
						mSleep(3000)
						goto push
					end
				end
			elseif api_change == "9" or api_change == "11" then
				if api_change == "9" then
					url = "http://www.phantomunion.com:10023/pickCode-api/push/sweetWrapper?token="..tokens.."&serialNumber="..serialNumber
				elseif api_change == "11" then
					url = "http://cucumber.bid/bbq-cu-api/push/sweetWrapper?token="..tokens.."&serialNumber="..serialNumber
				end

				yzm_bool = false
				::get_mess::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp =
				ts.httpGet(
					url,
					header_send,
					body_send
				)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "200" then
						if #tmp.data.verificationCode > 0 and #(tmp.data.verificationCode[1].vc):atrim() > 0 then
							yzm_mess = string.match(tmp.data.verificationCode[1].vc,"%d+")
							yzm_bool = true
							toast(yzm_mess,1)
							mSleep(1000)

							if api_change == "11" then
								url = "http://cucumber.bid/bbq-cu-api/push/redemption?token="..tokens.."&feedbackType=A&serialNumber="..serialNumber.."&description=success"..telphone
							end

							::get_sucess::
							header_send = {}
							body_send = {}
							ts.setHttpsTimeOut(60)
							status_resp, header_resp, body_resp =
							ts.httpGet(
								url,
								header_send,
								body_send
							)
							if status_resp == 200 then
								tmp = json.decode(body_resp)
								if tmp.code == "200" then
									if tmp.data == "SUCCESS" or tmp.message == "success" then
										toast("接收到验证码，反馈成功",1)
										mSleep(1000)
									else
										toast("接收到验证码，反馈失败"..tostring(body_resp),1)
										mSleep(2000)
										goto get_sucess
									end
								else
									toast(tmp.message, 1)
									mSleep(3000)
									goto get_sucess
								end
							else
								toast(body_resp, 1)
								mSleep(3000)
								goto get_sucess
							end
						else
							toast("验证码获取失败:"..get_time,1)
							mSleep(5000)
							get_time = get_time + 1
							--messGetTime,messSendTime
							if get_time > tonumber(messGetTime) then
								restart_time = restart_time + 1
								if restart_time > tonumber(messSendTime) then
									yzm_mess = ""

									if api_change == "9" then
										url = "http://www.phantomunion.com:10023/pickCode-api/push/redemption?token="..tokens.."&serialNumber="..serialNumber.."&feedbackType=A&description=fail"..telphone
									elseif api_change == "11" then
										url = "http://cucumber.bid/bbq-cu-api/push/redemption?token="..tokens.."&feedbackType=B&serialNumber="..serialNumber.."&description=fail"..telphone
									end

									::get_fail::
									header_send = {}
									body_send = {}
									ts.setHttpsTimeOut(60)
									status_resp, header_resp, body_resp =
									ts.httpGet(
										url,
										header_send,
										body_send
									)
									if status_resp == 200 then
										tmp = json.decode(body_resp)
										if tmp.code == "200" then
											if tmp.data == "SUCCESS" or tmp.message == "success" then
												toast("拉黑成功",1)
												mSleep(1000)
											else
												toast("拉黑失败"..tostring(body_resp),1)
												mSleep(2000)
												goto get_fail
											end
										else
											toast(tmp.message, 1)
											mSleep(3000)
											goto get_fail
										end
									else
										toast(body_resp, 1)
										mSleep(3000)
										goto get_fail
									end
									lua_restart()
								else
									mSleep(500)
									if fz_type ~= "3" then
										self:change_vpn()
									else
										setVPNEnable(true)
									end
									mSleep(math.random(2000, 3000))
									randomTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomTap(368, 1039,5)
									mSleep(math.random(3000, 5000))
									while (true) do
										mSleep(500)
										if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
											break
										else
											toast("等待验证码重新发送",1)
											mSleep(3000)
										end
									end

									if fz_type ~= "3" then
										setVPNEnable(true)
									else
										setVPNEnable(false)
									end
									get_time = 1
									mSleep(2000)
									goto get_code_again
								end
							else
								goto get_mess
							end
						end
					else
						toast(tmp.message, 1)
						mSleep(3000)
						goto get_mess
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto get_mess
				end
			elseif api_change == "13" then
				yzm_bool = false
				::get_mess::
				local ts = require("ts")
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/dq_huan_cun&mingzi=" .. telphone, header_send,body_send)
				if code == 200 then
					yzm_mess = string.match(body_resp, '%d+%d+%d+%d+%d+%d+')
					if type(yzm_mess) == "nil" then
						toast("获取验证码失败",1)
						mSleep(5000)
						get_time = get_time + 1
						--messGetTime,messSendTime
						if get_time > tonumber(messGetTime) then
							restart_time = restart_time + 1
							if restart_time > tonumber(messSendTime) then
								status = 2
								yzm_mess = ""
								::push::
								header_send = {}
								body_send = {}
								ts.setHttpsTimeOut(60)
								status_resp, header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/huan_cun&mingzi="..telphone.."&nr=0",header_send,body_send)
								if status_resp == 200 then
									if tonumber(body_resp) == 1 then
										toast("号码清除成功",1)
										mSleep(1000)
									else
										toast(body_resp, 1)
										mSleep(3000)
										goto push
									end
								else
									toast(body_resp, 1)
									mSleep(3000)
									goto push
								end
								lua_restart()
							else
								mSleep(500)
								if fz_type ~= "3" then
									self:change_vpn()
								else
									setVPNEnable(true)
								end
								mSleep(math.random(2000, 3000))
								randomTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomTap(368, 1039,5)
								mSleep(math.random(3000, 5000))
								while (true) do
									mSleep(500)
									if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
										break
									else
										toast("等待验证码重新发送",1)
										mSleep(3000)
									end
								end

								if fz_type ~= "3" then
									setVPNEnable(true)
								else
									setVPNEnable(false)
								end
								get_time = 1
								mSleep(2000)
								goto get_code_again
							end
						else
							goto get_mess
						end
					elseif #yzm_mess == 6 then
						toast(yzm_mess,1)
					else
						toast(code..body_resp,1)
						goto get_mess
					end
				else
					toast(code,0)
					goto get_mess
				end
			elseif api_change == "14" then
				yzm_bool = false
				::get_mess::
				if get_time > tonumber(messGetTime) then
					restart_time = restart_time + 1
					if restart_time > tonumber(messSendTime) then
						status = 2
						yzm_mess = ""
						::AddBlackPhone::
						header_send = {}
						body_send = {}
						ts.setHttpsTimeOut(60)
						status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/AddBlackPhone?Token=" .. yzm_token .. "&MSGID=" .. MSGID,header_send,body_send)
						if status_resp == 200 then
							tmp = json.decode(body_resp)
							if tmp.code == "0" or tmp.code == 0 then
								toast(tmp.msg, 1)
								mSleep(1000)
							else
								toast(tmp.msg, 1)
								mSleep(3000)
								goto AddBlackPhone
							end
						else
							toast(body_resp, 1)
							mSleep(3000)
							goto AddBlackPhone
						end
						lua_restart()
					else
						mSleep(500)
						if fz_type ~= "3" then
							self:change_vpn()
						else
							setVPNEnable(true)
						end
						mSleep(math.random(2000, 3000))
						randomTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomTap(368, 1039,5)
						mSleep(math.random(3000, 5000))
						while (true) do
							mSleep(500)
							if getColor(369,  614) == 0x9ce6bf and getColor(374,  668) == 0x9ce6bf then
								break
							else
								toast("等待验证码重新发送",1)
								mSleep(3000)
							end
						end

						if fz_type ~= "3" then
							setVPNEnable(true)
						else
							setVPNEnable(false)
						end
						get_time = 1
						mSleep(2000)
						goto get_code_again
					end
				else
					goto get_mess
				end

				local ts = require("ts")
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpGet("http://www.58yzm.com/GetMessage?Token=" .. yzm_token .. "&MSGID=" .. MSGID, header_send,body_send)
				if code == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "0" or tmp.code == 0 then
						yzm_mess = string.match(tmp.data, '%d+%d+%d+%d+%d+%d+')
						if type(yzm_mess) == "nil" then
							toast("获取验证码失败",1)
							mSleep(5000)
							get_time = get_time + 1
							--messGetTime,messSendTime
						elseif #yzm_mess == 6 then
							toast(yzm_mess,1)
						else
							toast(code..body_resp,1)
							mSleep(8000)
							goto get_mess
						end
					else
						toast(code..body_resp,1)
						mSleep(8000)
						goto get_mess
					end
				else
					toast(code,0)
					mSleep(8000)
					goto get_mess
				end
			end

			mSleep(500)
			if #yzm_mess:atrim() > 0 and yzm_mess ~= old_yzm then
				if login_times == "1" then
					if gn and not tiaoma_bool then
						mSleep(2000)
						--						self:change_GNvpn()
						mSleep(1000)
						gn = false
					end
				end

				if localNetwork == "1" then
					if fz_type ~= "3" then
						self:change_GNvpn()
						setVPNEnable(true)
					end
				end

				while true do
					mSleep(math.random(500, 700))
					x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						randomTap(590,  482, 3)
						mSleep(math.random(1000, 1500))
						break
					end

					mSleep(500)
					if getColor(260,641) == 0x5c160 then
						mSleep(500)
						randomTap(590,  482, 3)
						mSleep(1000)
						for var= 1, 10 do
							mSleep(100)
							keyDown("DeleteOrBackspace")
							mSleep(100)
							keyUp("DeleteOrBackspace")
						end
					end
				end

				for var= 1, 10 do
					mSleep(100)
					keyDown("DeleteOrBackspace")
					mSleep(100)
					keyUp("DeleteOrBackspace")
				end

				for i = 1, #(yzm_mess) do
					mSleep(math.random(500, 700))
					num = string.sub(yzm_mess,i,i)
					if num == "0" then
						randomTap(373, 1281, 8)
					elseif num == "1" then
						randomTap(132,  955, 8)
					elseif num == "2" then
						randomTap(377,  944, 8)
					elseif num == "3" then
						randomTap(634,  941, 8)
					elseif num == "4" then
						randomTap(128, 1063, 8)
					elseif num == "5" then
						randomTap(374, 1061, 8)
					elseif num == "6" then
						randomTap(628, 1055, 8)
					elseif num == "7" then
						randomTap(119, 1165, 8)
					elseif num == "8" then
						randomTap(378, 1160, 8)
					elseif num == "9" then
						randomTap(633, 1164, 8)
					end
				end

				mSleep(math.random(500, 700))
				randomTap(546,  623,11)
				mSleep(math.random(500, 700))

				login_error = false
				--检查验证码是否正确
				for var= 1, 10 do
					mSleep(500)
					x,y = findMultiColorInRegionFuzzy(0x576b95, "-28|-1|0x576b95,-15|-154|0x000000,-137|-163|0x000000,146|-158|0x000000", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(500)
						randomTap(x,y,5)
						mSleep(3000)
						randomTap(590, 492, 3)
						mSleep(1000)
						for var= 1, 10 do
							mSleep(100)
							keyDown("DeleteOrBackspace")
							mSleep(100)
							keyUp("DeleteOrBackspace")
						end
						mSleep(math.random(1000, 1500))
						randomTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomTap(368, 1039,5)
						mSleep(math.random(10000, 15000))
						toast("验证码不正确，重新发送",1)
						old_yzm = yzm_mess
						aodi_bool = true
						goto reset_codes
					end

					x,y = findMultiColorInRegionFuzzy( 0x576b95, "-28|3|0x576b95,-136|-177|0x000000,-66|-179|0x000000,54|-175|0x000000,199|-180|0x000000", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						dialog("注册异常",0)
						mSleep(1000)
						lua_restart()
						--						login_error = true
						--						toast("注册异常",1)
						--						break
					end
				end

				if fz_type == "0" then
					--标记订单
					local sz = require("sz");
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)

					if code == 200 then
						tmp = json.decode(res)
						if tmp.code == "200" then
							toast(tmp.message, 1)
							mSleep(3000)
						end
					end
				end

				if login_error then
					return false
				else
					return true
				end
			elseif yzm_mess:atrim() == old_yzm:atrim() then
				mSleep(500)
				toast("验证码一样，重新获取",1)
				mSleep(500)
				if fz_type ~= "3" then
					self:change_vpn()
				end
				mSleep(math.random(2000, 3000))
				randomTap(372,  749, 3)
				mSleep(math.random(1000, 1500))
				randomTap(368, 1039,5)
				mSleep(math.random(3000, 5000))
				setVPNEnable(false)
				mSleep(30000)
				goto reset_codes
			else
				return false
			end
		else
			if fz_type == "0" then
				--标记订单
				local sz = require("sz");
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://api.004461.cn/change.action?url="..ewm_url.."&merchant="..sumbit_key.."&order_sn="..order_sn.."&status="..status)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == "200" then
						toast(tmp.message, 1)
						mSleep(3000)
					end
				end
			elseif fz_type == "7" then
				::push_work::
				header_send = {
					["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
				}
				body_send = {
					["id"] = ewm_id,
					["state"] = "2",
				}
				ts.setHttpsTimeOut(60)
				code,header_resp, body_resp = ts.httpsPost("http://106.15.248.73/index.php/api/qr/up", header_send,body_send)
				if code == 200 then
					local tmp = json.decode(body_resp)
					if tmp.msg == "up_success" then
						toast("状态失败，更新成功",1)
						if localNetwork == "1" then
							setVPNEnable(true)
							mSleep(1000)
						end
					end
				else
					toast("状态更新失败:"..tostring(body_resp),1)
					setVPNEnable(false)
					mSleep(6000)
					goto push_work
				end
			elseif fz_type == "9" then
				::push_work::
				header_send = {}
				body_send = string.format("userKey=%s&orderId=%s&status=%s",sumbit_key,taskId,status)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.msg == "已提交任务结果" then
						toast("订单可能未接单退款了："..tmp.msg,1)
						mSleep(2000)
					elseif tmp.code == 1 then
						toast(tmp.msg,1)
						mSleep(2000)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "10" then
				::push_work::
				header_send = {}
				body_send = string.format("key=%s&oId=%s&sts=%s",sumbit_key,oId,"fail")
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/xg", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.code == "3" or tmp.code == "4" or tmp.code == "5" or tmp.code == "7" or tmp.code == "6" then
						toast(tmp.msg,1)
						mSleep(2000)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "11" then
				::push_work::
				header_send = {
					["Content-Type"] = "application/x-www-form-urlencoded",
				}
				body_send = {
					["userKey"] = sumbit_key,
					["orderId"] = orderId,
					["status"] = status,
				}
				ts.setHttpsTimeOut(60)
				code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
				if code == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "12" then
				::push_work::
				header_send = {token=string.format("%s", sumbit_key)}

				body_send = string.format("taskId=%s&status=%s", taskId, 3)
				ts.setHttpsTimeOut(60) -- 安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpPost("https://ctpu.chitutask.com/api/task/status", header_send,body_send)
				if code == 200 then
					mSleep(500)
					local tmp = json.decode(body_resp)
					if tmp.code == 200 then
						toast("标记成功",1)
					elseif tmp.message == "任务已被标记为成功" or tmp.message == "任务已被标记为失败" then
						toast("已经标记过该任务",1)
					elseif tmp.message == "任务超时未领取，已退款" then
						toast("任务超时未领取，已退款",1)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					goto push_work
				end
			end

			if api_change == "7" then
				::push::
				mSleep(500)
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=poststatus&phone="..phone.."&status=失败")
				mSleep(500)
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("号码标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "8" then
				::push::
				mSleep(500)
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=poststatus&phone="..phone.."&status=失败")
				mSleep(500)
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("号码标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "9" or api_change == "11" then
				if api_change == "9" then
					url = "http://www.phantomunion.com:10023/pickCode-api/push/redemption?token="..tokens.."&serialNumber="..serialNumber.."&feedbackType=A&description=fail"..telphone
				elseif api_change == "11" then
					url = "http://cucumber.bid/bbq-cu-api/push/redemption?token="..tokens.."&feedbackType=B&serialNumber="..serialNumber.."&description=fail"..telphone
				end

				::get_fail::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp =
				ts.httpGet(
					url,
					header_send,
					body_send
				)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "200" then
						if tmp.data == "SUCCESS" or tmp.message == "success" then
							toast("拉黑成功",1)
							mSleep(1000)
						else
							toast("拉黑失败"..tostring(body_resp),1)
							mSleep(2000)
							goto get_fail
						end
					else
						toast(tmp.message, 1)
						mSleep(3000)
						goto get_fail
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto get_fail
				end
			elseif api_change == "13" then
				::push::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/huan_cun&mingzi="..phone.."&nr=0",header_send,body_send)
				if status_resp == 200 then
					if tonumber(body_resp) == 1 then
						toast("号码清除成功",1)
						mSleep(1000)
					else
						toast(body_resp, 1)
						mSleep(3000)
						goto push
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "14" then
				::AddBlackPhone::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/AddBlackPhone?Token=" .. yzm_token .. "&MSGID=" .. MSGID,header_send,body_send)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "0" or tmp.code == 0 then
						toast(tmp.msg, 1)
						mSleep(1000)
					else
						toast(tmp.msg, 1)
						mSleep(3000)
						goto AddBlackPhone
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto AddBlackPhone
				end
			end
			return false
		end
	end
end

function model:idCard()
	while true do
		mSleep(500)
		if getColor(654,1279) == 0x7c160 then
			mSleep(500)
			while true do
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0xc777,"12|-6|0xc777,-3|-3|0xc777,67|-12|0x191919,90|-12|0x191919,103|2|0x191919,117|-9|0x1b1b1b,122|3|0x191919", 100, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(1000)
					randomTap(x, y, 2)
					mSleep(1000)
					toast("支付",1)
					mSleep(1000)
					break
				end
			end

			--钱包
			while true do
				mSleep(500)
				if getColor(385,196) == 0x3cb371 then
					mSleep(1000)
					randomTap(554,289,2)
					mSleep(1000)
					toast("钱包",1)
					mSleep(1000)
					break
				end

				--欧盟同意
				mSleep(500)
				if getColor(299,1097) == 0x9ed99d then
					mSleep(1000)
					randomTap(205,978,1)
					mSleep(1000)
					while true do
						mSleep(500)
						if getColor(302,1115) == 0x1aad19 then
							mSleep(1000)
							randomTap(302,1115,2)
							mSleep(1000)
							toast("同意",1)
							mSleep(1000)
							break
						end
					end
				end
			end

			--零钱
			while true do
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0x10aeff,"1|-8|0x10aeff,-3|379|0x7c160,15|370|0x7c160,-16|372|0x7c160,292|-199|0x181818,337|-193|0x181818", 100, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(1000)
					randomTap(404, 186, 2)
					mSleep(1000)
					toast("零钱",1)
					mSleep(1000)
					break
				end
			end
			break
		else
			mSleep(500)
			randomTap(654,1279,2)
			mSleep(500)
		end
	end

	while (true) do
		mSleep(500)
		if getColor(118, 1125) == 0xededed and getColor(116,  938) == 0x000000 then
			mSleep(3000)
			randomTap(116,  938,2)
			mSleep(1000)
			toast("验证大陆身份证",1)
			mSleep(1000)
		end

		mSleep(500)
		if getColor(650,1287) == 0x1aad19 and getColor(683,1288) == 0x1aad19 then
			mSleep(3000)
			randomTap(683,1288,2)
			mSleep(1000)
			toast("微信支付政策",1)
			mSleep(1000)
			break
		end
	end

	while (true) do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x1aad19, "31|-1|0x1aad19,-405|-1198|0x000000,-344|-1199|0x000000,-301|-1198|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x,y,2)
			mSleep(1000)
		end

		mSleep(500)
		if getColor(259,  707) == 0x9ce6bf then
			mSleep(500)
			randomTap(324,  231,2)
			mSleep(1000)
			inputText("李元芳")
			mSleep(1000)
			randomTap(326,  322,2)
			mSleep(1000)
			inputText("341126199301216243")
			mSleep(1000)
			randomTap(316,  415,2)
			mSleep(1000)
			while (true) do
				mSleep(500)
				if getColor(87, 1041) == 0x191919 and getColor(223, 1043) == 0xffffff then
					mSleep(500)
					randomTap(223, 1043,2)
					mSleep(1000)
					break
				end
			end

			while (true) do
				mSleep(500)
				if getColor(200,  604) == 0x576b95 or getColor(200,  621) == 0x576b95 then
					mSleep(1000)
					randomTap(289,  511,2)
					mSleep(1000)
					break
				end

				mSleep(500)
				if getColor(36, 83) == 0x181818 then
					mSleep(500)
					randomTap(46, 83,2)
					mSleep(1000)
				end
			end

			--地区选择
			while (true) do
				mSleep(500)
				if getColor(380,   79) == 0x181818 and getColor(361,  178) == 0xffffff then
					mSleep(500)
					randomTap(156,  802,2)
					mSleep(2000)
					randomTap(156,  802,2)
					mSleep(1000)
					break
				end
			end

			while (true) do
				mSleep(500)
				if getColor(200,  604) == 0x576b95 or getColor(200,  621) == 0x576b95 then
					mSleep(500)
					randomTap(354,  720,2)
					mSleep(1000)
					toast("下一步",1)
					mSleep(1000)
					break
				end

				mSleep(500)
				if getColor(36, 83) == 0x181818 then
					mSleep(500)
					randomTap(46, 83,2)
					mSleep(1000)
				end
			end
			break
		end
	end

	while (true) do
		mSleep(500)
		if getColor(616, 1280) == 0x464646 then
			for var= 1, 6 do
				mSleep(200)
				randomTap(125,  950 ,2)
			end

			mSleep(500)
			toast("设置密码",1)
			mSleep(1000)
			break
		end
	end

	while (true) do
		mSleep(500)
		if getColor(616, 1280) == 0x464646 and getColor(259,  695) == 0x9ce6bf then
			for var= 1, 6 do
				mSleep(200)
				randomTap(125,  950 ,2)
			end

			mSleep(500)
			randomTap(259,  695,4)
			mSleep(1000)
			toast("再次设置密码",1)
			mSleep(1000)
			break
		end
	end

	while (true) do
		mSleep(500)
		if getColor(390,  777) == 0x576b95 and getColor(421,  612) == 0x000000 then
			mSleep(500)
			randomTap(390,  777,2)
			mSleep(1000)
			break
		end
	end
end

function model:connetMoveHttp(liandongName)
	t1 = ts.ms()

	while true do
		::connet::
		local sz = require("sz");
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://2.56.255.65/duqusjget.php?action=czs&name="..liandongName)
		if code == 200 then
			jump = string.match(res, '跳')
			if jump == "跳" then
				toast("出现跳，准备继续下一步",1)
				mSleep(1000)
				return true
			else
				toast("联动接口返回: "..tostring(res),1)
				mSleep(5000)
			end 
		else
			goto connet
		end

		t2 = ts.ms()

		if os.difftime(t2, t1) > 300 then
			toast("超过5分钟重新获取当前手机号码", 1)
			mSleep(1000)
			return false
		end
	end
end

function model:replace_file(fileName)
	appPath = appBundlePath(self.wc_bid);  

	local file = io.open(userPath().."/res/info/"..fileName,"rb") 
	if file then 
		local str = file:read("*a") 
		file:close()

		local file = io.open(appPath.."/Info.plist", 'wb');
		file:write(str)
		file:close();

		::writeAgain::
		bool = writeFileString(userPath().."/res/info/wc_version.txt",fileName,"w") --将 string 内容存入文件，成功返回 true
		if bool then
			toast("版本号存储成功，替换文件成功",1)
			mSleep(1000)
		else
			toast("写入失败", 1)
			goto writeAgain
		end
	end
end

function model:wechat(fz_error_times,iptimes,ip_userName,ip_country,place_id,data_sel,login_times,login_times_set,skey,wc_version,hk_way,fz_key,fz_type, phone, country_num, phone_token, api_change, SMS_country, username, user_pass, work_id, phone_country, country_id,nickName,password,provinceId,getPhone_key, sumbit_key,messGetTime,messSendTime,sendSixDataApi,updateNickName,needPay,localNetwork,needConnetMove,liandongName,liandongTime)
	new_bool = false
	ewm_url_bool = false
	serviceError = false
	connet_bool = true
	old = ""

	::run_app::
	closeApp(self.wc_bid)
	::nexts::
	mSleep(200)
	runApp(self.wc_bid)
	mSleep(500)
	if login_times == "0" then
		while (true) do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(549, 1240,10)
				mSleep(math.random(500, 700))
				toast("注册",1)
				break
			end

			flag = isFrontApp(self.wc_bid)
			if flag == 0 then
				goto run_app
			end
		end
	else
		-- 		if data_sel[1] == "0" then
		while (true) do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(549, 1240,10)
				mSleep(math.random(500, 700))
				toast("注册",1)
				break
			end

			flag = isFrontApp(self.wc_bid)
			if flag == 0 then
				goto run_app
			end
		end
		-- 		else
		-- 			while true do
		-- 				mSleep(math.random(500, 700))
		-- 				if getColor(561,1265) == 0x576b95 then
		-- 					mSleep(math.random(500, 700))
		-- 					randomTap(542,1273,3)
		-- 					mSleep(math.random(500, 700))
		-- 				end

		-- 				if getColor(393,1170) == 0 then
		-- 					mSleep(math.random(500, 700))
		-- 					randomTap(393,1170,3)
		-- 					mSleep(math.random(500, 700))
		-- 					break
		-- 				end
		-- 			end
		-- 		end
	end

	::start::
	while (true) do
		--10系统
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xf2f2f2,"458|9|0xf2f2f2,291|-94|0x576b95",100,0,0,749,1333)
		if x~=-1 and y~=-1 then
			toast("注册页面",1)
			mSleep(1000)
			break
		end

		--11系统
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"194|0|0xd7f5e5,530|-7|0x9ce6bf,234|-36|0x9ce6bf,229|28|0x9ce6bf",90,0,700,749,1333)
		if x~=-1 and y~=-1 then
			toast("注册页面",1)
			mSleep(1000)
			break
		end

		--点击模态框10
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a,"11|2|0x1a1a1a,44|1|0x1a1a1a,79|-1|0x1a1a1a,114|-1|0x1a1a1a,153|3|0x1a1a1a,187|3|0x1a1a1a", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x,y,10)
			mSleep(math.random(500, 700))
		end

		--点击模态框11
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0,"10|7|0,22|7|0,45|4|0,80|3|0,117|3|0,153|8|0,178|8|0", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(367,1042,10)
			mSleep(math.random(500, 700))
		end
	end

	--添加头像
	if addHeaderPicLogin == "0" then	
		while true do
			mSleep(200)
			if getColor(416,404) == 0x2bb00 then
				mSleep(500)
				randomTap(377,357,4)
				mSleep(500)
			end

			mSleep(200)
			if getColor(328,1175) == 0 and getColor(328,1175) == 0 then
				mSleep(500)
				randomTap(328,1175,4)
				mSleep(500)
				break
			end
		end

		while true do
			mSleep(200)
			if getColor(328,1175) == 0 and getColor(328,1175) == 0 then
				mSleep(500)
				randomTap(328,1175,4)
				mSleep(500)
			end

			mSleep(200)
			if getColor(258,84) == 0xefefef and getColor(249,199) == 0 then
				mSleep(500)
				randomTap(418,185,4)
				mSleep(500)
			end

			mSleep(200)
			if getColor(426,97) == 0x2f2f2f and getColor(311,92) == 0x2f2f2f then
				mSleep(500)
				randomTap(95,221,4)
				mSleep(500)
				break
			end
		end

		while true do
			mSleep(200)
			if getColor(426,97) == 0x2f2f2f and getColor(311,92) == 0x2f2f2f then
				mSleep(500)
				randomTap(95,221,4)
				mSleep(500)
			end

			mSleep(200)
			if getColor(580,1276) == 0 and getColor(663,1272) == 0xffffff then
				mSleep(500)
				randomTap(663,1272,4)
				mSleep(500)
				break
			end
		end
	end

	::aodi::
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
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://47.104.246.33/onlinesim.php?cmd=getphone&apikey="..getPhone_key.."&service=WeChat&country="..country_num)
		if #res > 10 then
			tmp = json.decode(res)
			if tmp.country == country_num then
				tzid = tmp.tzid
				service_phone = tmp.number
				phone_country = tmp.country
			else
				toast("获取不到国家取号，重新取号:"..tostring(res),1)
				mSleep(2000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "1" then
		::get_phone::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://simsms.org/priemnik.php?metod=get_number&country="..SMS_country.."&service=opt67&apikey=Zn8GvDXIzN6iRiJyZIc4tmJS0Ziidv")
		if code == 200 then
			tmp = json.decode(res)
			if tmp.response == "1" then
				toast(tmp.number, 1)
				toast(tmp.CountryCode, 1)
				toast(tmp.id, 1)
				pay_id = tmp.id
			else
				toast("获取不到国家取号，重新取号:"..tostring(res),1)
				mSleep(30000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..tostring(res),1)
			mSleep(30000)
			goto get_phone
		end
	elseif api_change == "2" or api_change == "10" or api_change == "12" then
		if api_change == "10" then
			url = "http://web.jiemite.com"
		elseif api_change == "2" then
			url = "http://api.ma37.com"
		elseif api_change == "12" then
			url = "http://27.124.4.13"
		end

		::file_bool::
		bool = self:file_exists(userPath().."/res/phone_data.txt")
		if bool then
			phone_data = readFile(userPath().."/res/phone_data.txt")
			toast(phone_data[1],1)
			if type(phone_data[1]) ~= "nil" then
				mobile = phone_data[1]
				toast("号码文件有号码",1)
				::get_phone::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(url.."/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..work_id.."&mobile="..mobile)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						if api_change == "10"  then
							telphone = data[4]
						elseif api_change == "2" or api_change == "12" then
							telphone = data[5]
							pid = data[2]
						end
					else
						toast("获取手机号码失败，重新获取:"..tostring(res),1)
						mSleep(1000)
						goto get_phone
					end
				else
					toast("获取手机号码失败，重新获取:"..tostring(res),1)
					mSleep(1000)
					goto get_phone
				end
			else
				::get_phone::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(url.."/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..work_id)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						if api_change == "10" then
							telphone = data[4]
						elseif api_change == "2" or api_change == "12" then
							telphone = data[5]
							pid = data[2]
						end
						toast(telphone,1)
						writeFileString(userPath().."/res/phone_data.txt",telphone,"w",0)
						writeFileString(userPath().."/res/phone_loginTime.txt","0","w",0)
						toast("号码记录成功",1)
					else
						toast("获取手机号码失败，重新获取:"..tostring(res),1)
						mSleep(1000)
						goto get_phone
					end
				else
					toast("获取手机号码失败，重新获取:"..tostring(res),1)
					mSleep(1000)
					goto get_phone
				end
			end
		else
			toast("文件不存在，创建文件",1)
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			goto file_bool
		end
	elseif api_change == "3" then
		::get_token::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://47.56.103.47/api.php?action=Login&user="..username.."&pwd="..user_pass)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				tokens = data[2]
			else
				toast("请求接口或者参数错误,脚本重新运行:"..tostring(res),1)
				lua_restart()
			end
		else
			toast("获取token失败，重新获取:"..tostring(res),1)
			mSleep(1000)
			goto get_token
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://47.56.103.47/api.php?action=GetNumber&token="..tokens.."&pid="..work_id)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				telphone = data[2]
			elseif data[1] == "no" then
				toast("暂无号码",1)
				mSleep(1000)
				goto get_phone
			else
				toast("请求接口或者参数错误，脚本重新运行:"..tostring(res),1)
				lua_restart()
			end
		else
			toast("获取手机号码失败，重新获取:"..tostring(res),1)
			mSleep(1000)
			goto get_phone
		end
	elseif api_change == "4" then
		::get_token::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://129.204.138.57:11223/api/Camel/login?uname="..username.."&upwd="..user_pass)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.Status == 200 then
				tokens = tmp.Data.TOKEN
			else
				toast("请求接口或者参数错误,脚本重新运行:"..tmp.Msg,1)
				lua_restart()
			end
		else
			toast("获取token失败，重新获取:"..tostring(res),1)
			mSleep(1000)
			goto get_token
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://129.204.138.57:11223/api/Camel/getphone?token="..tokens.."&rid="..work_id.."&idn="..SMS_country)
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
			toast("获取手机号码失败，重新获取:"..tostring(res),1)
			mSleep(1000)
			goto get_phone
		end
	elseif api_change == "5" then
		::get_phone::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://opapi.sms-5g.com/out/ext_api/getMobile?name="..username.."&pwd="..user_pass.."&cuy="..SMS_country.."&pid="..work_id.."&num=1&noblack=1&serial=2&secret_key="..getPhone_key)
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
			toast("获取手机号码失败，重新获取:"..tostring(res),1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "6" then
		::file_bool::
		bool = self:file_exists(userPath().."/res/phone_data.txt")
		if bool then
			phone_data = readFile(userPath().."/res/phone_data.txt")
			toast(phone_data[1],1)
			if type(phone_data[1]) ~= "nil" then
				telphone = phone_data[1]
				toast("号码文件有号码",1)
			else
				::get_user::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/api.php?cmd=balance&token="..getPhone_key.."&username="..username)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.msg == "success" then
						mSleep(200)
						if tonumber(tmp.data) > 0 then
							toast("当前余额:"..tmp.data,1)
							mSleep(2000)
						else
							toast("当前余额不足",1)
							mSleep(3000)
							goto get_user
						end
					else
						mSleep(500)
						toast("获取信息失败，重新获取:"..tostring(res),1)
						mSleep(5000)
						goto get_user
					end
				else
					toast("获取信息失败，重新获取",1)
					mSleep(10000)
					goto get_user
				end

				::get_phone::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/api.php?cmd=mobile&token="..getPhone_key.."&src=tl&app=WeChat&username="..username)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.msg == "success" then
						mSleep(200)
						telphone = tmp.data
						toast(telphone,1)
						writeFileString(userPath().."/res/phone_data.txt",telphone,"w",0)
						writeFileString(userPath().."/res/phone_loginTime.txt","0","w",0)
						toast("号码记录成功",1)
					else
						mSleep(500)
						toast("获取手机号码失败，重新获取",1)
						mSleep(5000)
						goto get_phone
					end
				else
					toast("获取手机号码失败，重新获取",1)
					mSleep(10000)
					goto get_phone
				end
			end
		else
			toast("文件不存在，创建文件",1)
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			goto file_bool
		end
	elseif api_change == "7" then
		::file_bool::
		bool = self:file_exists(userPath().."/res/phone_data.txt")
		if bool then
			phone_data = readFile(userPath().."/res/phone_data.txt")
			toast(phone_data[1],1)
			if type(phone_data[1]) ~= "nil" then
				phoneData = strSplit(phone_data[1], "|")
				telphone = phoneData[1]
				codeUrl = phoneData[2]
				toast("号码文件有号码",1)
			else
				::get_phone::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=getphone")
				if code == 200 then
					tmp = strSplit(res, "|")
					if #tmp == 2 then
						telphone = tmp[1]
						codeUrl = tmp[2]
						writeFileString(userPath().."/res/phone_data.txt",res,"w",0)
						writeFileString(userPath().."/res/phone_loginTime.txt","0","w",0)
						toast("号码记录成功",1)
					else
						toast("获取不到国家取号，重新取号:"..tostring(res),1)
						mSleep(30000)
						goto get_phone
					end
				else
					toast("获取手机号码失败，重新获取:"..tostring(res),1)
					mSleep(5000)
					goto get_phone
				end
			end
		else
			toast("文件不存在，创建文件",1)
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			goto file_bool
		end
	elseif api_change == "8" then
		::file_bool::
		bool = self:file_exists(userPath().."/res/phone_data.txt")
		if bool then
			phone_data = readFile(userPath().."/res/phone_data.txt")
			toast(phone_data[1],1)
			if type(phone_data[1]) ~= "nil" then
				phoneData = strSplit(phone_data[1], "|")
				telphone = phoneData[1]
				codeUrl = phoneData[2]
				toast("号码文件有号码",1)
			else
				::get_phone::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=getphone")
				if code == 200 then
					tmp = strSplit(res, "|")
					if #tmp == 2 then
						telphone = tmp[1]
						codeUrl = tmp[2]
						writeFileString(userPath().."/res/phone_data.txt",res,"w",0)
						writeFileString(userPath().."/res/phone_loginTime.txt","0","w",0)
						toast("号码记录成功",1)
					else
						toast("获取不到国家取号，重新取号:"..tostring(res),1)
						mSleep(30000)
						goto get_phone
					end
				else
					toast("获取手机号码失败，重新获取:"..tostring(res),1)
					mSleep(5000)
					goto get_phone
				end
			end
		else
			toast("文件不存在，创建文件",1)
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			goto file_bool
		end
	elseif api_change == "9" or api_change == "11" then
		if api_change == "9" then
			url = "http://www.phantomunion.com:10023/pickCode-api/push/ticket?key="..getPhone_key
		elseif api_change == "11" then
			url = "http://cucumber.bid/bbq-cu-api/push/ticket?key="..getPhone_key
		end

		::get_token::
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60)
		status_resp, header_resp, body_resp =
		ts.httpGet(
			url,
			header_send,
			body_send
		)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.code == "200" then
				tokens = tmp.data.token
				toast(tokens,1)
				mSleep(1000)
			else
				toast(tmp.message, 1)
				mSleep(3000)
				goto get_token
			end
		else
			toast(body_resp, 1)
			mSleep(3000)
			goto get_token
		end

		if api_change == "9" then
			url = "http://www.phantomunion.com:10023/pickCode-api/push/buyCandy?token="..tokens.."&businessCode=10012&quantity=1&country="..SMS_country.."&effectiveTime=10"
		elseif api_change == "11" then
			url = "http://cucumber.bid/bbq-cu-api/push/buyLcCandy?token="..tokens.."&businessCode=10012&quantity=1&country="..SMS_country
		end

		::get_phone::
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60)
		status_resp, header_resp, body_resp =
		ts.httpGet(
			url,
			header_send,
			body_send
		)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.code == "200" then
				if tonumber(tmp.data.balance) > 1 then
					telphone = tmp.data.phoneNumber[1].number
					serialNumber = tmp.data.phoneNumber[1].serialNumber
					toast(telphone.."\r\n"..serialNumber,1)
					mSleep(1000)
				else
					dialog("幻影平台余额低于1,充值完点击确定重新请求号码",0)
					mSleep(2000)
					goto get_phone
				end
			else
				toast(tmp.message, 1)
				mSleep(3000)
				goto get_phone
			end
		else
			toast(body_resp, 1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "13" then
		::get_phone::
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60)
		status_resp, header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/tqsc&sjk=qij",header_send,body_send)
		if status_resp == 200 then
			if tonumber(body_resp) then
				telphone = string.gsub(body_resp,"%s+","") 
				toast(telphone,1)
				mSleep(1000)
			else
				toast(body_resp, 1)
				mSleep(3000)
				goto get_phone
			end
		else
			toast(body_resp, 1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "14" then
		::login::
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60)
		status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/Login?User=" .. username .. "&Password=" .. user_pass .. "&Logintype=0",header_send,body_send)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.code == "0" or tmp.code == 0 then
				yzm_token = tmp.data.Token
			else
				toast(tmp.msg, 1)
				mSleep(3000)
				goto login
			end
		else
			toast(body_resp, 1)
			mSleep(3000)
			goto login
		end

		::get_phone::
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60)
		status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/GetPhoneNumber?Token=" .. yzm_token .. "&ItemId=" .. work_id,header_send,body_send)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.code == "0" or tmp.code == 0 then
				telphone = tmp.data.Phone
				MSGID = tmp.data.MSGID
			else
				toast(tmp.msg, 1)
				mSleep(3000)
				goto login
			end
		else
			toast(body_resp, 1)
			mSleep(3000)
			goto get_phone
		end
	elseif api_change == "15" then
		later_phone = self:randomStr("1234567890", 5)
		telphone = simulation_phone .. later_phone
	end

	if country_id == "0" then
		--昵称
		while true do
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0,"7|2|0,20|-2|0,22|-9|0,40|15|0,55|3|0,58|-5|0", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x+300,y+3)
				mSleep(math.random(500, 700))
				break
			end
		end

		if nickName == "0" then  --英文
			nickName = self:randomStr("`~#^&*-=!@$;/|QWERTYUIOPASDF`~#^&*-=!@$;/|GHJKLZXCVBNM`~#^&*-=!@$;/|qwertyuiopasd`~#^&*-=!@$;/|fghjklzxcvbnm`~#^&*-=!@$;/|", math.random(7, 10))
			--检测是否有删除按钮
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
				toast(y, 1)
				if x~=-1 and y~=-1 then
					break
				else
					mSleep(500)
					inputStr(nickName)
					mSleep(500)
					toast("输入昵称",1)
				end
			end
		elseif nickName == "1" then  --特殊符号
			--			inputStr("르㸏مฬ้๊سمرًς.έل")

			--检测是否有删除按钮
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
				toast(y, 1)
				if x~=-1 and y~=-1 then
					break
				else
					mSleep(500)
					inputStr("@")
					mSleep(500)
					toast("输入昵称",1)
				end
			end
		end
	end

	--国家／地区
	while (true) do
		--10
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x1a1a1a,"22|0|0x1a1a1a,27|27|0x1a1a1a,0|24|0x1a1a1a,14|12|0x1a1a1a,36|5|0x1a1a1a,64|4|0x1a1a1a", 90, 0, 0, 749, 431)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x+120,y+90, 6)
			mSleep(math.random(500, 700))
			break
		end
		--11
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0,"27|26|0,3|25|0,17|-2|0,14|6|0,35|2|0,63|1|0", 90, 0, 0, 749, 701)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x+120,y+90, 6)
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
	mSleep(200)
	if api_change == "0" or api_change == "2" or api_change == "3" or api_change == "4" 
	or api_change == "5" or api_change == "6" or api_change == "7" or api_change == "8" 
	or api_change == "9" or api_change == "10" or api_change == "11" or api_change == "12" 
	or api_change == "13" or api_change == "14" or api_change == "15" then
		country_num = phone_country
	elseif api_change == "1" then
		country_num = tmp.CountryCode
	end

	mSleep(200)
	for i = 1, #(country_num) do
		mSleep(math.random(500, 700))
		num = string.sub(country_num,i,i)
		if num == "0" then
			randomTap(373, 1281, 8)
		elseif num == "1" then
			randomTap(132,  955, 8)
		elseif num == "2" then
			randomTap(377,  944, 8)
		elseif num == "3" then
			randomTap(634,  941, 8)
		elseif num == "4" then
			randomTap(128, 1063, 8)
		elseif num == "5" then
			randomTap(374, 1061, 8)
		elseif num == "6" then
			randomTap(628, 1055, 8)
		elseif num == "7" then
			randomTap(119, 1165, 8)
		elseif num == "8" then
			randomTap(378, 1160, 8)
		elseif num == "9" then
			randomTap(633, 1164, 8)
		end
	end

	--密码
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "15|-4|0x1a1a1a,28|0|0x1a1a1a,14|17|0x1a1a1a,3|20|0x1a1a1a,25|18|0x1a1a1a,37|15|0x1a1a1a,53|-5|0x1a1a1a,58|16|0x1a1a1a,83|9|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x+400,y-70,8)
			mSleep(500)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x+400,y-70,8)
			mSleep(500)
			break
		end
	end

	if api_change == "0" then
		if country_id == "0" then
			phone = string.sub(service_phone,5,#service_phone)
		else
			phone = string.sub(service_phone,4,#service_phone)
		end
	elseif api_change == "1" then
		phone = tmp.number
	elseif api_change == "2" or api_change == "10" or api_change == "12" then
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
	elseif api_change == "3"  or api_change == "7" or api_change == "8" or api_change == "13" or api_change == "15" then
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
	elseif api_change == "6" or api_change == "9" or api_change == "11" then
		if api_change == "11" then
			telphone = string.match(telphone,"%d+")
		end

		phone = string.sub(telphone, #country_num + 1 ,#telphone)
	elseif api_change == "14" then
		phone = string.sub(telphone, #country_num + 2 ,#telphone)
	end

	for i = 1, #phone do
		num = string.sub(phone,i,i)
		mSleep(500)
		if num == "0" then
			tap(373, 1281)
		elseif num == "1" then
			tap(132,  955)
		elseif num == "2" then
			tap(377,  944)
		elseif num == "3" then
			tap(634,  941)
		elseif num == "4" then
			tap(128, 1063)
		elseif num == "5" then
			tap(374, 1061)
		elseif num == "6" then
			tap(628, 1055)
		elseif num == "7" then
			tap(119, 1165)
		elseif num == "8" then
			tap(378, 1160)
		elseif num == "9" then
			tap(633, 1164)
		end
		mSleep(100)
	end

	if password == "0" then
		password = "vip"..string.sub(phone,#phone-4,#phone)
	elseif password == "1" then
		password = self:randomStr("qwertyuiopasdfghjklzxcvbnm", 4)..self:randomStr("1234567890",4)
	elseif password == "2" then
		password = "llmm"..string.sub(phone,#phone-3,#phone)
	end
    
    writePasteboard(password)
	--密码
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "15|-4|0x1a1a1a,28|0|0x1a1a1a,14|17|0x1a1a1a,3|20|0x1a1a1a,25|18|0x1a1a1a,37|15|0x1a1a1a,53|-5|0x1a1a1a,58|16|0x1a1a1a,83|9|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x+400,y,8)
			mSleep(math.random(1000, 1700))
            keyDown("RightGUI") 
            keyDown("v")
            keyUp("v")
            keyUp("RightGUI")
			mSleep(math.random(500, 700))
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x+400,y,8)
			mSleep(math.random(1000, 1700))
			keyDown("RightGUI") 
            keyDown("v")
            keyUp("v")
            keyUp("RightGUI")
			mSleep(math.random(500, 700))
			break
		end
	end

	::change_again::
	if localNetwork == "1" then
-- 		if vpn_country == "0" then
-- 			self:changeGNIP(ip_userName,place_id,iptimes)
-- 		elseif vpn_country == "1" then
-- 			self:changeGWIP(ip_userName,ip_country)
-- 		end

		if fz_type ~= "3" then
			ip = self:vpn()
			toast(ip,1)
			mSleep(800)
		end
	end

	if wc_version == "1" then
		--点击协议
		while (true) do
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x+19,y+164,4)
				mSleep(500)
				break
			end
		end
	end

	next_again_time = 0
	againLogin_bool = false
	set_vpn =false
	cheack_bool = true

	::next_again::
	if againLogin_bool then
		phone_loginTime = readFile(userPath().."/res/phone_loginTime.txt")
		if tonumber(phone_loginTime[1]) < tonumber(fz_error_times) then
			writeFileString(userPath().."/res/phone_loginTime.txt",tostring(tonumber(phone_loginTime[1]) + 1),"w",0)
			toast("辅助失败，号码返回重新注册:"..phone_loginTime[1],1)
			mSleep(1000)
			if localNetwork == "1" then
				setVPNEnable(true)
				mSleep(2000)
			end
		else
			if api_change == "2" or api_change == "10" or api_change == "12" then
				if api_change == "10" then
					black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
				elseif api_change == "2" then
					black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				elseif api_change == "12" then
					black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				end

				::addblack::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(black_url)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
					elseif data[2] == "-5" then
						if api_change == "12" then
							black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						elseif api_change == "2" then
							black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						end
					else
						toast(res,1)
						mSleep(2000)
						goto addblack
					end
				end
			elseif api_change == "7" then
				::push::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=poststatus&phone="..phone.."&status=失败")
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("号码标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "8" then
				::push::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=poststatus&phone="..phone.."&status=失败")
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("号码标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "9" or api_change == "11" then
				if api_change == "9" then
					url = "http://www.phantomunion.com:10023/pickCode-api/push/redemption?token="..tokens.."&serialNumber="..serialNumber.."&feedbackType=A&description=fail"..telphone
				elseif api_change == "11" then
					url = "http://cucumber.bid/bbq-cu-api/push/redemption?token="..tokens.."&feedbackType=B&serialNumber="..serialNumber.."&description=fail"..telphone
				end

				::get_fail::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp =
				ts.httpGet(
					url,
					header_send,
					body_send
				)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "200" then
						if tmp.data == "SUCCESS" or tmp.message == "success" then
							toast("拉黑成功",1)
							mSleep(1000)
						else
							toast("拉黑失败"..tostring(body_resp),1)
							mSleep(2000)
							goto get_fail
						end
					else
						toast(tmp.message, 1)
						mSleep(3000)
						goto get_fail
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto get_fail
				end
			elseif api_change == "13" then
				::push::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/huan_cun&mingzi="..phone.."&nr=0",header_send,body_send)
				if status_resp == 200 then
					if tonumber(body_resp) == 1 then
						toast("号码清除成功",1)
						mSleep(1000)
					else
						toast(body_resp, 1)
						mSleep(3000)
						goto push
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "14" then
				::AddBlackPhone::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/AddBlackPhone?Token=" .. yzm_token .. "&MSGID=" .. MSGID,header_send,body_send)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "0" or tmp.code == 0 then
						toast(tmp.msg, 1)
						mSleep(1000)
					else
						toast(tmp.msg, 1)
						mSleep(3000)
						goto AddBlackPhone
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto AddBlackPhone
				end
			end
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			toast("超过"..fz_error_times.."次注册失败，重新获取注册",1)
			goto over
		end
	end

	--协议后下一步
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-63|12|0x07c160,128|13|0x07c160,54|13|0xffffff,295|-2|0x07c160,-262|6|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x,y,10)
			mSleep(math.random(500, 700))
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"540|-7|0x9ce6bf,270|30|0x9ce6bf,270|-89|0x576b95",90,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x+100,y,10)
			mSleep(math.random(500, 700))
			break
		end
	end

	erweima_bool = false
	::erweima::
	if erweima_bool then
		if country_id == "0" then
			mSleep(math.random(500, 700))
			randomTap(373, 1035,10)
			mSleep(math.random(500, 700))
		else
			mSleep(math.random(500, 700))
			randomTap(373, 769,10)
			mSleep(math.random(500, 700))
		end
		erweima_bool = false
	end

	--隐秘政策
	time = 0
	net_check = true

	while (true) do
		if set_vpn then
			if needConnetMove == "0" then
				if connet_bool then
					connet_bool = false

					::connet::
					connetBool = self:connetMoveHttp(liandongName)
					if not connetBool then
						if api_change == "2" or api_change == "10" or api_change == "12" then
							if api_change == "10" then
								url = "http://web.jiemite.com"
							elseif api_change == "2" then
								url = "http://api.ma37.com"
							elseif api_change == "12" then
								url = "http://27.124.4.13"
							end

							::get_phone::
							local sz = require("sz")        --登陆
							local szhttp = require("szocket.http")
							local res, code = szhttp.request(url.."/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..work_id.."&mobile="..telphone)
							if code == 200 then
								data = strSplit(res, "|")
								if data[1] == "1" then
									toast("获取手机号码成功",1)
									mSleep(1000)
									goto connet
								else
									toast("获取手机号码失败，重新获取:"..tostring(res),1)
									mSleep(1000)
									goto get_phone
								end
							else
								toast("获取手机号码失败，重新获取:"..tostring(res),1)
								mSleep(1000)
								goto get_phone
							end
						else
							toast("等待指令",1)
							mSleep(5000)
							goto connet
						end
					end
				end
			end
		end

		if country_num == "86" then
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0xd8f0d8,"-254|21|0x9ed99d,368|13|0x9ed99d,61|-20|0x9ed99d,49|46|0x9ed99d",100, 0, 920, 749, 1333)
			if x~=-1 and y~=-1 then
				if not cheack_bool then
					flag = getVPNStatus()
					if not flag.active then
						self:changeGWIP(ip_userName,ip_country)
					end

					if set_vpn then
						ip = self:vpn()
						toast(ip,1)
						mSleep(500)
					end
				end
				mSleep(500)
				randomTap(x-277, y-100,1)
				mSleep(math.random(700, 1500))
				break
			else
				time = time + 1
				toast("等待隐秘政策"..time,1)
				mSleep(1000)
			end
		else
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0xc2c2c2,"13|19|0xc2c2c2,52|12|0xc2c2c2,83|0|0xc2c2c2,84|16|0xc2c2c2,-111|-5|0xf2f2f2,219|43|0xf2f2f2,274|18|0xededed,-172|9|0xededed", 100, 0, 920, 749, 1333)
			if x~=-1 and y~=-1 then
				if not cheack_bool then
					flag = getVPNStatus()
					if not flag.active then
						self:changeGWIP(ip_userName,ip_country)
					end

					if set_vpn then
						ip = self:vpn()
						toast(ip,1)
						mSleep(500)
					end
				end
				mSleep(500)
				randomTap(x - 240, y-95,1)
				mSleep(500)
				break
			else
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xc2c2c2, "-148|-7|0xf2f2f2,140|2|0xf2f2f2,245|2|0xededed,-175|6|0xf2f2f2", 100, 0, 920, 749, 1333)
				if x~=-1 and y~=-1 then
				    if not cheack_bool then
    					flag = getVPNStatus()
    					if not flag.active then
    						self:changeGWIP(ip_userName,ip_country)
    					end
    
    					if set_vpn then
    						ip = self:vpn()
    						toast(ip,1)
    						mSleep(500)
    					end
				    end
					mSleep(500)
					randomTap(x, y-112,1)
					mSleep(500)
					break
				else
					time = time + 1
					toast("等待隐秘政策"..time,1)
					mSleep(1000)
				end
			end
		end

		--欧盟国家需要多下一步
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xffffff,"37|5|0xffffff,-108|11|0x7c160,37|-16|0x7c160,182|8|0x7c160,42|34|0x7c160", 100, 0, 1000, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x, y,5)
			mSleep(math.random(500, 700))
			toast("欧盟国家下一步",1)
		end

		--无效手机号码
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|1|0x576b95,-38|-232|0,20|-223|0,-195|149|0x36030,159|133|0x36030", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomTap(x, y, 1)
			mSleep(math.random(3000, 5000))
			toast("手机号码错误",1)
			if api_change == "2" or api_change == "10" or api_change == "12" then
				if api_change == "10" then
					black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
				elseif api_change == "2" then
					black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				elseif api_change == "12" then
					black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				end

				::addblack::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(black_url)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
					elseif data[2] == "-5" then
						if api_change == "12" then
							black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						elseif api_change == "2" then
							black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						end
					else
						toast(res,1)
						mSleep(2000)
						goto addblack
					end
				end
			end
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			lua_restart()
		end

		if net_check then
			--网络出错，轻触屏幕重新加载
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0xc9c9c9,"16|156|0xc9c9c9,-18|151|0xc9c9c9,-66|105|0xc9c9c9,-56|29|0xc9c9c9,36|6|0xc9c9c9,64|130|0xc9c9c9,2|79|0xffffff,22|-251|0xefeff4", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				setVPNEnable(false)
				mSleep(2000)
				self:changeGWIP(ip_userName,ip_country)
				mSleep(math.random(2000, 3000))
				if localNetwork == "1" then
					setVPNEnable(true)
				end
				mSleep(math.random(4000, 7000))
				randomTap(x, y, 1)
				mSleep(math.random(3000, 5000))
				toast("网络出错，轻触屏幕重新加载",1)
				net_check = false
				time = 0
			end
		else
			if time > 40 then
				lua_restart()
			end
		end

		if net_check then
			if time > 40 then
				lua_restart()
			end
		end
	end

	ys_next = 0
	--隐秘政策：下一步
	while (true) do
		if country_num == "86" then
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0xd8f0d8,"-254|21|0x9ed99d,368|13|0x9ed99d,61|-20|0x9ed99d,49|46|0x9ed99d",100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x-277, y-100,1)
				mSleep(500)
			end
		else
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x-240, y-112,1)
				mSleep(500)
			else
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xc2c2c2, "-148|-7|0xf2f2f2,140|2|0xf2f2f2,245|2|0xededed,-175|6|0xf2f2f2", 100, 0, 1145, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					randomTap(x, y-98,1)
					mSleep(500)
				end
			end
		end

		mSleep(200)
		if getColor(272,1235) == 0x1aad19 then
			mSleep(500)
			randomTap(272,1235,10)
			mSleep(500)
			toast("隐秘政策同意，下一步",1)
			mSleep(1000)
			ys_next = ys_next + 1
		end

		mSleep(200)
		if getColor(300, 1201) == 0x07c160 then
			mSleep(500)
			randomTap(370, 1204,10)
			mSleep(500)
			toast("下一步",1)
			mSleep(1000)
			ys_next = ys_next + 1
		end

		--欧盟国家
		mSleep(200)
		if getColor(289,1106) == 0x7c160 and getColor(372,1107) == 0xffffff then
			mSleep(500)
			randomTap(289,1108,10)
			mSleep(500)
			toast("下一步2",1)
			ys_next = ys_next + 1
		end

		mSleep(200)
		if getColor(353,  287) == 0x10aeff and getColor(304, 1105) == 0x07c160 then
			toast("准备安全验证",1)
			mSleep(1000)
			break
		end

		--无效手机号码
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|1|0x576b95,-38|-232|0,20|-223|0,-195|149|0x36030,159|133|0x36030", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomTap(x, y,1)
			mSleep(math.random(3000, 5000))
			toast("手机号码错误",1)
			if api_change == "2" or api_change == "10" or api_change == "12" then
				if api_change == "10" then
					black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
				elseif api_change == "2" then
					black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				elseif api_change == "12" then
					black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				end

				::addblack::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(black_url)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
					elseif data[2] == "-5" then
						if api_change == "12" then
							black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						elseif api_change == "2" then
							black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						end
					else
						toast(res,1)
						mSleep(2000)
						goto addblack
					end
				end
			end
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			lua_restart()
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "-28|5|0x576b95,17|-156|0x000000,-147|-170|0x000000,169|-95|0xf9f7fa", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomTap(x, y,1)
			mSleep(500)
			toast("连接失败",1)
			mSleep(1000)
			goto next_again
		end

		if ys_next > 40 then
			mSleep(500)
			lua_restart()
		else
			mSleep(1000)
			toast("隐私下一步："..ys_next,1)
			ys_next = ys_next + 1
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
		if status_resp == 200 then
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
	elseif fz_type == "8" then
		hk_url = self:get_hkUrl(country_num)
		hk_url = urlEncoder(hk_url)
		toast(hk_url,1)
	end

	--安全验证
	::get_pic::
	safe_time = 0
	while (true) do
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if hk_way == "1" then
				mSleep(500)
				randomTap(372, 1105,10)
			end
			mSleep(500)
			randomTap(372, 1105,10)
			mSleep(500)
			break
		else
			toast("安全验证等待："..safe_time,1)
			mSleep(1000)
			safe_time = safe_time + 1
		end

		if safe_time > 40 then
			lua_restart()
		end
	end

	if cheack_bool then
		if fz_type == "3" then
			while (true) do
				mSleep(200)
				if getColor(118,  948) == 0x007aff then
					mSleep(500)
					randomTap(56, 81, 8)
					mSleep(math.random(500, 700))
					break
				end

				mSleep(200)
				x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					randomTap(372, 1105,6)
					mSleep(500)
				end
			end
			toast("跳马注册",1)
			set_vpn = true
			cheack_bool = false
			goto next_again
		end
	end

	::hk::
	if hk_way == "0" then
		--滑块
		safe = 0
		hk_time = 0
		while (true) do
			mSleep(200)
			if getColor(118,  948) == 0x007aff then
				x_lens = self:moves()
				if tonumber(x_lens) > 0 then
					mSleep(500)
					moveTowards( 108,  952, 0, x_len-75)
					mSleep(3000)
				else
					mSleep(500)
					randomTap(689, 1032,10)
					mSleep(math.random(3000, 6000))
					goto get_pic
				end
				break
			else
				toast("滑块等待："..hk_time,1)
				mSleep(1000)
				hk_time = hk_time + 1
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x000000, "-8|9|0x000000,12|1|0x000000,12|14|0x000000,-1|18|0x000000,27|21|0x000000,50|21|0x000000,18|11|0xffffff,538|558|0xb3b3b3", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 600, y + 569)
				mSleep(500)
				goto get_pic
			end

			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(372, 1105,10)
				mSleep(500)
				toast("安全验证",1)
				safe = safe + 1
			end

			if safe > 40 then
				mSleep(500)
				randomTap(56, 81, 8)
				mSleep(math.random(500, 700))
				goto next_again
			else
				toast("安全验证等待"..safe,1)
				mSleep(1000)
			end

			if hk_time > 40 then
				lua_restart()
			end

		end
	end

	if fz_type == "0" or fz_type == "7" or fz_type == "9" or fz_type == "10" or fz_type == "11" or fz_type == "12" then
		if fz_type == "7" then
			toast("手动上传辅助二维码",1)
		end

		--二维码识别
		while (true) do
			mSleep(200)
			if getColor(132,  766) == 0x000000 and getColor(132, 1058) == 0x000000 then
				imgDecode = false

				mSleep(math.random(500, 700))
				snapshot("1.png", 109,  701, 442, 1073)
				mSleep(math.random(1000, 1500))

				local newImage,msg = image.loadFile(userPath() .. "/res/1.png")
				if image.is(newImage) then
					--解析图片
					toast("准备解析图片",1)
					mSleep(1000)
					local str,msg = image.qrDecode(newImage)
					if msg == "" then
						ewm_url = str
						toast(ewm_url,1)
						mSleep(1000)
						ewm_url_bool =  true
					else
						toast(msg,1)
						mSleep(1000)
						imgDecode = true
					end
				else
					toast(msg,1)
					mSleep(1000)
					imgDecode = true
				end

				if imgDecode then
					::ewm_go::
					url = "https://upload.api.cli.im/upload.php?kid=cliim";
					local _file1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="Filedata"; filename="1.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
					aa = self:imgupload2(url, userPath() .. "/res/1.png",_file1);
					if aa ~= nil then
						local tmp = json.decode(aa)["data"]["path"]
						toast(tmp,1)
						header_send = {
							["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
						}
						body_send = {
							["img"] = tmp,
						}
						ts.setHttpsTimeOut(60)
						code,header_resp, body_resp = ts.httpsPost("https://cli.im/apis/up/deqrimg", header_send,body_send)
						toast(body_resp, 1)
						mSleep(1000)
						if code == 200 then
							function decodeJson() 
								return json.decode(body_resp)
							end

							local status, err = pcall(decodeJson)
							if status then
								if type(err) ~= "nil" then
									local tmp = err
									ewm_url = tmp["info"]["data"][1]
									toast(ewm_url,1)
									mSleep(1000)
									ewm_url_bool =  true
								else
									toast("json解析失败，重新解析", 1)
									mSleep(2000)
									randomTap(56,83,3)
									mSleep(500)
									goto next_again
								end
							else
								toast("json解析失败，重新解析", 1)
								mSleep(2000)
								randomTap(56,83,3)
								mSleep(500)
								goto next_again
							end
						else
							toast("二维码解析失败:"..tostring(body_resp),1)
							mSleep(6000)
							snaPicError = true
							goto ewm_go
						end
					else
						toast("二维码图片上传失败:"..tostring(aa),1)
						mSleep(1000)
						goto ewm_go
					end
				end

				if fz_type == "7" then
					header_send = {
						["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
					}
					body_send = {
						["token"] = fz_key,
						["qr"] = ewm_url,
						["cd"] = self.phoneDevice.."号",
					}
					ts.setHttpsTimeOut(60)
					code,header_resp, body_resp = ts.httpsPost("http://106.15.248.73/index.php/api/qr/add", header_send,body_send)
					if code == 200 then
						local tmp = json.decode(body_resp)
						if tmp.msg == "success" then
							ewm_id = tmp.id
							toast(ewm_id, 1)
						end
					else
						toast("链接提交失败:"..tostring(body_resp),1)
						mSleep(6000)
					end
				end

				--				base_six_four = self:readFileBase64(userPath().."/res/1.png") 
				--				::ewm_go::
				--				header_send = {
				--					["Content-Type"] = "application/x-www-form-urlencoded",
				--				}
				--				body_send = {
				--					["base64"] = urlEncoder("data:image/png;base64,"..base_six_four),
				--				}
				--				ts.setHttpsTimeOut(60)
				--				code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/decode", header_send,body_send)
				--				if code == 200 then
				--					ewm_url = body_resp  
				--					toast(ewm_url,1)
				--					mSleep(1000)
				--					ewm_url_bool =  true
				--				else
				--					toast("二维码失败失败:"..body_resp,1)
				--					mSleep(6000)
				--					snaPicError = true
				--					goto ewm_go
				--				end
				break
			end

			if hk_way == "0" then
				mSleep(200)
				if getColor(118,  948) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomTap(603, 1032,5)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end

			if api_change == "7" or api_change == "8" or api_change == "9" or api_change == "11" or api_change == "13" or api_change == "14" then
				mSleep(200)
				x, y = findMultiColorInRegionFuzzy(0x576b95,"-38|1|0x576b95,-314|-9|0x181819,-356|-3|0x181819,-157|-155|0,24|-174|0",90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					toast("操作频繁",1)
					mSleep(500)
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					goto gg
				end
			end
		end
	elseif fz_type == "3" then
		while (true) do
			mSleep(200)
			if getColor(132, 766) == 0x000000 and getColor(54,648) == 0x808080 or getColor(44, 1286) == 0x576b95 and getColor(121, 1281) == 0x576b95 then
				next_again_time = next_again_time + 1
				if next_again_time >= tonumber(fz_error_times) then
					if api_change == "2" or api_change == "10" or api_change == "12" then
						if api_change == "10" then
							black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
						elseif api_change == "2" then
							black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
						elseif api_change == "12" then
							black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
						end

						::addblack::
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request(black_url)
						toast(res,1)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								toast("拉黑手机号码",1)
							elseif data[2] == "-5" then
								if api_change == "12" then
									black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
									goto addblack
								elseif api_change == "2" then
									black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
									goto addblack
								end
							else
								toast(res,1)
								mSleep(2000)
								goto addblack
							end
						end
					elseif api_change == "4" then
						::addblack::
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://129.204.138.57:11223/api/Camel/addblack?token="..tokens.."&skey="..skey)
						if code == 200 then
							tmp = json.decode(res)
							if tmp.Status == 200 then
								toast("跳马失败加黑手机号码",1)
								mSleep(1000)
							else
								goto addblack
							end
						end
					elseif api_change == "5" then
						::addblack::
						local sz = require("sz")        --登陆
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://opapi.sms-5g.com//out/ext_api/addBlack?name="..username.."&pwd="..user_pass.."&pn="..telphone.."&pid="..work_id)
						if code == 200 then
							tmp = json.decode(res)
							if tmp.code == 200 or tmp.code == "200" then
								toast("跳马失败加黑手机号码",1)
								mSleep(1000)
							else
								goto addblack
							end
						end
					end
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					toast("重新新机注册："..next_again_time,1)
					new_bool = true
					mSleep(1000)
					goto over
				else
					while true do
						mSleep(200)
						x, y = findMultiColorInRegionFuzzy(0x7c160,"621|3|0x7c160,622|68|0x7c160,6|64|0x7c160,323|35|0xffffff,355|31|0xffffff,281|41|0xffffff", 100, 0, 0, 749, 1333)
						if x~=-1 and y~=-1 then
							break
						else
							mSleep(500)
							randomTap(56,83,3)
							mSleep(500)
						end
					end
					toast("跳马失败："..next_again_time,1)
					mSleep(1000)
					setVPNEnable(false)
					mSleep(1000)
					goto next_again
				end
			end

			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				toast("短信界面",1)
				if api_change == "15" then
					setVolumeLevel(0.5)
					mSleep(500)
					playAudio(userPath().."/res/好运来.mp3")
					mSleep(15000)
					setVPNEnable(false)
					mSleep(500)
					luaExit()
				else
					if needConnetMove == "0" then
						t1 = ts.ms()
						while true do
							t2 = ts.ms()

							if os.difftime(t2, t1) > tonumber(liandongTime) then
								toast("等待"..liandongTime.."秒了，获取验证码", 1)
								mSleep(1000)
								break
							else
								toast(os.difftime(t2, t1),1)
								mSleep(5000)
							end
						end
					end

					ewm_url_bool = true
					tiaoma_bool = true
					break
				end
			end

			if hk_way == "0" then
				mSleep(200)
				if getColor(118,  948) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomTap(603, 1032,5)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end

			mSleep(200)
			if getColor(390,822) == 0x576b95 and getColor(363,822) == 0x576b95 then
				mSleep(500)
				randomTap(390,822,5)
				mSleep(500)
				toast("拒收微信登录",1)
				goto next_again
			end
		end
	elseif fz_type == "1" or fz_type == "2" or fz_type == "4" or fz_type == "5" or fz_type == "6" or fz_type == "8" then
		while (true) do
			mSleep(200)
			if getColor(132,  766) == 0x000000 or getColor(256,  639) == 0x9ce6bf then
				if fz_type == "1" then
					::put_work::
					header_send = {
					}
					body_send = string.format("userKey=%s&phone=%s&region=%s&receiveProvinceId=%s",fz_key, phone, country_num, fz_province)
					ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://ymka.ymassist.com/assist/api/order/submitPhone", header_send, body_send, true)
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
					if status_resp == 200 then
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
					if status_resp == 200 then
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
					if status_resp == 200 then
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
					if status_resp == 200 then
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
				elseif fz_type == "5" or fz_type == "6" or fz_type == "8" then
					if fz_type == "8" then
						::put_work::
						header_send = {}
						body_send = string.format("userKey=%s&qrCodeUrl=%s&phone=%s",fz_key,hk_url,phone)
						ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
						status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/submit", header_send, body_send, true)
						if status_resp == 200 then
							local tmp = json.decode(body_resp)
							if tmp.success then
								taskId = tmp.obj.orderId
								toast("发布成功,id:"..tmp.obj.orderId,1)
							else
								goto put_work
							end
						else
							goto put_work
						end
					end

					if fz_type == "8" then
						time = os.time() + 390
					else
						time = os.time() + 310
					end

					while true do
						mSleep(200)
						x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
						if x~=-1 and y~=-1 then
							mSleep(math.random(500, 700))
							self:change_vpn()
							toast("返回注册流程",1)
							break
						end

						mSleep(200)
						if getColor(256,  639) == 0x9ce6bf then
							break
						end

						mSleep(200)
						x,y = findMultiColorInRegionFuzzy( 0xfa5151, "49|1|0xfa5151,-154|787|0x07c160,180|843|0x07c160,186|795|0x07c160,-130|847|0x07c160", 90, 0, 0, 749, 1333)
						if x~=-1 and y~=-1 then
							mSleep(math.random(500, 700))
							setVPNEnable(false)
							toast("系统繁忙，稍后再试",1)
							serviceError = true
							goto bj_fail
						end

						new_time = os.time()
						if new_time >= time then
							ewm_url_bool = false
							toast("辅助超时，进入标记失败订单",1)
							goto bj_fail
						else
							toast(time - new_time,1)
							mSleep(5000)
						end
					end
				end

				while true do
					mSleep(200)
					x, y = findMultiColorInRegionFuzzy(0x7c160,"282|6|0x7c160,121|9|0xffffff,136|-18|0x7c160,133|39|0x7c160,99|-812|0x7c160,165|-790|0x7c160,128|-792|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						tap(x + 150, y)
						mSleep(math.random(1200, 1700))
						toast("返回注册流程",1)
					end

					mSleep(200)
					x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						toast("辅助成功，短信界面",1)
						ewm_url_bool = true
						phone_help = true
						mSleep(1000)
						break
					end

					mSleep(200)
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

			if hk_way == "0" then
				mSleep(200)
				if getColor(118,  948) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomTap(603, 1032,5)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end

			if api_change == "7" or api_change == "8" or api_change == "9" or api_change == "11" or api_change == "13" or api_change == "14" then
				mSleep(200)
				x, y = findMultiColorInRegionFuzzy(0x576b95,"-38|1|0x576b95,-314|-9|0x181819,-356|-3|0x181819,-157|-155|0,24|-174|0",90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					toast("操作频繁",1)
					mSleep(500)
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					goto gg
				end
			end
		end

		if fm_bool then
			while true do
				mSleep(200)
				x, y = findMultiColorInRegionFuzzy(0,"136|3|0,-73|686|0x7c160,330|683|0x7c160,170|683|0xffffff,116|826|0x6ae56,205|815|0x6ae56",100, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					if api_change == "2" or api_change == "10" or api_change == "12" then
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
						local szhttp = require("szocket.http")
						local res, code = szhttp.request("http://api5.caugu.com/yhapi.ashx?act=sendCode&token="..phone_token.."&pid="..pid.."&receiver="..phone_num.."&smscontent="..content_num1..content_num2)
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								mSleep(10000)
								randomTap(384,1131,6)
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
	end

	::bj_fail::
	clean_bool = false
	if ewm_url_bool then
		fz_success_bool = self:ewm(ip_userName,ip_country,login_times,phone_help,skey,tiaoma_bool,fz_bool,fz_type,phone,phone_token,api_change,SMS_country,pid,pay_id,ewm_url,provinceId,tzid,getPhone_key,sumbit_key,codeUrl,messGetTime,messSendTime,ewm_id,localNetwork)
		if fz_type == "0" or fz_type == "1" or fz_type == "2" or fz_type == "5" or fz_type == "4" or fz_type == "6" or fz_type == "8" or fz_type == "9" or fz_type == "10" or fz_type == "11" or fz_type == "12" then
			if fz_success_bool then
				toast("辅助成功",1)
				if api_change == "2" or api_change == "6" or api_change == "7" or api_change == "8" or api_change == "9" or api_change == "10" or api_change == "11" or api_change == "12" or api_change == "13" or api_change == "14" then
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					toast("清空保存号码文件",1)
				end
				clean_bool = true
			else
				toast("辅助失败",1)
				if fz_type == "5" then
					--标记订单
					::bj::
					local sz = require("sz");
					local szhttp = require("szocket.http")
					local res, code = szhttp.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=fail")
					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							toast("订单标记："..tmp.data, 1)
							mSleep(3000)
						else
							toast("标记失败:"..tostring(res),1)
							mSleep(2000)
							goto bj
						end
					end
				elseif fz_type == "6" then
					::push_work::
					header_send = {}
					body_send = string.format("order_sn=%s&status=%s&merchant=%s",order_sn,"2",fz_key)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.004461.cn/change.action", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.code == "200" then
							toast("标记成功",1)
						else
							toast("标记失败:"..body_resp,1)
							mSleep(2000)
							goto push_work
						end
					else
						toast("标记失败:"..body_resp,1)
						mSleep(2000)
						goto push_work
					end
				elseif fz_type == "8" then
					::push_work::
					header_send = {}
					body_send = string.format("userKey=%s&orderId=%s&status=%s",fz_key,taskId,2)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.success then
							toast("标记成功",1)
						else
							goto push_work
						end
					else
						goto push_work
					end
				elseif fz_type == "9" then
					::push_work::
					header_send = {}
					body_send = string.format("userKey=%s&orderId=%s&status=%s",sumbit_key,taskId,2)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.success then
							toast("标记成功",1)
						elseif tmp.msg == "已提交任务结果" then
							toast("订单可能未接单退款了："..tmp.msg,1)
							mSleep(2000)
						elseif tmp.code == 1 then
							toast(tmp.msg,1)
							mSleep(2000)
						else
							toast(body_resp,1)
							mSleep(3000)
							goto push_work
						end
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				elseif fz_type == "10" then
					::push_work::
					header_send = {}
					body_send = string.format("key=%s&oId=%s&sts=%s",sumbit_key,oId,"fail")
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/xg", header_send, body_send, true)
					if status_resp == 200 then
						local tmp = json.decode(body_resp)
						if tmp.success then
							toast("标记成功",1)
						elseif tmp.code == "3" or tmp.code == "4" or tmp.code == "5" or tmp.code == "7" or tmp.code == "6" then
							toast(tmp.msg,1)
							mSleep(2000)
						else
							toast(body_resp,1)
							mSleep(3000)
							goto push_work
						end
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				elseif fz_type == "11" then
					::push_work::
					header_send = {
						["Content-Type"] = "application/x-www-form-urlencoded",
					}
					body_send = {
						["userKey"] = sumbit_key,
						["orderId"] = orderId,
						["status"] = 2,
					}
					ts.setHttpsTimeOut(60)
					code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
					if code == 200 then
						local tmp = json.decode(body_resp)
						if tmp.success then
							toast("标记成功",1)
						else
							toast(body_resp,1)
							mSleep(3000)
							goto push_work
						end
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				elseif fz_type == "12" then
					::push_work::
					header_send = {token=string.format("%s", sumbit_key)}

					body_send = string.format("taskId=%s&status=%s", taskId, 3)
					ts.setHttpsTimeOut(60) -- 安卓不支持设置超时时间
					code,header_resp, body_resp = ts.httpPost("https://ctpu.chitutask.com/api/task/status", header_send,body_send)
					if code == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.code == 200 then
							toast("标记成功",1)
						elseif tmp.message == "任务已被标记为成功" or tmp.message == "任务已被标记为失败" then
							toast("已经标记过该任务",1)
						elseif tmp.message == "任务超时未领取，已退款" then
							toast("任务超时未领取，已退款",1)
						else
							toast(body_resp,1)
							mSleep(3000)
							goto push_work
						end
					else
						goto push_work
					end
				end

				if login_times == "0" then
					if api_change == "2" or api_change == "6" or api_change == "7" or api_change == "8" 
					or api_change == "9" or api_change == "10" or api_change == "11" or api_change == "12" 
					or api_change == "13" or api_change == "14" then
						mSleep(500)
						randomTap(55,83,3)
						mSleep(500)
						if localNetwork == "1" then
							setVPNEnable(false)
							if vpn_country == "0" then
								self:changeGNIP(ip_userName,place_id,iptimes)
							elseif vpn_country == "1" then
								self:changeGWIP(ip_userName,ip_country)
							end
							setVPNEnable(true)
						end
						againLogin_bool = true
						goto next_again
					else
						goto over
					end
				else
					goto over
				end
			end
		elseif fz_type == "3" then
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
			if fz_success_bool then
				toast("跳马辅助成功",1)
			else
				toast("跳马辅助失败",1)
				mSleep(500)
				goto run_app
			end
		elseif fz_type == "7" then
			if fz_success_bool then
				toast("辅助成功",1)
				clean_bool = true
				--				while true do
				--					mSleep(math.random(500, 700))
				--					x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 749, 1333)
				--					if x~=-1 and y~=-1 then
				--						mSleep(500)
				--						randomTap(x,y,5)
				--						mSleep(500)
				--						break
				--					end
				--				end
				--				self:idCard()
			else
				mSleep(500)
				randomTap(55,83,3)
				mSleep(500)
				if localNetwork == "1" then
					setVPNEnable(false)
					if vpn_country == "0" then
						self:changeGNIP(ip_userName,place_id,iptimes)
					elseif vpn_country == "1" then
						self:changeGWIP(ip_userName,ip_country)
					end
					setVPNEnable(true)
				end
				againLogin_bool = true
				goto next_again
			end
		end
	else
		if fz_type == "5" then
			--标记订单
			if send_fm_bool then
				::bj::
				local sz = require("sz");
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=success")
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
		elseif fz_type == "8" then
			if send_fm_bool then
				::push_work::
				header_send = {}
				body_send = string.format("userKey=%s&orderId=%s&status=%s",fz_key,taskId,1)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.msg == "已提交任务结果" then
						toast("订单可能未接单退款了："..tmp.msg,1)
						mSleep(2000)
						goto over
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
			mSleep(200)
			if not fm_bool then
				mSleep(math.random(500, 700))
				randomTap(54, 79, 5)
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
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x343434,"49|-24|0x343434,2|547|0x9de7bf,326|537|0x9de7bf", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(355,590,8)
				mSleep(math.random(500, 700))
				toast("昵称",1)
				break
			end

			--不是我的，继续注册
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x6ae56,"38|-2|0x6ae56,136|6|0x6ae56,182|-5|0x6ae56,261|-7|0x6ae56,290|-5|0x6ae56,-131|-11|0xf2f2f2,433|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(375,782,8)
				mSleep(math.random(500, 700))
				toast("不是我的，继续注册1",1)
			end

			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x6ae56,"47|-11|0x6ae56,-98|-24|0x6ae56,-223|-18|0xededed,285|-15|0xededed", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(375,782,8)
				mSleep(math.random(500, 700))
				toast("不是我的，继续注册2",1)
			end

			--不是我的，继续注册
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0x6ae56,"36|1|0x6ae56,136|5|0x6ae56,181|-7|0x6ae56,294|-7|0x6ae56,371|0|0xf2f2f2,-98|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomTap(x,y,8)
				mSleep(math.random(500, 700))
				toast("不是我的，继续注册3",1)
			end
		end

		if nickName == "0" then  --英文
			nickName = self:randomStr("`~#^&*-=!@$;/|QWERTYUIOPASDF`~#^&*-=!@$;/|GHJKLZXCVBNM`~#^&*-=!@$;/|qwertyuiopasd`~#^&*-=!@$;/|fghjklzxcvbnm`~#^&*-=!@$;/|", math.random(7, 10))
			--检测是否有删除按钮
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
				toast(y, 1)
				if x~=-1 and y~=-1 then
					break
				else
					mSleep(500)
					inputStr(nickName)
					mSleep(500)
					toast("输入昵称",1)
				end
			end
		elseif nickName == "1" then  --特殊符号
-- 			inputStr("르㸏مฬ้๊سمرًς.έل")
			--检测是否有删除按钮
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
				toast(y, 1)
				if x~=-1 and y~=-1 then
					break
				else
					mSleep(500)
					inputStr("@")
					mSleep(500)
					toast("输入昵称",1)
				end
			end

		end

		mSleep(math.random(500, 700))
		randomTap(369,740,8)
		mSleep(math.random(500, 700))

		while true do
			--填写生日
			mSleep(200)
			x, y = findMultiColorInRegionFuzzy(0,"49|-16|0,-5|344|0x9ed99d,365|339|0x9ed99d", 100, 0, 0, 749, 800)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1000, 1700))
				randomTap(384,447,8)
				mSleep(math.random(500, 700))
				toast("点击生日",1)
			end

			mSleep(200)
			if getColor(701,813) == 0x1aad19 then
				mSleep(math.random(1000, 1700))
				randomTap(685,813,3)
				mSleep(math.random(500, 700))
				toast("确定",1)
			end

			mSleep(200)
			if getColor(276,660) == 0x1aad19 then
				mSleep(math.random(1000, 1700))
				randomTap(378,659,8)
				mSleep(math.random(500, 700))
				toast("下一步",1)
				break
			end
		end
	end

	not_get_code = 0
	while (true) do
		--通讯录匹配
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|13|0x576b95,14|-4|0x576b95,14|6|0x576b95,18|18|0x576b95", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			toast("通讯录匹配,等待8秒",1)
			setVPNEnable(false)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			toast("通讯录匹配,等待8秒",1)
			setVPNEnable(false)
			break
		end

		--不是我的，继续注册
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x6ae56,"38|-2|0x6ae56,136|6|0x6ae56,182|-5|0x6ae56,261|-7|0x6ae56,290|-5|0x6ae56,-131|-11|0xf2f2f2,433|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(375,782,8)
			mSleep(math.random(500, 700))
			toast("不是我的，继续注册1",1)
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x6ae56,"47|-11|0x6ae56,-98|-24|0x6ae56,-223|-18|0xededed,285|-15|0xededed", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(375,782,8)
			mSleep(math.random(500, 700))
			toast("不是我的，继续注册2",1)
		end

		--不是我的，继续注册
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x6ae56,"36|1|0x6ae56,136|5|0x6ae56,181|-7|0x6ae56,294|-7|0x6ae56,371|0|0xf2f2f2,-98|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x,y,8)
			mSleep(math.random(500, 700))
			toast("不是我的，继续注册3",1)
		end

		mSleep(200)
		if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
			toast("封号1",1)
			break
		end

		mSleep(200)
		if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
			toast("封号2",1)
			break
		end

		mSleep(200)
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			toast("账号状态异常",1)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-27|-1|0x576b95,-261|-189|0,-225|-188|0,173|-182|0,-218|219|0x36030,158|207|0x36030", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x,y,8)
			mSleep(math.random(1500, 2700))
			randomTap(384,1131,6)
			mSleep(4000)
			not_get_code = not_get_code + 1
			if not_get_code > 2 then
				goto over
			else
				toast("尚未收到短信"..not_get_code,1)
			end
		end

		--注册异常
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "-28|3|0x576b95,-136|-177|0x000000,-66|-179|0x000000,54|-175|0x000000,199|-180|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			dialog("注册异常",0)
			mSleep(1000)
			lua_restart()
			--			mSleep(500)
			--			if fz_type == "3" then
			--				goto run_app
			--			else
			--				goto over
			--			end
		end
	end
	mSleep(12000)
	error_bool = false
	get_wechatError_six = false
	while (true) do
		--通讯录匹配
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|13|0x576b95,14|-4|0x576b95,14|6|0x576b95,18|18|0x576b95", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			get_six_two = true
			toast("账号存活",1)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 645,  845)
		if x~=-1 and y~=-1 then
			mSleep(500)
			get_six_two = true
			toast("账号存活",1)
			break
		end

		mSleep(200)
		if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
			mSleep(500)
			randomTap(362,797,4)
			mSleep(500)
			toast("封号1",1)
			error_bool = true
			get_wechatError_six = true
			break
		end

		mSleep(200)
		if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
			mSleep(500)
			randomTap(362,797,4)
			mSleep(500)
			toast("封号2",1)
			error_bool = true
			get_wechatError_six = true
			break
		end

		mSleep(200)
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			mSleep(500)
			randomTap(362,797,4)
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

		function _自定义提取62数据流程(fz_type,get_wechatError_six,ip)
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

			ip = self.phoneDevice.."号"

			if get_wechatError_six then
				toast("写入异常数据",1)
				if api_change == "7" or api_change == "8" or api_change == "9" or api_change == "11" or api_change == "13" then
					if api_change == "9" or api_change == "11" then
						codeUrl = ""
					end

					all_data = wx.."----"..password.."----"..data.."----"..wxid.."----"..ip.."======MiaoFeng----"..now.."----"..urlEncoder(codeUrl)
				else
					all_data = wx.."----"..password.."----"..data.."----"..wxid.."----"..ip.."======MiaoFeng----"..now.."----null"
				end
				status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSpriteENT/res/秒封62数据") --新建文件夹
				writeFileString(userPath().."/res/秒封62数据/62数据wxid.txt",wxid.."----"..password.."----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				writeFileString(userPath().."/res/秒封62数据/62数据手机号.txt",all_data,"a",1) --将 string 内容存入文件，成功返回 true
				mSleep(1000)
			else
				toast("写入正常数据",1)
				if api_change == "9" or api_change == "11" then
					codeUrl = ""
				end

				if api_change == "7" or api_change == "8" or api_change == "9" or api_change == "11" or api_change == "13" then
					all_data = wx.."----"..password.."----"..data.."----"..wxid.."----"..ip.."----"..now.."----"..urlEncoder(codeUrl)
				else
					all_data = wx.."----"..password.."----"..data.."----"..wxid.."----"..ip.."----"..now.."----null"
				end
				status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSpriteENT/res/62数据") --新建文件夹
				writeFileString(userPath().."/res/62数据/62数据wxid.txt",wxid.."----"..password.."----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				writeFileString(userPath().."/res/62数据/62数据手机号.txt",all_data,"a",1) --将 string 内容存入文件，成功返回 true
				mSleep(1000)
			end

			if #(sendSixDataApi:atrim()) == 0 then
				send_api = "http://47.104.246.33/account.php"
			elseif #sendSixDataApi:atrim() > 0 then
				send_api = "http://47.104.246.33/account"..(sendSixDataApi:atrim())..".php"
			else
				dialog("上传接口输入错误",0)
				lua_restart()
			end

			::send::
			local sz = require("sz")       
			local http = require("szocket.http")
			local res, code = http.request(send_api.."?time="..time.."&info="..all_data)
			if code == 200 then
				if tostring(res) == "success" then
					mSleep(500)
					toast("数据上传:"..tostring(res),1)
					mSleep(1000)
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					if sendFriend == "1" then
					    closeApp("*",1)
					end
				else
					toast("数据上传失败:"..tostring(res),1)
					mSleep(1000)
					goto send
				end
			else
				toast("重新上传",1)
				mSleep(1000)
				goto send
			end
		end

		_自定义提取62数据流程(fz_type,get_wechatError_six,ip)

		if login_times == "0" or login_times == "1" then
			data_six_two = false

			if updateNickName == "0" or sendFriend == "0" then
				while true do
					mSleep(200)
					x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(500)
						randomTap(x,y,5)
						mSleep(500)
					end

					mSleep(200)
					x, y = findMultiColorInRegionFuzzy(0x7c160,"483|-9|0x7c160,155|2|0xffffff,159|95|0x576b95,225|92|0x576b95,246|99|0x576b95", 90, 0, 1013, 749,  1333)
					if x~=-1 and y~=-1 then    
						mSleep(math.random(500, 700))
						randomTap(375,1274,6)
						mSleep(math.random(500, 700))
						toast("加朋友",1)
					end

					mSleep(200)
					x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
					if x~=-1 and y~=-1 then
					    if updateNickName == "0" then
    						mSleep(math.random(500, 700))
    						randomTap(653,1278,6)
    						mSleep(math.random(500, 700))
    					elseif sendFriend == "0" then
    					    mSleep(math.random(500, 700))
    					    randomTap(467,1273,6)
    					    mSleep(math.random(500, 700))
    					end
						toast("微信界面",1)
						data_six_two = true
						break
					end
				end

				if data_six_two and updateNickName == "0" then
					while true do
						mSleep(200)
						if getColor(653,1277) == 0x7c160 then
							mSleep(math.random(500, 700))
							randomTap(359,430,6)
							mSleep(math.random(500, 700))
							toast("修改昵称",1)
							break
						else
							mSleep(math.random(500, 700))
							randomTap(653,1278,6)
							mSleep(math.random(500, 700))
						end

						--通过siri
						mSleep(200)
						if getColor(513,833) == 0x7aff then
							mSleep(math.random(500, 700))
							randomTap(513,833,6)
							mSleep(math.random(500, 700))
							toast("通过siri打开微信",1)
						end
					end

					while true do
						mSleep(200)
						x, y = findMultiColorInRegionFuzzy(0x181818,"36|-14|0x181818,60|5|0x181818,102|-2|0x181818,267|-1|0xf2f2f2", 90, 0, 0, 749,  1333)
						if x~=-1 and y~=-1 then
							mSleep(math.random(500, 700))
							randomTap(653,350,6)
							mSleep(math.random(500, 700))
							toast("个人信息",1)
							break
						end

						mSleep(200)
						if getColor(653,1277) == 0x7c160 then
							mSleep(math.random(500, 700))
							randomTap(359,430,6)
							mSleep(math.random(500, 700))
						end
					end

					while true do
						mSleep(200)
						x, y = findMultiColorInRegionFuzzy(0x181818,"36|-14|0x181818,60|5|0x181818,102|-2|0x181818,267|-1|0xf2f2f2", 90, 0, 0, 749,  1333)
						if x~=-1 and y~=-1 then
							mSleep(math.random(500, 700))
							randomTap(653,350,6)
							mSleep(math.random(500, 700))
						end

						mSleep(200)
						if getColor(617,82) == 0x9ce6bf then
							mSleep(math.random(800, 1200))
							randomTap(555,188,6)
							mSleep(math.random(1000, 1700))
							for var= 1, 10 do
								mSleep(100)
								keyDown("DeleteOrBackspace")
								mSleep(100)
								keyUp("DeleteOrBackspace")
								mSleep(100)
							end
							mSleep(math.random(800, 1200))
							randomTap(49, 1283,8)
							mSleep(math.random(500, 700))
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

							Nickname = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],1,3)

							--检测是否有删除按钮
							mSleep(500)
							while (true) do
								mSleep(200)
								x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
								toast(y, 1)
								if x~=-1 and y~=-1 then
									break
								else
									mSleep(500)
									inputStr(Nickname)
									mSleep(500)
								end
							end
							mSleep(math.random(500, 700))
							toast("输入昵称",1)
							mSleep(math.random(1000, 1500))
							randomTap(659, 84,8)
							mSleep(math.random(500, 700))
							toast("设置名字",1)
							mSleep(math.random(1000, 1500))
							break
						end
					end
				elseif data_six_two and sendFriend == "0" then
				    while (true) do
				        mSleep(200)
    					x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
    					if x~=-1 and y~=-1 then
    					    if updateNickName == "0" then
        						mSleep(math.random(500, 700))
        						randomTap(653,1278,6)
        						mSleep(math.random(500, 700))
        					elseif sendFriend == "0" then
        					    mSleep(math.random(500, 700))
        					    randomTap(467,1273,6)
        					    mSleep(math.random(500, 700))
        					end
    					end
					
				        mSleep(200)
				        x,y = findMultiColorInRegionFuzzy(0x6467f0, "2|17|0x10aeff,-14|17|0x91d300,-16|4|0xfa9d3b,101|1|0x000000,147|12|0x000000,647|11|0xb2b2b2", 90, 0, 0, 750, 1334, { orient = 2 })
                        if x ~= -1 then
                            mSleep(math.random(500, 700))
                            randomTap(x + 300,y + 20, 6)
                            mSleep(math.random(500, 700))
                            toast("朋友圈",1)
                            mSleep(1000)
                        end
                        
                        mSleep(200)
                        if getColor(595,199) ~= 0xffffff and getColor(692,73) == 0xffffff then
                            mSleep(math.random(500, 700))
                            touchDown(692, 73)
                            mSleep(4000)
                            touchUp(692, 73)
                            mSleep(math.random(500, 700))
                            break
                        end
				    end
				    
				    while (true) do
				        mSleep(200)
				        x,y = findMultiColorInRegionFuzzy(0x1d8a25, "-171|0|0x1d8a25,-94|-24|0x2d9535,-87|22|0x11821a,-33|4|0xffffff,-133|-7|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
                        if x ~= -1 then
                            mSleep(math.random(500, 700))
                            randomTap(375,1237, 6)
                            mSleep(math.random(500, 700))
                            toast("我知道了",1)
                            mSleep(1000)
                        end
                        
                        mSleep(200)
                        if getColor(618,82) == 0x9ce6bf then
                            State={
								["随机常量"] = 0,
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
                            writePasteboard(self:Rnd_Word(State["名字"],1,3))
                            mSleep(math.random(500, 700))
                            randomTap(316,205, 6)
                            mSleep(math.random(500, 700))
                            keyDown("RightGUI") 
                            keyDown("v")
                            keyUp("v")
                            keyUp("RightGUI")
                            mSleep(math.random(500, 700))
                            randomTap(618,82, 3)
                            mSleep(math.random(1500, 1700))
                            break
                        end
				    end
				    
				    while (true) do
				        mSleep(200)
                        if getColor(595,199) ~= 0xffffff and getColor(692,73) == 0xffffff then
                            mSleep(math.random(500, 700))
                            break
                        end
				    end
				end

				if needPay == "0" and updateNickName == "0" then
					if data_six_two then
						mSleep(math.random(1000, 1500))
						randomTap(42,82,3)
						mSleep(500)
					end

					self:idCard()
				end
			end
		end

		if request_ipWay == "1" then
			::areaId::
			local sz = require("sz");
			local szhttp = require("szocket.http")
			local res, code = szhttp.request("http://cardapi.mabang18.com/mbapi/generic/getprovincesort")
			if code == 200 then
				tmp = json.decode(res)
				if #tmp.data > 3 then
					areaId = math.random(1, 3)
				else
					areaId = math.random(1, #tmp.data)
				end
				place_id = tmp.data[areaId].areaId
				toast(place_id,1)
				mSleep(1000)
			else
				goto areaId
			end
		end

		if fz_success_bool then
			if fz_type == "5" then
				--标记订单
				::bj::
				local sz = require("sz");
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=success")
				if code == 200 then
					tmp = json.decode(res)
					if tmp.success then
						toast("订单标记："..tmp.data, 1)
						mSleep(3000)
					else
						toast("标记失败:"..tostring(res),1)
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
						mSleep(1000)
						toast("标记成功",1)
					else
						toast("标记失败:"..body_resp,1)
						mSleep(2000)
						goto push_work
					end
				else
					toast("标记失败:"..body_resp,1)
					mSleep(2000)
					goto push_work
				end
			elseif fz_type == "8" then 
				::push_work::
				header_send = {}
				body_send = string.format("userKey=%s&orderId=%s&status=%s",fz_key,taskId,1)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.msg == "已提交任务结果" then
						toast("订单可能未接单退款了："..tmp.msg,1)
						mSleep(2000)
					else
						goto push_work
					end
				else
					goto push_work
				end
			elseif fz_type == "9" then
				::push_work::
				header_send = {}
				body_send = string.format("userKey=%s&orderId=%s&status=%s",sumbit_key,taskId,1)
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.msg == "已提交任务结果" then
						toast("订单可能未接单退款了："..tmp.msg,1)
						mSleep(2000)
					elseif tmp.code == 1 then
						toast(tmp.msg,1)
						mSleep(2000)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "10" then
				::push_work::
				header_send = {}
				body_send = string.format("key=%s&oId=%s&sts=%s",sumbit_key,oId,"success")
				ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
				status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/xg", header_send, body_send, true)
				if status_resp == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					elseif tmp.code == "3" or tmp.code == "4" or tmp.code == "5" or tmp.code == "7" or tmp.code == "6" then
						toast(tmp.msg,1)
						mSleep(2000)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "11" then
				::push_work::
				header_send = {
					["Content-Type"] = "application/x-www-form-urlencoded",
				}
				body_send = {
					["userKey"] = sumbit_key,
					["orderId"] = orderId,
					["status"] = 1,
				}
				ts.setHttpsTimeOut(60)
				code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
				if code == 200 then
					local tmp = json.decode(body_resp)
					if tmp.success then
						toast("标记成功",1)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					toast(body_resp,1)
					mSleep(3000)
					goto push_work
				end
			elseif fz_type == "12" then
				::push_work::
				header_send = {token=string.format("%s", sumbit_key)}
				body_send = string.format("taskId=%s&status=%s", taskId, 2)
				ts.setHttpsTimeOut(60) -- 安卓不支持设置超时时间
				code,header_resp, body_resp = ts.httpPost("https://ctpu.chitutask.com/api/task/status", header_send,body_send)
				if code == 200 then
					mSleep(500)
					local tmp = json.decode(body_resp)
					if tmp.code == 200 then
						toast("标记成功",1)
					elseif tmp.message == "任务已被标记为成功" or tmp.message == "任务已被标记为失败" then
						toast("已经标记过该任务",1)
					elseif tmp.message == "任务超时未领取，已退款" then
						toast("任务超时未领取，已退款",1)
					else
						toast(body_resp,1)
						mSleep(3000)
						goto push_work
					end
				else
					goto push_work
				end
			end
		end

		get_six_two = false
		if login_times == "1" then
			data_sel = readFile(userPath().."/res/data_sel.txt")
			account_len = tonumber(data_sel[1]) + 1
			if account_len >= tonumber(login_times_set) then
				toast(login_times_set.."个注册完成",1)
				mSleep(1000)

				writeFileString(userPath().."/res/data_sel.txt","0","w",0) --将 string 内容存入文件，成功返回 true
				-- dialog(login_times_set.."个注册完成",300)
				mSleep(1000)
				luaExit()
				-- goto over
			else
				toast("第"..account_len.."个注册完成",1)
				mSleep(150)
				writeFileString(userPath().."/res/data_sel.txt",tostring(account_len),"w",0) --将 string 内容存入文件，成功返回 true
				mSleep(500)
				-- if not get_wechatError_six then
				-- 	while true do
				-- 		mSleep(math.random(500, 700))
				-- 		x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 749, 1333)
				-- 		if x~=-1 and y~=-1 then
				-- 			mSleep(500)
				-- 			randomTap(x,y,5)
				-- 			mSleep(500)
				-- 		end

				-- 		mSleep(math.random(500, 700))
				-- 		if getColor(363,813) == 0x576b95 and getColor(382,820) == 0x576b95 then
				-- 			mSleep(500)
				-- 			randomTap(363,813,4)
				-- 			mSleep(500)
				-- 		end

				-- 		mSleep(500)
				-- 		if getColor(654,1279) == 0x7c160 then
				-- 			mSleep(500)
				-- 			while true do
				-- 				mSleep(500)
				-- 				x, y = findMultiColorInRegionFuzzy(0x1485ee,"64|11|0x191919,78|6|0x191919,99|11|0x191919,116|11|0x191919,108|12|0x4a4a4a,2|13|0x1485ee", 90, 0, 600, 749, 1333)
				-- 				if x~=-1 and y~=-1 then
				-- 					mSleep(500)
				-- 					randomTap(x+300,y+50,5)
				-- 					mSleep(500)
				-- 					break
				-- 				end
				-- 			end
				-- 			mSleep(1000)
				-- 			toast("我的",1)
				-- 			break
				-- 		else
				-- 			mSleep(500)
				-- 			randomTap(654,1279,2)
				-- 			mSleep(500)
				-- 		end

				-- 		mSleep(math.random(500, 700))
				-- 		if getColor(492, 1266) == 0x576b95 and getColor(561, 1262) == 0x576b95 then
				-- 			mSleep(500)
				-- 			randomTap(362,797,4)
				-- 			mSleep(500)
				-- 			toast("封号1,超过判断12秒时间，账号写入正常列表",1)
				-- 			goto fh
				-- 		end

				-- 		mSleep(math.random(500, 700))
				-- 		if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
				-- 			mSleep(500)
				-- 			randomTap(362,797,4)
				-- 			mSleep(500)
				-- 			toast("封号2,超过判断12秒时间，账号写入正常列表",1)
				-- 			goto fh
				-- 		end

				-- 		mSleep(math.random(500, 700))
				-- 		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
				-- 			mSleep(500)
				-- 			randomTap(362,797,4)
				-- 			mSleep(500)
				-- 			toast("账号状态异常,超过判断12秒时间，账号写入正常列表",1)
				-- 			goto fh
				-- 		end

				-- 	end

				-- 	while true do
				-- 		mSleep(500)
				-- 		if getColor(356,1167) == 0x191919 then
				-- 			mSleep(500)
				-- 			tap(356,1167)
				-- 			mSleep(500)
				-- 		end

				-- 		mSleep(500)
				-- 		if getColor(356,1172) == 0xe64340 then
				-- 			mSleep(500)
				-- 			tap(356,1172)
				-- 			mSleep(500)
				-- 			break
				-- 		end

				-- 	end
				-- 	get_wechatError_six = false
				-- end

				-- ::fh::
				-- if fz_type == "3" then
				-- 	mSleep(500)
				-- 	closeApp(self.wc_bid, 0)
				-- 	mSleep(5000)
				-- 	setVPNEnable(false)
				-- 	setVPNEnable(false)
				-- 	mSleep(1000)
				-- 	runApp(self.wc_bid)
				-- 	mSleep(2000)
				-- end

				-- while true do
				-- 	mSleep(math.random(500, 700))
				-- 	if getColor(561,1265) == 0x576b95 then
				-- 		mSleep(math.random(500, 700))
				-- 		randomTap(542,1273,3)
				-- 		mSleep(math.random(500, 700))
				-- 	end

				-- 	if getColor(393,1170) == 0 then
				-- 		mSleep(math.random(500, 700))
				-- 		randomTap(393,1170,3)
				-- 		mSleep(math.random(500, 700))
				-- 		break
				-- 	end
				-- end
				-- next_again_time_bool = true
				-- goto start
			end
		else
			--			while true do
			--				mSleep(math.random(500, 700))
			--				x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 749, 1333)
			--				if x~=-1 and y~=-1 then
			--					mSleep(500)
			--					randomTap(x,y,5)
			--					mSleep(500)
			--					break
			--				end
			--			end
			--			self:idCard()
		end
	end

	::over::
	if new_bool then
		mSleep(500)
		closeApp(self.wc_bid, 0)
		mSleep(5000)
		setVPNEnable(false)
		setVPNEnable(false)
		mSleep(1000)
	end

	if fz_type == "5" then
		::check::
		local sz = require("sz");
		local szhttp = require("szocket.http")
		local res, code = szhttp.request("http://www.tvnxl.com/xd/cx?key="..fz_key.."&oId="..old)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.success then
				if tmp.data.sts == 4 then
					wjd_bool = true
				else
					wjd_bool = false
				end
			else
				toast(res,1)
				mSleep(2000)
				goto check
			end
		else
			toast(res,1)
			mSleep(2000)
			goto check
		end

		--标记订单
		if not send_fm_bool and not ewm_url_bool and not wjd_bool then
			::bj::
			local sz = require("sz");
			local szhttp = require("szocket.http")
			local res, code = szhttp.request("http://api.tvnxl.com/xd/xg?key="..fz_key.."&oId="..old.."&sts=fail")
			if code == 200 then
				tmp = json.decode(res)
				if tmp.success then
					toast("订单标记："..tmp.data, 1)
					mSleep(3000)
				else
					toast(body_resp,1)
					mSleep(5000)
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
			elseif tmp.code == "800" then
				wjd_bool = true
			else
				toast(res,1)
				mSleep(2000)
				goto check
			end
		else
			toast(res,1)
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
				elseif tmp.message == "任务已标记，请勿重复标记" then
					toast(tmp.message,1)
					mSleep(1000)
				else
					toast(body_resp,1)
					mSleep(5000)
					goto push_work
				end
			else
				toast(body_resp,1)
				mSleep(2000)
				goto push_work
			end
		end
	elseif fz_type == "8" then
		::push_work::
		header_send = {}
		body_send = string.format("userKey=%s&orderId=%s&status=%s",fz_key,taskId,2)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				toast("标记成功",1)
			elseif tmp.msg == "已提交任务结果" then
				toast("订单可能未接单退款了："..tmp.msg,1)
				mSleep(2000)
			elseif tmp.code == 1 then
				toast(tmp.msg,1)
				mSleep(2000)
			else
				toast("标记失败，重新标记："..tostring(body_resp),1)
				mSleep(8000)
				goto push_work
			end
		else
			toast("标记失败，重新标记："..tostring(body_resp),1)
			mSleep(8000)
			goto push_work
		end
	elseif fz_type == "9" then
		::push_work::
		header_send = {}
		body_send = string.format("userKey=%s&orderId=%s&status=%s",sumbit_key,taskId,2)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://cardapi.mabang18.com/mbapi/order/mark", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				toast("标记成功",1)
			elseif tmp.msg == "已提交任务结果" then
				toast("订单可能未接单退款了："..tmp.msg,1)
				mSleep(2000)
			elseif tmp.code == 1 then
				toast(tmp.msg,1)
				mSleep(2000)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto push_work
			end
		else
			toast(body_resp,1)
			mSleep(3000)
			goto push_work
		end
	elseif fz_type == "10" then
		::push_work::
		header_send = {}
		body_send = string.format("key=%s&oId=%s&sts=%s",sumbit_key,oId,"fail")
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/xg", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				toast("标记成功",1)
			elseif tmp.code == "3" or tmp.code == "4" or tmp.code == "5" or tmp.code == "7" or tmp.code == "6" then
				toast(tmp.msg,1)
				mSleep(2000)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto push_work
			end
		else
			toast(body_resp,1)
			mSleep(3000)
			goto push_work
		end
	elseif fz_type == "11" then
		::push_work::
		header_send = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
		body_send = {
			["userKey"] = sumbit_key,
			["orderId"] = orderId,
			["status"] = 2,
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
		if code == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				toast("标记成功",1)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto push_work
			end
		else
			toast(body_resp,1)
			mSleep(3000)
			goto push_work
		end
	elseif fz_type == "12" then
		::push_work::
		header_send = {token=string.format("%s", sumbit_key)}

		body_send = string.format("taskId=%s&status=%s", taskId, 3)
		ts.setHttpsTimeOut(60) -- 安卓不支持设置超时时间
		code,header_resp, body_resp = ts.httpPost("https://ctpu.chitutask.com/api/task/status", header_send,body_send)
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.code == 200 then
				toast("标记成功",1)
			elseif tmp.message == "任务已被标记为成功" or tmp.message == "任务已被标记为失败" then
				toast("已经标记过该任务",1)
			elseif tmp.message == "任务超时未领取，已退款" then
				toast("任务超时未领取，已退款",1)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto push_work
			end
		else
			goto push_work
		end
	end

	if fz_type ~= "3" then
		phone_loginTime = readFile(userPath().."/res/phone_loginTime.txt")
		if tonumber(phone_loginTime[1]) < tonumber(fz_error_times) then
			if not clean_bool then
				if api_change == "2" or api_change == "6" or api_change == "7" or api_change == "8" or api_change == "9" 
				or api_change == "10" or api_change == "11" or api_change == "12" or api_change == "13" or api_change == "14" then
					mSleep(500)
					randomTap(55,83,3)
					mSleep(500)
					if localNetwork == "1" then
						setVPNEnable(false)
						if vpn_country == "0" then
							self:changeGNIP(ip_userName,place_id,iptimes)
						elseif vpn_country == "1" then
							self:changeGWIP(ip_userName,ip_country)
						end
						setVPNEnable(true)
					end
					againLogin_bool = true
					if api_change == "2" or api_change == "10" or api_change == "12" then
						goto aodi
					else
						goto next_again
					end
				end
			else
				writeFileString(userPath().."/res/phone_data.txt","","w",0)
			end
		else
			if api_change == "2" or api_change == "10" or api_change == "12" and not clean_bool then
				if api_change == "10" then
					black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
				elseif api_change == "2" then
					black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				elseif api_change == "12" then
					black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				end

				::addblack::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request(black_url)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
					elseif data[2] == "-5" then
						if api_change == "12" then
							black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						elseif api_change == "2" then
							black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
							goto addblack
						end
					else
						toast(res,1)
						mSleep(2000)
						goto addblack
					end
				end
			elseif api_change == "7" and not clean_bool then
				::push::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone.php?cmd=poststatus&phone="..phone.."&status=失败")
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "8" and not clean_bool then
				::push::
				local sz = require("sz")        --登陆
				local szhttp = require("szocket.http")
				local res, code = szhttp.request("http://47.104.246.33/phone1.php?cmd=poststatus&phone="..phone.."&status=失败")
				if code == 200 then
					if reTxtUtf8(res) == "反馈成功" then
						toast("号码状态标记成功",1)
					else
						goto push
					end
				else
					toast("标记失败，重新标记:"..tostring(res),1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "9" and not clean_bool or api_change == "11" and not clean_bool then
				if api_change == "9" then
					url = "http://www.phantomunion.com:10023/pickCode-api/push/redemption?token="..tokens.."&serialNumber="..serialNumber.."&feedbackType=A&description=fail"..telphone
				elseif api_change == "11" then
					url = "http://cucumber.bid/bbq-cu-api/push/redemption?token="..tokens.."&feedbackType=B&serialNumber="..serialNumber.."&description=fail"..telphone
				end

				::get_fail::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp =
				ts.httpGet(
					url,
					header_send,
					body_send
				)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "200" then
						if tmp.data == "SUCCESS" or tmp.message == "success" then
							toast("拉黑成功",1)
							mSleep(1000)
						else
							toast("拉黑失败"..tostring(body_resp),1)
							mSleep(2000)
							goto get_fail
						end
					else
						toast(tmp.message, 1)
						mSleep(3000)
						goto get_fail
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto get_fail
				end
			elseif api_change == "13" and not clean_bool then
				::push::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://47.107.172.3/php/index.php?s=/home/index/huan_cun&mingzi="..phone.."&nr=0",header_send,body_send)
				if status_resp == 200 then
					if tonumber(body_resp) == 1 then
						toast("号码清除成功",1)
						mSleep(1000)
					else
						toast(body_resp, 1)
						mSleep(3000)
						goto push
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto push
				end
			elseif api_change == "14" and not clean_bool then
				::AddBlackPhone::
				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60)
				status_resp, header_resp, body_resp = ts.httpGet("http://www.58yzm.com/AddBlackPhone?Token=" .. yzm_token .. "&MSGID=" .. MSGID,header_send,body_send)
				if status_resp == 200 then
					tmp = json.decode(body_resp)
					if tmp.code == "0" or tmp.code == 0 then
						toast(tmp.msg, 1)
						mSleep(1000)
					else
						toast(tmp.msg, 1)
						mSleep(3000)
						goto AddBlackPhone
					end
				else
					toast(body_resp, 1)
					mSleep(3000)
					goto AddBlackPhone
				end
			end
			writeFileString(userPath().."/res/phone_data.txt","","w",0)
		end
	end
	::gg::
	setVPNEnable(false)
	closeApp(self.wc_bid)
end

function model:main()
	deviceId = readFile(userPath().."/res/phone_num.txt")
	self.phoneDevice = deviceId[1]

	if getSixData == "0" then
		local m = TSVersions()
		if m <= "1.2.7" then
			dialog("请使用 v1.2.8 及其以上版本 TSLib",0)
			luaExit()
		else
			ts_version = ts.version()
			toast("TSLib版本为："..m.."\r\nts.so版本为："..ts_version,1)
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

		if addHeaderPicLogin == "0" then
			mSleep(500)
			clearAllPhotos()
			mSleep(1000)

			::save_pic::
			tb = {
				opts = {
					save = userPath().."/res/1.jpg"
				}
			}

			picNum = math.random(3122, 3273)
			toast(picNum,1)

			url = "http://47.104.246.33/TP/"..picNum..".jpg"

			http.setTimeout(60)
			status,header,content = http.get(url,tb)
			if status == 200 then
				toast("图片资源下载成功",1)
			else
				toast("图片资源下载失败",1)
				goto save_pic
			end

			saveImageToAlbum(userPath().."/res/1.jpg")
			mSleep(50)
			saveImageToAlbum(userPath().."/res/1.jpg")
			mSleep(3000)
		end

		if api_change == "2" or api_change == "10" or api_change == "12" then
			if api_change == "2" then
				ksUrl = "http://api.ma37.com"
			elseif api_change == "10" then
				ksUrl = "http://web.jiemite.com"
			elseif api_change == "12" then
				ksUrl = "http://27.124.4.13"
			end

			::get_token::
			local sz = require("sz");
			local szhttp = require("szocket.http")
			local res, code = szhttp.request(ksUrl.."/yhapi.ashx?act=login&ApiName="..username.."&PassWord="..user_pass)
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

		if request_ipWay == "1" then
			::areaId::
			local sz = require("sz");
			local szhttp = require("szocket.http")
			local res, code = szhttp.request("http://cardapi.mabang18.com/mbapi/generic/getprovincesort")
			if code == 200 then
				tmp = json.decode(res)
				if #tmp.data > 3 then
					areaId = math.random(1, 3)
				else
					areaId = math.random(1, #tmp.data)
				end
				place_id = tmp.data[areaId].areaId
				toast(place_id,1)
				mSleep(1000)
			else
				goto areaId
			end
		end

		mSleep(500)
		setVPNEnable(false)
		mSleep(2000)
		get_six_two = false
		while true do
			if vpn_country == "0" then
				mSleep(200)
				runApp("com.liguangming.Shadowrocket")
				while true do
					mSleep(200)
					if getColor(547,101) == 0x2473bd then
						mSleep(500)
						tap(365,579)
						mSleep(3000)
						break
					end

					mSleep(200)
					if getColor(547,101) == 0x4386c5 then
						mSleep(500)
						tap(365,630)
						mSleep(3000)
						break
					end
				end
			elseif vpn_country == "1" then
				mSleep(200)
				runApp("com.liguangming.Shadowrocket")
				while true do
					mSleep(200)
					if getColor(547,101) == 0x2473bd then
						mSleep(500)
						tap(365,670)
						mSleep(2000)
						break
					end

					mSleep(200)
					if getColor(547,101) == 0x4386c5 then
						mSleep(500)
						tap(365,710)
						mSleep(2000)
						break
					end
				end
			elseif vpn_country == "2" then
				self:service_GWvpn()
			elseif vpn_country == "3" then
				self:service_GNvpn()
			end

			if replaceFile ~= "0" then
				local bool = isFileExist(userPath().."/res/info/wc_version.txt")
				if bool then
					txt = readFileString(userPath().."/res/info/wc_version.txt")--读取文件内容，返回全部内容的 string
					if txt then
						toast("当前版本号："..txt, 1)
						mSleep(1000)
					end
				end

				if replaceFile == "1" then
					file_name = "715.plist"
				elseif replaceFile == "2" then
					file_name = "717.plist"
				elseif replaceFile == "3" then
					file_name = "718.plist"
				elseif replaceFile == "4" then
					file_name = "720.plist"
				elseif replaceFile == "5" then
					file_name = "721.plist"
				elseif replaceFile == "6" then
					file_name = "801.plist"
				elseif replaceFile == "7" then
					file_name = "802.plist"
				elseif replaceFile == "8" then
					file_name = "800.plist"
				elseif replaceFile == "9" then
					file_name = "803.plist"
				end

				self:replace_file(file_name)
			end

			if login_times == "1" then
				::file::
				bool = self:file_exists(userPath().."/res/data_sel.txt")
				if bool then
					self:clear_App()
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
				else
					writeFileString(userPath().."/res/data_sel.txt","0","w",0)
					goto file
				end
			else
				::file::
				bool = self:file_exists(userPath().."/res/phone_data.txt")
				if bool then
					phone_data = readFile(userPath().."/res/phone_data.txt")
					toast(phone_data[1],1)
					if type(phone_data[1]) ~= "nil" then
						toast("号码文件有号码，不新机",1)
					else
						writeFileString(userPath().."/res/phone_data.txt","","w",0)
						self:clear_App()
					end
				else
					writeFileString(userPath().."/res/phone_data.txt","","w",0)
					goto file
				end
			end
			self:wechat(fz_error_times,iptimes,ip_userName,ip_country,place_id,data_sel,login_times,login_times_set,skey,wc_version,hk_way,fz_key, fz_type, phone, country_num, phone_token, api_change, SMS_country, username, user_pass, work_id, phone_country, country_id,nickName,password,provinceId,getPhone_key, sumbit_key,messGetTime,messSendTime,sendSixDataApi,updateNickName,needPay,localNetwork,needConnetMove,liandongName,liandongTime)
			mSleep(1000)
		end
	else
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
				dialog("没有要存入的内容", 0)
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

			ip = self.phoneDevice.."号"

			toast("写入正常数据",1)
			all_data = wx.."----111111111----"..data.."----"..wxid.."----"..ip.."----"..now.."----null"

			status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSpriteENT/res/62数据") --新建文件夹
			writeFileString(userPath().."/res/62数据/62数据wxid.txt",wxid.."----111111111----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
			writeFileString(userPath().."/res/62数据/62数据手机号.txt",all_data,"a",1) --将 string 内容存入文件，成功返回 true
			mSleep(1000)

			if #(sendSixDataApi:atrim()) == 0 then
				send_api = "http://47.104.246.33/account.php"
			elseif #sendSixDataApi:atrim() > 0 then
				send_api = "http://47.104.246.33/account"..(sendSixDataApi:atrim())..".php"
			else
				dialog("上传接口输入错误",0)
				lua_restart()
			end

			::send::
			local sz = require("sz")       
			local szhttp = require("szocket.http")
			local res, code = szhttp.request(send_api.."?time="..time.."&info="..all_data)
			if code == 200 then
				if tostring(res) == "success" then
					mSleep(500)
					toast("数据上传:"..tostring(res),1)
					mSleep(1000)
				else
					toast("数据上传失败:"..tostring(res),1)
					mSleep(1000)
					goto send
				end
			else
				toast("重新上传",1)
				mSleep(1000)
				goto send
			end
		end

		_自定义提取62数据流程()
	end
end

function beforeUserExit()
	mSleep(200)
	setVPNEnable(false)
	mSleep(2000)
	writeFileString(userPath().."/res/phone_data.txt","","w",0)
	writeFileString(userPath().."/res/data_sel.txt","0","w",0)
	if api_change == "2" or api_change == "10" or api_change == "12" then
		if api_change == "10" then
			black_url = "http://web.jiemite.com/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..work_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
		elseif api_change == "2" then
			black_url = "http://api.ma37.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
		elseif api_change == "12" then
			black_url = "http://27.124.4.13/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
		end

		::addblack::
		local sz = require("sz")        --登陆
		local szhttp = require("szocket.http")
		local res, code = szhttp.request(black_url)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "1" then
				toast("拉黑手机号码",1)
			elseif data[2] == "-5" then
				if api_change == "12" then
					black_url = "http://27.124.4.13/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
					goto addblack
				elseif api_change == "2" then
					black_url = "http://api.ma37.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
					goto addblack
				end
			end
		end
	end
end

model:main()