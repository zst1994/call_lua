require("TSLib")

wc_bid = ""
wc_folder = ""
wc_file = ""

function file_read_write(path,str,nr)  --path路径，str要查找的文本，nr是新增文本,返回值是行内容和行数。
	local path = userPath().."/res/"..path
	local result
	if isFileExist(path) then
	else
		dialog("路径不存在！请检查", 0)
	end
	local code 
	local data = readFileString(path)
	data = TryRemoveUtf8BOM(data)
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

function TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end

function _hexStringToFile(hex,file)
	local data = '';
	if hex==nil or string.len(hex)<2 then
		toast('error',1)
		return
	end
	dialog(#hex, 0)
	hex = string.match(hex,"(%w+)");
	dialog(string.len(hex), 0)
	for i = 1, string.len(hex),2 do
		local code = string.sub(hex, i, i+1);
		data =data..string.char(tonumber(code,16));
	end
	nLog(data)
	local file = io.open(file, 'wb');
	file:write(data);
	file:close();
end

function _writeData(data) --写入数据
	local wcdataPath = appDataPath(wc_bid) .. wc_folder;
	newfolder(wcdataPath)
	os.execute('chown mobile ' .. wcdataPath)
	_hexStringToFile(data,appDataPath(wc_bid) .. wc_file)
	os.execute('chown mobile ' .. appDataPath(wc_bid) .. wc_file)
	return true
end

function write_six_two()
	local path = userPath().."/res/62数据.txt"

	local result

	if isFileExist(path) then
	else
		dialog("写入文件不存在！请检查", 0)
		lua_exit()
	end

	local data =  file_read_write("62数据.txt","已经读取","----已经读取")
	data = TryRemoveUtf8BOM(data)
	toast(data,1)
	if data ~= "" and data ~= nil then
		local data = strSplit(data,"----")
		if #data > 2 then
			wczh = data[1]
			wcmm = data[2]
			lesjk=data[3]
		end	
		_writeData(data[3])
		toast("写入成功！") 
		--sjkwj=data[3]
		
		dialog(data[1],0)
		dialog(data[2],0)
		dialog(data[3],0)
		result = true
	else
		dialog("登录失败！原因：写入数据无效！", 0) 
		result = false
	end	
	return result
end

function six_two_login()
	if write_six_two() then
		mSleep(2000)
	else
		dialog("登录失败！请检查数据！", 0)
		lua_exit()
	end	
end

function clear_data (bid)
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
	delFileEx(dataPath..wc_folder.."*")
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

function run()
	clear_data(wc_bid)
	mSleep(2000)
	six_two_login()
end

function main()
	mSleep(1000)
	closeApp(wc_bid)
	mSleep(2000)
	run()
end

function getConfig()
	tab = readFile(userPath().."/res/config1.txt") 
	if tab then 
		wc_bid = string.gsub(tab[1],"%s+","")
		wc_folder = string.gsub(tab[2],"%s+","")
		wc_file = string.gsub(tab[3],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在")
	end
end

function loop()
	getConfig()
	main()
	toast('运行完成',1)
end

loop()




