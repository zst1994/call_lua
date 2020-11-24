rets, input1,input2,input3,input4,input5,input6,input7,input8,input9,input10,input11,input12,input13,input14,input15,input16,input17= showUI("{\"style\":\"default\","
	.."\"width\":\"2000\","
	.."\"height\":\"2000\","
	.."\"config\":\"陌陌.dat\","
	.."\"timer\":\"99\","
	.."\"orient\":\"0\","
	.."\"title\":\"提供一手线报免费用脚本\","
	.."\"cancelname\":\"取消\","
	.."\"okname\":\"开始\","  
	.."\"views\":["
	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
	.."{\"type\":\"CheckBoxGroup\",\"list\":\"通道1,通道5,修改名字\",\"select\":\"2\"},"-------------------1
	.."{\"type\":\"Label\",\"text\":\"--年--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------2
	.."{\"type\":\"Edit\",\"prompt\":\"年\",\"text\":\"\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\"},"-------------------2
	.."{\"type\":\"Label\",\"text\":\"--月--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------3
	.."{\"type\":\"Edit\",\"prompt\":\"\",\"text\":\"\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\"},"-------------------3
	.."{\"type\":\"Label\",\"text\":\"--号段--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------4
	.."{\"type\":\"Edit\",\"prompt\":\"6\",\"text\":\"45\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------4
	.."{\"type\":\"CheckBoxGroup\",\"list\":\"aa,bb\",\"select\":\"0\"},"-------------------5
	.."{\"type\":\"RadioGroup\",\"list\":\"a,b,c\",\"select\":\"0\"},"-------------------6
	.."{\"type\":\"Label\",\"text\":\"--aaa--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------7
	.."{\"type\":\"Edit\",\"prompt\":\"680\",\"text\":\"4000\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------7
	.."{\"type\":\"Label\",\"text\":\"--注册多少个--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------8
	.."{\"type\":\"Edit\",\"prompt\":\"请填写数字\",\"text\":\"30\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------8
	.."{\"type\":\"Label\",\"text\":\"--运行次数--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------9
	.."{\"type\":\"Edit\",\"prompt\":\"请填写数字\",\"text\":\"30\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------9
	.."]}")
local t,sz = pcall(require,"sz")
require "TSLib"--使用本函数库必须在脚本开头引用并将文件放到设备 lua 目录下
local ts 				= require('ts')
local json 				= ts.json
local http = require("szocket.http")


function readFile(path)--按行读取函数
	local file = io.open(path,"r");--打开文件
	if file then--条件：文件值为真
		local _list = {};
		for l in file:lines() do
			table.insert(_list,l)
		end
		file:close()--关闭文件
		return _list--放回文件
	end
end

function afile(a,b)--换行保存文件函数
	file = io.open(b,"a") --打开文件
	file:write("\n"..a)--换行保存文件
	file:close()--关闭文件
end

function file_exists(file_name)--判断指定文件是否存在
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function 访问(url)
	local ts = require("ts")
	header_send = {typeget = "ios"}
	ts.setHttpsTimeOut(59)--安卓不支持设置超时时间
	status_resp, header_resp,body_resp = ts.httpGet(url, header_send, body_send)
	nLog(body_resp)
	return body_resp
end

function utf8加密(id)---需要加载sz裤支持
	local iconv = sz.iconv
	id=id:tohex()--转为16进制
	id=string.upper(id);--到大写
	local 分割后文本=id:fromgbk()
	local m=0
	local ad=""
	for i=2 , tonumber(#分割后文本) ,2 do
		if i ~= tonumber(#分割后文本) then
			ad=ad..string.sub(分割后文本,i-1,i).."%"
		else
			ad=ad..string.sub(分割后文本,i-1,i)
		end
	end
	return "%"..ad
end

function 获取任务编号并下发任务()
	local qr = require("tsqr")

	snapshot("1.png",0, 0, 749, 1333)
	mSleep(1000)
	str = qr.qrDecode(userPath().."/res/1.png") 
	nLog(str)
	二维码=utf8加密(str)
	nLog(二维码)
	a=访问("http://122.114.5.43/wechat/api/getid.php?userName=a115&passWord=a115&taskId=2")
	nLog(a)
	delFile(userPath().."/res/1.png")---删除二维码截图
	resJson = sz.json.decode(a);
	detailId = resJson.detailId;
	atId=resJson.atId
	projectId=resJson.projectId
	nLog(detailId)
	nLog(atId)
	nLog(projectId)
	a=访问("http://122.114.5.43/wechat/api/sendtask.php?userName=a115&passWord=a115&atId="..atId.."&projectId="..projectId.."&detailId="..detailId.."&reqUrl="..二维码)
	nLog(a)
	resJson = sz.json.decode(a);
	code = resJson.code;
	if tonumber(code) == 0 then

		return 0
	else
		return 1
	end
end

function click(x,y,z)--点击函数 --一下math.random 是随机的函数
	mSleep(math.random(30,50))--mSleep是触动官方延迟函数
	touchDown(1, x, y)
	mSleep(math.random(30,50))
	touchMove(x, y)
	mSleep(math.random(30,50)) 
	touchUp(1, x, y)
	mSleep(math.random(30,50))
	if z then
		nLog(z)
		--fwShowTextView("wid","textid",z.."","center","FF0000","FFDAB9",20,0,0,0,169,   42,1)------显示窗口
		fwShowTextView("wid","textid",z.."","center","FF0000","FFDAB9",20,0,0,0,297,   42,1)------显示窗口
	end
end

function isColor(x,y,c,s)--找色函数
	local ce,abs,fl = math.ceil,math.abs,math.floor
	local s = ce(0x100*(100-s)*0.01)
	local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
	local rr,gg,bb = getColorRGB(x,y)
	if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
		return true
	end
end

function findColor()
	local x, y = findMultiColorInRegionFuzzy(0x00a4e3,"-24|-4|0xffd801,11|21|0xe50a13,13|-20|0x2fb046",90,22,238,106,448)
	if x>0 then
		return (x..","..y)
	end 
end

function ip获取()--ip格式化
	while (true) do
		ip = getNetIP() --获取IP
		if ip ~= false and #ip > 4 then
			dialog(ip, 1)
			mSleep(200)
			return ip
		end
		toast("获取ip失败",1)
		mSleep(1000)
	end
end

function 飞行VPN()--VPN操作过程
	--local ip0=ip()--获取当前IP
	setAirplaneMode(true)
	mSleep(6000)
	setAirplaneMode(false)
	mSleep(8000)
	while true do--循环
		local ipg=ip获取()
		if ipg then--看是否联网了
			toast(ipg,1)
			break
		end
	end
end

function VPN()--VPN操作过程
	setVPNEnable(false)
	mSleep(4000)
	setVPNEnable(true)
	mSleep(4000)
	while true do--循环
		local flag = getVPNStatus()--检查VPN状态
		if flag.active then
			fwShowTextView("wid","textid","vpn已连接","center","FF0000","FFDAB9",20,0,0,0,297,   42,1)------显示窗口
			mSleep(2000)
			local x,y = findMultiColorInRegionFuzzy( 0x007aff, "4|14|0x007aff,17|13|0xc2ddfa,18|13|0x007aff,24|-6|0x007aff,24|-7|0x99c8fb,26|7|0x007aff,27|7|0x5aa7fd,31|7|0xf8f8f8", 90, 334,  754, 411,  818)
			if x > 0 then
				click(373,  780,"好-vpn无法连接")
				mSleep(1000)
				setVPNEnable(true)
				mSleep(4000)
			else
				return true
			end
		else
			local x,y = findMultiColorInRegionFuzzy( 0x007aff, "4|14|0x007aff,17|13|0xc2ddfa,18|13|0x007aff,24|-6|0x007aff,24|-7|0x99c8fb,26|7|0x007aff,27|7|0x5aa7fd,31|7|0xf8f8f8", 90, 334,  754, 411,  818)
			if x > 0 then
				click(373,  780,"好-vpn无法连接")
				mSleep(1000)
			end
			fwShowTextView("wid","textid","打开vpn","center","FF0000","FFDAB9",20,0,0,0,297,   42,1)------显示窗口
			setVPNEnable(true)
			mSleep(5000)
		end
	end
end

function  getNickName()
	nickName_tb = readFile(userPath().."/lua/昵称.txt") 
	if table then 
		nickName = nickName_tb[1]:atrim()
		table.remove(nickName_tb, 1)
		writeFile(userPath().."/lua/昵称.txt",nickName_tb,"w",1) --将 table 内容存入文件，成功返回 true
		return nickName
	else
		dialog("文件不存在")
	end
end

function getMMId(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		b = string.find(l, 'u.(%d%d%d%d%d%d%d%d%d)_main.sqlite')
		if type(b) ~= "nil" then
			c = string.match(l, '%d%d%d%d%d%d%d%d%d')
			return c
		end
	end
end

function gaiji()
	runApp("YOY");
	mSleep(1000)
	local x,y = findMultiColorInRegionFuzzy( 0x007aff, "4|14|0x007aff,17|13|0xc2ddfa,18|13|0x007aff,24|-6|0x007aff,24|-7|0x99c8fb,26|7|0x007aff,27|7|0x5aa7fd,31|7|0xf8f8f8", 90, 334,  754, 411,  818)
	if x > 0 then
		click(373,  780,"改机vpn卡段")
		mSleep(1000)
		VPN()
	end
	local 返回=http.request("http://127.0.0.1:1688/cmd?fun=newrecord")
	fwShowTextView("wid","textid",返回,"center","FF0000","FFDAB9",20,0,0,0,297,   42,1)------显示窗口
	mSleep(4000)
end

function gaican()
	runApp("YOY");
	mSleep(1000)
	if 老号== 1 then
		httpGet("http://127.0.0.1:1688/cmd?fun=renamecurrentrecord&name=laohao")
	else
		httpGet("http://127.0.0.1:1688/cmd?fun=renamecurrentrecord&name="..mm_id)
		afile(mm_id,"/var/mobile/Media/TouchSprite/lua/momo.txt")
	end
	老号=0
	mSleep(2000)
end

function 选择生日()
	local nn=1995 - tonumber(input2)
	if nn > 0 then
		for i=1,nn do
			click(213, 1053,i.."年")
			mSleep(500)
		end
	end

	if nn < 0 then
		nn=tonumber(input2) - 1995
		for i=1,nn do
			click(216, 1179,i.."年")
			mSleep(500)
		end
	end

	local yy=8 - tonumber(input3)
	if yy > 0 then
		for i=1,yy do
			click(358, 1055,i.."月")
			mSleep(500)
		end
	end

	if yy < 0 then
		yy = tonumber(input3) - 8
		for i=1,yy do
			click(359, 1181,i.."月")
			mSleep(500)
		end
	end

	if 点日期==1 then
		for i=1,记录 do
			click(522, 1178,i.."日")
			mSleep(500)
		end
	end
end

function mo()
	老号=0
	生日=0
	微信登录=0
	倒计时=0
	开始记录=0
	授权成功=0
	pressHomeKey(0);    --按下 Home 键
	pressHomeKey(1);    --抬起 Home 键
	mSleep(2000)
	runApp("com.wemomo.momoappdemo1")
	mSleep(1500)
	--	if (isColor(  99, 1241, 0x7c73ff, 70) and 
	--isColor( 112, 1240, 0xffffff, 70) and 
	--isColor( 124, 1241, 0x7c73ff, 70) and 
	--isColor( 139, 1240, 0xffffff, 85) and 
	--isColor(  90, 1271, 0xf960c9, 70)) then
	--end

	while (true) do
		--		if  frontAppBid() ~= "com.wemomo.momoapppdemo1" and 微信登录==0 then --如NZT不在前台，则启动NZT
		--			mSleep(1000)
		--		runApp("com.wemomo.momoapppdemo1")
		--		mSleep(1500)
		--	   end
		if (isColor( 103, 1224, 0x000000, 85) and 
			isColor( 120, 1117, 0x000000, 85) and 
			isColor(  77, 1165, 0x000000, 85) and 
			isColor( 628, 1214, 0x000000, 85) and 
			isColor( 651, 1134, 0x000000, 85) and 
			isColor( 674, 1177, 0x000000, 85) and 
			isColor( 360, 1125, 0x000000, 85) and 
			isColor( 387, 1205, 0x000000, 85)) then
			click(374, 1175,"手机号登录")
			mSleep(1000)
			微信登录=1
		end
		
		if (isColor( 258, 1184, 0x18d9f1, 85) and 
			isColor( 265, 1111, 0x18d9f1, 85) and 
			isColor( 477, 1190, 0x18d9f1, 85) and 
			isColor( 490, 1115, 0x18d9f1, 85) and 
			isColor( 375, 1107, 0x18d9f1, 85) and 
			isColor( 378, 1188, 0x18d9f1, 85) and 
			isColor(  90, 1274, 0x32d8f3, 65) and 
			isColor( 107, 1274, 0xfdfcfd, 85)) then
			click(383, 1145,"注册登录4")
			mSleep(800)
		end
		
		if (isColor( 111, 1130, 0x000000, 85) and 
			isColor( 117, 1038, 0x000000, 85) and 
			isColor(  79, 1096, 0x000000, 85) and 
			isColor( 635, 1138, 0x000000, 85) and 
			isColor( 642, 1046, 0x000000, 85) and 
			isColor( 526, 1100, 0x000000, 85) and 
			isColor( 378, 1044, 0x000000, 85)) then
			click(363, 1084,"手机号登录2")
			mSleep(1000)
			微信登录=1
		end

		if (isColor( 156, 1191, 0x0ec600, 85) and 
			isColor( 205,  525, 0xd8d8d8, 85) and 
			isColor( 333,   98, 0xffffff, 85) and 授权成功==0) then
			click(188, 1186,"微信3")
			mSleep(500)
			微信登录=1
		end
		
		if (isColor( 377, 1107, 0x0ec600, 85) and 
			isColor( 372, 1182, 0x0ec600, 85) and 
			isColor( 331, 1144, 0x0ec600, 85) and 
			isColor( 418, 1149, 0x0ec600, 85) and 授权成功==0) then
			click(376, 1154,"微信5")
			mSleep(500)
			微信登录=1
		end
		
		if (isColor( 370, 1235, 0x0ec600, 85) and 
			isColor( 379, 1145, 0x0ec600, 85) and 
			isColor( 419, 1189, 0x0ec600, 85) and 
			isColor( 329, 1191, 0x0ec600, 85) and 授权成功==0) then
			click(369, 1190,"微信4")
			mSleep(500)
			微信登录=1
		end
		
		if (isColor(371,1195,0x0ec600,85) and
			isColor(379,1105,0x0ec600,85) and
			isColor(327,1152,0x0ec600,85) and
			isColor(412,1154,0x0ec600,85) and
			isColor(244,540,0xd8d8d8,85) and 授权成功==0) then
			click(371,1154,"微信6")
			mSleep(500)
			微信登录=1
		end
		
		if (isColor( 191, 1154, 0x0ec600, 85) and 
			isColor( 189, 1234, 0x0ec600, 85) and 
			isColor( 140, 1186, 0x0ec600, 85) and 
			isColor( 180,  523, 0xd8d8d8, 85) and 
			isColor( 203,  870, 0xffffff, 85) and 授权成功==0) then
			click(188, 1186,"微信1")
			mSleep(500)
			微信登录=1
		end
		
---------------
		if (isColor(  56, 1219, 0x3fe6e4, 70) and 
			isColor(  90, 1215, 0x33d9f0, 70) and 
			isColor(  71, 1202, 0x35dbef, 70) and 
			isColor( 258, 1115, 0x18d9f1, 85) and 
			isColor( 262, 1052, 0x18d9f1, 85) and 
			isColor( 469, 1117, 0x18d9f1, 85) and 
			isColor( 491, 1044, 0x18d9f1, 85) and 
			isColor( 378, 1041, 0x18d9f1, 85) and 
			isColor( 367, 1115, 0x18d9f1, 85) and 
			isColor(  73, 1216, 0xfdfcfd, 85)) then
			click(384, 1081,"注册登录")
			mSleep(600)
		end
		
		if (isColor( 212,  139, 0xffffff, 85) and 
			isColor( 194,  573, 0xd8d8d8, 85) and 
			isColor( 173,  860, 0xffffff, 85) and 
			isColor( 145, 1151, 0x0ec600, 85) and 
			isColor( 225, 1152, 0x0ec600, 85) and 授权成功==0) then
			click(181, 1151,"微信2")
			mSleep(600)
		end

------------
		if (isColor( 266,  169, 0xffffff, 85) and 
			isColor( 493,  170, 0x00beff, 85) and 
			isColor( 422, 1045, 0x00beff, 85) and 
			isColor(  84, 1049, 0x00beff, 85) and 授权成功==0) then
			if (isColor( 202,  607, 0xffffff, 85) and 
				isColor( 220,  588, 0x000000, 85) and 
				isColor( 201,  259, 0xffffff, 85) and 
				isColor( 220,  279, 0x000000, 85) and 
				isColor( 527,  277, 0x000000, 85) and 
				isColor( 511,  257, 0xffffff, 85)) then
				if string.find(input1.."","0")~= nil  then
					click(195,  735,"通道1")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
				if string.find(input1.."","1")~= nil  then
					click(197, 1031,"通道4")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
			end
		end
		
		if (isColor(479,186,0x00beff,85) and
			isColor(721,181,0x00beff,85) and
			isColor(176,1049,0x00beff,85) and
			isColor(526,1050,0x00beff,85) and 授权成功==0) then
			if (isColor(221,278,0x000000,85) and
				isColor(241,279,0xffffff,85) and
				isColor(533,279,0x000000,85) and
				isColor(550,279,0xffffff,85) and
				isColor(222,581,0x000000,85) and
				isColor(242,583,0xffffff,85)) then
				if string.find(input1.."","0")~= nil  then
					click(194,  732,"通道1")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
				if string.find(input1.."","1")~= nil  				then
					click(190,1034,"通道4b")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
			end
		end
		
		if (isColor( 478,  139, 0x00beff, 85) and 
			isColor( 723,  147, 0x00beff, 85) and 
			isColor( 154, 1053, 0x00beff, 85) and 
			isColor( 518, 1049, 0x00beff, 85) and 
			isColor( 172, 1083, 0xffffff, 85) and 授权成功==0) then
			if (isColor( 222,  275, 0x000000, 85) and 
				isColor( 240,  258, 0xffffff, 85) and 
				isColor( 526,  281, 0x000000, 85) and 
				isColor( 526,  255, 0xffffff, 85) and 
				isColor( 224,  585, 0x000000, 85) and 
				isColor( 225,  606, 0xffffff, 85)) then
				if string.find(input1.."","0")~= nil  then
					click(194,  732,"通道1")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
				if string.find(input1.."","1")~= nil  				then
					click(195, 1027,"通道4a")
					mSleep(9000)
					授权成功=1
					开始记录=1
				end
			end
		end
		
		if (isColor( 713,   75, 0x0078cc, 85) and 
			isColor( 307,  721, 0xefeff0, 85) and 
			isColor( 588,  718, 0xf0f0f0, 85) and 
			isColor( 712,  709, 0xcccccc, 85) and 
			isColor( 692, 1276, 0xc7c7c7, 85) and 
			isColor( 138, 1274, 0x0061cc, 85)) then
			mSleep(1000)
			click(503,  723,"打开")
		end
		
		if (isColor( 345,  715, 0x007aff, 85) and 
			isColor( 351,  731, 0x007aff, 85) and 
			isColor( 370,  727, 0x007aff, 85) and 
			isColor( 371,  727, 0x6fb3fc, 85) and 
			isColor( 372,  727, 0xf9f9f9, 85) and 
			isColor( 362,  734, 0x007aff, 85) and 
			isColor( 357,  748, 0xf9f9f9, 85) and 
			isColor( 177,  541, 0x828282, 85) and 
			isColor( 578,  532, 0x828282, 85) and 
			isColor( 408, 1131, 0x087700, 85)) then
			老号=1
			dialog("非法请求", 1)
			mSleep(1000)
			return true
		end
		if (isColor( 106,  871, 0xd8d8d8, 85) and 
			isColor( 117,  800, 0xd8d8d8, 85) and 
			isColor( 635,  867, 0xd8d8d8, 85) and 
			isColor( 650,  805, 0xd8d8d8, 85) and 
			isColor( 547,  826, 0xd8d8d8, 85) and 
			isColor( 235,  819, 0xd8d8d8, 85) and 
			isColor( 402,  645, 0x18d9f1, 85) and 
			isColor( 546,  646, 0x18d9f1, 85) and 
			isColor( 349,  645, 0xffffff, 85)) then
			click(181,  607,"默认男生选女生")
			mSleep(500)
			倒计时=1
		end
		
		if (isColor( 105,  883, 0xd8d8d8, 85) and 
			isColor( 120,  792, 0xd8d8d8, 85) and 
			isColor( 628,  876, 0xd8d8d8, 85) and 
			isColor( 663,  794, 0xd8d8d8, 85) and 
			isColor( 527,  834, 0xd8d8d8, 85) and 
			isColor( 340,  906, 0xffffff, 85) and 
			isColor( 523,  648, 0xb3b3b3, 85) and 
			isColor( 523,  646, 0xffffff, 85) and 
			isColor( 169,  648, 0xb3b3b3, 85) and 
			isColor( 169,  647, 0xffffff, 85)) then
			click(187,  605,"啥都没选选女生")
			mSleep(500)
			倒计时=1
		end
		if (isColor( 126,  927, 0xd8d8d8, 85) and 
			isColor( 126,  856, 0xd8d8d8, 85) and 
			isColor( 613,  912, 0xd8d8d8, 85) and 
			isColor( 636,  859, 0xd8d8d8, 85) and 
			isColor( 430,  694, 0x18d9f1, 85) and 
			isColor( 431,  703, 0xffffff, 85) and 
			isColor( 586,  693, 0x18d9f1, 85) and 
			isColor( 316,  694, 0xffffff, 85)) then
			click(205,  661,"选难受的选女生")
			mSleep(500)
			倒计时=1
		end
		
		if (isColor( 122,  924, 0xd8d8d8, 85) and 
			isColor( 136,  848, 0xd8d8d8, 85) and 
			isColor( 645,  893, 0xd8d8d8, 85) and 
			isColor( 340,  693, 0xff2d55, 85) and 
			isColor( 118,  693, 0xff2d55, 85) and 生日==0) then  
			倒计时=1
			click(170,  538,"生日2")
			mSleep(1000)
			选择生日()
			mSleep(500)
			click(628,  168,"空白2")
			生日=1
		end
		
		if (isColor( 114,  923, 0xd8d8d8, 85) and 
			isColor( 122,  848, 0xd8d8d8, 85) and 
			isColor( 638,  924, 0xd8d8d8, 85) and 
			isColor( 638,  862, 0xd8d8d8, 85) and 
			isColor( 534,  879, 0xd8d8d8, 85) and 
			isColor( 164,  873, 0xd8d8d8, 85) and 
			isColor( 184,  696, 0xb3b3b3, 85) and 
			isColor( 184,  695, 0xffffff, 85) and 
			isColor( 553,  696, 0xb3b3b3, 85) and 
			isColor( 553,  695, 0xffffff, 85)) then
			click(172,  655,"点女生")
			mSleep(600)
			倒计时=1
		end
		
		if (isColor( 121,  875, 0xd8d8d8, 85) and 
			isColor( 131,  799, 0xd8d8d8, 85) and 
			isColor( 617,  861, 0xd8d8d8, 85) and 
			isColor( 622,  801, 0xd8d8d8, 85) and 
			isColor( 475,  838, 0xd8d8d8, 85) and 
			isColor(  83,  645, 0xff2d55, 85) and 
			isColor( 244,  646, 0xff2d55, 85) and 
			isColor( 341,  645, 0xff2d55, 85) and 
			isColor( 339,  655, 0xffffff, 85) and 生日==0) then
			click(171,  493,"生日")
			mSleep(1000)
			选择生日()
			mSleep(500)
			click(628,  168,"空白")
			生日=1
			倒计时=1
		end
		
		if (isColor( 112,  874, 0x18d9f1, 85) and 
			isColor( 132,  790, 0x18d9f1, 85) and 
			isColor(  93,  830, 0x18d9f1, 85) and 
			isColor( 624,  866, 0x18d9f1, 85) and 
			isColor( 627,  808, 0x18d9f1, 85) and 
			isColor( 483,  842, 0x18d9f1, 85) and 
			isColor( 242,  645, 0xff2d55, 85) and 
			isColor( 118,  646, 0xff2d55, 85) and 生日==1) then
			if string.find(input1.."","2")~= nil  then
				nicheng = getNickName()
				click(543,  386,"修改名字")
				mSleep(700)
				click(659,  295,"删除")
				mSleep(600)
				inputText(nicheng)
				mSleep(600)
				click(371,  757,"下一步")
				mSleep(600)
			else
				click(370,  830,"下一步")
				mSleep(600)
			end
			倒计时=1
		end
		
--		if (isColor( 107,  926, 0x18d9f1, 85) and 
--			isColor( 131,  846, 0x18d9f1, 85) and 
--			isColor( 627,  922, 0x18d9f1, 85) and 
--			isColor( 676,  851, 0x18d9f1, 85) and 
--			isColor( 468,  883, 0x18d9f1, 85) and 
--			isColor( 127,  693, 0xff2d55, 85) and 
--			isColor( 300,  694, 0xff2d55, 85)and 生日==1) then
--			if string.find(input1.."","2")~= nil  then
--				click(285,  421,"修改名字2")
--				mSleep(700)
--				click(659,  295,"删除2")
--				mSleep(600)
--				click(613,  864,"随机点名字")
--				mSleep(600)
--				click(613,  864,"随机点名字")
--				mSleep(600)
--				inputText("娜娜")
--				mSleep(600)
--				click(371,  757,"下一步2")
--				mSleep(600)
--			else
--				click(373,  875,"下一步2")
--				mSleep(600)

--			end
--			倒计时=1

--		end

		if (isColor(  85, 1255, 0x3bb3fa, 85) and 
			isColor(  94, 1179, 0x3bb3fa, 85) and 
			isColor(  73, 1215, 0x3bb3fa, 85) and 
			isColor( 659, 1260, 0x3bb3fa, 85) and 
			isColor( 656, 1179, 0x3bb3fa, 85) and 
			isColor( 484, 1208, 0x3bb3fa, 85) and 
			isColor( 494,  504, 0x8a82f6, 85) and 
			isColor( 374,  522, 0xf7df5b, 85) and 
			isColor( 278,  401, 0xffa0f8, 85)) then
			click( 53,  339,"旅游景点关闭打卡3")
			mSleep(600)
		end
		
		if (isColor(  81,  856, 0xebebeb, 85) and 
			isColor(  83,  790, 0xebebeb, 85) and 
			isColor( 198,  823, 0xebebeb, 85) and 
			isColor( 644,  843, 0xebebeb, 85) and 
			isColor( 633,  543, 0xebebeb, 85) and 
			isColor( 729,  558, 0xffffff, 85)) then
			if (isColor( 702,   85, 0x323333, 85) and 
				isColor( 701,   85, 0x4d4d4d, 85) and 
				isColor( 698,   84, 0xffffff, 85) and 
				isColor( 698,   80, 0x323333, 85) and 
				isColor( 698,   81, 0x6e6f6f, 85) and 
				isColor( 688,   90, 0xa3a4a4, 85) and 
				isColor( 687,   90, 0x323333, 85)) then

				click(677,   84,"跳过1")
				if 生日==0 then
					老号=1
					return true
				end
			end
			倒计时=1
		end
		
		local x,y = findMultiColorInRegionFuzzy( 0x1182fe, "1|0|0xf3ecea,-2|0|0x6cadf6,-18|12|0x007aff,-17|12|0xe7e5e8,-20|12|0xa8c8ee,-22|12|0xf1eae7,-57|-5|0x007aff,-54|-5|0xf1efec,-51|-5|0x007aff", 90, 181,  784, 293,  839)

		if x> 0 then
			倒计时=1
			click(240,  808,"跳过2")
			mSleep(500)
			if 生日==0 then
				老号=1
				return true
			end
		end
		
		if (isColor(  97,  893, 0xebebeb, 85) and 
			isColor(  93,  837, 0xebebeb, 85) and 
			isColor( 642,  895, 0xebebeb, 85) and 
			isColor( 652,  860, 0xebebeb, 85)) then
			local x6,y6 = findMultiColorInRegionFuzzy( 0x323333, "-1|0|0x4d4d4d,-1|11|0x4d4d4d,0|11|0x323333,2|21|0x323333,2|20|0x7e7e7e,-15|10|0x323333,-14|10|0xa3a4a4,-13|10|0xffffff", 90, 660,   94, 723,  171)
			if x6> 0 then
				倒计时=1
				click(678,  133,"跳过3")
				mSleep(500)
				if 生日==0 then
					老号=1
					return true
				end
			end
		end
		
		if (isColor(  59, 1291, 0x40e7e2, 70) and 
			isColor(  91, 1283, 0x34daf0, 70) and 
			isColor(  76, 1262, 0x32d9f1, 70) and 
			isColor(  76, 1279, 0xfdfcfd, 85) and 
			isColor(  59, 1274, 0x3be2e8, 70) and 
			isColor(  43, 1281, 0xfdfcfd, 85) and 
			isColor( 111, 1279, 0xfdfcfd, 85) and 
			isColor(  73, 1266, 0x34dbef, 70) and 生日==1) then
			click(673, 1284,"更多6")
			return true
		end
		
		if (isColor(  58, 1224, 0x40e7e3, 70) and 
			isColor(  88, 1223, 0x36ddee, 70) and 
			isColor(  73, 1199, 0x33d9f0, 70) and 
			isColor(  90, 1213, 0x33d9f2, 70) and 
			isColor(  60, 1213, 0x3ce2e7, 70) and 
			isColor(  74, 1216, 0xfcfbfc, 70) and 生日==1) then
			click(675, 1218,"更多4")
			return true
		end

		if (isColor( 215,  972, 0x3bb3fa, 85) and 
			isColor( 217,  902, 0x3bb3fa, 85) and 
			isColor( 190,  940, 0x3bb3fa, 85) and 
			isColor( 342,  983, 0x3bb3fa, 85) and 
			isColor( 531,  975, 0x3bb3fa, 85) and 
			isColor( 535,  914, 0x3bb3fa, 85) and 
			isColor( 352,  901, 0x3bb3fa, 85) and 
			isColor( 261, 1006, 0xffffff, 85) and 
			isColor( 374,  881, 0xffffff, 85) and 
			isColor( 407,  609, 0x453577, 85)) then
			click(640,  326,"关闭立即展示跳过4")
			mSleep(600)
		end
		
		if (isColor( 193,  917, 0x3bb3fa, 85) and 
			isColor( 204,  947, 0x3bb3fa, 85) and 
			isColor( 540,  951, 0x3bb3fa, 85) and 
			isColor( 530,  915, 0x3bb3fa, 85)) then
			click(368, 1033,"更新版本2")
			mSleep(600)
		end
	end
end

function 快速从下向上滑动(x,y,z,w)
	--mSleep(500)
	--local zc=(y-w)/20
	--touchDown(1, x,y);
	--mSleep(20);
	--for i=1 ,zc do
	--	y=y-20
	--	touchMove(1, x, y);
	--	mSleep(20);
	--end
	--touchMove(1, z, w)
	--mSleep(20)
	--touchUp(1, z,w);
	--mSleep(600)
	moveTo(x,y,z,w)
end

function mima()
	保存=0
	修改完成=0
	while (true) do
		if (isColor( 116, 1250, 0x3bb3fa, 85) and 
			isColor( 135, 1190, 0x3bb3fa, 85) and 
			isColor( 633, 1255, 0x3bb3fa, 85) and 
			isColor( 655, 1189, 0x3bb3fa, 85) and 
			isColor( 374, 1294, 0xffffff, 85) and 
			isColor(  54,  338, 0x323333, 85) and 
			isColor(  43,  338, 0xffffff, 85) and 
			isColor(  52,  351, 0xffffff, 85) and 
			isColor(  65,  339, 0xffffff, 85) and 
			isColor(  50,  326, 0xffffff, 85)) then
			click(54,  338,"旅游景点关闭打卡")
			mSleep(600)
		end
		
		if (isColor( 187,  932, 0x3bb3fa, 85) and 
			isColor( 218,  899, 0x3bb3fa, 85) and 
			isColor( 530,  897, 0x3bb3fa, 85) and 
			isColor( 563,  927, 0x3bb3fa, 85) and 
			isColor( 215,  974, 0x3bb3fa, 85) and 
			isColor( 529,  972, 0x3bb3fa, 85) and 
			isColor( 399, 1002, 0xffffff, 85) and 
			isColor( 581,  961, 0xffffff, 85) and 
			isColor( 552,  882, 0xffffff, 85) and 
			isColor( 179,  894, 0xffffff, 85)) then
			click(375, 1033,"更新版本")
			mSleep(600)
		end
		
		if (isColor( 196,  925, 0x3bb3fa, 85) and 
			isColor( 311,  971, 0x3bb3fa, 85) and 
			isColor( 560,  935, 0x3bb3fa, 85) and 
			isColor( 432,  899, 0x3bb3fa, 85) and 
			isColor( 543, 1039, 0xffffff, 85)) then
			click(369, 1038,"更新版本1")
			mSleep(600)
		end
		
		if (isColor( 193,  917, 0x3bb3fa, 85) and 
			isColor( 204,  947, 0x3bb3fa, 85) and 
			isColor( 540,  951, 0x3bb3fa, 85) and 
			isColor( 530,  915, 0x3bb3fa, 85)) then
			click(368, 1033,"更新版本2")
			mSleep(600)
		end
		
		if (isColor(  85, 1255, 0x3bb3fa, 85) and 
			isColor(  94, 1179, 0x3bb3fa, 85) and 
			isColor(  73, 1215, 0x3bb3fa, 85) and 
			isColor( 659, 1260, 0x3bb3fa, 85) and 
			isColor( 656, 1179, 0x3bb3fa, 85) and 
			isColor( 484, 1208, 0x3bb3fa, 85) and 
			isColor( 494,  504, 0x8a82f6, 85) and 
			isColor( 374,  522, 0xf7df5b, 85) and 
			isColor( 278,  401, 0xffa0f8, 85)) then
			click( 53,  339,"旅游景点关闭打卡2")
			mSleep(600)
		end
		
		if (isColor(  82,  909, 0xebebeb, 85) and 
			isColor(  90,  832, 0xebebeb, 85) and 
			isColor( 654,  901, 0xebebeb, 85) and 
			isColor( 666,  847, 0xebebeb, 85) and 
			isColor( 560,  878, 0xebebeb, 85) and 
			isColor( 227,  877, 0xebebeb, 85) and 
			isColor( 359,  788, 0xffffff, 85)) then
			if (isColor( 701,  132, 0x4d4d4d, 85) and 
				isColor( 702,  132, 0x323333, 85) and 
				isColor( 703,  132, 0xdbdbdb, 85) and 
				isColor( 702,  147, 0x323333, 85) and 
				isColor( 702,  146, 0x808080, 85) and 
				isColor( 687,  137, 0x323333, 85) and 
				isColor( 688,  137, 0xa3a4a4, 85) and 
				isColor( 689,  137, 0xffffff, 85)) then
				click(678,  133,"跳过8")
				mSleep(600)
			end
		end
		
		if (isColor( 215,  972, 0x3bb3fa, 85) and 
			isColor( 217,  902, 0x3bb3fa, 85) and 
			isColor( 190,  940, 0x3bb3fa, 85) and 
			isColor( 342,  983, 0x3bb3fa, 85) and 
			isColor( 531,  975, 0x3bb3fa, 85) and 
			isColor( 535,  914, 0x3bb3fa, 85) and 
			isColor( 352,  901, 0x3bb3fa, 85) and 
			isColor( 261, 1006, 0xffffff, 85) and 
			isColor( 374,  881, 0xffffff, 85) and 
			isColor( 407,  609, 0x453577, 85)) then
			click(640,  326,"关闭立即展示跳过")
			mSleep(600)
		end
		
		if (isColor(  59, 1280, 0x3de3e6, 70) and 
			isColor(  89, 1279, 0x34daf1, 70) and 
			isColor(  74, 1263, 0x33d9f0, 70) and 
			isColor(  86, 1291, 0x38deeb, 70) and 
			isColor(  73, 1280, 0xfdfcfd, 70)) then
			click( 675, 1280,"更多")
			mSleep(700)
		end
		
		if (isColor(  58, 1224, 0x40e7e3, 70) and 
			isColor(  88, 1223, 0x36ddee, 70) and 
			isColor(  73, 1199, 0x33d9f0, 70) and 
			isColor(  90, 1213, 0x33d9f2, 70) and 
			isColor(  60, 1213, 0x3ce2e7, 70) and 
			isColor(  74, 1216, 0xfcfbfc, 70)) then
			click(675, 1218,"更多3")
		end
		
		if (isColor( 664, 1290, 0xffd200, 85) and 
			isColor( 685, 1288, 0xffc500, 85) and 
			isColor( 673, 1288, 0xffcb00, 85) and 
			isColor( 676, 1270, 0xffc100, 85) and 
			isColor( 674, 1261, 0xffbd00, 85) and 
			isColor( 656, 1255, 0xfdfcfd, 85) and 
			isColor( 695, 1266, 0xfdfcfd, 85) and 
			isColor( 647, 1280, 0xfdfcfd, 85)) then
			if 修改完成 == 1 then
				click(372,  277,"5查看个人资料")
				mSleep(500)
			else
				click(696,   84,"齿轮5")
				mSleep(500)
			end
		end
		
		if (isColor( 101, 1246, 0x65ece7, 70) and 
			isColor( 106, 1173, 0x65ece6, 70) and 
			isColor( 650, 1243, 0x2fd2f8, 70) and 
			isColor( 659, 1175, 0x2ed2f8, 70) and 
			isColor( 210, 1198, 0x5ae7ea, 70) and 
			isColor( 538, 1206, 0x3ad8f5, 70) and 
			isColor( 186, 1101, 0xb9bcbc, 85) and 
			isColor( 171, 1101, 0xf8fafb, 85) and 
			isColor( 202, 1102, 0xf8fafc, 85) and 
			isColor( 185, 1111, 0xf8f9fa, 85)) then
			click(67, 1071,"动态点资料3")
			mSleep(600)
		end

		if (isColor( 341,  318, 0xc0c0c0, 85) and 
			isColor( 397,  323, 0xb3b3b3, 85) and 
			isColor( 411,  256, 0xc0c0c0, 85) and 
			isColor( 340,  252, 0xb3b3b3, 85) and 
			isColor( 375,  291, 0xfcfcfc, 85)) then
			local x4,y4 = findMultiColorInRegionFuzzy( 0x323333, "10|26|0x3b3c3c,10|25|0xc5c5c5,4|19|0x323333,-4|27|0x434444,-7|5|0x323333,-6|5|0xbabbbb,-14|20|0x323333,-14|3|0x4c4d4d", 90, 111,  637, 180,  714)
			if x4 > 0 then
				click(619,  678,"设置密码")
				mSleep(600)
			end
		end
		
		if (isColor(  81,  856, 0xebebeb, 85) and 
			isColor(  83,  790, 0xebebeb, 85) and 
			isColor( 198,  823, 0xebebeb, 85) and 
			isColor( 644,  843, 0xebebeb, 85) and 
			isColor( 633,  543, 0xebebeb, 85) and 
			isColor( 729,  558, 0xffffff, 85)) then
			if (isColor( 702,   85, 0x323333, 85) and 
				isColor( 701,   85, 0x4d4d4d, 85) and 
				isColor( 698,   84, 0xffffff, 85) and 
				isColor( 698,   80, 0x323333, 85) and 
				isColor( 698,   81, 0x6e6f6f, 85) and 
				isColor( 688,   90, 0xa3a4a4, 85) and 
				isColor( 687,   90, 0x323333, 85)) then
				click(677,   84,"跳过")
			end
		end
		
		local x,y = findMultiColorInRegionFuzzy( 0x1182fe, "1|0|0xf3ecea,-2|0|0x6cadf6,-18|12|0x007aff,-17|12|0xe7e5e8,-20|12|0xa8c8ee,-22|12|0xf1eae7,-57|-5|0x007aff,-54|-5|0xf1efec,-51|-5|0x007aff", 90, 181,  784, 293,  839)

		if x> 0 then
			click(240,  808,"跳过")
			mSleep(500)
		end
		
		if (isColor( 675, 1266, 0xffbf00, 80) and 
			isColor( 675, 1271, 0xffc200,80) and 
			isColor( 676, 1288, 0xffca00, 80) and 
			isColor( 641, 1271, 0xfdfcfd, 80) and 
			isColor( 699, 1268, 0xfdfcfd, 80)) then
			if 修改完成 == 1 then
				click(372,  277,"1查看个人资料")
				mSleep(500)
			else
				click(696,   84,"齿轮5")
				mSleep(500)
			end
		end
		
		if (isColor( 664, 1225, 0xffd100, 75) and 
			isColor( 683, 1225, 0xffc700, 75) and 
			isColor( 675, 1198, 0xffbd00, 75) and 
			isColor( 675, 1207, 0xffc200, 75) and 
			isColor( 655, 1207, 0xfdfcfd, 85) and 
			isColor( 701, 1213, 0xfdfcfd, 85)) then

			if 修改完成 == 1 then
				click(331,  323,"3查看个人资料")
				mSleep(500)
			else

				click(696,  131,"齿轮3")
				mSleep(500)
			end
		end

		local x9,y9 = findMultiColorInRegionFuzzy( 0x4c4d4d, "0|3|0xffffff,1|9|0x323333,1|10|0x575858,-1|17|0x323333,6|4|0x323333,5|4|0x444545,4|4|0xffffff,7|4|0xbabbbb,21|22|0x323333", 90, 115,  639,176,  710)

		if x9> 0 then
			if 修改完成 == 1 then
				click(59,   85,"密码设置返回2")
			else
				click(629,  679,"密码设置2")
				mSleep(500)
			end

	end
	
		local xs,ys = findMultiColorInRegionFuzzy( 0x2c2c2c, "0|4|0xffffff,0|9|0x1e1e1e,0|12|0xffffff,-7|17|0x1e1e1e,15|17|0x1e1e1e,4|0|0x2c2c2c,5|5|0x656565,4|-9|0x1e1e1e", 90, 145,  218, 203,  293)
		if xs > 0 then
			if xs > 0 then
				if 修改完成 == 1 then
					click(58,  131,"账号安全返回")
					mSleep(500)
				else
					click(142,  258,"账号安全")
					mSleep(500)
				end
			end
		end


		local x,y = findMultiColorInRegionFuzzy( 0x1e1e1e, "-1|0|0x3e3e3e,-2|0|0xffffff,4|-5|0x1e1e1e,5|-5|0x767676,4|21|0x1e1e1e,5|21|0x767676,6|21|0xffffff,24|19|0x1e1e1e,24|7|0x1e1e1e", 90, 20,  184, 71,  237)

		if x > 0 then
			if 修改完成 == 1 then
				click(59,   85,"账号安全返回")
				mSleep(500)
			else
				click(121,  206,"账号安全")
				mSleep(500)
			end
		end
		
		if (isColor( 173,  205, 0x1e1e1e, 85) and 
			isColor( 173,  208, 0xffffff, 85) and 
			isColor( 173,  213, 0x1e1e1e, 85) and 
			isColor( 173,  221, 0x1e1e1e, 85) and 
			isColor( 186,  221, 0x1e1e1e, 85) and 
			isColor( 181,  204, 0x2c2c2c, 85) and 
			isColor( 176,  200, 0xffffff, 85) and 
			isColor( 176,  195, 0x1e1e1e, 85) and 
			isColor( 177,  209, 0x656565, 85) and 
			isColor( 178,  209, 0xffffff, 85)) then
			if 修改完成 == 1 then
				click(59,   85,"账号安全返回3")
				mSleep(500)
			else
				click(121,  206,"账号安全3")
				mSleep(500)
			end
		end
		
		if (isColor( 125,  960, 0x4ebbfb, 85) and 
			isColor( 133,  898, 0x4ebbfb, 85) and 
			isColor( 100,  924, 0x4ebbfb, 85) and 
			isColor( 606,  954, 0x4ebbfb, 85) and 
			isColor( 630,  904, 0x4ebbfb, 85) and 
			isColor( 348,  981, 0xffffff, 85) and 
			isColor( 362,  896, 0x4ebbfb, 85) and 
			isColor( 581,  745, 0xebebeb, 85) and 
			isColor( 577,  723, 0xffffff, 85) and 
			isColor( 647,  354, 0x323333, 85)) then
			click(647,  353,"关闭绑定手机")
			mSleep(600)
		end

		if (isColor(  45,  696, 0x3cc9ff, 85) and 
			isColor(  63,  696, 0x3cc9ff, 85) and 
			isColor(  70,  683, 0x3cc9ff, 85) and 
			isColor(  53,  673, 0x3cc9ff, 85) and 
			isColor(  53,  685, 0x00a6ff, 85) and 
			isColor(  45,  685, 0xffffff, 85) and 
			isColor(  37,  684, 0x3cc9ff, 85) and 
			isColor(  61,  684, 0xffffff, 85) and 
			isColor(  54,  660, 0x3cc9ff, 85) and 
			isColor(  53,  666, 0xffffff, 85)) then
			if 修改完成 == 1 then
				click(59,   85,"密码设置返回")

			else

				click(629,  679,"密码设置")
				mSleep(500)
			end
		end
		
		if (isColor( 642,   83, 0x3bb3fa, 85) and 
			isColor( 643,   83, 0x8cd2fb, 85) and 
			isColor( 644,   83, 0xfefefe, 85) and 
			isColor( 642,   91, 0x3bb3fa, 85) and 
			isColor( 643,   91, 0x8cd2fb, 85) and 
			isColor( 656,   95, 0x3cb4fa, 85) and 
			isColor( 654,   95, 0xc1e6fc, 85) and 
			isColor( 652,   95, 0xfefefe, 85) and 
			isColor( 655,   79, 0x3bb3fa, 85) and 
			isColor( 655,   75, 0xfefefe, 85) and 保存==0) then
			mSleep(500)
			click(290,  192,"密码获取焦点")
			mSleep(700)
			inputText("sz201818")
			mSleep(700)
			click(407,  280,"密码二获取焦点")
			mSleep(700)
			inputText("sz201818")
			mSleep(800)
			click(319,  508,"随便点")
			mSleep(800)
			click(666,   84,"保存")
			mSleep(600)
			mm_id = getMMId(appDataPath("com.wemomo.momoappdemo1").."/Documents")
			保存=1
			return true
		end
		if (isColor( 688,   73, 0x3bb3fa, 85) and 
			isColor( 695,   73, 0x3bb3fa, 85) and 
			isColor( 690,   79, 0x3bb3fa, 85) and 
			isColor( 697,   87, 0x3bb3fa, 85) and 
			isColor( 697,   86, 0xfefefe, 85) and 
			isColor( 682,   87, 0x3bb3fa, 85) and 
			isColor( 682,   86, 0xfefefe, 85) and 
			isColor( 680,   73, 0x3bb3fa, 85) and 
			isColor( 676,   69, 0xfefefe, 85)and 保存==0) then
			mSleep(500)
			click(290,  192,"密码获取焦点")
			mSleep(700)
			inputText("sz201818")
			mSleep(700)
			click(407,  280,"密码二获取焦点")
			mSleep(700)
			inputText("sz201818")
			mSleep(1500)
			click(319,  508,"随便点")
			mSleep(800)
			click(666,   84,"保存2")
			mSleep(600)
			mm_id = getMMId(appDataPath("com.wemomo.momoappdemo1").."/Documents")
			保存=1
			return true
		end
	end
end
a="没发现陌陌号"
点日期=0
fwShowWnd("wid",192,0,449, 41,1)----创建窗口
记录=0
老号=0
for j=1,tonumber(input8) do--循环注册次
	VPN()
	gaiji()
	mo()
	if 老号== 0 then
		mima()
	end
	mSleep(4500)
	closeApp("com.wemomo.momoappdemo1")
	mSleep(900)
	gaican()
	点日期=1
	记录=记录+1
end


