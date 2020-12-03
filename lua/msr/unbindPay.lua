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

model.infoData = ""

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
end

function model:write_six_two()
	::getSixData::
	local category = "six-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
	    self.infoData = data
		toast(self.infoData, 1)
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
	tab = readFile(userPath().."/res/config1.txt") 
	if tab then 
		self.wc_bid = string.gsub(tab[1],"%s+","")
		self.wc_folder = string.gsub(tab[2],"%s+","")
		self.wc_file = string.gsub(tab[3],"%s+","")
		self.awz_bid = string.gsub(tab[4],"%s+","")
		self.awz_url = string.gsub(tab[5],"%s+","")
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
	self:clear_App()
	self:clear_data(self.wc_bid)
	mSleep(2000)
	self:six_two_login()
end

function model:timeOutRestart(t1)
    t2 = ts.ms()

    if os.difftime(t2, t1) > 60 then
        toast("超过45秒退出微信重新进入", 1)
        mSleep(1000)
    	closeApp(self.wc_bid)
    	mSleep(2000)
		return false
	else
		return true
    end
end

function model:dialog_box()
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "321|10|0x576b95,317|-11|0x576b95,39|-356|0x1a1a1a,224|-358|0x1a1a1a,259|-356|0x1a1a1a", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(math.random(500, 700))
		tap(x, y)
		mSleep(math.random(500, 700))
		toast("匹配通讯录",1)
		mSleep(500)
	end
	
	--允许访问位置
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0x007aff, "22|0|0x007aff,38|-1|0x007aff,-114|-273|0x000000,-47|-277|0x000000,-93|-316|0x000000", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(math.random(500, 700))
		randomsTap(x, y, 4)
		mSleep(math.random(500, 700))
		toast("允许访问位置",1)
		mSleep(500)
	end
	
	--好
	x,y = findMultiColorInRegionFuzzy( 0x007aff, "8|-1|0x007aff,6|14|0x007aff,16|-5|0x007aff,27|8|0x007aff,18|22|0x007aff", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(math.random(500, 700))
		randomsTap(x, y, 4)
		mSleep(math.random(500, 700))
		toast("好",1)
		mSleep(500)
	end
	
	--尚未绑定手机号
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "6|-1|0x576b95,33|4|0x576b95,69|3|0x576b95,142|-1|0x576b95,-349|-217|0x1a1a1a,-314|-224|0x1a1a1a,-122|-140|0x1a1a1a,-103|-131|0x1a1a1a,152|-187|0x1a1a1a", 90, 0, 0, 749, 1333)
	if x~=-1 and y~=-1 then
		mSleep(math.random(500, 700))
		randomsTap(x - 250, y, 4)
		mSleep(math.random(500, 700))
		toast("尚未绑定手机号",1)
		mSleep(500)
	end
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
    
    tt = ts.ms()
	while (true) do
	    timeOut = self:timeOutRestart(tt)
		if not timeOut then
			tt = ts.ms()
		end
	    
		--登陆
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "35|9|0xffffff,-304|-34|0x07c160,-306|32|0x07c160,1|-38|0x07c160,16|34|0x07c160,334|-35|0x07c160,336|27|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x, y, 4)
			mSleep(math.random(500, 700))
		end

		self:dialog_box()

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("微信界面",1)
			data_six_two = true
			break
		end
        
        --密码错误
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "45|-1|0x576b95,-210|-162|0x1a1a1a,-193|-166|0x1a1a1a,-163|-165|0x1a1a1a,-58|-157|0x1a1a1a,-37|-157|0x1a1a1a,12|-165|0x1a1a1a,66|-160|0x1a1a1a,170|-164|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("密码错误",1)
			data_six_two = false
			category = "error-data"
			data = self.infoData.."----密码错误"
			break
		end
		
		--外挂封号
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "17|-2|0x576b95,46|-2|0x576b95,-388|-303|0x1a1a1a,-356|-300|0x1a1a1a,-320|-303|0x1a1a1a,-32|-145|0x1a1a1a,3|-139|0x1a1a1a,22|-152|0x1a1a1a,22|-144|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("外挂封号",1)
			data_six_two = false
			category = "error-data"
			data = self.infoData.."----外挂封号"
			break
		end
		
		--恶意营销
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "28|3|0x576b95,-47|-286|0x1a1a1a,-21|-286|0x1a1a1a,-22|-272|0x1a1a1a,-33|-258|0x1c1c1c,-39|-264|0x1a1a1a,-195|-155|0x1a1a1a,-195|-146|0x1a1a1a,-179|-147|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("恶意营销",1)
			data_six_two = false
			category = "error-data"
			data = self.infoData.."----恶意营销"
			break
		end
		
		--安全验证
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x10aeff, "117|6|0x10aeff,53|1|0xffffff,-265|388|0x1aad19,378|387|0x1aad19,382|440|0x1aad19,-271|449|0x1aad19", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("安全验证",1)
			data_six_two = false
			category = "error-data"
			data = self.infoData.."----安全验证"
			break
		end
		
		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			runApp(self.wc_bid)
	        mSleep(2000)
		end
	end

	mSleep(500)
	if data_six_two then
	    tt = ts.ms()
	    
        while (true) do
            timeOut = self:timeOutRestart(tt)
			if not timeOut then
				tt = ts.ms()
			end
				
			self:dialog_box()
            
            mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x07c160, "-4|-26|0x07c160,-569|-17|0xf5f5f5,-54|6|0xf5f5f5", 90, 0, 1190, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			else
				mSleep(math.random(500, 700))
				tap(659, 1269)
				mSleep(math.random(500, 700))
			end
			
			mSleep(math.random(500, 700))
    		flag = isFrontApp(self.wc_bid)
    		if flag == 0 then
    			runApp(self.wc_bid)
    	        mSleep(2000)
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
				tap(x, y)
				mSleep(math.random(500, 700))
				toast("三个点",1)
				mSleep(500)
			end

			--注销wcPay
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				while true do
				    mSleep(500)
				    x,y = findMultiColorInRegionFuzzy(0x1b1b1b, "16|11|0x262626,11|22|0x1a1a1a,45|10|0x212121,63|14|0x1a1a1a,97|14|0x1a1a1a,116|14|0x272727,148|-1|0x1a1a1a,168|20|0x1a1a1a,187|8|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                    if x~=-1 and y~=-1 then
        				mSleep(math.random(500, 700))
        				tap(x, y)
        				mSleep(math.random(500, 700))
        				toast("注销wcPay",1)
        				mSleep(500)
        				break
        			else
        			    mSleep(math.random(500, 700))
    					moveTowards( 108,  1052, 80, 500)
    					mSleep(3000)
        			end
				end
				break
			end
		end
        
		::again::
		while (true) do
		    --确认注销
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "111|-4|0xffffff,-184|-38|0x04be02,-185|31|0x04be02,52|-38|0x04be02,52|31|0x04be02,381|-33|0x04be02,376|27|0x04be02,-36|-607|0x171717,142|-608|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x, y)
				mSleep(math.random(500, 700))
				toast("确认注销",1)
				mSleep(500)
			end
			
			--验证pay密码
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy(0xc8c8cd, "-427|-228|0x171717,-270|-222|0x171717,-251|-225|0x171717,-260|-6|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x - 200, y)
				mSleep(math.random(500, 700))
				toast("验证pay密码",1)
				mSleep(1500)
				break
			end
		end
		
		while true do
		    mSleep(500)
		    if getColor(566,1289) == 0xededed and getColor(617,1280) == 0x181818 then
		        payPass = "800000"
		        for i = 1, #(payPass) do
            		mSleep(500)
            		num = string.sub(payPass,i,i)
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
		    end
		    
		    --原身份已注销
		    mSleep(500)
		    x,y = findMultiColorInRegionFuzzy(0xffffff, "30|-4|0xffffff,-228|-34|0x04be02,-230|21|0x04be02,18|-36|0x04be02,15|25|0x04be02,311|-36|0x04be02,312|26|0x04be02,6|-378|0x09bb07,25|-294|0x09bb07", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("原身份已注销",1)
				mSleep(500)
				category = "success-data"
				data = self.infoData.."----注销成功"
				break
            end
		    
		    --支付密码错误
		    mSleep(500)
		    x,y = findMultiColorInRegionFuzzy(0x576b95, "12|3|0x576b95,10|17|0x576b95,34|7|0x576b95,50|1|0x576b95,79|12|0x576b95,117|10|0x576b95,-260|-164|0x1a1a1a,-80|-161|0x1a1a1a,41|-157|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("支付密码错误",1)
				mSleep(500)
				category = "error-data"
				data = self.infoData.."----支付密码错误"
				break
            end
			
			--账户冻结
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "25|9|0xffffff,50|10|0xffffff,-293|-16|0x04be02,-298|36|0x04be02,362|-17|0x04be02,355|38|0x04be02,-279|-207|0x000000,-26|-210|0x000000,9|-219|0x000000", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				toast("账户冻结",1)
				mSleep(500)
				category = "error-data"
				data = self.infoData.."----账户冻结"
				break
            end
			
			--确定
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0x02bb00, "10|0|0x02bb00,37|0|0x02bb00,-36|-122|0x000000,-25|-121|0x040404,5|-121|0x000000,34|-125|0x000000,61|-126|0x000000", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(500, 700))
				tap(x, y)
				mSleep(math.random(500, 700))
				toast("确定",1)
				mSleep(500)
				goto again
			end
		end
		
		::pushData::
    	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
    	if plugin_ok and api_ok then
    		toast("插入数据成功", 1)
    		mSleep(1000)
    	else
    		toast("插入数据失败，重新插入", 1)
    		mSleep(1000)
    		goto pushData
    	end
	else
	    ::pushData::
    	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
    	if plugin_ok and api_ok then
    		toast("插入数据成功", 1)
    		mSleep(1000)
    	else
    		toast("插入数据失败，重新插入", 1)
    		mSleep(1000)
    		goto pushData
    	end
		toast("账号封禁或者账号密码错误了，进行下一个操作",1)
	end
end

function model:main()
    while true do
    	self:getConfig()
    	self:run()
    	self:loginAccount()
    	toast('一个流程结束，进行下一个',1)
    end
end

model:main()



