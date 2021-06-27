--陌陌-qq号码注册 爱加速AJS
require "TSLib"
local sz                    = require("sz") --登陆
local http                  = require("szocket.http")
local ts                    = require("ts")
local json                  = ts.json
local plist                 = ts.plist

local model                 = {}

model.awz_bid               = "com.superdev.AMG"
model.mm_bid                = "com.wemomo.momoappdemo1"
model.ajs_bid               = "com.aijiasuinc.AiJiaSuClient"

model.qqList                = {}

model.qqAcount              = ""
model.qqPassword            = ""
model.phone_table           = {}
model.phone                 = ""
model.code_token            = ""
model.mm_yzm                = ""

model.mm_accountId          = ""
model.subName               = ""

model.city                  = ""
model.phone_type            = "脚本自动选择"
model.sys_version           = "脚本自动选择"

model.updatePass            = false

model.special_str           = "ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿ゠ㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ"

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:click(click_x, click_y, ms)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(500, 600))
end

function model:myToast(str,ms)
	toast(str,1)
	mSleep(ms and ms or math.random(500, 600))
end

--检查AMG是否在前台
function model:Check_AMG()
	while true do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
		if x ~= -1 then
			toast("进入界面成功", 1)
			mSleep(500)
			break
		end

		--提示：网络连接失败(5)
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|10|0x007aff,10|11|0x007aff,19|11|0x007aff,32|11|0x007aff,38|11|0x007aff,52|11|0x007aff,76|11|0x007aff,76|-2|0x007aff,58|-135|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y)
			lua_restart()
		end

		mSleep(50)
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

			if changeVPNWay == "1" then
				model:ajs_vpn()
			end

			::newR::
			mSleep(50)
			if isFrontApp(model.awz_bid) == 0 then
				runApp(model.awz_bid)
				mSleep(3000)
				model:Check_AMG()
			end

			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=newRecord")
			if code == 200 then
				return model:Check_AMG_Result()
			else
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "-18|-4|0x007aff,-21|-8|0x007aff,13|2|0x007aff,26|-9|0x007aff,27|10|0x007aff,47|-12|0x0d80ff,57|11|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x, y)
					toast("我知道了",1)
					mSleep(500)
				end

				goto newR
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
	keepScreen(true)
	mSleep(500)
	snapshot("test_3.jpg", 33, 503, 712, 892)
	ts.img.binaryzationImg(userPath() .. "/res/test_3.jpg", mns)
	if self:file_exists(userPath() .. "/res/tmp.jpg") then
		toast("正在计算", 1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath() .. "/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333)
		if type(point) == "table" and #point ~= 0 then
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
		mSleep(50)
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

		mSleep(50)
		flag = isFrontApp(self.awz_bid)
		if flag == 0 then
			closeApp(self.awz_bid)
			mSleep(3000)
			goto runAgain1
		end
	end
end

function model:timeOutRestart(t1)
	if self:vpn_connection("1") == 1 then
		return true
	end

	t2 = ts.ms()

	diff_time = os.difftime(t2, t1)
	if diff_time > 60 then
		return true
	else
		toast("距离重启脚本还有"..(60 - os.difftime(t2, t1)) .. "秒",1)
		mSleep(1000)
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
			--提示：网络连接失败(5)
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|10|0x007aff,10|11|0x007aff,19|11|0x007aff,32|11|0x007aff,38|11|0x007aff,52|11|0x007aff,76|11|0x007aff,76|-2|0x007aff,58|-135|0x000000", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				lua_restart()
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				self:click(x, y + 180)
				toast("设置", 1)
				mSleep(500)
			end

			mSleep(50)
			if getColor(347,87) == 0x000000 and getColor(404,97) == 0x000000 then
				toast("进入设置",1)
				mSleep(500)
				break
			end

			mSleep(50)
			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end

		--设置当前设备机型
		if editorWay == "2" or editorWay == "4" then
			while true do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x000000, "5|6|0x000000,22|4|0x000000,38|4|0x000000,54|6|0x000000,59|-11|0x000000,70|-2|0x000000,74|4|0x000000,88|2|0x000000,118|10|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					self:click(x + 200, y)
					toast("进入选择机型",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(2500)
				end
			end

			idx = (math.random(1, 8) - 1) * 90
			while true do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0x000000, "5|-9|0x000000,5|3|0x000000,21|3|0x000000,27|3|0x000000,39|3|0x000000,52|5|0x000000,-24|1|0x000000,-51|4|0x000000,-143|4|0x000000", 100, 0, 0, 749, 1333)
				if x ~= -1 then
					self:click(x, y + idx)
					toast("选择机型",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(2500)
				end
			end

			while true do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x000000, "5|6|0x000000,22|4|0x000000,38|4|0x000000,54|6|0x000000,59|-11|0x000000,70|-2|0x000000,74|4|0x000000,88|2|0x000000,118|10|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					toast("进入下一步",1)
					mSleep(500)
					break
				else
					self:click(55, 85)
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
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy( 0x000000, "4|5|0x000000,21|5|0x000000,38|5|0x000000,53|5|0x000000,53|-11|0x000000,83|9|0x000000,124|-8|0x000000,145|-7|0x000000,230|7|0x000000", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					self:click(x + 200, y)
					toast("进入选择系统版本",1)
					mSleep(500)
					break
				else
					mSleep(500)
					moveTowards(404,1194,90,900,10)
					mSleep(2500)
				end
			end

			-- 			idx = math.random(1, 3)
			yy = math.random(171, 1214)

			for var=1,4 do
				mSleep(500)
				moveTowards(404,1194,90,900,50)
				mSleep(500)
			end

			self:click(300, yy)
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
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				break
			else
				self:click(55, 85)
			end

			mSleep(50)
			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end
	end

	while true do
		mSleep(500)
		--一键新机
		::newApp_again::
		if AMG.New() == true then
			while true do
				mSleep(50)
				if getColor(266, 601) == 0xffffff then
					toast("newApp成功", 1)
					break
				end

				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "-18|-4|0x007aff,-21|-8|0x007aff,13|2|0x007aff,26|-9|0x007aff,27|10|0x007aff,47|-12|0x0d80ff,57|11|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x, y)
					toast("我知道了",1)
					mSleep(500)
				end
				
				mSleep(50)
        		if isFrontApp(self.awz_bid) == 0 then
        			goto newApp_again
        		end

				self:vpn_connection("0")
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
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				self:click(x, y + 180)
				toast("设置", 1)
				mSleep(500)
			end

			mSleep(50)
			if getColor(347,87) == 0x000000 and getColor(404,97) == 0x000000 then
				toast("进入设置",1)
				mSleep(500)
				break
			end

			mSleep(50)
			if isFrontApp(self.awz_bid) == 0 then
				runApp(self.awz_bid)
				mSleep(3000)
			end
		end

		while true do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x000000, "4|-7|0x000000,4|12|0x000000,13|-3|0x000000,20|-5|0x000000,28|2|0x000000,21|10|0x000000,47|-1|0x000000,54|0|0x000000,61|-1|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
				break
			else
				mSleep(500)
				moveTowards(404,1194,90,900,10)
				mSleep(1500)
			end
		end

		while (true) do
			mSleep(50)
			if getColor(379,181) == 0xeaebed and getColor(655,85) ==0x007aff then
				self:click(379, 181)
				inputStr(self.city)
				mSleep(1000)
				key = "ReturnOrEnter"
				keyDown(key)
				keyUp(key)
				mSleep(2000)
				self:click(math.random(178, 599), math.random(618, 1076))
				mSleep(4000)
				self:click(682, 86)
				mSleep(500)
				break
			end
		end

		while true do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "24|0|0x007aff,38|3|0x007aff,55|3|0x007aff,58|14|0x007aff,58|-7|0x007aff,58|-12|0x007aff,75|2|0x007aff,93|2|0x007aff,125|2|0x007aff", 90, 24, 540, 319, 610, { orient = 2 })
			if x ~= -1 then
				toast("准备下一步",1)
				mSleep(500)
				break
			else
				self:click(45, 81)
			end
		end
	end
end

function model:vpn_connection(idx)
	if idx ~= "2" then
		--vpn连接
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x1382ff, "-4|4|0x1382ff,5|10|0x1382ff,2|19|0x1382ff,12|-1|0x1382ff,17|8|0x1382ff,10|13|0x1382ff,24|13|0x1382ff,13|26|0x1382ff,17|19|0x1382ff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y)
			setVPNEnable(true)
			toast("好",1)
			mSleep(3000)
		end

		--网络连接失败：知道了
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "34|5|0x007aff,66|5|0x007aff,63|-11|0x007aff,-63|-102|0x000000,-44|-102|0x000000,3|-98|0x000000,53|-105|0x000000,49|-140|0x000000,4|-142|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y)
			toast("知道了",1)
			mSleep(1000)
		end
	end

	--vpn连接: 好
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|15|0x007aff,16|-5|0x007aff,20|15|0x007aff,-56|-177|0x000000,-48|-159|0x000000,-41|-179|0x000000,40|-167|0x000000,60|-171|0x000000", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		toast("vpn连接0", 1)
		mSleep(500)
		if idx == "1" then
			return 1
		elseif idx == "2" then
			return true
		end
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
			toast("请求ip地址失败："..tostring(body_resp),1)
			mSleep(1000)
			setVPNEnable(false)
			mSleep(2000)
			setVPNEnable(true)
			mSleep(5000)
			goto ip_addresss
		end
	else
		toast("请求ip地址失败："..tostring(body_resp),1)
		mSleep(1000)
		setVPNEnable(false)
		mSleep(2000)
		setVPNEnable(true)
		mSleep(5000)
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

function model:selectVpn()
	openURL("prefs:root=General&path=VPN")

	while (true) do
		mSleep(50)
		if getColor(352,93) == 0x000000 and getColor(424,182) == 0xf2f2f7 then
			mSleep(500)
			self:click(390,  604, 1000)
			self:vpn()
			break
		end
	end
end

function model:ajs_vpn()
	closeApp(self.ajs_bid)
	mSleep(500)
	runApp(self.ajs_bid)
	mSleep(1000)
	
	::ajs_again::
	t1 = ts.ms()
	while (true) do
		mSleep(50)
		if getColor(374,390) == 0x4580ff and getColor(374,438) == 0x4580ff then
			self:click(469, 866)
			self:myToast("准备切换线路")
			break
		else
			setVPNEnable(false)
			mSleep(2000)
		end
		
		if self:timeOutRestart(t1) then
			self:index()
		end
	end
	
	t1 = ts.ms()
	while (true) do
		mSleep(50)
		if getColor(374,390) == 0x4580ff and getColor(374,438) == 0x4580ff then
			self:click(469, 866)
		end
		
		mSleep(50)
		if getColor(646,344) == 0xf5f5f5 then
			break
		elseif getColor(216,181) == 0xf5f5f5 then
			self:click(458, 271)
		end
		
		if self:timeOutRestart(t1) then
			self:index()
		end
	end

	count = math.random(1, 6)

	for var = 1, count do
		mSleep(500)
		moveTowards(404,1194,90,100,10)
		mSleep(1000)
	end
	
	t1 = ts.ms()
	while (true) do
		mSleep(50)
		if getColor(423,415) == 0x467dff and getColor(334,444) == 0x467dff then
			self:myToast("AJS——vpn连接成功")
			break
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x8f9ab3, "15|0|0x8f9ab3,29|0|0x8f9ab3,-46|12|0xd6d6d6,-47|-13|0xd6d6d6,-25|0|0xffffff,45|-1|0xffffff", 100, 0, math.random(130, 1000), 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x - 300, y)
		end
		
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x808080, "18|8|0x808080,9|21|0x808080,38|8|0x808080,38|0|0x808080,48|-1|0x808080,48|18|0x808080,51|9|0x808080,43|9|0x808080", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:myToast("网络未知，重新选择")
			goto ajs_again
		end
		
		if self:timeOutRestart(t1) then
			self:index()
		end
	end
end

function model:vpn()
	::get_vpn::
	if self.ajs_bid == "com.aijiasuinc.AiJiaSuClient" then
		self:click(390,  604, 1000)
	end

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

function model:getPhoneAndToken()
	self.phone_table = readFile(userPath() .. "/res/phoneNum.txt")
	if self.phone_table then
		if #self.phone_table > 0 then
			if #(self.phone_table[1]:atrim()) < 130 and #(self.phone_table[1]:atrim()) > 0 then
				phone_mess = strSplit(self.phone_table[1]:atrim(), "|")
				self.phone = phone_mess[1]
				self.code_token = phone_mess[2]
				toast(self.phone .. "\r\n" .. self.code_token, 1)
				mSleep(1000)
			else
				dialog("号码文件为空或者格式有问题，需要一条数据一行，可能数据没有换行", 0)
				lua_exit()
			end
		else
			dialog("号码文件没号码了", 0)
			lua_exit()
		end
	else
		dialog("号码文件不存在，请检查该文件是否有误", 0)
		lua_exit()
	end
end

function model:get_mess()
	get_code_num = 0

	::get_yzm_restart::
	yzm_time1 = ts.ms()

	::get_yzm::
	header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60)
	status_resp, header_resp, body_resp = ts.httpGet(self.code_token, header_send, body_send)
	toast(status_resp .. "===" .. self.code_token,1)
	mSleep(1000)
	if status_resp == 200 then
		if type(string.find(body_resp, "%d+%d+%d+%d+%d+%d+")) == "number" then
			-- local i, j = string.find(body_resp, "%d+%d+%d+%d+%d+%d+")
			self.mm_yzm = string.match(body_resp,"%d+")
			toast(self.mm_yzm, 1)
			mSleep(2000)
			return true
		else
			yzm_time2 = ts.ms()
			if os.difftime(yzm_time2, yzm_time1) > 65 then
				toast("验证码获取失败，结束下一个", 1)
				mSleep(3000)
				return false
			else
				toast(tostring(body_resp), 1)
				mSleep(3000)
				goto get_yzm
			end
		end
	else
		yzm_time2 = ts.ms()
		if os.difftime(yzm_time2, yzm_time1) > 65 then
			toast("验证码获取失败，结束下一个:"..tostring(body_resp), 1)
			mSleep(3000)
			return false
		else
			toast(tostring(body_resp), 1)
			mSleep(3000)
			goto get_yzm
		end
	end
end

function model:remove_phone()
	table.remove(self.phone_table, 1)

	::save::
	bool = writeFile(userPath() .. "/res/phoneNum.txt", self.phone_table, "w", 1) --将 table 内容存入文件，成功返回 true
	if bool then
		self:myToast("写入成功")
	else
		self:myToast("写入失败")
		goto save
	end
end

function model:clear_input()
	self:click(620, 357)
	mSleep(500)
	for var=1,25 do
		mSleep(50)
		keyDown("DeleteOrBackspace")
		keyUp("DeleteOrBackspace")  
	end
	self:click(620, 469)
	mSleep(500)
	for var=1,30 do
		mSleep(100)
		keyDown("DeleteOrBackspace")
		keyUp("DeleteOrBackspace")  
	end
end

function model:shouye()
	--首页
	mSleep(50)
	if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
	getColor(411, 176) == 0x323333 and getColor(419, 135) == 0x323333 or
	getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 or
	getColor(206, 156) == 0x323333 and getColor(336, 157) == 0x323333 or
	getColor(206,  153) == 0x313232 and getColor(371,  131) == 0x313232 or
	getColor(410,  127) == 0x323333 and getColor(404,  107) == 0x323333 or
	getColor(297, 128) == 0x323333 and getColor(303, 106) == 0x323333 then
		toast("首页1", 1)
		mSleep(500)
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
	if x ~= -1 then
		toast("首页2", 1)
		mSleep(500)
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
	if x ~= -1 then
		toast("首页3", 1)
		mSleep(500)
		return true
	end

	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x323333, "8|0|0x323333,17|-7|0x323333,40|7|0x323333,48|4|0x323333,276|2|0x3bb3fa,290|-2|0x3bb3fa,314|7|0x3bb3fa,326|-6|0x3bb3fa,219|-211|0x323333", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		toast("当前为非wifi环境", 1)
		mSleep(1000)
	end
end

function model:bindPhoneDialog()
	--绑定手机
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		toast("绑定手机", 1)
		mSleep(500)
	end

	--绑定手机
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x + 10, y + 5)
		toast("绑定手机2", 1)
		mSleep(500)
	end
end

function model:location(index)
	--定位服务未开启
	mSleep(50)
	x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
	if x ~= -1 then
		self:click(x, y)
		toast("定位服务未开启", 1)
		mSleep(500)
		return true
	end

	--定位服务未开启
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x, y)
		toast("定位服务未开启2", 1)
		mSleep(500)
		return true
	end

	if index == "0" then
		--同意
		mSleep(50)
		if getColor(298, 941) == 0x3bb3fa and getColor(520, 941) == 0x3bb3fa then
			self:click(376, 944)
		end

		--允许
		mSleep(50)
		if getColor(533, 770) == 0x7aff and getColor(495, 771) == 0x7aff then
			self:click(495, 771)
		end

		--注册登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("注册登录1",1)
			mSleep(500)
		end

		--注册登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("注册登录2",1)
			mSleep(500)
		end
	elseif index == "1" then
		--跳过屏蔽通讯录
		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			self:click(x, y)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
			return true
		end
	end
end

function model:ranSpecialStr()
	local options = {
		["tstab"] = 1, 
		--随机生成 2 位字符串
		["num"] = 1,
	}

	name = getRndStr(self.special_str,options)
	return name
end

function model:mm(password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, changePass)
	Nickname = "已经注册过的账号无昵称"

	closeApp(self.mm_bid)
	mSleep(1000)
	runApp(self.mm_bid)
	mSleep(1000)
	t1 = ts.ms()

	runAgain = false
	while true do
		self:location("0")

		--手机号登录注册
		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
		if x ~= -1 and y ~= -1 then
			if runAgain then
				self:click(x - 160, y)
				toast("手机号登录注册", 1)
				closeApp(self.mm_bid)
				mSleep(1000)
				break
			else
				closeApp(self.mm_bid)
				mSleep(1000)
				runAgain = true
			end
		end

		if loginAccountWay == "0" then
			--qq图标
			mSleep(50)
			x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
			if x ~= -1 and y ~= -1 then
				mSleep(500)
				closeApp(self.mm_bid)
				mSleep(2000)
				break
			end
		elseif loginAccountWay == "1" then
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "-128|-6|0x18d9f1,-109|0|0x18d9f1,-91|-4|0x18d9f1,-63|-3|0x18d9f1,-29|8|0x18d9f1,28|-2|0x18d9f1,51|-3|0x18d9f1,80|-4|0x18d9f1,67|-96|0xd8d8d8", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				toast("手机号验证码登录",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "8|-90|0xd8d8d8,561|-96|0xd8d8d8,258|-97|0xffffff,328|-87|0xffffff,150|10|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				break
			end
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	::white::
	if loginAccountWay == "0" then
		t1 = ts.ms()
		while true do
			self:location("0")

			--手机号登录注册
			mSleep(50)
			x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
			if x ~= -1 and y ~= -1 then
				self:click(x - 160, y)
			end

			--qq图标
			mSleep(50)
			x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
			if x ~= -1 and y ~= -1 then
				self:click(x, y)
				toast("扣扣图标",1)
				mSleep(math.random(3500, 5000))
				break
			end

			flag = isFrontApp(self.mm_bid)
			if flag == 0 then
				runApp(self.mm_bid)
				mSleep(3000)
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end
	end

	huakuai = false
	inputAgain = false
	huanjing_error = 0
	::hk::
	if loginAccountWay == "0" then
		t1 = ts.ms()
		hk_whiteBool = true
		while (true) do
			flag = isFrontApp(self.mm_bid)
			if flag == 0 then
				runApp(self.mm_bid)
				mSleep(3000)
			else
				toast("应用在线",1)
				mSleep(1000)
			end

			mSleep(100)
			if getColor(239, 629) == 0x12b7f5 then
				if inputAgain then
					self:clear_input()
				end

				mSleep(5000)
				while (true) do
					mSleep(200)
					if getColor(676,  357) == 0xbbbbbb or getColor(599,354) == 0xffffff then
						self:click(447, 477)
						break
					else
						self:click(395, 357)
						mSleep(1500)
						inputStr(self.qqAcount)
						mSleep(1000)
					end

					flag = isFrontApp(self.mm_bid)
					if flag == 0 then
						goto over
					end
				end

				writePasteboard(self.qqPassword)
				while (true) do
					mSleep(200)
					if getColor(89,  465) == 0x000000 or getColor(163,471) == 0x000000 then
						self:click(239, 629)
						mSleep(3000)
						break
					else
						self:click(447, 477)
						keyDown("RightGUI")
						keyDown("v")
						keyUp("v")
						keyUp("RightGUI")
						mSleep(1000)
					end

					flag = isFrontApp(self.mm_bid)
					if flag == 0 then
						goto over
					end
				end
			end

			mSleep(100)
			if getColor(391,541) == 0x12b7f5 and getColor(379,884) == 0x000000 then
				if selectWay == "0" then
					self:click(379, 884)
					table.remove(self.qqList, 1)
					writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
					self:getAccount()
					inputAgain = true
					toast("扣扣登陆异常,换号重新登录",1)
					log("扣扣登陆异常,换号重新登录")
					mSleep(1000)
				else
					toast("扣扣登陆不上去,重新运行",1)
					mSleep(1000)
					goto over
				end
			end

-- 			--滑块白色为加载出图片
-- 			mSleep(200)
-- 			if getColor(83,413) == 0xefefef and getColor(691,1038) == 0xefefef then
-- 				if hk_whiteBool then
-- 					t3 = ts.ms()
-- 					hk_whiteBool = false
-- 				end

-- 				if os.difftime(ts.ms(), t3) > 25 then
-- 					mSleep(500)
-- 					setVPNEnable(false)
-- 					mSleep(2000)
-- 					self:vpn()
-- 					hk_whiteBool = true
-- 					toast("滑块未加载成功",1)
-- 					mSleep(1000)
-- 				else
-- 					toast("滑块白色：" .. os.difftime(ts.ms(), t3),1)
-- 				end
-- 			end

			mSleep(100)
			if isColor(116,949,0x007aff,100) then
				toast("准备滑块",1)
				log("准备滑块")
				mSleep(500)
				if huakuai then
					x_lens = self:moves()
					if tonumber(x_lens) > 0 then
						mSleep(math.random(500, 700))
						moveTowards(116, 949, 10, x_len - 65)
						mSleep(500)
						self:click(370, 1024)
						mSleep(1500)
						huakuai = false
						break
					else
						mSleep(200)
						self:click(603, 1032)
						mSleep(math.random(3000, 6000))
						toast("刷新滑块1",1)
						mSleep(500)
					end
				else
					mSleep(200)
					self:click(603, 1032)
					mSleep(math.random(3000, 6000))
					huakuai = true
					toast("刷新滑块2",1)
					mSleep(500)
				end
			end

-- 			mSleep(100)
-- 			if getColor(296,  615) == 0x12b7f5 and getColor(682,  259) == 0x818181 then
-- 				toast("暂时无法登陆", 1)
-- 				mSleep(500)
-- 				self.subName = "暂时无法登陆"
-- 				goto get_mmId
-- 			end

			if self:vpn_connection("2") then
				toast("结束进行下一个",1)
				log("结束进行下一个")
				goto over
			end

			--填写资料
			mSleep(100)
			x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",100,0,0,750,1334,{orient = 2})
			if x ~= -1 then
				toast("不需要过滑块", 1)
				mSleep(500)
				break
			end

-- 			--已经注册过，需要绑定手机号码
-- 			mSleep(100)
-- 			if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
-- 				toast("已经注册过，需要绑定手机号码", 1)
-- 				mSleep(500)
-- 				self.subName = "注册过"
-- 				goto get_mmId
-- 			end

			if self:location("1") then
				self.subName = "注册过"
				self.updatePass = true
				toast("注册过",1)
				log("注册过")
				goto sy
			end

			mSleep(100)
			if getColor(74,  464) == 0x000000 and getColor(676, 258) ~= 0xffffff then
				-- if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) == 0x808080 or getColor(676,258) == 0x818181 or getColor(78,468) == 0x000000 
				-- or getColor(676,  257) == 0x7f7f7f or getColor(78,468) == 0x000000 then
				if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) ~= 0xffffff then
					-- 你的账号暂时无法登陆，请点击这里恢复正常使用
					if getColor(655,211) == 0xffffff then
						toast("你的账号暂时无法登陆，请点击这里恢复正常使用", 1)
						mSleep(500)
						table.remove(self.qqList, 1)
						writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
						-- writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
						self:getAccount()
						self:clear_input()
						inputAgain = true
						-- 		goto hk
						--					goto over
						--该帐号密码已泄漏
					elseif getColor(681,246) == 0x4d94ff then
						if selectWay == "0" then
							toast("该帐号密码已泄漏", 1)
							mSleep(500)
							writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
							table.remove(self.qqList, 1)
							writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
							goto over
							-- 			setVPNEnable(false)
							-- 			mSleep(2000)
							-- 			self:vpn()

							-- 			huanjing_error = huanjing_error + 1
							-- 			if huanjing_error > 3 then
							-- 				writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
							-- 				self:getAccount()
							-- 				inputAgain = true
							-- 				huanjing_error = 0
							-- 			end
							-- 			goto hk
						else
				-- 			table.remove(self.qqList, 1)
				-- 			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
							goto over
						end
					else
						toast("切换下一个账号2", 1)
						mSleep(500)
						table.remove(self.qqList, 1)
						writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
						-- writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
						-- self:getAccount()
						-- inputAgain = true
						-- goto hk
						goto over
					end
				end
			end

			if self:timeOutRestart(t1) then
				goto over
			end
--			diff_time = self:timeOutRestart(t1)
--			if diff_time > 30 then
--				mSleep(500)
--				closeApp(self.mm_bid)
--				mSleep(500)
--				setVPNEnable(false)
--				mSleep(2000)
--				self:vpn()
--				goto white
--			end
			mSleep(1000)
		end
	elseif loginAccountWay == "1" then
		back_again = 0
		getPhoneInputAgain = 0

		::input_us::
		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "-128|-6|0x18d9f1,-109|0|0x18d9f1,-91|-4|0x18d9f1,-63|-3|0x18d9f1,-29|8|0x18d9f1,28|-2|0x18d9f1,51|-3|0x18d9f1,80|-4|0x18d9f1,67|-96|0xd8d8d8", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				toast("手机号验证码登录",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "8|-90|0xd8d8d8,561|-96|0xd8d8d8,258|-97|0xffffff,328|-87|0xffffff,150|10|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x + 30, y - 270)
				toast("选择区号",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x8e8e93, "45|-10|0x8e8e93,556|4|0xffffff,657|10|0xc9c9ce,181|-97|0x000000,260|-94|0x000000,31|50|0xc9c9ce", 100, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x + 100, y)
				mSleep(1000)
				inputStr("美国")
				mSleep(1000)
				key = "ReturnOrEnter"
				keyDown(key)
				keyUp(key)
				mSleep(500)
				self:click(x + 100, y + 10)
				mSleep(500)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		::get_phone_agagin::
		if back_again > 0 then
			t1 = ts.ms()
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x18d9f1, "32|-1|0x18d9f1,65|10|0x18d9f1,97|0|0x18d9f1,124|-1|0x18d9f1,150|0|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					--          mSleep(500)
					-- 			randomTap(584,401, 4)
					-- 			mSleep(1500)
					-- 			for var=1,25 do
					--         		mSleep(50)
					--         		keyDown("DeleteOrBackspace")
					--         		keyUp("DeleteOrBackspace")  
					-- 			end
					break
				end

				if self:timeOutRestart(t1) then
					goto over
				end
			end
		end

		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x8e8e93, "45|-10|0x8e8e93,556|4|0xffffff,657|10|0xc9c9ce,181|-97|0x000000,260|-94|0x000000,31|50|0xc9c9ce", 100, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				goto input_us
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "8|-90|0xd8d8d8,561|-96|0xd8d8d8,258|-97|0xffffff,328|-87|0xffffff,150|10|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x + 350, y - 270)
				mSleep(1000)
				inputStr(self.phone)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "419|11|0x18d9f1,89|-12|0xffffff,161|11|0xffffff,191|-2|0xffffff,137|-40|0x18d9f1,150|35|0x18d9f1", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				toast("登陆",1)
				mSleep(1000)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "-38|-1|0x18d9f1,28|0|0x18d9f1,90|-1|0xb3b3b3,525|-1|0xb3b3b3,499|113|0xd8d8d8,61|124|0xd8d8d8", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "-38|-1|0x18d9f1,28|0|0x18d9f1,90|-1|0xb3b3b3,525|-1|0xb3b3b3,499|113|0xd8d8d8,61|124|0xd8d8d8", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				if inputPhoneAgain == "1" then
					back_again = back_again + 1
					if back_again > 1 then
						break
					else
						self:click(55, 85)
						mSleep(1500)
						goto get_phone_agagin
					end
				else
					break
				end
			else
				self:click(119, 414)
				mSleep(1000)
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		getMessStatus = self:get_mess()
		if getMessStatus then
			mSleep(50)
			if getColor(629, 1264) == 0 then
				-- mSleep(500)
				-- tap(119, 363)
				-- mSleep(1000)
				for i = 1, #(self.mm_yzm) do
					mSleep(300)
					num = string.sub(self.mm_yzm, i, i)
					mSleep(100)
					if num == "0" then
						self:click(373, 1281)
					elseif num == "1" then
						self:click(132, 955)
					elseif num == "2" then
						self:click(377, 944)
					elseif num == "3" then
						self:click(634, 941)
					elseif num == "4" then
						self:click(128, 1063)
					elseif num == "5" then
						self:click(374, 1061)
					elseif num == "6" then
						self:click(628, 1055)
					elseif num == "7" then
						self:click(119, 1165)
					elseif num == "8" then
						self:click(378, 1160)
					elseif num == "9" then
						self:click(633, 1164)
					end
					mSleep(100)
				end
				mSleep(1000)
				self:remove_phone()
			end
		else
			getPhoneInputAgain = getPhoneInputAgain + 1
			if getPhoneInputAgain > 3 then
				::saveAgain::
				mSleep(500)
				bool = writeFileString(userPath().."/res/phoneError.txt",self.phone .. "----" .. self.code_token,"a",1) --将 string 内容存入文件，成功返回 true
				if bool then
					toast("保存号码到失败文件成功",1)
				else
					toast("保存号码到失败文件失败",1)
					goto saveAgain
				end
				self:remove_phone()
				goto over
			else
				toast("第" .. getPhoneInputAgain .. "次获取验证码失败，保存号码到失败文件",1)
				mSleep(1000)
				::saveAgain::
				mSleep(500)
				bool = writeFileString(userPath().."/res/phoneError.txt",self.phone .. "----" .. self.code_token,"a",1) --将 string 内容存入文件，成功返回 true
				if bool then
					toast("保存号码到失败文件成功",1)
				else
					toast("保存号码到失败文件失败",1)
					goto saveAgain
				end
				self:remove_phone()
				self:getPhoneAndToken()
				self:click(55, 85)
				mSleep(1500)

				t1 = ts.ms()
				while (true) do
					mSleep(50)
					x,y = findMultiColorInRegionFuzzy(0x18d9f1, "32|-1|0x18d9f1,65|10|0x18d9f1,97|0|0x18d9f1,124|-1|0x18d9f1,150|0|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
					if x ~= -1 then
						self:click(x + 444, y - 120)
						mSleep(1000)
						for var=1,25 do
							mSleep(50)
							keyDown("DeleteOrBackspace")
							keyUp("DeleteOrBackspace")  
						end
						break
					end

					if self:timeOutRestart(t1) then
						goto over
					end
				end

				back_again = 0
				goto get_phone_agagin
			end
		end
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

	if addSpecialStr == "1" then
		Nickname = self:ranSpecialStr() .. Nickname .. self:ranSpecialStr()
	end

	change_vpn_bool = false
	t1 = ts.ms()
	while true do
		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		--不是我的，注册新号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "35|-2|0x323333,64|-14|0x323333,91|-7|0x323333,164|-13|0x323333,254|-10|0x323333,365|-8|0xffffff,-115|-156|0xc9c9c9,349|-149|0xc9c9c9,150|-141|0xfafafa", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y)
			toast("不是我的，注册新号", 1)
			mSleep(500)
		end

		mSleep(50)
		if getColor(116, 949) == 0x007aff then
			self:click(603, 1032)
			mSleep(math.random(3000, 6000))
			toast("重新滑块",1)
			mSleep(500)
			goto hk
		end

		mSleep(50)
		if getColor(391,541) == 0x12b7f5 and getColor(379,884) == 0x000000 then
			if selectWay == "0" then
				self:click(379, 884)
				table.remove(self.qqList, 1)
				writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
				self:getAccount()
				inputAgain = true
				goto hk
			else
				toast("扣扣登陆不上去,重新运行",1)
				mSleep(1000)
				goto over
			end
		end

		mSleep(50)
		if getColor(149,  187) == 0x323233 or getColor(149,187) == 0x323333 or getColor(149,  187) == 0x313232 then
			mSleep(500)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			toast("收起键盘",1)
			mSleep(500)
		end

		--填写资料
		mSleep(50)
--		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",100,0,0,750,334,{orient = 2})
		if x ~= -1 then
			if not change_vpn_bool then
				self:selectVpn()
				change_vpn_bool = true
			else
				self:click(x + 300, y + 121)
				mSleep(1000)
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
		end

		mSleep(50)
		if getColor(74,  464) == 0x000000 and getColor(676, 258) ~= 0xffffff then
			-- if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) == 0x808080 or getColor(676,258) == 0x818181 or getColor(78,468) == 0x000000 
			-- or getColor(676,  257) == 0x7f7f7f or getColor(78,468) == 0x000000 then
			if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) ~= 0xffffff then
				if getColor(655,211) == 0xffffff then
					toast("你的账号暂时无法登陆，请点击这里恢复正常使用", 1)
					mSleep(500)
					table.remove(self.qqList, 1)
					writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
					-- writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
					self:getAccount()
					self:clear_input()
					inputAgain = true
					goto hk
					-- 	goto over
				elseif getColor(681,246) == 0x4d94ff then
					if selectWay == "0" then
						toast("该帐号密码已泄漏", 1)
						mSleep(500)
						writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
						table.remove(self.qqList, 1)
						writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
						goto over
						-- 		setVPNEnable(false)
						-- 		mSleep(2000)
						-- 		self:vpn()

						-- 		huanjing_error = huanjing_error + 1
						-- 		if huanjing_error > 3 then
--							writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
--							self:getAccount()
--							inputAgain = true
--							huanjing_error = 0
						-- 			table.remove(self.qqList, 1)
						-- 			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
						-- 			goto over
						-- 		else
						-- 			goto hk
						-- 		end
					else
				-- 		table.remove(self.qqList, 1)
				-- 		writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
						goto over
					end
				else
					toast("切换下一个账号2", 1)
					mSleep(500)
					table.remove(self.qqList, 1)
					writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
					-- writeFileString(userPath().."/res/qq_loginError.txt",self.qqAcount .. "----" .. self.qqPassword,"a",1)
					-- self:getAccount()
					-- inputAgain = true
					-- goto hk
					goto over
				end
			end
		end

		if self:vpn_connection("2") then
			goto over
		end

		--动态密码
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "56|-3|0xffffff,-190|-32|0x0078ff,-192|26|0x0078ff,27|27|0x0078ff,29|-33|0x0078ff,257|-29|0x0078ff,250|20|0x0078ff,244|-121|0x0078ff,335|-127|0x0078ff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			toast("动态密码,切换下一个账号", 1)
			mSleep(500)
			table.remove(self.qqList, 1)
			writeFile(userPath() .. "/res/qq.txt", self.qqList, "w", 1)
			goto over
		end

		--密保手机号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "39|-1|0xffffff,77|2|0xffffff,-288|-26|0x0079ff,-290|31|0x0079ff,33|-31|0x0079ff,40|32|0x0079ff,370|-21|0x0079ff,370|28|0x0079ff,-132|112|0x0079ff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			toast("密保手机号")
			mSleep(500)
			goto over
		end

		--已经注册过，需要绑定手机号码
		mSleep(50)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			toast("已经注册过，需要绑定手机号码", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		if self:location("1") then
			self.subName = "注册过"
			self.updatePass = true
			toast("注册过1",1)
			mSleep(1000)
			goto sy
		end

		if self:shouye() then
			goto sy
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	t1 = ts.ms()
	while true do
		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"17|0|0x323333,9|8|0x323333,0|17|0x323333,17|17|0x323333,2|6|0xffffff,18|7|0xffffff,10|17|0xffffff,9|-1|0xffffff",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			self:click(x, y + 110)
			toast("生日", 1)
			mSleep(1000)
			break
		end

		--填写资料
		mSleep(200)
--		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",100,0,0,750,334,{orient = 2})
		if x ~= -1 then
			if not change_vpn_bool then
				self:selectVpn()
				change_vpn_bool = true
			else
				self:click(x + 300, y + 121)
				mSleep(1000)
				for var = 1, 20 do
					mSleep(50)
					keyDown("DeleteOrBackspace")
					mSleep(50)
					keyUp("DeleteOrBackspace")
					mSleep(50)
				end
				mSleep(500)
				inputStr(Nickname)
				mSleep(1000)
				toast("生日前输入昵称", 1)
				mSleep(500)
			end
		end

		if self:location("1") then
			self.subName = "注册过"
			self.updatePass = true
			toast("注册过2",1)
			mSleep(1000)
			goto sy
		end

		if self:timeOutRestart(t1) then
			goto over
		end
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
			mSleep(100)
			if getColor(85,1117) == 0xeeeef0 then
				y_top = 1046
				y_bottom = 1193
			else
				y_top = 1100
				y_bottom = 1229
			end

			if topBottom == 1 then
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, y_top, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, y_top, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, y_top, 4)
				end
			else
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, y_bottom, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, y_bottom, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, y_bottom, 4)
				end
			end

			t1 = ts.ms()
			while true do
				mSleep(200)
				if getColor(432, 732) == 0xffffff then
					if sex == "0" then
						self:click(190, 612)
					else
						self:click(550, 612)
					end
					break
				else
					self:click(431, 708)
					mSleep(500)
				end

				if self:timeOutRestart(t1) then
					goto over
				end
			end
			break
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	t1 = ts.ms()
	while true do
		--下一步
		mSleep(200)
		if getColor(470, 842) == 0x18d9f1 then
			self:click(470, 842)
			toast("下一步", 1)
			mSleep(1000)
			self.subName = "未注册过"
			self.updatePass = false
			break
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	if loginAccountWay == "1" then
		t1 = ts.ms()
		while (true) do
			--下一步
			mSleep(200)
			if getColor(470, 842) == 0x18d9f1 then
				self:click(470, 842)
				self.subName = "未注册过"
			end

			--上传本人真实照片
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xe8e8e8, "-42|-4|0xffffff,48|-10|0xffffff,6|-54|0xffffff,4|37|0xffffff,4|66|0xffffff,-4|-114|0xe8e8e8,-5|139|0xe8e8e8,-117|22|0xe8e8e8,-8|449|0xd8d8d8", 100, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
			end 

			--上传本人真实照片：带+号
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xf6f6f6, "0|-52|0x18d9f1,-62|9|0x18d9f1,-8|56|0x18d9f1,60|-6|0x18d9f1,60|43|0x18d9f1,-130|479|0xd8d8d8,138|474|0xd8d8d8", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
			end 

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "6|24|0x007aff,16|10|0x007aff,25|5|0x0a7fff,31|17|0x007aff,58|9|0x007aff,69|1|0x007aff,53|0|0x278efe", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x000000, "298|-3|0x007aff,-50|-15|0x000000,-54|-12|0x000000,255|-9|0x007aff,312|-5|0x007aff,304|-5|0x007aff,304|-11|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(407, 230)
			end

			--无照片或视频
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x999999, "39|17|0x999999,30|42|0x999999,54|19|0x999999,137|6|0x999999,237|18|0x999999,314|22|0x999999,305|144|0x999999,-104|97|0x999999,384|148|0x999999", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				toast("无照片或视频",1)
				mSleep(1000)
				goto over
			end

			mSleep(200)
			if getColor(109,91) == 0x007aff then
				self:click(162, 255)
				break
			end

			if self:vpn_connection("1") == 1 then
				goto over
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		t1 = ts.ms()
		while (true) do
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x18d9f1, "302|6|0x18d9f1,58|-4|0xffffff,96|-8|0xffffff,128|-4|0xffffff,-67|-827|0x323333,32|-830|0x323333,286|-821|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
				break
			else
				self:click(688, 1264)
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end
	end

	::sy::
	toast("判断首页",1)
	log("判断首页")
	mSleep(1000)

	t1 = ts.ms()
	while true do
		if self:shouye() then
			if changePass == "1" then
				goto get_mmId
			else
				break
			end
		end

		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x18d9f1,"121|-9|0x18d9f1,64|55|0x18d9f1,62|36|0xf6f6f6,-28|12|0xf6f6f6,164|-4|0xf6f6f6,58|328|0xd8d8d8",90,0,0,750,1334,{orient = 2})
		if x ~= -1 and y ~= -1 then
			self:click(675, 83)
			toast("上传照片1", 1)
			mSleep(1000)
		end

		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			self:click(675, 83)
			toast("上传照片2", 1)
			mSleep(1000)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "13|5|0xcdcdcd,17|5|0xcdcdcd,25|8|0xffffff,32|8|0xcdcdcd,46|8|0xcdcdcd,39|1|0xcdcdcd,-448|824|0x18d9f1,-86|815|0x18d9f1,-298|819|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			self:click(x + 20, y + 10)
			toast("上传照片3", 1)
			mSleep(1000)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("立即打卡1", 1)
			mSleep(1000)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("立即打卡2", 1)
			mSleep(1000)
		end

		--下一步
		mSleep(50)
		if getColor(113,839) == 0x18d9f1 or getColor(632,841) == 0x18d9f1 then
			self:click(470, 842)
		end

		--她们在附近 ：跳过
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "4|0|0x323333,-10|6|0x323333,15|3|0x323333,33|3|0x323333,27|-2|0x323333,36|17|0x323333", 90, 0, 0, 749, 133)
		if x ~= -1 then
			self:click(x + 20, y)
			toast("跳过", 1)
			mSleep(500)
		end

		--跳过
		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x323333,"4|10|0x323333,13|4|0x323333,17|4|0x323333,32|7|0x323333,47|7|0x323333,42|-1|0x323333,59|5|0xffffff,-20|3|0xffffff,25|27|0xffffff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			self:click(x + 20, y + 10)
			toast("跳过", 1)
			mSleep(500)
		end

		self:bindPhoneDialog()

		--有新版本
		mSleep(50)
		if getColor(265, 944) == 0x3bb3fa and getColor(491, 949) == 0x3bb3fa then
			self:click(377, 1042)
			toast("有新版本", 1)
			mSleep(500)
		end

		--绑定手机号码
		mSleep(50)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			self:click(672, 85)
			toast("绑定手机号码", 1)
			mSleep(500)
		end

		self:location("1")

		if self:vpn_connection("1") == 1 then
			goto over
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	time = 0
	t1 = ts.ms()
	while (true) do
		--更多
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x + 10, y - 10)
			self:click(x + 10, y - 10)
			toast("更多1",1)
			mSleep(500)
			break
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x + 10, y)
			self:click(x + 10, y)
			toast("更多2",1)
			mSleep(500)
			break
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("立即打卡1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			toast("立即打卡2", 1)
			mSleep(1000)
		end

		self:bindPhoneDialog()
		self:location("1")
		if self:timeOutRestart(t1) then
			goto over
		end
	end

	if searchFriend == "0" and not self.updatePass then
		toast("搜索好友流程",1)
		mSleep(500)
		t1 = ts.ms()
		while true do
			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y - 10)
				self:click(x + 10, y - 10)
				toast("更多1",1)
				mSleep(500)
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y)
				self:click(x + 10, y)
				toast("更多2",1)
				mSleep(500)
			end

			self:bindPhoneDialog()

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y - 10)
			end

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("好友",1)
				mSleep(500)
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 and y ~= -1 then
				self:click(x, y)
				toast("立即打卡1", 1)
				mSleep(1000)
			end

			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 and y ~= -1 then
				self:click(x, y)
				toast("立即打卡2", 1)
				mSleep(1000)
			end

			--输入好友账号
			mSleep(200)
			if getColor(420,  284) == 0xf3f3f3 then
				self:click(420, 284)
				mSleep(500)
				inputStr(searchAccount)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(470,  334) == 0xf3f3f3 then
				self:click(470, 334)
				mSleep(500)
				inputStr(searchAccount)
				mSleep(1000)
			end

			--搜索用户
			mSleep(200)
			if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 or getColor(584,84) == 0x8e8e93 then
				self:click(108, 179)
				toast("搜索",1)
				mSleep(500)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
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
						self:click(55, 82)
					elseif getColor(678,  131) == 0xffffff then
						mSleep(2000)
						self:click(55, 128)
					else
						mSleep(2000)
						self:click(55, 128)
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
						self:click(678, 83)
					end

					--好友
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						break
					else
						mSleep(200)
						if getColor(420,  284) == 0xf3f3f3 then
							self:click(55, 82)
						elseif getColor(470,  334) == 0xf3f3f3 then
							self:click(55, 132)
						else
							self:click(55, 132)
						end
					end

					if self:timeOutRestart(t1) then
						goto over
					end
				end
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end
	end

	if changeHeader == "0" and not self.updatePass then
		toast("换头像流程",1)
		mSleep(500)
		t1 = ts.ms()
		while true do
			self:bindPhoneDialog()

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y - 10)
				mSleep(500)
			end

			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "30|-11|0xaaaaaa,68|-15|0xaaaaaa,62|-4|0xaaaaaa,69|0|0xaaaaaa,52|0|0xaaaaaa,84|-3|0xaaaaaa,101|-3|0xaaaaaa,17|-7|0xffffff,-82|-5|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("个人资料1",1)
				mSleep(500)
			end

			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|13|0xaaaaaa,21|-1|0xffffff,31|-6|0xaaaaaa,41|-2|0xffffff,53|7|0xaaaaaa,64|2|0xaaaaaa,69|-9|0xaaaaaa,70|5|0xaaaaaa,101|3|0xaaaaaa", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("个人资料2",1)
				mSleep(500)
			end

			--下次再说
			mSleep(200)
			if getColor(255, 1031) == 0x3bb3fa and getColor(557, 1020) == 0x3bb3fa then
				self:click(370, 1131)
				toast("下次再说",1)
				mSleep(500)
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("填写你的收入1",1)
				mSleep(500)
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "55|14|0xaaaaaa,-161|-99|0x3bb3fa,173|-106|0x3bb3fa,26|-128|0x3bb3fa,12|-60|0x3bb3fa,-97|-782|0x323333,-44|-788|0x323333,11|-781|0x323333,56|-785|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("填写你的收入3",1)
				mSleep(500)
			end

			--你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("你的家乡",1)
				mSleep(500)
			end

			--立即展示
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xd5d5d5, "-304|284|0x453577,-235|284|0x453577,-414|614|0x3bb3fa,-255|582|0x3bb3fa,-251|646|0x3bb3fa,-130|620|0x3bb3fa,-312|625|0xffffff,-278|614|0xffffff,-224|619|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("立即展示",1)
				mSleep(500)
			end

			--获得新成就:好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "5|13|0xffffff,18|9|0xffffff,36|8|0xffffff,51|8|0xffffff,197|10|0x3bb3fa,25|-28|0x3bb3fa,-157|5|0x3bb3fa,23|47|0x3bb3fa,19|74|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("好的",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 100, 0, 0, 749, 333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("编辑",1)
				mSleep(500)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		t1 = ts.ms()
		while true do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x007aff, "-18|0|0x007aff,6|-2|0x007aff,35|0|0x007aff,35|-8|0x007aff,27|-15|0x007aff,-99|-147|0x000000,-95|-135|0x000000,-87|-136|0x000000,-76|-135|0x000000", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("资料审核中",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 100, 0, 0, 749, 333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("填写你的收入1",1)
				mSleep(500)
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "55|14|0xaaaaaa,-161|-99|0x3bb3fa,173|-106|0x3bb3fa,26|-128|0x3bb3fa,12|-60|0x3bb3fa,-97|-782|0x323333,-44|-788|0x323333,11|-781|0x323333,56|-785|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("填写你的收入3",1)
				mSleep(500)
			end

			--你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("你的家乡",1)
				mSleep(500)
			end

			--立即展示
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xd5d5d5, "-304|284|0x453577,-235|284|0x453577,-414|614|0x3bb3fa,-255|582|0x3bb3fa,-251|646|0x3bb3fa,-130|620|0x3bb3fa,-312|625|0xffffff,-278|614|0xffffff,-224|619|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("立即展示",1)
				mSleep(500)
			end

			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "-9|-9|0xaaaaaa,-9|10|0xaaaaaa,-9|0|0xffffff,-379|-262|0x000000,-350|-255|0x000000,-328|-253|0x000000,-309|-252|0x000000,-293|-253|0x000000,-276|-253|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(98, 326)
				toast("头像1",1)
				mSleep(500)
			end

			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x - 180, y)
				toast("头像2",1)
				mSleep(500)
			end

			--点击头像 带+号
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|35|0xaaaaaa,-18|17|0xaaaaaa,16|18|0xaaaaaa,-67|94|0xf9f9f9,70|92|0xf9f9f9,75|-50|0xf9f9f9,-66|-54|0xf9f9f9", 100, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x - 180, y)
				toast("头像3",1)
				mSleep(500)
			end

			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "5|-2|0x3bb3fa,5|-7|0x3bb3fa,5|6|0x3bb3fa,8|6|0x3bb3fa,11|6|0x3bb3fa,20|6|0x3bb3fa,27|6|0x3bb3fa,34|6|0x3bb3fa,11|-19|0xf9f9f9", 100, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x - 140, y)
				toast("头像4",1)
				mSleep(500)
			end

			--访问照片
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "-4|6|0x007aff,2|21|0x007aff,12|2|0x007aff,12|14|0x007aff,13|29|0x007aff,18|21|0x007aff,-333|-162|0x000000,-312|-161|0x000000,-188|-161|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("访问照片",1)
				mSleep(500)
			end

			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				if y > 1110 then
					self:click(x, y - 220)
				else
					self:click(x, y + 120)
				end
				toast("相册",1)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				self:click(370, 298)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(127,  309) == 0xababab and getColor(220,  384) == 0xf6f6f6 then
				self:click(370, 345)
			end

			--继续
			mSleep(200)
			if getColor(663,   86) == 0x3bb3fa and getColor(701,   88) == 0x3bb3fa or getColor(651,   83) == 0x3bb3fa and getColor(690,   77) == 0x3bb3fa then
				self:click(663, 86)
				toast("继续",1)
				mSleep(500)
			end

			--完成
			mSleep(200)
			if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
				self:click(621, 61)
				toast("完成1",1)
				mSleep(500)
				break
			end

			--完成
			mSleep(200)
			if getColor(620,   117) == 0x00c0ff and getColor(665,   114) == 0xffffff then
				self:click(665, 114)
				toast("完成2",1)
				mSleep(500)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		t1 = ts.ms()
		toast("准备保存头像",1)
		mSleep(500)
		while (true) do
			--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				self:click(621, 61)
				toast("保存1",1)
				mSleep(500)
			end

			--保存
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "-13|-11|0xffffff,15|-12|0xffffff,307|-5|0x3bb3fa,-3|34|0x3bb3fa,-323|-7|0x3bb3fa,-2|-31|0x3bb3fa,-58|-1139|0x000000,55|-1131|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
				toast("保存2",1)
				mSleep(500)
			end

			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 388, y - 650)
				toast("好的",1)
				mSleep(500)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end

		toast("保存头像完成",1)
		mSleep(500)

		t1 = ts.ms()
		while true do
			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 388, y - 650)
			end

			--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				self:click(621, 61)
			end

			--保存
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "134|-39|0x3bb3fa,135|49|0x3bb3fa,303|-2|0x3bb3fa,112|9|0xffffff,124|8|0xffffff,141|13|0xffffff,159|10|0xffffff,44|-911|0xaaaaaa,91|-927|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x, y)
			end

			--获得新成就:好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "5|13|0xffffff,18|9|0xffffff,36|8|0xffffff,51|8|0xffffff,197|10|0x3bb3fa,25|-28|0x3bb3fa,-157|5|0x3bb3fa,23|47|0x3bb3fa,19|74|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("好的",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 100, 0, 0, 749, 333)
			if x~=-1 and y~=-1 then
				self:click(55, y)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			else
				self:click(55, 84)
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end
	end

	t1 = ts.ms()
	while true do
		--更多
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x + 10, y - 10)
			self:click(x + 10, y - 10)
			toast("更多1",1)
			mSleep(500)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x565656, "40|0|0x565656,-596|30|0x0fc9e1,-584|30|0x0fc9e1,-575|28|0x0fc9e1,-564|27|0x0fc9e1,-450|-21|0x3e3e3e,-408|-20|0x3e3e3e,-117|25|0x424343", 100, 0, 747, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x + 10, y)
			self:click(x + 10, y)
			toast("更多2",1)
			mSleep(500)
		end

		mSleep(50)
		if getColor(665, 1310) == 0xf6aa00 or getColor(664,1322) == 0xecae3f and getColor(686,1317) == 0xecae3f or 
		getColor(664,1321) == 0xebad3b and getColor(670,1323) == 0xebad3b then
			self:click(693, 80)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(50)
		if getColor(664, 1253) == 0xf8aa05 or getColor(664, 1253) == 0xf6aa00 then
			self:click(696, 130)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-1|-35|0x323333,-78|-28|0x4b4c4c,-77|0|0x4b4c4c,-97|-14|0x4b4c4c,-61|-13|0x4b4c4c,-67|-13|0x4b4c4c,-41|-16|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y - 20)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "27|0|0xaaaaaa,-161|-95|0x3bb3fa,199|-91|0x3bb3fa,3|-94|0xffffff,31|-94|0xffffff,-215|-91|0xffffff,240|-91|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y - 20)
			toast("立即体验",1)
			mSleep(500)
		end

		if self:timeOutRestart(t1) then
			goto over
		end
	end

	if changePass == "0" then
		if selPassWay == "1" then
			password = self:getMMId(appDataPath(self.mm_bid) .. "/Documents") .. "w"
		end

		t1 = ts.ms()
		while true do
			--设置
			mSleep(200)
			if getColor(342, 80) == 0 and getColor(386, 79) == 0 then
				self:click(577, 209)
				toast("设置",1)
				mSleep(500)
			end

			--设置
			mSleep(200)
			if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
				self:click(577, 254)
				toast("设置",1)
				mSleep(500)
			end

			--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				toast("密码修改",1)
				mSleep(500)
			end

			--重置密码
			mSleep(200)
			if getColor(642,   87) == 0x3bb3fa and getColor(689, 87) == 0x3bb3fa then
				self:click(396, 194)
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

					if self:timeOutRestart(t1) then
						goto over
					end
				end

				mSleep(500)
				self:click(396, 279)
				while true do
					mSleep(400)
					if getColor(712, 281) == 0xcccccc then
						break
					else
						mSleep(500)
						inputStr(password)
						mSleep(1000)
					end

					if self:timeOutRestart(t1) then
						goto over
					end
				end
				mSleep(500)
				self:click(666, 81)
				mSleep(5000)
				break
			end

			if self:timeOutRestart(t1) then
				goto over
			end
		end
	end

	::get_mmId::
	self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")

	times = getNetTime()
	sj = os.date("%Y年%m月%d日%H点%M分%S秒",times)

	--重命名当前记录名
	local old_name = AMG.Get_Name()
	if loginAccountWay == "0" then
		new_name = self.mm_accountId .. "----" .. self.subName .. "----" .. self.qqAcount .. "----" .. self.qqPassword .. "----" .. password .. "----" .. sj
	elseif loginAccountWay == "1" then
		new_name = self.mm_accountId .. "----" .. self.subName .. "----" .. self.phone .. "----" .. sj

		::saveAgain::
		mSleep(500)
		bool = writeFileString(userPath().."/res/USA-phone.txt",self.mm_accountId .. "----" .. self.phone .. "----" .. self.code_token,"a",1) --将 string 内容存入文件，成功返回 true
		if bool then
			toast("保存号码到失败文件成功",1)
		else
			toast("保存号码到失败文件失败",1)
			goto saveAgain
		end
	end

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

function model:index()
	while true do
		if loginAccountWay == "0" then
			self:getAccount()
		elseif loginAccountWay == "1" then
			self:getPhoneAndToken()
		end

		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)

		-- 		changeHeader = "1"
		if changeHeader == "0" then
			-- 		if loginAccountWay == "1" then
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

		if changeVPNWay == "0" then
			self:ajs_vpn()
		end

		self:newMMApp(sysVersion, sysPhoneType, gpsAddress, editorWay)
		self:mm(password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, changePass)
	end
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
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "号码文件路径是在触动res下，文件名字是phoneNum.txt",
				["size"] = 15,
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
			},
			{
				["type"] = "Label",
				["text"] = "选择vpn切换方式",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "先切vpn再打开软件,先打开软件再切vpn",
				["select"] = "0",
				["countperline"] = "3"
			},
			{
				["type"] = "Label",
				["text"] = "选择注册方式",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "扣扣注册,美国号码注册",
				["select"] = "0",
				["countperline"] = "3"
			},
			{
				["type"] = "Label",
				["text"] = "是否需要输入两次号码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "不需要,需要",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "昵称是否需要添加特殊字符",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "不需要,需要",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择账号密码错误的执行流程",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "换号重新输入,重新运行",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择更改密码方式",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "固定,id + w",
				["select"] = "0",
				["countperline"] = "4"
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, password, sex, searchFriend, searchAccount, changeHeader, nikcNameType, sysVersion, sysPhoneType, openPingNet, gpsAddress, changePass, editorWay, changeVPNWay, loginAccountWay, inputPhoneAgain, addSpecialStr, selectWay, selPassWay = showUI(MyJsonString)
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

	self:index()
end

model:main()
