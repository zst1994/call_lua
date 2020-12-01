require("TSLib")
local ts 				= require('ts')
local json 				= ts.json
local ts_enterprise_lib = require("ts_enterprise_lib")

local model 			= {}

model.wc_bid = ""
model.wc_folder = ""
model.wc_file = ""
model.awz_bid = ""
model.awz_url = ""

model.account = ""
model.password = ""
model.six_two_data = ""

model.idCard_user = ""
model.idCard_numCode = ""

function model:clear_App()
	::run_again::
	mSleep(500)
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
				toast("准备newApp",1)
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
				toast("newApp成功",1)
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
				toast("新机成功，但是ip重复了",1)
			elseif result == 1 then
				toast("新机成功",1)
			else 
				toast("失败，请手动查看问题："..tostring(res), 1)
				mSleep(3000)
				goto run_again
			end
		end 
	end
end

function model:TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end

function model:_hexStringToFile(hex,file)
	local data = '';
	if hex==nil or string.len(hex)<2 then
		toast('error',1)
		return
	end
	hex = string.match(hex,"(%w+)");
	for i = 1, string.len(hex),2 do
		local code = string.sub(hex, i, i+1);
		data =data..string.char(tonumber(code,16));
	end
	local file = io.open(file, 'wb');
	file:write(data);
	file:close();
end

function model:_writeData(data) --写入62
	local wxdataPath = appDataPath(self.wc_bid) .. self.wc_folder;
	newfolder(wxdataPath)
	os.execute('chown mobile ' .. wxdataPath)
	self:_hexStringToFile(data,appDataPath(self.wc_bid) .. self.wc_file)
	os.execute('chown mobile ' .. appDataPath(self.wc_bid) .. self.wc_file)
	return true
end

function model:write_six_two()
	::getSixData::
	local category = "six-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
		toast(data, 1)
		mSleep(1000)
	else
		dialog("62数据已经用完，请重新上传新数据", 0)
		goto getSixData
	end

	data = self:TryRemoveUtf8BOM(data)
	if data ~= "" and data ~= nil then
		local data = strSplit(data,"----")
		if #data > 2 then
			self.account = data[1]
			self.password = data[2]
			self.six_two_data = data[3]
		end	
		self:_writeData(self.six_two_data)
		toast("写入成功！") 
		result = true
	else
		dialog("登录失败！原因：写入62数据无效！", 0) 
		result = false
	end	
	return result
end

function model:six_two_login()
	if self:write_six_two() then
		mSleep(2000)
	else
		dialog("登录失败！请检查数据！", 0)
		lua_exit()
	end	
end

function model:clear_data (bid)
	local sz = require("sz")
	local sqlite3 = sz.sqlite3	
	del_sql = function ()
		local db = sqlite3.open("/private/var/Keychains/keychain-2.db")
		db:exec("delete from genp where agrp not like '%apple%'")
		db:exec("delete from cert")
		db:exec("delete from keys")
		db:exec("delete from inet")
		db:exec("delete from sqlite_sequence")
		assert(db:close() == sqlite3.OK)
	end

	delFileEx = function (path)
		os.execute("rm -rf "..path);
	end

	clearCache = function ()
		os.execute("su mobile -c uicache");
	end

	newfolder = function (path)
		os.execute("mkdir "..path);
	end

	if bid == nil or type(bid) ~= "string" then 
		dialog("清理传入的bid有问题") 
		return false 
	end

	toast("清理中,请勿中止",10);
	mSleep(888)
	::getDataPath::
	local dataPath = appDataPath(bid);
	if dataPath == nil then
		goto getDataPath
	end

	local flag = appIsRunning(bid);
	if flag == 1 then
		closeApp(bid); 
		mSleep(1500)
	end

	delFileEx(dataPath.."/Documents") 
	delFileEx(dataPath.."/tmp")
	delFileEx(dataPath.."/Library/APCfgInfo.plist") 
	delFileEx(dataPath.."/Library/APWsjGameConfInfo.plist") 
	delFileEx(dataPath.."/Library/Preferences/*")
	mSleep(500)
	newfolder(dataPath.."/Documents") 
	newfolder(dataPath.."/tmp")
	os.execute("chmod -R 777 ar/Keychains");
	del_sql();
	clearKeyChain(bid);--指定清除应用钥匙串信息Keychains
	--	local str = clearIDFAV();
	--	dialog(str)
	clearCookies();
	toast("清理",2);
	os.execute("chmod -R 777 "..dataPath.."/Documents");
	os.execute("chmod -R 777 "..dataPath.."/tmp");
	os.execute("chmod -R 777 "..dataPath.."/Library");
	os.execute("chmod -R 777 "..dataPath.."/Library/Preferences");
	mSleep(500)
	clearCache();
end

function model:getConfig()
	tb = readFile(userPath().."/res/config.txt") 
	if table then 
		self.wc_bid = string.gsub(tb[1],"%s+","")
		self.wc_folder = string.gsub(tb[2],"%s+","")
		self.wc_file = string.gsub(tb[3],"%s+","")
		self.awz_bid = string.gsub(tb[4],"%s+","")
		self.awz_url = string.gsub(tb[5],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在")
	end
end

function model:run()
	mSleep(1000)
	closeApp(self.wc_bid)
	mSleep(2000)
--	self:clear_App()
	self:clear_data(self.wc_bid)
	mSleep(2000)
	self:six_two_login()
end

function model:loginAccount()
	::run_app::
	mSleep(1000)
	runApp(self.wc_bid)
	mSleep(2000)
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x - 350, y + 20, 4)
			mSleep(math.random(500, 700))
			toast("登录",1)
			mSleep(500)
			break
		end

		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "31|-1|0x576b95,55|9|0x576b95,96|0|0x576b95,225|-4|0x576b95,275|7|0x576b95,295|1|0x576b95,329|4|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 4)
			mSleep(math.random(500, 700))
			toast("微信号/QQ/邮箱登录",1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "33|-4|0x576b95,56|3|0x576b95,72|-4|0x576b95,105|-1|0x576b95,162|3|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x + 343, y - 209, 4)
			mSleep(math.random(500, 700))
			inputKey(self.account)
			mSleep(500)
			toast("输入账号",1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "33|-4|0x576b95,56|3|0x576b95,72|-4|0x576b95,105|-1|0x576b95,162|3|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x + 343, y - 121, 4)
			mSleep(math.random(500, 700))
			inputKey(self.password)
			mSleep(500)
			toast("输入密码",1)
			mSleep(500)
		end

		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "35|9|0xffffff,-304|-34|0x07c160,-306|32|0x07c160,1|-38|0x07c160,16|34|0x07c160,334|-35|0x07c160,336|27|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 4)
			mSleep(math.random(500, 700))
			toast("登录",1)
			mSleep(500)
			break
		end
	end

	data_six_two = false

	while (true) do
		--登陆
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "35|9|0xffffff,-304|-34|0x07c160,-306|32|0x07c160,1|-38|0x07c160,16|34|0x07c160,334|-35|0x07c160,336|27|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 4)
			mSleep(math.random(500, 700))
		end

		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "321|10|0x576b95,317|-11|0x576b95,39|-356|0x1a1a1a,224|-358|0x1a1a1a,259|-356|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 4)
			mSleep(math.random(500, 700))
			toast("匹配通讯录",1)
			mSleep(500)
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("微信界面",1)
			data_six_two = true
			break
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "28|3|0x576b95,-336|0|0x181819,-288|1|0x181819,-399|-319|0x000000,-367|-312|0x000000,-334|-317|0x000000,-6|-139|0x000000,-18|-134|0x000000,94|-112|0xf9f7fa", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("账号封禁1",1)
			data_six_two = false
			break
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "44|4|0x1a1a1a,320|5|0x576b95,337|3|0x576b95,366|-4|0x576b95,374|3|0x576b95,-68|-214|0x1a1a1a,-36|-210|0x1a1a1a,0|-213|0x1a1a1a,401|-143|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("账号封禁2",1)
			data_six_two = false
			break
		end
	end

	mSleep(500)
	if data_six_two then
		::getIdCard::
		local category = "idCard-data"
		local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
		if plugin_ok and api_ok then
			toast(data, 1)
			mSleep(1000)
		else
			dialog("身份信息已经用完，请重新上传新数据", 0)
			goto getIdCard
		end

		data = self:TryRemoveUtf8BOM(data)
		if data ~= "" and data ~= nil then
			local data = strSplit(data,"----")
			if #data > 0 then
				self.idCard_user = data[1]
				self.idCard_numCode = data[2]
			end	
		end

		while (true) do
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "321|10|0x576b95,317|-11|0x576b95,39|-356|0x1a1a1a,224|-358|0x1a1a1a,259|-356|0x1a1a1a", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(x, y, 4)
				mSleep(math.random(500, 700))
				toast("匹配通讯录",1)
				mSleep(500)
			end

			x,y = findMultiColorInRegionFuzzy( 0x07c160, "-4|-26|0x07c160,-569|-17|0xf5f5f5,-54|6|0xf5f5f5", 90, 0, 1190, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			else
				mSleep(math.random(500, 700))
				randomsTap(659, 1269, 4)
				mSleep(math.random(500, 700))
			end
		end

		while (true) do
			--支付
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x00c777, "-13|-3|0x00c777,24|-2|0x00c777,66|-12|0x1a1a1a,91|-12|0x1a1a1a,79|6|0x1a1a1a,103|2|0x1a1a1a,122|-1|0x1a1a1a", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x + 200, y + 20)
				mSleep(math.random(500, 700))
				toast("支付",1)
				mSleep(500)
			end

			--三个点
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x181818, "-7|-2|0xededed,-14|-2|0x181818,-26|2|0xededed,7|0|0xededed,14|-2|0x181818,30|-2|0xededed,-292|5|0x171717,21|77|0x3cb371,23|319|0x3cb371", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(x, y, 4)
				mSleep(math.random(500, 700))
				toast("三个点",1)
				mSleep(500)
			end

			--实名认证
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				randomsTap(379,  192, 4)
				mSleep(math.random(500, 700))
				toast("实名认证",1)
				mSleep(500)
				break
			end
		end

		::smrz::
		while (true) do
			--立即认证
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "110|10|0xffffff,-124|-27|0x07c160,-123|38|0x07c160,49|-23|0x07c160,55|40|0x07c160,228|-21|0x07c160,226|37|0x07c160,12|-779|0x07c160,90|-780|0x07c160", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x, y)
				mSleep(math.random(500, 700))
				toast("立即认证",1)
				mSleep(500)
			end

			--同意
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x07c160, "-15|3|0x07c160,10|6|0x07c160,32|7|0x07c160,-605|8|0x2c2b31,-584|8|0x2c2b31,-559|4|0x2c2b31,-536|3|0x2c2b31,-297|13|0xffffff", 90, 0, 1220, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x, y)
				mSleep(math.random(500, 700))
				toast("同意",1)
				mSleep(500)
				break
			end
		end

		while (true) do
			mSleep(500)
			if getColor(249,  270) == 0x1a1a1a  and getColor(498,  266) == 0x1a1a1a then
				while (true) do
					mSleep(500)
					x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(500)
						tap(425,  638)
						mSleep(500)
						break
					else
						mSleep(500)
						tap(390, 526)
						mSleep(math.random(500, 700))
						inputStr("袁燕群")
					end
				end
				break
			end
		end

		while (true) do
			mSleep(500)
			if getColor(270, 1234) == 0x07c160  and getColor(363,  654) == 0x1a1a1a then
				mSleep(500)
				tap(370, 1035)
				mSleep(500)
				while (true) do
					mSleep(500)
					x,y = findMultiColorInRegionFuzzy( 0x484848, "0|6|0x484848,15|6|0x484848,9|17|0x484848,33|6|0x484848,51|10|0x484848,77|4|0x484848,32|17|0x484848", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						tap(374, 1224)
						mSleep(math.random(500, 700))
						break
					end
				end
				break
			end
		end

		while (true) do
			mSleep(500)
			if getColor(249,  270) == 0x1a1a1a  and getColor(498,  266) == 0x1a1a1a or 
			getColor(248,  141) == 0x1a1a1a and getColor(498,  137) == 0x1a1a1a then
				mSleep(500)
				tap(378,  746)
				mSleep(math.random(500, 700))
				inputKey("M0111747900")
				key = "ReturnOrEnter"
				keyDown(key)
				keyUp(key)
				mSleep(100)
				keyDown(key)
				keyUp(key)
			end

			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "50|13|0xffffff,-126|-20|0x07c160,-124|41|0x07c160,45|-20|0x07c160,49|45|0x07c160,220|-12|0x07c160,221|47|0x07c160", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x,y - 290)
				mSleep(math.random(500, 700))
				break
			end
		end

		while (true) do
			mSleep(500)
			if getColor(312,   86) == 0x171717  and getColor(428,   85) == 0x171717 then
				mSleep(300)
				y =  math.random(218, 1077)
				mSleep(500)
				tap(378, y)
				mSleep(math.random(500, 700))
				toast("职业选择",1)
				mSleep(1000)
			end

			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "50|13|0xffffff,-126|-20|0x07c160,-124|41|0x07c160,45|-20|0x07c160,49|45|0x07c160,220|-12|0x07c160,221|47|0x07c160", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x,y)
				mSleep(math.random(500, 700))
				break
			end
		end

		while (true) do
			--添加银行卡
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "1|12|0x1a1a1a,-1|29|0x1a1a1a,9|-1|0x1a1a1a,19|8|0x1a1a1a,18|28|0x1a1a1a,201|3|0x1a1a1a,210|12|0x1a1a1a,33|155|0x576b95,165|150|0x576b95", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(65,   84)
				mSleep(math.random(500, 700))
				while (true) do
					mSleep(500)
					if getColor(535,  778) == 0x576b95 then
						mSleep(500)
						tap(535,  778)
						mSleep(500)
						break
					end
					toast("添加银行卡",1)
					mSleep(1000)
					break
				end

				while (true) do
					mSleep(500)
					x,y = findMultiColorInRegionFuzzy( 0xffffff, "50|13|0xffffff,-126|-20|0x07c160,-124|41|0x07c160,45|-20|0x07c160,49|45|0x07c160,220|-12|0x07c160,221|47|0x07c160", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						tap(65,   84)
						mSleep(math.random(500, 700))
						break
					end
				end
				goto smrz
			end
		end
	else
		toast("账号封禁或者账号密码错误了，进行下一个操作",1)
	end
end

function model:main()
	self:getConfig()
	self:run()
	self:loginAccount()
	toast('一个流程结束，进行下一个',1)
end

model:main()



