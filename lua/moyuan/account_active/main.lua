--陌陌-账号活跃
require "TSLib"
local ts              = require("ts")
local json            = ts.json
local sz              = require("sz") --登陆
local http            = require("szocket.http")

local model           = {}

model.awz_bid         = "com.superdev.AMG"
model.mm_bid          = "com.wemomo.momoappdemo1"

model.qqAcount        = ""
model.qqPassword      = ""

model.phone_table     = {}
model.phone           = ""
model.code_token      = ""
model.mm_yzm          = ""

model.mm_accountId    = ""
model.subName         = ""
model.fubiaoqian      = ""
model.subNameBool     = true

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

--检查AMG是否在前台
function model:Check_AMG()
	if isFrontApp(self.awz_bid) == 0 then
		runApp(self.awz_bid)
		mSleep(3000)
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
	Next = (function()  --下一条
			model:Check_AMG()
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					if connect_vpn == "0" then
						model:vpn()
					end
					mSleep(500)
					tap(x,y)
					mSleep(500)
				end

				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "-35|6|0x007aff,-47|-13|0x067dff,-23|-12|0x007aff,37|-12|0x007aff,35|8|0x007aff,29|4|0x007aff,45|4|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(500)
					tap(x,y)
					mSleep(2000)
					break
				end
			end

			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(500)
					break
				else
					mSleep(500)
					tap(58,83)
					mSleep(500)
				end
			end
			return true

-- 			return model:Check_AMG_Result()
--             ::record::
-- 			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=nextRecord");
-- 			if code == 200 then
-- 				return model:Check_AMG_Result()
-- 			else
-- 			    toast("查看切换下一条结果失败，重新查看",1)
-- 			    mSleep(2000)
-- 			    goto record
-- 			end
		end),
	First = (function() --还原第一条记录
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=firstRecord");
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
		end)
}

function model:getNetIP()
	::ip_addresss::
	local sz = require("sz");
	local http = require("szocket.http")
	local res, code = http.request("http://myip.ipip.net/")
	if code == 200 then
		if type(string.match(res,"%d+.%d+.%d+.%d+")) == "string" then
			return string.match(res,"%d+.%d+.%d+.%d+")
		else
			return false
		end
	else
		return false
	end
end

function model:vpn()
	::get_vpn::
	old_data = self:getNetIP() --获取IP
	if old_data then
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
		for var = 1, 10 do
			mSleep(math.random(200, 500))
			toast("等待vpn切换" .. var, 1)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("关闭状态", 1)
	end

	setVPNEnable(true)
	mSleep(1000 * math.random(2, 4))


	t1 = ts.ms()
	while true do
		new_data = self:getNetIP() --获取IP
		if new_data then
			toast(new_data, 1)
			if new_data ~= old_data then
				mSleep(1000)
				toast("vpn链接成功")
				mSleep(1000)
				break
			end
		end

		t2 = ts.ms()

		if os.difftime(t2, t1) > 10 then
			setVPNEnable(false)
			mSleep(2000)
			toast("ip地址一样，重新打开", 1)
			mSleep(2000)
			goto get_vpn
		end
	end
end

function model:timeOutRestart(t1)
	t2 = ts.ms()

	if os.difftime(t2, t1) > 60 then
		self:index()
	else
		toast("距离重启脚本还有"..(120 - os.difftime(t2, t1)) .. "秒",1)
		mSleep(1000)
	end
end

function model:sameMain()
	--首页
	mSleep(200)
	if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
	getColor(411, 176) == 0x323333 and getColor(419, 135) == 0x323333 or
	getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 or
	getColor(206, 156) == 0x323333 and getColor(336, 157) == 0x323333 or
	getColor(206,  153) == 0x313232 and getColor(371,  131) == 0x313232 then
		toast("首页1", 1)
		mSleep(500)
		return true
	end

	--首页
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
	if x ~= -1 then
		toast("首页2", 1)
		mSleep(1000)
		return true
	end

	--首页
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
	if x ~= -1 then
		toast("首页3", 1)
		mSleep(1000)
		return true
	end

	--跳过
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy(0x323333, "-3|1|0x3b3b3a,-3|-10|0x323333,10|-8|0x323333,14|-8|0x323333,28|3|0x353535,40|10|0x323333,43|0|0x323333,36|-9|0x323333", 100, 0, 0, 750, 234, { orient = 2 })
	if x ~= -1 then
		mSleep(200)
		randomTap(x,y,4)
		mSleep(500)
		toast("跳过1",1)
		mSleep(500)
		return false
	end
	
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy( 0x323333, "-3|1|0x3c3c3c,-3|-10|0x323333,10|-9|0x323333,14|-8|0x323333,28|0|0x353636,41|9|0x323333,43|-3|0x323333,36|-10|0x323333", 90, 0, 0, 749, 233)
	if x ~= -1 then
		mSleep(200)
		randomTap(x,y,4)
		mSleep(500)
		toast("跳过2",1)
		mSleep(500)
		return false
	end

	--绑定手机
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy( 0x323333, "-199|53|0x323333,-210|53|0x323333,-251|53|0x323333,-294|56|0x323333,-329|56|0x323333,-338|56|0x323333,-423|574|0x4ebbfb,-119|572|0x4ebbfb,-74|391|0xebebeb", 100, 0, 0, 749, 1333)
	if x ~= -1 and y ~= -1 then
		mSleep(200)
		randomTap(x,y,4)
		mSleep(500)
		toast("绑定手机",1)
		mSleep(500)
		return false
	end

	--打个卡
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "5|14|0xffffff,19|11|0xffffff,40|11|0xffffff,59|6|0xffffff,340|2|0x3bb3fa,-226|9|0x3bb3fa,51|-33|0x3bb3fa,52|45|0x3bb3fa,362|-639|0x979797", 90, 0, 0, 749, 1333)
	if x ~= -1 and y ~= -1 then
		mSleep(200)
		randomTap(697, 551, 4)
		mSleep(500)
		toast("打个卡",1)
		mSleep(500)
		return false
	end
end

function model:mm()
	runApp(self.mm_bid)
	mSleep(1000)

	::inputPass::
	t1 = ts.ms()
	while (true) do
		if self:sameMain() then
			break
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录1",1)
			mSleep(500)
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录2",1)
			mSleep(500)
		end

		--帐号密码登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "-33|5|0x18d9f1,-60|-1|0x18d9f1,-89|-1|0x18d9f1,-98|-1|0x18d9f1,24|-1|0x18d9f1,50|-2|0x18d9f1,-18|-101|0xd8d8d8,454|-106|0xd8d8d8", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("帐号密码登录",1)
			mSleep(500)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "34|4|0x18d9f1,57|3|0x18d9f1,-124|-501|0x323333,-96|-506|0x323333,-64|-507|0x323333,-17|-506|0x323333,33|-506|0x323333,47|-106|0xd8d8d8,350|-95|0xd8d8d8", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x + 110,y - 280,4)
			mSleep(500)
			writePasteboard(old_pass)
			mSleep(500)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(500)
			randomTap(288,  805,4)
			mSleep(500)
			break
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while (true) do
		if self:sameMain() then
			break
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			goto inputPass
		end

		--注册登录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			goto inputPass
		end

		self:timeOutRestart(t1)
	end

	if refresh == "0" then
		for var= 1, 3 do
			mSleep(200)
			randomTap(74, 1227,4,"",1,20)
			randomTap(74, 1227,4,"",1,20)
			mSleep(3500)
		end

		--重命名当前记录名
		local old_name = AMG.Get_Name()

		new_name = old_name .. "----刷新成功"

		toast(new_name,1)
		if AMG.Rename(old_name, new_name) == true then
			toast("重命名当前记录 " .. old_name .. " 为 " .. new_name, 3)
		end
	else
		mSleep(1000)
	end
end

function model:index()
	while (true) do
		mSleep(500)
		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		mSleep(500)

		--下一条并检查是否最后一条
		if AMG.Next() == true then
			if AMG.Get_Name() == "原始机器" then
				dialog("最后一条数据了", 0)
				luaExit()
			end

			self:mm()
		end
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
				["text"] = "是否需要连接vpn",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "连接,不连接",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "输入账号密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入账号密码",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "是否执行刷新操作",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "刷新,不刷新",
				["select"] = "0",
				["countperline"] = "4"
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, connect_vpn, old_pass, refresh = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if old_pass == "" or old_pass == "默认值" then
		dialog("密码不能为空，请重新运行脚本设置密码", 3)
		luaExit()
	end

	self:index()
end

model:main()