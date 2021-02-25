--陌陌-qq号码注册绑定手机卡
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

			return model:Check_AMG_Result()
-- 			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=nextRecord");
-- 			if code == 200 then
-- 				return model:Check_AMG_Result()
-- 			end
		end),
	First = (function() --还原第一条记录
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=firstRecord");
			if code == 200 then
				return model:LCheck_AMG_Result()
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

function model:vpn()
	::get_vpn::
	old_data = getNetIP() --获取IP
	if old_data and old_data ~= "" then
		toast(old_data, 1)
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

	t1 = ts.ms()
	setVPNEnable(true)
	mSleep(1000 * math.random(2, 4))

	while true do
		new_data = getNetIP() --获取IP
		if new_data and new_data ~= "" then
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
			setVPNEnable(false)
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

	if os.difftime(t2, t1) > 120 then
		lua_restart()
	else
		toast("距离重启脚本还有"..(120 - os.difftime(t2, t1)) .. "秒",1)
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

function model:remove_phone()
	table.remove(self.phone_table, 1)

	::save::
	mSleep(500)
	bool = writeFile(userPath() .. "/res/phoneNum.txt", self.phone_table, "w", 1) --将 table 内容存入文件，成功返回 true
	if bool then
		toast("写入成功", 1)
	else
		toast("写入失败", 1)
		goto save
	end
	mSleep(1000)
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
	mSleep(500)
	if status_resp == 200 then
		local i, j = string.find(body_resp, "%d+%d+%d+%d+%d+%d+")
		if i > 0 then
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
				toast(tmp.message, 1)
				mSleep(3000)
				goto get_yzm
			end
			-- mSleep(500)
			-- if get_code_num > 2 then
			-- 	toast("验证码重新获取超过2次失败，结束下一个", 1)
			-- 	mSleep(3000)
			-- 	return false
			-- else
			-- 	yzm_time2 = ts.ms()

			-- 	if os.difftime(yzm_time2, yzm_time1) > 65 then
			-- 		mSleep(500)
			-- 		tap(491,  489)
			-- 		mSleep(1000)
			-- 		toast("重新获取验证码：" .. get_code_num, 1)
			-- 		mSleep(1000)
			-- 		get_code_num = get_code_num + 1
			-- 		goto get_yzm_restart
			-- 	end

			-- 	toast(tmp.message, 1)
			-- 	mSleep(3000)
			-- 	goto get_yzm
			-- end
		end
	else
		yzm_time2 = ts.ms()
		if os.difftime(yzm_time2, yzm_time1) > 65 then
			toast("验证码获取失败，结束下一个"..tostring(body_resp), 1)
			mSleep(3000)
			return false
		else
			toast(tostring(body_resp), 1)
			mSleep(3000)
			goto get_yzm
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

function model:mm()
	runApp(self.mm_bid)
	mSleep(1000)
	t1 = ts.ms()

	inputAgain = false
	::input_again::
	while true do
		--首页
		mSleep(200)
		if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
		getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 then
			mSleep(500)
			toast("首页1", 1)
			mSleep(1000)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页2", 1)
			mSleep(1000)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页3", 1)
			mSleep(1000)
			break
		end

		--登陆过期
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|0|0x007aff,18|0|0x007aff,50|-1|0x007aff,-31|-106|0x000000,-17|-110|0x000000,-17|-96|0x000000,-6|-106|0x000000,12|-109|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("登陆过期", 1)
			mSleep(500)
			inputAgain = true
		end

		if inputAgain then
			mSleep(200)
			if getColor(243,  796) == 0xd8d8d8 then
				mSleep(500)
				tap(577,  629)
				mSleep(1000)
				inputStr(old_pass)
				mSleep(1000)
			end

			mSleep(200)
			if getColor(246,  807) == 0x18d9f1 then
				mSleep(500)
				tap(246,  807)
				mSleep(2000)
				inputAgain = false
			end
		end

		--网络好像有问题
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "29|1|0x007aff,-122|-107|0x000000,-98|-106|0x000000,-68|-103|0x000000,-68|-119|0x000000,-33|-107|0x000000,86|-106|0x000000,104|-106|0x000000,140|-108|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x,  y)
			mSleep(1000)
			self:vpn()
			mSleep(500)
			tap(246,  807)
			mSleep(2000)
			toast("网络好像有问题", 1)
		end
		
		--验证码校验
		mSleep(200)
        x,y = findMultiColorInRegionFuzzy(0xafbabf, "174|-228|0x000000,173|-214|0x000000,190|-220|0x000000,190|-203|0x000000,209|-214|0x000000,225|-216|0x000000,279|-212|0x000000,312|-214|0x000000,329|-202|0x000000", 100, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			toast("验证码校验", 1)
			mSleep(1000)
			self.subName = "验证码校验"
			self.subNameBool = false
			goto reName
		end
		
		--密码错误
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "8|0|0x007aff,18|-8|0x007aff,42|7|0x007aff,57|7|0x007aff,281|-9|0x007aff,356|10|0x007aff,116|-96|0x000000,153|-104|0x000000,327|-95|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			toast("密码错误", 1)
			mSleep(1000)
			self.subName = "密码错误"
			self.subNameBool = false
			goto reName
		end

		--用户名密码错误
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "16|0|0x007aff,46|0|0x007aff,-87|-113|0x000000,-76|-109|0x000000,-65|-109|0x000000,-41|-111|0x000000,88|-104|0x000000,109|-101|0x000000,137|-108|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			toast("用户名密码错误", 1)
			mSleep(1000)
			self.subName = "密码错误"
			self.subNameBool = false
			goto reName
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x18d9f1,"121|-9|0x18d9f1,64|55|0x18d9f1,62|36|0xf6f6f6,-28|12|0xf6f6f6,164|-4|0xf6f6f6,58|328|0xd8d8d8",90,0,0,750,1334,{orient = 2})
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			tap(675,   83)
			mSleep(math.random(500, 700))
			toast("上传照片1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			tap(675,   83)
			mSleep(math.random(500, 700))
			toast("上传照片2", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "13|5|0xcdcdcd,17|5|0xcdcdcd,25|8|0xffffff,32|8|0xcdcdcd,46|8|0xcdcdcd,39|1|0xcdcdcd,-448|824|0x18d9f1,-86|815|0x18d9f1,-298|819|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			tap(x + 20, y + 10)
			mSleep(math.random(500, 700))
			toast("上传照片3", 1)
			mSleep(1000)
		end

		--下一步
		mSleep(400)
		if getColor(113,839) == 0x18d9f1 or getColor(632,841) == 0x18d9f1 then
			mSleep(500)
			tap(470, 842)
			mSleep(500)
		end

		--跳过
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"4|10|0x323333,13|4|0x323333,17|4|0x323333,32|7|0x323333,47|7|0x323333,42|-1|0x323333,59|5|0xffffff,-20|3|0xffffff,25|27|0xffffff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			tap(x + 20, y + 10)
			mSleep(500)
			toast("跳过", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x + 10, y + 5)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end

		--有新版本
		mSleep(200)
		if getColor(265, 944) == 0x3bb3fa and getColor(491, 949) == 0x3bb3fa then
			mSleep(500)
			tap(377, 1042)
			mSleep(500)
			toast("有新版本", 1)
			mSleep(500)
		end

		--内测体验资格
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "17|0|0xaaaaaa,29|1|0xaaaaaa,43|4|0xaaaaaa,-58|-4|0xaaaaaa,-185|-101|0x3bb3fa,1|-135|0x3bb3fa,175|-98|0x3bb3fa,-51|-89|0xffffff,12|-95|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("以后再说", 1)
			mSleep(500)
		end

		--招呼一下
		mSleep(200)
		if getColor(669,130) == 0xbde1f7 and getColor(702,131) == 0xbde1f7 then
			mSleep(500)
			tap(669,130)
			mSleep(500)
			toast("跳过招呼一下", 1)
			mSleep(500)
		end

		--绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			tap(672, 85)
			mSleep(500)
			toast("绑定手机号码", 1)
			mSleep(500)
		end

		--新版隐身模式
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "18|-35|0x3bb3fa,27|37|0x3bb3fa,237|10|0x3bb3fa,9|0|0xffffff,34|2|0xfafdff,-89|-870|0xf1f1f1,125|-859|0xf1f1f1,187|-568|0x323333,242|-565|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("新版隐身模式", 1)
			mSleep(500)
		end

		--跳过屏蔽通讯录
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
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
	while (true) do
		--注册登录
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			toast("注册登录1",1)
			mSleep(500)
			inputAgain = true
			goto input_again
		end

		--注册登录
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			toast("注册登录2",1)
			mSleep(500)
			inputAgain = true
			goto input_again
		end

		--更多
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 10, y - 10)
			mSleep(1000)
			tap(x + 10, y - 10)
			mSleep(500)
			toast("更多",1)
			mSleep(500)
			break
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x + 10, y + 5)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
		end
		
		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end
		
		self:timeOutRestart(t1)
		mSleep(1000)
	end

	if searchFriend == "0" then
		t1 = ts.ms()
		while true do
			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("绑定手机", 1)
				mSleep(500)
			end

			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x + 10, y + 5)
				mSleep(500)
				toast("绑定手机2", 1)
				mSleep(500)
			end

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 10, y - 10)
				mSleep(1000)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y)
				mSleep(500)
				toast("好友",1)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(420,  284) == 0xf3f3f3 then
				mSleep(500)
				tap(420,  284)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(470,  334) == 0xf3f3f3 then
				mSleep(500)
				tap(470,  334)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(1000)
			end

			--搜索用户
			mSleep(200)
			if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
				mSleep(500)
				tap(108,  179)
				mSleep(500)
				toast("搜索",1)
				mSleep(500)
			end

			--返回到更多页面
			mSleep(200)
			if getColor(678,   83) == 0xffffff or getColor(678,  131) == 0xffffff then
				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0xffffff then
						mSleep(2000)
						tap(55,   82)
						mSleep(500)
					elseif getColor(678,  131) == 0xffffff then
						mSleep(2000)
						tap(55,   128)
						mSleep(500)
					else
						mSleep(2000)
						tap(55,   128)
						mSleep(500)
					end

					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						break
					end
				end

				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						tap(678,   83)
						mSleep(500)
					end

					--好友
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						toast("准备下一步操作",1)
						mSleep(1000)
						break
					else
						mSleep(200)
						if getColor(420,  284) == 0xf3f3f3 then
							mSleep(500)
							tap(55,   82)
							mSleep(500)
						elseif getColor(470,  334) == 0xf3f3f3 then
							mSleep(500)
							tap(55,   132)
							mSleep(500)
						end
					end
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
			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("绑定手机", 1)
				mSleep(500)
			end

			--绑定手机
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x + 10, y + 5)
				mSleep(500)
				toast("绑定手机2", 1)
				mSleep(500)
			end

			--更多
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 10, y - 10)
				mSleep(1000)
			end

			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "30|-11|0xaaaaaa,68|-15|0xaaaaaa,62|-4|0xaaaaaa,69|0|0xaaaaaa,52|0|0xaaaaaa,84|-3|0xaaaaaa,101|-3|0xaaaaaa,17|-7|0xffffff,-82|-5|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y)
				mSleep(500)
				toast("个人资料1",1)
				mSleep(500)
			end

			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|13|0xaaaaaa,21|-1|0xffffff,31|-6|0xaaaaaa,41|-2|0xffffff,53|7|0xaaaaaa,64|2|0xaaaaaa,69|-9|0xaaaaaa,70|5|0xaaaaaa,101|3|0xaaaaaa", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y)
				mSleep(500)
				toast("个人资料2",1)
				mSleep(500)
			end

			--下次再说
			mSleep(200)
			if getColor(255, 1031) == 0x3bb3fa and getColor(557, 1020) == 0x3bb3fa then
				mSleep(500)
				tap(370, 1131)
				mSleep(500)
				toast("下次再说",1)
				mSleep(500)
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入",1)
				mSleep(500)
			end

			--你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("你的家乡",1)
				mSleep(500)
			end

			--立即展示
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xd5d5d5, "-304|284|0x453577,-235|284|0x453577,-414|614|0x3bb3fa,-255|582|0x3bb3fa,-251|646|0x3bb3fa,-130|620|0x3bb3fa,-312|625|0xffffff,-278|614|0xffffff,-224|619|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("立即展示",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
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
			--账号存在异常
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "14|62|0x3bb3fa,11|29|0xc5e8fe,31|28|0xc5e8fe,623|9|0x3bb3fa,623|57|0x3bb3fa,344|-5|0x3bb3fa,343|64|0x3bb3fa,592|-64|0x323333,624|-54|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self.subName = "异常"
				self.subNameBool = false
				goto reName
			end

			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入",1)
				mSleep(500)
			end

			--你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("你的家乡",1)
				mSleep(500)
			end

			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "-9|-9|0xaaaaaa,-9|10|0xaaaaaa,-9|0|0xffffff,-379|-262|0x000000,-350|-255|0x000000,-328|-253|0x000000,-309|-252|0x000000,-293|-253|0x000000,-276|-253|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(98,326)
				mSleep(500)
				toast("头像1",1)
				mSleep(500)
			end

			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x - 180,y)
				mSleep(500)
				toast("头像2",1)
				mSleep(500)
			end

			--点击头像 带+号
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|35|0xaaaaaa,-18|17|0xaaaaaa,16|18|0xaaaaaa,-67|94|0xf9f9f9,70|92|0xf9f9f9,75|-50|0xf9f9f9,-66|-54|0xf9f9f9", 100, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x - 180,y)
				mSleep(500)
				toast("头像3",1)
				mSleep(500)
			end

			--访问照片
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "-4|6|0x007aff,2|21|0x007aff,12|2|0x007aff,12|14|0x007aff,13|29|0x007aff,18|21|0x007aff,-333|-162|0x000000,-312|-161|0x000000,-188|-161|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y)
				mSleep(500)
				toast("访问照片",1)
				mSleep(500)
			end

			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x,y + 120)
				mSleep(500)
				toast("相册",1)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				mSleep(500)
				tap(370,  298)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(127,  309) == 0xababab and getColor(220,  384) == 0xf6f6f6 then
				mSleep(500)
				tap(370,  345)
				mSleep(500)
			end

			--继续
			mSleep(200)
			if getColor(663,   86) == 0x3bb3fa and getColor(701,   88) == 0x3bb3fa or getColor(651,   83) == 0x3bb3fa and getColor(690,   77) == 0x3bb3fa then
				mSleep(500)
				tap(663,   86)
				mSleep(500)
				toast("继续",1)
				mSleep(500)
			end

			--完成
			mSleep(200)
			if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
				mSleep(500)
				tap(621,   61)
				mSleep(500)
				toast("完成1",1)
				mSleep(500)
				break
			end

			--完成
			mSleep(200)
			if getColor(620,   117) == 0x00c0ff and getColor(665,   114) == 0xffffff then
				mSleep(500)
				tap(665,   114)
				mSleep(500)
				toast("完成2",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
			mSleep(1000)
		end

		t1 = ts.ms()
		while (true) do
			--保存
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				mSleep(500)
				tap(621,   61)
				mSleep(500)
				toast("保存1",1)
				mSleep(500)
			end

			--保存
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "134|-39|0x3bb3fa,135|49|0x3bb3fa,303|-2|0x3bb3fa,112|9|0xffffff,124|8|0xffffff,141|13|0xffffff,159|10|0xffffff,44|-911|0xaaaaaa,91|-927|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x,   y)
				mSleep(500)
				toast("保存2",1)
				mSleep(500)
			end

			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 388,y - 650)
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
			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x + 388,y - 650)
				mSleep(500)
			end

			--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				mSleep(500)
				tap(621,   61)
				mSleep(500)
			end

			--保存
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "134|-39|0x3bb3fa,135|49|0x3bb3fa,303|-2|0x3bb3fa,112|9|0xffffff,124|8|0xffffff,141|13|0xffffff,159|10|0xffffff,44|-911|0xaaaaaa,91|-927|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(500)
				tap(x,   y)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(55,   y)
				mSleep(500)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			else
				mSleep(500)
				tap(55,   84)
				mSleep(500)
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
			tap(693, 80)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(200)
		if getColor(664, 1253) == 0xf8aa05 or getColor(664, 1253) == 0xf6aa00 then
			mSleep(500)
			tap(696,  130)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	t1 = ts.ms()
	while (true) do
		--设置
		mSleep(200)
		if getColor(342, 80) == 0 and getColor(386, 79) == 0 then
			mSleep(500)
			tap(577, 209)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--设置
		mSleep(200)
		if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
			mSleep(500)
			tap(577, 254)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			--手机绑定红色图标
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xef7070, "-9|0|0xffffff,-14|0|0xef7070,-1|-12|0xef7070,-1|-9|0xffffff,12|1|0xef7070,9|1|0xffffff,-1|14|0xef7070,-1|12|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x - 100, y)
				mSleep(500)
				toast("手机绑定",1)
				mSleep(500)
				break
			else
				self.subName = "账号已经绑定过手机号码"
				self.subNameBool = false
				toast("账号已经绑定过手机号码",1)
				mSleep(500)
				goto reName
			end
		else
			mSleep(500)
			tap(55,   87)
			mSleep(500)
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	back_again = 0
	getPhoneAgain = false

	::get_phone_agagin::
	if getPhoneAgain then
		self:getPhoneAndToken()
	end

	t1 = ts.ms()
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "135|-29|0x3bb3fa,136|43|0x3bb3fa,356|-5|0x3bb3fa,85|3|0xffffff,115|8|0xffffff,198|4|0xffffff,91|-1016|0x000000,114|-1007|0x000000,200|-1009|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("绑定手机号",1)
			mSleep(500)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "3|15|0xcdcdcd,11|1|0xcdcdcd,19|12|0xcdcdcd,42|-2|0xcdcdcd,-250|-25|0xf3f3f3,-251|33|0xf3f3f3,312|-24|0xf3f3f3,301|38|0xf3f3f3,-58|-385|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x - 227, y - 268)
			mSleep(500)
			toast("选择区号",1)
			mSleep(500)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xf3f3f3, "-132|-149|0x000000,-119|-158|0x000000,-112|-147|0x000000,-84|-158|0x000000,-49|-145|0x000000,-33|-150|0x000000,-8|-151|0x000000,82|-154|0x000000,122|-151|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			inputStr("美国")
			mSleep(1000)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			mSleep(500)
			tap(x, y + 100)
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	t1 = ts.ms()
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "3|15|0xcdcdcd,11|1|0xcdcdcd,19|12|0xcdcdcd,42|-2|0xcdcdcd,-250|-25|0xf3f3f3,-251|33|0xf3f3f3,312|-24|0xf3f3f3,301|38|0xf3f3f3,-58|-385|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 60, y - 268)
			mSleep(1000)
		end

		--输入号码
		mSleep(200)
		if getColor(629, 1264) == 0 then
			mSleep(500)
			inputStr(self.phone)
			mSleep(500)
		end

		mSleep(200)
		if getColor(491,  489) ~= 0xf3f3f3 then
			mSleep(500)
			tap(491,  489)
			mSleep(1000)
			tap(215,  485)
			mSleep(500)
			if inputPhoneAgain == "1" then
				back_again = back_again + 1
				if back_again > 1 then
					break
				else
					mSleep(500)
					tap(60,   84)
					mSleep(2000)
					goto get_phone_agagin
				end
			else
				break
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
			mSleep(1000)
			tap(370,  661)
			mSleep(5000)
			self.subName = "绑定号码成功=="..self.phone
			self:remove_phone()
		end
	else
		toast("获取验证码失败，保存号码到失败文件",1)
		::saveAgain::
		mSleep(500)
		bool = writeFileString(userPath().."/res/phoneError.txt",self.phone,"a",1) --将 string 内容存入文件，成功返回 true
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
		back_again = 0
		getPhoneAgain =true
		goto get_phone_agagin
	end

	t1 = ts.ms()
	while true do
		--设置
		mSleep(200)
		if getColor(342, 80) == 0 and getColor(386, 79) == 0 then
			mSleep(500)
			tap(577, 209)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--设置
		mSleep(200)
		if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
			mSleep(500)
			tap(577, 254)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--退出修改绑定手机号码
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "169|-29|0x3bb3fa,159|41|0x3bb3fa,393|-14|0x3bb3fa,52|6|0xffffff,123|5|0xffffff,258|2|0xffffff,106|-1011|0x000000,149|-1012|0x000000,218|-1010|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(57, 84)
			mSleep(500)
		end

		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			toast("密码修改",1)
			mSleep(500)
		end

		--重置密码
		mSleep(200)
		if getColor(642,   87) == 0x3bb3fa and getColor(689, 87) == 0x3bb3fa then
			mSleep(500)
			tap(396, 194)
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
			tap(396, 279)
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
			tap(666, 81)
			mSleep(5000)
			break
		end

		self:timeOutRestart(t1)
		mSleep(1000)
	end

	::reName::
	--重命名当前记录名
	local old_name = AMG.Get_Name()
	local new_name = old_name .. "----" .. self.subName
	toast(new_name,1)
	mSleep(1000)
	if AMG.Rename(old_name, new_name) == true then
	    if self.subNameBool then
    		self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")
    		writeFileString(userPath().."/res/绑定手机号记录.txt", self.mm_accountId .. "----" .. self.phone .. "----" .. self.code_token,"a",1)
    		toast("重命名当前记录 " .. old_name .. " 为 " .. new_name, 3)
	    end
	    self.subNameBool = true
	end

	::over::
end

function model:main()
	local w, h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 50,
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
				["text"] = "设置原密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入原密码",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置新密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入新密码",
				["text"] = "默认值"
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
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, old_pass, password, searchFriend, searchAccount, changeHeader, inputPhoneAgain = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if old_pass == "" or old_pass == "默认值" then
		dialog("密码不能为空，请重新运行脚本设置密码", 3)
		luaExit()
	end

	if password == "" or password == "默认值" then
		dialog("密码不能为空，请重新运行脚本设置密码", 3)
		luaExit()
	end

	if searchFriend == "0" then
		if searchAccount == "" or searchAccount == "默认值" then
			dialog("搜索好友用户名不能为空，请重新运行脚本设置搜索好友用户名", 3)
			luaExit()
		end
	end

	while (true) do
		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)

		self:vpn()

		--下一条并检查是否最后一条
		if AMG.Next() == true then
			if AMG.Get_Name() == "原始机器" then
				dialog("最后一条数据了", 0)
				lua_exit()
			end

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

			self:getPhoneAndToken()
			self:mm()
		end
	end
end

model:main()
