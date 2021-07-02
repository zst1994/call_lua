require("TSLib")
local ts 				= require('ts')
local json 				= ts.json
local ts_enterprise_lib = require("ts_enterprise_lib")

local model 			= {}

model.wc_bid 			= ""
model.awz_bid 			= ""
model.awz_url 			= ""

model.idCard_user 		= ""
model.idCard_numCode 	= ""

model.pushCategory 		= ""
model.pushData       	= ""

function model:myToast(str,ms)
	toast(str,1)
	mSleep(ms and ms or math.random(500, 600))
end

function model:clear_App()
	closeApp(self.wc_bid)
	mSleep(2000)
	::run_again::
	closeApp(self.awz_bid) 
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(1, 3))

	while true do
		--AWZ，AXJ
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(657,1307) == 0x0950d0 or getColor(652,1198) == 0x0950d0 then
				self:myToast("准备newApp")
				break
			end
		else
			goto run_again
		end
	end

	mSleep(1000)
	if getColor(56,1058) == 0x6f7179 then
		mSleep(math.random(500, 1000))
		tap(225,826)
		mSleep(math.random(500, 1000))
		while true do
			if getColor(376, 735) == 0xffffff or getColor(379, 562) == 0xffffff then
				self:myToast("newApp成功")
				break
			end
		end
	else
		::new_phone::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request(self.awz_url)
		if code == 200 then
			local resJson = sz.json.decode(res)
			local result = resJson.result
			if result == 3 then
				self:myToast("新机成功，但是ip重复了")
			elseif result == 1 then
				self:myToast("新机成功")
			else 
				self:myToast("失败，请手动查看问题："..tostring(res), 3000)
				goto run_again
			end
		end 
	end
end

function model:getConfig()
	::configFile::
	tab = readFile(userPath().."/res/config1.txt") 
	if tab then 
		self.wc_bid = string.gsub(tab[1],"%s+","")
		self.awz_bid = string.gsub(tab[4],"%s+","")
		self.awz_url = string.gsub(tab[5],"%s+","")
		self:myToast("获取配置信息成功")
	else
		dialog("文件不存在,请检测配置文件")
		goto configFile
	end
end

function model:loginAccount()
	::run_app::
	mSleep(1000)
	runApp(self.wc_bid)
	mSleep(2000)
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "22|0|0x1a1a1a,30|0|0x1a1a1a,49|0|0x1a1a1a,350|1|0x1a1a1a,380|4|0x1a1a1a,433|-1|0x1a1a1a,484|-2|0xffffff,589|-1|0xb3b3b3", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 50, y)
			mSleep(math.random(500, 700))
			self:myToast("ipad使用")
		end

		mSleep(50)
		if getColor(232,  430) ==  0x000000 then
			break
		else
			mSleep(math.random(500, 700))
			tap(352, 980)
			mSleep(math.random(500, 700))
		end

		mSleep(50)
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x576b95, "-8|-13|0x576b95,10|-13|0x576b95,-303|-414|0x1a1a1a,-286|-427|0x1a1a1a,-286|-397|0x1a1a1a,-82|-403|0x1a1a1a,-45|-404|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("匹配通讯录")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "181|29|0x191919,566|29|0x191919,108|31|0xf9f9f9,607|18|0xf9f9f9", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			self:myToast("微信界面")
			break
		end

		mSleep(50)
		if getColor(232,  430) ==  0x000000 then
			mSleep(500)
			self:myToast("等待扫码",5000)
		end

		mSleep(50)
		if getColor(385,  463) == 0x18aa48 or getColor(384,  496) == 0x18aa48 then
			mSleep(500)
			tap(385,  463)
			mSleep(2000)
			self:myToast("二维码失效",5000)
		end

		mSleep(50)
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			runApp(self.wc_bid)
			mSleep(2000)
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "-4|-26|0x07c160,-569|-17|0xf5f5f5,-54|6|0xf5f5f5", 90, 0, 1190, 749, 1333)
		if x~=-1 and y~=-1 then
			self:myToast("我")
			break
		else
			mSleep(math.random(500, 700))
			tap(659, 1269)
			mSleep(math.random(500, 700))
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x576b95, "-8|-13|0x576b95,10|-13|0x576b95,-303|-414|0x1a1a1a,-286|-427|0x1a1a1a,-286|-397|0x1a1a1a,-82|-403|0x1a1a1a,-45|-404|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("匹配通讯录")
		end

		mSleep(50)
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			runApp(self.wc_bid)
			mSleep(2000)
		end
	end

	while (true) do
		--支付
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x00c777, "-16|-1|0x00c777,29|-1|0x00c777,77|-13|0x1a1a1a,108|-13|0x1a1a1a,96|-4|0x1a1a1a,121|4|0x1a1a1a,144|3|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 200, y + 20)
			mSleep(math.random(500, 700))
			self:myToast("支付")
		end

		--三个点
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x181818, "-7|0|0xededed,-14|0|0x181818,7|0|0xededed,14|0|0x181818,1|27|0xededed,-15|100|0x2aae67,-312|4|0x171717,-292|-1|0x171717", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("三个点")
		end

		--实名认证
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(379,  192)
			mSleep(math.random(500, 700))
			self:myToast("实名认证")
			break
		end
	end

	::smrz::
	while (true) do
		--实名认证
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(379,  192)
			mSleep(math.random(500, 700))
		end

		--立即认证
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "110|10|0xffffff,-124|-27|0x07c160,-123|38|0x07c160,49|-23|0x07c160,55|40|0x07c160,228|-21|0x07c160,226|37|0x07c160,12|-779|0x07c160,90|-780|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("立即认证")
		end

		--同意
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "-15|3|0x07c160,10|6|0x07c160,32|7|0x07c160,-605|8|0x2c2b31,-584|8|0x2c2b31,-559|4|0x2c2b31,-536|3|0x2c2b31,-297|13|0xffffff", 90, 0, 1220, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("同意")
			break
		end
	end

	unmatching = false
	::getIdCard::
	if unmatching then
		::pushData::
		local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter", "insert_data", self.pushCategory, self.pushData)
		if plugin_ok and api_ok then
			self:myToast("插入数据成功")
		else
			self:myToast("插入数据失败，重新插入:"..tostring(plugin_ok).."----"..tostring(api_ok), 3000)
			goto pushData
		end
	end

	local category = "idCard-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data", category)
	if plugin_ok and api_ok then
		self:myToast(data)

		local data = strSplit(data,"----")
		if #data > 0 then
			self.idCard_user = data[1]
			self.idCard_numCode = data[2]
		end	
	else
		dialog("身份信息已经用完，请重新上传新数据", 0)
		goto getIdCard
	end

	while (true) do
		mSleep(50)
		if getColor(249,  270) == 0x1a1a1a  and getColor(498,  266) == 0x1a1a1a or getColor(274, 1272) == 0x07c160 then
			self:myToast("准备输入信息",1000)

			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "16|0|0x1a1a1a,49|0|0x1a1a1a,77|-16|0x1a1a1a,77|-9|0x1a1a1a,77|-4|0x1a1a1a,77|3|0x1a1a1a,80|12|0x1a1a1a", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					tap(x + 500, y - 340)
					mSleep(1000)
					if unmatching then
						for var= 1, 10 do
							keyDown("DeleteOrBackspace")
							mSleep(20)
							keyUp("DeleteOrBackspace")
							mSleep(30)
						end
						mSleep(500)
					end
					inputStr(self.idCard_user)
					mSleep(500)
					key = "ReturnOrEnter"
					keyDown(key)
					keyUp(key)
					mSleep(1000)
					break
				end
			end

			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "16|0|0x1a1a1a,49|0|0x1a1a1a,77|-16|0x1a1a1a,77|-9|0x1a1a1a,77|-4|0x1a1a1a,77|3|0x1a1a1a,80|12|0x1a1a1a", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					tap(x + 551, y)
					mSleep(1000)
					if unmatching then
						for var= 1, 40 do
							keyDown("DeleteOrBackspace")
							mSleep(20)
							keyUp("DeleteOrBackspace")
							mSleep(30)
						end
						mSleep(500)
					end
					inputKey(self.idCard_numCode)
					self:myToast("输入姓名和id号")
					break
				end
			end
			break
		end
	end

	--性别
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "21|0|0x1a1a1a,34|-13|0x1a1a1a,57|-8|0x1a1a1a,74|-5|0x1a1a1a,90|1|0x1a1a1a,126|-1|0x1a1a1a,142|-1|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 64, y - 114)
			mSleep(1000)
		else
			mSleep(500)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
		end

		mSleep(50)
		if getColor(492, 1165) == 0x07c160 then
			mSleep(500)
			tap(492, 1165)
			mSleep(500)
			self:myToast("性别")
			break
		end
	end

	if unmatching then
		unmatching = false
		goto next
	end

	--证件生效期
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "21|0|0x1a1a1a,34|-13|0x1a1a1a,57|-8|0x1a1a1a,74|-5|0x1a1a1a,90|1|0x1a1a1a,126|-1|0x1a1a1a,142|-1|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 64, y + 226)
			mSleep(1000)
		end

		mSleep(50)
		if getColor(488, 1239) == 0x07c160 then
			mSleep(500)
			tap(488, 1239)
			mSleep(500)
			self:myToast("证件生效期")
			break
		end
	end

	--证件失效期
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "21|0|0x1a1a1a,34|-13|0x1a1a1a,57|-8|0x1a1a1a,74|-5|0x1a1a1a,90|1|0x1a1a1a,126|-1|0x1a1a1a,142|-1|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 64, y + 335)
			mSleep(1000)
		end

		mSleep(50)
		if getColor(488, 1239) == 0x07c160 then
			mSleep(500)
			tap(488, 1239)
			mSleep(500)
			self:myToast("证件失效期")
			break
		end
	end

	--职业
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "21|0|0x1a1a1a,34|-13|0x1a1a1a,57|-8|0x1a1a1a,74|-5|0x1a1a1a,90|1|0x1a1a1a,126|-1|0x1a1a1a,142|-1|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x + 64, y + 454)
			mSleep(1000)
		end

		mSleep(50)
		if getColor(421,   78) == 0x171717 and getColor(510,   87) == 0xededed then
			mSleep(500)
			tap(314, 1075)
			mSleep(500)
			self:myToast("职业")
			break
		end
	end

	::next::
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "35|1|0xffffff,71|-4|0xffffff,-137|10|0x07c160,36|-28|0x07c160,202|5|0x07c160,31|21|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			self:myToast("下一步")
			break
		else
			moveTowards(404,1094,90,300,10)
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "16|-1|0x1a1a1a,52|-1|0x1a1a1a,262|-15|0x576b95,438|-12|0x576b95,182|-215|0x1a1a1a,182|-185|0x1a1a1a,168|-202|0x1a1a1a,234|-202|0x1a1a1a,234|-184|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x,   y)
			mSleep(math.random(500, 700))
			self:myToast("证件与姓名不匹配")
			unmatching = true
			self.pushCategory = "error-data"
			self.pushData = self.idCard_user .. "----" .. self.idCard_numCode .. "----证件与姓名不匹配"
			goto getIdCard
		end

		--已征得同意
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "25|6|0x576b95,41|3|0x576b95,79|3|0x576b95,104|0|0x576b95,137|2|0x576b95,-279|-4|0x1a1a1a,-260|-10|0x1a1a1a,-236|4|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(x, y)
			mSleep(500)
			self:myToast("已征得同意")
		end

		--添加银行卡
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "68|0|0x07c160,168|2|0xf2f2f2,-124|6|0xf2f2f2,-139|-112|0x07c160,181|-110|0x07c160,-33|-102|0xffffff,68|-113|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x,   y)
			mSleep(math.random(500, 700))
			self:myToast("暂不绑卡")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "7|0|0x07c160,17|-9|0x07c160,47|15|0x07c160,81|6|0x07c160,112|8|0x07c160,135|-1|0xf2f2f2,-51|1|0xf2f2f2,-380|9|0x1a1a1a,-449|15|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x - 175,   y - 111)
			mSleep(math.random(500, 700))
			inputStr(phoneNum)
			mSleep(1000)
			tap(x,   y)
			mSleep(500)
			self:myToast("输入手机号码")
		end

		mSleep(50)
		if getColor(614, 1256) == 0x181818 and getColor(674, 1260) == 0xededed then
			self:myToast("准备设置密码", 1000)
			break
		end
	end

	while (true) do
		mSleep(50)
		if getColor(614, 1256) == 0x181818 and getColor(674, 1260) == 0xededed then
			mSleep(500)
			for i = 1, #(pwd) do
				mSleep(200)
				num = string.sub(pwd,i,i)
				mSleep(300)
				if num == "0" then
					mSleep(500)
					tap(374, 1262)
				elseif num == "1" then
					mSleep(500)
					tap(121,  811)
				elseif num == "2" then
					mSleep(500)
					tap(371,  808)
				elseif num == "3" then
					mSleep(500)
					tap(624,  806)
				elseif num == "4" then
					mSleep(500)
					tap(122,  963)
				elseif num == "5" then
					mSleep(500)
					tap(377,  960)
				elseif num == "6" then
					mSleep(500)
					tap(613,  956)
				elseif num == "7" then
					mSleep(500)
					tap(119, 1110)
				elseif num == "8" then
					mSleep(500)
					tap(375, 1106)
				elseif num == "9" then
					mSleep(500)
					tap(621, 1107)
				end
				mSleep(500)
			end
			mSleep(2000)
		end

		mSleep(50)
		if getColor(92,  673) == 0x07c160 and getColor(663,  665) == 0x07c160 then
			mSleep(math.random(500, 700))
			tap(368,  676)
			mSleep(math.random(500, 700))
			self:myToast("下一步", 3000)
			break
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x06ae56, "4|16|0x06ae56,43|-5|0x06ae56,19|-836|0x07c160,25|-775|0x07c160,-100|6|0xf2f2f2,151|11|0xf2f2f2", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			self:myToast("完成")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x00c777, "-16|-1|0x00c777,29|-1|0x00c777,77|-13|0x1a1a1a,108|-13|0x1a1a1a,96|-4|0x1a1a1a,121|4|0x1a1a1a,144|3|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 200, y + 130)
			mSleep(math.random(500, 700))
			break
		else
			mSleep(math.random(500, 700))
			tap(54, 81)
			mSleep(math.random(500, 700))
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x00c777, "-16|-1|0x00c777,29|-1|0x00c777,77|-13|0x1a1a1a,108|-13|0x1a1a1a,96|-4|0x1a1a1a,121|4|0x1a1a1a,144|3|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 200, y + 130)
			mSleep(math.random(500, 700))
		end
		
		mSleep(50)
		if getColor(693,   83) == 0x181818 and getColor(604,   85) == 0xededed then
			mSleep(math.random(500, 700))
			tap(693,   83)
			mSleep(math.random(500, 700))
		end
		
		mSleep(50)
		if getColor(694,   83) == 0x757575 then
			mSleep(math.random(500, 700))
			tap(313,   283)
			mSleep(math.random(500, 700))
			inputStr(self.idCard_user .. "----" .. self.idCard_numCode)
			mSleep(1000)
			tap(54, 81)
			mSleep(math.random(500, 700))
			break
		end
	end
end

function model:main()
	self:getConfig()
	while (true) do
		self:clear_App()
		self:loginAccount()
		self:myToast('一个流程结束，进行下一个', 5000)
	end
end

model:main()



