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
model.fubiaoqian      = ""
model.subNameBool     = true

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
			self:myToast("执行中")
			goto get_amg_result
		end
	end
end

local AMG = {
	Next = (function()  --下一条
	        ::toNext::
			model:Check_AMG()
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 100, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					if model.subName ~= "密码错误" then
						model:vpn(true)
					end
					model:click(x,y)
				end

				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "-35|6|0x007aff,-47|-13|0x067dff,-23|-12|0x007aff,37|-12|0x007aff,35|8|0x007aff,29|4|0x007aff,45|4|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
				    old_re = AMG.Get_Name()
					model:click(x,y,2000)
					break
				end
			end

			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 100, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					new_re = AMG.Get_Name()
					if new_re ~= old_re then
					    model:myToast("备份切换成功")
					    return true
					else
					    model:myToast("当前备份记录与之前一样，重新切备份", 1000)
					    goto toNext
					end
				else
					model:click(58, 83, 1000)
				end
			end

-- 			return model:Check_AMG_Result()
--             ::record::
-- 			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=nextRecord");
-- 			if code == 200 then
-- 				return model:Check_AMG_Result()
-- 			else
-- 			    self:myToast("查看切换下一条结果失败，重新查看")
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
		self:myToast("删除成功")
	else
		self:myToast("删除失败")
		mSleep(1000)
		goto delete
	end
end

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

function model:vpn(start)
	::get_vpn::
	old_data = self:getNetIP() --获取IP
	if old_data then
		self:myToast(old_data)
	else
		goto get_vpn
	end

	if networkMode == "0" then
		mSleep(math.random(500, 1500))
		flag = getVPNStatus()
		if flag.active then
			self:myToast("打开状态")
			setVPNEnable(false)
			setVPNEnable(false)
			for var = 1, 10 do
				mSleep(math.random(200, 500))
				self:myToast("等待vpn切换" .. var)
				mSleep(math.random(200, 500))
			end
			goto get_vpn
		else
			self:myToast("关闭状态")
		end

		setVPNEnable(true)
		mSleep(1000 * math.random(2, 4))
	elseif networkMode == "1" then
		mSleep(math.random(500, 1500))
		setAirplaneMode(true)
		mSleep(1000 * math.random(10, 14))
		setAirplaneMode(false)
		mSleep(4000)
	end

	t1 = ts.ms()
	while true do
		new_data = self:getNetIP() --获取IP
		if new_data then
			self:myToast(new_data)
			if new_data ~= old_data then
				mSleep(1000)
				if networkMode == "0" then
					self:myToast("vpn链接成功")
				elseif networkMode == "1" then
					self:myToast("wifi链接成功")
				end
				
				if start then
					mSleep(1000)
					self:Check_AMG()
					while (true) do
						mSleep(200)
						x,y = findMultiColorInRegionFuzzy(0x000000, "44|-1|0x000000,79|0|0x000000,-25|154|0x007aff,0|155|0x007aff,17|155|0x007aff,56|161|0x007aff,-22|253|0x007aff,35|251|0x097fff,81|243|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
						if x ~= -1 then
							break
						end
					end
				end
				break
			else
				--vpn连接：需要输入帐号密码重新连接vpn
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "9|0|0x007aff,20|-10|0x007aff,43|7|0x007aff,58|6|0x007aff,307|5|0x007aff,97|-261|0x000000,112|-260|0x000000,121|-253|0x000000,158|-242|0x000000", 100, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x,y)
					self:myToast("取消")
					mSleep(500)
					openURL("prefs:root=General&path=VPN")

					while (true) do
						mSleep(200)
						x,y = findMultiColorInRegionFuzzy(0x007aff, "9|-1|0x007aff,51|2|0x077dff,288|-7|0x007aff,307|6|0x007aff,95|-239|0x000000,103|-217|0x000000,111|-239|0x000000,119|-224|0x000000,231|-232|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
						if x ~= -1 then
							self:click(x,y)
							self:myToast("取消")
						end

						mSleep(200)
						x,y = findMultiColorInRegionFuzzy(0x007aff, "-1|-12|0x007aff,-661|5|0x007aff,-650|169|0x007aff,-564|160|0x007aff,-543|164|0x007aff,-489|161|0x007aff,-473|171|0x007aff,-455|169|0x007aff,-330|-360|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
						if x ~= -1 then
							self:click(x,y)
						end

						mSleep(200)
						if getColor(691,89) == 0x007aff then
							self:click(691,89)
						end

						mSleep(200)
						x,y = findMultiColorInRegionFuzzy(0x000000, "27|0|0x000000,14|18|0x000000,3|18|0x000000,20|21|0x000000,53|15|0x000000,53|9|0x000000,42|11|0x000000,60|97|0x000000,14|108|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
						if x ~= -1 then
							self:click(x + 340, y + 10)
							writePasteboard(vpnPass)
							mSleep(200)
							keyDown("RightGUI")
							keyDown("v")
							keyUp("v")
							keyUp("RightGUI")
							mSleep(200)
							key = "ReturnOrEnter"
							keyDown(key)
							keyUp(key)
							mSleep(200)
							writePasteboard(vpnSecretKey)
							mSleep(200)
							keyDown("RightGUI")
							keyDown("v")
							keyUp("v")
							keyUp("RightGUI")
							mSleep(200)
							key = "ReturnOrEnter"
							keyDown(key)
							keyUp(key)
							break
						end
					end
					setVPNEnable(false)
					goto get_vpn
				end
			end
		end

		t2 = ts.ms()

		if os.difftime(t2, t1) > 10 then
			if networkMode == "0" then
				setVPNEnable(false)
				setVPNEnable(false)
				setVPNEnable(false)
			end
			mSleep(2000)
			self:myToast("ip地址一样，重新打开")
			mSleep(2000)
			goto get_vpn
		end
	end
end

function model:timeOutRestart(t1)
	self:vpn_connection("1")

	t2 = ts.ms()

	if os.difftime(t2, t1) > 60 then
		self:index()
	else
		self:myToast("距离重启脚本还有"..(120 - os.difftime(t2, t1)) .. "秒", 1000)
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
				self:myToast(self.phone .. "\r\n" .. self.code_token)
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
	phoneLen = #self.phone_table

	::deleteTab::
	table.remove(self.phone_table, 1)
	if #self.phone_table < phoneLen then
		self:myToast('号码删除成功')
		::save::
		bool = writeFile(userPath() .. "/res/phoneNum.txt", self.phone_table, "w", 1) --将 table 内容存入文件，成功返回 true
		if bool then
			self:myToast("写入成功")
		else
			self:myToast("写入失败")
			goto save
		end
		mSleep(1000)
	else
		self:myToast('号码删除失败')
		goto deleteTab
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
			self.mm_yzm = string.match(body_resp,"%d+")
			self:myToast(self.mm_yzm)
			mSleep(2000)
			return true
		else
			yzm_time2 = ts.ms()
			if os.difftime(yzm_time2, yzm_time1) > 65 then
				self:myToast("验证码获取失败，结束下一个")
				mSleep(3000)
				return false
			else
				self:myToast(tostring(body_resp))
				mSleep(3000)
				goto get_yzm
			end
		end
	else
		yzm_time2 = ts.ms()
		if os.difftime(yzm_time2, yzm_time1) > 65 then
			self:myToast("验证码获取失败，结束下一个:"..tostring(body_resp))
			mSleep(3000)
			return false
		else
			self:myToast(tostring(body_resp))
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
			self:myToast("陌陌id:" .. c, 1)
			mSleep(1000)
			return c
		end
	end
end

function model:clear_input()
	self:click(600,  357, 1000)
	for var=1,25 do
		mSleep(50)
		keyDown("DeleteOrBackspace")
		keyUp("DeleteOrBackspace")  
	end
	mSleep(500)
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	self:myToast("滑动")
	mSleep(math.random(500, 700))
	keepScreen(true)
	snapshot("test_3.jpg", 33, 503, 712, 892)
	ts.img.binaryzationImg(userPath() .. "/res/test_3.jpg", mns)
	mSleep(500)
	if self:file_exists(userPath() .. "/res/tmp.jpg") then
		self:myToast("正在计算")
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath() .. "/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333)
		mSleep(math.random(500, 1000))
		if type(point) == "table" and #point ~= 0 then
			x_len = point[1].x
			self:myToast(x_len)
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

function model:vpn_connection(idx)
	--vpn连接
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x1382ff, "-4|4|0x1382ff,5|10|0x1382ff,2|19|0x1382ff,12|-1|0x1382ff,17|8|0x1382ff,10|13|0x1382ff,24|13|0x1382ff,13|26|0x1382ff,17|19|0x1382ff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x,y)
		setVPNEnable(true)
		self:myToast("好",1)
		mSleep(3000)
	end

	--vpn连接: 好
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|15|0x007aff,16|-5|0x007aff,20|15|0x007aff,-56|-177|0x000000,-48|-159|0x000000,-41|-179|0x000000,40|-167|0x000000,60|-171|0x000000", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x,y)
		self:myToast("vpn连接0")
		if idx == "1" then
			self:index()
		end
	end

	--网络连接失败：知道了
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x007aff, "34|5|0x007aff,66|5|0x007aff,63|-11|0x007aff,-63|-102|0x000000,-44|-102|0x000000,3|-98|0x000000,53|-105|0x000000,49|-140|0x000000,4|-142|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x,y)
		self:myToast("知道了")
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
		self:myToast("首页1")
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
	if x ~= -1 then
		self:myToast("首页2")
		return true
	end

	--首页
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
	if x ~= -1 then
		self:myToast("首页3")
		return true
	end
end

function model:toRename()
	mSleep(50)
	if getColor(239, 629) == 0x12b7f5 and getColor(676, 258) ~= 0xffffff and getColor(600,1004) == 0xffffff then
		if getColor(655,211) == 0xffffff then
			self:myToast("你的帐号暂时无法登录，请点击这里恢复正常使用")
			self.subName = "企鹅无法登陆"
			self.subNameBool = false
			return true
		elseif getColor(422,219) == 0xffffff and getColor(412,216) == 0xffffff then
			self:myToast("网络异常")
			self.subName = "企鹅网络异常"
			self.subNameBool = false
			return true
		end
	end

	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x000000, "22|9|0x000000,35|9|0x000000,61|12|0x000000,-189|-329|0x12b7f5,310|-328|0x12b7f5,85|-253|0x000000,119|-254|0x000000,155|-251|0x000000,245|-169|0x12b7f5", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:myToast("你输入的帐号或密码不正确")
		self.subName = "企鹅密码错误"
		self.subNameBool = false
		return true
	end
	
	--此账号是第三方登录账号
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x000000, "32|-1|0x000000,105|2|0x000000,110|9|0x000000,137|-7|0x000000,136|2|0x000000,138|12|0x000000,154|-5|0x000000,170|5|0x000000,234|-38|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
    if x ~= -1 then
        --取消
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x007aff, "9|-1|0x007aff,22|-11|0x007aff,44|5|0x007aff,58|8|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:myToast("此账号是第三方登录账号")
    		self.subName = "第三方"
    		self.subNameBool = false
    		return true
        end
    end
end

function model:login_button()
	--注册登录
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
	if x ~= -1 and y ~= -1 then
		self:click(x,y)
		self:myToast("注册登录1")
		return true
	end

	--注册登录
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|2|0xffffff,90|3|0xfdffff,-99|-2|0x18d9f1,43|-41|0x18d9f1,41|37|0x18d9f1,176|-3|0x18d9f1", 90, 0, 0, 749, 1333)
	if x ~= -1 and y ~= -1 then
		self:click(x,y,4)
		self:myToast("注册登录2")
		return true
	end
end

function model:new_version()
	--有新版本
	mSleep(50)
	if getColor(265, 944) == 0x3bb3fa and getColor(491, 949) == 0x3bb3fa then
		self:click(377, 1042)
		self:myToast("有新版本")
	end
end

function model:location_model()
	--定位服务未开启
	mSleep(50)
	x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
	if x ~= -1 then
		self:click(x, y)
		self:myToast("定位服务未开启")
	end

	--定位服务未开启
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x, y)
		self:myToast("定位服务未开启2")
	end
end

function model:bind_phone_model()
	--绑定手机
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		self:myToast("绑定手机")
	end

	--绑定手机
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x ~= -1 then
		self:click(x + 10, y + 5)
		self:myToast("绑定手机2")
	end
end

function model:other_model()
	--填写你的收入
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
	if x~=-1 and y~=-1 then
		self:click(x, y)
		self:myToast("填写你的收入1")
	end

	--填写你的收入
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "55|14|0xaaaaaa,-161|-99|0x3bb3fa,173|-106|0x3bb3fa,26|-128|0x3bb3fa,12|-60|0x3bb3fa,-97|-782|0x323333,-44|-788|0x323333,11|-781|0x323333,56|-785|0x323333", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		self:click(x, y)
		self:myToast("填写你的收入3")
	end

	--你的家乡
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x~=-1 and y~=-1 then
		self:click(x, y)
		self:myToast("你的家乡")
	end

	--立即展示
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0xd5d5d5, "-304|284|0x453577,-235|284|0x453577,-414|614|0x3bb3fa,-255|582|0x3bb3fa,-251|646|0x3bb3fa,-130|620|0x3bb3fa,-312|625|0xffffff,-278|614|0xffffff,-224|619|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
	if x~=-1 and y~=-1 then
		self:click(x, y)
		self:myToast("立即展示")
	end
	
	--立即聊天
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "-12|-13|0xaaaaaa,-11|12|0xaaaaaa,12|12|0xaaaaaa,12|-11|0xaaaaaa,-12|0|0xffffff,12|1|0xffffff,-1|-12|0xffffff,-1|10|0xffffff,22|-187|0xb2b2b2", 100, 0, 0, 750, 1334, { orient = 2 })
    if x ~= -1 then
        self:click(x, y)
        self:myToast("立即聊天")
    end
end

function model:done()
	--完成
	mSleep(50)
	if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
		self:click(621,   61)
		self:myToast("完成1")
		return true
	end

	--完成
	mSleep(50)
	if getColor(620,   117) == 0x00c0ff and getColor(665,   114) == 0xffffff then
		self:click(665,   114)
		self:myToast("完成2")
		return true
	end
end

function model:mm()
	reRunApp = 0
	huakuai = false
	hk_whiteBool = true
	
	if restoreBackup == "1" then
		local old_name = AMG.Get_Name()
		data = strSplit(old_name,"----")
		if #data > 2 then
			self.qqAcount = data[3]
			self.qqPassword = data[4]
			self:myToast(self.qqAcount .. "\r\n" .. self.qqPassword)
		else
			dialog("数据没有账号密码，进行下一个",5)
			mSleep(500)
			goto over
		end
	else
	    if selectPassWay == "1" then
	        local old_name = AMG.Get_Name()
		    data = strSplit(old_name,"----")
		    if #data > 2 then
    			old_pass = data[5]
    			self:myToast(old_pass)
    		else
    			dialog("数据没有账号密码，进行下一个",5)
    			mSleep(500)
    			goto over
    		end
	    end
	end

	::reRunAppAgagin::
	runApp(self.mm_bid)
	mSleep(1000)

	::back_restore::
	if restoreBackup == "1" then
		t1 = ts.ms()
		while (true) do
		    mSleep(50)
			if self:shouye() then
				break
			end

			self:new_version()
			
			self:location_model()

			--跳过：招呼一下/分享到动态
			mSleep(50)
			if getColor(669,130) == 0xbde1f7 and getColor(702,131) == 0xbde1f7
			or getColor(669,130) == 0x3bb3fa and getColor(702,130) == 0x3bb3fa then
				self:click(669,130)
				self:myToast("跳过")
			end

			self:login_button()

			--qq图标
			mSleep(50)
			x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
			if x ~= -1 and y ~= -1 then
				self:click(x, y, math.random(3500, 5000))
			end

			mSleep(50)
			if getColor(239, 629) == 0x12b7f5 then
				if getColor(677,357) == 0xbbbbbb then
					self:clear_input()
				end

				mSleep(2000)
				writePasteboard(self.qqAcount)
				while (true) do
					mSleep(50)
					if getColor(676,  357) == 0xbbbbbb or getColor(599,354) == 0xffffff then
						self:click(447, 477)
						break
					else
						self:click(395, 357, 2000)
						mSleep(2000)
						keyDown("RightGUI")
						keyDown("v")
						keyUp("v")
						keyUp("RightGUI")
						mSleep(1000)
					end
				end

				writePasteboard(self.qqPassword)
				while (true) do
					mSleep(50)
					if getColor(677,  469) == 0xbbbbbb or getColor(163,471) == 0x000000 then
						self:click(239, 629)
						break
					else
						self:click(447, 477)
						keyDown("RightGUI")
						keyDown("v")
						keyUp("v")
						keyUp("RightGUI")
						mSleep(1000)
					end
				end
				key = "ReturnOrEnter"
				keyDown(key)
				mSleep(50)
				keyUp(key)
				mSleep(5000)
			end

			if self:toRename() then
				goto reName
			end

			--滑块白色为加载出图片
			mSleep(50)
			if getColor(83,413) == 0xefefef and getColor(691,1038) == 0xefefef then
				if hk_whiteBool then
					t3 = ts.ms()
					hk_whiteBool = false
				end

				if os.difftime(ts.ms(), t3) > 5 then
					setVPNEnable(false)
					mSleep(2000)
					self:vpn(false)
					hk_whiteBool = true
					self:myToast("滑块未加载成功")
				end
			end

			mSleep(50)
			if getColor(116, 949) == 0x007aff then
				if huakuai then
					x_lens = self:moves()
					if tonumber(x_lens) > 0 then
						mSleep(math.random(500, 700))
						moveTowards(116, 949, 10, x_len - 65)
						mSleep(500)
						self:click(370, 1024, 2000)
						break
					else
						self:click(603, 1032, math.random(3000, 6000))
					end
				else
					self:click(603, 1032, math.random(3000, 6000))
					huakuai = true
				end
			end

			flag = isFrontApp(self.mm_bid)
			if flag == 0 then
				runApp(self.mm_bid)
				mSleep(3000)
			end

			self:timeOutRestart(t1)
		end
	end

	inputAgain = false
	::input_again::
	t1 = ts.ms()
	while true do
		if self:shouye() then
			break
		end

		if self:toRename() then
			goto reName
		end
		
		--立即收听
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "332|127|0xffffff,275|913|0x323333,277|931|0x323333,295|918|0x323333,309|918|0x323333,330|919|0x323333,341|913|0x323333,352|921|0x323333,371|926|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
			self:myToast("立即收听")
        end

		--登陆过期
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|0|0x007aff,18|0|0x007aff,50|-1|0x007aff,-31|-106|0x000000,-17|-110|0x000000,-17|-96|0x000000,-6|-106|0x000000,12|-109|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y)
			self:myToast("登陆过期")
			inputAgain = true
		end

		--取消发动态
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x7f7f7f, "33|6|0x7f7f7f,258|-4|0x000000,266|1|0x000000,298|10|0x000000,326|-2|0x000000,368|-10|0x000000,570|-3|0xf3f3f3,648|0|0xf3f3f3,595|-4|0xaaaaaa", 90, 0, 0, 749, 211)
		if x ~= -1 then
			self:click(x, y)
			self:myToast("取消发动态")
		end

		if inputAgain then
			mSleep(200)
			if getColor(243,  756) == 0xd8d8d8 then
				self:click(577,  589, 1000)
				inputStr(old_pass)
				mSleep(1000)
			end

			mSleep(200)
			if getColor(246,  807) == 0x18d9f1 then
				self:click(246,  807, 2000)
				inputAgain = false
			end
		else
			mSleep(50)
			if getColor(243,  796) == 0xd8d8d8 or getColor(246,  807) == 0x18d9f1 then
				self:click(57, 133, 2000)
			end
		end

		--网络好像有问题
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "29|1|0x007aff,-122|-107|0x000000,-98|-106|0x000000,-68|-103|0x000000,-68|-119|0x000000,-33|-107|0x000000,86|-106|0x000000,104|-106|0x000000,140|-108|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x,  y, 1000)
			self:vpn(false)
			self:click(246,  807, 2000)
			self:myToast("网络好像有问题")
		end

		--验证码校验
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xafbabf, "174|-228|0x000000,173|-214|0x000000,190|-220|0x000000,190|-203|0x000000,209|-214|0x000000,225|-216|0x000000,279|-212|0x000000,312|-214|0x000000,329|-202|0x000000", 100, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:myToast("验证码校验")
			self.subName = "验证码校验"
			self.subNameBool = false
			goto reName
		end

		--帐号在其他设备上登陆
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "12|0|0x007aff,48|0|0x007aff,41|-15|0x007aff,152|-254|0x000000,162|-246|0x000000,162|-229|0x000000,194|-255|0x000000,196|-240|0x000000,91|-191|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:myToast("密码错误")
			self.subName = "密码错误"
			self.subNameBool = false
			goto reName
		end

		--密码错误
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "9|0|0x007aff,19|-10|0x007aff,43|5|0x007aff,269|6|0x007aff,356|2|0x007aff,137|-141|0x000000,182|-139|0x000000,121|-97|0x000000,147|-99|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:myToast("密码错误")
			self.subName = "密码错误"
			self.subNameBool = false
			goto reName
		end

		--用户名密码错误
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "16|0|0x007aff,46|0|0x007aff,-87|-113|0x000000,-76|-109|0x000000,-65|-109|0x000000,-41|-111|0x000000,88|-104|0x000000,109|-101|0x000000,137|-108|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:myToast("用户名密码错误")
			self.subName = "密码错误"
			self.subNameBool = false
			goto reName
		end

		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x18d9f1,"121|-9|0x18d9f1,64|55|0x18d9f1,62|36|0xf6f6f6,-28|12|0xf6f6f6,164|-4|0xf6f6f6,58|328|0xd8d8d8",90,0,0,750,1334,{orient = 2})
		if x ~= -1 and y ~= -1 then
			self:click(675,   83)
			self:myToast("上传照片1")
		end

		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			self:click(675,   83)
			self:myToast("上传照片2")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "13|5|0xcdcdcd,17|5|0xcdcdcd,25|8|0xffffff,32|8|0xcdcdcd,46|8|0xcdcdcd,39|1|0xcdcdcd,-448|824|0x18d9f1,-86|815|0x18d9f1,-298|819|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			self:click(x + 20, y + 10)
			self:myToast("上传照片3")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-12|-12|0x323333,13|-12|0x323333,-11|11|0x323333,12|12|0x323333,65|859|0x3bb3fa,595|863|0x3bb3fa,280|852|0xffffff,363|868|0xffffff,319|821|0x3bb3fa", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			self:myToast("立即打卡1")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-11|-11|0x323333,13|-12|0x323333,11|11|0x323333,57|886|0x3bb3fa,571|885|0x3bb3fa,339|846|0x3bb3fa,315|924|0x3bb3fa,280|874|0xffffff,363|891|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			self:myToast("立即打卡2")
		end

		--下一步
		mSleep(50)
		if getColor(113,839) == 0x18d9f1 or getColor(632,841) == 0x18d9f1 then
			self:click(470, 842)
		end

		--跳过
		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x323333,"4|10|0x323333,13|4|0x323333,17|4|0x323333,32|7|0x323333,47|7|0x323333,42|-1|0x323333,59|5|0xffffff,-20|3|0xffffff,25|27|0xffffff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			self:click(x + 20, y + 10)
			self:myToast("跳过")
		end

		self:bind_phone_model()

		self:new_version()

		--内测体验资格
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "17|0|0xaaaaaa,29|1|0xaaaaaa,43|4|0xaaaaaa,-58|-4|0xaaaaaa,-185|-101|0x3bb3fa,1|-135|0x3bb3fa,175|-98|0x3bb3fa,-51|-89|0xffffff,12|-95|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y)
			self:myToast("以后再说")
		end

		--跳过：招呼一下/分享到动态
		mSleep(50)
		if getColor(669,130) == 0xbde1f7 and getColor(702,131) == 0xbde1f7
		or getColor(669,130) == 0x3bb3fa and getColor(702,130) == 0x3bb3fa then
			self:click(669,130)
			self:myToast("跳过")
		end

		--跳过：招呼一下/分享到动态
		mSleep(50)
		if getColor(669,42) == 0x3bb3fa and getColor(702,43) == 0x3bb3fa then
			self:click(699,43)
			self:myToast("跳过")
		end
		
		--绑定手机号码
		mSleep(50)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			self:click(672, 85)
			self:myToast("绑定手机号码")
		end

		--新版隐身模式
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "18|-35|0x3bb3fa,27|37|0x3bb3fa,237|10|0x3bb3fa,9|0|0xffffff,34|2|0xfafdff,-89|-870|0xf1f1f1,125|-859|0xf1f1f1,187|-568|0x323333,242|-565|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y)
			self:myToast("新版隐身模式")
		end

		--跳过屏蔽通讯录
		mSleep(50)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			self:click(x, y)
			self:myToast("跳过屏蔽通讯录")
		end

		self:location_model()

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
	end

	mSleep(1000)
	t1 = ts.ms()
	while (true) do
		if self:login_button() then
			if restoreBackup == "1" then
				goto back_restore
			else
				inputAgain = true
				if reRunApp > 2 then
					closeApp(self.mm_bid)
					mSleep(2000)
					goto reRunAppAgagin
				else
					reRunApp = reRunApp + 1
					goto input_again
				end
			end
		end

		--更多
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x + 10, y - 10)
			self:click(x + 10, y - 10)
			self:myToast("更多1")
			break
		end

		--更多
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "6|0|0x323333,-6|0|0x323333,6|-6|0x5a5b5b,-127|3|0x383838,-153|2|0x323333,-274|-3|0x323333,-285|-1|0x323333,-53|-18|0xfcfcfc,-514|-25|0xfdfcfd", 90, 0, 1165, 747, 1330, { orient = 2 })
		if x ~= -1 then
			self:click(x, y)
			self:click(x, y)
			self:myToast("更多2")
			break
		end
		
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "27|0|0xaaaaaa,-161|-95|0x3bb3fa,199|-91|0x3bb3fa,3|-94|0xffffff,31|-94|0xffffff,-215|-91|0xffffff,240|-91|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y - 20)
			toast("立即体验",1)
			mSleep(500)
		end

		self:bind_phone_model()

		self:location_model()

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
	end

	if searchFriend == "0" then
		t1 = ts.ms()
		while true do
			self:bind_phone_model()

			--更多
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y - 10)
			end

			--好友
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x,y)
				self:myToast("好友")
			end

			--输入好友账号
			mSleep(50)
			if getColor(420,  284) == 0xf3f3f3 then
				self:click(420,  284, 1000)
				inputStr(searchAccount)
				mSleep(500)
			end

			--输入好友账号
			mSleep(50)
			if getColor(470,  334) == 0xf3f3f3 then
				self:click(470,  334, 1000)
				inputStr(searchAccount)
				mSleep(1000)
			end

			--搜索用户
			mSleep(50)
			if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
				self:click(108,  179)
				self:myToast("搜索")
			end

			--返回到更多页面
			mSleep(50)
			if getColor(678,   83) == 0xffffff or getColor(678,  131) == 0xffffff then
				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0xffffff then
						mSleep(1000)
						self:click(55,   82)
					elseif getColor(678,  131) == 0xffffff then
						mSleep(1000)
						self:click(55,   128)
					else
						mSleep(1000)
						self:click(55,   128)
					end

					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						break
					end
				end

				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						self:click(678,   83)
					end

					--好友
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						self:myToast("准备下一步操作")
						break
					else
						mSleep(200)
						if getColor(420,  284) == 0xf3f3f3 then
							self:click(55,   82)
						elseif getColor(470,  334) == 0xf3f3f3 then
							self:click(55,   132)
						end
					end
				end
				break
			end
			self:timeOutRestart(t1)
		end
	end

	if changeHeader == "0" then
		t1 = ts.ms()
		while true do
			self:bind_phone_model()

			--更多
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 10, y - 10, 1000)
			end

			--个人资料
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "30|-11|0xaaaaaa,68|-15|0xaaaaaa,62|-4|0xaaaaaa,69|0|0xaaaaaa,52|0|0xaaaaaa,84|-3|0xaaaaaa,101|-3|0xaaaaaa,17|-7|0xffffff,-82|-5|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x,y)
				self:myToast("个人资料1")
			end

			--个人资料
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|13|0xaaaaaa,21|-1|0xffffff,31|-6|0xaaaaaa,41|-2|0xffffff,53|7|0xaaaaaa,64|2|0xaaaaaa,69|-9|0xaaaaaa,70|5|0xaaaaaa,101|3|0xaaaaaa", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x,y)
				self:myToast("个人资料2")
			end

			--下次再说
			mSleep(50)
			if getColor(255, 1031) == 0x3bb3fa and getColor(557, 1020) == 0x3bb3fa then
				self:click(370, 1131)
				self:myToast("下次再说")
			end

			self:other_model()

			--获得新成就:好的
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "5|13|0xffffff,18|9|0xffffff,36|8|0xffffff,51|8|0xffffff,197|10|0x3bb3fa,25|-28|0x3bb3fa,-157|5|0x3bb3fa,23|47|0x3bb3fa,19|74|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				self:myToast("好的")
			end

			--编辑
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 100, 0, 0, 749, 333)
			if x~=-1 and y~=-1 then
				self:click(x, y)
				self:myToast("编辑")
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		while true do
		    mSleep(50)
		    if getColor(201,81) == 0x989898 then
		        self:click(357, 78)
		        self:myToast("关闭弹框")
		    end
	        
			--账号存在异常
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "14|62|0x3bb3fa,11|29|0xc5e8fe,31|28|0xc5e8fe,623|9|0x3bb3fa,623|57|0x3bb3fa,344|-5|0x3bb3fa,343|64|0x3bb3fa,592|-64|0x323333,624|-54|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self.subName = "异常"
				self.subNameBool = false
				goto reName
			end

			self:other_model()

			--点击头像
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "-9|-9|0xaaaaaa,-9|10|0xaaaaaa,-9|0|0xffffff,-379|-262|0x000000,-350|-255|0x000000,-328|-253|0x000000,-309|-252|0x000000,-293|-253|0x000000,-276|-253|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(98,326)
				self:myToast("头像1")
			end

			--点击头像
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x - 180,y)
				self:myToast("头像2")
			end

			--点击头像 带+号
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "0|35|0xaaaaaa,-18|17|0xaaaaaa,16|18|0xaaaaaa,-67|94|0xf9f9f9,70|92|0xf9f9f9,75|-50|0xf9f9f9,-66|-54|0xf9f9f9", 100, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x - 180,y)
				self:myToast("头像3")
			end

			--点击头像
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "5|-2|0x3bb3fa,5|-7|0x3bb3fa,5|6|0x3bb3fa,8|6|0x3bb3fa,11|6|0x3bb3fa,20|6|0x3bb3fa,27|6|0x3bb3fa,34|6|0x3bb3fa,11|-19|0xf9f9f9", 100, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x - 140,y)
				self:myToast("头像4")
			end

			--访问照片
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "-4|6|0x007aff,2|21|0x007aff,12|2|0x007aff,12|14|0x007aff,13|29|0x007aff,18|21|0x007aff,-333|-162|0x000000,-312|-161|0x000000,-188|-161|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x,y)
				self:myToast("访问照片")
			end

			--相册
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				if y > 1110 then
					self:click(x,y - 220)
				else
					self:click(x,y + 120)
				end
				self:myToast("相册")
			end

			--点击图片选择作为头像
			mSleep(50)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				self:click(370,  298)
			end

			--点击图片选择作为头像
			mSleep(50)
			if getColor(127,  309) == 0xababab and getColor(220,  384) == 0xf6f6f6 then
				self:click(370,  345)
			end

			--继续
			mSleep(50)
			if getColor(663,   86) == 0x3bb3fa and getColor(701,   88) == 0x3bb3fa or getColor(651,   83) == 0x3bb3fa and getColor(690,   77) == 0x3bb3fa then
				self:click(663,   86)
				self:myToast("继续")
			end

			if self:done() then
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		self:myToast("准备保存头像")
		while (true) do
			self:done()

			--保存
			mSleep(50)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				self:click(621,   61)
				self:myToast("保存1")
			end

			--保存
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "-13|-11|0xffffff,15|-12|0xffffff,307|-5|0x3bb3fa,-3|34|0x3bb3fa,-323|-7|0x3bb3fa,-2|-31|0x3bb3fa,-58|-1139|0x000000,55|-1131|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x,   y)
				self:myToast("保存2")
			end

			--好的
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 388,y - 650)
				self:myToast("好的")
				break
			end

			--帐号部分功能被禁用
			mSleep(50)
			if getColor(552,698) == 0x616161  and getColor(499,646) == 0xffffff then
				self:myToast("帐号部分功能被禁用")
				self.subName = "异常"
				self.subNameBool = false
				goto reName
			end

			self:timeOutRestart(t1)
		end

		self:myToast("保存头像完成")

		t1 = ts.ms()
		while true do
			--好的
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				self:click(x + 388,y - 650)
			end

			--保存
			mSleep(50)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff or getColor(612,   79) == 0x3bb3ff  and getColor(676,   79) == 0xffffff then
				self:click(621,   61)
			end

			--保存
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "134|-39|0x3bb3fa,135|49|0x3bb3fa,303|-2|0x3bb3fa,112|9|0xffffff,124|8|0xffffff,141|13|0xffffff,159|10|0xffffff,44|-911|0xaaaaaa,91|-927|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				self:click(x,   y)
			end

			--获得新成就:好的
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "5|13|0xffffff,18|9|0xffffff,36|8|0xffffff,51|8|0xffffff,197|10|0x3bb3fa,25|-28|0x3bb3fa,-157|5|0x3bb3fa,23|47|0x3bb3fa,19|74|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				self:click(x, y)
				self:myToast("好的")
			end

			--编辑
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 100, 0, 0, 749, 333)
			if x~=-1 and y~=-1 then
				self:click(55,   y)
			end

			--好友
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			else
				self:click(55,   84)
			end

			self:timeOutRestart(t1)
		end
	end

	t1 = ts.ms()
	while true do
		--更多
		mSleep(50)
		if getColor(665, 1310) == 0xf6aa00 or getColor(664,1322) == 0xecae3f and getColor(686,1317) == 0xecae3f or 
		getColor(664,1321) == 0xebad3b and getColor(670,1323) == 0xebad3b then
			self:click(693, 80)
			self:myToast("进入设置")
			break
		end

		mSleep(50)
		if getColor(664, 1253) == 0xf8aa05 or getColor(664, 1253) == 0xf6aa00 then
			self:click(696,  130)
			self:myToast("进入设置")
			break
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "-1|-35|0x323333,-78|-28|0x4b4c4c,-77|0|0x4b4c4c,-97|-14|0x4b4c4c,-61|-13|0x4b4c4c,-67|-13|0x4b4c4c,-41|-16|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x, y - 20)
			self:myToast("进入设置")
			break
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while (true) do
		--设置
		mSleep(50)  
		if getColor(342, 80) == 0 and getColor(386, 79) == 0 or getColor(342, 127) == 0 and getColor(386, 145) == 0 then
			-- 			mSleep(500)
			-- 			tap(577, 209)
			-- 			mSleep(500)
			-- 			self:myToast("设置")
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x1e1e1e, "4|0|0x1e1e1e,9|0|0x1e1e1e,14|0|0x1e1e1e,14|-11|0x1e1e1e,23|-1|0x1e1e1e,46|-1|0x1e1e1e,46|-6|0x1e1e1e,46|-12|0x1e1e1e,115|-3|0x1e1e1e", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x,y)
					break
				else
					mSleep(500)
					moveTowards(341,1031, 85, 600)
					mSleep(2000)
				end
				
				self:other_model()
			end
		end

		-- 		--设置
		-- 		mSleep(200)
		-- 		if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
		-- 			mSleep(500)
		-- 			tap(577, 254)
		-- 			mSleep(500)
		-- 			self:myToast("设置")
		-- 		end

		--退出当前帐号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "0|5|0x323333,0|9|0x323333,0|25|0x323333,28|6|0x323333,40|18|0x323333,61|4|0x323333,58|24|0x323333,165|11|0x323333,162|17|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "113|5|0x007aff,41|9|0x007aff,70|9|0x007aff,-157|10|0x1283ff,-275|0|0x007aff,-236|12|0x007aff,-110|-101|0x000000,-81|-236|0x000000,-26|-194|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x,y)
					self:myToast("手机绑定")
					break
				end

				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "12|-13|0x007aff,40|-1|0x007aff,267|0|0x007aff,279|0|0x007aff,285|1|0x007aff,307|-4|0x007aff,307|-13|0x007aff,106|-186|0x000000,206|-172|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self.subName = "账号已经绑定过手机号码"
					self.subNameBool = false
					self:myToast("账号已经绑定过手机号码")
					goto reName
				end
			end
			break
		end

		-- 		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
		-- 		if x ~= -1 and y ~= -1 then
		-- 			--手机绑定红色图标
		-- 			mSleep(500)
		-- 			x,y = findMultiColorInRegionFuzzy( 0xef7070, "-9|0|0xffffff,-14|0|0xef7070,-1|-12|0xef7070,-1|-9|0xffffff,12|1|0xef7070,9|1|0xffffff,-1|14|0xef7070,-1|12|0xffffff", 100, 0, 0, 749, 1333)
		-- 			if x ~= -1 and y ~= -1 then
		-- 				mSleep(500)
		-- 				tap(x - 100, y)
		-- 				mSleep(500)
		-- 				self:myToast("手机绑定")
		-- 				break
		-- 			else
		-- 				self.subName = "账号已经绑定过手机号码"
		-- 				self.subNameBool = false
		-- 				self:myToast("账号已经绑定过手机号码")
		-- 				goto reName
		-- 			end
		-- 		else
		-- 			mSleep(500)
		-- 			tap(55,   87)
		-- 			mSleep(500)
		-- 		end

		self:timeOutRestart(t1)
	end

	back_again = 0
	getPhoneAgain = false

	::get_phone_agagin::
	if getPhoneAgain then
		self:getPhoneAndToken()
	end

	t1 = ts.ms()
	while (true) do
		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "135|-29|0x3bb3fa,136|43|0x3bb3fa,356|-5|0x3bb3fa,85|3|0xffffff,115|8|0xffffff,198|4|0xffffff,91|-1016|0x000000,114|-1007|0x000000,200|-1009|0x000000", 90, 0, 0, 749, 1333)
		-- 		if x~=-1 and y~=-1 then
		-- 			mSleep(500)
		-- 			tap(x, y)
		-- 			mSleep(500)
		-- 			self:myToast("绑定手机号")
		-- 		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "-274|-1|0x3bb3fa,26|-37|0x3bb3fa,331|-8|0x3bb3fa,-115|-492|0xff682c,-120|-569|0xf3d339,4|-685|0xfc7ef3,137|-626|0xff682c", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			self:click(x, y)
			self:myToast("绑定手机号")
		end

		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "3|15|0xcdcdcd,11|1|0xcdcdcd,19|12|0xcdcdcd,42|-2|0xcdcdcd,-250|-25|0xf3f3f3,-251|33|0xf3f3f3,312|-24|0xf3f3f3,301|38|0xf3f3f3,-58|-385|0x000000", 90, 0, 0, 749, 1333)
		-- 		if x~=-1 and y~=-1 then
		-- 			mSleep(500)
		-- 			tap(x - 227, y - 268)
		-- 			mSleep(500)
		-- 			self:myToast("选择区号")
		-- 		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "53|-15|0x323333,87|-16|0x323333,124|-16|0x323333,148|-22|0x323333,184|-22|0x323333,51|430|0xebebeb,566|431|0xebebeb,276|380|0xebebeb,249|423|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(x + 30, y + 109)
			self:myToast("选择区号")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xeeeef0, "351|-1|0xffffff,-92|-84|0x000000,-59|-86|0x000000,-29|-85|0x000000,5|-103|0x000000,37|-95|0x000000,-96|2|0xeeeef0", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			self:click(x + 100, y)
			inputStr("美国")
			mSleep(1000)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			mSleep(1000)
			self:click(x + 100, y + 10)
			break
		end

		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy( 0xf3f3f3, "-132|-149|0x000000,-119|-158|0x000000,-112|-147|0x000000,-84|-158|0x000000,-49|-145|0x000000,-33|-150|0x000000,-8|-151|0x000000,82|-154|0x000000,122|-151|0x000000", 90, 0, 0, 749, 1333)
		-- 		if x~=-1 and y~=-1 then
		-- 			mSleep(500)
		-- 			tap(x, y)
		-- 			mSleep(500)
		-- 			inputStr("美国")
		-- 			mSleep(1000)
		-- 			key = "ReturnOrEnter"
		-- 			keyDown(key)
		-- 			keyUp(key)
		-- 			mSleep(500)
		-- 			tap(x, y + 100)
		-- 			break
		-- 		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while (true) do
		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "3|15|0xcdcdcd,11|1|0xcdcdcd,19|12|0xcdcdcd,42|-2|0xcdcdcd,-250|-25|0xf3f3f3,-251|33|0xf3f3f3,312|-24|0xf3f3f3,301|38|0xf3f3f3,-58|-385|0x000000", 90, 0, 0, 749, 1333)
		-- 		if x~=-1 and y~=-1 then
		-- 			mSleep(500)
		-- 			tap(x + 60, y - 268)
		-- 			mSleep(1000)
		-- 		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "51|-16|0x323333,88|-14|0x323333,148|-18|0x323333,194|-22|0x323333,64|112|0xc7c7cc,164|106|0xc7c7cc,232|107|0xc7c7cc,77|432|0xebebeb,433|427|0xebebeb", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			self:click(x + 270, y + 100, 1500)
			inputStr(self.phone)
			mSleep(500)
		end

		-- 		--输入号码
		-- 		mSleep(200)
		-- 		if getColor(629, 1264) == 0 then
		-- 			mSleep(500)
		-- 			inputStr(self.phone)
		-- 			mSleep(500)
		-- 		end

		-- 		mSleep(200)
		-- 		if getColor(491,  489) ~= 0xf3f3f3 then
		-- 			mSleep(500)
		-- 			tap(491,  489)
		-- 			mSleep(1000)
		-- 			tap(215,  485)
		-- 			mSleep(500)
		-- 			if inputPhoneAgain == "1" then
		-- 				back_again = back_again + 1
		-- 				if back_again > 1 then
		-- 					break
		-- 				else
		-- 					mSleep(500)
		-- 					tap(60,   84)
		-- 					mSleep(2000)
		-- 					goto get_phone_agagin
		-- 				end
		-- 			else
		-- 				break
		-- 			end
		-- 		end

		mSleep(50)
		if getColor(581,444) == 0x3bb3fa then
			self:click(588,  474, 1000)
			if inputPhoneAgain == "1" then
				back_again = back_again + 1
				if back_again > 1 then
					break
				else
					self:click(60, 84, 2000)
					goto get_phone_agagin
				end
			else
				break
			end
		end

		self:timeOutRestart(t1)
	end

	getMessStatus = self:get_mess()
	if getMessStatus then
		mSleep(200)
		if getColor(629, 1264) == 0 then
			self:click(196, 466, 1000)
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
			self:click(370,  671, 5000)
			self.subName = "绑定号码成功:" .. self.phone
			self:remove_phone()
		end
	else
		self:myToast("获取验证码失败，保存号码到失败文件")
		::saveAgain::
		bool = writeFileString(userPath().."/res/phoneError.txt",self.phone .. "----" .. self.code_token,"a",1) --将 string 内容存入文件，成功返回 true
		if bool then
			self:myToast("保存号码到失败文件成功")
		else
			self:myToast("保存号码到失败文件失败")
			goto saveAgain
		end
		mSleep(1000)
		self:remove_phone()
		self:click(60, 84, 2000)
		back_again = 0
		getPhoneAgain =true
		goto get_phone_agagin
	end

	t1 = ts.ms()
	while true do
		--提交验证码卡住了
		mSleep(50)
		if getColor(254,657) == 0xf3f3f3 and getColor(352,654) == 0xcdcdcd and getColor(226,273) == 0x000000 then
			self:click(57, 84)
			self:myToast("提交验证码卡住了返回")
		end

		--绑定手机成功退出手机绑定
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "215|-5|0xffffff,404|0|0x3bb3fa,-169|-6|0x3bb3fa,115|-38|0x3bb3fa,124|34|0x3bb3fa,110|-239|0xffffff,160|-299|0x2760ff,132|-622|0x2760ff,213|-635|0xff682c", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(66, 90)
		end

		--绑定手机成功退出手机绑定
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffffff, "213|-7|0xffffff,-118|-4|0x3bb3fa,106|34|0x3bb3fa,147|-48|0x3bb3fa,288|-2|0x3bb3fa,-2|-212|0x323333,145|-211|0x323333,191|-210|0x323333,106|-248|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(66, 90)
		end

		--退出当前帐号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x323333, "0|5|0x323333,0|9|0x323333,0|25|0x323333,28|6|0x323333,40|18|0x323333,61|4|0x323333,58|24|0x323333,165|11|0x323333,162|17|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			self:click(57, 84)
		end

		--设置
		mSleep(50)
		if getColor(342, 80) == 0 and getColor(386, 79) == 0 or getColor(342, 127) == 0 and getColor(386, 145) == 0 then
			-- 			mSleep(500)
			-- 			tap(577, 209)
			-- 			mSleep(500)
			-- 			self:myToast("设置")
			while (true) do
				mSleep(200)
				x,y = findMultiColorInRegionFuzzy(0x1e1e1e, "4|0|0x1e1e1e,9|0|0x1e1e1e,14|0|0x1e1e1e,25|-2|0x1e1e1e,46|-2|0x1e1e1e,46|4|0x1e1e1e,75|4|0x1e1e1e,85|-10|0x1e1e1e,154|12|0x1e1e1e", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					self:click(x + 300, y)
					break
				else
					mSleep(500)
					moveTo(370,350,369,973,20,70)
					mSleep(2000)
				end
			end
		end

		-- 		--设置
		-- 		mSleep(200)
		-- 		if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
		-- 			mSleep(500)
		-- 			tap(577, 254)
		-- 			mSleep(500)
		-- 			self:myToast("设置")
		-- 		end

		-- 		--退出修改绑定手机号码
		-- 		mSleep(200)
		-- 		x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "169|-29|0x3bb3fa,159|41|0x3bb3fa,393|-14|0x3bb3fa,52|6|0xffffff,123|5|0xffffff,258|2|0xffffff,106|-1011|0x000000,149|-1012|0x000000,218|-1010|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		-- 		if x ~= -1 then
		-- 			mSleep(500)
		-- 			tap(57, 84)
		-- 			mSleep(500)
		-- 		end

		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			self:click(x, y)
			self:myToast("密码修改")
		end

		--重置密码
		mSleep(50)
		if getColor(642,   87) == 0x3bb3fa and getColor(689, 87) == 0x3bb3fa then
			self:click(396, 194)
			self:myToast("重置密码")
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
			end

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

				self:timeOutRestart(t1)
			end
			self:click(666, 81, 5000)
			break
		end

		self:timeOutRestart(t1)
	end

	::reName::
	self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")
	--重命名当前记录名
	local old_name = AMG.Get_Name()
	--	if restoreBackup == "1" then
	data = strSplit(old_name,"----")
	if #data > 2 then
		newAccount = data[3]
		newPass = data[4]
		new_name = self.mm_accountId .. "----" .. self.subName .. "----" .. newAccount .. "----" .. newPass
	else
		new_name = self.mm_accountId .. "----" .. self.subName .. "----无账号密码"
	end
	--	else
	--	    new_name = self.mm_accountId .. "----" .. self.subName
	--	end


	if AMG.Rename(old_name, new_name) == true then
		if self.subNameBool then
			writeFileString(userPath().."/res/绑定手机号记录.txt", self.mm_accountId .. "----" .. self.phone .. "----" .. self.code_token,"a",1)
		end
		self.subNameBool = true
		self:myToast("重命名当前记录 " .. old_name .. " 为 " .. new_name)
	end

	::over::
end

function model:index()
	while (true) do
		closeApp(self.mm_bid, 0)
		mSleep(500)
		if self.subName ~= "密码错误" then
			setVPNEnable(false)
			mSleep(1000)
		end

		if self.subName ~= "密码错误" then
			if networkMode == "0" then
				setWifiEnable(true) 
			elseif networkMode == "1" then
				setWifiEnable(false) 
			end
		end
		mSleep(2000)

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
				self:myToast(fileName, 1)
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
			},
			{
				["type"] = "Label",
				["text"] = "选择网络方式",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "wifi,4G",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "恢复备份记录类型",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "正常,密码错误",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "设置vpn连接密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入vpn连接密码",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置vpn连接密钥",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入vpn连接密钥",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "选择原密码方式",
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

	ret, old_pass, password, searchFriend, searchAccount, changeHeader, inputPhoneAgain, networkMode, restoreBackup, vpnPass, vpnSecretKey, selectPassWay = showUI(MyJsonString)
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

	self:index()
end

model:main()
