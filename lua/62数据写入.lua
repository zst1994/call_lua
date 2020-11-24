require("TSLib")

function fileToHexString(file)--字符串转十六进制
	local file = io.open(file, 'rb');
	local data = file:read("*all");
	file:close();
	local t = {};
	for i = 1, string.len(data),1 do
		local code = tonumber(string.byte(data, i, i));
		table.insert(t, string.format("%02x", code));
	end
	return table.concat(t, "");
end

function hexStringToFile(hex)--十六进制转字符串
	local data = '';
	for i = 1, string.len(hex),2 do
		local code = string.sub(hex, i, i+1);
		data =data..string.char(tonumber(code,16));
	end  
	return data
end

function file_exists(file_name)--检测指定文件是否存在
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function readFile(file)
	assert(file,"file open failed")
	local fileTab = {}
	local line = file:read()
	while line do
		print("get line",line)
		table.insert(fileTab,line)
		line = file:read()
	end
	return fileTab
end --封装好 不用改

function writeFile(file,fileTab)
	assert(file,"file open failed")
	for i,line in ipairs(fileTab) do
		print("write ",line)
		file:write(line)
		file:write("\n")
	end
end

function file_get_line(path,n) --获取一个文本文件指定行的数据
	local file = io.open(path,"r");--用读模式打开一个文件
	if file then
		local _list = {};
		for l in file:lines() do 
			table.insert(_list,l)
		end
		file:close();--关闭默认的输出文件
		return _list[n]
	end
end

function file_remove_line(filePath,n)--移除文件中指定行
	local fileRead = io.open(filePath)
	if fileRead then
		local tab = readFile(fileRead)
		fileRead:close()              
		table.remove(tab,n)
		local fileWrite = io.open(filePath,"w")
		if fileWrite then
			writeFile(fileWrite,tab)
			fileWrite:close()
		end
	end
end

function split(input, delimiter)--分割字符串
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter=='') then return false end
	local pos,arr = 0, {}
	-- for each divider found
	for st,sp in function() return string.find(input, delimiter, pos, true) end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

local WeiChat_Token = {  --62读写
	Read = (function()
			bid = 'com.tencent.xin'
			if appDataPath(bid) == '' then return false end
			if not file_exists(appDataPath(bid) .. '/Library/WechatPrivate/wx.dat') then return false end
			f = io.open(appDataPath(bid) .. '/Library/WechatPrivate/wx.dat', 'rb')
			if not f then return end
			local s =  fileToHexString(appDataPath(bid)..'/Library/WechatPrivate/wx.dat');
			f:close()
			return s
		end),

	Write = (function(_data)
			bid = 'com.tencent.xin'
			path = appDataPath("com.tencent.xin")
			if appDataPath(bid) == '' then return false end
			os.execute("mkdir -p " .. path .. '/Library/WechatPrivate/')
			local wxsj = hexStringToFile(_data) mSleep(1000)
			file_writes(path..'/Library/WechatPrivate/wx.dat', wxsj) 
			os.execute("chown -R mobile:mobile " .. path .. '/Library/WechatPrivate/')
			os.execute('chmod -R 755 ' .. path .. '/Library/WechatPrivate/')
			return true
		end)
}

function file_appends(Path,str)--追加写入文件
	local file = io.open(Path,"a")
	file:write(str)
	file:close()
end 

function file_writes(Path,str)--覆盖写入文件
	local file = io.open(Path,"w")    
	file:write(str)
	file:close()
end

function 写入62()
	local data = file_get_line("/var/mobile/Media/TouchSprite/res/62数据.txt",1); --文本格式 账号----密码----62；
	local data =split(data,"----");
	phone = data[1];
	psw = data[2];
	Wxdata = data[3];
	WeiChat_Token.Write(Wxdata)
	file_remove_line("/var/mobile/Media/TouchSprite/res/62数据.txt",1);
	mSleep(1000)
	toast('写入成功',1)
end

function 提取62()
	file_appends("//var/mobile/Media/TouchSprite/res/提取62.txt",WeiChat_Token.Read().."\r\n")
	toast("提取62成功",5000)
end

--封装好 不用改

function 多点找色(id,x1,y1)
	local 启动

	if id == "登录界面"  then
		x,y = findMultiColorInRegionFuzzy( 0xb3b3b3, "-1|17|0xb3b3b3,7|17|0xb3b3b3,22|17|0xb3b3b3,38|15|0xb3b3b3,44|15|0xb3b3b3", 90, 177, 157, 461, 217)
		toast('登录界面',1)
	end

	if id == "其他方式登录" then
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "6|0|0x576b95,25|-2|0x576b95,61|-1|0x576b95,82|-1|0x576b95,109|-1|0x576b95", 90, 178, 514, 518, 1114)
		mSleep(500)
		toast('其他方式登录',1)
	end

	if id == "使用账号和密码登录" then
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "2|1|0xffffff,5|1|0xe1f7ec,14|-1|0x07c160,15|-1|0x07c160,21|-1|0xe1f7ec,23|-1|0xabeac9,26|1|0xadeaca", 90, 492, 53, 608, 112)
		mSleep(500)
		toast('使用账号和密码登录',1)
	end

	if id == "登录" then
		x,y = findMultiColorInRegionFuzzy( 0xd1d1d3, "7|0|0xd3d3d5,7|4|0xd3d3d5,6|5|0xd3d3d5,6|6|0xd3d3d5,7|7|0xd3d3d5", 90, 484, 68, 519, 100)
		mSleep(500)
		toast('登录',1)  

	end

	if id=="登录成功" then
		x,y = findMultiColorInRegionFuzzy( 0x9a9a9a, "1|0|0x9a9a9a,12|1|0xa0a0a0,26|1|0xa0a0a0,31|1|0xa0a0a0,32|3|0x9a9a9a", 90, 558, 71, 612, 102)
		mSleep(500)
		toast('登录成功',1)    

	end

	local x1 = x1 or x
	local y1 = y1 or y
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
end

function 登录流程()
	写入62()
	mSleep(1000)
	runApp("com.tencent.xin")
	mSleep(3000)
	local  key = "ReturnOrEnter"   --模拟回车键
	while (true) do
		if	多点找色("登录界面",x1,y1) then
		end

		if	多点找色("其他方式登录",x1,y1) then
		end

		if 	多点找色("使用账号和密码登录",x1,y1)  then
			mSleep(1000)
			inputText(phone)
			mSleep(1000)
			keyDown(key)
			keyUp(key)
			mSleep(1000)
			inputText(psw)
			mSleep(1000)
			keyDown(key)
			keyUp(key)
			mSleep(500)
		end

		if	多点找色("登录",x1,y1) then
		end
	end
end

--登录流程()


写入62()