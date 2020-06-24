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

--下面是子程序
function model:change_IP(content_user,content_country)--换IP
	while true do
		mSleep(500)
		status_resp, header_resp,body_resp = ts.httpGet("http://gate.rola-ip.site:333/?user="..content_user.."&country="..content_country)
		
		mSleep(1000)
		if (status_resp==200) then--打开网站成功
			local 返回号=json.decode(body_resp)["Msg"]
			if (返回号=="IP修改成功") then
				mSleep(200)
				toast(body_resp)
				mSleep(1000)
				break;  
				return 1
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

--删除文件
function model:delFile(path)--帮你玩平台禁用此函数
	mSleep(500)
	os.execute("rm -rf "..path)
end

function model:clear_App(content_user,content_country)
	mSleep(1000)
	closeApp(model.wc_bid)
	mSleep(1000)
	dataPath = appDataPath("com.tencent.xin")
	mSleep(1000)
	if dataPath ~= nil then
		mSleep(500)
		local a = io.popen("ls "..dataPath.."/Library/Caches") 
		for l in a:lines() do 
			mSleep(500)
			local a = io.popen("ls "..dataPath.."/Library/Caches") 
			for l in a:lines() do 
				::remove_again::
				mSleep(500)
				status = ts.hlfs.removeDir(dataPath.."/Library/Caches/"..l)--删除 hello 文件夹及所有文件
				if status then
					toast(dataPath.."/Library/Caches/"..l.."文件删除成功",1)
					mSleep(1000)
				else
					toast("文件删除失败重新删除",1)
					mSleep(1000)
					goto remove_again
				end
			end 
		end 
		
	else
		toast("数据路径不存在",1)
	end
	
	closeApp(self.awz_bid)
	::run_again::
	mSleep(math.random(500, 700))
	runApp(self.awz_bid)
	mSleep(1000*math.random(2, 4))
	::set_ip_again::
	while true do
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			mSleep(500)
			if getColor(146,443) == 0x6f7179 then
				toast("awz进入成功",1)
				mSleep(1000)
				if network_type == "1" then
					self:change_IP(content_user,content_country)
					mSleep(1000)
					setVPNEnable(true)
				elseif network_type == "2" or network_type == "3" then
					mSleep(1000)
					setVPNEnable(true)
				end
				mSleep(5000)
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
			toast("新机成功，不过ip重复，重新切ip",1)
--			setVPNEnable(false)
--			mSleep(3000)
--			goto set_ip_again
		elseif result == 1 then
			toast("成功",1)
		else 
			toast("失败，请手动查看问题", 1)
			goto new_phone
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

function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
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

function model:moves()
	mns = 80
	mnm = "66|0|0,67|67|0,1|67|0,2|15|0,2|54|0,51|63|0,17|63|0,35|30|0,17|25|0,47|27|0"

	toast("滑动",1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 28, 440, 609, 773)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	mSleep(500)
	if self:file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 640, 1136);   
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

function model:ewm(login_type,phone,ewm_url,fz_terrace,country_id)
	if fz_terrace == "0" then
		if login_type == "2" then
			qrCode = "qrCodeUrl"
		else
			qrCode = "qrCodeImg"
		end
		
		::put_work::
		header_send = {
		}
		body_send = string.format("userKey=%s&"..qrCode.."=%s&phone=%s","7fd606d7697248daa9580b4d91f02fad",ewm_url,phone)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.ymassist.com/assist/api/order/submit", header_send, body_send, true)
		nLog(body_resp)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				orderId = tmp.object.orderId
				toast("发布成功,id:"..orderId,1)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto put_work
			end
		else
			goto put_work
		end
	elseif fz_terrace == "1" then
		::put_work::
		header_send = {
		}
		body_send = string.format("userKey=%s&qrCodeImg=%s&phone=%s&provinceId=%s","0AC5DD5FD444A4E0301CA74A901FCD4E",ewm_url,phone,"210000")
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://card-api.mali126.com/api/order/submit", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				taskId = tmp.obj.orderId
				toast("发布成功,id:"..tmp.obj.orderId,1)
			else
				toast(body_resp,1)
				mSleep(3000)
				goto put_work
			end
		else
			goto put_work
		end
	elseif fz_terrace == "2" then
		::put_work::
		header_send = {
		}
		body_send = string.format("key=%s&url=%s&tel=%s&area=%s","08d05d48-1bd1-447d-9ae4-45583aa098b2", ewm_url, phone, country_id)
		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.tvnxl.com/xd/tj", header_send, body_send, true)
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
			goto put_work
		end
	end

	bioaji_bool = false
	time = os.time() + 365
	--查询订单状态
	while (true) do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"14|44|0x7c160,-2|24|0xffffff,-131|626|0x7c160,148|617|0x7c160,4|600|0x7c160,-10|629|0xffffff", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(317, 899,6)
			mSleep(math.random(500, 700))
			if fz_terrace == "0" then
				status = 3
			elseif fz_terrace == "1" then
				status = 1
			elseif fz_terrace == "2" then
				sts = "success"
			end
			bioaji_bool = true
		end
		
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"334|3|0x9ce6bf,135|-317|0x353535,186|-330|0x353535,233|-334|0x353535", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			break
		end
		
		new_time = os.time()
		if new_time >= time then
			if fz_terrace == "0" then
				status = 6
			elseif fz_terrace == "1" then
				status = 2
			elseif fz_terrace == "2" then
				sts = "fail"
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
		}
		body_send = string.format("userKey=%s&orderId=%s&status=%s", "7fd606d7697248daa9580b4d91f02fad", orderId, status)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://api.ymassist.com/assist/api/order/mark", header_send, body_send, true)
		if status_resp == 200 then
			tmp = json.decode(body_resp)
			if tmp.success then
				if bioaji_bool then
					toast("任务结果:"..tmp.object.statusDesc, 1)
					return true
				else
					return false
				end
			elseif tmp.msg == "订单已超时" then
				return false
			else
				toast(tmp.msg,1)
				mSleep(1000)
				goto push_work
			end
		else
			goto push_work
		end
	elseif fz_terrace == "1" then
		::push_work::
		header_send = {
		}
		body_send = string.format("userKey=%s&orderId=%s&status=%s","0AC5DD5FD444A4E0301CA74A901FCD4E",taskId,status)
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
		::push_work::
		header_send = {
		}
		body_send = string.format("key=%s&oId=%s&sts=%s","08d05d48-1bd1-447d-9ae4-45583aa098b2",oId,sts)
		ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
		status_resp, header_resp, body_resp  = ts.httpPost("http://www.tvnxl.com/xd/xg", header_send, body_send, true)
		if status_resp == 200 then
			local tmp = json.decode(body_resp)
			if tmp.code == "3" then
				if bioaji_bool then
					toast("标记成功",1)
					return true
				else
					return false
				end
			elseif tmp.code == "4" then
				return false
			else
				goto push_work
			end
		else
			goto push_work
		end
	end
end

function model:wechat(content_user,content_country,hk_way,service_user,service_pass,content_user,content_country,login_type,fz_terrace,ks_type,ks_user, ks_pass,ks_id,kn_user, kn_pass, kn_id,password,phone_token,ks_country,TM_loginError)
	addblack = false
	ewm_url_bool = false
	check_ewm = true
	::over::
	if addblack then
		setVPNEnable(false)
		mSleep(7000)
		goto overs
	end
	::start::
	closeApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	runApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	login_check = 0
	
	while (true) do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"94|0|0xffffff,154|-2|0x7c160,-125|1|0xffffff,-203|5|0x6ae56,-280|0|0xffffff", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(469, 1049,6)
			mSleep(math.random(200, 500))
			toast("注册",1)
			break
		else
			login_check = login_check + 1
			mSleep(1000)
		end
		
		if login_check > 5 then
			self:clear_App(content_user,content_country)
			goto start
		end
		
	end

	while (true) do
		--11系统
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"339|-3|0x9ce6bf,117|-7|0xd7f5e5,113|-702|0x353535,227|-699|0x353535",90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			toast("注册页面",1)
			mSleep(1000)
			break
		end
	end
	
	if ks_type == "0" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..ks_id)
		mSleep(500)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "1" then
				mSleep(200)
				telphone = data[5]
				pid = data[2]
				toast(telphone,1)
			elseif data[1] == "0" then
				toast("获取手机号码失败，重新获取",1)
				mSleep(1000)
				goto get_phone
			else
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif ks_type == "1" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.115.87.250:8080/muup2/index?m=Lua.getZh&name=API&password=112233")
		mSleep(500)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "ok" then
				mSleep(200)
				telphone = data[2]
				code_url = data[3]
				service_data = data[2].."|"..urlEncoder(data[3])
				toast(telphone,1)
			else
				mSleep(1000)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif ks_type == "2" then
		::get_token::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=Login&user="..kn_user.."&pwd="..kn_pass)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				tokens = data[2]
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
		local res, code = http.request("http://47.56.103.47/api.php?action=GetNumber&token="..tokens.."&pid="..kn_id)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				telphone = data[2]
			elseif data[1] == "no" then
				toast(data[2],1)
				mSleep(1000)
				goto get_phone
			elseif data[1] == "error" then
				toast(data[2],1)
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
	end
	
	if ks_type == "0" then
		country_id = ks_country
		b,c = string.find(string.sub(telphone,1,#country_id),country_id)
		if c ~= nil then
			phone = string.sub(telphone,c+1,#telphone)
		else
			phone = telphone
		end
	else
		country_id = ks_country
		phone = telphone
	end
	
	nick_name = self:randomStr("1234567890",8)
	--昵称
	mSleep(math.random(200, 500))
	randomsTap(370, 504, 5)
	mSleep(math.random(200, 500))
	inputText(nick_name)
	mSleep(math.random(200, 500))	

	--国家／地区
	while (true) do
		--707版本
		mSleep(math.random(200, 500))
		x, y = findMultiColorInRegionFuzzy(0,"39|7|0,113|13|0,127|25|0,123|99|0xc9c9c9", 90, 0, 0, 640, 968)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x + 83,y + 104, 6)
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
			randomsTap(316,1083, 8)
		elseif num == "1" then
			mSleep(math.random(200, 300))
			randomsTap(110,763, 8)
		elseif num == "2" then
			mSleep(math.random(200, 300))
			randomsTap(322,757, 8)
		elseif num == "3" then
			mSleep(math.random(200, 300))
			randomsTap(534,764, 8)
		elseif num == "4" then
			mSleep(math.random(200, 300))
			randomsTap(107,868, 8)
		elseif num == "5" then
			mSleep(math.random(200, 300))
			randomsTap(329,859, 8)
		elseif num == "6" then
			mSleep(math.random(200, 300))
			randomsTap(535,870, 8)
		elseif num == "7" then
			mSleep(math.random(200, 300))
			randomsTap(108,972, 8)
		elseif num == "8" then
			mSleep(math.random(200, 300))
			randomsTap(316,964, 8)
		elseif num == "9" then
			mSleep(math.random(200, 300))
			randomsTap(524,967, 8)
		end
	end

	--密码
	while (true) do
		mSleep(math.random(200, 500))
		x, y = findMultiColorInRegionFuzzy(0,"39|7|0,113|13|0,127|25|0,123|99|0xc9c9c9", 90, 0, 0, 640, 968)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x + 340,y + 104, 6)
			mSleep(math.random(200, 500))
			break
		end
	end

	mSleep(500)
	inputText(phone)
	mSleep(1200)

	--密码
	while (true) do
		mSleep(math.random(200, 500))
		x, y = findMultiColorInRegionFuzzy(0,"10|23|0,14|18|0,26|16|0,38|16|0,54|9|0,42|115|0x9ce6bf", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+340,y,8)
			mSleep(math.random(200, 500))
			inputText(password)
			mSleep(math.random(200, 500))
			break
		end
	end
	
	::wait_ys::
	if not check_ewm then
		mSleep(500)
		setVPNEnable(false)
		mSleep(2000)
		if network_type == "1" then
			self:change_IP(content_user,content_country)
			mSleep(1000)
			setVPNEnable(true)
		elseif network_type == "2" or network_type == "3" then
			mSleep(1000)
			setVPNEnable(true)
		end
	end
	
	--协议后下一步
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-63|12|0x07c160,128|13|0x07c160,54|13|0xffffff,295|-2|0x07c160,-262|6|0x07c160", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
			break
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"540|-7|0x9ce6bf,270|30|0x9ce6bf,270|-89|0x576b95", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x+100,y,10)
			mSleep(math.random(200, 500))
			break
		end
	end
	
	--隐秘政策
	time = 0
	while (true) do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xcdcdcd,"14|22|0xcdcdcd,51|12|0xcdcdcd,-105|8|0xfafafa,189|9|0xfafafa,-211|-784|0x444444,-67|-772|0x444444", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x-182, y-96,3)
			mSleep(math.random(200, 500))
			mSleep(500)
			break
		else
			time = time + 1
			toast("等待隐秘政策"..time,1)
			mSleep(math.random(1500, 2500))
		end

		if time > 60 then
			mSleep(math.random(2000, 3000))
			randomsTap(56, 81, 8)
			mSleep(math.random(200, 500))
			goto wait_ys
		end
	end
	
	--隐秘政策：下一步
	while (true) do
		mSleep(math.random(200, 500))
		if getColor(251, 1006) == 0x07c160 then
			mSleep(math.random(300, 600))
			randomsTap(251, 1006,10)
			mSleep(math.random(200, 500))
			toast("隐秘政策同意：下一步",1)
		end
		
		--再次检测隐秘正常勾选
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xcdcdcd,"14|22|0xcdcdcd,51|12|0xcdcdcd,-105|8|0xfafafa,189|9|0xfafafa,-211|-784|0x444444,-67|-772|0x444444", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x-182, y-96,3)
			mSleep(math.random(200, 500))
		end
		
		--操作过于频繁
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|4|0x576b95,-284|-13|0x181819,-334|-5|0x181819,-380|-157|0,-199|-166|0,-143|-155|0,-160|-54|0xe0dee1", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x, y,3)
			mSleep(math.random(200, 500))
			if ks_type == "0" then
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败"))
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
						mSleep(500)
					else
						toast(res,1)
						mSleep(1000)
						goto addblack
					end
				end
			elseif ks_type == "2" then
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
			end
			addblack = true
			goto over
		end
		
		mSleep(math.random(200, 500))
		if getColor(299,  291) == 0x10aeff and getColor(207, 902) == 0x07c160 then
			toast("准备安全验证",1)
			mSleep(2000)
			break
		end
	end
	
	if login_type == "2" then
		hk_url = self:get_hkUrl(country_id)
		hk_url = urlEncoder(hk_url)
	end
	
	::get_pic::
	--安全验证
	while (true) do
		mSleep(math.random(700, 900))
		if getColor(299,  291) == 0x10aeff and getColor(207, 902) == 0x07c160 then
			mSleep(math.random(1000, 1500))
			randomsTap(317, 903,6)
			mSleep(math.random(1000, 1500))
			toast("安全验证",1)
			break
		end

		mSleep(math.random(200, 500))
		if getColor(251, 1006) == 0x07c160 then
			mSleep(math.random(300, 600))
			randomsTap(251, 1006,10)
			mSleep(math.random(200, 500))
			toast("下一步",1)
		end
	end
	
	if  login_type == "0" or login_type == "1" or login_type == "2" then
		::hk::
		if hk_way == "1" then
			--滑块
			while (true) do
				mSleep(math.random(500, 700))
				if getColor(98,823) == 0x007aff then
					x_lens = self:moves()
					if tonumber(x_lens) > 0 then
						mSleep(math.random(500, 700))
						moveTowards(92,  824, 0, x_len-65)
						mSleep(3000)
					else
						mSleep(math.random(500, 1000))
						randomsTap(588, 898,10)
						mSleep(math.random(3000, 6000))
						goto get_pic
					end
					break
				end
				
				mSleep(math.random(700, 900))
				if getColor(299,  291) == 0x10aeff and getColor(207, 902) == 0x07c160 then
					mSleep(math.random(1000, 1500))
					randomsTap(317, 903,6)
					mSleep(math.random(1000, 1500))
					toast("安全验证",1)
				end
			end
		end
		
		if login_type == "1" then
			--二维码识别
			while (true) do
				mSleep(math.random(500, 700))
				if getColor(130,  811) == 0x000000 then
					mSleep(math.random(500, 700))
					snapshot("1.png", 95,  745, 460, 1136); --以 test 命名进行截图
					mSleep(math.random(1000, 1500))
					base_six_four = self:readFileBase64(userPath().."/res/1.png") 
					ewm_url = base_six_four
					ewm_url_bool =  true
					mSleep(1000)
					break
				end

				mSleep(math.random(500, 700))
				if getColor(98,823) == 0x007aff then
					mSleep(math.random(500, 1000))
					randomsTap(513, 898,4)
					mSleep(math.random(3000, 6000))
					goto hk
				end
			end
		elseif login_type == "2" then
			ewm_url = hk_url 
			toast(ewm_url,1)
			mSleep(1000)
			ewm_url_bool =  true
		end
		
		if ewm_url_bool then
			toast("准备发布任务",1)
			mSleep(1000)
			ewm_bool = self:ewm(login_type,phone,ewm_url,fz_terrace,country_id)
			if ewm_bool then
				mSleep(500)
				toast("辅助成功",1)
				mSleep(500)
			else
				if ks_type == "1" then
					::send::
					local sz = require("sz")       
					local http = require("szocket.http")
					local res, code = http.request("http://47.115.87.250:8080/muup2/index?m=Lua.addZh&name=fz1&password=112233&zh="..service_data)
					if code == 200 then
						if res == "ok" then
							toast("数据上传状态:"..res,1)
							mSleep(1000)
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
				end
				addblack = true
				goto over
			end
		end
	end
	
	mess_bool = false
	TM_loginError_times = 1
	::wait_mess::
	--短信界面
	while true do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"334|3|0x9ce6bf,135|-317|0x353535,186|-330|0x353535,233|-334|0x353535", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1500, 2700))
			randomsTap(426, 404,5)
			mSleep(math.random(500, 700))
			toast("接收短信中",1)
			mess_bool = true
			break
		end
		
		mSleep(math.random(500, 700))
		if getColor(129,804) == 0 and getColor(154,829) == 0 then
			if check_ewm then
				if TM_loginError_times > tonumber(TM_loginError) - 1 then
					check_ewm = false
				end
				mSleep(math.random(1500, 2700))
				randomsTap(54, 83,3)
				mSleep(math.random(1000, 1700))
				toast("跳马失败，出现二维码了,返回重新注册",1)
				goto wait_ys
			else
				toast("跳马失败，出现二维码了,释放号码",1)
				if ks_type == "0" then
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
							toast(res,1)
							mSleep(2000)
							goto addblack
						end
					end
				elseif ks_type == "2" then
					::addblack::
					local sz = require("sz")        --登陆
					local http = require("szocket.http")
					local res, code = http.request("http://47.56.103.47/api.php?action=CancelNumber&token="..tokens.."&pid="..kn_id.."&number="..telphone)
					mSleep(500)
					if code == 200 then
						data = strSplit(res, ",")
						if data[1] == "ok" then
							toast("释放手机号码",1)
						else
							goto addblack
						end
					end
				end
				addblack = true
				goto over
			end
		end
		
		--操作过于频繁
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|4|0x576b95,-284|-13|0x181819,-334|-5|0x181819,-380|-157|0,-199|-166|0,-143|-155|0,-160|-54|0xe0dee1", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x, y,3)
			mSleep(math.random(200, 500))
			if ks_type == "0" then
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
						toast(res,1)
						mSleep(2000)
						goto addblack
					end
				end
			elseif ks_type == "2" then
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.56.103.47/api.php?action=CancelNumber&token="..tokens.."&pid="..kn_id.."&number="..telphone)
				mSleep(500)
				if code == 200 then
					data = strSplit(res, ",")
					if data[1] == "ok" then
						toast("释放手机号码",1)
					else
						goto addblack
					end
				end
			end
			addblack = true
			goto over
		end

		--红色报错
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xfa5151,"30|-10|0xffffff,-18|154|0x191919,-55|595|0x7c160,160|605|0x7c160,11|605|0xffffff", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1500, 2700))
			randomsTap(55, 83,5)
			mSleep(math.random(500, 700))
			goto wait_ys
		end
		
	end
	
	get_time = 0
	getCodeAgain = false
	if mess_bool then
		restart_time = 0
		if ks_type == "0" then
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid)
			mSleep(500)
			if code == 200 then
				data = strSplit(res, "|")
				if data[1] == "1" then
					mess_yzm = data[2]
				elseif data[1] == "0" then
					toast("暂无短信"..get_time,1)
					mSleep(5000)
					get_time = get_time + 1
					if get_time > 22 then
						mSleep(math.random(1000, 1500))
						randomsTap(309,  633, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(318, 885,5)
						mSleep(math.random(1000, 1500))
						get_time = 1
						restart_time = restart_time + 1
						getCodeAgain = true
						toast("重新获取验证码",1)
					end
					
					mSleep(500)
					x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|5|0x576b95,-379|-159|0,-312|-159|0,-175|-158|0,-142|-156|0,29|-162|0,-128|-157|0xf9f7fa", 90, 0, 0, 640, 1136)
					if x~=-1 and y~=-1 then
						mSleep(math.random(1500, 2700))
						randomsTap(x, y,5)
						mSleep(math.random(500, 700))
						::addblack::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败"))
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								toast("拉黑手机号码",1)
							else
								goto addblack
							end
						end
						addblack = true
						goto over
					end
		
					if restart_time > 2 then
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
						addblack = true
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
		elseif ks_type == "1" then
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request(code_url)
			mSleep(500)
			if code == 200 then
				res = urlDecoder(urlEncoder(res))
				mess_yzm = string.match(res, '%d+%d+%d+%d+%d+%d+')
				if type(mess_yzm) == "nil" then
					mSleep(500)
					toast(res..":"..res_time,1)
					mSleep(5000)
					res_time = res_time + 1
					if res_time > 19 then
						mSleep(math.random(1000, 1500))
						tap(372,  749)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(1000, 1500))
						toast("重新获取验证码"..again_time,1)
						res_time = 0
						again_time = again_time + 1
					end
					
					if again_time > 4 then
						addblack = true
						goto over
					else
						goto get_mess
					end
				elseif #mess_yzm == 6 and tonumber(mess_yzm) > 0 then
					mess_yzm = string.match(res, '%d+%d+%d+%d+%d+%d+')
				else 
					toast(res..":"..res_time,1)
					mSleep(3000)
					goto get_mess
				end
			else
				toast("获取验证码失败，重新获取",1)
				mSleep(3000)
				goto get_mess
			end
		elseif ks_type == "2" then
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://47.56.103.47/api.php?action=GetCode&token="..tokens.."&pid="..kn_id.."&number="..phone)
			mSleep(500)
			if code == 200 then
				data = strSplit(res, ",")
				if data[1] == "ok" then
					mess_yzm = data[2]
				elseif data[1] == "no" then
					toast("暂无短信"..get_time,1)
					mSleep(5000)
					get_time = get_time + 1
					if get_time > 25 then
						mSleep(math.random(1000, 1500))
						randomsTap(309,  633, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(318, 885,5)
						mSleep(math.random(1000, 1500))
						get_time = 1
						restart_time = restart_time + 1
						getCodeAgain = true
						toast("重新获取验证码",1)
					end
					
					if restart_time > 2 then
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
						addblack = true
						goto over
					else
						goto get_mess
					end
				else
					toast(res,1)
					mSleep(3000)
					goto get_mess
				end
			else
				toast("获取验证码失败，重新获取",1)
				mSleep(3000)
				goto get_mess
			end
		end
		
		toast(mess_yzm,1)
		mSleep(2000)
		if getCodeAgain then
			mSleep(math.random(1000, 1700))
			randomsTap(319, 465,5)
			mSleep(math.random(500, 700))
		end
		
		if network_type == "1" then
			self:change_IP(content_user,content_country)
			mSleep(1000)
		end
		
		for i = 1, #(mess_yzm) do
			mSleep(math.random(500, 700))
			num = string.sub(mess_yzm,i,i)
			if num == "0" then
				mSleep(math.random(200, 300))
				randomsTap(316,1083, 8)
			elseif num == "1" then
				mSleep(math.random(200, 300))
				randomsTap(110,763, 8)
			elseif num == "2" then
				mSleep(math.random(200, 300))
				randomsTap(322,757, 8)
			elseif num == "3" then
				mSleep(math.random(200, 300))
				randomsTap(534,764, 8)
			elseif num == "4" then
				mSleep(math.random(200, 300))
				randomsTap(107,868, 8)
			elseif num == "5" then
				mSleep(math.random(200, 300))
				randomsTap(329,859, 8)
			elseif num == "6" then
				mSleep(math.random(200, 300))
				randomsTap(535,870, 8)
			elseif num == "7" then
				mSleep(math.random(200, 300))
				randomsTap(108,972, 8)
			elseif num == "8" then
				mSleep(math.random(200, 300))
				randomsTap(316,964, 8)
			elseif num == "9" then
				mSleep(math.random(200, 300))
				randomsTap(524,967, 8)
			end
		end
		mSleep(math.random(500, 700))
		randomsTap(316,  529,11)
		mSleep(math.random(500, 700))
	end
	
	if ks_type == "0" then
		::addblack::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败"))
		mSleep(500)
		if code == 200 then
			data = strSplit(res, "|")
			if data[1] == "1" then
				toast("拉黑手机号码",1)
			else
				goto addblack
			end
		end
	elseif ks_type == "2" then
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
	end
	
	txl = 0
	while true do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"17|6|0x1565fc,-89|-241|0,-57|-251|0,-11|-258|0,8|83|0x157efb", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1500, 2700))
			toast("通讯录界面,等待10秒",1)
			mSleep(math.random(1500, 2700))
			txl = 1
			break
		end
		
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|3|0x576b95,-189|-246|0,-32|-223|0,50|-133|0,133|-101|0xf9f7fa", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1500, 2700))
			toast("账号被封界面",1)
			mSleep(math.random(1500, 2700))
			break
		end
		
		--不是我的
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xededed,"445|-10|0xededed,63|-15|0x25b66a,210|10|0x6ae56,336|4|0x6ae56,365|0|0x6ae56", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,5)
			mSleep(math.random(500, 700))
		end
		
		--一个月内号码注册过微信
		x, y = findMultiColorInRegionFuzzy(0x576b95,"28|0|0x576b95,-196|-240|0,-159|-232|0,-71|-178|0,47|-137|0,26|-98|0xf9f7fa", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,5)
			mSleep(math.random(500, 700))
			if ks_type == "0" then
				::addblack::
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=addBlack&token="..phone_token.."&pid="..pid.."&reason="..urlEncoder("获取失败"))
				mSleep(500)
				if code == 200 then
					data = strSplit(res, "|")
					if data[1] == "1" then
						toast("拉黑手机号码",1)
						mSleep(500)
					else
						toast(res,1)
						mSleep(1000)
						goto addblack
					end
				end
			elseif ks_type == "2" then
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
			end
			addblack = true
			goto over
		end
	end
	
	if txl == 1 then
		mSleep(5000)
	end
	
	get_six_two = false
	while true do
		--通讯录：好
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"17|6|0x1565fc,-89|-241|0,-57|-251|0,-11|-258|0,8|83|0x157efb", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			get_six_two = true
			break
		end
		
		--账号被封
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x576b95,"-28|3|0x576b95,-189|-246|0,-32|-223|0,50|-133|0,133|-101|0xf9f7fa", 90, 0, 0, 640, 1136)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 6)
			mSleep(math.random(500, 700))
			break
		end
	end
	
	function write_data(inifile,key)
		F=io.open(userPath().."/"..inifile,"a")
		F:write(key,'\r\n')
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
	time = getNetTime()
	sj=os.date("%Y年%m月%d日%H点%M分%S秒",time)
	mSleep(200)
	toast(sj)       --或这样
	mSleep(1000)
	user = "00"..country_id..phone
	mSleep(500)
	if get_six_two then
		file_path = "完成的账号.ini"
	else
		file_path = "秒封的账号.ini"
	end
	
	if ks_type == "1" then
		content = user.."----"..password.."----"..six_data.."----"..urlEncoder(code_url).."----"..sj
	else
		content = user.."----"..password.."----"..six_data.."----"..sj
	end
	
	write_data(file_path,content)
	mSleep(500)
	
	if get_six_two then
		::send::
		local sz = require("sz")       
		local http = require("szocket.http")
		local res, code = http.request("http://47.115.87.250:8080/muup2/index?m=Lua.addZh&name="..service_user.."&password="..service_pass.."&zh="..content)
		if code == 200 then
			if res == "ok" then
				toast("数据上传状态:"..res,1)
				mSleep(1000)
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
	else
		::send::
		local sz = require("sz")       
		local http = require("szocket.http")
		local res, code = http.request("http://47.115.87.250:8080/muup2/index?m=Lua.addZh&name=ms1&password=112233&zh="..content)
		if code == 200 then
			if res == "ok" then
				toast("数据上传状态:"..res,1)
				mSleep(1000)
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
	end
	
	::overs::
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
				["list"] = "手动,自动",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "网络连接方式",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "4G,wifi+vpn,4G+vpn,vpn",
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
				["list"] = "跳马注册,二维码辅助注册,滑块链接辅助注册",
				["select"] = "0",  
				["countperline"] = "2",
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
				["list"] = "有米(二维码/滑块),马力(二维码),fz(滑块)",
				["select"] = "0",  
				["countperline"] = "2",
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
				["list"] = "奥迪,服务器取号,卡农",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "奥迪卡商平台账号",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的奥迪卡商平台账号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "奥迪卡商平台密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的奥迪卡商平台密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "奥迪卡商平台项目id",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的奥迪卡商平台项目id",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "卡农卡商平台账号",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的卡农卡商平台账号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "卡农卡商平台密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的卡农卡商平台密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "卡农卡商平台项目id",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的卡农卡商平台项目id",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置号码国家区号",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的号码国家区号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置微信注册密码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的微信注册密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置切换ip的账号",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置切换ip的账号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置切换ip的国家代码",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置切换ip的国家代码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "服务器上传用户名",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的服务器上传用户名",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "服务器上传用户名的密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的服务器上传用户名的密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "跳马失败循环注册次数",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的跳马失败循环注册次数",
				["text"] = "默认值",       
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, hk_way, network_type, login_type, fz_terrace, ks_type, ks_user, ks_pass, ks_id,kn_user, kn_pass, kn_id, ks_country, password, content_user,content_country, service_user, service_pass, TM_loginError = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
	
	while true do
		if network_type == "0" then
			mSleep(500)
			setAirplaneMode(true)
			mSleep(3000)
			setAirplaneMode(false)
		elseif network_type == "2" then
			mSleep(500)
			setWifiEnable(false)
			mSleep(500)
			setVPNEnable(false)
		else
			mSleep(500)
			setVPNEnable(false)
		end
		mSleep(3000)
		
		if ks_type == "0" then
			::get_token::
			local sz = require("sz");
			local http = require("szocket.http")
			local res, code = http.request("http://www.3cpt.com/yhapi.ashx?act=login&ApiName="..ks_user.."&PassWord="..ks_pass)
			if code == 200 then
				data = strSplit(res,"|")
				if data[1] == "1" then
					phone_token = data[2]
					toast(phone_token,1)
				else
					toast(res,1)
					mSleep(1000)
					goto get_token
				end
			else
				goto get_token
			end
		end
			
		self:clear_App(content_user,content_country)
		self:wechat(content_user,content_country,hk_way,service_user,service_pass,content_user,content_country,login_type,fz_terrace,ks_type,ks_user, ks_pass,ks_id,kn_user, kn_pass, kn_id,password,phone_token,ks_country,TM_loginError)
	end
end

model:main()