require("TSLib")
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.awz_bid = ""
model.awz_url = ""
model.wc_bid = ""
model.wc_folder = ""
model.wc_file = ""

model.account = ""
model.password = ""
model.six_two_data = ""

function model:clear_App()
	::run_again::
	mSleep(500)
	closeApp(self.awz_bid) 
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(3, 6))

	while true do
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				break
			end
		else
			goto run_again
		end
	end

	::new_phone::
	local sz = require("sz");
	local szhttp = require("szocket.http")
	local res, code = szhttp.request()
	if code == 200 then
		local resJson = sz.json.decode(res)
		local result = resJson.result
		if result == 3 then
			toast("newApp成功，但是ip重复了",1)
		elseif result == 1 then
			toast("newApp成功",1)
		else 
			toast("newApp失败，请手动查看问题", 1)
			mSleep(3000)
			goto run_again
		end
	end 
end

function model:file_read_write(path,str,nr)  --path路径，str要查找的文本，nr是新增文本,返回值是行内容和行数。
	local path = userPath().."/res/"..path
	local result

	if not isFileExist(path) then
		dialog("路径不存在！请检查", 0)
	end

	local code 
	local data = readFileString(path)
	data = self:TryRemoveUtf8BOM(data)
	if data ~= "" and data ~= nil then
		local line = strSplit(data,"\r\n")
		for i = 1,#line do 
			if string.find(line[i],str) ~= nil then   ---如果真   找到，需要继续找
				--dialog(i.."="..line[i], 0)
			else
				result = line[i]
				code = i
				break
			end	
		end	

		writeFileString(path,"","w")
		for k = 1,#line do
			if k == code then
				writeFileString(path,line[k]..nr.."\r\n","a")
			else
				writeFileString(path,line[k].."\r\n","a")
			end	
		end	
	end	
	return result,code
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
	local path = userPath().."/res/62数据.txt"

	local result

	if isFileExist(path) then
	else
		dialog("写入文件不存在！请检查", 0)
		lua_exit()
	end

	local data =  self:file_read_write("62数据.txt","已经读取","----已经读取")
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
		--sjkwj=data[3]

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
		writeFileString(userPath().."/res/账号正常.txt",self.account.."----"..self.password.."----"..self.six_two_data.."----账号正常","a",1) 
	else
		writeFileString(userPath().."/res/账号封禁.txt",self.account.."----"..self.password.."----"..self.six_two_data.."----账号封禁","a",1) 
	end
	mSleep(500)
	toast("数据保存成功",1)
end

function model:main()
	self:getConfig()
	self:run()
	self:loginAccount()
	toast('运行完成',10)
end

model:main()



