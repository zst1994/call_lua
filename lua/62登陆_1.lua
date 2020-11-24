require("TSLib")

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
	local path = userPath().."/res/62数据.txt"

	local result
	if isFileExist(path) then
	else
		dialog("写入文件不存在！请检查", 0)
		lua_exit()
	end
	local data =  _文件查找读取写入("62数据.txt","已经读取","----已经读取")
	data = TryRemoveUtf8BOM(data)
	if data ~= "" and data ~= nil then
		local data = strSplit(data,"----")
		if #data > 2 then
			wxzh = data[1]
			wxmm = data[2]
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
		mSleep(1000)

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
if id=="返回" then
	x,y = findMultiColorInRegionFuzzy( 0x9a9a9a, "1|0|0x9a9a9a,12|1|0xa0a0a0,26|1|0xa0a0a0,31|1|0xa0a0a0,32|3|0x9a9a9a", 90, 558, 71, 612, 102)

end
if id == "该用户不存在" then
	x,y = findMultiColorInRegionFuzzy( 0x898989, "3|1|0x888888,7|1|0x888888,12|1|0x888888,34|1|0x888888,55|-1|0x939393", 90, 251, 197, 324, 279)

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




function 运行()
清理()
_登录62流程()
--mSleep(1000)
----获取ip()
--runApp("com.tencent.xin")
--mSleep(3000)
--local  key = "ReturnOrEnter"   --模拟回车键
--while (true) do

--	if	多点找色("第一登录界面",x1,y1) then
--		mSleep(1000)
--	end


--	if	多点找色("用微信号登录",x1,y1) then
--		mSleep(1000)
--	end


--	if 	多点找色("输入微信号",x1,y1)  then
--		mSleep(1000)
--		inputKey(wxzh)
--		mSleep(1000)
--		keyDown(key)
--		keyUp(key)
--		mSleep(1000)
--		inputKey(wxmm)
--		mSleep(1000)
--		keyDown(key)
--		keyUp(key)
--		mSleep(500)
--	end

--	if	多点找色("点击确定")  then
--		mSleep(1000)
--		break	
--	end
--end
end



function 主控制()
mSleep(1000)
closeApp("com.tencent.xin")
mSleep(2000)
--飞行模式切换IP流程()
运行()

end
主控制()
toast('运行完成',10)