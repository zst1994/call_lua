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
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					if connect_vpn == "0" then
						model:vpn()
					end
					mSleep(200)
					tap(x,y)
					mSleep(500)
				end

				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "-35|6|0x007aff,-47|-13|0x067dff,-23|-12|0x007aff,37|-12|0x007aff,35|8|0x007aff,29|4|0x007aff,45|4|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(200)
					tap(x,y)
					mSleep(2000)
					break
				end
			end

			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(200)
					break
				else
					mSleep(200)
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
		toast("距离重启脚本还有"..(60 - os.difftime(t2, t1)) .. "秒",1)
		mSleep(1000)
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
				luaExit()
			end
		else
			dialog("号码文件没号码了", 0)
			luaExit()
		end
	else
		dialog("号码文件不存在，请检查该文件是否有误", 0)
		luaExit()
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
	if status_resp == 200 then
		if type(string.find(body_resp, "%d+%d+%d+%d+%d+%d+")) == "number" then
			-- local i, j = string.find(body_resp, "%d+%d+%d+%d+%d+%d+")
			self.mm_yzm = string.match(body_resp,"%d+%d+%d+%d+%d+%d+")
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
		toast("写入成功", 1)
	else
		toast("写入失败", 1)
		goto save
	end
	mSleep(1000)
end

function model:sameMain()
	--首页
	mSleep(50)
	if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
	getColor(411, 176) == 0x323333 and getColor(419, 135) == 0x323333 or
	getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 or
	getColor(206, 156) == 0x323333 and getColor(336, 157) == 0x323333 or
	getColor(206,  153) == 0x313232 and getColor(371,  131) == 0x313232 then
		toast("首页1", 1)
		mSleep(1000)
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
	if x ~= -1 then
		toast("首页2", 1)
		mSleep(1000)
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
	if x ~= -1 then
		toast("首页3", 1)
		mSleep(1000)
		return true
	end

	--跳过
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323333, "-3|1|0x3b3b3a,-3|-10|0x323333,10|-8|0x323333,14|-8|0x323333,28|3|0x353535,40|10|0x323333,43|0|0x323333,36|-9|0x323333", 100, 0, 0, 750, 234, { orient = 2 })
	if x ~= -1 then
		mSleep(200)
		randomTap(x,y,4)
		mSleep(500)
		toast("跳过1",1)
		mSleep(500)
		return false
	end

	mSleep(50)
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
	mSleep(50)
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
	mSleep(50)
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
	openAgain = true
	runApp(self.mm_bid)
	mSleep(1000)

	::inputPass::
	t1 = ts.ms()
	while (true) do
		if self:sameMain() then
			if openAgain then
				closeApp(self.mm_bid)
				mSleep(1000)
				openAgain = false
			else
				break
			end
		end

		--注册登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录1",1)
			mSleep(500)
		end

		--注册登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录2",1)
			mSleep(500)
		end

		--帐号密码登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "-33|5|0x18d9f1,-60|-1|0x18d9f1,-89|-1|0x18d9f1,-98|-1|0x18d9f1,24|-1|0x18d9f1,50|-2|0x18d9f1,-18|-101|0xd8d8d8,454|-106|0xd8d8d8", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(x,y,4)
			mSleep(500)
			toast("帐号密码登录",1)
			mSleep(500)
		end

		mSleep(50)
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

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while (true) do
		if self:sameMain() then
			--注册登录
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
			if x ~= -1 and y ~= -1 then
				mSleep(200)
				randomTap(x,y,4)
				mSleep(500)
				goto inputPass
			end

			--注册登录
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
			if x ~= -1 and y ~= -1 then
				mSleep(200)
				randomTap(x,y,4)
				mSleep(500)
				goto inputPass
			end
			break
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

		randomTap(333,147,4)
		mSleep(3500)

		for var= 1, 1 do
			mSleep(200)
			randomTap(74, 1227,4,"",1,20)
			randomTap(74, 1227,4,"",1,20)
			mSleep(3500)
		end

		self.subName = "刷新成功"
	else
		mSleep(1000)
	end

	if changePhone == "0" then
		back_again = 0
		bindCount = 0
		getPhoneAgain = true

		t1 = ts.ms()
		while (true) do
			--更多
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "0|36|0x323333,-5|17|0x323333,6|17|0x323333,0|17|0xffffff,-566|498|0x18d9f1,-76|501|0x21deac,-253|496|0xffc20e", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				randomTap(x, y + 20, 4)
				mSleep(1000)
				break
			else
				mSleep(200)
				randomTap(675, 1227, 4)
				mSleep(1000)
				toast("更多",1)
				mSleep(500)
			end

			self:timeOutRestart(t1)
		end

		::get_phone_agagin::
		if getPhoneAgain then
			self:getPhoneAndToken()
			getPhoneAgain = false
		end

		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x1e1e1e, "24|0|0x1e1e1e,13|-4|0x1e1e1e,13|5|0x1e1e1e,13|15|0x1e1e1e,35|19|0x1e1e1e,54|11|0x1e1e1e,39|4|0x1e1e1e,585|8|0xc7c7cc", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				randomTap(x, y + 20, 4)
				mSleep(1000)
				toast("账户与安全",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xfcfcfc, "0|-23|0xfcfcfc,1|23|0xfcfcfc,-34|-29|0xb3b3b3,40|-34|0xc0c0c0,21|26|0xb3b3b3,-26|30|0xc0c0c0,81|-9|0xffffff,-95|-7|0xffffff,-7|-201|0x000000", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				randomTap(x, y + 489, 4)
				mSleep(1000)
				toast("手机绑定",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "217|-4|0xffffff,413|-2|0x3bb3fa,-208|-4|0x3bb3fa,109|-44|0x3bb3fa,119|37|0x3bb3fa,-44|-493|0xff682c,213|-631|0xff682c,-45|-569|0xf3d339,70|-680|0xfc7ef3", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				randomTap(x, y, 4)
				mSleep(1000)
				toast("修改绑定的手机号码",1)
				mSleep(500)
				break
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "27|-2|0xffffff,41|4|0xffffff,60|-2|0xffffff,353|-3|0x3bb3fa,38|-39|0x3bb3fa,43|39|0x3bb3fa,-103|-488|0xff682c,171|-621|0xff682c,21|-680|0xfc7ef3", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(200)
				randomTap(x, y, 4)
				mSleep(1000)
				toast("绑定手机号",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x323333, "53|-15|0x323333,87|-16|0x323333,124|-16|0x323333,148|-22|0x323333,184|-22|0x323333,51|430|0xebebeb,566|431|0xebebeb,276|380|0xebebeb,249|423|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x + 30, y + 109)
				mSleep(500)
				toast("选择区号",1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x8e8e93, "44|8|0x8e8e93,537|5|0xffffff,646|1|0xc9c9ce,195|-105|0x000000,230|-88|0x000000,259|-99|0x000000,325|-99|0x000000,352|-100|0x000000,398|-111|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 100, y)
				mSleep(500)
				writePasteboard("美国")
				mSleep(500)
				keyDown("RightGUI")
				keyDown("v")
				keyUp("v")
				keyUp("RightGUI")
				mSleep(200)
				key = "ReturnOrEnter"
				keyDown(key)
				keyUp(key)
				mSleep(1000)
				tap(x + 100, y + 10)
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x323333, "51|-16|0x323333,88|-14|0x323333,148|-18|0x323333,194|-22|0x323333,64|112|0xc7c7cc,164|106|0xc7c7cc,232|107|0xc7c7cc,77|432|0xebebeb,433|427|0xebebeb", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 270, y + 100)
				mSleep(1500)
				writePasteboard(self.phone)
				mSleep(500)
				keyDown("RightGUI")
				keyDown("v")
				keyUp("v")
				keyUp("RightGUI")
				mSleep(500)
			end

			mSleep(50)
			if getColor(581,534) == 0x3bb3fa then
				mSleep(500)
				tap(588,  517)
				mSleep(1000)
				back_again = back_again + 1
				if back_again > 1 then
					break
				else
					mSleep(500)
					tap(60,   84)
					mSleep(2000)
					goto get_phone_agagin
				end
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end

		getMessStatus = self:get_mess()
		if getMessStatus then
			mSleep(200)
			if getColor(629, 1264) == 0 then
				mSleep(500)
				tap(196,519)
				mSleep(1000)
				for i = 1, #(self.mm_yzm) do
					mSleep(300)
					num = string.sub(self.mm_yzm, i, i)
					mSleep(100)
					if num == "0" then
						tap(373, 1281)
					elseif num == "1" then
						tap(132, 955)
					elseif num == "2" then
						tap(377, 944)
					elseif num == "3" then
						tap(634, 941)
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

				t1 = ts.ms()
				while (true) do
					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0xffffff, "217|-4|0xffffff,413|-2|0x3bb3fa,-208|-4|0x3bb3fa,109|-44|0x3bb3fa,119|37|0x3bb3fa,-44|-493|0xff682c,213|-631|0xff682c,-45|-569|0xf3d339,70|-680|0xfc7ef3", 100, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(200)
						toast("换绑手机号码成功",1)
						mSleep(500)
						break
					else
						mSleep(200)
						tap(370,  671)
						mSleep(500)
					end

					mSleep(50)
					if getColor(390,  630) == 0x606060 and getColor(490,  705) == 0x445660 and getColor(472,  660) == 0xf5f6f5 then
						mSleep(200)
						toast("验证码错误",1)
						mSleep(500)
						break
					end

					self:timeOutRestart(t1)
					mSleep(1000)
				end

				self:remove_phone()

				self.subName = "换绑已成功"
			end
		else
			toast("获取验证码失败，保存号码到失败文件",1)
			::saveAgain::
			mSleep(500)
			bool = writeFileString(userPath().."/res/phoneError.txt",self.phone .. "----" .. self.code_token,"a",1) --将 string 内容存入文件，成功返回 true
			if bool then
				toast("保存号码到失败文件成功",1)
			else
				toast("保存号码到失败文件失败",1)
				goto saveAgain
			end
			mSleep(1000)
			self:remove_phone()
			mSleep(500)
			tap(60,   84)
			mSleep(2000)
		end

		bindCount = bindCount + 1

		if bindCount < tonumber(bindPhoneCount) then
			back_again = 0
			getPhoneAgain = true
			goto get_phone_agagin
		end
	end

	self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")

	--重命名当前记录名
	old_name = AMG.Get_Name()

	new_name = self.mm_accountId .. "----" .. self.subName

	if AMG.Rename(old_name, new_name) == true then
		toast("重命名当前记录 " .. old_name .. " 为 " .. new_name, 3)
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
			else
				self:mm()
			end
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
			{
				["type"] = "Label",
				["text"] = "是否换绑手机号码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "换绑,不换绑",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "输入绑定手机号码次数",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入绑定手机号码次数",
				["text"] = "默认值"
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, connect_vpn, old_pass, refresh, changePhone, bindPhoneCount = showUI(MyJsonString)
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