--wechat version 7.0.8
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json
local model 				= {}
--local qr 				= require("tsqr")
 
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

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
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
	mSleep(1000*math.random(8, 12))

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
	closeApp(self.awz_bid)
	mSleep(math.random(200, 500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(5, 7))

	while true do
		mSleep(500)
		if getColor(147,456) == 0x6f7179 then
			break
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
			setVPNEnable(false)
			for var= 1, 8 do
				mSleep(math.random(200, 500))
				toast("ip重复，等待切换"..var,1)
				mSleep(math.random(200, 500))
			end
			setVPNEnable(true)
			mSleep(10000)
			goto new_phone
		elseif result == 1 then
			toast("成功",1)
		else 
			dialog("失败，请手动查看问题", 0)
		end
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

function model:ewm(fz_type,go_ProvinceId,phone,ewm_url)
	if fz_type == "0" then
		appid = "13097010828"
		appkey = "7DAAD15B192B105BEC1317AE16A69BCC"

		sign = appid .. appkey .. phone
		new_sign = sign:md5()
		mSleep(1000)
		--下单
		::down_ewm::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://api.qtfz888.com/simple/upload?appId="..appid.."&sign="..new_sign.."&taskKey="..phone.."&type=3&qrInfo="..ewm_url.."&expireTime=300&provCode=990000")
		if code == 200 then
			tmp = json.decode(res)
			if tmp.returnCode == 100 then
				toast(tmp.returnMsg, 1)
				taskId = tmp.data.taskId
			end
		else
			goto down_ewm
		end 
	elseif fz_type == "1" then
		function 提交辅助(ewm_url)--提交辅助
			尝试次数=0
			while true do
				尝试次数=尝试次数+1
				mSleep(100)
				toast("正在第" ..尝试次数.."次尝辅助结果")
				mSleep(1000)
				header_send = {token = "9EFF92762BF429DECA29C8E99F9EC36A4D1A6B54A1D14688B73161332C60D52E"}
				mSleep(200)
				body_send = {}
				mSleep(200)
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				mSleep(200)
				--str是二维码分解地址
				code,status_resp,body_resp = ts.httpPost("http://s.golddak.com:8080/task/publish?provCode=000001&qr="..ewm_url.."", header_send, body_send)
				--dialog(code)
				toast(body_resp,1)
				mSleep(2000)
				if (code==200) then--打开网站成功
					symbol=":"
					pos=1
					data = strSplit(body_resp,symbol,pos)  --data = {1,2,3}
					yid=data[5]
					mSleep(100)
					symbol="}"
					pos=1
					data = strSplit(yid,symbol,pos)  --data = {1,2,3}
					fzid=data[1]
					--dialog(fzid)
					mSleep(500)
					toast("提交辅助成功ID"..fzid)
					mSleep(2000) 
					break;  
				else
					toast("提交辅助成功ID..失败")
					mSleep(2000) 
				end

				if (code==502) then--打开网站失败
					toast("打开网站失败等待5秒")
					mSleep(5000)
				end

				if 尝试次数==5 then 
					mSleep(100)
					toast("提交辅助失败.....重启"); 
					mSleep(1000)
					释放手机号()
					mSleep(1000)
					lua_restart()
				end
			end
		end
		提交辅助(ewm_url)
		
	elseif fz_type == "2" then
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
			token = "AF3F54966D8E7AA98F14DCBBD42B6BF29386E34AE78689EC906E496F1C9343D6"
		}
		body_send = string.format("phone=%s&provCode=%s&qr=%s",phone,"000001",ewm_url)

		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
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
	elseif fz_type == "3" then
		--下单
		::down_ewm::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://api.ymassist.com/assist/api/order/submit?userKey=2babc99543304dc6815975dba5f84dfd&qrCodeUrl="..ewm_url.."&phone="..phone)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.success or tmp.success == "true" then
				mSleep(200)
				orderId = tmp.object.orderId
				toast("发布成功,id:"..orderId,1)
			else
				toast("发布失败",1)
				mSleep(1000)
				goto down_ewm
			end
		else
			goto down_ewm
		end
	elseif fz_type == "4" then
		::put_work::

		header_send = {
		}
		body_send = string.format("userKey=%s&qrCodeUrl=%s&phone=%s&provinceId=%s","079CD5BB63B2D7C69927ECC108BAD034",ewm_url,phone,go_ProvinceId)

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
	end

	bioaji_bool = false
	if fz_type == "0" or fz_type == "2" or fz_type == "3" or fz_type == "4" then
		time = os.time() + 300
	elseif fz_type == "1" then
		time = os.time() + 360
	end

	--查询订单状态
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x7c160,"279|8|0x7c160,133|-829|0x7c160,160|-785|0x7c160,128|-659|0x191919,216|-659|0x191919", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(373, 1099,10)
			mSleep(math.random(500, 700))
			status = 1
			bioaji_bool = true
			break
		end

		new_time = os.time()
		if new_time >= time then
			status = 2
			toast("辅助超时，进入标记失败订单",1)
			break
		else
			toast(new_time,1)
			mSleep(1000)
		end
	end

	if fz_type == "0" then
		::push_work::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://api.qtfz888.com/simple/result?appId="..appid.."&sign="..new_sign.."&taskKey="..phone.."&taskId="..taskId.."&taskResult="..status)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.returnCode == 100 then
				if bioaji_bool then
					toast("任务结果"..tmp.returnMsg, 1)
					return true
				else
					return false
				end
			end
		else
			goto push_work
		end 
		
	elseif fz_type == "1" then
		function 提交失败(fzid)--自动识别图片
			while true do
				header_send = {token = "这个自己填"}
				body_send = {}
				ts.setHttpsTimeOut(60) --安卓不支持设置超时时间
				code,status_resp,body_resp = ts.httpPost("http://s.golddak.com:8080/task/update?tid="..fzid.."&status=3", header_send, body_send)
				--dialog(code)
				--dialog(body_resp,5)
				mSleep(2000)
				if (code==200) then--打开网站成功
					toast("辅助已失败，提交成功")
					mSleep(2000) 
					break;  
				else
					toast("辅助已失败，手机号："..手机号)
					mSleep(2000)
				end

				if (code==502) then--打开网站失败
					toast("打开网站失败等待5秒")
					mSleep(5000)
				end
			end
		end
		
		if status == 2 then
			提交失败(fzid)
			return false
		else
			return true
		end
		
	elseif fz_type == "2" then
		--标记订单
		::push_work::

		header_send = {
			token = "AF3F54966D8E7AA98F14DCBBD42B6BF29386E34AE78689EC906E496F1C9343D6"
		}
		body_send = string.format("status=%s&taskId=%s",status + 1, taskId)

		ts.setHttpsTimeOut(80)--安卓不支持设置超时时间 
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
			else
				toast(body_resp,1)
				mSleep(1000)
				goto push_work
			end
		else
			toast(body_resp,1)
			mSleep(1000)
			goto push_work
		end
	elseif fz_type == "3" then
		if status == 1 then
			status = 3
		elseif status == 2 then
			status = 6
		end
		
		::push_work::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://api.ymassist.com/assist/api/order/mark&userKey=2babc99543304dc6815975dba5f84dfd&orderId="..orderId.."&status="..status)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.success then
				if bioaji_bool then
					toast("任务结果:"..tmp.object.statusDesc, 1)
					return true
				else
					return false
				end
			else
				toast(tmp.msg,1)
				mSleep(1000)
				goto push_work
			end
		else
			toast("标记订单接口出错"..res,1)
			mSleep(1000)
			goto push_work
		end 
	elseif fz_type == "4" then
		::push_work::

		header_send = {
		}
		body_send = string.format("userKey=%s&orderId=%s&status=%s","079CD5BB63B2D7C69927ECC108BAD034",taskId,status)

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
			else
				goto push_work
			end
		else
			goto push_work
		end
	end
end


function model:wchat(wc_version, net_type, ks_type, kn_id, fz_type, go_ProvinceId, phone_token, ks_id, country_id, phone_len, password)
	closeApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	runApp(self.wc_bid)
	mSleep(math.random(1000, 1500))
	while (true) do
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

	while (true) do
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
	end

	if ks_type == "0" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=getPhone&token="..phone_token.."&iid="..ks_id)
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
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif ks_type == "1" then
		::get_token::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=Login&user=sjq0822&pwd=sjq666666")

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				mSleep(200)
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
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.56.103.47/api.php?action=GetNumber&token="..tokens.."&pid="..kn_id)

		mSleep(500)
		if code == 200 then
			data = strSplit(res, ",")
			if data[1] == "ok" then
				mSleep(200)
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
	elseif ks_type == "2" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://47.92.125.255/get_data")

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
				dialog("没有可用的美国号码,即将退出运行",10)
				lua_exit()
			else
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取",1)
			mSleep(1000)
			goto get_phone
		end
	elseif ks_type == "3" then
		::get_phone::
		mSleep(500)
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://172.96.210.124:9192/api/mobile?token=ee4219333ef82fa890918a29a395ae27bf5a46ce&src=tl&app=WeChat&username=taishan11")
		mSleep(500)
		if code == 200 then
			tmp = json.decode(res)
			if tmp.msg == "success" then
				mSleep(200)
				telphone = tmp.data
				toast(telphone,1)
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

	s1 = self:randomStr("abcdefghijklmnopqrstuvwxyz", 3) --生成 6 位随机字母
	mSleep(200)
	s2 = self:randomStr("abcdefghijklmnopqrstuvwxyz", 3) --生成 6 位随机字母

	nickName = s1 .. " " .. s2

	--昵称
	mSleep(math.random(200, 500))
	randomsTap(348, 518, 8)
	mSleep(math.random(200, 500))
	inputStr(nickName)
	mSleep(math.random(1000, 1500))	

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
	
	if ks_type == "3" then
		country_id = "670"
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
	
	if ks_type == "0" then
		mSleep(500)
		if #telphone > 11 then
			phone = string.sub(telphone, #country_id + 1, #telphone)
		elseif #telphone == 11 then
			phone = telphone
		else
			phone = telphone
		end
	elseif ks_type == "1" or ks_type == "2" then
		phone = telphone
	elseif ks_type == "3" then
		phone = string.sub(telphone, #country_id + 1,#telphone)
	end
	
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
			mSleep(math.random(200, 500))
			inputStr(password)
			mSleep(math.random(200, 500))
			break
		end
	end

	cheack_bool = true
	ewm_url_bool = false
	
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
	
	::wait_ys::
	--协议后下一步
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-63|12|0x07c160,128|13|0x07c160,54|13|0xffffff,295|-2|0x07c160,-262|6|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x,y,4)
			mSleep(math.random(500, 700))
			break
		end

		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"540|-7|0x9ce6bf,270|30|0x9ce6bf,270|-89|0x576b95",90,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x+100,y,4)
			mSleep(math.random(500, 700))
			break
		end
	end

	erweima_bool = false
	::erweima::
	if erweima_bool then
		mSleep(math.random(1000, 1700))
		randomsTap(373, 1035,10)
		mSleep(math.random(500, 700))
		erweima_bool = false
	end

	--隐秘政策
	time = 0
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "48|13|0xcdcdcd,80|4|0xcdcdcd,-87|11|0xfafafa,186|13|0xfafafa,50|34|0xfafafa,265|13|0xffffff", 100, 0, 966, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x-240, y-98,3)
			mSleep(math.random(1000, 1500))
			toast("隐秘政策同意",1)
			mSleep(500)
			break
		else
			time = time + 1
			toast("等待隐秘政策"..time,1)
			mSleep(math.random(1000, 1500))
		end

		if time > 40 then
			mSleep(math.random(200, 500))
			randomsTap(56, 81, 8)
			mSleep(math.random(200, 500))
			while (true) do
				mSleep(math.random(200, 500))
				if getColor(281, 1037) == 0x07c160 then
					mSleep(math.random(200, 500))
					randomsTap(281, 1037,8)
					mSleep(math.random(200, 500))
					break
				end
			end
			time = 0
		end
	end

	--隐秘政策：下一步
	while (true) do
		mSleep(math.random(200, 500))
		if getColor(300, 1201) == 0x07c160 then
			mSleep(math.random(300, 600))
			randomsTap(370, 1204,10)
			mSleep(math.random(200, 500))
			toast("下一步",1)
		end

		mSleep(math.random(200, 500))
		if getColor(353,  287) == 0x10aeff and getColor(304, 1105) == 0x07c160 then
			toast("准备安全验证",1)
			mSleep(2000)
			break
		end
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
	end

	::hk::
	--滑块
	::get_pic::
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

	--二维码识别
	while (true) do
		mSleep(math.random(500, 700))
		if getColor(132,  766) == 0x000000 then
			mSleep(math.random(500, 700))
			snapshot("1.png", 123,  701, 442, 1093); --以 test 命名进行截图
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
		end

		mSleep(math.random(500, 700))
		if getColor(118,  948) == 0x007aff then
			goto hk
		end
	end

	if ewm_url_bool then
		toast("准备发布任务",1)
		mSleep(1000)
		ewm_bool = self:ewm(fz_type,go_ProvinceId,phone,ewm_url)
		if ewm_bool then
			toast("辅助成功",1)
		else
			toast("辅助超时",1)
			goto over
		end
	end

	mess_bool = false
	while true do
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x353535,"44|23|0x353535,67|20|0x353535,-6|331|0,30|317|0,67|317|0,105|455|0x9ce6bf,486|480|0x9ce6bf", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			if vpn_stauts == "2" then
				mSleep(500)
				setVPNEnable(false)
				mSleep(2000)
			end
			mSleep(math.random(500, 700))
			randomsTap(412, 489,5)
			mSleep(math.random(500, 700))
			toast("接收短信中",1)
			mess_bool = true
			break
		end

		mSleep(math.random(500, 700))
		if getColor(132,  766) == 0x000000 then
			mSleep(math.random(500, 700))
			toast("跳马失败",1)
			break
		end
	end

	if mess_bool then
		get_time = 1
		restart_time = 1
		
		if ks_type == "0" then
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=getPhoneCode&token="..phone_token.."&pid="..pid)
			mSleep(500)
			if code == 200 then
				data = strSplit(res, "|")
				if data[1] == "1" then
					mess_yzm = data[2]
				elseif data[1] == "0" then
					toast("暂无短信"..get_time,1)
					mSleep(15000)
					get_time = get_time + 1
					if get_time > 6 then
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(1000, 1500))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(1000, 1500))
						setVPNEnable(false)
						get_time = 1
						restart_time = restart_time + 1
						caozuo_more = true
						toast("重新获取验证码"..restart_time,1)
					end
					
					if restart_time > 2 then
						::addblack::
						local sz = require("sz")        --登陆
						local http = require("szocket.http")
						local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=setRel&token="..phone_token.."&pid="..pid)
						mSleep(500)
						if code == 200 then
							data = strSplit(res, "|")
							if data[1] == "1" then
								toast("释放手机号码",1)
							else
								goto addblack
							end
						end
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
			local res, code = http.request("http://47.56.103.47/api.php?action=GetCode&token="..tokens.."&pid="..kn_id.."&number="..telphone)
			mSleep(500)
			if code == 200 then
				data = strSplit(res, ",")
				if data[1] == "ok" then
					mess_yzm = data[2]
				elseif data[1] == "no" then
					toast("暂无短信"..get_time,1)
					mSleep(5000)
					get_time = get_time + 1
					if get_time > 20 then
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(1000, 1500))
						randomsTap(372,  749, 3)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(1000, 1500))
						setVPNEnable(false)
						get_time = 1
						restart_time = restart_time + 1
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
						goto over
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
		
		elseif ks_type == "2" then
			res_time = 0
			again_time = 0
			mSleep(500)
			toast(code_url,1)
			mSleep(1000)
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request(code_url)
			mSleep(500)
			if code == 200 then
				if res == "暂时没有短信,请2秒后再次刷新...." then
					mSleep(500)
					toast(res..":"..res_time,1)
					mSleep(5200)
					res_time = res_time + 1
					if res_time > 12 then
						mSleep(500)
						setVPNEnable(true)
						mSleep(math.random(1000, 1500))
						tap(372,  749)
						mSleep(math.random(1000, 1500))
						randomsTap(368, 1039,5)
						mSleep(math.random(1000, 1500))
						setVPNEnable(false)
						toast("重新获取验证码"..again_time,1)
						res_time = 0
						again_time = again_time + 1
					end
					
					if again_time > 4 then
						goto over
					else
						goto get_mess
					end
				else
					mess_yzm = string.match(res, '%d+%d+%d+%d+%d+%d+')
					if #mess_yzm ~= 6 then
						toast("验证码不是6位数",1)
						goto get_mess
					end
					yzm_bool = true
				end
			else
				toast("获取验证码失败，重新获取",1)
				mSleep(3000)
				goto get_mess
			end
			
			if yzm_bool then
				::push::
				mSleep(500)
				local sz = require("sz")        --登陆
				local http = require("szocket.http")
				local res, code = http.request("http://47.92.125.255/update_data?id="..result_id)
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
		elseif ks_type == "3" then
			::get_mess::
			mSleep(500)
			local sz = require("sz")        --登陆
			local http = require("szocket.http")
			local res, code = http.request("http://172.96.210.124:9192/api/code?token=ee4219333ef82fa890918a29a395ae27bf5a46ce&src=tl&app=WeChat&username=taishan11&mobile="..telphone)
			mSleep(500)
			if code == 200 then
				tmp = json.decode(res)
				if #(tmp.data:atrim()) > 0 then
					mess_yzm = tmp.data
				else
					toast("暂无短信"..get_time,1)
					mSleep(5000)
					get_time = get_time + 1
					if get_time > 20 then
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
		end

		mSleep(math.random(500, 700))
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
		mSleep(math.random(500, 700))
		randomsTap(216,  623,11)
		mSleep(math.random(500, 700))

		get_six_two = false

		while (true) do
			--通讯录匹配
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|13|0x576b95,14|-4|0x576b95,14|6|0x576b95,18|18|0x576b95", 90, 0, 0, 645,  845)
			if x~=-1 and y~=-1 then
				mSleep(500)
				toast("通讯录匹配",1)
				get_six_two = true
				break
			end
			
			mSleep(math.random(500, 700))
			x, y = findMultiColorInRegionFuzzy(0x1565fc,"1|14|0x1565fc,12|-4|0x1565fc,16|6|0x1565fc,12|21|0x1565fc,-174|-247|0", 90, 0, 0, 645,  845)
			if x~=-1 and y~=-1 then
				mSleep(500)
				toast("通讯录匹配",1)
				get_six_two = true
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
				toast("封号3",1)
				break
			end
			
			--环境异常
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0x576b95,"-44|3|0x576b95,-252|-185|0,-207|-203|0,-186|-191|0,-151|-193|0,-66|-177|0,53|-181|0,-47|-141|0,-14|-59|0xe0dee1", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomsTap(x,  y, 3)
				mSleep(1000)
				setVPNEnable(true)
				mSleep(4000)
				toast("注册环境异常",1)
				mSleep(1000)
				get_time = 1
				restart_time = 0
				goto wait_ys
			end
		end
		
		if get_six_two then
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

			function _自定义提取62数据流程(password,ks_type,code_url)
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
					dialog("提取失败！", time)
				end	
				local ts = require("ts")
				time = getNetTime()    
				now = os.date("%Y年%m月%d日%H点%M分%S秒",time) 
				mSleep(math.random(500, 700))
				all_data = wx.."----"..password.."----"..data
				toast(all_data,1)
				mSleep(1200)
				status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSprite/res/62数据") --新建文件夹
				writeFileString(userPath().."/res/62数据/62数据wxid.txt",wxid.."----"..password.."----"..data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				writeFileString(userPath().."/res/62数据/62数据手机号.txt",all_data.."----"..now,"a",1) --将 string 内容存入文件，成功返回 true
				mSleep(1000)
				
				if ks_type == "2" then
					mSleep(200)
					api = code_url
				else
					mSleep(200)
					api = "null"
				end
				
				toast(api,1)
				mSleep(1000)
				::send::
				local sz = require("sz")       
				local http = require("szocket.http")
				--                              http://47.92.125.255//import_data?phone=12233&password=1234&token=1234567&time=fads
				local res, code = http.request("http://47.92.125.255/import_data?phone="..wx.."&password="..password.."&token="..data.."&link="..api.."&time="..now)
				if code == 200 then
					tmp = json.decode(res)
					if tmp.code == 200 then
						mSleep(500)
						pressHomeKey(0)
						mSleep(100)
						pressHomeKey(1)
						mSleep(200)
						toast(tmp.message,1)
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

			_自定义提取62数据流程(password,ks_type,code_url)
			get_six_two = false
			if net_type == "1" then
				mSleep(500)
				setAirplaneMode(true)
				mSleep(500)
			end
		end
	end
	
	::over::
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(1000)
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
				["text"] = "微信版本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "7.0.2,7.0.7/7.0.8",
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
				["list"] = "WIFI,流量",
				["select"] = "0",  
				["countperline"] = "4",
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
				["list"] = "奥迪,卡农,USA-Api,东帝汶",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "卡农对接码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的卡农对接码",
				["text"] = "默认值",       
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
				["list"] = "蜻蜓,Sgolddak,gold,go下单,马力",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "go/马力下单定向省份",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的go/马力下单定向省份id",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "卡商项目ID",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的项目id",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置国家区号",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的国家区号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置号码长度",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入号码长度",
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
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, wc_version, net_type, ks_type, kn_id, fz_type, go_ProvinceId, ks_id, country_id, phone_len, password = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if ks_type == "1" then
		if kn_id == "" or kn_id == "默认值" then
			dialog("卡商id不能为空，请设置卡商id", 3)
			lua_restart()
		end
	end

	if ks_id == "" or ks_id == "默认值" then
		dialog("卡商id不能为空，请设置卡商id", 3)
		lua_restart()
	end

	if country_id == "" or country_id == "默认值" then
		dialog("国家区号不能为空，请设置国家区号", 3)
		lua_restart()
	end

	if phone_len == "" or phone_len == "默认值" then
		dialog("号码长度不能为空，请设置号码长度", 3)
		lua_restart()
	end

	if password == "" or password == "默认值" then
		dialog("密码不能为空，重新运行脚本设置密码", 3)
		lua_restart()
	end
	
	if ks_type == "0" then
		::get_token::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request("http://api5.caugu.com/yhapi.ashx?act=login&ApiName=sjq082217&PassWord=sjq666666")
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

	while true do
		if net_type == "1" then
			mSleep(500)
			setAirplaneMode(false)
			mSleep(500)
			setWifiEnable(false)
			self:Net()
		else
			mSleep(200)
			setAirplaneMode(false)
			mSleep(200)
			setWifiEnable(true)
			self:vpn()
		end
		self:clear_App()
		self:wchat(wc_version, net_type, ks_type, kn_id, fz_type, go_ProvinceId, phone_token, ks_id, country_id, phone_len, password)
		mSleep(1000)
	end
end

model:main()