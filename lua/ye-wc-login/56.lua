require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 				= {}

model.wc_bid 			= ""
model.wc_name			= ""
model.wc_file			= ""
model.awz_bid 			= ""
model.awz_newUrl        = ""
model.awz_getparam      = "http://127.0.0.1:1688/cmd?fun=getcurrentrecordparam"

model.newIndex          = "0"

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

--[[检查网络方法]]
function model:Net()
--	::check_net::
--	mSleep(1000)
--	--ping 3次测试网络连接情况
--	status = ts.ping("www.baidu.com",3)
--	if status then
--		local n = 0
--		for i=1,#status do
--			n = n + status[i]
--		end
--		if n >= 100 then
--			toast("网络延迟高，重新飞行")
--			mSleep(1000)
--			setAirplaneMode(true);    --打开飞行模式
--			mSleep(3000)
--			setAirplaneMode(false);    --关闭飞行模式
--			mSleep(5000)
--			goto check_net
--		else
--			toast("网络良好")
--			mSleep(1000)
--		end
--	else
--		--无网络，窗口提示并退出程序
--		toast("无网络，请检查网络")
--		mSleep(1000)
--		setAirplaneMode(true);    --打开飞行模式
--		mSleep(3000)
--		setAirplaneMode(false);    --关闭飞行模式
--		mSleep(5000)
--		goto check_net
--	end
end


function model:changeIP(content_user,content_country)
	if content_country == "0" then
		change_url = "http://refresh.come-ip.site/refresh?token=c1568ade&time=600&protocol=socks5&isp=0&user="..content_user.."&province="
	else
		change_url = "http://refresh.come-ip.site/refresh?token=c1568ade&time=600&protocol=socks5&isp=0&user="..content_user.."&province="..content_country
	end

	::change_ip::
	mSleep(500)
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request(change_url)
	mSleep(500)
	nLog(res)
	if code == 200 then
		tmp = json.decode(res)
		if tmp.Ret == "SUCCESS" then
			toast("切换成功",1)
			mSleep(1000)
		elseif tmp.Ret == "PARAM_ERROR" then
			toast("切换失败",1)
			mSleep(3000)
			goto change_ip
		end
	else
		toast("切换失败",1)
		mSleep(2000)
		goto change_ip
	end
end

--下面是子程序
function model:change_IP(content_user,content_country)--换IP
	while true do
		::change_ip::
		mSleep(500)
		status_resp, header_resp,body_resp = ts.httpGet("http://refresh.rola-ip.co/refresh?user="..content_user.."&country="..content_country)
--		status_resp, header_resp,body_resp = ts.httpGet("http://www.luminati-cn.net/changeip/8.210.167.86/"..content_country)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.Ret == "SUCCESS" then      --http://refresh.rola-ip.co接口返回
				toast("切换成功",1)
				mSleep(1000)
				break
			elseif tmp.state == "ok" then     --http://www.luminati-cn.net接口返回
				toast("切换成功",1)
				mSleep(1000)
				break
			else
				toast("切换失败",1)
				mSleep(3000)
				goto change_ip
			end
		else
			toast("切换失败",1)
			mSleep(2000)
			goto change_ip
		end

		if (status_resp==502) then--打开网站失败
			toast("打开网站失败等待3秒")
			mSleep(3000)
		end
	end
end

function model:vpn()
	mSleep(math.random(500, 700))
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(math.random(500, 700))
	old_data = getNetIP() --获取IP  
	toast(old_data,1)

	::get_vpn::
	mSleep(math.random(200, 500))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态",1)
		setVPNEnable(false)
		for var= 1, 10 do
			mSleep(math.random(200, 500))
			toast("等待vpn切换"..var,1)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("关闭状态",1)
	end

	setVPNEnable(true)
	mSleep(1000*math.random(2, 4))

	new_data = getNetIP() --获取IP  
	toast(new_data,1)
	if new_data == old_data then
		toast("vpn切换失败",1)
		mSleep(math.random(200, 500))
		setVPNEnable(false)
		mSleep(math.random(200, 500))
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "3|15|0x007aff,19|10|0x007aff,-50|-128|0x000000,-34|-147|0x000000,3|-127|0x000000,37|-132|0x000000,59|-135|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
		end

		--好
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "1|20|0x007aff,11|0|0x007aff,18|17|0x007aff,14|27|0x007aff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("vpn正常使用", 1)
	end
end

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
    
    if self.newIndex == "0" then
    	::new_phone::
    	local sz = require("sz");
    	local http = require("szocket.http")
    	local res, code = http.request(self.awz_newUrl)
    	if code == 200 then
    		local resJson = sz.json.decode(res)
    		local result = resJson.result
    		if result == 3 then
    			toast("newApp成功，不过ip重复了",1)
    			mSleep(1000)
    			if connect_vpn == "0" then
    				self:vpn()
    			end
    		elseif result == 1 then
    			toast("成功",1)
    		else 
    			toast("失败，请手动查看问题", 1)
    			mSleep(4000)
    			goto new_phone
    		end
    	end
    else
        ::getcurrentrecordparam::
    	local sz = require("sz");
    	local http = require("szocket.http")
    	local res, code = http.request(self.awz_getparam)
    	if code == 200 then
    		local resJson = sz.json.decode(res)
    		local result = resJson.result
    		if result == 1 then
    			toast("数据保存成功",1)
    			mSleep(1000)
    			self.newIndex = "0"
    		else 
    			toast("失败，请手动查看问题", 1)
    			mSleep(4000)
    			goto getcurrentrecordparam
    		end
    	end
    end
end

function model:get_hkUrl(country_num)
	filepath=appDataPath(self.wc_bid)..'/Documents/MMappedKV/maycrashcpmap_v2'
	local file = io.open(filepath,'r')
	local text = file:read("*all")
	file:close()
	if text then
		local link='https%3a%2f%2fweixin110.qq.com%2fsecurity%2freadtemplate%3ft%3dsignup%5Fverify%2fw%5Fintro%26regcc%3d'..country_num..'%26regmobile%3d'..text:match('mobile=(%d+)&regid')..'%26regid%3d'..text:match('regid=(%d%p%d+)&scen')..'%26scene%3dget_reg_verify_code%26'..self.wc_name..'_real_lang%3dzh_CN'
		return urlDecoder(link)
	else
		toast('文件不存在',1)
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

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/config.txt") 
	if tab then 
		self.wc_bid = string.gsub(tab[1],"%s+","")
		self.wc_name = string.gsub(tab[2],"%s+","")
		self.wc_file = string.gsub(tab[3],"%s+","")
		self.awz_bid = string.gsub(tab[4],"%s+","")
		self.awz_newUrl = string.gsub(tab[5],"%s+","")
-- 		self.awz_getparam = string.gsub(tab[6],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在,请检查配置文件路径",5)
		goto read_file
	end
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

function model:ewm(phone,country_id,ewm_url,fz_terrace,load_ewm_bool,base_six_four)
	if fz_terrace == "0" then
		if #phone < 11 then
			while true do
				if #phone == 11 then
					break
				else
					phone = phone .. "0"
				end
			end
		elseif #phone > 11 then
			phone = string.sub(phone,1,11)
		end
		toast(phone,1)
		mSleep(1000)
		::put_work::

		header_send = {
			token = "9F66EC5294A71EDB24C0946295472932ABE11F69175013F576E7EA746D11F974"
		}
		body_send = string.format("phone=%s&provCode=%s&qr=%s",phone,"000001",ewm_url)

		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://sj.golddak.com/api/task/v1/add", header_send, body_send, true)
		toast(body_resp,1)
		mSleep(1000)
		if status_resp == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.message == "success" then
				taskId = tmp.data.taskId
				toast("发布成功,id:"..tmp.data.taskId,1)
			else
				goto put_work
			end
		else
			goto put_work
		end

	elseif fz_terrace == "1" then
		if load_ewm_bool then
			qrCode = "qrCodeImg"
			ewm_url = base_six_four
		else
			qrCode = "qrCodeUrl"
			ewm_url = ewm_url
		end

		::put_work::

		header_send = {
			typeget = "ios"
		}
		body_send = string.format("userKey=%s&"..qrCode.."=%s&phone=%s&provinceId=%s","ABB46ACDA4F901C244A9A88F8D40578C",ewm_url,phone,"210000")

		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://card-api.mali126.com/api/order/submit", header_send, body_send, true)
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
	elseif fz_terrace == "2" then
		::put_work::
		header_send = {
		}
		body_send = string.format("key=%s&url=%s&tel=%s&area=%s","2c588238-2a69-47eb-b082-2a20a1dd5ee8", ewm_url, phone, country_id)
		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://www.tvnxl.com/xd/tj", header_send, body_send, true)
		mSleep(1000)
		if status_resp == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.success then
				oId = tmp.data.oId
				toast("滑块链接发布成功:"..oId,1)
				mSleep(5000)
			else
				mSleep(500)
				toast("发布失败，6秒后重新发布:"..body_resp,1)
				mSleep(6000)
				goto put_work
			end
		else
			mSleep(500)
			toast("发布失败，6秒后重新发布:"..body_resp,1)
			mSleep(6000)
			goto put_work
		end
	end

	bioaji_bool = false
	time = os.time() + 365
	--查询订单状态
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x7c160,"279|8|0x7c160,133|-829|0x7c160,160|-785|0x7c160,128|-659|0x191919,216|-659|0x191919", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			self:vpn()
			mSleep(math.random(3500, 5700))
			randomsTap(373, 1099,10)
			mSleep(math.random(500, 700))
			if fz_terrace == "0" then
				status = 2
			elseif fz_terrace == "1" then
				status = 1
			elseif fz_terrace == "2" then
				status = "success"
			end
			bioaji_bool = true
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			setVPNEnable(false)
			mSleep(4000)
			break
		end

		new_time = os.time()
		if new_time >= time then
			if fz_terrace == "0" then
				status = 3
			elseif fz_terrace == "1" then
				status = 2
			elseif fz_terrace == "2" then
				status = "fail"
			end
			toast("辅助超时，进入标记失败订单",1)
			break
		else
			toast(new_time,1)
			mSleep(1000)
		end
	end


	if fz_terrace == "0" then
		--标记订单
		::push_work::

		header_send = {
			token = "9F66EC5294A71EDB24C0946295472932ABE11F69175013F576E7EA746D11F974"
		}
		body_send = string.format("status=%s&taskId=%s",status, taskId)

		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://sj.golddak.com/api/task/v1/submit", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.message == "success" then
				if bioaji_bool then
					toast("标记成功",1)
					return true
				else
					return false
				end
			elseif tmp.message == "任务超时未领取，已退款" then
				toast(tmp.message,1)
				mSleep(2000)
				return false
			else
				toast(body_resp,1)
				mSleep(2000)
				goto push_work
			end
		else
			toast(body_resp,1)
			mSleep(2000)
			goto push_work
		end

	elseif fz_terrace == "1" then
		::push_work::
		header_send = {
			typeget = "ios"
		}
		body_send = string.format("userKey=%s&orderId=%s&status=%s","ABB46ACDA4F901C244A9A88F8D40578C",taskId,status)

		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://card-api.mali126.com/api/order/mark", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				if bioaji_bool then
					toast("标记成功",1)
					return true
				else
					return false
				end
			elseif tmp.msg == "已提交任务结果" then
				toast("订单可能未接单退款了："..tmp.msg,1)
				mSleep(2000)
				return false
			else
				goto push_work
			end
		else
			goto push_work
		end
	elseif fz_terrace == "2" then
		::check::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://www.tvnxl.com/xd/cx?key=2c588238-2a69-47eb-b082-2a20a1dd5ee8&oId="..oId)
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
		if not wjd_bool then
			::bj::
			local sz = require("sz");
			local http = require("szocket.http")
			local res, code = http.request("http://api.tvnxl.com/xd/xg?key=2c588238-2a69-47eb-b082-2a20a1dd5ee8&oId="..oId.."&sts="..status)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.success then
					if bioaji_bool then
						toast("订单标记："..tmp.data, 1)
						mSleep(3000)
						return true
					else
						return false
					end
				else
					toast(body_resp,1)
					mSleep(2000)
					goto bj
				end
			end
		else
			return false
		end
	end

end

function model:idCard(countryCode)
--	if countryCode == "60" then
--		while true do
--			mSleep(500)
--			if getColor(654,1279) == 0x7c160 then
--				mSleep(500)
--				while true do
--					--设置
--					mSleep(1000)
--					x, y = findMultiColorInRegionFuzzy(0x1485ee,"0|13|0x1485ee,58|2|0x191919,63|13|0x191919,77|6|0x191919,97|11|0x191919,116|13|0x191919,106|20|0x444444", 90, 0, 0, 749, 1333)
--					if x~=-1 and y~=-1 then
--						mSleep(1000)
--						randomTap(x + 300,y,2)
--						mSleep(1000)
--					end

--					--帮助与反馈
--					mSleep(1000)
--					if getColor(153,661) == 0x272727 and getColor(49,675) == 0x191919 then
--						mSleep(2500)
--						randomTap(153,661,2)
--						mSleep(4000)
--						break
--					end
--				end

--				while true do
--					mSleep(1000)
--					if getColor(602,88) == 0 and getColor(276,344) == 0x191919 then
--						mSleep(3000)
--						randomTap(4276,344,2)
--						mSleep(3000)
--					end

--					--实名问题
--					mSleep(1000)
--					x, y = findMultiColorInRegionFuzzy(0x191919,"21|0|0x191919,11|10|0x191919,34|12|0x191919,41|-3|0x191919,57|7|0x191919,78|7|0x191919,92|7|0x191919,102|0|0x191919,-40|37|0xf6b460", 90, 0, 0, 749, 1333)
--					if x~=-1 and y~=-1 then
--						mSleep(3000)
--						randomTap(x + 10,y + 10,2)
--						mSleep(3000)
--					end

--					mSleep(1000)
--					if getColor(71,250) == 0x29ae68 and getColor(106,242) == 0xf6b460 then
--						mSleep(3000)
--						randomTap(456,227,2)
--						mSleep(3000)
--						toast("实名认证",1)
--						mSleep(1500)
--						break
--					end
--				end
--				break
--			else
--				mSleep(500)
--				randomTap(654,1279,2)
--				mSleep(500)
--			end
--		end
--	else
--		while true do
--			mSleep(500)
--			if getColor(654,1279) == 0x7c160 then
--				mSleep(500)
--				randomTap(92,1269,2)
--				mSleep(1000)
--				while true do
--					mSleep(500)
--					if getColor(693,89) == 0x181818 and getColor(685,75) == 0xededed then
--						mSleep(500)
--						randomTap(693,89,2)
--						mSleep(1000)
--						break
--					end
--				end

--				while true do
--					mSleep(500)
--					if getColor(700,417) == 0x4c4c4c and getColor(483,535) == 0xffffff then
--						mSleep(500)
--						randomTap(575,530,2)
--						mSleep(1000)
--						toast("收付款",1)
--						mSleep(3000)
--						break
--					end
--				end
--				break
--			else
--				mSleep(500)
--				randomTap(654,1279,2)
--				mSleep(500)
--			end
--		end
--	end

--	while (true) do
--		--二维码收款
--		mSleep(2000)
--		x, y = findMultiColorInRegionFuzzy(0x509863,"-225|-9|0xffffff,-206|-13|0xffffff,-187|3|0xffffff,-173|-4|0xffffff,-399|-6|0x509863,96|-67|0x439057", 100, 0, 0, 749, 1333)
--		if x~=-1 and y~=-1 then
--			mSleep(3000)
--			randomTap(x + 100, y, 2)
--			mSleep(1000)
--			toast("二维码收款",1)
--			mSleep(1000)
--		end

--		mSleep(500)
--		if getColor(118, 1125) == 0xededed and getColor(116,  938) == 0x000000 then
--			mSleep(3000)
--			randomTap(116,  938,2)
--			mSleep(1000)
--			break
--		end
--	end

--	while (true) do
--		mSleep(500)
--		x,y = findMultiColorInRegionFuzzy( 0x1aad19, "31|-1|0x1aad19,-405|-1198|0x000000,-344|-1199|0x000000,-301|-1198|0x000000", 90, 0, 0, 749, 1333)
--		if x~=-1 and y~=-1 then
--			mSleep(500)
--			randomTap(x,y,2)
--			mSleep(1000)
--		end

--		mSleep(500)
--		if getColor(259,  707) == 0x9ce6bf then
--			mSleep(500)
--			randomTap(324,  231,2)
--			mSleep(1000)
--			inputText("李元芳")
--			mSleep(1000)
--			randomTap(326,  322,2)
--			mSleep(1000)
--			inputText("341126199301216243")
--			mSleep(1000)
--			randomTap(316,  405,2)
--			mSleep(1000)
--			while (true) do
--				mSleep(500)
--				if getColor(87, 1041) == 0x191919 and getColor(223, 1043) == 0xffffff then
--					mSleep(500)
--					randomTap(223, 1043,2)
--					mSleep(1000)
--					break
--				end
--			end

--			while (true) do
--				mSleep(500)
--				if getColor(200,  604) == 0x576b95 or getColor(200,  621) == 0x576b95 then
--					mSleep(1000)
--					randomTap(289,  511,2)
--					mSleep(1000)
--					break
--				end

--				mSleep(500)
--				if getColor(36, 83) == 0x181818 then
--					mSleep(500)
--					randomTap(46, 83,2)
--					mSleep(1000)
--				end
--			end
--			--地区选择
--			while (true) do
--				mSleep(500)
--				if getColor(380,   79) == 0x181818 and getColor(361,  178) == 0xffffff then
--					mSleep(500)
--					randomTap(156,  802,2)
--					mSleep(2000)
--					randomTap(156,  802,2)
--					mSleep(1000)
--					break
--				end
--			end

--			while (true) do
--				mSleep(500)
--				if getColor(200,  604) == 0x576b95 or getColor(200,  621) == 0x576b95 then
--					mSleep(500)
--					randomTap(354,  720,2)
--					mSleep(1000)
--					toast("下一步",1)
--					mSleep(1000)
--					break
--				end

--				mSleep(500)
--				if getColor(36, 83) == 0x181818 then
--					mSleep(500)
--					randomTap(46, 83,2)
--					mSleep(1000)
--				end
--			end
--			break
--		end
--	end

--	while (true) do
--		mSleep(500)
--		if getColor(616, 1280) == 0x464646 then
--			mSleep(500)
--			for var= 1, 3 do
--				mSleep(500)
--				randomTap(125,  950 + (var - 1)* 110,2)
--				mSleep(1000)
--			end

--			for var= 1, 3 do
--				mSleep(500)
--				randomTap(373,  950 + (var - 1)* 110,2)
--				mSleep(1000)
--			end

--			toast("设置密码",1)
--			mSleep(1000)
--			break
--		end
--	end

--	while (true) do
--		mSleep(500)
--		if getColor(616, 1280) == 0x464646 and getColor(259,  695) == 0x9ce6bf then
--			mSleep(500)
--			for var= 1, 3 do
--				mSleep(500)
--				randomTap(125,  950 + (var - 1)* 110,2)
--				mSleep(1000)
--			end

--			for var= 1, 3 do
--				mSleep(500)
--				randomTap(373,  950 + (var - 1)* 110,2)
--				mSleep(1000)
--			end
--			mSleep(500)
--			randomsTap(259,  695,4)
--			mSleep(1000)
--			toast("再次设置密码",1)
--			mSleep(1000)
--			break
--		end
--	end

--	while (true) do
--		mSleep(500)
--		if getColor(390,  777) == 0x576b95 and getColor(421,  612) == 0x000000 then
--			mSleep(500)
--			randomTap(390,  777,2)
--			mSleep(1000)
--		end

--		mSleep(500)
--		if getColor(90,1267) == 0x7c160 or getColor(654,1279) == 0x7c160 then
--			toast("wwxx",1)
--			break
--		else
--			mSleep(500)
--			randomTap(46, 83,1)
--			mSleep(500)
--		end
--	end
end

function model:sendSMSKQ()
	mSleep(math.random(500, 700))
	x, y = findMultiColorInRegionFuzzy(0x576b95,"17|-2|0x576b95,45|1|0x576b95,44|-16|0x576b95,-223|-274|0,-194|-237|0,247|-186|0,-26|-134|0,43|-144|0", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(math.random(200, 500))
		randomsTap(x, y, 4)
		mSleep(math.random(200, 500))
		toast("编辑短信KQ",1)
		mSleep(1000)
	end
end

function model:sendServerStatus(telphone,status)
	::send_code::
	local sz = require("sz")       
	local http = require("szocket.http")
	local res, code = http.request("http://39.99.192.160//import_abnormal?phone="..telphone.."&code="..status)
	nLog(res)
	if code == 200 then
		tmp = json.decode(res)
		if tmp.code == 200 then
			toast(tmp.message,1)
			mSleep(1000)
		else
			toast("重新上传",1)
			mSleep(1000)
			goto send_code
		end
	else
		toast("重新上传",1)
		mSleep(1000)
		goto send_code
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

function model:wc(ksUrl,move_type,operator,login_times,content_user,content_country,content_type,vpn_stauts,phone_token,kn_country,kn_id,countryId,nickName,password,country_len,login_type,addBlack,diff_user,ran_pass,ddwGet,airplaneStatus,connect_vpn,EU_countries,tmFailBack)
	account_len = 0
	old_mess_yzm = ""
	login_diff_bool = false
	load_ewm_bool= false
	closeApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	runApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if airplaneStatus == "1" then
				mSleep(math.random(200, 500))
				setAirplaneMode(true)
				mSleep(3000)
				setAirplaneMode(false)
			end
			randomsTap(549, 1240,10)
			mSleep(math.random(200, 500))
			toast("注册",1)
			break
		end
	end

	tm_bool = false
	::reset::
	if tm_bool then
		while true do
			mSleep(math.random(500, 700))
			if getColor(561,1265) == 0x576b95 then
				mSleep(math.random(500, 700))
				randomsTap(536,1266,3)
				mSleep(math.random(500, 700))
				if airplaneStatus == "1" then
					mSleep(math.random(200, 500))
					setAirplaneMode(true)
					mSleep(3000)
					setAirplaneMode(false)
				end
			end

			if getColor(393,1170) == 0 then
				mSleep(math.random(500, 700))
				randomsTap(393,1170,3)
				mSleep(math.random(500, 700))
				break
			end

			--取消
			mSleep(math.random(500, 700))
			if getColor(79,88) == 0x2bb00 then
				mSleep(math.random(500, 700))
				randomsTap(79,88,3)
				mSleep(math.random(500, 700))
			end
		end
	end

	while (true) do
		--11系统
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"161|-2|0xd7f5e5,387|-10|0x9ce6bf,163|30|0x9ce6bf,156|-31|0x9ce6bf",90,0,831,749,1053)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			toast("注册页面",1)
			break
		end

		--点击模态框10
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a,"11|2|0x1a1a1a,44|1|0x1a1a1a,79|-1|0x1a1a1a,114|-1|0x1a1a1a,153|3|0x1a1a1a,187|3|0x1a1a1a", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
		end

		--点击模态框11
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0,"10|7|0,22|7|0,45|4|0,80|3|0,117|3|0,153|8|0,178|8|0", 90, 228, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(367,1042,10)
			mSleep(math.random(500, 700))
		end

		mSleep(math.random(500, 700))
		if getColor(561,1265) == 0x576b95 then
			mSleep(math.random(500, 700))
			randomsTap(536,1266,3)
			mSleep(math.random(500, 700))
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(549, 1240,10)
			mSleep(math.random(200, 500))
		end

		if getColor(393,1170) == 0 then
			mSleep(math.random(500, 700))
			randomsTap(393,1170,3)
			mSleep(math.random(500, 700))
		end
	end

	if vpn_stauts == "1" then
		::get_token::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=Login&user=huqianjin1&pwd=huqianjin")

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				token = data[2]
			else
				toast("请求接口或者参数错误,脚本重新运行",1)
				lua_restart()
			end
		else
			toast("获取token失败，重新获取",1)
			mSleep(1000)
			goto get_token
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=GetNumber&token="..token.."&pid="..kn_id)

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
				toast("请求接口或者参数错误，脚本重新运行",1)
				lua_restart()
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "16"  then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request(ksUrl.."/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..kn_id)
		mSleep(500)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "1" then
				mSleep(200)
				if vpn_stauts == "13" then
					telphone = data[4]
				elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16"  then
					telphone = data[5]
					pid = data[2]
				end
				toast(telphone,1)
			elseif data[1] == "0" then
				toast("获取手机号码失败，重新获取",1)
				mSleep(1000)
				goto get_phone
			end
		else
			toast("接口返回错误",1)
			mSleep(1000)
			goto get_phone
		end
	elseif vpn_stauts == "3" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://52yzm.top/handler/api.php?apikey=001a21dda85bbe700fbb33f17a5eb49d&action=getnumber&country="..countryId.."&service=67")
		mSleep(500)
		if code == 200 then
			if  reTxtUtf8(res) == "error" then
				toast("网站挂了",1)
				lua_exit()
			else
				data = strSplit(res, ":")
				if reTxtUtf8(data[1]) == "OK" then
					mSleep(200)
					telphone = data[2]
					pid = data[3]
					nLog(telphone)
					toast(telphone,1)
				elseif reTxtUtf8(data[1]) == "BAD" then
					toast("获取手机号码失败，错误代码："..res,1)
					mSleep(10000)
					goto get_phone
				end
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(10000)
			goto get_phone
		end
	elseif vpn_stauts == "4" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("https://smsregs.ru/api/v1/get_number?token=zn278868698:6DBB856EFAFE4EE77AAC&country="..countryId.."&service="..self.wc_name)
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.phone_number then
				mSleep(200)
				telphone = tmp.phone_number
				country_code = tmp.country_code
				requestId = tmp.request_id
				toast(telphone,1)
			else
				mSleep(500)
				toast("获取手机号码失败，失败信息:"..tmp.message,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(10000)
			goto get_phone
		end
	elseif vpn_stauts == "5" then
		if ddwGet == "1" then
			::get_phoneList::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://106.54.140.11/chayue.php?&id=huqianjin")
			mSleep(500)
			if code == 200 then
				data = strSplit(res, "：")
				if tonumber(data[2]) > 0 then
					mSleep(200)
					telphone = data[2]
					toast(telphone,1)
				else
					mSleep(500)
					toast("当前没有可用的号码",1)
					mSleep(5000)
					goto get_phoneList
				end
			else
				toast("获取手机号码数量失败，重新获取",1)
				mSleep(10000)
				goto get_phoneList
			end

			::get_phone::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://106.54.140.11/getnumber.php?&id=huqianjin")
			mSleep(500)
			if code == 200 then
				if res ~= "NO" then
					data = strSplit(res, "----")
					if #data == 2 then
						mSleep(200)
						telphone = data[1]
						ddwToken = data[2]
						ddwData = res:atrim()
						toast(telphone,1)
					end
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
		else
			::get_platform::
			local sz = require("sz")       
			local http = require("szocket.http")
			local res, code = http.request("http://39.99.192.160/get_platform")
			if code == 200 then
				tmp = json.decode(res)
				if tmp.code == 200 then
					get_platformId = tmp.data.id
					data = strSplit(tmp.data.token, "----")
					telphone = data[1]
					ddwToken = data[2]
				else
					toast("获取号码失败",1)
					mSleep(1000)
					goto get_platform
				end
			else
				toast("获取号码失败",1)
				mSleep(1000)
				goto get_platform
			end
		end
	elseif vpn_stauts == "6" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://39.99.192.160/get_data")

		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.data.status then
				mSleep(500)
				telphone = tmp.data.account
				mSleep(200)
				code_url = tmp.data.link
				mSleep(200)
				result_id = tmp.data.id
				mSleep(200)
			elseif tmp.message == "没有可用数据" then
				dialog("服务器当前没号码可用,即将退出运行",10)
				lua_exit()
			else
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif vpn_stauts == "7" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://api.smsregs.ru/control/get-number?token=huqianjin675196542@qq.com&application_id=2&country_id="..countryId)
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.application_id == 2 then
				mSleep(200)
				telphone = tmp.number
				requestId = tmp.request_id
				toast(telphone,1)
			elseif tmp.application_id == "2" then
				toast("获取手机号码失败，重新获取:"..tmp.error_code,1)
				mSleep(1000)
				goto get_phone
			elseif tmp.success == false then
				toast(tmp.error_code,1)
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif vpn_stauts == "8" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://161.117.87.24/api.php?act=quhao&diqu="..countryId.."&key=99837")
		mSleep(500)
		if code == 200 then
			if tonumber(res) then
				mSleep(200)
				telphone = res
				toast(telphone,1)
			else
				toast("获取手机号码失败，重新获取:"..res,1)
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif vpn_stauts == "10" then
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://simsms.org/priemnik.php?metod=get_number&country="..countryId.."&service=opt67&apikey=pRv27lOtdWjwW8xlLZm54NAgZLQwZr")

		if code == 200 then
			tmp = json.decode(res)
			if tmp.response == "1" then
				telphone = tmp.number
				country_code = string.sub(tmp.CountryCode,2,#tmp.CountryCode)
				pay_id = tmp.id
				toast(telphone, 1)
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
	elseif vpn_stauts == "11" then
		::get_balance::
		local ts = require("ts")
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60) 
		code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=account&apik=6b133584", header_send,body_send)
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.ResponseCode == 0 then
				if tmp.Result.Balance > 4.5 then
					toast("当前金额为:"..tmp.Result.Balance,1)
				else
					dialog("平台余额不足",0)
					lua_exit()
				end
			else
				toast("获取金额失败:"..body_resp,1)
				mSleep(5000)
				goto get_balance
			end
		else
			toast("获取金额失败:"..body_resp,1)
			mSleep(5000)
			goto get_balance
		end

		::get_app::
		local ts = require("ts")
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60) 
		code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=app&apik=6b133584", header_send,body_send)
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.ResponseCode == 0 then
				for k,v in ipairs(tmp.Result) do
					if v.Name == self.wc_name then
						id = v.Id
						toast("项目id:"..id,1)
						mSleep(1000)
						break
					end
				end
			else
				toast("获取项目id失败:"..body_resp,1)
				mSleep(5000)
				goto get_app
			end
		else
			toast("获取项目id失败:"..body_resp,1)
			mSleep(5000)
			goto get_app
		end

		::get_phone::
		local ts = require("ts")
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60) 
		code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=number&apik=6b133584&appId="..id, header_send,body_send)
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.ResponseCode == 0 then
				telphone = tmp.Result.Number
				telphoneID = tmp.Result.Id
				toast(telphone.."\r\n"..telphoneID,1)
				mSleep(1000)
			else
				toast("获取号码失败:"..body_resp,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取号码失败:"..body_resp,1)
			mSleep(5000)
			goto get_phone
		end
	elseif vpn_stauts == "12" then
		::get_phone::
		local ts = require("ts")
		header_send = {}
		body_send = {}
		ts.setHttpsTimeOut(60) 
		code,header_resp, body_resp = ts.httpsGet("https://admin.smscodes.io/api/sms/GetServiceNumber?key=3edcec83-89e0-4c13-a1a4-c2a12018422f&iso="..countryId.."&serv=bb147412-4700-44d6-a4fe-637361940f2a", header_send,body_send)
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.Number == "N/A" then
				toast("获取号码失败:"..body_resp,1)
				mSleep(5000)
				goto get_phone
			elseif tonumber(tmp.Number) > 0 then
				telphone = tmp.Number
				sid = tmp.SecurityId
				toast(telphone.."\r\n"..sid,1)
			else
				toast("获取号码失败:"..body_resp,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取号码失败:"..body_resp,1)
			mSleep(5000)
			goto get_phone
		end
	elseif vpn_stauts == "14" then
		::get_phone::
		header_send = {
			["Content-Type"] = "application/json"
		}
		body_send = {
			["appKey"] = "x727KdG1",
			["secretKey"] = "cc128a0c117a4493b2827de05c150909",
			["infos"] = {
				{
					["productId"] = 3,
					["abbr"] = countryId,
					["number"] = 1
				}
			},
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpPost("http://gvU6e7.g7e6.com:20083/api/phone", header_send,body_send)
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.status == 0 then
				taskId = tmp.phones[1].phoneNodes[1].taskId
				telphone = tmp.phones[1].phoneNodes[1].phone
				toast(telphone.."\r\n"..taskId,1)
			elseif tmp.status == 20000 then
				toast("暂无手机号",1)
				mSleep(5000)
				goto get_phone
			elseif tmp.status == 20001 then
				toast("参数为空",1)
				mSleep(5000)
				goto get_phone
			elseif tmp.status == 20002 then
				toast("任务已完成",1)
				mSleep(5000)
			elseif tmp.status == 20003 then
				toast("任务已关闭",1)
				mSleep(5000)
				goto get_phone
			elseif tmp.status == 20004 then
				toast("下发上限，等待成功反馈同步后继续下发",1)
				mSleep(5000)
				goto get_phone
			elseif tmp.status == 20006 then
				toast("appKey或者secretKey不正确",1)
				mSleep(5000)
				goto get_phone
			else
				toast("获取号码失败:"..body_resp,1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取号码失败:"..body_resp,1)
			mSleep(5000)
			goto get_phone
		end
	elseif vpn_stauts == "15" then
		lsj_key = "8jHAQCjC01"

		::getUserInfo::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://api.nwohsz.com:2086/registerApi/getUserInfo?uid=1608085312&sign="..lsj_key:md5())
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(res)
			if tmp.code == 0 then
				gold = tmp.data.score[1].gold
				if gold > 3 then
					toast("当前用户积分大于3，可以正常取号",1)
					mSleep(500)
				else
					toast("当前用户积分低于3，请及时充值",1)
					mSleep(500)
					goto getUserInfo
				end
			else
				toast("获取用户信息失败:"..tostring(res),1)
				mSleep(5000)
				goto getUserInfo
			end
		else
			toast("获取用户信息失败:"..tostring(res),1)
			mSleep(5000)
			goto getUserInfo
		end

		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://api.nwohsz.com:2086/registerApi/getMobile?uid=1608085312&size=1&pid=11&cuy="..string.upper(countryId).."&include=1&sign="..lsj_key:md5())
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(res)
			if tmp.code == 0 then
				orderId = tmp.orderId
				telphone = tostring(tmp.data[1])
				toast(telphone.."\r\n"..orderId,1)
			else
				toast("获取号码失败:"..tostring(res),1)
				mSleep(5000)
				goto get_phone
			end
		else
			toast("获取号码失败:"..tostring(res),1)
			mSleep(5000)
			goto get_phone
		end
	elseif vpn_stauts == "17" then
	    ::get_token::
        local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://117.149.243.6:82/api/yonghu_login/type=1&username=huqianjin&password=huqianjin")
            if code == 200 then
			data = strSplit(urlDecoder(res), "|")
			if data[1] == "成功" then
			    server_token = data[2]
				toast(server_token,1)
			else
				toast("获取token失败，重新获取",1)
				mSleep(1000)
				goto get_token
			end
		else
			toast("获取token失败，重新获取",1)
			mSleep(1000)
			goto get_token
        end
	
	    ::get_balane::
        local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://117.149.243.6:889/api/xhqyhzb/&lx=3&token="..server_token)
            if code == 200 then
			data = strSplit(urlDecoder(res), "|")
			if data[1] == "成功" then
			    if tonumber(data[2]) > 1 then
				    toast(data[2],1)
				else
				    toast("当前余额不足1块",1)
				    mSleep(500)
			    end
			else
				toast("获取token失败，重新获取",1)
				mSleep(1000)
				goto get_balane
			end
		else
			toast("获取token失败，重新获取",1)
			mSleep(1000)
			goto get_balane
        end
    
        ::get_phone::
        local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://117.149.243.6:84/api/shouduanxin_zaixianhaoma_plpt/xmid=02121-SMNAIV&xzgj=马来西亚&glhmd=1&qhsl=1&token="..server_token)
            if code == 200 then
			data = strSplit(urlDecoder(res), "|")
			if data[1] == "成功" then
			    telphone = data[2]
			    toast(telphone,1)
			else
				toast("获取手机号码失败，重新获取",1)
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
        end
	else
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://opapi.sms-5g.com/out/ext_api/getMobileCode?name=huqianjin&pwd=huqianjin2123&pid=180&cuy="..countryId.."&num=1&noblack=0&serial=2&secret_key=0aeccdd584986df89b302804")

		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.code == 200 then
				phone = strSplit(tmp.data, ",")
				telphone = phone[1]
				toast(telphone,1)
			elseif tmp.code == 902 then
				dialog("传递参数不正确，请查看传递参数是否正确",5)
				mSleep(2000)
				goto get_phone
			elseif tmp.code == 906 then
				toast("手机号列表为空",1)
				mSleep(1000)
				goto get_phone
			elseif tmp.code == 403 then
				dialog("积分不足，请充值",5)
				mSleep(2000)
				lua_exit()
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(3000)
			goto get_phone
		end
	end

	if vpn_stauts == "1" or vpn_stauts == "2" or vpn_stauts == "3" or vpn_stauts == "5" or vpn_stauts == "6" or vpn_stauts == "7" or vpn_stauts == "8" or vpn_stauts == "9" or vpn_stauts == "11" or vpn_stauts == "12" or vpn_stauts == "13" or vpn_stauts == "14" or vpn_stauts == "15" or vpn_stauts == "16" or vpn_stauts == "17" then
		country_id = kn_country
	elseif vpn_stauts == "4" or vpn_stauts == "10" then
		country_id = country_code
	else
		if country_len == "0" then
			lens = 1
		elseif country_len == "1" then
			lens = 2
		elseif country_len == "2" then
			lens = 3
		end

		--输入国家区号
		mSleep(math.random(200, 300))
		country_id = string.sub(telphone,2,lens+1)
		mSleep(math.random(200, 300))
	end

	if vpn_stauts == "1" or vpn_stauts == "3" or vpn_stauts == "4" or vpn_stauts == "6" or vpn_stauts == "10" or vpn_stauts == "11" or vpn_stauts == "17" then
		phone = telphone
	elseif vpn_stauts == "5" or vpn_stauts == "8" or vpn_stauts == "12" or vpn_stauts == "15" then
		phone = string.sub(telphone, #country_id + 1,#telphone)
	elseif vpn_stauts == "2" or vpn_stauts == "7" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "14" or vpn_stauts == "16" then
		if vpn_stauts == "14" then
			telphone = string.match(telphone,"%d+")
		end

		b,c = string.find(string.sub(telphone,1,#country_id),country_id)
		if c ~= nil then
			phone = string.sub(telphone,c+1,#telphone)
		else
			phone = telphone
		end
	else
		phone = string.sub(telphone, lens+2, #telphone)
	end

	if EU_countries == "1" then
		--昵称
		while (true) do
			--707版本
			mSleep(math.random(200, 500))
			x, y = findMultiColorInRegionFuzzy(0,"21|17|0,36|21|0,41|4|0,-15|12|0", 90, 0, 0, 749, 701)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(348, 518, 8)
				mSleep(math.random(200, 500))
				--	if login_type == "0" then
				if diff_user == "0" then
					nickName = self:randomStr("1234567890QWERTYUIOPASDF1234567890GHJKLZXCVBNM1234567890qwertyuiopasd1234567890fghjklzxcvbnm1234567890", math.random(8, 15))
				else
					nickName = self:randomStr("`~#^&*-=!@$;/|1234567890QWERTYUIOPASDF`~#^&*-=!@$;/|1234567890GHJKLZXCVBNM`~#^&*-=!@$;/|1234567890qwertyuiopasd`~#^&*-=!@$;/|1234567890fghjklzxcvbnm1234567890`~#^&*-=!@$;/|", math.random(8, 15))
				end
				--	end

				--检测是否有删除按钮
				mSleep(500)
				while (true) do
					mSleep(500)
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
				break
			end
		end
	end

	--国家／地区
	while (true) do
		--707版本
		mSleep(math.random(200, 500))
		x, y = findMultiColorInRegionFuzzy(0,"27|26|0,3|25|0,17|-2|0,14|6|0,35|2|0,63|1|0", 90, 0, 0, 749, 701)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+110,y+90, 6)
			mSleep(math.random(200, 500))
			break
		end
	end

	--删除区号
	for var= 1, 10 do
		mSleep(100)
		keyDown("DeleteOrBackspace")
		mSleep(100)
		keyUp("DeleteOrBackspace")
		mSleep(100)
	end

	for i = 1, #(country_id) do
		mSleep(math.random(200, 300))
		num = string.sub(country_id,i,i)
		if num == "0" then
			mSleep(math.random(200, 300))
			randomsTap(373, 1281, 8)
		elseif num == "1" then
			mSleep(math.random(200, 300))
			randomsTap(132,  955, 8)
		elseif num == "2" then
			mSleep(math.random(200, 300))
			randomsTap(377,  944, 8)
		elseif num == "3" then
			mSleep(math.random(200, 300))
			randomsTap(634,  941, 8)
		elseif num == "4" then
			mSleep(math.random(200, 300))
			randomsTap(128, 1063, 8)
		elseif num == "5" then
			mSleep(math.random(200, 300))
			randomsTap(374, 1061, 8)
		elseif num == "6" then
			mSleep(math.random(200, 300))
			randomsTap(628, 1055, 8)
		elseif num == "7" then
			mSleep(math.random(200, 300))
			randomsTap(119, 1165, 8)
		elseif num == "8" then
			mSleep(math.random(200, 300))
			randomsTap(378, 1160, 8)
		elseif num == "9" then
			mSleep(math.random(200, 300))
			randomsTap(633, 1164, 8)
		end
	end

	--密码
	while (true) do
		mSleep(math.random(500, 1000))
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+400,y-70,8)
			mSleep(math.random(200, 500))
			break
		end
	end

	toast(phone,1)
	mSleep(1200)
	for i = 1, #phone do
		mSleep(math.random(200, 500))
		num = string.sub(phone,i,i)
		mSleep(math.random(200, 500))
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
		mSleep(math.random(200, 500))
		x, y = findMultiColorInRegionFuzzy(0,"28|1|0,15|-2|0,14|20|0,3|22|0,26|20|0,38|18|0,54|-3|0,53|18|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+400,y,8)
			mSleep(math.random(500, 700))
			if login_type == "0" then
				if ran_pass == "1" then
					password = self:randomStr("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM", math.random(1, 3))..self:randomStr("QWERTYUIOPASDFG1234567890HJKLZXCVBNM1234567890qwertyuiopasdfgh1234567890jklzxcvbnm", math.random(4, 6))..self:randomStr("1234567890", math.random(3, 4))
				end
			end
			mSleep(500)
			inputStr(password)
			mSleep(math.random(200, 500))
			break
		end
	end

	cheack_bool = true
	set_vpn = false
	tmFailBack_bool = true

	::tiaoma::
	if connect_vpn == "1" then
		if set_vpn then
			if content_type == "0" or content_type == "2" or content_type == "3" then
				self:vpn()
			end
		end
	end

	::wait_ys::
	--协议后下一步
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-63|12|0x07c160,128|13|0x07c160,54|13|0xffffff,295|-2|0x07c160,-262|6|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
			break
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"540|-7|0x9ce6bf,270|30|0x9ce6bf,270|-89|0x576b95",90,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+100,y,10)
			mSleep(math.random(200, 500))
			break
		end
	end

	--欧盟隐秘政策多一个下一步
	if EU_countries == "0" then
		while (true) do
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x7c160,"309|7|0x7c160,304|54|0x7c160,-12|57|0x7c160,-49|31|0xededed,382|32|0xededed,156|25|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x,y,10)
				mSleep(math.random(200, 500))
				toast("欧盟。。。",1)
				mSleep(1000)
				break
			end
		end
	end

	--隐秘政策
	::ymzc::
	time = 0
	while (true) do
		if EU_countries == "0" then
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x7c160,"309|7|0x7c160,304|54|0x7c160,-12|57|0x7c160,-49|31|0xededed,382|32|0xededed,156|25|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x,y,10)
				mSleep(math.random(200, 500))
				toast("欧盟。。。",1)
				mSleep(1000)
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0xc2c2c2,"13|19|0xc2c2c2,52|12|0xc2c2c2,83|0|0xc2c2c2,84|16|0xc2c2c2,-111|-5|0xf2f2f2,219|43|0xf2f2f2,274|18|0xededed,-172|9|0xededed", 100, 0, 924, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 1000))
				randomsTap(x - 240, y-95,1)
				mSleep(math.random(3000, 5000))
				break
			else
				time = time + 1
				toast("欧盟等待隐秘政策"..time,1)
				mSleep(math.random(2000, 3000))
			end
		else
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(200, 500))
				randomsTap(x-240, y-98,2)
				mSleep(math.random(200, 500))
				break
			else
				mSleep(math.random(500, 700))
				x,y = findMultiColorInRegionFuzzy( 0xc2c2c2, "-148|-7|0xf2f2f2,140|2|0xf2f2f2,245|2|0xededed,-175|6|0xf2f2f2", 100, 0, 1145, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 1000))
					randomsTap(x, y-112,1)
					mSleep(math.random(3000, 5000))
					break
				else
					time = time + 1
					toast("等待隐秘政策"..time,1)
					mSleep(math.random(2000, 3000))
				end
			end
		end

		--后者网络失败
		if time > 60 or getColor(363,329) == 0xc9c9c9 and getColor(374,425) ==0xffffff then
			if content_type == "2" then
				setVPNEnable(false)
				mSleep(2000)
				self:changeIP(content_user,content_country)
				setVPNEnable(true)
				mSleep(4000)
			else
				if content_type ~= "1" then
					setVPNEnable(false)
					mSleep(2000)
					self:change_IP(content_user,content_country)
					setVPNEnable(true)
					mSleep(4000)
				end
			end
			mSleep(math.random(2000, 3000))
			randomsTap(56, 81, 8)
			mSleep(math.random(200, 500))
			goto wait_ys
		end
	end

	--隐秘政策：下一步
	while (true) do
		if EU_countries == "0" then
			mSleep(math.random(200, 500))
			if getColor(300, 1107) == 0x07c160 then
				mSleep(math.random(300, 600))
				randomsTap(370, 1107,10)
				mSleep(math.random(200, 500))
				toast("欧盟隐秘政策同意：下一步",1)
			end
		else
			mSleep(math.random(200, 500))
			if getColor(300, 1201) == 0x07c160 then
				mSleep(math.random(300, 600))
				randomsTap(370, 1204,10)
				mSleep(math.random(200, 500))
				toast("隐秘政策同意：下一步",1)
			end
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
		if x~=-1 and y~=-1 then
			toast("再次勾选隐秘政策",1)
			mSleep(1000)
			goto ymzc
		else
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy( 0xc2c2c2, "-148|-7|0xf2f2f2,140|2|0xf2f2f2,245|2|0xededed,-175|6|0xf2f2f2", 100, 0, 1145, 749, 1333)
			if x~=-1 and y~=-1 then
				toast("再次勾选隐秘政策",1)
				mSleep(1000)
				goto ymzc
			end
		end

		--欧盟
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xc2c2c2,"13|19|0xc2c2c2,52|12|0xc2c2c2,83|0|0xc2c2c2,84|16|0xc2c2c2,-111|-5|0xf2f2f2,219|43|0xf2f2f2,274|18|0xededed,-172|9|0xededed", 100, 0, 924, 749, 1333)
		if x~=-1 and y~=-1 then
			toast("欧盟再次勾选隐秘政策",1)
			mSleep(1000)
			goto ymzc
		end

		mSleep(math.random(500, 700))
		if getColor(118,  948) == 0x007aff then
			mSleep(math.random(500, 1000))
			randomsTap(690, 1032,10)
			mSleep(math.random(3000, 6000))
		end

		mSleep(math.random(200, 500))
		if getColor(353,  287) == 0x10aeff and getColor(304, 1105) == 0x07c160 then
			toast("准备安全验证",1)
			mSleep(2000)
			break
		end

		mSleep(500)
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|0|0x576b95,-41|-242|0,1|-228|0,35|-239|0,79|-83|0xf9f7fa", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomsTap(x,y,5)
			mSleep(1000)
			toast("手机号码错误",1)
			mSleep(1000)
			closeApp(self.wc_bid, 0)
			mSleep(5000)
			runApp(self.wc_bid)
			mSleep(2000)
			if account_len ~= 0 then
				tm_bool = true
			end
			goto reset
		end

		mSleep(500)
		x, y = findMultiColorInRegionFuzzy(0x576b95,"17|-1|0x576b95,46|-2|0x576b95,46|-17|0x576b95,-223|-162|0,-87|-157|0,-52|-162|0,24|-174|0,168|-162|0,227|-153|0", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomsTap(x,y,5)
			mSleep(1000)
			toast("连接失败，请检查你的网络设置",1)
			mSleep(1000)
			goto over
		end
	end

	if login_type == "3" then
		hk_url = self:get_hkUrl(country_id)
		hk_url = urlEncoder(hk_url)
	end

	--安全验证
	while (true) do
		mSleep(math.random(700, 900))
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1000, 1500))
			randomsTap(372, 1105,6)
			mSleep(math.random(1000, 1500))
			toast("安全验证",1)
			break
		end

		mSleep(math.random(500, 700))
		if getColor(300, 1201) == 0x07c160 then
			mSleep(math.random(1000, 1700))
			randomsTap(370, 1204,10)
			mSleep(math.random(1000, 1700))
			toast("下一步",1)
		end

		mSleep(math.random(200, 500))
		if getColor(300, 1107) == 0x07c160 then
			mSleep(math.random(300, 600))
			randomsTap(370, 1107,10)
			mSleep(math.random(200, 500))
			toast("欧盟隐秘政策同意：下一步",1)
		end
	end

	if cheack_bool then
		if login_type == "0" then
			if EU_countries == "1" then
				while (true) do
					mSleep(math.random(500, 700))
					if getColor(118,  948) == 0x007aff then
						mSleep(math.random(500, 700))
						randomsTap(56, 81, 8)
						mSleep(math.random(500, 700))
						break
					end

					mSleep(math.random(700, 900))
					x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(1000, 1500))
						randomsTap(372, 1105,6)
						mSleep(math.random(1000, 1500))
					end
				end
				toast("跳马注册",1)
				cheack_bool = false
				set_vpn = true
				goto tiaoma
			end
		elseif login_type == "1" or login_type == "3" then
			toast("辅助注册",1)
			::hk::
			if move_type == "0" then
				--滑块
				::get_pic::
				while (true) do
					mSleep(math.random(500, 700))
					if getColor(118,  948) == 0x007aff then
						x_lens = self:moves()
						if tonumber(x_lens) > 0 then
							mSleep(math.random(500, 700))
							moveTowards( 108,  952, 10, x_len-65)
							mSleep(3000)
						else
							mSleep(math.random(500, 1000))
							randomsTap(603, 1032,10)
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

			if login_type == "1" then
				--二维码识别
				while (true) do
					mSleep(math.random(500, 700))
					if getColor(132,  766) == 0x000000 then
						mSleep(math.random(500, 700))
						snapshot("1.png", 123,  701, 442, 1093); --以 test 命名进行截图
						mSleep(math.random(1000, 1500))
						base_six_four = self:readFileBase64(userPath().."/res/1.png") 
						if fz_terrace == "0" or fz_terrace == "2" then
							::ewm_go::
							token = "c97f4c3afad288a06d092df40ab77dc2"
							header_send = {}
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
									goto wait_ys
								end
							else
								toast(body_resp,1)
								goto ewm_go
							end
						elseif fz_terrace == "1" then
							load_ewm_bool = true
							ewm_url_bool =  true
							break
						end
					end

					mSleep(math.random(500, 700))
					if getColor(118,  948) == 0x007aff then
						mSleep(math.random(500, 1000))
						randomsTap(603, 1032,10)
						mSleep(math.random(3000, 6000))
						goto hk
					end
				end
			elseif login_type == "3" then
				ewm_url = hk_url 
				toast(ewm_url,1)
				mSleep(1000)
				ewm_url_bool =  true
			end

			if ewm_url_bool then
				toast("准备发布任务",1)
				mSleep(1000)
				ewm_bool = self:ewm(phone,country_id,ewm_url,fz_terrace,load_ewm_bool,base_six_four)
				if ewm_bool then
					mSleep(500)
					toast("辅助成功",1)
					mSleep(500)
				else
					if ddwGet == "1" then
						--						writeFileString(userPath().."/res/savePhone.txt",ddwData,"a",1)jiuss
						::import_platform::
						local sz = require("sz")       
						local http = require("szocket.http")
						local res, code = http.request("http://39.99.192.160/import_platform?data="..ddwData)
						if code == 200 then
							tmp = json.decode(res)
							if tmp.code == 200 then
								toast(tmp.message,1)
								mSleep(1000)
							else
								toast("重新上传",1)
								mSleep(1000)
								goto import_platform
							end
						else
							toast("重新上传",1)
							mSleep(1000)
							goto import_platform
						end
					end
					goto over
				end
			end
		end
	end

	::hk_again::
	if move_type == "0" then
		if login_type == "0" or login_type == "2" or login_type == "3" then 
			--滑块
			::get_pic::
			while (true) do
				mSleep(math.random(500, 700))
				if getColor(118,  948) == 0x007aff then
					x_lens = self:moves()
					if tonumber(x_lens) > 0 then
						mSleep(math.random(500, 700))
						moveTowards( 108,  952, 10, x_len-65)
						mSleep(3000)
					else
						mSleep(math.random(500, 1000))
						randomsTap(603, 1032,10)
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
	end

	if login_type == "2" then
		toast("手机号辅助",1)
		mSleep(1000)
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(132,  766) == 0x000000 then
				toast("手机号辅助开始发布任务",1)
				mSleep(1000)
				if fz_terrace == "0" then
					::put_work::
					header_send = {
						token = "9F66EC5294A71EDB24C0946295472932ABE11F69175013F576E7EA746D11F974"
					}
					body_send = string.format("phone=%s&areaCode=%s",phone,country_id)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://sj.golddak.com/api/surround/v1/phone", header_send, body_send, true)
					mSleep(1000)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.message == "success" then
							toast("手机号辅助发布成功,20秒后开始查询",1)
							mSleep(20000)
						elseif tmp.message == "重复的手机号码" then
							toast("手机号重复发布",1)
							mSleep(1000)
						else
							toast(body_resp,1)
							mSleep(2000)
							goto put_work
						end
					else
						goto put_work
					end

					::check_phone::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://sj.golddak.com/api/surround/v1/status/"..phone.."?token=9F66EC5294A71EDB24C0946295472932ABE11F69175013F576E7EA746D11F974")
					mSleep(500)
					if code == 200 then
						tmp = json.decode(res)
						if tmp.message == "success" then
							if tmp.data.taskStatus == 3 then
								toast("辅助成功",1)
								mSleep(1000)
								if content_type == "0" then
									self:vpn()
								end
							elseif tmp.data.taskStatus == 4 or tmp.data.taskStatus == 5 then
								toast(tmp.data.remarks,1)
								mSleep(1000)
								goto over
							else
								toast("等待辅助,20秒后再次查询："..res,1)
								mSleep(20000)
								goto check_phone
							end

						else
							toast("辅助查询失败",1)
							mSleep(3000)
							goto check_phone
						end
					else
						toast("获取手机号码失败，重新获取",1)
						mSleep(3000)
						goto check_phone
					end
				elseif fz_terrace == "1" then
					::put_work::
					header_send = {
					}
					body_send = string.format("key=%s&tel=%s&area=%s","ABB46ACDA4F901C244A9A88F8D40578C",phone,country_id)
					ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
					status_resp, header_resp, body_resp  = ts.httpPost("http://card-api.mali126.com/api/order/telsubmit", header_send, body_send, true)
					mSleep(1000)
					nLog(body_resp)
					if status_resp == 200 then
						mSleep(500)
						local tmp = json.decode(body_resp)
						if tmp.success then
							orderId = tmp.obj.orderId
							toast("手机号辅助发布成功:"..tmp.msg..",20秒后开始查询",1)
							mSleep(20000)
						else
							toast(body_resp,1)
							mSleep(2000)
							goto put_work
						end
					else
						goto put_work
					end

					::check_phone::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://card-api.mali126.com/api/order/telquery?key=ABB46ACDA4F901C244A9A88F8D40578C&orderId="..orderId)
					mSleep(500)
					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							if tmp.obj.status == 1 then
								toast("辅助成功",1)
								mSleep(1000)
								if content_type == "0" then
									self:vpn()
								end
							elseif tmp.obj.status == 3 or tmp.obj.status == 4 or tmp.obj.status == 6 or tmp.obj.status == 8 or tmp.obj.status == 9 or tmp.obj.status == 10 then
								mSleep(1000)
								toast("辅助失败:"..tmp.obj.showString,1)
								mSleep(1000)
								goto over
							else
								toast("等待辅助,20秒后再次查询："..res,1)
								nLog(res)
								mSleep(20000)
								goto check_phone
							end
						else
							toast("辅助查询失败",1)
							mSleep(3000)
							goto check_phone
						end
					else
						toast("获取手机号码失败，重新获取",1)
						mSleep(3000)
						goto check_phone
					end
				end
			end

			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy(0x7c160,"279|8|0x7c160,133|-829|0x7c160,160|-785|0x7c160,128|-659|0x191919,216|-659|0x191919", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(373, 1099,10)
				mSleep(math.random(500, 700))
				toast("返回注册按钮",1)
				mSleep(1000)
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				toast("辅助成功，短信界面",1)
				mSleep(1000)
				break
			end
		end
	end

	mess_bool = false
	get_ms_code = false
	tiaoma_next = false
	while true do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if content_type == "0" or login_type == "2" or content_type == "2" then
				mSleep(500)
				setVPNEnable(false)
			end
			mSleep(math.random(1500, 2700))
			randomsTap(412, 489,5)
			mSleep(math.random(500, 700))
			toast("接收短信中",1)
			mess_bool = true
			get_ms_code = true
			mSleep(200)
			if login_diff_bool then
				for i = 5, 0 , -1 do
					mSleep(500)
					toast("倒计时："..((i + 1) * 5).."秒",1)
					mSleep(3500)
				end
			end
			break
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0,"136|3|0,-73|686|0x7c160,330|683|0x7c160,170|683|0xffffff,116|826|0x6ae56,205|815|0x6ae56",100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if vpn_stauts == "2" or vpn_stauts == "9"  then
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
					local content_name = userPath() .. "/res/baiduAI_content_name.jpg"
					local phone_name = userPath() .. "/res/baiduAI_phone_name.jpg"
					--内容
					snapshot(content_name, 21,587,182,676) 
					--号码
					snapshot(phone_name, 70,765,451,835) 
					local code2, body = baiduAI(access_token,content_name)
					if code2 then
						local tmp = json.decode(body)
						for i=1,#tmp.words_result,1 do
							content_num = string.lower(tmp.words_result[i].words)
						end
					else
						dialog("识别失败\n" .. body,5)
						goto over
					end 

					local code2, body = baiduAI(access_token,phone_name)
					if code2 then
						local tmp = json.decode(body)
						for i=1,#tmp.words_result,1 do
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

				::send_message::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request(ksUrl.."/yhapi.ashx?act=sendCode&token="..phone_token.."&pid="..pid.."&receiver="..phone_name.."&smscontent="..content_num)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						mSleep(500)
						randomsTap(384,1131,6)
						mSleep(2000)
						toast("发送短信成功",1)
						mSleep(1000)
						mess_bool = true
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
			break
		end

		mSleep(math.random(500, 700))
		if getColor(132,  766) == 0x000000 and getColor(159,  784) == 0x000000 then
			if tmFailBack_bool then
				if tmFailBack == "1" then
					mSleep(math.random(500, 700))
					toast("跳马失败",1)
					tiaoma_next = true
					break
				else
					mSleep(math.random(500, 700))
					randomsTap(56, 81, 8)
					mSleep(math.random(500, 700))
					tmFailBack_bool = false
					goto tiaoma
				end
			else
				mSleep(math.random(500, 700))
				toast("跳马失败",1)
				tiaoma_next = true
				break
			end
		end

		mSleep(math.random(500,700))
		if getColor(390,822) == 0x576b95 and getColor(363,822) == 0x576b95 then
			mSleep(500)
			randomsTap(390,822,5)
			mSleep(500)
			toast("拒收wwxx登录",1)
			tiaoma_next = true
			goto kq
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-38|1|0x576b95,-314|-9|0x181819,-356|-3|0x181819,-157|-155|0,24|-174|0",90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			toast("操作频繁",1)
			mSleep(500)
			setVPNEnable(false)
			setVPNEnable(false)
			mSleep(500)
			if content_type == "2" then
				self:changeIP(content_user,content_country)
			else
				if content_type ~= "1" then
					self:change_IP(content_user,content_country)
				end
			end
			closeApp(self.wc_bid)
			mSleep(math.random(5000, 6000))
			runApp(self.wc_bid)
			mSleep(math.random(1000, 1500))
			if account_len == 0 then
				goto over
			else
				tm_bool = true
				goto reset
			end
		end

		mSleep(math.random(700, 900))
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1000, 1500))
			randomsTap(372, 1105,6)
			mSleep(math.random(1000, 1500))
			toast("安全验证",1)
		end

		--滑块失败重新刷新
		mSleep(math.random(500, 700))
		if getColor(118,  948) == 0x007aff then
			mSleep(math.random(500, 1000))
			randomsTap(603, 1032,10)
			mSleep(math.random(3000, 6000))
			goto hk_again
		end
	end

	::kq::
	--跳马失败释放号码
	if tiaoma_next then
		mSleep(500)
		setVPNEnable(false)
		mSleep(3000)
		if vpn_stauts == "0" then		--柠檬
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://opapi.sms-5g.com/out/ext_api/passMobile?name=huqianjin&pwd=huqianjin2123&pn="..telphone.."&pid=180&serial=2")
			mSleep(500)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.code == 200 then
					toast("释放号码成功",1)
				end
			end
		elseif vpn_stauts == "1" then		--卡农
			if addBlack == "0" then
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.56.103.47/api.php?action=CancelNumber&token="..token.."&pid="..kn_id.."&number="..telphone)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						toast("释放手机号码",1)
					else
						goto addblack
					end
				else
					toast('释放失败，重新释放',1)
					goto addblack
				end
			else
				black_time = 0
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.56.103.47/api.php?action=AddBlackNumber&token="..token.."&pid="..kn_id.."&number="..telphone)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						toast("加黑手机号码",1)
					else
						goto addblack
					end
				else
					toast('拉黑失败，重新拉黑',1)
					mSleep(3000)
					black_time = black_time + 1
					if black_time > 15 then
						toast("拉黑多次失败，进行系一个",1)
						mSleep(1000)
					else
						goto addblack
					end
				end
			end
		elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "16" then		--奥迪
			if addBlack == "0" then
				if vpn_stauts == "13" then
					setRel_url = ksUrl.."/yhapi.ashx?act=setRel&token="..phone_token.."&iid="..kn_id.."&mobile="..telphone
				elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16" then
					setRel_url = ksUrl.."/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
				end

				::open_phone::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request(setRel_url)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("释放号码成功",1)
					elseif data[1] == "0" then
						mSleep(500)
						if data[2] == "x" then
							toast("释放失败,错误信息:"..data[2].."秒后才允许被释放",1)
							mSleep(tonumber(data[2])*1000)
							goto open_phone
						elseif data[2] == "-3" then
							toast("手机号不存在或已释放",1)
						elseif data[2] == "-4" then
							toast("已回码,不允许释放",1)
						elseif data[2] == "-5" then
							toast("短信已提交发送,不允许释放",1)
						elseif data[2] == "-6" then
							toast("释放超过次数,自动加黑",1)
						else
							toast(data[2],1)
							goto open_phone
						end
					end
				else
					toast("释放号码失败，重新释放",1)
					mSleep(5000)
					goto open_phone
				end
			else
				black_time = 0

				if vpn_stauts == "13" then
					black_url = ksUrl.."/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..kn_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
				elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16" then
					black_url = ksUrl.."/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
				end

				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request(black_url)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
					else
						if data[2] ~= "-4" then
							toast("拉黑失败"..tostring(res),1)
							mSleep(2000)
							goto addblack
						else
							toast("号码已经不存在或者释放",1)
							mSleep(1000)
						end
					end
				else
					toast('拉黑失败，重新拉黑',1)
					mSleep(3000)
					black_time = black_time + 1
					if black_time > 15 then
						toast("拉黑多次失败，进行系一个",1)
						mSleep(1000)
					else
						goto addblack
					end
				end
			end
		elseif vpn_stauts == "7" then
			::reject::
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://api.smsregs.ru/control/set-status?token=huqianjin675196542@qq.com&request_id="..requestId.."&status=reject")
			mSleep(500)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.success then
					toast("释放手机号码",1)
				else
					toast(res,1)
					mSleep(3000)
					goto reject
				end
			end
		elseif vpn_stauts == "11" then
			::black::
			local ts = require("ts")
			header_send = {}
			body_send = {}
			ts.setHttpsTimeOut(60) 
			code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=expired&apik=6b133584&id="..telphoneID, header_send,body_send)
			if code == 200 then
				tmp = json.decode(body_resp)
				if tmp.ResponseCode == 0 then
					toast("已成功取消", 1)
				else
					toast("取消失败",1)
					goto black
				end
			else
				toast("取消失败",1)
				goto black
			end
		elseif vpn_stauts == "15" then
			::addblack::
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://api.nwohsz.com:2086/registerApi/addBlack?uid=1608085312&pid=11&number="..telphone.."&sign="..lsj_key:md5())
			if code == 200 then
				mSleep(500)
				local tmp = json.decode(res)
				if tmp.code == 0 then
					toast("拉黑成功",1)
					mSleep(500)
				else
					toast("拉黑失败:"..tostring(res),1)
					mSleep(5000)
					goto addblack
				end
			else
				toast("拉黑失败:"..tostring(res),1)
				mSleep(5000)
				goto addblack
			end
		elseif vpn_stauts == "17" then
		    if addBlack == "0" then
				::open_phone::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://117.149.243.6:86/api/shouduanxin_shifang/xmid=02121-SMNAIV&sjhm="..phone.."&token="..server_token)
				mSleep(500)
				if code == 200 then
					data = strSplit(urlDecoder(res), "|")
					if data[1] == "成功" then
						toast("释放号码成功",1)
					else
						toast("释放号码失败，重新释放："..res,1)
						mSleep(5000)
						goto open_phone
					end
				else
					toast("释放号码失败，重新释放",1)
					mSleep(5000)
					goto open_phone
				end
			else
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://117.149.243.6:86/api/shouduanxin_lahei/xmid=02121-SMNAIV&sjhm="..phone.."&token="..server_token)
				mSleep(500)
				if code == 200 then
					data = strSplit(urlDecoder(res), "|")
					if data[1] == "成功" then
						toast("拉黑手机号码",1)
					else
						toast("拉黑失败"..tostring(res),1)
						mSleep(2000)
						goto addblack
					end
				else
					toast('拉黑失败，重新拉黑'..tostring(res),1)
					mSleep(3000)
					goto addblack
				end
			end
		end

		mSleep(500)
		setVPNEnable(false)
		setVPNEnable(false)
		mSleep(500)
		if content_type == "2" then
			self:changeIP(content_user,content_country)
		else
			if content_type ~= "1" then
				self:change_IP(content_user,content_country)
			end
		end
		closeApp(self.wc_bid)
		mSleep(math.random(2000, 4000))
		runApp(self.wc_bid)
		mSleep(3000)
		if account_len == 0 then
			goto over
		else
			tm_bool = true
			goto reset
		end
	end

	if mess_bool then
		if get_ms_code then
			get_time = 1
			restart_time = 0
			caozuo_more = false
			first_time = os.time()

			::caozuo_more::
			if caozuo_more then
				mSleep(500)
				if  getColor(522,770) == 0x576b95 then
					mSleep(500)
					randomsTap(213,770,5)
					mSleep(500)
					if content_type ~= "3" then
						setVPNEnable(false)
						setVPNEnable(false)
					end

					mSleep(500)
					if content_type == "2" then
						self:changeIP(content_user,content_country)
					else
						if content_type ~= "1" then
							self:change_IP(content_user,content_country)
						end
					end
					closeApp(self.wc_bid)
					mSleep(math.random(5000, 6000))
					runApp(self.wc_bid)
					mSleep(math.random(1000, 1500))
					if account_len == 0 then
						goto over
					else
						tm_bool = true
						goto reset
					end
				end
				self:sendSMSKQ()
			end

			::get_new_mess::
			if vpn_stauts == "1" then
				::get_mess::
				self:sendSMSKQ()

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.56.103.47/api.php?action=GetCode&token="..token.."&pid="..kn_id.."&number="..telphone)

				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						mess_yzm = data[2]
					elseif data[1] == "no" then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						if kn_country == "54" then
							get_time = get_time + 1
							if get_time > 17 then
								if country_id == "886" then
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
								get_time = 1
								restart_time = restart_time + 1
								caozuo_more = true
								toast("重新获取验证码"..restart_time,1)
								goto caozuo_more
							end

							if restart_time > 3 then
								if addBlack == "0" then
									::addblack::
									local sz = require("sz")        --登陆
									local http = require("szocket.http")
									local res, code = http.request("http://47.56.103.47/api.php?action=CancelNumber&token="..token.."&pid="..kn_id.."&number="..telphone)
									mSleep(500)
									if code == 200 then
										data = strSplit(res, ",")
										if data[1] == "ok" then
											toast("释放手机号码",1)
										else
											goto addblack
										end
									else
										toast('释放失败，重新释放',1)
										goto addblack
									end
								else
									::addblack::
									local sz = require("sz")        --登陆
									local http = require("szocket.http")
									local res, code = http.request("http://47.56.103.47/api.php?action=AddBlackNumber&token="..token.."&pid="..kn_id.."&number="..telphone)
									mSleep(500)
									if code == 200 then
										data = strSplit(res, ",")
										if data[1] == "ok" then
											toast("加黑手机号码",1)
										else
											goto addblack
										end
									else
										toast('拉黑失败，重新拉黑',1)
										goto addblack
									end
								end
								goto over
							end
						else
							get_time = get_time + 1
							if get_time > 17 then
								::addblack::
								local sz = require("sz")        --登陆
								local http = require("szocket.http")
								local res, code = http.request("http://47.56.103.47/api.php?action=AddBlackNumber&token="..token.."&pid="..kn_id.."&number="..telphone)
								mSleep(500)
								if code == 200 then
									data = strSplit(res, ",")
									if data[1] == "ok" then
										toast("加黑手机号码",1)
									else
										goto addblack
									end
								end
								goto over
							end
						end
						goto get_mess
					else
						toast("请求接口或者参数错误,脚本重新运行",1)
						lua_restart()
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "16" then
				if country_id == "60" then
					all_time = 15
				else
					all_time = 17
				end

				::get_mess::
				second_time = os.time()
				diff_time = os.difftime(second_time,first_time)
				if diff_time > 600000 then
					goto over
				else
					toast(diff_time,1)
					mSleep(1000)
				end

				self:sendSMSKQ()

				if get_time > all_time then
					if country_id == "886" then
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(2000, 3000))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(5000, 6000))
						if content_type ~= "3" then
							setVPNEnable(false)
						end
					else
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(2000, 3000))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(5000, 6000))
						if content_type ~= "3" then
							setVPNEnable(false)
						end
					end
					get_time = 1
					restart_time = restart_time + 1
					caozuo_more = true
					toast("重新获取验证码"..restart_time,1)
					goto caozuo_more
				end

				if restart_time > 2 then
					if addBlack == "0" then
						if vpn_stauts == "13" then
							setRel_url = ksUrl.."/yhapi.ashx?act=setRel&token="..phone_token.."&iid="..kn_id.."&mobile="..telphone
						elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16" then
							setRel_url = ksUrl.."/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid
						end

						::addblack::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request(setRel_url)
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								toast("释放手机号码",1)
							else
								if data[2] ~= "-4" then
									toast("拉黑失败"..tostring(res),1)
									mSleep(2000)
									goto addblack
								else
									toast("号码已经不存在或者释放",1)
									mSleep(1000)
								end
							end
						else
							toast('释放失败，重新释放',1)
							goto addblack
						end
					else
						if vpn_stauts == "13" then
							black_url = ksUrl.."/yhapi.ashx?act=addBlack&token="..phone_token.."&iid="..kn_id.."&mobile="..telphone.."&reason="..urlEncoder("获取失败")
						elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16" then
							black_url = ksUrl.."/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败")
						end

						::addblack::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request(black_url)
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								toast("拉黑手机号码",1)
							else
								if data[2] ~= "-4" then
									toast("拉黑失败"..tostring(res),1)
									mSleep(2000)
									goto addblack
								else
									toast("号码已经不存在或者释放",1)
									mSleep(1000)
								end
							end
						else
							toast('拉黑失败，重新拉黑',1)
							goto addblack
						end
					end
					goto over
				end

				if vpn_stauts == "13" then
					getPhoneCode_url = ksUrl.."/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&iid="..kn_id.."&mobile="..telphone
				elseif vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "16" then
					getPhoneCode_url = ksUrl.."/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid
				end

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request(getPhoneCode_url)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						mess_yzm = data[2]
					elseif data[1] == "0" then
						if data[2] == "-3" then
							toast("暂无短信"..get_time,1)
							mSleep(5000)
							get_time = get_time + 1
							goto get_mess
						elseif data[2] == "-4" then
							toast("号码已离线或强制释放",1)
							mSleep(1000)
							goto over
						end
					else
						toast("获取验证码失败，重新获取",1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "3" then
				::get_mess::
				if get_time > 25 then
					::addblack::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://52yzm.top/handler/api.php?apikey=001a21dda85bbe700fbb33f17a5eb49d&action=ban&service=67&id="..pid)
					mSleep(500)
					if code == 200 then
						data = strSplit(res, ":")
						if reTxtUtf8(data[1]) == "OK" then
							toast("拉黑手机号码",1)
						else
							goto addblack
						end
					end
					goto over
				end

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://52yzm.top/handler/api.php?apikey=001a21dda85bbe700fbb33f17a5eb49d&action=getsms&country="..countryId.."&service=67&id="..pid)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ":")
					if reTxtUtf8(data[1]) == "OK" then
						mess_yzm = data[2]
					elseif reTxtUtf8(data[1]) == "BAD" then
						if data[2] == "7" then
							toast("暂无短信"..get_time,1)
							mSleep(15000)
						elseif data[2] == "1" then
							dialog("错误的key",10)
							mSleep(500)
							lua_restart()
						elseif data[2] == "2" then
							dialog("余额不足",5)
							goto over
						end
						get_time = get_time + 1
						goto get_mess
					else
						toast("获取验证码失败，重新获取",1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "4" then
				::get_mess::
				if get_time > 25 then
					::addblack::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("https://smsregs.ru/api/v1/set_status?token=12345&request_id="..requestId.."&status=BAN")
					mSleep(500)
					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							toast("拉黑手机号码",1)
						else
							goto addblack
						end
					end
					goto over
				end

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("https://smsregs.ru/api/v1/get_sms?token=zn278868698:6DBB856EFAFE4EE77AAC&request_id="..requestId)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.sms and #tmp.sms > 0 then
						mess_yzm = tmp.sms
					elseif tmp.status == "ERROR" then
						toast("暂无短信"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					else
						toast(res,1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "5" then
				::get_mess::
				self:sendSMSKQ()

				if get_time > 17 then
					if 	country_id == "886" then
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(2000, 3000))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(5000, 6000))
						if content_type ~= "3" then
							setVPNEnable(false)
						end
					else
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(2000, 3000))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(5000, 6000))
						if content_type ~= "3" then
							setVPNEnable(false)
						end
					end
					get_time = 1
					restart_time = restart_time + 1
					caozuo_more = true
					goto caozuo_more
				end

				if restart_time > 2 then
					if ddwGet == "1" then
						--						writeFileString(userPath().."/res/savePhone.txt",ddwData,"a",1)
						::import_platform::
						local sz = require("sz")       
						local http = require("szocket.http")
						local res, code = http.request("http://39.99.192.160/import_platform?data="..ddwData)
						if code == 200 then
							tmp = json.decode(res)
							if tmp.code == 200 then
								toast(tmp.message,1)
								mSleep(1000)
							else
								toast("重新上传",1)
								mSleep(1000)
								goto import_platform
							end
						else
							toast("重新上传",1)
							mSleep(1000)
							goto import_platform
						end
					end
					goto over
				end

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://106.54.140.11/mangguo.php?&MobileNumber="..telphone.."&token="..ddwToken:atrim())
				mSleep(500)
				toast(res,1)
				if code == 200 then
					data = strSplit(res, "|")
					if reTxtUtf8(data[1]) == "OK" then
						mess_yzm = string.match(data[2], '%d+%d+%d+%d+%d+%d+')
						if ddwGet == "0" then
--							datatable = readFile(userPath().."/res/savePhone.txt")
--							table.remove(datatable, savePhone)
--							writeFile(userPath().."/res/test.txt",datatable,"w",1)
--							toast("获取验证码成功，删除文件里面这个号码",1)
--							mSleep(1000)
							::update_platform::
							local sz = require("sz")       
							local http = require("szocket.http")
							local res, code = http.request("http://39.99.192.160/update_platform?id="..get_platformId)
							if code == 200 then
								tmp = json.decode(res)
								if tmp.code == 200 then
									toast(tmp.message,1)
									mSleep(1000)
								else
									toast("重新上传",1)
									mSleep(1000)
									goto update_platform
								end
							else
								toast("重新上传",1)
								mSleep(1000)
								goto update_platform
							end
						end
					elseif reTxtUtf8(data[1]) == "ON" then
						toast("暂无短信"..get_time..":"..res,1)
						mSleep(6000)
						get_time = get_time + 1

						goto get_mess
					else
						toast("获取验证码失败，重新获取",1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "6" then
				res_time = 0
				again_time = 0
				mSleep(500)
				toast(code_url,1)
				mSleep(1000)
				::get_mess::
				self:sendSMSKQ()

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request(code_url)
				mSleep(500)
				if code == 500 then
					tmp = json.decode(res)
					if tmp.message == "error" then
						mSleep(500)
						toast(res..":"..res_time,1)
						mSleep(5200)
						res_time = res_time + 1
						if res_time > 17 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							end
							toast("重新获取验证码"..again_time,1)
							res_time = 0
							again_time = again_time + 1
							caozuo_more = true
							goto caozuo_more
						end

						if again_time > 2 then
							goto over
						else
							goto get_mess
						end
					end
				elseif code == 200 then
					mess_yzm = string.match(res, '%d+%d+%d+%d+%d+%d+')
					if #mess_yzm ~= 6 then
						toast("验证码不是6位数",1)
						goto get_mess
					else
						toast(mess_yzm,1)
					end
					yzm_bool = true
				end

				if yzm_bool then
					::push::
					mSleep(500)
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://39.99.192.160/update_data?id="..result_id)
					mSleep(500)
					if code == 200 then
						tmp = json.decode(res)
						if tmp.message == "更新成功" then
							toast("号码状态标记成功",1)
						else
							goto push
						end
					else
						toast("标记失败，重新标记",1)
						mSleep(3000)
						goto push
					end
				end
			elseif vpn_stauts == "7" then
				::get_mess::

				if get_time > 25 then
					::reject::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://api.smsregs.ru/control/set-status?token=huqianjin675196542@qq.com&request_id="..requestId.."&status=reject")
					mSleep(500)
					if code == 200 then
						tmp = json.decode(res)
						if tmp.success then
							toast("释放手机号码",1)
						else
							toast(res,1)
							mSleep(3000)
							goto reject
						end
					end
					goto over
				end

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://api.smsregs.ru/control/get-sms?token=huqianjin675196542@qq.com&request_id="..requestId)
				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.sms_code and #tmp.sms_code > 0 then
						mess_yzm = tmp.sms_code
					elseif tmp.error_msg then
						toast(tmp.error_msg..":"..get_time,1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					else
						toast(res,1)
						mSleep(5000)
						get_time = get_time + 1
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "8" then
				::get_mess::
				self:sendSMSKQ()

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://161.117.87.24/api.php?act=quYanzhengma&haoma="..telphone.."&key=99837")
				mSleep(500)
				if code == 200 then
					if tonumber(res) then
						mess_yzm = res
					else
						toast(res,1)
						mSleep(20000)
						get_time = get_time + 1
						if get_time > 6 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 2 then
							goto over
						end
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(15000)
					get_time = get_time + 1
					goto get_mess
				end
			elseif vpn_stauts == "10" then
				::get_mess::
				self:sendSMSKQ()

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://simsms.org/priemnik.php?metod=get_sms&country="..countryId.."&service=opt67&apikey=pRv27lOtdWjwW8xlLZm54NAgZLQwZr&id="..pay_id)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.response == "1" then
						toast(tmp.sms, 1)
						mess_yzm = tmp.sms
					else
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							::black::
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://simsms.org/priemnik.php?metod=ban&service=opt67&apikey=pRv27lOtdWjwW8xlLZm54NAgZLQwZr&id="..pay_id)
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
							goto over
						end
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif vpn_stauts == "11" then
				::get_mess::
				self:sendSMSKQ()

				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) 
				code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=code&apik=6b133584&id="..telphoneID, header_send,body_send)
				if code == 200 then
					tmp = json.decode(body_resp)
					if tmp.ResponseCode == 0 then
						mess_yzm = tmp.Result.Code
						toast(tmp.Result.SMS,1)
						mSleep(1000)
					elseif tmp.ResponseCode == 1 then
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							::black::
							local ts = require("ts")
							header_send = {}
							body_send = {}
							ts.setHttpsTimeOut(60) 
							code,header_resp, body_resp = ts.httpsGet("https://chothuesimcode.com/api?act=expired&apik=6b133584&id="..telphoneID, header_send,body_send)

							if code == 200 then
								tmp = json.decode(body_resp)
								if tmp.ResponseCode == 0 then
									toast("已成功取消", 1)
								else
									toast("取消失败",1)
									goto black
								end
							else
								toast("取消失败",1)
								goto black
							end
							goto over
						end
						goto get_mess
					else
						toast("获取验证码失败，重新获取:"..body_resp,1)
						mSleep(3000)
						goto get_mess
					end
				else
					toast("获取验证码失败，重新获取",1)
					mSleep(3000)
					goto get_mess
				end
			elseif vpn_stauts == "12" then
				::get_mess::
				self:sendSMSKQ()

				header_send = {}
				body_send = {}
				ts.setHttpsTimeOut(60) 
				code,header_resp, body_resp = ts.httpsGet("https://admin.smscodes.io/api/sms/GetSMSCode?key=3edcec83-89e0-4c13-a1a4-c2a12018422f&sid="..sid.."&number="..telphone, header_send,body_send)
				if code == 200 then
					tmp = json.decode(body_resp)
					if tmp.SMS == "Message not received yet" then
						toast("获取验证码失败:"..body_resp,1)
						mSleep(20000)
						get_time = get_time + 1
						if get_time > 6 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 2 then
							goto over
						end
						goto get_mess
					else
						code = strSplit(tmp.SMS," : ")
						if tonumber(code[1]) then
							mess_yzm = code[1]
						else
							toast("获取号码失败:"..body_resp,1)
							mSleep(5000)
							goto get_mess
						end
					end
				else
					toast("获取号码失败:"..body_resp,1)
					mSleep(5000)
					goto get_mess
				end
			elseif vpn_stauts == "14" then
				::get_mess::
				self:sendSMSKQ()

				::get_code::
				header_send = {
					["Content-Type"] = "application/json"
				}
				body_send = {
					["appKey"] = "x727KdG1",
					["secretKey"] = "cc128a0c117a4493b2827de05c150909",
					["taskIds"] = {
						{
							["taskId"] = taskId,
						}
					},
				}
				ts.setHttpsTimeOut(60)
				code,header_resp, body_resp = ts.httpPost("http://gvU6e7.g7e6.com:20083/api/code", header_send,body_send)
				toast(body_resp,1)
				mSleep(500)
				if code == 200 then
					mSleep(500)
					local tmp = json.decode(body_resp)
					if tmp.status == 0 and #tmp.codes > 0 then
						code = tmp.codes[1].code
						mess_yzm = string.match(code,"%d%d%d%d%d%d")
					else
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							goto over
						end
						goto get_mess
					end
				else
					toast("获取验证码失败:"..body_resp,1)
					mSleep(5000)
					goto get_code
				end
			elseif vpn_stauts == "15" then
				::get_mess::
				self:sendSMSKQ()

				::get_code::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://api.nwohsz.com:2086/registerApi/getMsg?uid=1608085312&orderId="..orderId.."&sign="..lsj_key:md5())
				toast(res,1)
				mSleep(500)
				if code == 200 then
					local tmp = json.decode(res)
					if tmp.data and #tmp.data > 0 then
						mess_yzm = tmp.data[1].code
					else
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							::addblack::
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://api.nwohsz.com:2086/registerApi/addBlack?uid=1608085312&pid=11&number="..telphone.."&sign="..lsj_key:md5())
							if code == 200 then
								mSleep(500)
								local tmp = json.decode(res)
								if tmp.code == 0 then
									toast("拉黑成功",1)
									mSleep(500)
								else
									toast("拉黑失败:"..tostring(res),1)
									mSleep(5000)
									goto addblack
								end
							else
								toast("拉黑失败:"..tostring(res),1)
								mSleep(5000)
								goto addblack
							end
							goto over
						end
						goto get_mess
					end
				else
					toast("获取验证码失败:"..tostring(res),1)
					mSleep(5000)
					goto get_code
				end
			elseif vpn_stauts == "17" then
				::get_mess::
				self:sendSMSKQ()

				::get_code::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://117.149.243.6:85/api/shouduanxin_quma/xmid=02121-SMNAIV&sjhm="..telphone.."&token="..server_token)
				toast(res,1)
				mSleep(500)
				if code == 200 then
					data = strSplit(urlDecoder(res), "|")
					if data[1] == "成功" and tostring(string.match(data[3],"短信内容")) ~= "nil" then
						mess_yzm = string.match(data[3],"%d%d%d%d%d%d")
					else
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							if addBlack == "0" then
                				::open_phone::
                				mSleep(500)
                				local sz = require("sz")        --登陆
                				local http = require("szocket.http")
                				local res, code = http.request("http://117.149.243.6:86/api/shouduanxin_shifang/xmid=02121-SMNAIV&sjhm="..phone.."&token="..server_token)
                				mSleep(500)
                				if code == 200 then
                					data = strSplit(urlDecoder(res), "|")
                					if data[1] == "成功" or tostring(string.match(data[1],"已释放但已来码")) ~= "nil" then
                						toast("释放号码成功",1)
                					else
                						toast("释放号码失败，重新释放："..res,1)
                						mSleep(5000)
                						goto open_phone
                					end
                				else
                					toast("释放号码失败，重新释放",1)
                					mSleep(5000)
                					goto open_phone
                				end
                			else
                				::addblack::
                				local sz = require("sz")        --登陆
                				local http = require("szocket.http")
                				local res, code = http.request("http://117.149.243.6:86/api/shouduanxin_lahei/xmid=02121-SMNAIV&sjhm="..phone.."&token="..server_token)
                				mSleep(500)
                				if code == 200 then
                					data = strSplit(urlDecoder(res), "|")
                					if data[1] == "成功" or tostring(string.match(data[1],"已拉黑此手机号但已来码")) ~= "nil" then
                						toast("拉黑手机号码",1)
                					else
                						toast("拉黑失败"..tostring(res),1)
                						mSleep(2000)
                						goto addblack
                					end
                				else
                					toast('拉黑失败，重新拉黑'..tostring(res),1)
                					mSleep(3000)
                					goto addblack
                				end
                			end
							goto over
						end
						goto get_mess
					end
				else
					toast("获取验证码失败:"..tostring(res),1)
					mSleep(5000)
					goto get_code
				end
			else
				::get_mess::
				self:sendSMSKQ()

				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://opapi.sms-5g.com/out/ext_api/getMsg?name=huqianjin&pwd=huqianjin2123&pn="..telphone.."&pid=180&serial=2")

				mSleep(500)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == 200 then
						mess_yzm = tmp.data
						toast(mess_yzm,1)
					elseif tmp.code == 908 then
						toast("暂未查询到验证码，请稍后再试"..get_time,1)
						mSleep(2000)
						get_time = get_time + 1
						if get_time > 15 then
							if country_id == "886" then
								mSleep(500)
								setVPNEnable(true)
								mSleep(math.random(2000, 3000))
								randomsTap(372,  749, 3)
								mSleep(math.random(1000, 1500))
								randomsTap(368, 1039,5)
								mSleep(math.random(5000, 6000))
								if content_type ~= "3" then
									setVPNEnable(false)
								end
							else
								if content_type == "1" then
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
								else
									mSleep(500)
									setVPNEnable(true)
									mSleep(math.random(2000, 3000))
									randomsTap(372,  749, 3)
									mSleep(math.random(1000, 1500))
									randomsTap(368, 1039,5)
									mSleep(math.random(5000, 6000))
									if content_type ~= "3" then
										setVPNEnable(false)
									end
								end
							end
							get_time = 1
							restart_time = restart_time + 1
							caozuo_more = true
							toast("重新获取验证码"..restart_time,1)
							goto caozuo_more
						end

						if restart_time > 1 then
							local sz = require("sz")        --登陆
							local http = require("szocket.http")
							local res, code = http.request("http://opapi.sms-5g.com/out/ext_api/passMobile?name=huqianjin&pwd=huqianjin2123&pn="..telphone.."&pid=180&serial=2")
							mSleep(500)
							if code == 200 then
								tmp = json.decode(res)
								if tmp.code == 200 then
									toast("释放号码成功",1)
								end
							end
							goto over
						end
						goto get_mess
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
			end

			if tonumber(mess_yzm) ~= tonumber(old_mess_yzm) then
				toast(mess_yzm,1)
				mSleep(math.random(1000, 1700))
				randomsTap(390,  472,9)
				mSleep(math.random(1000, 1500))
				for i = 1, #(mess_yzm) do
					mSleep(math.random(500, 700))
					num = string.sub(mess_yzm,i,i)
					if num == "0" then
						mSleep(math.random(500, 700))
						randomsTap(373, 1281, 8)
					elseif num == "1" then
						mSleep(math.random(500, 700))
						randomsTap(132,  955, 8)
					elseif num == "2" then
						mSleep(math.random(500, 700))
						randomsTap(377,  944, 8)
					elseif num == "3" then
						mSleep(math.random(500, 700))
						randomsTap(634,  941, 8)
					elseif num == "4" then
						mSleep(math.random(500, 700))
						randomsTap(128, 1063, 8)
					elseif num == "5" then
						mSleep(math.random(500, 700))
						randomsTap(374, 1061, 8)
					elseif num == "6" then
						mSleep(math.random(500, 700))
						randomsTap(628, 1055, 8)
					elseif num == "7" then
						mSleep(math.random(500, 700))
						randomsTap(119, 1165, 8)
					elseif num == "8" then
						mSleep(math.random(500, 700))
						randomsTap(378, 1160, 8)
					elseif num == "9" then
						mSleep(math.random(500, 700))
						randomsTap(633, 1164, 8)
					end
				end
			else
				goto get_new_mess
			end
			mSleep(math.random(500, 700))
			randomsTap(216,  623,11)
			mSleep(math.random(2000, 3000))
		end
		data_six_two = false
		error_wc = false
		while true do
			if EU_countries == "0" then
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0x343434,"49|-24|0x343434,2|547|0x9de7bf,326|537|0x9de7bf", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					randomsTap(355,590,8)
					mSleep(math.random(500, 700))
					if diff_user == "0" then
						nickName = self:randomStr("1234567890QWERTYUIOPASDF1234567890GHJKLZXCVBNM1234567890qwertyuiopasd1234567890fghjklzxcvbnm1234567890", math.random(8, 15))
					else
						nickName = self:randomStr("`~#^&*-=!@$;/|1234567890QWERTYUIOPASDF`~#^&*-=!@$;/|1234567890GHJKLZXCVBNM`~#^&*-=!@$;/|1234567890qwertyuiopasd`~#^&*-=!@$;/|1234567890fghjklzxcvbnm1234567890`~#^&*-=!@$;/|", math.random(8, 15))
					end
					--	end

					--检测是否有删除按钮
					mSleep(500)
					while (true) do
						mSleep(500)
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
					toast("欧盟昵称生日",1)
				end
			end

			--不是我的，继续注册
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x6ae56,"36|1|0x6ae56,136|5|0x6ae56,181|-7|0x6ae56,294|-7|0x6ae56,371|0|0xf2f2f2,-98|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("不是我的，继续注册",1)
				break
			end


			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x576b95,"28|-1|0x576b95,-84|141|0x36030,164|141|0x36030,-208|-180|0,-121|-230|0", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("手机号近期注册过wwxx",1)
				break
			end

			mSleep(math.random(500, 700))
			if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
				toast("通讯录前账号状态异常",1)
				error_wc = true
				break
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x1565fc,"6|13|0x1565fc,17|-5|0x1565fc,19|6|0x1565fc,17|20|0x1565fc", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("通讯录",1)
				break
			end

			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|-1|0x576b95,-6|-15|0x576b95,-135|-165|0,-70|-164|0,-14|-155|0", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomsTap(x,  y, 3)
				mSleep(1000)
				closeApp(self.wc_bid, 0)
				mSleep(3000)
				setVPNEnable(false)
				mSleep(500)
				if content_type == "2" then
					self:changeIP(content_user,content_country)
				else
					if content_type ~= "1" then
						self:change_IP(content_user,content_country)
					end
				end
				mSleep(1000)
				runApp(self.wc_bid)
				mSleep(2000)

				while true do
					mSleep(math.random(500, 700))
					if getColor(561,1265) == 0x576b95 then
						mSleep(math.random(500, 700))
						randomsTap(536,1266,3)
						mSleep(math.random(500, 700))
						if airplaneStatus == "1" then
							mSleep(math.random(200, 500))
							setAirplaneMode(true)
							mSleep(3000)
							setAirplaneMode(false)
						end
					end

					if getColor(393,1170) == 0 then
						mSleep(math.random(500, 700))
						randomsTap(393,1170,3)
						mSleep(math.random(500, 700))
						break
					end

					--取消
					mSleep(math.random(500, 700))
					if getColor(79,88) == 0x2bb00 then
						mSleep(math.random(500, 700))
						randomsTap(79,88,3)
						mSleep(math.random(500, 700))
					end

					mSleep(math.random(500, 700))
					x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(200, 500))
						randomsTap(549, 1240,10)
						mSleep(math.random(200, 500))
						toast("注册",1)
						break
					end
				end

				self:sendServerStatus(telphone,mess_yzm)

				toast("验证码不正确",1)
				mSleep(1000)
				goto reset
			end

			--环境异常
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x576b95,"-44|3|0x576b95,-252|-185|0,-207|-203|0,-186|-191|0,-151|-193|0,-66|-177|0,53|-181|0,-47|-141|0,-14|-59|0xe0dee1", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:sendServerStatus(telphone,"环境异常")

				mSleep(500)
				randomsTap(x,  y, 3)
				mSleep(1000)
				closeApp(self.wc_bid, 0)
				mSleep(3000)
				setVPNEnable(false)
				mSleep(500)
				if content_type == "2" then
					self:changeIP(content_user,content_country)
				else
					if content_type ~= "1" then
						self:change_IP(content_user,content_country)
					end
				end
				mSleep(1000)
				runApp(self.wc_bid)
				mSleep(2000)

				while true do
					mSleep(math.random(500, 700))
					if getColor(561,1265) == 0x576b95 then
						mSleep(math.random(500, 700))
						randomsTap(536,1266,3)
						mSleep(math.random(500, 700))
						if airplaneStatus == "1" then
							mSleep(math.random(200, 500))
							setAirplaneMode(true)
							mSleep(3000)
							setAirplaneMode(false)
						end
					end

					if getColor(393,1170) == 0 then
						mSleep(math.random(500, 700))
						randomsTap(393,1170,3)
						mSleep(math.random(500, 700))
						break
					end

					--取消
					mSleep(math.random(500, 700))
					if getColor(79,88) == 0x2bb00 then
						mSleep(math.random(500, 700))
						randomsTap(79,88,3)
						mSleep(math.random(500, 700))
					end

					mSleep(math.random(500, 700))
					x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(200, 500))
						randomsTap(549, 1240,10)
						mSleep(math.random(200, 500))
						toast("注册",1)
						break
					end
				end
				toast("环境异常",1)
				mSleep(1000)
				goto reset
			end
		end

		mSleep(10000)
		while true do
			if EU_countries == "0" then
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0x343434,"49|-24|0x343434,2|547|0x9de7bf,326|537|0x9de7bf", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					randomsTap(355,590,8)
					mSleep(math.random(500, 700))
					if diff_user == "0" then
						nickName = self:randomStr("1234567890QWERTYUIOPASDF1234567890GHJKLZXCVBNM1234567890qwertyuiopasd1234567890fghjklzxcvbnm1234567890", math.random(8, 15))
					else
						nickName = self:randomStr("`~#^&*-=!@$;/|1234567890QWERTYUIOPASDF`~#^&*-=!@$;/|1234567890GHJKLZXCVBNM`~#^&*-=!@$;/|1234567890qwertyuiopasd`~#^&*-=!@$;/|1234567890fghjklzxcvbnm1234567890`~#^&*-=!@$;/|", math.random(8, 15))
					end
					--	end

					--检测是否有删除按钮
					mSleep(500)
					while (true) do
						mSleep(500)
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
					toast("欧盟昵称生日",1)
				end
			end

			--不是我的，继续注册
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x6ae56,"36|1|0x6ae56,136|5|0x6ae56,181|-7|0x6ae56,294|-7|0x6ae56,371|0|0xf2f2f2,-98|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(x,y,8)
				mSleep(math.random(500, 700))
				toast("不是我的，继续注册",1)
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x576b95,"28|-1|0x576b95,-84|141|0x36030,164|141|0x36030,-208|-180|0,-121|-230|0", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(x,y,8)
				mSleep(math.random(500, 700))
				toast("手机号近期注册过wwxx",1)
				self:sendServerStatus(telphone,"最近注册")
				goto over
			end

			mSleep(math.random(500, 700))
			if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
				toast("通讯录前账号状态异常",1)
				error_wc = true
				break
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x1565fc,"6|13|0x1565fc,17|-5|0x1565fc,19|6|0x1565fc,17|20|0x1565fc", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				--				randomsTap(x-250,y,8)
				--				mSleep(math.random(500, 700))
				toast("通讯录",1)
				break
			end

			--环境异常
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x576b95,"-44|3|0x576b95,-252|-185|0,-207|-203|0,-186|-191|0,-151|-193|0,-66|-177|0,53|-181|0,-47|-141|0,-14|-59|0xe0dee1", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:sendServerStatus(telphone,"环境异常")

				mSleep(500)
				randomsTap(x,  y, 3)
				mSleep(1000)
				mSleep(500)
				closeApp(self.wc_bid, 0)
				mSleep(5000)
				setVPNEnable(false)
				setVPNEnable(false)
				mSleep(500)
				if content_type == "2" then
					self:changeIP(content_user,content_country)
				else
					if content_type ~= "1" then
						self:change_IP(content_user,content_country)
					end
				end
				mSleep(1000)
				runApp(self.wc_bid)
				mSleep(2000)

				while true do
					mSleep(math.random(500, 700))
					if getColor(561,1265) == 0x576b95 then
						mSleep(math.random(500, 700))
						randomsTap(536,1266,3)
						mSleep(math.random(500, 700))
						if airplaneStatus == "1" then
							mSleep(math.random(200, 500))
							setAirplaneMode(true)
							mSleep(3000)
							setAirplaneMode(false)
						end
					end

					if getColor(393,1170) == 0 then
						mSleep(math.random(500, 700))
						randomsTap(393,1170,3)
						mSleep(math.random(500, 700))
						break
					end

					--取消
					mSleep(math.random(500, 700))
					if getColor(79,88) == 0x2bb00 then
						mSleep(math.random(500, 700))
						randomsTap(79,88,3)
						mSleep(math.random(500, 700))
					end

					mSleep(math.random(500, 700))
					x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(200, 500))
						randomsTap(549, 1240,10)
						mSleep(math.random(200, 500))
						toast("注册",1)
						break
					end
				end
				goto reset
			end
		end

		mSleep(10000)

		while true do
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x1565fc,"6|13|0x1565fc,17|-5|0x1565fc,19|6|0x1565fc,17|20|0x1565fc", 90, 0, 0, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				--				randomsTap(x-250,y,8)
				--				mSleep(math.random(500, 700))
				toast("10秒后通讯录",1)
				data_six_two = true
				break
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x7c160,"483|-9|0x7c160,155|2|0xffffff,159|95|0x576b95,225|92|0x576b95,246|99|0x576b95", 90, 0, 1013, 749,  1333)
			if x~=-1 and y~=-1 then    
				mSleep(math.random(500, 700))
				randomsTap(375,1274,6)
				mSleep(math.random(500, 700))
				toast("加朋友",1)
			end

			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(653,1278,6)
				mSleep(math.random(500, 700))
				toast("wwxx界面",1)
				data_six_two = true
				break
			end

			mSleep(math.random(500, 700))
			if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
				toast("通讯录后账号状态异常",1)
				error_wc = true
				break
			end
		end

		--		if data_six_two then
		--			while true do
		--				mSleep(700)
		--				if getColor(653,1277) == 0x7c160 then
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(359,430,6)
		--					mSleep(math.random(500, 700))
		--					toast("修改昵称",1)
		--					break
		--				else
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(653,1278,6)
		--					mSleep(math.random(500, 700))
		--				end

		--				--通过siri
		--				mSleep(700)
		--				if getColor(513,833) == 0x7aff then
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(513,833,6)
		--					mSleep(math.random(500, 700))
		--					toast("通过siri打开wwxx",1)
		--				end
		--			end

		--			while true do
		--				mSleep(math.random(500, 700))
		--				x, y = findMultiColorInRegionFuzzy(0x181818,"36|-14|0x181818,60|5|0x181818,102|-2|0x181818,267|-1|0xf2f2f2", 90, 0, 0, 749,  1333)
		--				if x~=-1 and y~=-1 then
		--					mSleep(math.random(500, 700))
		--					randomsTap(653,350,6)
		--					mSleep(math.random(500, 700))
		--					toast("个人信息",1)
		--					break
		--				end

		--				mSleep(700)
		--				if getColor(653,1277) == 0x7c160 then
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(359,430,6)
		--					mSleep(math.random(500, 700))
		--				end
		--			end

		--			while true do
		--				mSleep(500)
		--				if getColor(617,82) == 0x9ce6bf then
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(555,188,6)
		--					mSleep(math.random(1000, 1700))
		--					for var= 1, 20 do
		--						mSleep(100)
		--						keyDown("DeleteOrBackspace")
		--						mSleep(100)
		--						keyUp("DeleteOrBackspace")
		--						mSleep(100)
		--					end
		--					mSleep(math.random(1000, 1700))
		--					randomsTap(49, 1283,8)
		--					mSleep(math.random(500, 700))
		--					State={
		--						["随机常量"] = 0,
		--						["姓氏"]="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
		--						"姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍" ..
		--						"史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾" ..
		--						"孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈" ..
		--						"项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡" ..
		--						"田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸" ..
		--						"左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄曲家封芮羿储靳汲邴糜松井" ..
		--						"段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎" ..
		--						"祖武符刘景詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲邰从鄂索咸籍赖卓蔺屠" ..
		--						"蒙池乔阴鬱胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛" ..
		--						"寿通边扈燕冀郟浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈" ..
		--						"廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂" ..
		--						"晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权" ..
		--						"逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台" ..
		--						"公冶宗政濮阳淳于单于太叔申屠公孙仲孙轩辕令狐钟离宇文长孙慕容鲜" ..
		--						"于闾丘司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良" ..
		--						"拓拔夹谷宰父谷粱晋楚闫法汝鄢涂钦段干百里东郭南门呼延归海羊舌微" ..
		--						"生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱" ..
		--						"阳佟第五言福百家姓终",
		--						["名字"]="安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
		--						"濮存罡禄瑛瑛嗣嫚朵寅添渟黎臻舞绢城骥彰渺禾教祖剑黎莞咸浓芦澹帅臻渟添禾亭添亭霖深策臻稷辞" ..
		--						"悟悟澄涉城鸥黎悟乔恒黎鲲涉莞霖甲深婕乔程澹男岳深涉益澹悟箫乔多职适芦瑛澄婕朵适祖霖瑛坤嫚" ..
		--						"涉男珂箫芦黎珹绢芦程识嗣珂瑰枝允黎庸嗣赐罡纵添禄霖男延甲彰咸稷箫岳悟职祖恒珂庸琅男莞庸浓" ..
		--						"多罡延瑛濮存爵添剑益骥澄延迪寅婕程霖识瑰识程群教朵悟舞岳浓箫城适程禾嫚罡咸职铃爵渺添辞嫚" ..
		--						"浓寅鲲嗣瑛鸥多教瑛迪坤铃珹群黎益澄程莞深坤澹禄职澹赩澄藉群箫骥定彰寅臻渟枝允珹深群黎甲鲲" ..
		--						"亭黎藏浓涤渟莞寅辞嗣坤迪嫚添策庸策藉瑰彰箫益莞渺乔彰延舞祖婕澹渺鸥纵嗣瑛藏濮存婕职程芦群" ..
		--						"禾嫚程辞祖黎职浓桦藏渟禾彰帅辞铃铃黎允绢濮存剑辞禾瑰添延添悟赐祖咸莞男绢策婕藉禾浓珹涤祖" ..
		--						"汉骥舞瑛多稷赐莞渟黎舞桦黎群藏渺黎坤桦咸迪澈舞允稷咸剑定亭澄濮存鲲臻全鸥多赐程添瑛亭帅悟" ..
		--						"甲男帅涤适纵渟鲲亭悟琅亭添允舞禾庸咸瑛教鲲允箫芦允瑛咸鸥帅悟延珂黎珹箫爵剑霖剑霖禄鸥悟涉" ..
		--						"彰群悟辞帅渺莞澄桦瑛适臻益霖珹亭澹辞坤程嗣铃箫策澈枝赐莞爵渟禄群枝添芦群浓赐职益城澄赩琅" ..
		--						"延群乔珹鲲祖群悟黎定庸澄芦延霖罡鲲咸渺纵亭禄鸥赩涤剑澹藏纵濮存澄芦剑延瑰稷黎益赩澄允悟澈" ..
		--						"甲嗣绢朵益甲悟涤婕群咸臻箫鲲寅鸥桦益珂舞允庸芦藉寅渺咸赐澄程剑瑰霖瑰铃帅男铃悟识瑰仕仕城" ..
		--						"允莞全朵涤铃剑渺稷剑珂铃箫全仕益纵芦桦珂濮存城朵朵咸程剑澄定澈爵寅庸定莞瑛教彰黎箫仕黎桦" ..
		--						"赩深赩爵迪悟珹涤琅添箫桦帅瑛黎黎策识寅嫚涉迪策汉舞定彰允男祖教澄群瑛濮存男禾教莞禾鸥澈濮" ..
		--						"存岳城嫚深舞教岳澄亭禾坤朵亭职莞稷寅瑰城庸亭舞禾瑛恒坤浓彰莞澄澈鸥臻稷教琅辞益剑藉黎添瑛" ..
		--						"延舞坤仕岳多婕骥迪帅黎悟全澄识益甲桦纵适罡彰澄禾婕程黎城涤浓枝箫咸渟岳渟澹臻珹识珹澄箫辞" ..
		--						"浓鲲识悟允悟禾识群祖迪渟鲲群庸莞珹悟澹瑰悟鸥汉群甲莞庸职琅莞桦鲲朵深乔辞允彰渺朵瑰亭瑰朵" ..
		--						"定深男识群职霖益男舞城允舞爵赩枝罡罡群澹芦藉爵悟渟澹禾多庸箫坤乔芦甲濮存多渟藉珹赐汉纵亭" ..
		--						"禾城枝剑露以玉春飞慧娜悠亦元晔曜霜宁桃彦仪雨琴青筠逸曼代菀孤昆秋蕊语莺丝红羲盛静南淑震晴" ..
		--						"彭祯山霞凝柔隽松翠高骊雅念皓双洛紫瑞英思歆蓉娟波芸荷笑云若宏夏妍嘉彩如鹏寄芝柳凌莹蝶舒恬" ..
		--						"虹清爽月巧乾勋翰芳罗刚鸿运枫阳葳杰怀悦凡哲瑶凯然尚丹奇弘顺依雪菡君畅白振馨寻涵问洁辉忆傲" ..
		--						"伟经润志华兰芹修晨木宛俊博韶天锐溪燕家沈放明光千永溶昊梅巍真尔馥莲怜惜佳广香宇槐珺芷帆秀" ..
		--						"理柏书沛琪仙之竹向卉欣旻晓冬幻和雁淳浩歌荣懿文幼岚昕牧绿轩工旭颜醉玑卓觅叶夜灵胜晗恨流佁" ..
		--						"乐火音采睿翎萱民画梦寒泽怡丽心石邵玮佑旺壮名一学谷韵宜冰赫新蕾美晖项琳平树又炳骏气海毅敬" ..
		--						"曦婉爰伯珊影鲸容晶婷林子昌梧芙澍诗星冉初映善越原茂国腾孟水烟半峯莉绮德慈敏才戈梓景智盼霁" ..
		--						"琇苗熙姝从谊风发钰玛忍婀菲昶可荌小倩妙涛姗方图迎惠晤宣康娅玟奕锦濯穆禧伶丰良祺珍曲喆扬拔" ..
		--						"驰绣烁叡长雯颖辰慕承远彬斯薇成聪爱朋萦田致世实愫进瀚朝强铭煦朗精艺熹建忻晏冷佩东古坚滨菱" ..
		--						"囡银咏正儿瑜宝蔓端蓓芬碧人开珠昂琬洋璠桐舟姣琛亮煊信今年庄淼沙黛烨楠桂斐胤骄兴尘河晋卿易" ..
		--						"愉蕴雄访湛蓝媛骞娴儒妮旋友娇泰基礼芮羽妞意翔岑苑暖玥尧璇阔燎偲靖行瑾资漪晟冠同齐复吉豆唱" ..
		--						"韫素盈密富其翮熠绍澎淡韦诚滢知鹍苒抒艳义婧闳琦壤杨芃洲阵璟茵驹涆来捷嫒圣吟恺璞西旎俨颂灿" ..
		--						"情玄利痴蕙力潍听磊宸笛中好任轶玲螺郁畴会暄峻略琼琰默池温炫季雰司杉觉维饮湉许宵茉贤昱蕤珑" ..
		--						"锋纬渊超萍嫔大霏楚通邈飙霓谧令厚本邃合宾沉昭峰业豪达彗纳飒壁施欢姮甫湘漾闲恩莎祥启煜鸣品" ..
		--						"希融野化钊仲蔚生攸能衍菁迈望起微鹤荫靓娥泓金琨筱赞典勇斌媚寿喜飇濡宕茜魁立裕弼翼央莘绚焱" ..
		--						"奥萝米衣森荃航璧为跃蒙庆琲倚穹武甜璐俏茹悌格穰皛璎龙材湃农福旷童亘苇范寰瓃忠虎颐蓄霈言禹" ..
		--						"章花健炎籁暮升葛贞侠专懋澜量纶布皎源耀鸾慨曾优栋妃游乃用路余珉藻耘军芊日赡勃卫载时三闵姿" ..
		--						"麦瑗泉郎怿惬萌照夫鑫樱琭钧掣芫侬丁育浦磬献苓翱雍婵阑女北未陶干自作伦珧溥桀州荏举杏茗洽焕" ..
		--						"吹甘硕赋漠颀妤诺展俐朔菊秉苍津空洮济尹周江荡简莱榆贝萧艾仁漫锟谨魄蔼豫纯翊堂嫣誉邦果暎珏" ..
		--						"临勤墨薄颉棠羡浚兆环铄"
		--					}
		--					State["随机常量"] = tonumber(self:Rnd_Word("0123456789",5))

		--					Nickname = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],1,3)

		--					--检测是否有删除按钮
		--					mSleep(math.random(500, 700))
		--					while (true) do
		--						mSleep(500)
		--						x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
		--						toast(y, 1)
		--						if x~=-1 and y~=-1 then
		--							break
		--						else
		--							mSleep(500)
		--							inputStr(Nickname)
		--							mSleep(500)
		--							toast("输入昵称",1)
		--						end
		--					end

		--					--					mSleep(math.random(500, 700))
		--					--					for i = 1, #phone do
		--					--						mSleep(math.random(500, 700))
		--					--						num = string.sub(phone,i,i)
		--					--						if num == "0" then
		--					--							randomsTap(713,  965, 8)
		--					--						elseif num == "1" then
		--					--							randomsTap(38,  964, 8)
		--					--						elseif num == "2" then
		--					--							randomsTap(112,  965, 8)
		--					--						elseif num == "3" then
		--					--							randomsTap(185,  965, 8)
		--					--						elseif num == "4" then
		--					--							randomsTap(264,  963, 8)
		--					--						elseif num == "5" then
		--					--							randomsTap(338,  964, 8)
		--					--						elseif num == "6" then
		--					--							randomsTap(414,  962, 8)
		--					--						elseif num == "7" then
		--					--							randomsTap(495,  964, 8)
		--					--						elseif num == "8" then
		--					--							randomsTap(566,  966, 8)
		--					--						elseif num == "9" then
		--					--							randomsTap(642,  961, 8)
		--					--						end
		--					--					end
		--					mSleep(math.random(1000, 1500))
		--					randomsTap(659, 84,8)
		--					mSleep(math.random(500, 700))
		--					toast("设置名字",1)
		--					break
		--				end
		--			end
		--		end

		if data_six_two or error_wc then
			function write_data(inifile,key)
				F=io.open(userPath().."/res/"..inifile,"a")
				F:write(key,'\n')
				F:close()
			end

			function getData() --获取six-two-data (可以用的)
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
					local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var]..self.wc_file,"rb") 
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
			time = getNetTime()
			sj=os.date("%Y年%m月%d日%H点%M分%S秒",time)
			mSleep(200)
			toast(sj)       --或这样
			mSleep(1000)
			user = "00"..country_id..phone
			mSleep(500)
			if data_six_two then
				file_path = "完成的账号.ini"
				is_normal = "true"
			elseif error_wc then 
				file_path = "秒封的账号.ini"
				is_normal = "false"
			end

			write_data(file_path,user.."----"..password.."----"..six_data.."----"..sj)
			mSleep(500)

			if vpn_stauts == "6" then
				mSleep(200)
				api = code_url
			else
				mSleep(200)
				api = "null"
			end

			::send::
			local sz = require("sz")       
			local http = require("szocket.http")
			local res, code = http.request("http://39.99.192.160/import_data?phone="..user.."&password="..password.."&token="..six_data.."&is_normal="..is_normal.."&operator="..operator.."&link="..urlEncoder(api).."&time="..sj)
			if code == 200 then
				tmp = json.decode(res)
				if tmp.code == 200 then
					toast(tmp.message,1)
					mSleep(1000)
				-- 	self.newIndex = "1"
				-- 	self:clear_App()
				else
					toast("重新上传",1)
					mSleep(1000)
					goto send
				end
			else
				toast("重新上传",1)
				mSleep(1000)
				goto send
			end

			if content_type == "3" then
				setVPNEnable(false)
			end

			fh_bool = false
			if login_type == "0" then
				if login_times == "1" then
					mSleep(500)
					account_len = account_len + 1
					if login_times == "0" then
						times = 1
					elseif login_times == "1" then
						times = 18
					end

					if data_six_two then
						mSleep(500)
						randomsTap(42,82,3)
						mSleep(500)
					end

					if account_len == times then
						toast(times.."个注册完成",1)
						mSleep(1000)
					else
						toast("第"..account_len.."个注册完成",1)
						mSleep(1000)

						self:idCard(country_id)

						while true do
							mSleep(500)
							if getColor(654,1279) == 0x7c160 then
								mSleep(500)
								x,y = findMultiColorInRegionFuzzy( 0x191919, "5|13|0x191919,38|-7|0x191919,21|4|0x191919,57|8|0x191919,39|10|0x191919,54|18|0x444444,-77|5|0x1485ee", 90, 0, 680, 749, 1333)
								if x~=-1 and y~=-1 then
									mSleep(500)
									randomTap(x,y,2)
									mSleep(1000)
								end
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
								toast("封号1",1)
								mSleep(500)
								fh_bool = true
								break
							end

							mSleep(math.random(500, 700))
							if getColor(346, 803) == 0x576b95 and getColor(390, 796) == 0x576b95 then
								mSleep(500)
								randomsTap(362,797,4)
								mSleep(500)
								toast("封号2",1)
								mSleep(500)
								fh_bool = true
								break
							end

							mSleep(math.random(500, 700))
							if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
								mSleep(500)
								randomsTap(362,797,4)
								mSleep(500)
								toast("账号状态异常",1)
								mSleep(500)
								fh_bool = true
								break
							end
						end

						if not fh_bool then
							while true do
								mSleep(500)
								if getColor(356,1167) == 0x191919 then
									mSleep(500)
									tap(356,1167)
									mSleep(1000)
								end

								mSleep(500)
								if getColor(356,1172) == 0xe64340 then
									mSleep(500)
									tap(356,1172)
									mSleep(5000)
									break
								end
							end
						end

						mSleep(500)
						closeApp(self.wc_bid, 0)
						mSleep(5000)
						setVPNEnable(false)
						setVPNEnable(false)
						mSleep(500)
						if content_type == "2" then
							self:changeIP(content_user,content_country)
						else
							if content_type ~= "1" then
								self:change_IP(content_user,content_country)
							end
						end
						mSleep(1000)
						runApp(self.wc_bid)
						mSleep(2000)

						while true do
							mSleep(math.random(500, 700))
							if getColor(561,1265) == 0x576b95 then
								mSleep(math.random(500, 700))
								randomsTap(536,1266,3)
								mSleep(math.random(500, 700))
								if airplaneStatus == "1" then
									mSleep(math.random(200, 500))
									setAirplaneMode(true)
									mSleep(3000)
									setAirplaneMode(false)
								end
							end

							if getColor(393,1170) == 0 then
								mSleep(math.random(500, 700))
								randomsTap(393,1170,3)
								mSleep(math.random(500, 700))
								break
							end

							--取消
							mSleep(math.random(500, 700))
							if getColor(79,88) == 0x2bb00 then
								mSleep(math.random(500, 700))
								randomsTap(79,88,3)
								mSleep(math.random(500, 700))
							end
						end
						goto reset
					end
				end
			end
		end
		mess_bool = false
	end

	::over::
	if account_len == 0 or account_len == times then
		if data_six_two then
			mSleep(500)
			randomsTap(42,82,3)
			mSleep(500)
			self:idCard(country_id)
		end

		mSleep(math.random(200, 500))
		closeApp(self.wc_bid)
		mSleep(math.random(200, 500))
	else
		if data_six_two then
			mSleep(500)
			randomsTap(42,82,3)
			mSleep(500)
			self:idCard(country_id)
		end

		mSleep(500)
		closeApp(self.wc_bid, 0)
		mSleep(5000)
		setVPNEnable(false)
		setVPNEnable(false)
		mSleep(500)
		if content_type == "2" then
			self:changeIP(content_user,content_country)
		else
			if content_type ~= "1" then
				self:change_IP(content_user,content_country)
			end
		end
		mSleep(1000)
		runApp(self.wc_bid)
		mSleep(2000)

		while true do
			mSleep(math.random(500, 700))
			if getColor(561,1265) == 0x576b95 then
				mSleep(math.random(500, 700))
				randomsTap(536,1266,3)
				mSleep(math.random(500, 700))
				if airplaneStatus == "1" then
					mSleep(math.random(200, 500))
					setAirplaneMode(true)
					mSleep(3000)
					setAirplaneMode(false)
				end
			end

			if getColor(393,1170) == 0 then
				mSleep(math.random(500, 700))
				randomsTap(393,1170,3)
				mSleep(math.random(500, 700))
				break
			end

			--取消
			mSleep(math.random(500, 700))
			if getColor(79,88) == 0x2bb00 then
				mSleep(math.random(500, 700))
				randomsTap(79,88,3)
				mSleep(math.random(500, 700))
			end
		end
		goto reset
	end
	data_six_two = false
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
				["size"] = 30,
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
				["text"] = "滑块滑动方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "自动,手动",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "跳马注册次数",
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
				["type"] = "Label",
				["text"] = "选择网络连接方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "vpn,流量,国内vpn,全程vpn",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "网页切换ip账号",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入网页切换ip账号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "网页切换ip国家代码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入网页切换ip国家代码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择卡商平台",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "柠檬,卡农注册,奥迪,52,俄罗斯1,东帝汶,服务器取号,俄罗斯2,各国API,老友,SMS,越南,各国API2,奶茶,柠檬2,老司机,水煮鱼,松鼠",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "卡农注册/奥迪/52/东帝汶/服务器取号/各国API/老友的区号",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入卡农注册/奥迪/52/东帝汶/服务器取号/各国API/老友的区号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "卡农注册/奥迪/老友的项目ID",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入卡农注册/奥迪/老友的项目ID",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置柠檬/52/俄罗斯1/俄罗斯2/各国API的国家代码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的国家代码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择国家区号位数",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "1,2,3",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择注册方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "跳马注册,二维码辅助注册,手机号辅助注册,滑块链接注册",
				["select"] = "0",  
				["countperline"] = "3",
			},
			{
				["type"] = "Label",
				["text"] = "选择需要辅助的平台",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "薄荷,马力,捍卫者",
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
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的昵称",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置密码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "上传服务器标识",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的服务器标识",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "奥迪卡农老友拉黑释放选择",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "释放,拉黑",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "随机昵称",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "不加特殊字符,特殊字符",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "随机密码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "不随机,随机",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "东帝汶号码获取方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "服务器获取存储号码,平台接口获取",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "是否开启关闭飞行模式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "无,开启关闭",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "是否新机连vpn",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "连接,不连接",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "是否是欧盟国家注册",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "欧盟,非欧盟",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "跳马失败是否返回",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "返回,不返回",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择替换文件版本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "暂不替换,715,717,备用",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "输入替换备用文件版本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要替换备用文件版本",
				["text"] = "718",       
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, move_type, login_times, content_type, content_user, content_country, vpn_stauts, kn_country, kn_id, countryId, country_len, login_type, fz_terrace, nickName, password, operator, addBlack, diff_user, ran_pass, ddwGet, airplaneStatus, connect_vpn, EU_countries, tmFailBack, replaceFile, replaceFileVersion = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if countryId == "" or countryId == "默认值" then
		dialog("国家代码不能为空，请重新运行脚本设置国家代码", 3)
		luaExit()
	end

	if password == "" or password == "默认值" then
		dialog("密码不能为空，请重新运行脚本设置密码", 3)
		luaExit()
	end
	local m = TSVersions()
	if m <= "1.2.7" then
		dialog("请使用 v1.2.8 及其以上版本 TSLib",0)
		luaExit()
	else
		ts_version = ts.version()
		toast("TSLib版本为："..m.."\r\nts.so版本为："..ts_version,1)
	end
	
	if replaceFile == "3" then
	    if replaceFileVersion == "" or replaceFileVersion == "默认值" then
    		dialog("替换备用文件版本不能为空，请重新运行脚本设置替换备用文件版本", 3)
    		luaExit()
    	end
	end
	
	self:getConfig()
	
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
		    self:replace_file(file_name)
		elseif replaceFile == "2" then
		    file_name = "717.plist"
		    self:replace_file(file_name)
		elseif replaceFile == "3" then
		    file_name = replaceFileVersion .. ".plist"
		    self:replace_file(file_name)
		end
	end

	get_six_two = false
	while true do
		if vpn_stauts == "2" then
			ksUrl = "http://www.3cpt.com"
			ApiName = "huqianjin54"
		elseif vpn_stauts == "9" then
			ksUrl = "http://web.lyf5.com"
			ApiName = "huqianjin42"
		elseif vpn_stauts == "13" then
			ksUrl = "http://web.jiaotai56.com"
			ApiName = "huqianjin89"
		elseif vpn_stauts == "16" then
			ksUrl = "http://api.hegrace-safex.cn"
			ApiName = "api_huqianjin_m8k"
		end

		if vpn_stauts == "1" or vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "16" then
			mSleep(500)
			if kn_country == "" or kn_country == "默认值" then
				dialog("国家区号不能为空，请重新运行脚本设置国家区号", 3)
				luaExit()
			end

			if kn_id == "" or kn_id == "默认值" then
				dialog("项目id不能为空，请重新运行脚本设置id", 3)
				luaExit()
			end
		end
		mSleep(math.random(200, 500))
		closeApp(self.wc_bid)
		mSleep(500)
		setVPNEnable(false)
		setVPNEnable(false)
		mSleep(500)
		if content_type == "2" then
			self:changeIP(content_user,content_country)
		else
			if content_type ~= "1" then
				self:change_IP(content_user,content_country)
			end
		end

		if vpn_stauts == "2" or vpn_stauts == "9" or vpn_stauts == "13" or vpn_stauts == "16" then
			::get_token::
			local sz = require("sz");
			local http = require("szocket.http")
			local res, code = http.request(ksUrl.."/yhapi.ashx?act=login&ApiName="..ApiName.."&PassWord=huqianjin")
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

		self:clear_App()
		self:Net()
		self:wc(ksUrl,move_type,operator,login_times,content_user,content_country,content_type,vpn_stauts,phone_token,kn_country,kn_id,countryId,nickName,password,country_len,login_type,addBlack,diff_user,ran_pass,ddwGet,airplaneStatus,connect_vpn,EU_countries,tmFailBack)
		mSleep(1000)
	end
end

model:main()

