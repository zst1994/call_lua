require("TSLib")


xgmm = asd123123



function getData()  ----单线程提取
	local getList = function(path)
		local a = io.popen("ls "..path)
		local f = {};
		for l in a:lines() do
			table.insert(f,l)
		end
		return f
	end 
	local Wildcard = getList("/var/mobile/Containers/Data/Application")
	for var = 1,#Wildcard do
		local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/wx.dat","rb")
		if file then 
			a="/private/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Documents/LoginInfo2.dat"
			require "TSLib"--使用本函数库必须在脚本开头引用并将文件放到设备 lua 目录下
			b=readFileString(a)
			c=strSplit(b,"",1)
			d=strSplit(c[2],"R",1)
			nLog(d[1])
			wxid=d[1]

			--dialog(wxid.."\r\n"..wx, 0)
			nLog(Wildcard[var])
			local str = file:read("*a")
			file:close()
			require"sz"
			local str = string.tohex(str) --16进制编码
			return str
		end 
	end 
end
function _追加写入(path,nr1,nr2,nr3,nr4,nr5,nr6,nr7)     ---以追加的方式写入文本，path是路径，nr是要写入的内容，自动换行
	local path = userPath().."/res/"..path
	if nr1 == nil then
		dialog("没有要存入的内容", 0)
	end	
	local nr2 = nr2 or ""
	local nr3 = nr3 or ""
	local nr4 = nr4 or ""
	local nr5 = nr5 or ""
	local nr6 = nr6 or ""
	local nr7 = nr7 or ""
	local 文件句柄 = io.open(path,"a")
	local 文件 = 文件句柄:write(nr1,nr2,nr3,nr4,nr5,nr6,nr7)   
	local 文件 = 文件句柄:write("\n")   
	文件句柄:close()
	local 文件句柄 = io.open(path,"r")
	local 文件 = 文件句柄:read("*all")
	toast(文件,5)
	文件句柄:close()
end
function 自定义提取62数据流程()
local data = getData()
if data then
	if wx_id == "提取wx_id" then
		_追加写入("备用读取62数据.txt",wxid,"----",data)
		mSleep(1000)
		toast("提取成功！",1)
	else
		_追加写入("备用读取62数据.txt",wx,"----",data)
		mSleep(1000)
		toast("提取成功！",1)
	end	
else
	dialog("提取失败！", 0)
end	
local ts = require("ts")
mSleep(500)
status = ts.hlfs.makeDir("/private/var/mobile/Media/TouchSprite/res/微信") --新建文件夹
writeFileString(userPath().."/res/微信/62数据wxid.txt",wxid.."----未知密码----"..data,"a",1) --将 string 内容存入文件，成功返回 true
writeFileString(userPath().."/res/微信/62数据手机号.txt",wx.."----未知密码----"..data,"a",1) --将 string 内容存入文件，成功返回 true

end


----62数据登录流程
function newfolder(path) --创建文件夹
	return os.execute("mkdir "..path);
end
function _hexStringToFile(hex,file)
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
function _writeData(data) --写入62
	local wxdataPath = appDataPath('com.tencent.xin') .. '/Library/WechatPrivate/';
	newfolder(wxdataPath)
	os.execute('chown mobile ' .. wxdataPath)
	_hexStringToFile(data,wxdataPath .. 'wx.dat')
	os.execute('chown mobile ' .. wxdataPath .. 'wx.dat')
	return true
end
function _文件查找读取写入(path,str,nr)  --path路径，str要查找的文本，nr是新增文本,返回值是行内容和行数。
	local path = userPath().."/res/"..path
	local result
	if isFileExist(path) then
	else
		dialog("路径不存在！请检查", 0)
	end
	local 临时值 
	local data = readFileString(path)
	data = TryRemoveUtf8BOM(data)
	if data ~= "" and data ~= nil then
		local line = strSplit(data,"\r\n")
		for i = 1,#line do 
			if string.find(line[i],str) ~= nil then   ---如果真   找到，需要继续找
				--dialog(i.."="..line[i], 0)
			else
				result = line[i]
				临时值 = i
				break
			end	
		end	
		--dialog(临时值, 0)
		writeFileString(path,"","w")
		for k = 1,#line do
			if k == 临时值 then
				writeFileString(path,line[k]..nr.."\r\n","a")
				--writeFileString(path,"\n","a")
			else
				writeFileString(path,line[k].."\r\n","a")
			end	
		end	
	end	
	return result,临时值
end
function writeData(data) ---旧版本写入数据
	local getList = function(path)
		local a = io.popen("ls "..path)
		local f = {};
		for l in a:lines() do  
			table.insert(f,l) 
		end
		return f
	end 
	local Wildcard = getList("/var/mobile/Containers/Data/Application")
	for var = 1,#Wildcard do
		local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/wx.dat","wb") 
		if file then 
			require"sz"
			data = string.fromhex(data)
			os.execute('chown mobile '.."/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/")
			file:write(data)
			file:close()
			os.execute('chown mobile '.."/var/mobile/Containers/Data/Application/"..Wildcard[var].."/Library/WechatPrivate/wx.dat")
			return true  
		end  
	end
end
function TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end
function _写入62数据()
	local path = userPath().."/res/登录62数据.txt"

	local result
	if isFileExist(path) then
	else
		dialog("写入文件不存在！请检查", 0)
		lua_exit()
	end
	local data =  _文件查找读取写入("登录62数据.txt","已经读取","----已经读取")
	data = TryRemoveUtf8BOM(data)
	if data ~= "" and data ~= nil then
		local data = strSplit(data,"----")
		if #data > 2 then
			wxzh = data[1]
			wxmm = data[2]
			lesjk=data[3]
		end	
		_writeData(data[3])
		toast("写入成功！") 
		--sjkwj=data[3]

		result = true
	else
		dialog("登录失败！原因：写入62数据无效！", 0) 
		result = false
	end	
	return result
end
function _登录62流程()

	if _写入62数据() then
		mSleep(2000)

	else
		dialog("登录失败！请检查数据！", 0)
		lua_exit()
	end	
end




function 飞行模式切换IP流程()
toast('开启飞行模式',1)
setAirplaneMode(true);  --打开飞行模式
mSleep(1000)
setAirplaneMode(false); --关闭飞行模式
mSleep(6000)
toast('切换成功',1)
mSleep(1000)
end

function 爱伪装一键新机()
runApp("AWZ");
mSleep(1 * 3000);
local sz = require("sz");
local http = require("szocket.http");
local res, code = http.request("http://127.0.0.1:1688/cmd?fun=newrecord");
if code == 200 then
	local resJson = sz.json.decode(res);
	local result = resJson.result;
	if result == 1 then
		toast('一键新机成功-网络正常',1)
		mSleep(1000)
	end
	if result == 100 then
		toast('一键新机失败-网络不正常',1)
		closeApp('AWZ')
		网络情况()
		mSleep(1000)
		runApp('AWZ')
		mSleep(10000)
		return 爱伪装一键新机()
	end

end 
end

function 爱立思一键新机()

runApp("ALS");
mSleep(3000)
openURL("IGG://cmd/newrecord");
toast('一键新机',1)
mSleep(3000)
end

function 清理()
closeApp('com.tencent.xin')
mSleep(1000)
dataPath = appDataPath("com.tencent.xin");   
local ts = require("ts")
status = ts.hlfs.removeDir(dataPath.."/Documents")
status = ts.hlfs.removeDir(dataPath.."/tmp")
status = ts.hlfs.removeDir(dataPath.."/Library")
if status then
	dialog("清理成功",1)
	creatflag= ts.hlfs.makeDir(dataPath.."/Documents") 
	creatflag= ts.hlfs.makeDir(dataPath.."/tmp") 
	creatflag= ts.hlfs.makeDir(dataPath.."/Library")
	creatflag= ts.hlfs.makeDir(dataPath.."/Library/Caches")
	creatflag= ts.hlfs.makeDir(dataPath.."/Library/Preferences")
	mSleep(2000)
end
end




function 多点找色(id,x1,y1)

local 启动

if id == "第一登录界面"  then
	x,y = findMultiColorInRegionFuzzy( 0xededed,"0|1|0x000000,0|3|0xa6a6a6,0|4|0xa9a9a9,0|5|0x181818,0|9|0x3a3a3a,0|11|0x454545,0|15|0x000000",90,123,1022,211,1086)
	toast('登录',1)
end


if id=="用微信号登录" then
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0xadb6c9,"1|0|0x576b95,3|0|0xd4d8e0,6|0|0x909db7,7|0|0x576b95,15|0|0x576b95,18|0|0x576b95,26|0|0x62759c",90,42,524,201,573)
	mSleep(500)
	toast('用微信号登录',1)
end
if id=="输入微信号" then
	mSleep(500)
	x,y = findMultiColorInRegionFuzzy( 0xd2d2d2,"2|0|0xbcbcbc,7|0|0xc7c7c7,11|1|0xbcbcbc,14|1|0xbcbcbc,18|1|0xbcbcbc,21|1|0xbcbcbc",90,195,335,379,386)
	mSleep(500)
	toast('输入微信号',1)

end
if id=="登录上号" then
	x,y = findMultiColorInRegionFuzzy( 0x3cb93b,"1|0|0xdff4df,6|0|0xc9ecc9,10|0|0xb0e3b0,15|-1|0x1aad19,16|-1|0x7fd17f,20|-1|0xade2ad",90,275,594,366,652)
	mSleep(500)
	toast('登录上号',1)

end
if id=="登录识别存活" then
	x,y = findMultiColorInRegionFuzzy( 0x007aff,"5|-1|0x4ca1fd,19|-1|0x84bdfc,23|8|0xadd2fb,20|15|0x8fc3fb,13|23|0x3494fe,9|23|0x7bb9fc,-2|21|0xb6d7fb",90,424,672,486,723)
	mSleep(500)
	toast('识别存活',1)
end
if id == "我" then
	x,y = findMultiColorInRegionFuzzy( 0x7a7e83,"1|3|0xe2e2e3,1|5|0x9fa2a5,1|9|0xb0b2b5,13|10|0xa0a2a6,13|11|0x7a7e83,13|14|0x8a8d92,13|17|0xa4a7ab",90,525,1053,592,1108)
	mSleep(500)
	toast('我',1)
end

if id == "设置" then
	x,y = findMultiColorInRegionFuzzy( 0x95dbff,"0|1|0xd4f0ff,1|2|0x37bbff,7|2|0x4bc2ff,23|8|0x35bbff,25|7|0x4cc2ff,27|5|0xcbeeff,28|4|0xcbeeff",90,25,817,88,875)
	mSleep(500)
	toast('设置',1)
end
if id == "账号与安全" then
	x,y = findMultiColorInRegionFuzzy( 0xc1c1c1,"2|0|0xa9a9a9,5|-5|0x6d6d6d,7|0|0x909090,17|-5|0x565656,20|6|0x8c8c8c,21|11|0x323232,22|15|0x8c8c8c",90,26,184,105,222)
	mSleep(500)
	toast('账号与安全',1)
end

if id == "设置密码" then
	x,y = findMultiColorInRegionFuzzy( 0xb9b9b9,"0|-2|0xe0e0e0,1|-4|0xa9a9a9,10|-3|0xb4b4b4,18|-1|0x929292,20|-1|0x9f9f9f,21|2|0xdfdfdf,26|7|0xd2d2d2,29|12|0xc6c6c6",90,482,396,576,445)
	mSleep(500)
	toast('设置密码',1)
end

if id == "不能设置密码" then
	x,y = findMultiColorInRegionFuzzy( 0xcde2f9,"1|-1|0x4aa0fd,3|-1|0x3896fe,5|2|0x84bdfb,6|2|0x84bdfb,9|2|0x3695fe,12|2|0x85befb,16|2|0x96c6fb,18|2|0x96c6fb,21|2|0x58a7fd",90,278,677,356,725)
	mSleep(500)
	toast('不能设置密码',1)
end

if id == "封号" then
	x,y = findMultiColorInRegionFuzzy( 0x3e9df7,"0|1|0xa9d8ea,4|8|0x5aabf5,7|17|0x5aabf7,9|19|0x50a5f8,14|19|0x228cfc,14|26|0x59a9f9,21|26|0x459ffa",90,415,745,493,790)
		mSleep(500)
		toast('封号',1)
	end

if id == "旧密码" then
	x,y = findMultiColorInRegionFuzzy( 0xe2e2e5,"0|1|0xcdcdd2,2|2|0xd0d0d5,14|2|0xccccd1,14|16|0xc7c7cc,15|16|0xd2d2d6,16|15|0xebebed",90,203,398,275,438)
	mSleep(500)
	toast('旧密码',1)
end

if id == "输入新密码" then
	x,y = findMultiColorInRegionFuzzy( 0xeaeaec,"1|5|0xe8e8ea,5|17|0xdfdfe2,3|20|0xe8e8ea,9|22|0xd1d1d5,15|26|0xd5d5d9,12|26|0xd5d5d9,12|28|0xebebed",90,241,344,283,396)
	mSleep(500)
	toast('输入新密码',1)
end

if id == "再次输入新密码" then
	x,y = findMultiColorInRegionFuzzy( 0xd3d3d7,"0|4|0xd6d6da,0|6|0xcfcfd4,8|11|0xccccd1,8|20|0xd6d6da,8|26|0xcfcfd4,10|27|0xd3d3d7,7|29|0xe3e3e6",90,239,432,278,481)
	mSleep(500)
	toast('再次输入新密码',1)
end

if id == "改密完成" then
	x,y = findMultiColorInRegionFuzzy( 0x2f6332,"1|2|0x289c29,1|5|0x2a8a2c,1|17|0x2d802f,9|26|0x2c882e,14|25|0x335a37,17|24|0x326035,22|24|0x2d822f",90,552,65,622,108)
	mSleep(500)
	toast('改密完成',1)
end









	local x1=x1 or x
	local y1=y1 or y
	if x1==0 or y1==0 then
		if x ~= -1  and y ~= -1 then
			启动= true
		else
			启动= false
		end
	else	
		if x ~= -1  and y ~= -1 then
			tap(x1,y1)
			mSleep(500)
			nLog(id)
			启动=true
		else
			启动=false
			nLog('未知界面')
			mSleep(500)
		end	
	end
	return 启动,x,y
-- body
end








一键清理 = function (bid)
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
	if bid == nil or type(bid) ~= "string" then dialog("一键清理传入的bid有问题"); return false end
	toast("一键清理,请勿中止",10);
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
	toast("一键清理",2);
	os.execute("chmod -R 777 "..dataPath.."/Documents");
	os.execute("chmod -R 777 "..dataPath.."/tmp");
	os.execute("chmod -R 777 "..dataPath.."/Library");
	os.execute("chmod -R 777 "..dataPath.."/Library/Preferences");
	mSleep(500)
	clearCache();
end



function 运行()
一键清理("com.tencent.xin")
mSleep(2000)
_登录62流程()
mSleep(3000)
--获取ip()
runApp("com.tencent.xin")
mSleep(5000)
local  key = "ReturnOrEnter"   --模拟回车键
while (true) do



	if	多点找色("第一登录界面",x1,y1) then
		mSleep(1000)
	end


	if	多点找色("用微信号登录",x1,y1) then
		mSleep(1000)
	end


	if 	多点找色("输入微信号",x1,y1)  then
		mSleep(1000)
		inputKey(wxzh)
		mSleep(1000)
		keyDown(key)
		keyUp(key)
		mSleep(1000)
		inputKey(wxmm)
		mSleep(1000)
		keyDown(key)
		keyUp(key)
		mSleep(500)
	end

	if	多点找色("点击确定")  then
		mSleep(2000)
		break	
	end
end
end






function 登录识别界面()
while (true) do

	if	多点找色("封号",x1,y1) then
		mSleep(1000)
		return 主控制()
	end

	if	多点找色("登录识别存活",x1,y1) then
		mSleep(1000)
		break
	end

end
end


function 运行改密()
while (true) do

	if	多点找色("我",x1,y1) then
		mSleep(1000)
	end

	if	多点找色("设置",x1,y1) then
		mSleep(1000)
	end

	if	多点找色("账号与安全",x1,y1) then
		mSleep(1000)
	end

	if	多点找色("设置密码",x1,y1) then
		mSleep(1000)
	end

	if	多点找色("不能设置密码",x1,y1) then
		mSleep(2000)
		return 主控制()
	end
	
	if	多点找色("旧密码",x1,y1) then
		mSleep(1000)
		inputKey(wxmm)
		mSleep(1000)
		keyDown(key)
		keyUp(key)
		mSleep(1000)
		break
	end
end
end


function 改密()
while (true) do
	if 多点找色("输入新密码",x1,y1) then
		mSleep(1000)
		inputText("asd1122334")
		mSleep(1000)
	end
	if 多点找色("再次输入新密码",x1,y1) then	
		mSleep(1000)
		inputText("asd1122334")
		mSleep(1000)
	end
	if 多点找色("改密完成",x1,y1) then		
		mSleep(50000)
		return 主控制()
	end
end
end




function 主控制()
mSleep(1000)
closeApp("com.tencent.xin")
mSleep(2000)
飞行模式切换IP流程()
运行()
登录识别界面()
运行改密()
改密()
end


function 无限()
while (true) do
	主控制()
	toast('运行完成',10)
end
end
无限()




