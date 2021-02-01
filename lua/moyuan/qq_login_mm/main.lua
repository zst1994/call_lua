--陌陌-qq号码注册
require "TSLib"
local sz = require("sz") --登陆
local http = require("szocket.http")
local ts = require("ts")
local json = ts.json
local plist = ts.plist

local model = {}

model.awz_bid = "com.superdev.AMG"
model.mm_bid = "com.wemomo.momoappdemo1"

model.qqList = {}

model.qqAcount = ""
model.qqPassword = ""

model.mm_accountId = ""
model.subName = ""

model.city = ""
model.phone_type = "脚本自动选择"
model.sys_version = "脚本自动选择"

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

--检查AMG是否在前台
function model:Check_AMG()
	while true do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
		if x ~= -1 then
			toast("进入界面成功", 1)
			mSleep(500)
			break
		end

		if isFrontApp(self.awz_bid) == 0 then
			runApp(self.awz_bid)
			mSleep(3000)
		end
	end
end

--检查执行结果
function model:Check_AMG_Result()
	::get_amg_result::
	mSleep(3000) --根据所选应用数量和备份文件大小来增加等待时间，如果有开智能飞行模式，建议时间在15秒以上，当然，运行脚本时不建议开智能飞行，直接用脚本判断IP更准确
	local result_file = "/var/mobile/amgResult.txt"
	if isFileExist(result_file) then
		local amg_result = readFileString(result_file)
		if amg_result == "0" then
			return false
		elseif amg_result == "1" then
			return true
		elseif amg_result == "2" then
			toast("执行中", 1)
			goto get_amg_result
		end
	end
end

local AMG = {
	New = (function()
			--一键新机
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=newRecord")
			if code == 200 then
				return model:Check_AMG_Result()
			end
		end),
	Get_Name = (function()
			--获取当前记录名称
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=getCurrentRecordName")
			if code == 200 then
				if model:Check_AMG_Result() == true then
					return res
				end
			end
		end),
	Rename = (function(old_name, new_name) --重命名
			model:Check_AMG()
			local res, code =
			http.request("http://127.0.0.1:8080/cmd?fun=setRecordName&oldName=" .. old_name .. "&newName=" .. new_name)
			if code == 200 then
				return model:Check_AMG_Result()
			end
		end),
	Get_Param = (function() --获取当前记录参数并保存到指定文件夹
			model:Check_AMG()
			local param_file = userPath().."/lua/AMG_Param.plist"   --此处可自行修改保存路径和文件名
			if isFileExist(param_file) then delFile(param_file) end
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=getCurrentRecordParam&saveFilePath="..param_file);
			if code == 200 then
				if model:Check_AMG_Result() == true then
					return param_file
				end
			end 
		end),
	Set_Param = (function(param_file)  --设置当前记录参数
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=setCurrentRecordParam&filePath="..param_file);
			if code == 200 then
				return model:Check_AMG_Result()
			end 
		end),

}

--设置机型版本
--设置开关
function model:Set_AMG_Config(key,valus)
	local config_file = "/private/var/mobile/Library/Preferences/AMG/config.plist"
	local amg_config = plist.read(config_file)
	amg_config[key] = valus
	plist.write(config_file,amg_config)
	toast("修改参数成功",1)
	mSleep(500)
end

--设置当前设备机型
function model:Set_Device_Model(iphone_model)
	if iphone_model ~= nil then
		self:Set_AMG_Config("fakeDeviceModel","1")
	else
		self:Set_AMG_Config("fakeDeviceModel","0")
	end
	local param_file = AMG.Get_Param()    --先获取当前记录参数
	if param_file then
		local amg_param = plist.read(param_file)
		local param_name = "Model"
		local param_value = "nil"
		if iphone_model ~= nil then
			param_value = iphone_model
		end
		amg_param[param_name] = iphone_model
		plist.write(param_file,amg_param)   --写入参数
		if AMG.Set_Param(param_file) == true then
			toast("设置当前记录参数"..param_name.."值为"..param_value,3)
		end
	end
end

--设置当前系统版本
function model:Set_SyetemVer(ios_ver)
	if ios_ver ~= nil then
		self:Set_AMG_Config("fakeSystemVer","1")
	else
		self:Set_AMG_Config("fakeSystemVer","0")
	end
	local param_file = AMG.Get_Param()    --先获取当前记录参数
	if param_file then
		local amg_param = plist.read(param_file)
		local param_name = "SystemVer"
		local param_value = "nil"
		if ios_ver ~= nil then
			param_value = ios_ver
		end
		amg_param[param_name] = ios_ver
		plist.write(param_file,amg_param)   --写入参数
		if AMG.Set_Param(param_file) == true then
			toast("设置当前记录参数"..param_name.."值为"..param_value,3)
		end
	end
end

--[[随机内容(UTF-8中文字符占3个字符)]]
function model:Rnd_Word(strs, i, Length)
	local ret = ""
	local z
	if Length == nil then
		Length = 1
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) + State["随机常量"])
	math.random(string.len(strs) / Length)
	for i = 1, i do
		z = math.random(string.len(strs) / Length)
		ret = ret .. string.sub(strs, (z * Length) - (Length - 1), (z * Length))
	end
	return ret
end

--遍历文件
function model:getList(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		table.insert(f, l)
	end
	a:close()
	return f
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动", 1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 33, 503, 712, 892)
	mSleep(500)
	ts.img.binaryzationImg(userPath() .. "/res/test_3.jpg", mns)
	mSleep(500)
	if self:file_exists(userPath() .. "/res/tmp.jpg") then
		toast("正在计算", 1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath() .. "/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333)
		mSleep(math.random(500, 1000))
		if type(point) == "table" and #point ~= 0 then
			mSleep(500)
			x_len = point[1].x
			toast(x_len, 1)
			return x_len
		else
			x_len = 0
			return x_len
		end
	else
		dialog("文件不存在", 1)
		mSleep(math.random(1000, 1500))
	end
end

function model:renameRecord(updateResultName)
	::runAgain1::
	runApp(self.awz_bid)
	mSleep(3 * 1000)
	while true do
		mSleep(500)
		if getColor(596, 443) == 0x6f7179 then
			local sz = require("sz")
			local http = require("szocket.http")
			local res, code = http.request(self.renameRecordUrl .. updateResultName)
			if code == 200 then
				local resJson = sz.json.decode(res)
				local result = resJson.result
				if result == 1 then
					toast("修改成功", 1)
					mSleep(1000)
				end
			end
			break
		end

		flag = isFrontApp(self.awz_bid)
		if flag == 0 then
			closeApp(self.awz_bid)
			mSleep(3000)
			goto runAgain1
		end
	end
end

function model:timeOutRestart(t1)
	t2 = ts.ms()

	if os.difftime(t2, t1) > 120 then
		lua_restart()
	else
		toast("距离重启脚本还有"..(120 - os.difftime(t2, t1)) .. "秒",1)
	end
end

function model:getIpAddress()
	::address::
	status_resp, header_resp,body_resp = ts.httpGet("http://ip-api.com/json/")
	if status_resp == 200 then--打开网站成功
		tmp = json.decode(body_resp)
		if tmp.status == "success" then
			return tmp
		end
	else
		toast("请求ip位置失败："..tostring(body_resp),1)
		mSleep(1000)
		goto address
	end
end

function model:newMMApp(sysVersion, sysPhoneType, gpsAddress, editorWay)
    if editorWay == "0" then
		toast("暂不修改",1)
		mSleep(500)
	elseif editorWay == "1" then
    	if #sysVersion > 0 or #sysPhoneType > 0 then
    		verList = {"13.0","13.1","13.1.1","13.1.2","13.1.3","13.2","13.2.2","13.2.3","13.3","13.3.1","13.4","13.4.1","13.5","13.5.1","13.6","13.6.1","13.7","14.0","14.0.1","14.1","14.2","14.3"}
    		modelList = {"iPhone 7","iPhonse 7 Plus","iPhone 8","iPhone 8 Plus","iPhone X","iPhone Xr","iPhone Xs","iPhone Xs Max","iPhone 11","iPhone 11 Pro","iPhone 11 Pro Max"}
    
    		check_verList = strSplit(sysVersion,"@")
    		check_modelList = strSplit(sysPhoneType,"@")
    
    		ios_ver = check_verList[math.random(1, #check_verList)]
    		iphone_model = check_modelList[math.random(1, #check_modelList)]
    
    		self.phone_type = modelList[tonumber(iphone_model) + 1]
    		self.sys_version = verList[tonumber(ios_ver) + 1]
    
    		self:Set_Device_Model(self.phone_type)
    		self:Set_SyetemVer(self.sys_version)
    	end
    else
        while true do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x,y + 180)
				mSleep(500)
				toast("设置", 1)
				mSleep(500)
			end

			mSleep(200)
			if getColor(347,87) == 0x000000 and getColor(404,97) == 0x000000 then
				mSleep(500)
				toast("进入设置",1)
				mSleep(500)
				break
			end

			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end
        
        --设置当前设备机型
		if editorWay == "2" or editorWay == "4" then
			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0x000000, "5|6|0x000000,22|4|0x000000,38|4|0x000000,54|6|0x000000,59|-11|0x000000,70|-2|0x000000,74|4|0x000000,88|2|0x000000,118|10|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(500)
					tap(x + 200,y)
					mSleep(500)
					toast("进入选择机型",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(1500)
				end
			end
			
			idx = (math.random(1, 7) - 1) * 90
			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy( 0x000000, "-7|-10|0x000000,7|-10|0x000000,7|11|0x000000,-7|11|0x000000,-29|3|0x000000,-53|2|0x000000,-92|6|0x000000,-113|4|0x000000,-121|2|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(500)
					tap(x,y + idx)
					mSleep(500)
					toast("选择机型",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(1500)
				end
			end

			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0x000000, "5|6|0x000000,22|4|0x000000,38|4|0x000000,54|6|0x000000,59|-11|0x000000,70|-2|0x000000,74|4|0x000000,88|2|0x000000,118|10|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(500)
					toast("进入下一步",1)
					mSleep(500)
					break
				else
					mSleep(500)
					tap(55,85)
					mSleep(500)
				end
			end
			
-- 			local param_file = AMG.Get_Param()
-- 			if param_file then
-- 				local amg_param = plist.read(param_file)
-- 				local param_name = "Model"
-- 				self.phone_type = amg_param[param_name]
-- 			end
		end
        
        --设置当前系统版本
		if editorWay == "3" or editorWay == "4" then
			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy( 0x000000, "4|5|0x000000,21|5|0x000000,38|5|0x000000,53|5|0x000000,53|-11|0x000000,83|9|0x000000,124|-8|0x000000,145|-7|0x000000,230|7|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(500)
					tap(x + 200,y)
					mSleep(500)
					toast("进入选择系统版本",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(1500)
				end
			end

-- 			idx = math.random(1, 3)
			yy = math.random(171, 1214)
			
			for var=1,4 do
			    mSleep(500)
				moveTowards(404,1194,90,900,50)
				mSleep(500)
			end
			
			mSleep(500)
			tap(300,yy)
			mSleep(500)
			toast("选择系统版本",1)
			mSleep(500)
			
-- 			while true do
-- 				mSleep(500)
-- 				x,y = findMultiColorInRegionFuzzy( 0x000000, "6|-4|0x000000,7|18|0x000000,28|18|0x000000,16|18|0x000000,16|0|0x000000,27|0|0x000000,35|16|0x000000,42|7|0x000000,56|7|0x000000", 90, 0, 0, 749, 1333)
-- 				if x ~= -1 then
-- 					for var= 1, idx do
-- 						mSleep(500)
-- 						moveTowards(404,1194,90,400,10)
-- 						mSleep(1500)
-- 					end
-- 					mSleep(500)
-- 					tap(x,yy)
-- 					mSleep(500)
-- 					toast("选择系统版本",1)
-- 					mSleep(500)
-- 					break
-- 				else
-- 					mSleep(500)
-- 					moveTowards(404,1194,90,900,10)
-- 					mSleep(1500)
-- 				end
-- 			end
			
-- 			local param_file = AMG.Get_Param()
-- 			if param_file then
-- 				local amg_param = plist.read(param_file)
-- 				local param_name = "SystemVer"
-- 				self.sys_version = amg_param[param_name]
-- 			end
		end

		while true do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				break
			else
				mSleep(500)
				tap(55,85)
				mSleep(500)
			end

			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end
    end

	while true do
		mSleep(500)
		--一键新机
		if AMG.New() == true then
			while true do
				if getColor(266, 601) == 0xffffff then
					toast("newApp成功", 1)
					break
				end

				self:vpn_connection()
			end
			break
		end
	end
	
	if gpsAddress == "0" then
		add = self:getIpAddress()
		lat = add.lat
		lon = add.lon
		toast(lat.."\r\n"..lon,1)
		mSleep(500)

		local param_file = AMG.Get_Param()    --先获取当前记录参数
		if param_file then
			--toast("获取成功，参数文件路径："..param_file, 3)
			local amg_param = plist.read(param_file)
			amg_param["Longitude"] = lon
			amg_param["Latitude"] = lat
			plist.write(param_file,amg_param)   --写入参数
			if AMG.Set_Param(param_file) == true then
				toast("设置当前记录GPS位置为".."经度："..lon.."纬度："..lat,3)
			end
		end
	elseif gpsAddress == "2" then
		while true do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x,y + 180)
				mSleep(500)
				toast("设置", 1)
				mSleep(500)
			end

			mSleep(200)
			if getColor(347,87) == 0x000000 and getColor(404,97) == 0x000000 then
				mSleep(500)
				toast("进入设置",1)
				mSleep(500)
				break
			end

			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end

		while true do
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy(0x000000, "4|-7|0x000000,4|12|0x000000,13|-3|0x000000,20|-5|0x000000,28|2|0x000000,21|10|0x000000,47|-1|0x000000,54|0|0x000000,61|-1|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x,y)
				mSleep(500)
				break
			else
				mSleep(500)
				moveTowards(404,1194,90,900,10)
				mSleep(1500)
			end
		end

		while (true) do
			mSleep(200)
			if getColor(379,181) == 0xeaebed and getColor(655,85) ==0x007aff then
				mSleep(500)
				tap(379,181)
				mSleep(500)
				inputStr(self.city)
				mSleep(1000)
				key = "ReturnOrEnter"
				keyDown(key)
				keyUp(key)
				mSleep(2000)
				tap(math.random(178, 599), math.random(618, 1076))
				mSleep(4000)
				tap(682,86)
				mSleep(1000)
				break
			end
		end

		while true do
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				toast("准备下一步",1)
				mSleep(500)
				break
			else
				mSleep(500)
				tap(45,81)
				mSleep(1000)
			end
		end
	end
end

function model:vpn_connection()
	--vpn连接
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy(0x1382ff, "-4|4|0x1382ff,5|10|0x1382ff,2|19|0x1382ff,12|-1|0x1382ff,17|8|0x1382ff,10|13|0x1382ff,24|13|0x1382ff,13|26|0x1382ff,17|19|0x1382ff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		mSleep(500)
		randomTap(x,y,4)
		mSleep(500)
		setVPNEnable(true)
		toast("好",1)
		mSleep(3000)
	end
end

function model:getIP()
	::ip_addresss::
	status_resp, header_resp,body_resp = ts.httpGet("http://myip.ipip.net")
	toast(body_resp,1)
	if status_resp == 200 then--打开网站成功
		local i,j = string.find(body_resp, "%d+%.%d+%.%d+%.%d+")
		if type(i) ~= "nil" and i > 0 then
			local ipaddr = string.sub(body_resp,i,j)
			address = strSplit(body_resp,"来自于：")[2]
			self.city = string.gsub(strSplit(address," ")[3],"%s+","") 
			return ipaddr
		else
			toast("请求ip位置失败："..tostring(body_resp),1)
			mSleep(1000)
			goto ip_addresss
		end
	else
		toast("请求ip位置失败："..tostring(body_resp),1)
		mSleep(1000)
		goto ip_addresss
	end
end

--[[检查网络方法]]
function model:Net()
	--ping 3次测试网络连接情况
	status = ts.ping("www.baidu.com",3)
	if status then
		local n = 0
		for i=1,#status do
			n = n + status[i]
		end
		if n > 800 then
			toast("当前网络延迟："..n,1)
			mSleep(500)
			return false
		else
			toast("网络良好",1)
			mSleep(500)
			return true
		end
	else
		toast("ping网络失败",1)
		mSleep(500)
		return false
	end
end

function model:vpn(openPingNet)
	::get_vpn::
	old_data = self:getIP() --获取IP
	if old_data and old_data ~= "" then
		toast(old_data, 1)
	else
		goto get_vpn
	end

	mSleep(math.random(500, 1500))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态", 1)
		setVPNEnable(false)
		setVPNEnable(false)
		mSleep(3000)
		goto get_vpn
	else
		toast("关闭状态", 1)
	end

	t1 = ts.ms()
	setVPNEnable(true)
	mSleep(1000 * math.random(2, 4))

	while true do
		mSleep(1000)
		new_data = self:getIP() --获取IP
		if new_data and new_data ~= "" then
			toast(new_data, 1)
			if new_data ~= old_data then
				mSleep(1000)
				toast("vpn链接成功,检测网络状态")
				mSleep(1000)
				break
			end
		end

		t2 = ts.ms()

		if os.difftime(t2, t1) > 10 then
			setVPNEnable(false)
			setVPNEnable(false)
			setVPNEnable(false)
			mSleep(2000)
			toast("ip地址一样，重新打开", 1)
			mSleep(2000)
			goto get_vpn
		end
	end

	if openPingNet == "0" then
		if not self:Net() then
			goto get_vpn
		end
	end
end

function model:getMMId(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		b = string.find(l, "u.(%d%d%d%d%d%d%d%d%d)_main.sqlite")
		if type(b) ~= "nil" then
			c = string.match(l, "%d%d%d%d%d%d%d%d%d")
			toast("陌陌id:" .. c, 1)
			mSleep(1000)
			return c
		end
	end
end

function model:downImage()
	--	list = self:getList(userPath().."/res/*.png")
	list = self:getList(userPath() .. "/res/picFile")

	if #list > 0 then
		return list[math.random(1, #list)]
	else
		dialog("文件夹路径没有照片了", 0)
		lua_exit()
	end
end

function model:deleteImage(path)
	::delete::
	bool = delFile(path)
	if bool then
		toast("删除成功", 1)
	else
		toast("删除失败", 1)
		mSleep(1000)
		goto delete
	end
end

function model:getAccount()
	self.qqList = readFile(userPath() .. "/res/qq.txt")
	if self.qqList then
		if #self.qqList > 0 then
			data = strSplit(string.gsub(self.qqList[1], "%s+", ""), "----")
			self.qqAcount = data[1]
			self.qqPassword = data[2]
			toast("获取账号成功",1)
			mSleep(1000)
		else
			dialog("没账号了", 0)
			lua_exit()
		end
	else
		dialog("文件不存在,请检查", 0)
		lua_exit()
	end
end

function model:mm(password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, changePass)
	Nickname = "已经注册过的账号无昵称"
	
	runApp(self.mm_bid)
	mSleep(1000)
	t1 = ts.ms()

	runAgain = false
	while true do
		--同意
		mSleep(200)
		if getColor(298, 941) == 0x3bb3fa and getColor(520, 941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376, 944, 4)
			mSleep(500)
		end

		--允许
		mSleep(200)
		if getColor(533, 770) == 0x7aff and getColor(495, 771) == 0x7aff then
			mSleep(500)
			randomTap(495, 771, 4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
		if x ~= -1 and y ~= -1 then
			if runAgain then
				mSleep(math.random(500, 700))
				randomTap(x - 160, y, 4)
				mSleep(math.random(500, 700))
				toast("手机号登录注册", 1)
				mSleep(1000)
				closeApp(self.mm_bid)
				mSleep(2000)
				break
			else
				mSleep(1000)
				closeApp(self.mm_bid)
				mSleep(2000)
				runAgain = true
			end
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录1",1)
			mSleep(500)
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录2",1)
			mSleep(500)
		end

		--qq图标
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(1000)
			closeApp(self.mm_bid)
			mSleep(2000)
			break
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	t1 = ts.ms()
	while true do
		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录1",1)
			mSleep(500)
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录2",1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
		end

		--同意
		mSleep(200)
		if getColor(298, 941) == 0x3bb3fa and getColor(520, 941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376, 944, 4)
			mSleep(500)
		end

		--允许
		mSleep(200)
		if getColor(533, 770) == 0x7aff and getColor(495, 771) == 0x7aff then
			mSleep(500)
			randomTap(495, 771, 4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x - 160, y, 4)
			mSleep(math.random(500, 700))
		end

		--qq图标
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y, 4)
			mSleep(math.random(3500, 5000))
			break
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	huakuai = false
	inputAgain = false
	::hk::

	t1 = ts.ms()
	while (true) do
		mSleep(200)
		if getColor(239, 629) == 0x12b7f5 then
			if inputAgain then
				mSleep(500)
				randomTap(620,  357, 3)
				mSleep(1000)
				for var=1,20 do
					mSleep(100)
					keyDown("DeleteOrBackspace")
					keyUp("DeleteOrBackspace")  
				end
				mSleep(500)
				randomTap(620,  469, 3)
				mSleep(1000)
				for var=1,20 do
					mSleep(100)
					keyDown("DeleteOrBackspace")
					keyUp("DeleteOrBackspace")  
				end
			end

			mSleep(5000)
			while (true) do
				mSleep(200)
				if getColor(676,  357) == 0xbbbbbb or getColor(599,354) == 0xffffff then
					mSleep(500)
					randomTap(447, 477, 4)
					mSleep(500)
					break
				else
					mSleep(500)
					randomTap(395, 357, 4)
					mSleep(2000)
					inputStr(self.qqAcount)
					mSleep(1000)
				end
			end

			while (true) do
				mSleep(200)
				if getColor(677,  469) == 0xbbbbbb or getColor(163,471) == 0x000000 then
					mSleep(500)
					randomTap(239, 629, 4)
					mSleep(500)
					break
				else
					mSleep(500)
					randomTap(447, 477, 4)
					mSleep(500)
					inputStr(self.qqPassword)
					mSleep(1000)
				end
			end
		end

		mSleep(200)
		if getColor(391,541) == 0x12b7f5 and getColor(379,884) == 0x000000 then
			mSleep(500)
			randomTap(379,884,4)
			mSleep(500)
			table.remove(self.qqList, 1)
			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
			self:getAccount()
			inputAgain = true
		end

		mSleep(200)
		if getColor(116, 949) == 0x007aff then
			if huakuai then
				x_lens = self:moves()
				if tonumber(x_lens) > 0 then
					mSleep(math.random(500, 700))
					moveTowards(116, 949, 10, x_len - 65)
					mSleep(1000)
					randomTap(370, 1024, 4)
					mSleep(2000)
					break
				else
					mSleep(math.random(500, 1000))
					randomTap(603, 1032, 10)
					mSleep(math.random(3000, 6000))
				end
			else
				mSleep(math.random(500, 1000))
				randomTap(603, 1032, 10)
				mSleep(math.random(3000, 6000))
				huakuai = true
				goto hk
			end
		end

		mSleep(200)
		if getColor(296,  615) == 0x12b7f5 and getColor(682,  259) == 0x818181 then
			mSleep(500)
			toast("暂时无法登陆", 1)
			mSleep(500)
			self.subName = "暂时无法登陆"
			goto get_mmId
		end

		--填写资料
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			toast("不需要过滑块", 1)
			mSleep(500)
			break
		end

		--已经注册过，需要绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			toast("已经注册过，需要绑定手机号码", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		mSleep(200)
		if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) == 0x808080 or getColor(676,258) == 0x818181 then
			if getColor(655,211) == 0xffffff then
				toast("切换下一个账号", 1)
				mSleep(500)
				table.remove(self.qqList, 1)
				writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
				self:getAccount()
				inputAgain = true
				goto hk
			elseif getColor(683,209) == 0xffffff then
				toast("切换下一个账号,重新新机", 1)
				mSleep(500)
				table.remove(self.qqList, 1)
				writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
				goto over
			end
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	if nikcNameType == "0" then
		State = {
			["随机常量"] = 0,
			["姓氏"] = "赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
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
			["名字"] = "安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
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
			"临勤墨薄颉棠羡浚兆环铄芷烟示奇玮沈曼冬种元英枝承安可晋黎昕赖冰双朱以松夙湛雨掌从凝东方静" ..
			"槐俞水风税靖之中义詹清秋睦乐音向昌燎辛鹤梦敖韶斐司阴雅宁褚理群顿若菱容诗双晁弘壮满阳旭委" ..
			"雨彤聂书慧矫璇珠伟正雅巫丽佳务元仰腾逸殳语殷逸秀曲运吾玉后女纪初晴夷易蓉潭紫夏耿雨文弭俨" ..
			"雅尔晨星韩蕙兰偶宣朗倪光明赵歌吹栾建白边虹雨清萱拱叶嘉督思溪星郁睿德泣彤雯龚傲松钱若芳冒" ..
			"静柏笪半青野悦媛宇清俊康宜春费绿兰荣香菱祢琲瓃恭芃虞丽华弥国安说雁露杨初夏连锐终冰岚焉恨" ..
			"瑶律元容喻雨石之和志房正文亥华辉宓孤风夫霞辉洪寻云招令雪乔梦山揭雪戏致欣裘怀薇玉驰轩公古" ..
			"韵府叶舞雪卉甫佳晨谯莹白邛慧捷晏良不采梦慎依云翠玉瑾苑醉冬郁梓敏郑梦晨单于晨潍仝半安繁高" ..
			"扬裔绿阙雅充秋白念怡布作人呼延芸茗丰古荆乃班和宜堂同方英涤夔瑜敏封陶宁欧阳会郗承天酆乐珍" ..
			"尹秋灵元高韵綦雅志池珺琪次博扬游贾静涵营鹏翼公叔晴照贺囡烟凯旋赫连慨能幼仪员鹏涛首谷蓝宝" ..
			"秋春老梦寒贯令梓蒋曼衍干凝芙乘鸿波邰丰羽御震轩巧锦树诗槐脱康宁邝霁芸柯若蕊冼桂陆德寿巩昆" ..
			"卉蓬建华诗寄灵百里思官风绪宏峻问紫云字阳平历凝竹邗清润疏晓灵锺芳蕤薛杨柳壬梓菱芮雅可卫德" ..
			"华暴舒方敬梦岚呼华池厚拔长俊郎钦冰凡励虹玉盍学真茹春华邸晴岚简英哲广飞珍台凝云修新柔第雨" ..
			"安宣旋功香梅穰承志僧清宋翠丝恽依风类婀北代灵才嘉赐介元德箕子濯系鸿才盖芷天汤可昕西门翠桃" ..
			"谌雨文郦宏达风依云纵幼旋庹卿月僪忆敏益鸿朗良兴修浮晴岚告春蕾尤清悦云曾琪谢正信敏丽华昆锐" ..
			"况梓颖鲍锦曦银小萍出叶飞登睿思那若表宛库醉柳抄歌阑宁思洁敛代秋碧鲁沛容撒映真藏白容愚耀华" ..
			"莘寒梦占白云汲虹颖计音悦董依云寒思涵拓跋山蝶桓皓佛思彤溥言武韶阳鲁昂驹醉香何玲然诸秀艳闽" ..
			"昆纬宇文夏岚邢觅丹佘敏叡祈紫萱森海亦仙晴霞平梓琬桑湘君剑恺铁星华波书文阎晓凡春钧坚芮丽冉" ..
			"英楠谷之费莫高峻零夏山闭鸿畅浦童尚庆生宾奥经风褒夜雪幸虹英将高懿马河灵庆千凝邶量蔡慧秀清" ..
			"逸百安然怀瑰玮席婵娟闳宾白在慕梅胡令璟孝安梦答冷萱皮雅彤通长文忻文翰相秀兰绳阳兰上官寻菡" ..
			"车隽巧公孙瑛衅夜春皎邵语海时盼晴寸歌云隆骞仕乐景龙戴成双淳于蕴强安顺栗开霁福平良青乐人穆" ..
			"雨筠勇宇郭笑容迟海熊喜儿丙新之理冷之陈欣悦陶正祥南宫洋洋位灵韵本雯君洛健柏化懿亓益称宜刚" ..
			"清莹兰鸿光屠辰宇卯运鸿刑叶帆哈语林军绣梓姿实江雪行新蕾娄飞昂施芬芬茅慧艳粘沛凝释开宇仇来" ..
			"娇洁牢韵诗歧沉道桂月户萌战婉娜巧仉俊达原琇芳白燕楠汗佳思针夜蓉惠以彤闻清漪谭雁桃史麦冬蒲" ..
			"听云凤高兴钊蔓危琇莹初冰海罕舒畅仪诗蕾第五奥维飞元甲段昊苍乐毛雪绿那拉雪曼任茹薇汪鸿光素" ..
			"醉易乌娅思受语柳乜宜仲颖斯邱珞武楚吴越婕板童颛桐芒柯侨闳帆六菲琪贯遥越千繁濛渠洛欧欣称曼" ..
			"松羽文雅兰琦通瑜泉毓彭平须诗过区畅杭雨向晴濮一旷谣汗彤笃皋瑜析佳拓跋珂春舒山婷中晶邵月刀" ..
			"晓伊姗宿璩睿佼鸽盘佳依莹衣昕吕韵老淇荀绮聊钰凭錦资弋郁婷叶彤荆之桥曦雪熙房北楠养可古倩秦" ..
			"雪多琪索格邛丹合涵稽奕祁冉嬴怡俟雨柔晴太叔子汝妤沈芸茅晗马佳琳容雪始丹费倩浑晶纪雨公孙熙" ..
			"夫妤丘一员瑜用昕郸濛委帆公冶莹业函尔錦奈平毓楠保奕势曦银宜乌雅曼壤驷佳孛钰尚想贝晓凤可养" ..
			"子示悦性琳狂姗刁睿仪冉石涵偶楚斛瑜赫连之出舒德琪蓝嘉黄毓朴涵骑千庾童邶诗俟鸽褚遥铁洛尧颖" ..
			"巫马淇郗珂宰羽邴琪书晴訾婷宛芸函婕夹谷畅本格求柯五韵丙晗硕越沃婷汝欣厍佳卞绮谷雨牛谣景琦" ..
			"从怡圭雅松菲刘菡闭珞碧涵言弋侍彤路彤丁桐靖晴屈月植濛芮晴同珞德昕高晴宋帆公叔瑜贝越贲彤石" ..
			"诗崔想夷宣函闪佳翦宜纪洛甘雪盍琪愚钰貊绮衅谣希睿士遥候桐受千毛菡敬妤骆格善一和舒居晓丰曦" ..
			"仉之象雅度晗英菲愈子邰月苍奕斛欣鲍婷饶婕郑淇朱楠韶毓沐婷笪平蒙熙隆畅赫涵项童祖怡豆楚慈颖" ..
			"訾琳穆雨捷冉乌雅彤苏丹梁丘莹庹琪旅弋莘姗年韵缑晶零羽逮瑜镜鸽东可大嘉杭佳鄞雨幸錦昝琦阿涵" ..
			"行悦应芸泰曼倪倩卞柯赫连珂生姗碧婕力涵郁琪徐涵鹿菲少涵箕欣弥舒夷莹梅遥柔晗归曼乙童牧雨双" ..
			"錦田珞赤丹桑楠荤嘉习晶答熙仪瑜终琳度婷常谣澄之关奕诗洛公冶倩诸葛颖经曦范晓闫毓曲绮颛孙睿" ..
			"毛楚姚瑜其彤溥昕律佳卯诗种悦苍芸衡平安雨麴函广羽操月闾冉莱妤硕淇韶怡苑子谢濛步钰中韵伯婷" ..
			"祁千集帆蒋菡芒琦西门琪亓越马彤衅雪锁弋农晴蓬雅廉想东门宜史可藤桐皋鸽圭珂鲍晴宏一卢格寸柯" ..
			"咸畅郎佳茆雨墨涵绳桐栋雨矫钰素函赤可尉晗伟宜类珂止淇解嘉宛舒欧阳千称韵聂珞刘晴巧濛曹琪板" ..
			"一局曼系彤力鸽阎晓书平綦婷隽姗终柯苌菡安格功之丘琳松昕涂晴宝倩贺琦尾绮怀婕慕容羽冀弋革畅" ..
			"鄂晶公婷长孙遥勇佳函菲束丹广毓董子仉怡钞诗第欣居楠孟谣闭佳谯想顾涵开妤崇錦高雪徭颖前涵梁" ..
			"丘帆师瑜庆睿充彤满熙姓莹费奕莱雅戏曦宗政月牵越卯洛肥瑜希楚糜悦信冉乌孙琪剑童孙芸衷妤谢莹" ..
			"农悦始子屠涵乐可郑帆同曦苏晓郜想抄雨奚彤乜菲泷琳厉婷闻佳北一竭雨贲瑜九诗泉雪蒿千夷琦能洛" ..
			"仝冉过楠黄姗机柯万俟琪栋越路丹考函鲜于畅敬晴弭奕示谣訾錦莱菡歧怡贸昕柴熙朱楚张简涵谷平藤" ..
			"晶褒宜茆晴龙晗问韵浦彤方月汉珞荆曼蔺涵锁珂阙羽桥桐弘婕寒绮亓官雅巴芸睢琪睦嘉戚濛燕婷夙舒" ..
			"卞睿智遥宾淇欧毓笪颖吕钰库佳合弋羽鸽宏格咸之靳瑜恭倩希童御欣抄绮牟芸桓"
		}
		State["随机常量"] = tonumber(self:Rnd_Word("0123456789", 5))

		Nickname = self:Rnd_Word(State["姓氏"], 1, 3) .. self:Rnd_Word(State["名字"], 1, 3)
	elseif nikcNameType == "1" then
		State = {
			["随机常量"] = 0,
			["姓氏"] = "赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
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
			["名字"] = {"梦琪","忆柳","之桃","慕青","问兰","尔岚","元香","bai初夏","沛菡","傲珊","曼文","乐菱","痴珊","恨玉","惜文","香寒","新柔","语蓉","海安","夜蓉","涵柏","水桃","醉蓝","春儿","语琴","从彤","傲晴","语兰","又菱","碧彤","元霜","怜梦","紫寒","妙彤","曼易","南莲","紫翠","雨寒","易烟","如萱","若南","寻真","晓亦","向珊","慕灵","以蕊","寻雁","映易","雪柳","孤岚","笑霜","海云","凝天","沛珊","寒云","冰旋","宛儿","绿真","盼儿","晓霜","碧凡","夏菡","曼香","若烟","半梦","雅绿","冰蓝","灵槐","平安","书翠","翠风","香巧","代云","梦曼","幼翠","友巧","听寒","梦柏","醉易","访旋","亦玉","凌萱","访卉","怀亦","笑蓝","春翠","靖柏","夜蕾","冰夏","梦松","书雪","乐枫","念薇","靖雁","寻春","恨山","从寒","忆香","觅波","静曼","凡旋","以亦","念露","芷蕾","千兰","新波","代真","新蕾","雁玉","冷卉","紫山","千琴","恨天","傲芙","盼山","怀蝶","冰兰","山柏","翠萱","恨松","问旋","从南","白易","问筠","如霜","半芹","丹珍","冰彤","亦寒","寒雁","怜云","寻文","乐丹","翠柔","谷山","之瑶","冰露","尔珍","谷雪","乐萱","涵菡","海莲","傲蕾","青槐","冬儿","易梦","惜雪","宛海","之柔","夏青","亦瑶","妙菡","春竹","痴梦","紫蓝","晓巧","幻柏","元风","冰枫","访蕊","南春","芷蕊","凡蕾","凡柔","安蕾","天荷","含玉","书兰","雅琴","书瑶","春雁","从安","夏槐","念芹","怀萍","代曼","幻珊","谷丝","秋翠","白晴","海露","代荷","含玉","书蕾","听白","访琴","灵雁","秋春","雪青","乐瑶","含烟","涵双","平蝶","雅蕊","傲之","灵薇","绿春","含蕾","从梦","从蓉","初丹。听兰","听蓉","语芙","夏彤","凌瑶","忆翠","幻灵","怜菡","紫南","依珊","妙竹","访烟","怜蕾","映寒","友绿","冰萍","惜霜","凌香","芷蕾","雁卉","迎梦","元柏","代萱","紫真","千青","凌寒","紫安","寒安","怀蕊","秋荷","涵雁","以山","凡梅","盼曼","翠彤","谷冬","新巧","冷安","千萍","冰烟","雅阳","友绿","南松","诗云","飞风","寄灵","书芹","幼蓉","以蓝","笑寒","忆寒","秋烟","芷巧","水香","映之","醉波","幻莲","夜山","芷卉","向彤","小玉","幼南","凡梦","尔曼","念波","迎松","青寒","笑天","涵蕾","碧菡","映秋","盼烟","忆山","以寒","寒香","小凡","代亦","梦露","映波","友蕊","寄凡","怜蕾","雁枫","水绿","曼荷","笑珊","寒珊","谷南","慕儿","夏岚","友儿","小萱","紫青","妙菱","冬寒","曼柔","语蝶","青筠","夜安","觅海","问安","晓槐","雅山","访云","翠容","寒凡","晓绿","以菱","冬云","含玉","访枫","含卉","夜白","冷安","灵竹","醉薇","元珊","幻波","盼夏","元瑶","迎曼","水云","访琴","谷波","乐之","笑白","之山","妙海","紫霜","平夏","凌旋","孤丝","怜寒","向萍","凡松","青丝","翠安","如天","凌雪","绮菱","代云","南莲","寻南","春文","香薇","冬灵","凌珍","采绿","天春","沛文","紫槐","幻柏","采文","春梅","雪旋","盼海","映梦","安雁","映容","凝阳","访风","天亦","平绿","盼香","觅风","小霜","雪萍","半雪","山柳","谷雪","靖易","白薇","梦菡","飞绿","如波","又晴","友易","香菱","冬亦","问雁","妙春","海冬","半安","平春","幼柏","秋灵","凝芙","念烟","白山","从灵","尔芙","迎蓉","念寒","翠绿","翠芙","靖儿","妙柏","千凝","小珍","天巧。妙旋","雪枫","夏菡","元绿","痴灵","绮琴","雨双","听枫","觅荷","凡之","晓凡","雅彤","香薇","孤风","从安","绮彤","之玉","雨珍","幻丝","代梅","香波","青亦","元菱","海瑶","飞槐","听露","梦岚","幻竹","新冬","盼翠","谷云","忆霜","水瑶","慕晴","秋双","雨真","觅珍","丹雪","从阳","元枫","痴香","思天","如松","妙晴","谷秋","妙松","晓夏","香柏","巧绿","宛筠","碧琴","盼兰","小夏","安容","青曼","千儿","香春","寻双","涵瑶","冷梅","秋柔","思菱","醉波","醉柳","以寒","迎夏","向雪","香莲","以丹","依凝","如柏","雁菱","凝竹","宛白","初柔","南蕾","书萱","梦槐","香芹","南琴","绿海","沛儿","晓瑶","听春","凝蝶","紫雪","念双","念真","曼寒","凡霜","飞雪","雪兰","雅霜","从蓉","冷雪","靖巧","翠丝","觅翠","凡白","乐蓉","迎波","丹烟","梦旋","书双","念桃","夜天","海桃","青香","恨风","安筠","觅柔","初南","秋蝶","千易","安露","诗蕊","山雁","友菱","香露","晓兰","白卉","语山","冷珍","秋翠","夏柳","如之","忆南","书易","翠桃","寄瑶","如曼","问柳","香梅","幻桃","又菡","春绿","醉蝶","亦绿","诗珊","听芹","新之","易巧","念云","晓灵","静枫","夏蓉","如南","幼丝","秋白","冰安","秋白","南风","醉山","初彤","凝海","紫文","凌晴","香卉","雅琴","傲安","傲之","初蝶","寻桃","代芹","诗霜","春柏","绿夏","碧灵","诗柳","夏柳","采白","慕梅","乐安","冬菱","紫安","宛凝","雨雪","易真","安荷","静竹","代柔","丹秋","绮梅","依白","凝荷","幼珊","忆彤","凌青","之桃","芷荷","听荷","代玉","念珍","梦菲","夜春","千秋","白秋","谷菱","飞松","初瑶","惜灵","恨瑶","梦易","新瑶","曼梅","碧曼","友瑶","雨兰","夜柳","香蝶","盼巧","芷珍","香卉","含芙","夜云","依萱","凝雁","以莲","易容","元柳","安南","幼晴","尔琴","飞阳","白凡","沛萍","雪瑶","向卉","采文","乐珍","寒荷","觅双","白桃","安卉","迎曼","盼雁","乐松","涵山","恨寒","问枫","以柳","含海","秋春","翠曼","忆梅","涵柳","梦香","海蓝","晓曼","代珊","春冬","恨荷","忆丹","静芙","绮兰","梦安","紫丝","千雁","凝珍","香萱","梦容","冷雁","飞柏","天真","翠琴","寄真","秋荷","代珊","初雪","雅柏","怜容","如风","南露","紫易","冰凡","海雪","语蓉","碧玉","翠岚","语风","盼丹","痴旋","凝梦","从雪","白枫","傲云","白梅","念露","慕凝","雅柔","盼柳","半青","从霜","怀柔","怜晴","夜蓉","代双","以南","若菱","芷文","寄春","南晴","恨之","梦寒","初翠","灵波","巧春","问夏","凌春","惜海"}
		}
		State["随机常量"] = tonumber(self:Rnd_Word("0123456789", 5))

		Nickname = self:Rnd_Word(State["姓氏"], 1, 3) .. State["名字"][math.random(1, #State["名字"])]
	end

	t1 = ts.ms()
	while true do
		mSleep(200)
		if getColor(116, 949) == 0x007aff then
			mSleep(math.random(500, 1000))
			randomTap(603, 1032, 10)
			mSleep(math.random(3000, 6000))
			toast("重新滑块",1)
			mSleep(500)
			goto hk
		end

		mSleep(200)
		if getColor(391,541) == 0x12b7f5 and getColor(379,884) == 0x000000 then
			mSleep(500)
			randomTap(379,884,4)
			mSleep(500)
			table.remove(self.qqList, 1)
			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
			self:getAccount()
			inputAgain = true
			goto hk
		end

		mSleep(200)
		if getColor(149,  187) == 0x323233 or getColor(149,187) == 0x323333 or getColor(149,  187) == 0x313232 then
			mSleep(500)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			toast("收起键盘",1)
			mSleep(500)
		end

		--填写资料
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(1000)
			tap(x + 300, y + 121)
			mSleep(1500)
			for var = 1, 20 do
				mSleep(200)
				keyDown("DeleteOrBackspace")
				mSleep(100)
				keyUp("DeleteOrBackspace")
				mSleep(100)
			end
			mSleep(500)
			inputStr(Nickname)
			mSleep(1000)
			toast("输入昵称", 1)
			mSleep(500)
			break
		end

		mSleep(200)
		if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) == 0x808080 or getColor(676,258) == 0x818181 then
			if getColor(655,211) == 0xffffff then
				toast("切换下一个账号", 1)
				mSleep(500)
				table.remove(self.qqList, 1)
				writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
				self:getAccount()
				inputAgain = true
				goto hk
			elseif getColor(683,209) == 0xffffff then
				toast("切换下一个账号,重新新机", 1)
				mSleep(500)
				table.remove(self.qqList, 1)
				writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
				goto over
			end
		end

		--动态密码
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "56|-3|0xffffff,-190|-32|0x0078ff,-192|26|0x0078ff,27|27|0x0078ff,29|-33|0x0078ff,257|-29|0x0078ff,250|20|0x0078ff,244|-121|0x0078ff,335|-127|0x0078ff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			toast("动态密码,切换下一个账号", 1)
			mSleep(500)
			table.remove(self.qqList, 1)
			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
			goto over
		end

		--已经注册过，需要绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			toast("已经注册过，需要绑定手机号码", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end
		
		--跳过屏蔽通讯录
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
		end
		
		--首页
		mSleep(200)
		if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
		getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 or
		getColor(206, 156) == 0x323333 and getColor(336, 157) == 0x323333 or
		getColor(206,  153) == 0x313232 and getColor(371,  131) == 0x313232 then
			mSleep(500)
			toast("首页1", 1)
			mSleep(500)
			goto sy
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页2", 1)
			mSleep(500)
			goto sy
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页3", 1)
			mSleep(500)
			goto sy
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	t1 = ts.ms()
	while true do
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"17|0|0x323333,9|8|0x323333,0|17|0x323333,17|17|0x323333,2|6|0xffffff,18|7|0xffffff,10|17|0xffffff,9|-1|0xffffff",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y + 110, 4)
			mSleep(math.random(500, 700))
			toast("生日", 1)
			mSleep(1000)
			break
		end

		--填写资料
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(1000)
			tap(x + 300, y + 121)
			mSleep(1500)
			for var = 1, 20 do
				mSleep(200)
				keyDown("DeleteOrBackspace")
				mSleep(100)
				keyUp("DeleteOrBackspace")
				mSleep(100)
			end
			mSleep(500)
			inputStr(Nickname)
			mSleep(1000)
			toast("生日前输入昵称", 1)
			mSleep(500)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	--上下
	topBottom = math.random(1, 2)
	--年份
	year = math.random(1, 5)
	--月份
	month = math.random(1, 6)
	--日期
	day = math.random(1, 15)

	t1 = ts.ms()
	while true do
		--生日
		mSleep(200)
		if getColor(38, 873) == 0x848484 and getColor(57, 1012) == 0xffffff then
			if topBottom == 1 then
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, 1100, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, 1100, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, 1100, 4)
				end
			else
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, 1229, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, 1229, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, 1229, 4)
				end
			end

			while true do
				mSleep(200)
				if getColor(432, 732) == 0xffffff then
					if sex == "0" then
						mSleep(500)
						randomTap(190, 612, 4)
						mSleep(500)
					else
						mSleep(500)
						randomTap(550, 612, 4)
						mSleep(500)
					end
					break
				else
					mSleep(500)
					randomTap(431, 708, 4)
					mSleep(1000)
				end
			end
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	t1 = ts.ms()
	while true do
		--下一步
		mSleep(200)
		if getColor(470, 842) == 0x18d9f1 then
			mSleep(500)
			randomTap(470, 842, 4)
			mSleep(500)
			toast("下一步", 1)
			mSleep(1000)
			self.subName = "未注册过"
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end
	
	::sy::
	t1 = ts.ms()
	while true do
		--首页
		mSleep(200)
		if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
		getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 or
		getColor(206, 156) == 0x323333 and getColor(336, 157) == 0x323333 or
		getColor(206,  153) == 0x313232 and getColor(371,  131) == 0x313232 then
			mSleep(500)
			toast("首页1", 1)
			mSleep(500)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页2", 1)
			mSleep(500)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页3", 1)
			mSleep(500)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x18d9f1,"121|-9|0x18d9f1,64|55|0x18d9f1,62|36|0xf6f6f6,-28|12|0xf6f6f6,164|-4|0xf6f6f6,58|328|0xd8d8d8",90,0,0,750,1334,{orient = 2})
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(675,   83, 4)
			mSleep(math.random(500, 700))
			toast("上传照片1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(675,   83, 4)
			mSleep(math.random(500, 700))
			toast("上传照片2", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "13|5|0xcdcdcd,17|5|0xcdcdcd,25|8|0xffffff,32|8|0xcdcdcd,46|8|0xcdcdcd,39|1|0xcdcdcd,-448|824|0x18d9f1,-86|815|0x18d9f1,-298|819|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x + 20, y + 10, 4)
			mSleep(math.random(500, 700))
			toast("上传照片3", 1)
			mSleep(1000)
		end
		
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("立即打卡1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("立即打卡2", 1)
			mSleep(1000)
		end

		--下一步
		mSleep(200)
		if getColor(113,839) == 0x18d9f1 or getColor(632,841) == 0x18d9f1 then
			mSleep(500)
			randomTap(470, 842, 4)
			mSleep(500)
		end

		--跳过
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"4|10|0x323333,13|4|0x323333,17|4|0x323333,32|7|0x323333,47|7|0x323333,42|-1|0x323333,59|5|0xffffff,-20|3|0xffffff,25|27|0xffffff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x + 20, y + 10, 4)
			mSleep(500)
			toast("跳过", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			randomTap(x + 10, y + 5, 3)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end

		--有新版本
		mSleep(200)
		if getColor(265, 944) == 0x3bb3fa and getColor(491, 949) == 0x3bb3fa then
			mSleep(500)
			randomTap(377, 1042, 4)
			mSleep(500)
			toast("有新版本", 1)
			mSleep(500)
		end

		--绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			randomTap(672, 85, 4)
			mSleep(500)
			toast("绑定手机号码", 1)
			mSleep(500)
		end

		--跳过屏蔽通讯录
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	time = 0
	t1 = ts.ms()
	while (true) do
		--更多
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x + 10, y - 10, 4)
			mSleep(1000)
			randomTap(x + 10, y - 10, 4)
			mSleep(500)
			toast("更多1",1)
			mSleep(500)
			break
		end
		
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x + 10, y, 4)
			mSleep(1000)
			randomTap(x + 10, y, 4)
			mSleep(500)
			toast("更多2",1)
			mSleep(500)
			break
		end
		
		--跳过屏蔽通讯录
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
		end
		
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("立即打卡1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("立即打卡2", 1)
			mSleep(1000)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			randomTap(x + 10, y + 5, 3)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	if searchFriend == "0" then
		t1 = ts.ms()
		while true do
			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y - 10, 4)
				mSleep(1000)
				randomTap(x + 10, y - 10, 4)
				mSleep(500)
				toast("更多1",1)
				mSleep(500)
			end
			
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y, 4)
				mSleep(1000)
				randomTap(x + 10, y, 4)
				mSleep(500)
				toast("更多2",1)
				mSleep(500)
			end

			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				mSleep(500)
				randomTap(x, y, 4)
				mSleep(500)
				toast("绑定手机", 1)
				mSleep(500)
			end

			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				randomTap(x + 10, y + 5, 3)
				mSleep(500)
				toast("绑定手机2", 1)
				mSleep(500)
			end

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y - 10, 4)
				mSleep(1000)
			end
			
			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y, 4)
				mSleep(1000)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("好友",1)
				mSleep(500)
			end
			
			mSleep(200)
    		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
    		if x ~= -1 and y ~= -1 then
    			mSleep(500)
				tap(x, y)
				mSleep(500)
    			toast("立即打卡1", 1)
    			mSleep(1000)
    		end
    
    		mSleep(200)
    		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
    		if x ~= -1 and y ~= -1 then
    			mSleep(500)
				tap(x, y)
				mSleep(500)
    			toast("立即打卡2", 1)
    			mSleep(1000)
    		end

			--输入好友账号
			mSleep(200)
			if getColor(420,  284) == 0xf3f3f3 then
				mSleep(500)
				randomTap(420,  284, 4)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(470,  334) == 0xf3f3f3 then
				mSleep(500)
				randomTap(470,  334, 4)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(1000)
			end

			--搜索用户
			mSleep(200)
			if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
				mSleep(500)
				randomTap(108,  179, 4)
				mSleep(500)
				toast("搜索",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end

		t1 = ts.ms()
		while true do
			--返回到更多页面
			mSleep(200)
			if getColor(678,   83) == 0xffffff or getColor(678,  131) == 0xffffff then
				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0xffffff then
						mSleep(2000)
						randomTap(55,   82, 4)
						mSleep(500)
					elseif getColor(678,  131) == 0xffffff then
						mSleep(2000)
						randomTap(55,   128, 4)
						mSleep(500)
					else
						mSleep(2000)
						randomTap(55,   128, 4)
						mSleep(500)
					end

					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						break
					end
				end

				t1 = ts.ms()
				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						randomTap(678,   83, 4)
						mSleep(500)
					end

					--好友
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						break
					else
						mSleep(200)
						if getColor(420,  284) == 0xf3f3f3 then
							mSleep(500)
							randomTap(55,   82, 4)
							mSleep(500)
						elseif getColor(470,  334) == 0xf3f3f3 then
							mSleep(500)
							randomTap(55,   132, 4)
							mSleep(500)
						else
							mSleep(500)
							randomTap(55,   132, 4)
							mSleep(500)
						end
					end

					self:timeOutRestart(t1)
					mSleep(1000)
				end
				break
			end
			self:timeOutRestart(t1)
			mSleep(1000)
		end
	end

	if changeHeader == "0" then
		t1 = ts.ms()
		while true do
		    mSleep(200)
    		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
    		if x ~= -1 and y ~= -1 then
    			mSleep(500)
				tap(x, y)
				mSleep(500)
    			toast("立即打卡1", 1)
    			mSleep(1000)
    		end
    
    		mSleep(200)
    		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
    		if x ~= -1 and y ~= -1 then
    			mSleep(500)
				tap(x, y)
				mSleep(500)
    			toast("立即打卡2", 1)
    			mSleep(1000)
    		end
		
			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y - 10, 4)
				mSleep(1000)
				randomTap(x + 10, y - 10, 4)
				mSleep(500)
				toast("更多1",1)
				mSleep(500)
			end
			
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x + 10, y, 4)
				mSleep(1000)
				randomTap(x + 10, y, 4)
				mSleep(500)
				toast("更多2",1)
				mSleep(500)
			end

			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "30|-11|0xaaaaaa,68|-15|0xaaaaaa,62|-4|0xaaaaaa,69|0|0xaaaaaa,52|0|0xaaaaaa,84|-3|0xaaaaaa,101|-3|0xaaaaaa,17|-7|0xffffff,-82|-5|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("个人资料",1)
				mSleep(500)
			end

			--下次再说
			mSleep(200)
			if getColor(255, 1031) == 0x3bb3fa and getColor(557, 1020) == 0x3bb3fa then
				mSleep(500)
				randomTap(370, 1131, 4)
				mSleep(500)
				toast("下次再说",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x, y, 4)
				mSleep(500)
				toast("编辑",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end

		t1 = ts.ms()
		while true do
			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 180,y,4)
				mSleep(500)
			end

			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y + 120,4)
				mSleep(500)
				toast("相册",1)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				mSleep(500)
				randomTap(370,  298,4)
				mSleep(500)
			end

			--继续
			mSleep(200)
			if getColor(663,   86) == 0x3bb3fa and getColor(701,   88) == 0x3bb3fa then
				mSleep(500)
				randomTap(663,   86,4)
				mSleep(500)
				toast("继续",1)
				mSleep(500)
			end

			--完成
			mSleep(200)
			if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("完成",1)
				mSleep(500)
			end

			--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("保存",1)
				mSleep(500)
			end

			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("好的",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end

		t1 = ts.ms()
		while true do
			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(55,   87, 4)
				mSleep(500)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end
	end

	t1 = ts.ms()
	while true do
		--更多
		mSleep(200)
		if getColor(665, 1310) == 0xf6aa00 then
			mSleep(500)
			randomTap(693, 80, 4)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(200)
		if getColor(664, 1253) == 0xf8aa05 or getColor(664, 1253) == 0xf6aa00 then
			mSleep(500)
			randomTap(696,  130, 4)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	if changePass == "0" then
		t1 = ts.ms()
		while true do
			--设置
			mSleep(200)
			if getColor(342, 80) == 0 and getColor(386, 79) == 0 then
				mSleep(500)
				randomTap(577, 209, 4)
				mSleep(500)
				toast("设置",1)
				mSleep(500)
			end

			--设置
			mSleep(200)
			if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
				mSleep(500)
				randomTap(577, 254, 4)
				mSleep(500)
				toast("设置",1)
				mSleep(500)
			end

			--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x, y, 4)
				mSleep(500)
				toast("密码修改",1)
				mSleep(500)
			end

			--重置密码
			mSleep(200)
			if getColor(642,   87) == 0x3bb3fa and getColor(689, 87) == 0x3bb3fa then
				mSleep(500)
				randomTap(396, 194, 4)
				mSleep(500)
				toast("重置密码",1)
				mSleep(500)
				while true do
					mSleep(400)
					if getColor(712, 193) == 0xcccccc then
						break
					else
						mSleep(500)
						inputStr(password)
						mSleep(1000)
					end

					self:timeOutRestart(t1)
					mSleep(1000)
				end

				mSleep(500)
				randomTap(396, 279, 4)
				mSleep(500)
				while true do
					mSleep(400)
					if getColor(712, 281) == 0xcccccc then
						break
					else
						mSleep(500)
						inputStr(password)
						mSleep(1000)
					end

					self:timeOutRestart(t1)
					mSleep(1000)
				end
				mSleep(500)
				randomTap(666, 81, 4)
				mSleep(5000)
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end
	end

	::get_mmId::
	self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")

	times = getNetTime()
	sj = os.date("%Y年%m月%d日%H点%M分%S秒",times)

	--重命名当前记录名
	local old_name = AMG.Get_Name()
	local new_name = self.mm_accountId .. "----QQ----" .. self.subName .. "----" .. Nickname .. "----" .. self.phone_type .. "----" .. self.sys_version .. "----" .. self.city .. "----" .. sj
	toast(new_name,1)
	mSleep(1000)
	if AMG.Rename(old_name, new_name) == true then
		toast("重命名当前记录 " .. old_name .. " 为 " .. new_name, 3)
	end

	table.remove(self.qqList, 1)
	writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
	mSleep(1000)

	::over::
end

function model:main()
	local w, h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 30,
		views = {
			{
				["type"] = "Label",
				["text"] = "陌陌脚本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "照片文件夹路径是在触动res下，文件夹名字是picFile",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "号码文件路径是在触动res下，文件名字是phoneNum.txt",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "设置密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入密码",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "性别选择",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "女生,男生",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "是否需要搜索好友",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "需要,不需要",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "设置搜索好友用户名",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入搜索好友用户名",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "是否需要换头像",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "换头像,不换头像",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "昵称类型选择",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "正常,偏女性化",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择多个系统版本随机",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "CheckBoxGroup",
				["id"] = "version", 
				["list"] = "13.0,13.1,13.1.1,13.1.2,13.1.3,13.2,13.2.2,13.2.3,13.3,13.3.1,13.4,13.4.1,13.5,13.5.1,13.6,13.6.1,13.7,14.0,14.0.1,14.1,14.2,14.3",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择多个手机型号随机",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "CheckBoxGroup",
				["id"] = "phoneType", 
				["list"] = "iPhone 7,iPhonse 7 Plus,iPhone 8,iPhone 8 Plus,iPhone X,iPhone Xr,iPhone Xs,iPhone Xs Max,iPhone 11,iPhone 11 Pro,iPhone 11 Pro Max",
				["select"] = "0",
				["countperline"] = "3"
			},
			{
				["type"] = "Label",
				["text"] = "是否开启网络检测",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "开启,不开启",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "是否开启GPS定位修改",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "开启,不开启,普通定位",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "是否修改密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "修改,不修改",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择修改型号系统方式",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "暂不修改,amg接口修改,单选型号,单选版本,脚本随机型号系统修改",
				["select"] = "0",
				["countperline"] = "3"
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, sysVersion, sysPhoneType, openPingNet, gpsAddress, changePass, editorWay = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if searchFriend == "0" then
		if searchAccount == "" or searchAccount == "默认值" then
			dialog("搜索好友用户名不能为空，请重新运行脚本设置搜索好友用户名", 3)
			luaExit()
		end
	end

	while true do
		self:getAccount()

		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)

		changeHeader = "1"
		if changeHeader == "0" then
			clearAllPhotos()
			mSleep(500)
			clearAllPhotos()
			mSleep(500)
			fileName = self:downImage()
			toast(fileName, 1)
			mSleep(1000)

			--		saveImageToAlbum(fileName)
			saveImageToAlbum(userPath() .. "/res/picFile/" .. fileName)
			mSleep(500)
			--		saveImageToAlbum(fileName)
			saveImageToAlbum(userPath() .. "/res/picFile/" .. fileName)
			mSleep(2000)

			--		self:deleteImage(fileName)
			self:deleteImage(userPath() .. "/res/picFile/" .. fileName)
		end

		self:vpn(openPingNet)
		self:newMMApp(sysVersion, sysPhoneType, gpsAddress, editorWay)
		self:mm(password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, changePass)
	end
end

model:main()
