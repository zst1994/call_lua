local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require("socket")
local http = require("szocket.http")
require("TSLib")
local sqlite3 = sz.sqlite3

--local sz = require("sz")
--local cjson = sz.json
--local http = sz.i82.http
--headers = {}
--headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36'
--headers['Referer'] = 'https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/'
--headers_send = cjson.encode(headers)
--dialog(headers_send,0)
--status_resp, headers_resp, body_resp = http.get("https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/",5,headers_send)
--if status_resp ~= nil then
--    dialog(status_resp,0)
--    dialog(headers_resp,0)
--    if status_resp == 200 then
--        dialog(string.len(body_resp),0)
--    end
--end

--code,header_resp, body_resp = ts.httpsGet("https://jiema.wwei.cn/", header_send,body_send)
--a = strSplit(body_resp,"token=")
--token = strSplit(a[2], "\";")
--dialog(token[1], time)
--nLog(token[1])

function ifIsJson(jsonString)
    local head
    local pos1, pos2
    jsonString = jsonString:atrim()
    local String1 = string.sub(jsonString, 1, 1) --最外部大括号
    local String2 = string.sub(jsonString, #jsonString)
    if String1 == "{" and String2 == "}" then
        String1 = jsonString
        jsonString = string.sub(jsonString, 2, -2) --去掉最外部括号
        pos1, _ = string.find(jsonString, "%[")
        if pos1 then
            pos2, _ = string.find(jsonString, "%]")
            if pos2 then
                head = string.sub(jsonString, 2, pos1 - 1)
                local a, b = string.gsub(head, '("-)(.-)("-):', "")
                if a == "" and b == 1 then
                    head = string.sub(jsonString, pos1 + 1, pos2 - 1)
                    while true do
                        if (pos2) == #jsonString then --没有后续的了
                            --							local result= ContinueCheck(head)  --传入 []里的内容
                            if result then
                                return true
                            else
                                return false
                            end
                        else --还有
                            local result = ContinueCheck(head) --传入 []里的内容
                            if result == false then
                                return false
                            end
                            jsonString = string.sub(jsonString, pos2 + 1, #jsonString) --记录下后面部分
                            pos1, _ = string.find(jsonString, "%[")
                            if pos1 then
                                pos2, _ = string.find(jsonString, "%]")
                                if pos2 then
                                    head = string.sub(jsonString, 2, pos1 - 1)
                                    local a, b = string.gsub(head, '("-)(.-)("-):', "")
                                    if a ~= "" and b ~= 1 then
                                        return false
                                    end -- "head":[{....},{.....},{.....}]  其中的head格式不正确
                                    head = string.sub(jsonString, pos1 + 1, pos2 - 1) --下一次循环传入的参数
                                else
                                    return false
                                 --缺少]
                                end
                            else
                                return false --[]缺少[]
                            end
                        end
                    end
                else
                    return false -- "head":[{....},{.....},{.....}]  其中的head格式不正确
                end
            else
                return false --不匹配[]
            end
        else --没有中括号,简单的单个{}json处理
            --			local result =ContinueCheck(String1)
            if result then
                return true
            else
                return false
            end
        end
    else
        return false --不匹配{}
    end
end
--精准滑动的原理就是通过向滑动方向的垂直线方向移动 1 像素来终止滑动惯性
--简单的垂直精准滑动
--mSleep(math.random(500, 700))
--x, y = findMultiColorInRegionFuzzy(0xc2c2c2,"13|19|0xc2c2c2,52|12|0xc2c2c2,83|0|0xc2c2c2,84|16|0xc2c2c2,-111|-5|0xf2f2f2,219|43|0xf2f2f2,274|18|0xededed,-172|9|0xededed", 100, 0, 920, 749, 1333)
--dialog(x..y, time)
--if x~=-1 and y~=-1 then
--	mSleep(math.random(500, 1000))
--	randomsTap(x - 240, y-95,1)
--	mSleep(math.random(3000, 5000))
--else
--	mSleep(math.random(500, 700))
--	x,y = findMultiColorInRegionFuzzy( 0xc2c2c2, "-148|-7|0xf2f2f2,140|2|0xf2f2f2,245|2|0xededed,-175|6|0xf2f2f2", 100, 0, 920, 749, 1333)
--	if x~=-1 and y~=-1 then
--		mSleep(math.random(500, 1000))
--		randomsTap(x, y-112,1)
--		mSleep(math.random(3000, 5000))
--	else
--		time = time + 1
--		toast("等待隐秘政策"..time,1)
--		mSleep(math.random(2000, 3000))
--	end
--end

--openURL("snssdk1128://aweme/detail/6864869537918045453")
--mSleep(math.random(500,700))
--x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "32|3|0xffffff,-112|-24|0xfe2c55,242|-21|0xfe2c55,239|26|0xfe2c55,68|0|0xffffff,102|4|0xffffff,277|-16|0x393a44,326|27|0x393a44,302|6|0xffffff", 90, 0, 0, 749, 1333)
--if x~=-1 and y~=-1 then
--	dialog(x..y, time)
--	mSleep(math.random(500,700))
--	randomTap(x,y,5)
--	mSleep(math.random(500,700))
--else
--	dialog("gg", time)
--end

function getWord(copyWord)
    local m = TSVersions()
    local a = ts.version()
    local API = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
    local Secret = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"
    local tp = getDeviceType()
    if m <= "1.2.7" then
        dialog("请使用 v1.2.8 及其以上版本 TSLib", 0)
        lua_exit()
    end

    if tp >= 0 and tp <= 2 then
        if a <= "1.3.9" then
            dialog("请使用 iOS v1.4.0 及其以上版本 ts.so", 0)
            lua_exit()
        end
    elseif tp >= 3 and tp <= 4 then
        if a <= "1.1.0" then
            dialog("请使用安卓 v1.1.1 及其以上版本 ts.so", 0)
            lua_exit()
        end
    end

    local tab = {
        paragraph = "true",
        probability = "true",
        ocrType = 2
    }

    local code1, access_token = getAccessToken(API, Secret)
    if code1 then
        local content_name1 = userPath() .. "/res/baiduAI_content_name1.jpg"
        --内容
        snapshot(content_name1, 0, 0, 749, 1333)
        mSleep(1000)

        local code2, body = baiduAI(access_token, content_name1, tab)
        nLog(body)
        if code2 then
            local tmp = json.decode(body)
            for i = 1, #tmp.words_result, 1 do
                mSleep(200)
                x, y = string.find(tmp.words_result[i].words, copyWord)
                toast(x, 1)
                if x ~= nil then
                    dialog(tmp.words_result[i].location.top, time)
                    return tmp.words_result[i]
                end
            end
        else
            dialog("识别失败\n" .. body, 5)
        end
    else
        dialog("识别失败\n" .. access_token, 5)
    end
    return nil
end

function getData()
    dataPath = appDataPath("com.wemomo.momoappdemo1")
    local getList = function(path)
        local a = io.popen("ls " .. path)
        local f = {}
        for l in a:lines() do
            table.insert(f, l)
        end
        return f
    end
    local Wildcard = getList("var/mobile/Containers/Data/Application")
    for var = 1, #Wildcard do
        local file = io.open(dataPath .. "/Library/Preferences/com.wemomo.momoappdemo1.plist", "rb")
        if file then
            local ts = require("ts")
            local plist = ts.plist
            local plfilename =
                appDataPath("com.wemomo.momoappdemo1") .. "/Library/Preferences/com.wemomo.momoappdemo1.plist" --设置plist路径
            local tmp2 = plist.read(plfilename) --读取 PLIST 文件内容并返回一个 TABLE
            for k, v in pairs(tmp2) do
                if string.match(k, "Key(%d+)") then
                    k = string.match(k, "%d+")
                    nLog(k)
                    toast(k, 1)
                    return k
                end
            end
        end
    end
end

--getData()

function getData() --获取62数据 (可以用的)
    dataPath = appDataPath("com.ss.iphone.ugc.Aweme")
    local getList = function(path)
        local a = io.popen("ls " .. path)
        local f = {}
        for l in a:lines() do
            table.insert(f, l)
        end
        return f
    end

    local file = io.open(dataPath .. "/Library/loginData.dat", "rb")
    if file then
        local str = file:read("*a")
        file:close()
        require "sz"
        local str = string.tohex(str) --16进制编码
        return str
    end
end

function getData() ----获取火山uid
    dataPath = appDataPath("com.ss.iphone.ugc.Live")

    local file = io.open(dataPath .. "/Library/Preferences/com.ss.iphone.ugc.Live.plist", "rb")
    if file then
        local ts = require("ts")
        local plist = ts.plist
        local plfilename = appDataPath("com.ss.iphone.ugc.Live") .. "/Library/Preferences/com.ss.iphone.ugc.Live.plist" --设置plist路径
        local tmp2 = plist.read(plfilename) --读取 PLIST 文件内容并返回一个 TABLE
        for k, v in pairs(tmp2) do
            if k == "kHTSLastLoginedUserId" then
                nLog(v)
                toast(v, 1)
                return v
            end
        end
    end
end

--MS4wLjABAAAAiRqZ36GT_Wu0U1aO0UFU93w3j1BXYhSi22bQcJHMXNY
--six_data = getData()
--dialog(six_data, 0)

--dataPath = appDataPath("com.tencent.xin");
--a =  appDataPath("com.ss.iphone.ugc.Aweme")
--nLog(dataPath.."\r\n"..a)

--require "TSLib"--使用本函数库必须在脚本开头引用并将文件放到设备 lua 目录下    J57HaeH
--local file = appDataPath("com.ss.iphone.ugc.Aweme").."/Library/AWEStorage/UnifyStorage.sqlite-wal"
--table=readFile(file)
--if table then
--    for k,v in ipairs(table) do
--		i, j = string.find(v, "https", 1)
--		if i > 0 then
--			dialog(v, time)
--		end

--		nLog(tostring(k).."==="..tostring(v))
--	end

--else
--    dialog("文件不存在")
--end
--if txt then
--    dialog("文件内容："..txt)
--else
--    dialog("文件不存在")
--end

--for var= 1, 10 do
--	mSleep(500)
----	moveTo(200,1000,201, 500,{["step"] = 15,["ms"] = 70,["index"] = 1,["stop"] = true})
--	touch():Step(15):on(200,1000):move(200,500):off()
--end

--local ts = require("ts")
--time = ts.ms()
--str = tostring(time * 1000)
--newtime = strSplit(str,".")
--sign = "1oTzLwB5sB7KEk2w"
--pass = sign:md5()

--header_send = {ContentType = "application/x-www-form-urlencoded"}
--body_send = {
--	["account"] = "18239773375",
--	["password"] = "123456qq",
--}
--ts.setHttpsTimeOut(60)
--code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/script/login/", header_send, body_send)
--if code == 200 then
--	tmp = json.decode(body_resp)
--	token = tmp.data.token
--end

--body_send = {
--	["token"] = token,
--	["ids"] = {
--		authorizedHs="1"
--	},
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/get/subList", header_send,body_send)
--if code == 200 then
--	local tmp = json.decode(body_resp)
--	data = tmp.data
--	for k,v in ipairs(data) do
--		if v.title=="神杖-关注" and v.openSelection==true then
--			id=v.id
--			nLog(id)
--		end
--	end
--end

--header_send = {ContentType = "application/x-www-form-urlencoded"}--获取任务
--body_send = {
--	["token"] = token,
--	["ids"] = id,
--	["tjStatus"]= "1",
--	["timestamp"] = newtime[1],
--	["scriptUid"] = "ujh",
--	["sign"]= pass,

--}
--ts.setHttpsTimeOut(60)
--code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/get/sign/task", header_send, body_send)
--nLog(code)
--dialog(code, time)
--dialog(body_resp, time)
--if code == 200 then
--	nLog(body_resp, time)
--	tmp = json.decode(body_resp)
----	token = tmp.status
----	nLog(token)
----	nLog("\r\n")
--end

--local ts = require("ts")--使用扩展库前必须插入这一句
--local cjson = ts.json--使用 JSON 模块前必须插入这一句
--local str = [[ {  "id":"243125b4-5cf9-4ad9-827b-37698f6b98f0" }]]
--dialog(tostring(ifIsJson(str)), time)
----把 json 字符串转换成 table
--local tmp = json.decode(str)
--if tostring(type(tmp)) == "table" then
--	dialog(tmp.meme[5],0);
--	dialog(tostring(tmp.nullvalue),0);
--else
--	toast("fff",1)
--end

--function ContinueCheck(jsonString)
--	local stringLength=#jsonString
--	local pos1,pos2=0,0
--	local JsonTable={}
--	local i=1
--	while (true) do   --截取{....}并且存入表JsonTable中
--		pos1,_=string.find(jsonString,"{",pos1+1)
--		if pos1 then
--			pos2,_=string.find(jsonString,"}",pos2+1)
--			if pos2 then
--				JsonTable[i]=string.sub(jsonString,pos1+1,pos2-1)
--			else
--				return false
--			end
--		else
--			return false
--		end
--		if pos2==#jsonString then break end
--		i=i+1
--	end
--	local a,b
--	local j=1
--	while (true) do
--		jsonString=JsonTable[j]  --一个一个值检查
--		while (true) do
--			local q,_=string.find(jsonString,",")
--			if q~= nil then --"a":"i","b":"j"找这之间的逗号
--				local jsonString2=string.sub(jsonString,1,q-1)  --,号前
--				jsonString=string.sub(jsonString,q+1,#jsonString)  --,号后
--				a,b=string.gsub(jsonString2,"(\"-)(.-)(\"-):","")
--			else   --没有则为key:value 的最后一个
--				a,b=string.gsub(jsonString,"(\"-)(.-)(\"-):","")
--			end
--			if  b==1 then
--				a,b=string.gsub(a,"(\"-)(.+)(\"+)","")
--				if a==""  then
--					mSleep(10)
--				else
--					a=tonumber(a)
--					if type(a) == "number" then
--						mSleep(10)
--					else
--						return false
--					end
--				end
--			else
--				return false
--			end
--			if q == nil then --找到最后啦
--				break
--			end
--		end
--		if j==i then return true end
--		j=j+1
--	end

--end

--function ifIsJson(JsonString)
--	local pos1,pos2,pos3,pos4=0,0,0,0
--	local counter1,counter2,counter3,counter4=0,0,0,0
--	local string1,string2
--	local Mytable,Mytable2={},{}
--	local i,j=1,1
--	JsonString=JsonString:atrim()
--	string1=string.sub(JsonString,1,1)
--	string2=string.sub(JsonString,-1,-1)
--	if string1=="{" and string2=="}" then --查看各种括号是否成对存在
--		_,pos1=string.gsub(JsonString,"{","{")
--		_,pos2=string.gsub(JsonString,"}","}")
--		_,pos3=string.gsub(JsonString,"%[","[")
--		_,pos4=string.gsub(JsonString,"%]","]")
--		if pos1~=pos2 or pos3~=pos4 then return false end
--	else return false end
--	while (true) do
--		pos1,pos2=string.find(JsonString,",%[{",pos1)-- 找 ,[{ 找到后找 }]
--		if pos1 then
--			pos3,pos4=string.find(JsonString,"}]",pos4)
--			if pos3 then
--				string1=string.sub(JsonString,pos1,pos4)
--				_,counter1=string.gsub(string1,"{","{")  --查看各种括号是否成对存在
--				_,counter2=string.gsub(string1,"}","}")
--				_,counter3=string.gsub(string1,"%[","[")
--				_,counter4=string.gsub(string1,"%]","]")
--				if counter1 == counter2 and counter3== counter4 then
--					Mytable[i]=string.sub(JsonString,pos2,pos3) --{....}
--					i=i+1
--					string1=string.sub(JsonString,1,pos1-1)
--					string2=string.sub(JsonString,pos4+1)
--					JsonString=string1..string2 -- 去掉,{[..}]
--					pos4=pos1
--				end
--			else return false end
--		else
--			pos1,pos2,pos3,pos4=1,1,1,1
--			pos1,pos2=string.find(JsonString,"%[{") --找[{ 找到后找 }]没有则跳出
--			if pos1 then
--				pos3,pos4=string.find(JsonString,"}]")
--				if pos3 then
--					string1=string.sub(JsonString,pos1,pos4)
--					_,counter1=string.gsub(string1,"{","{")  --查看各种括号是否成对存在
--					_,counter2=string.gsub(string1,"}","}")
--					_,counter3=string.gsub(string1,"%[","[")
--					_,counter4=string.gsub(string1,"%]","]")
--					if counter1 == counter2 and counter3== counter4 then
--						Mytable[i]=string.sub(JsonString,pos2,pos3) --{....}
--						i=i+1
--						string1=string.sub(JsonString,1,pos1-1)
--						string2=string.sub(JsonString,pos4+1)
--						JsonString=string1.."\"\""..string2 -- 去掉,[{..}]
--						pos4=pos1
--					end
--				else return false end
--			else break end
--		end
--	end
--	i=i-1
--	if Mytable[i]~= nil then
--		pos1,pos2,pos3,pos4=1,1,1,1
--		while (true) do  --截取嵌套n层的最里面的[{.....}]
--			repeat       -- 找table[]中[{最靠后的这符号,
--				pos1,pos2=string.find(Mytable[i],"%[{",pos2)
--				if pos1 then pos3,pos4=pos1,pos2  end
--			until pos1==nil
--			pos1,pos2=string.find(Mytable[i],"}]",pos4)  --找串中pos4之后}]最靠前的这个符号
--			if pos1 then
--				Mytable2[j]=string.sub(Mytable[i],pos4,pos1) --[ {....} ]
--				j=j+1
--				string1=string.sub(Mytable[i],1,pos3-1)
--				stirng2=string.sub(Mytable[i],pos2+1)
--				Mytable[i]=string1.."\"\""..string2
--			else
--				Mytable2[j]=Mytable[i]
--				j=j+1
--				i=i-1
--				if i== 0 then break end--直到找不到成对的[{}]
--			end
--			pos2=1
--		end
--	end

--	Mytable2[j]=JsonString
--	i=1
--	Mytable={}
--	pos1,pos2,pos3,pos4=0,0,1,1
--	while (true) do
--		repeat
--			pos1,_=string.find(Mytable2[j],"{",pos2+1)
--			if pos1 then pos2=pos1 end
--		until pos1 == nil
--		pos3,_=string.find(Mytable2[j],"}",pos2)
--		if pos3 and pos2~=1 then
--			Mytable[i]=string.sub(Mytable2[j],pos2,pos3) --  {...}
--			i=i+1
--			string1=string.sub(Mytable2[j],1,pos2-1)
--			string2=string.sub(Mytable2[j],pos3+1)
--			Mytable2[j]=string1.."\"\""..string2
--		else
--			Mytable[i]=string.sub(Mytable2[j],1,pos3)
--			i=i+1
--			j=j-1
--			if j==0 then break end
--		end
--		pos2=0
--		-- 串b截取   {  "id":"243125b4-5cf9-4ad9-827b-37698f6b98f0" }  这样的格式 存进table[j]
--		-- 剩下一个 "image":{ "id":"243125b4-5cf9-4ad9-827b-37698f6b98f0","a":"e0", "d":"2431-f6b98f0","f":"243125b98f0"--}这样的也存进table[j+1]
--	end

--	i=i-1
--	for n=1,i do  --去除{}
--		Mytable[n]=string.sub(Mytable[n],2,-2)
--	end

--	while (true) do
--		pos1,_=string.find(Mytable[i],",")
--		if pos1~= nil then --"a":"i","b":"j"找这之间的逗号
--			string1=string.sub(Mytable[i],1,pos1-1)--,前
--			Mytable[i]=string.sub(Mytable[i],pos1+1)
--			pos2,_=string.find(string1,"\"")
--			if pos2==1 then
--				pos3,pos4=string.find(string1,"\":",2)
--				if pos3 then
--					string2=string.sub(string1,pos4+1)
--				else
--					toast("发现错误1", 1)
--					return false
--				end
--			else
--				toast("发现错误2", 1)
--				return false
--			end
--		else
--			pos2,_=string.find(Mytable[i],"\"")
--			if pos2==1 then
--				pos3,pos4=string.find(Mytable[i],"\":",2)
--				if pos3 then
--					string2=string.sub(Mytable[i],pos4+1)
--				else
--					toast("发现错误3", 1)
--					return false
--				end
--			else
--				toast("发现错误4", 1)
--				return false
--			end
--		end

----		pos2,pos3=string.gsub(string2,"(\"-)(.+)(\"+)","")
----		if pos2=="" or pos2 == "null" then
----			toast("这一个串格式正确", 2)
----		else
----			pos2=tonumber(pos2)
----			dialog(type(pos2), time)
----			if type(pos2) == "number" then
----				toast("这一个串格式正确", 2)
----			else
----				toast("发现错误5", 1)
----				return false
----			end
----		end

--		if pos1 == nil then
--			i=i-1
--			if i==0 then return true end
--		end
--	end

--end

--iso = "FR"

--::get_phone::
--local ts = require("ts")
--header_send = {}
--body_send = {}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsGet("https://admin.smscodes.io/api/sms/GetServiceNumber?key=3edcec83-89e0-4c13-a1a4-c2a12018422f&iso="..iso.."&serv=bb147412-4700-44d6-a4fe-637361940f2a", header_send,body_send)
--if code == 200 then
--	post_data = string.gsub(body_resp,"\"{","{")
--    post_data = string.gsub(body_resp,"}\"","}")
--    post_data = string.gsub(body_resp,"\\","")
--	dialog(post_data, time)
--	tmp = json.decode(body_resp)
--	if tmp.Number == "N/A" then
--		toast("获取号码失败:"..body_resp,1)
--		mSleep(5000)
--		goto get_phone
--	elseif tonumber(tmp.Number) > 0 then
--		telphone = tmp.Number
--		sid = tmp.SecurityId
--		toast(telphone.."\r\n"..sid,1)
--	else
--		toast("获取号码失败:"..body_resp,1)
--		mSleep(5000)
--		goto get_phone
--	end
--else
--	toast("获取号码失败:"..body_resp,1)
--	mSleep(5000)
--	goto get_phone
--end

--::get_code::
--local ts = require("ts")
--header_send = {}
--body_send = {}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsGet("https://admin.smscodes.io/api/sms/GetSMSCode?key=3edcec83-89e0-4c13-a1a4-c2a12018422f&sid="..sid.."&number="..telphone, header_send,body_send)
--if code == 200 then
--	tmp = json.decode(body_resp)
--	if tmp.SMS == "Message not received yet" then
--		toast("获取验证码失败:"..body_resp,1)
--		mSleep(5000)
--		goto get_code
--	elseif tonumber(tmp.SMS) > 0 then
--		mess_yzm = tmp.SMS
--		toast(mess_yzm,1)
--	else
--		toast("获取验证码失败:"..body_resp,1)
--		mSleep(5000)
--		goto get_code
--	end
--else
--	toast("获取号码失败:"..body_resp,1)
--	mSleep(5000)
--	goto get_code
--end

--local httputil = HttpUtil()
--local url = "https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/"
--local resStr --响应结果
--local res,code = httputil.httpget(url)
--dialog(res..code, time)
--if code ~= 301 then
----	ngx.log(ngx.WARN,"非200状态，code:"..code)
--	return resStr
--end
--resStr = res
--dialog(resStr, 0)

--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["base64"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/decode", header_send,body_send)
--nLog(code..body_resp, time)

--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["userKey"] = "1875b88a1fd7484abfd531ddca810422",
----	["qrCodeImg"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--	["qrCodeUrl"] = urlEncoder("https://weixin110.qq.com/s/3ae2f306ac7"),
--	["phone"] = "13511111111" ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send,body_send)
--nLog(body_resp)
--dialog(body_resp, time)

--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["userKey"] = "1875b88a1fd7484abfd531ddca810422",
----	["qrCodeImg"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--	["orderId"] = "200828112247742NCTFO",
--	["status"] = 2,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
--nLog(body_resp)
--dialog(body_resp, time)

--nLog(urlDecoder("data%3aimage%2fpng%3bbase64%2ciVBORw0KGgoAAAANSUhEUgAAAQQAAAEECAYAAADOCEoKAAAbU0lEQVR4Xu2d7XqbOQ5Dm%2fu%2f6O7jzmzz0STnyMJLyx3sX5EECFKw7Gm7Lz9%2f%2fvz5o%2f%2brAlWgCvz48eOlhtA9qAJV4P8K1BC6C1WgCvxWoIbQZagCVaCG0B2oAlXgTwX6QuhWVIEq0BdCd6AKVIG%2bELoDVaAKfKMAfmV4eXn5zwhIfySDtKD8KSGJ5xSPXZwJPf8WrYzWRs8awhslSTBaHso3Q0vEEM8ExkSNCT3%2fFq3MPIyeNYQagtmlh8SYBd4lVkN4r2ANoYawe6cuy68hZKU1etYQagjZrQtWMwu8C9cXQl8IX%2b4QLSAtD%2bXvLq%2fNJ562zqPjJvT8W7QyszJ69oXQF4LZpYfEmAXeJVZD6AuhL4TdWzSUX0PICm303H4hGJBsW%2fdVM58E1AvVoHzDnDBMjUTMbi%2bmD8JI1CAtJjCIQ%2bqceiG9bzxqCId9ZaChppaH6pjl%2ba6G6YMwEjWozwkM4pA6p15I7xrCh0mQYAnBafiEQfmpc9KCcEwfhJGoMcGTMKbOSS%2fSu4ZQQ7j79xRaclrOWz4taKLGBE%2fCmDonvUjvGkINoYYg%2fq6OuUhTl37na5rpo78h9DeET3fMLM%2fOcvaFkLeQvhAWNCWxEgu6e4l%2bPdnEJ9ZC23eH7vZi%2biCMRA0SYAKDOKTOqRfSu18Z%2bpWhXxmEAZuLlLrUO3VqCAvqkVh9IbwXc%2fcSTOhtZkYrkuBJGFPn1IuZ6chvCEQ0IRg1azgkalAvhEH55msFYRgtDI8TYqhX4mi0IAxTg3jQOXFI7MXYV4YTBDMcSHRTIzFYqkE8JvogjlPn1CvxIC3NK8TUIB50bvokHqoG%2fT83RUDE9zQShM6pWepjavDEk%2fpMfBIYLQyPE2J29TRaEIapsasVcUjsRV8IH6ZEoicGTxhmcYgHYVC%2b4XBKDPVKPI0WhGFqEA86Jw41hAsuM4meGDxh0GIkBp%2fow%2fCciNnV02hBGKbGrhbEIbEXfSFcYCo0eDNYqkELSBiUT%2fgnnVOvxNVoQRimBvGgc%2bJQQ7jgMpPoicETBi1GYvCJPgzPiZhdPY0WhGFq7GpBHBJ70RfCBaZCgzeDpRq0gIRB%2bYR%2f0jn1SlyNFoRhahAPOicONYQLLjOJ%2fiyDp%2bVKnJNWBoP0TGAQD%2bJwyycepgbxoHPiUEOoIdAOXXpuFpQI0EVKYOxyqCF8UDAxNKpBQzPntDyGQ6KG4fpdDHEwnwS7HEy%2b4Ul1aCYJjF0ONYQawpc7RAtMy2fOzSWY4EFcDU%2bqQX0kMHY51BBqCDUEukXie7UogX%2fVu4bwqqLRImGw%2fctNbzaXRCfBzSWgGOLQrwyk4Nq5mSnNxNRYY%2fVnNHEwe6Fq9O8yeBd%2blsHvLp%2fJN8tFdUjPBMYuh35l6FeGfmWgW9SvDO8UImMTcmKIMUfioWr0heBfCDQ1Ggjlm08j8zQ0OLsxtFxTWuz2YXhO9Ep9EAezF6pGDaGGQMv42Tktl7lohEsYlG%2fODU%2fiYWoYLt%2fFEIcawgf1SDAzNKpBQzUYVMNwSOAQDzonngmOhEEczbnhSTxMDcOlhrCr0pv8xNCoBtFNLIbhkMChXuiceCY4EgZxNOeGJ%2fEwNQyXGsKuSjWEoIJrpSYuCWGsMf482lxm4mFq7HIlDv3K0K8Muzu2lU8LmrgkhLHVwL%2fJhifxMDV2uRKHGkINYXfHtvJpQROXhDC2GqghfCpf%2f6TiwtcOWsCpS5DAoV7onC5rgiNhEEdzbngSD1PDcOlvCLsqLVxmMzQaPNE1GFTDcEjgEA86J54JjoRBHM254Uk8TA3D5T9jCLtiJPLN0J5l8KQH9Up9Uv2pc%2brD8KBeDQbVMDwmYqgX08fIV4YJMQiDxLrlk2CmBvGgc%2bJA%2bbdz4pnAMDx2Y6gPU596NRhUw%2fCYiKFeTB81hPDXjt3Bm6ERRmIxCGPinPowHEhPg0E1DI%2bJGOrF9FFDqCFM7OpdGLTgpihdAoNBNQyPiRjqxfRRQ6ghTOzqXRi04KYoXQKDQTUMj4kY6sX0UUOoIUzs6l0YtOCmKF0Cg0E1DI%2bJGOrF9FFDqCFM7OpdGLTgpihdAoNBNQyPiRjqxfRRQ6ghTOzqXRi04KYoXQKDQTUMj4kY6sX0sW0IE41OYZBgEcFfXr5thzjcknd5UP4Ng3hQDcpP9JGoQX1M7d4EjprJ7j%2bQMtHIFAYJRstD%2bYkFTtSgPmoIUxs3i6P2s4bwOhQSjC4S5Scuc6IG9VFDmL2oU2hqP2sINYTPFpKWh0yF8hPGlqhBfUxd1gkcNZMaQg2hhjBxHR%2bPUUNYnAEJRp8mlJ%2f4REvUoD76lWFxcZ4kXO1nXwh9IfSF8CQ3epNmDWFRQBKMPlkpP%2fHpnqhBffSFsLg4TxKu9rMvhL4Q%2bkJ4khu9STNiCJscmv5BAfPpTKKZwVINOk%2fwJIyJ8wmtJvqYwsA%2fqThF5L%2bCk7hoE0ue4HnCTCe0OqHPFIcaQkpJWSdx0SaWPMFTSnJp2IRWlzYwXLyGMC04%2fF0GQ2diyWsIZhJ%2fX0wNYXimiYtWQ%2fBDm9DKszk%2fsoYwPKMawqzgNYQ1vWsIa3ptR9cQtiVcKlBDWJLrRw1hTa%2ft6BrCtoRLBWoIS3KxIZywwAkORpaJ5aFeDIfdGpRvtJqImdDC9EF6JXgaHrsxiufEn1Q0RL5rlgayK9T%2f83d5Gh7Ui%2bGwW4PyTR8TMRNamD5IrwRPw2M3RvGsIbzKbATbHcrEclEfxGG3x1Q%2b9XHDoV5MDeKbwKAaxCFxbrTA3xASjRgifSH8o4DRimZCNSg%2fsXyJGtRHDWFNZaVnXwh9Iayt1Vy0WuDAP1pLHZGBJngSh8S54llDqCEklu2KGmqBawhaeqVnDaGGoDdqOFAtcA1BT0XpWUOoIeiNGg5UC1xD0FNReu4aggLZ%2fAs9BkOr8k0gfVckjCmexCNxTlpQr5RvOBJG4kfFBE%2fTywkxSs8awuuodpfDCH7CYhgOpAX1SvmGA2HUEIyKay%2fg7f%2fsmBgatWUwqIY5313iKZ6ml90Y0oJ6pXzDjzBqCEbFGsKaSm%2bid5fYLPDd5IYTSQvqlfJNO4RRQzAq1hDWVKohfKoXXWi6rJRvhkQYNQSjYg1hTaUaQg3h7o15rkRlsP1R8XWou59qRvBnWSHSgnqlfKMDYfSFYFTsC2FNpb4Q%2bkK4e2OeK1EZbF8IfSF8ttb0CU%2fLRfnmKhFGXwhGxQNfCER7YnkMBi2gqUG90jlxoPzUOfWa4JnAoBqkh%2bmDMEwN4pE4T%2fAc%2bXMI1Cw1Qvm3cxqKwUjUMFy%2fiyEOu%2fVtPumV4JnAoBrUr%2bmDMEwN4pE4T%2fCsIbyZBA2WBE8MlTgkMEwN6jXBM4FBNahX0wdhmBrEI3Ge4FlDqCF8uouJ5aIlT2BQDeJgLjNhmBrEI3Ge4FlDqCHUEOA2Ji5a4sJTjQTPGkINoYZQQ%2fitQA2hhlBDqCHUED7bAfouSE8yetKZc%2bJgaiRiqNcEzwQG1SAtTB%2bEYWoQj8R5gie%2bECaIEoYRPCEG8aBz4nDLN73s4hCG4UkcTsAgjuY8oYXBoZhT9Kwh0KQWzs1y0eANHOEQBuUbDidgGJ4Uk9CCMMz5KXrWEMy0ZIxZLhq8gSIcwqB8w%2bEEDMOTYhJaEIY5P0XPGoKZlowxy0WDN1CEQxiUbzicgGF4UkxCC8Iw56foWUMw05IxZrlo8AaKcAiD8g2HEzAMT4pJaEEY5vwUPWsIZloyxiwXDd5AEQ5hUL7hcAKG4UkxCS0Iw5yfomcNwUxLxpjlosEbKMIhDMo3HE7AMDwpJqEFYZjzU%2fSsIZhpyRizXDR4A0U4hEH5hsMJGIYnxSS0IAxzfoqeNQQzLRljlosGb6AIhzAo33A4AcPwpJiEFoRhzk%2fRc8QQjCDfxZihJQTdrUH5RoepXokL9WJ4TmDs8qT8Ww%2fUq6lBWtA5cbjlJ3jUEN5MggSloVA%2bDd0snxk88TQ8qJdTMHZ5Ur6ZialhNL%2f6Q9FwqCHUED7dE1ryGsKrbKSVuYgUY%2fRO8Kgh1BBqCHAb6TImLmINgRR4c04DST2jabDEg%2fJNy4SR6pW4UC%2bG5wTGLk%2fK71cGmuIDzs3y0WAnahAHI90ET8ODejE8CSeBsVuD8msINMUHnJvlo8FO1CAORroJnoYH9WJ4Ek4CY7cG5dcQaIoPODfLR4OdqEEcjHQTPA0P6sXwJJwExm4Nyq8h0BQvOJ9YrgRt4jm1XLs8KN9oZXo1dR4dk9Di0T1YfDOzI%2f4rQ2Ioplkr3FdxxNNwOKEGcTA6mV5NnUfHJLR4dA8W38yshmDVDP2JNVpANbSXl29ZUw3iYCQhDFPjhJiEFif0YTiYmdUQjJL%2fxtDyKME3L3PiOy31YSQxvZo6j45JaPHoHiy%2bmVkNwarZF8I7pcxyLUj7sNAawnvpawgLq0jLYy7JCTWIg5HE9GrqPDomocWje7D4ZmY1BKtmXwh9ISzsyomhNYTwVOjTRAne3xDCU9krRzPdq35WttrPnxB1gmCmEZLe9LGLYzCI57Oc72qV6pM0fxaepIfpI6EFfmUgEGokcW7EIBzTxy6OwSCez3K%2bq1WqT9L8WXiSHqaPhBY1hDeTMKJ%2fNzgaCA39mc53tUr1Spo%2fC0%2fSw%2fSR0KKGUEOgXfz03CzoXYUXkxKXYBHyrnDiSUWN3oShavQ3hNdRGMH6QvhHgV2t6ALY88QlsFg7ccSTahu9CUPVqCHUEGgZPzs3y3VP3dWcxCVYxbwnnnhSTaM3YagaNYQaAi1jDeEehd7n0GUlBHWZE%2f9Ju4ZQQ6BlrCHco1ANYV%2b1LyoYdyRw49C7OAaDeD7L%2ba5WqT5J82fhSXqYPhJaHPFfGUyzJFhCjAkM4kkcbuekF2FQ%2fg1jtwblJ%2fo0NYhHQgvDw%2bB8V4f6SHGoIRgl%2f42hoZihUw1Dh3AIg%2fJrCNnnvjFxmjvNlPIthxqCUbKG8IdKZCpTC0zjIx7UhzFH4mAvY18I%2fypghkKiJwY%2fgUE8iYNZLsIweu%2fWoPxEn6YG8UhoYXgYnBpCDcHsUvzT2Szn7kWifNO44Ul1iIfBoBrEwZg41Zji0K8MNIk35zSUU5Zrgif1ShyM7IRhahAPg0E1DA%2bD0xdCXwhml%2fpCuEulf5LoMpuLSjUMPYNTQ6ghmF2qIdylUg3ho2zGlPArw8YsfqeSwxqixIMwKD9xbvognoka1IvBoBp0Tn1Svj2f6MVyuTLO6JnQooYQnKIZCA02UYNaMhhUg86pT8q35xO9WC5Xxhk9E1rUEIJTNAOhwSZqUEsGg2rQOfVJ%2bfZ8ohfL5co4o2dCixpCcIpmIDTYRA1qyWBQDTqnPinfnk%2f0YrlcGWf0TGhRQwhO0QyEBpuoQS0ZDKpB59Qn5dvziV4slyvjjJ4JLWoIwSmagdBgEzWoJYNBNeic%2bqR8ez7Ri%2bVyZZzRM6FFDSE4RTMQGmyiBrVkMKgGnVOflG%2fPJ3qxXK6MM3omtKghBKdoBkKDTdSglgwG1aBz6pPy7flEL5bLlXFGz4QWaAiGyJVC3GqbRolnogb1aTCoRuKctEhgTNRI6PksWlCviT4I4zbTGsKbzd4V3Qg%2bcZF2%2b5jgaDASej6LFtRrog%2fCqCF82Mpd0Y3g5iLsxuz2sYufyk%2fo%2bSxaUK%2bJPgijhlBDSN3dS%2bqYBSbgxEUijMQ59ZrogzBqCDWExC5fVsMsMIEnLhJhJM6p10QfhFFDqCEkdvmyGmaBCTxxkQgjcU69JvogjBpCDSGxy5fVMAtM4ImLRBiJc%2bo10Qdh1BBqCIldvqyGWWACT1wkwkicU6%2bJPgijhlBDSOzyZTXMAhN44iIRRuKcek30QRjKEBLNUjNElPITHE0N4mlqUC8JDMODYogn5Zs%2bCMPUIB6EQfm38wQPwiGehkOkBv1%2fO1Ij5nyXKOUbDokYMxTCoV4SGMTBnBNPqmH6IAxTg3gQBuXXEIxCizE0FBo85S%2fSuTuceJrC1EsCw%2fCgGOJJ%2baYPwjA1iAdhUH4NwSi0GENDocFT%2fiKdu8OJpylMvSQwDA%2bKIZ6Ub%2fogDFODeBAG5dcQjEKLMTQUGjzlL9K5O5x4msLUSwLD8KAY4kn5pg%2fCMDWIB2FQfg3BKLQYQ0OhwVP%2bIp27w4mnKUy9JDAMD4ohnpRv%2biAMU4N4EAbl1xCMQosxNBQaPOUv0rk7nHiawtRLAsPwoBjiSfmmD8IwNYgHYVB%2bDcEotBhDQ6HBU%2f4inbvDiacpTL0kMAwPiiGelG%2f6IAxTg3gQBuXXEIxCwzGnDJV4JBbYSLvLg%2fITl8BgmF53Y2gmhifV2OVo8g1PqmP6wH8ghUAmzqfEoF6IhxGcMMz5Lg%2fKryG8n8LUXL%2bbvZkZ7Y7po4ZAKr45p6EYwRfgvgzd5UH5NYQaQmJPL6thFpjAE5eVeCQwqI%2fb%2bS4Pyq8h1BDMHj4sxiwwkUtcVuKRwKA%2baghGodcYmgnNNGGOa4w%2fjzY8CYe0%2bLVbE3%2bXgYjS%2bZQYuzyM4IRhzkkP4kH5iUtgMEyvuzEnaLHbg%2fkQMBikRQ3BqPgmhpbcCL4I%2bWn4Lg%2fKryH0K0NiTy%2brYRaYwBOXlXgkMKgP82lBPKiPGkINwezhw2LMAhM5uiSUn7iIBsPEkB7UK%2bXXEGoIX%2b6hWR5a4t0FpXzCN5fZ1KAYw%2fMEPamPUwxhSk%2bjx9UxplfiQLtlMPBHRQIhkma5CMM0QjwIg%2fLNueGZ4EE4ExikxxSHBA71MnFOMzUcSAuDUUMwSssYJfjLi6z2dRjh0GIYAoRBNaY4JHCol4nzXb3NK9hg1BCC01aC1xC04lN6akIXBppeCZ7M0WDUEEjlhXMleA1BKzqlpyZ0YaDpleBrCKTQm3MSa6HUl6FmqAkehDOBQXpNcUjgUC8T5zRTw4G0MBh9IRilZYwSvC8Eqab758%2fpEmiwBwea3SGKpIXBqCGQygvnSvAaglZ0Sk9N6MJA0yvBjxgCkfgvnZPgCS3MYhAPU4O4Egbln8DhxjHBg3o1Wp3Aw3DAFwKJ8V86N4Pf1UMNDV4Zpgbx3O31BA41hPdTNjOpIdDNeHO%2be0kMlBpaDcFI%2bSvG6KmLfRFo9uIEHoZDDWFhG8zgF8p9GqqGVkPQMhs9dbEawq5Uf1d%2bDcHPM3ERE3oneFDXhucJPAyHvhBo2v3KsKDQa6hZPipsLhrVSPAgDMPzBB6GQw2Bpl1DWFCohvCVWOYy3iX0wn4aDjWEhSmYT4KFcv0NAcRK6G0uwe7MDM8TeBgOaAim2V1BT8k3gn3H1WhFGKbGKXrt8pjQIoGRqHG1Vrf6tDvUx68a9I%2bsEshuoyflG8FqCLmJkd6J3UtgJGrsqkYcagi7Cn%2bSb0SvIeSEJ71rCGu%2fyZBepHdfCB922whWQ6ghfFSALmJCMbObxEPV6FeGNReuISTW%2b58atKC04IZJAiNRw3D9LoY49CvDrsL9ynCBgmslaclrCGsfVqQX6d2vDP3KsHaDw9G0oLTghk4CI1HDcO0LYVelcD4NnuDMAhOGqUE8nuV8QosERqLG7kyIQ78y7CrcrwwXKLhWkpY8YY4JjESNNWX%2bjCYOxxiCIborRiLfLBf1QjUo3%2fRBGLcahEM1KD%2bxXMTBaDHB0%2fCgGNOr6YVwJs63%2f2DS0zQq%2fuky6oUGT%2flmoIRRQ3ivIumVmAnNjTiYmRHG1HkN4Y3StDw0eMo3QyUMs1xUw%2fDcrUH5RosJnoYHxZheTS%2bEM3FeQ6ghfLpntOS04JRvlpswEl9tDA%2bKMb2aXghn4ryGUEOoIWzetBrCwiXa1DqWnhga1Uh8ChBGvzL0N4TYpfikUF8IC%2bZGl7WG8ComaWWW2uhJOKaG4fJdDHEwJr7LIZVfQ6gh9CvD5m2qISxcIvPDz%2bY8fqXTJ0FiaFSDOBgtEjVIT4NBNeictErNjHg8yznNJKGn0WLkhWCaMWS%2fi5kQlPogDjWE9xMkvUjv3Z05KT%2bhBdUw%2fdYQFl47tKBmIBM1aPCGJ9Wgc%2bqzL4S8OSbmWkOoIdDdvuu8hrAmG13mhJ6GUQ2hhmD2ZDkmscCmxjKxQxNqCOHBTAhKC0oc%2bhtC%2fpkcXqOHlaPdod0zX8FMc30h9IVg9mQ5JrHApsYysUMTagjhwUwISgtKHPpC6Avhq7Wn3aHd6wvhg7ITgtJQiEMNoYZQQxD%2fjzKJxwJdRrrMCYedwDBaGR6mzk4MzcOY4w7%2b%2f3MNjwTOCTVo7kaL%2foaw8BsCDZ0GkjAd4jB10YiHWj7xj9YQDp0bHlTjWc5p%2f4wWNYQawiX7rpavhhDVvoawcJlJrMSn9wSG2SDDw9TZiakh7Kh3Xy7NXc1k9%2f%2b5SYEc8ElAYtUQ7lvCr7KeZS%2byXT%2b2Gu24mkkN4XWIRrDvRk4DSZiOWTnDw9TZiTFaTvA0PHb6PCmX9DRa9DeEha8dNHwaSA3hvYJGL9Kczs0loBrPck56Gi1qCDWES%2fZdLd8BXyUvaf5BRWsIC5eZxEp8ek9gTO2a6eVqLsZUruaQqv8sevaFsGAqtBxm6M%2by5KYX0mP3%2fFm0Mn0%2bi541hBrCp%2fv8LAtsLuMJMc%2biZw2hhlBDGHCMGsIbkSfEoOel4UA1aG8mMIhD6tz0ksL6qs7uPK7mt1L%2fWfTsC6EvhL4QVm72nbE1hL4QPl2dZ%2fnUe5YFvvN%2bjqc9i559IfSF0BfCgD3UEAZEXoEwA6FPb1ODOBEG5d%2fOiQdhUL7hkMBI1DBcd2MmeJ6A8Wu3Jv4uw%2b5AEvnmEpwyFOqXejmhD%2bJ463GCJ2lpzid4noBRQ%2fiwDacMhZaULtsJfRDHGsL7KZ8wsxpCDYG858vzxAInatzdwELiBM8TMGoINYSFa5H%2fRJu4BHc3%2bCZxgucJGDWEGsLd9yWxwIkadzewkDjB8wSMGkINYeFa9IXwlVjm9xISuoZACoXPzdBOGQq1Tr2c0Adx7I%2bKeYOlvaG96AuhLwTaof6oOPSfR%2bmyGoOlYRJGxBCIxDOdk2ATQzEYJ%2fCkuZ7SB%2fEkLX9dksC%2f7GRwvuNqOOxi1BAOfCEkBm9qJC7K1Quc6CPRZ4LH7mU1HHYxagg1hLu%2fEtBFSyywqUE86NxcogQPg3O1wZIWNYQaQg3h50%2b8JzWENxIlxEDFDwkgF09okcBI1CDJCYPyjVaEYWoQDzonDv0N4YOCE0OhoU2d03IktEhgJGqQpoRB%2bUYrwjA1iAedE4caQg3hyx1KLCgtoMFI1EhclKu%2f8xotqA86Jy1rCDWEGoL4b%2b900cxlpstoahAPOicONQRSsOdVoAr8tQrgP5Dy13bexqpAFfhDgRpCl6IKVIHfCtQQugxVoArUELoDVaAK%2fKlAXwjdiipQBfpC6A5UgSrQF0J3oApUgW8U6FeGrkcVqAK%2fFfgf0ERlbFq709oAAAAASUVORK5CYII%3d"))

--::put_work::
--header_send = {}
--body_send = string.format("userKey=%s&qrCodeImg=%s&phone=%s","1875b88a1fd7484abfd531ddca810422","data:image/png;base64,"..readFileBase64(userPath().."/res/222.png"),"13511111111")
--ts.setHttpsTimeOut(60)--安卓不支持设置超时时间
--status_resp, header_resp, body_resp  = ts.httpPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send, body_send, true)
--dialog(body_resp, time)
--if status_resp == 200 then
--	local tmp = json.decode(body_resp)
--	if tmp.success then
--		taskId = tmp.obj.orderId
--		toast("发布成功,id:"..tmp.obj.orderId,1)
--	else
--		goto put_work
--	end
--else
--	goto put_work
--end
--while (true) do
--	mSleep(500)
--	x,y = findMultiColorInRegionFuzzy( 0x161823, "13|0|0x161823,21|-3|0x161823,40|-14|0x161823,40|-5|0x161823,31|3|0x161823,45|3|0x161823,54|3|0x161823", 90, 0, 0, 749, 1333)
--	if x~=-1 and y~=-1 then
--		mSleep(500)
--		tap(x + 320,y)
--		mSleep(2000)
--	end

--	x,y = findMultiColorInRegionFuzzy( 0x161823, "0|8|0x161823,15|3|0x161823,23|11|0x161823,40|0|0x161823,37|18|0x161823,44|23|0x161823", 90, 0, 0, 749, 1333)
--	if x~=-1 and y~=-1 then
--		mSleep(500)
--		moveTowards( 283,  1044, math.random(70,90), 250)
--		mSleep(2000)
--		break
--	end
--end

--CS2008251013381507020
--8148887206
--http://124.156.99.83/usa1?voice=6b889f9bf8241d76ada0f0ac504bcb62ee4078c8d159aef3853cbf203d7bb2020c7e62d486b890d5

--openURL("snssdk1128://aweme/detail/6864418736191966467?refer=web&gd_label=click_wap_detail_download_feature&appParam=%7B%22__type__%22%3A%22wap%22%2C%22position%22%3A%22900718067%22%2C%22parent_group_id%22%3A%226553813763982626051%22%2C%22webid%22%3A%226568996356873356814%22%2C%22gd_label%22%3A%22click_wap%22%7D&needlaunchlog=1")
--base_six_four = readFileBase64(userPath().."/res/111.png")
--dialog(base_six_four:base64_decode(), time)
--::ewm_go::
--token = "c97f4c3afad288a06d092df40ab77dc2"
--header_send = {}
--body_send = string.format("qr=%s&token=%s",base_six_four,token)

--ts.setHttpsTimeOut(60)--安卓不支持设置超时时间
--status_resp, header_resp, body_resp  = ts.httpPost("https://www.sojson.com/qr/deqrByImages.shtml", header_send, body_send, true)
--mSleep(1000)
--dialog(body_resp, time)

--http://b.bshare.cn/barCode?site=weixin&url=

--local sz = require("sz");
--local http = require("szocket.http")
--local res, code = http.request("http://s.jiathis.com/qrcode.php?url="..userPath().."/res/111.png")
--dialog(res, time)
--if code == 200 then
--	tmp = json.decode(res)
--	if tmp.code == "200" then
--		toast(tmp.message, 1)
--		order_sn = tmp.data.order_sn
--	end
--end
--				--个人中心
--				openURL("snssdk1128://user/profile/id")
--				while (true) do
--					mSleep(500)
--					x,y = findMultiColorInRegionFuzzy( 0xface15, "54|0|0xface15,117|0|0xface15,199|0|0xface15", 90, 0, 0, 639, 1135)
--					if x >= 214 then
--						mSleep(500)
--						moveTowards( 283,  1044, 80, 1000,50)
--						mSleep(2000)
--						break
--					else
--						mSleep(500)
--						tap(300,y-60)
--						mSleep(500)
--					end
--				end
----获取token
--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
--}
--body_send = {
--	["username"] = "17811602486",
--	["loginpw"] = "qazwsx123" ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/account/raw/login", header_send,body_send)
--dialog(body_resp, time)
--local tmp = json.decode(body_resp)
--token = tmp.data.token
--dialog(token, time)
--nLog(token)

------获取签到参数
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/oss/sign_img", header_send,body_send)

----local tmp = json.decode(body_resp)
----tmp_accessid = tmp.data.accessid
----tmp_signature = tmp.data.signature
----tmp_prefix = tmp.data.prefix
----tmp_expire = tmp.data.expire
----tmp_dir = tmp.data.dir
----tmp_policy = tmp.data.policy

--http://qr.liantu.com/api.php?text=C:\Users\admin\Desktop\111.png
--url = "https://www.sojson.com/qr/zxing.html"

----local _table1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="key"]]..'\r\n\r\n'..[[]]..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'..[[]]
----local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="policy"]]..'\r\n\r\n'..[[]]..tmp_policy..[[]]
----local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="OSSAccessKeyId"]]..'\r\n\r\n'..[[]]..tmp_accessid..[[]]
----local _table4 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="signature"]]..'\r\n\r\n'..[[]]..tmp_signature..[[]]
----local _table5 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="id"]]..'\r\n\r\n'..[[WU_FILE_0]]
----local _file1  = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'

--local _file1  = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="111.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
--local _table1 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="charset"]]..'\r\n\r\n'..[[UTF-8]]
--local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="en"]]..'\r\n\r\n'..[[Nh01QnxgsJRHk245OQiYWD cZtwbHio/HRIzEEAMqqxjIoNnfrkAu1pyczEsnRh34FPsfgoo5aeJIhGC NMW6hmcuibY7CQf1Zx2JaaGHcMYVBlgzdhCXyKBqB3bk012covQ3SODP7hrCjUyhpJUPlj7DCOuk4mFFHC6CItztjE=]]
--local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="ip"]]..'\r\n\r\n'..[[R6b60JKNA1KglT50kNxyFQm5DsVsnQHkrBqz8nBAhmO/DrSEVxZMa0UBxxVw6PaO1uqvY2MsTR7UQkX2kne9eo0q0Dk5liOtQIX9fBJIyYTCvZkWTBUxOXxOJH6YaMb3VkY/WD3I FMyaRep0ZO9xNVCEmz657Kowmx4oM4PMFs=]]

--local _end    = '\r\n'..[[--abcd--]]..'\r\n'

--aa = imgupload2(url, userPath() .. "/res/111.png",_file1,_table1,_table2,_table3,_end);
----aa返回200标识上传截图成功，然后进行绑定操作
--dialog(aa, time)

------上传图片
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----	["img_url"] = "https://zqzan.oss-cn-shanghai.aliyuncs.com/sign/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/do/sign", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)

------绑定抖音号
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----	["shot_img"] = "https://yun.zqzan.com/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
----	["short_url"] = "https://v.douyin.com/JMKcGXX/" ,
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/do/oauth", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)

------解绑
----header_send = {
----	["Token"] = token,
----}

----body_send = {}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/undo/oauth", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)
----nLog(token)

------绑定支付宝
----header_send = {
----	["Token"] = token,
----}

----body_send = {
----	["alipay_account"] = 支付宝账号,
----	["alipay_realname"] = 姓名 ,
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/cash/alipay", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)
----nLog(token)

----获取任务
--header_send = {
--	["Token"] = token,
--}

--body_send = {
--	["b_discount"] = true,
--	["access"] = 79 ,
--	["exam_status"] = 0 ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/pull/one", header_send,body_send)
--dialog(body_resp, time)
--nLog(body_resp)
--local tmp = json.decode(body_resp)
--id = tmp.data.id
--dialog(tmp.msg, time)
--nLog(token)

--openURL("snssdk1128://aweme/detail/"..id)
--mSleep(20000)
--snapshot("test.jpg", 0, 0, 749, 1333,0.7);
--mSleep(2000)
--toast("截图成功",1)
--mSleep(2000)

----获取上传参数
--header_send = {
--	["Token"] = token,
--}
--body_send = {
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/oss/shot_img", header_send,body_send)

--local tmp = json.decode(body_resp)
--tmp_accessid = tmp.data.accessid
--tmp_signature = tmp.data.signature
--tmp_prefix = tmp.data.prefix
--tmp_expire = tmp.data.expire
--tmp_dir = tmp.data.dir
--tmp_policy = tmp.data.policy

----上传截图
--url = "https://yun.zqzan.com/"

--local _table1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="key"]]..'\r\n\r\n'..[[]]..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'..[[]]
--local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="policy"]]..'\r\n\r\n'..[[]]..tmp_policy..[[]]
--local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="OSSAccessKeyId"]]..'\r\n\r\n'..[[]]..tmp_accessid..[[]]
--local _table4 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="signature"]]..'\r\n\r\n'..[[]]..tmp_signature..[[]]
--local _table5 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="success_action_status"]]..'\r\n\r\n'..[[200]]
--local _file1  = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'

--local _end    = '\r\n'..[[--abcd--]]..'\r\n'

--aa = imgupload2(url, userPath() .. "/res/test.jpg",_file1,_table1,_table2,_table3,_table4,_table5,_end);
----aa返回200标识上传截图成功，然后进行绑定操作
--dialog(aa, time)

----提交任务
--header_send = {
--	["Token"] = token,
--}
--body_send = {
--	["doit_id"] = id,
--	["shot_img"] = "https://zqzan.oss-cn-shanghai.aliyuncs.com/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/submit/task", header_send,body_send)
--local tmp = json.decode(body_resp)
--dialog(tmp.msg, time)

--os.execute("rm -rf "..appDataPath("com.tencent.xin").."/Library/WechatPrivate");
--flag = ts.hlfs.removeDir(appDataPath("com.tencent.xin").."/Library/WechatPrivate")--删除 hello 文件夹及所有文件
--if flag then
--	dialog("删除成功")
--else
--	dialog("删除失败或没有此文件夹")
--end

--ts.binaryzation(414,924,443,964,200)

--		dialog(string.match("233.fdfhd,555555","%d%d%d%d%d%d"), time)

--if code == 200 then
--	mSleep(500)
--	local tmp = json.decode(body_resp)
--	if tmp.status == 0 then
--		taskId = tmp.phones[1].phoneNodes[1].taskId
--		telphone = tmp.phones[1].phoneNodes[1].phone
--		toast(telphone.."\r\n"..taskId,1)
--	else
--		toast("获取号码失败:"..body_resp,1)
--		mSleep(5000)
--		goto get_phone
--	end
--else
--	toast("获取号码失败:"..body_resp,1)
--	mSleep(5000)
--	goto get_phone
--end

--if code == 200 then
--	mSleep(500)
--	local tmp = json.decode(body_resp)
--	if tmp.status == 0 then
--		phone = tmp.phones[1].phoneNodes[1].phone
--		toast("二维码辅助发布成功:"..phone,1)
--		mSleep(5000)
--	else
--		mSleep(500)
--		toast("发布失败，6秒后重新发布",1)
--		mSleep(6000)
--		goto put_work
--	end
--else
--	goto put_work
--end

--0123456789
--14789

--local model = {}
--model.API = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
--model.Secret  = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"

--model.tab_CHN_ENG={
--	language_type="CHN_ENG",
--	detect_direction="true",
--	detect_language="true",
--	ocrType = 3
--}

--model.tab_ENG = {
--	language_type = "ENG",
--	detect_direction = "true",
--	detect_language = "true",
--	ocrType = 3
--}

--function model:readFileBase64(path)
--	f = io.open(path,"rb")
--	if f == null then
--		toast("no file")
--		mSleep(3000);
--		return null;
--	end
--	bytes = f:read("*all");
--	f:close();
--	return bytes:base64_encode();
--end

--function model:main()

--		::getBaiDuToken::
--		local code,access_token = getAccessToken(self.API,self.Secret)
--		if code then
--			::snap::
--			local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"

--			--内容
--			snapshot(content_name, 406,926,443,964)
--			mSleep(500)

--			::put_work::
--			header_send = {
--				["Content-Type"] = "application/x-www-form-urlencoded",
--			}
--			body_send = {
--				["access_token"] = access_token,
--				["image"] = urlEncoder(self:readFileBase64(content_name)),
--				["recognize_granularity"] = "big",
--				["detect_direction"] = "true"
--			}
--			ts.setHttpsTimeOut(60)
--			code,header_resp, body_resp = ts.httpsPost("https://aip.baidubce.com/rest/2.0/ocr/v1/numbers", header_send,body_send)
--			dialog(body_resp, time)
--			if code == 200 then
--				mSleep(500)
--				local tmp = json.decode(body_resp)
--				if #tmp.words_result > 0 then
--					self.content_num = string.lower(tmp.words_result[1].words)
--				else
--					mSleep(500)
--					local code, body = baiduAI(access_token,content_name,self.tab_ENG)
--					dialog("11"..body, time)
--					if code then
--						local tmp = json.decode(body)
--						if #tmp.words_result > 0 then
--							self.content_num = string.lower(tmp.words_result[1].words)
--						else
--							toast("识别内容失败\n" .. tostring(body),1)
--							mSleep(3000)
--							goto snap
--						end
--					else
--						toast("识别内容失败\n" .. tostring(body),1)
--						mSleep(3000)
--						goto snap
--					end
--				end
--			else
--				toast("识别内容失败\n" .. tostring(body_resp),1)
--				mSleep(3000)
--				goto put_work
--			end

--			if self.content_num ~= nil and #self.content_num >= 1 then
--				self.content_num = string.sub(self.content_num,#self.content_num - 1, #self.content_num)
--				toast("识别内容：\r\n"..self.content_num,1)
--				mSleep(1000)
--				category = "success-data"
--				data = self.infoData.."----"..self.content_num
--			else
--				toast("识别内容失败,重新截图识别" .. tostring(body),1)
--				mSleep(3000)
--				goto snap
--			end
--		else
--			toast("获取token失败",1)
--			goto getBaiDuToken
--		end

--end

--model:main()

--local code,access_token = getAccessToken(API,Secret)
--if code then
----	::snap::

--	local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"

--	--内容
--	snapshot(content_name, 84,  805,370,  882)
--	mSleep(500)

--	local code, body = baiduAI(access_token,content_name,tab)
--	dialog(body, time)
--	if code then
--		local tmp = json.decode(body)

--		if #tmp.words_result > 0 then
--			content_num = string.lower(tmp.words_result[1].words)
--		else

--		end
--	else
--		toast("识别内容失败\n" .. tostring(body),1)
--		mSleep(3000)
----		goto snap
--	end

--	if content_num ~= nil and #content_num >= 1 then
--		toast("识别内容：\r\n"..content_num,1)
--		mSleep(1000)
--	else
--		toast("识别内容失败,重新截图识别" .. tostring(body),1)
--		mSleep(3000)
--		--		goto snap
--	end
--else
--	toast("获取token失败",1)
--	goto getBaiDuToken
--end

--function 登入芝麻()
--	while (true) do
--		local http = require("szocket.http")
--		local res, code = http.request("http://webapi.http.zhimacangku.com/getip?num=1&type=2&pro=&city=0&yys=0&port=1&time=1&ts=0&ys=0&cs=0&lb=1&sb=0&pb=4&mr=1&regions=");
--		if code == 200 then
--			local tmp = json.decode(res)
--			ip= tmp.data[1].ip
--			port=tmp.data[1].port
--			mSleep(2000)
--			toast(ip.."==="..port, 1)
--			return port
--		end
--		mSleep(3000);
--	end
--end

--duankou = 登入芝麻()
--inputKey(tostring(duankou))

--local ts = require("ts")
--					local plist = ts.plist
--local tmp2 = plist.read(appDataPath("com.tencent.xin").."/Documents/Container/Documents/ad9c0fb01c2bdf2961e50f2140910dc7/WCPay/paymanage.info")                --读取 PLIST 文件内容并返回一个 TABLE
--for k, v in pairs(tmp2) do
--	dialog(k.."==="..v, 0)

--end

function getList(path)
    local a = io.popen("ls " .. path)
    local f = {}
    for l in a:lines() do
        table.insert(f, l)
    end
    return f
end

infoData = "aaaaa"
word = ""

function getConfig()
    ::read_file::
    tab = readFile(userPath() .. "/res/config1.txt")
    if tab then
        wc_bid = string.gsub(tab[1], "%s+", "")
        wc_folder = string.gsub(tab[2], "%s+", "")
        wc_file = string.gsub(tab[3], "%s+", "")
        awz_bid = string.gsub(tab[4], "%s+", "")
        awz_url = string.gsub(tab[5], "%s+", "")
        toast("获取配置信息成功", 1)
        mSleep(1000)
    else
        dialog("文件不存在", 5)
        goto read_file
    end
end

--getConfig()

--local Wildcard = getList(appDataPath(wc_bid)..wc_folder)
--for var = 1,#Wildcard do
--	local bool = isFileExist(appDataPath(wc_bid)..wc_folder..Wildcard[var].."/Favorites/fav.db")
--	if bool then
--		local db = sqlite3.open(appDataPath(wc_bid)..wc_folder..Wildcard[var].."/Favorites/fav.db")
--		local open = db:isopen("fav")
--		if open then
--			for a in db:nrows('SELECT * FROM FavoritesSearchTable') do
--				for k,v in pairs(a) do
--					if k == "SearchStr" then
--						v = string.gsub(v,"%s+","")
--						str = string.match(v, '----%U%d+')
--						if type(str) ~= "nil" then
--						    data = strSplit(v,";")
--							word = data[#data]
--							category = "success-data"
--							data = infoData.."----"..word
--							toast("识别内容："..word,1)
--							mSleep(1000)
--							break
--						end
--					end
--				end
--			end
--		end
--		break
--	end
--end

-- dialog(category.."===="..word, time)

function msleep(t1, t2)
    math.randomseed(getRndNum())
    t = math.random(t1, t2)
    dialog(t, 0)
    mSleep(t)
end

-- appPath = appBundlePath("com.tencent.xin");

-- local file = io.open(userPath().."/res/info/Info.plist","rb")
-- if file then
-- 	local str = file:read("*a")
-- 	file:close()

-- 	local file = io.open(appPath.."/Info.plist", 'wb');
-- 	file:write(str)
-- 	file:close();
-- end

--::put_work::
--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["data"] = "我是重要信息111",
--	["type"] = "des",
--	["arg"] = "m=ecb_pad=zero_p=Hwm39kY8_o=0_s=gb2312_t=0",
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://tool.chacuo.net/cryptdes", header_send,body_send)
--if code == 200 then
--	mSleep(500)
--	local tmp = json.decode(body_resp)
--	if tmp.status == 1 then
--		key = urlEncoder(tmp.data[1]:base64_encode())
--		toast("key:"..key,1)
--	else
--		mSleep(500)
--		toast("发布失败，6秒后重新发布",1)
--		mSleep(6000)
--		goto put_work
--	end
--else
--	goto put_work
--end

-- math.randomseed(getRndNum())

-- while (true) do
-- 	setAirplaneMode(true)
-- 	mSleep(5000)
-- 	setAirplaneMode(false)
-- 	mSleep(5000)
-- 	openURL('https://gdzqtp.dev.ganguomob.com/')
-- 	mSleep(500)
-- 	while (true) do
-- 		mSleep(200)
-- 		if getColor(282, 1090) == 0x555864 then
-- 			mSleep(500)
-- 			tap(388, 1217)
-- 			mSleep(500)
-- 			break
-- 		end
-- 	end

-- 	while (true) do
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy( 0xe2d08a, "0|21|0xe2d08a,2|15|0xe2d08a,-10|15|0xe2d08a,-79|343|0xffffff,-219|342|0xffffff,-291|346|0xffffff", 90, 0, 0, 749, 1333)
-- 		if x ~= -1 then
-- 			mSleep(200)
-- 			if getColor(x + 3, y + 266) == 0xebcd73 then
-- 				mSleep(math.random(2500, 4000))
-- 				tap(x + 3, y + 266)
-- 				mSleep(500)
-- 			else
-- 				setAirplaneMode(true)
-- 				mSleep(5000)
-- 				setAirplaneMode(false)
-- 				mSleep(5000)
-- 			end
-- 			break
-- 		else
-- 			mSleep(500)
-- 			moveTowards(363, 1228,90,800,10)
-- 			mSleep(1000)
-- 		end
-- 	end
-- end

--[[随机内容(UTF-8中文字符占3个字符)]]
function Rnd_Word(strs, i, Length)
    local ret = ""
    local z
    if Length == nil then
        Length = 1
    end
    math.randomseed(tostring(os.time()):reverse():sub(1, 6) + State["随机常量"])
    math.random(string.len(strs) / Length)
    for i = 1, i do
        z = math.random(string.len(strs) / Length)
        ret = ret .. string.sub(strs, (z * Length) - (Length - 1), (z * Length))
    end
    return ret
end

State = {
    ["随机常量"] = 0,
    ["姓氏"] = "赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
        "姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍" ..
            "史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾" ..
                "孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈" ..
                    "项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡" ..
                        "田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸" ..
                            "左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄曲家封芮羿储靳汲邴糜松井" ..
                                "段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎" ..
                                    "祖武符刘景詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲邰从鄂索咸籍赖卓蔺屠" ..
                                        "蒙池乔阴鬱胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛" ..
                                            "寿通边扈燕冀郟浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈" ..
                                                "廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂" ..
                                                    "晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权" ..
                                                        "逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台" ..
                                                            "公冶宗政濮阳淳于单于太叔申屠公孙仲孙轩辕令狐钟离宇文长孙慕容鲜" ..
                                                                "于闾丘司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良" ..
                                                                    "拓拔夹谷宰父谷粱晋楚闫法汝鄢涂钦段干百里东郭南门呼延归海羊舌微" ..
                                                                        "生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱" ..
                                                                            "阳佟第五言福百家姓终",
    ["名字"] = {"梦琪","忆柳","之桃","慕青","问兰","尔岚","元香","bai初夏","沛菡","傲珊","曼文","乐菱","痴珊","恨玉","惜文","香寒","新柔","语蓉","海安","夜蓉","涵柏","水桃","醉蓝","春儿","语琴","从彤","傲晴","语兰","又菱","碧彤","元霜","怜梦","紫寒","妙彤","曼易","南莲","紫翠","雨寒","易烟","如萱","若南","寻真","晓亦","向珊","慕灵","以蕊","寻雁","映易","雪柳","孤岚","笑霜","海云","凝天","沛珊","寒云","冰旋","宛儿","绿真","盼儿","晓霜","碧凡","夏菡","曼香","若烟","半梦","雅绿","冰蓝","灵槐","平安","书翠","翠风","香巧","代云","梦曼","幼翠","友巧","听寒","梦柏","醉易","访旋","亦玉","凌萱","访卉","怀亦","笑蓝","春翠","靖柏","夜蕾","冰夏","梦松","书雪","乐枫","念薇","靖雁","寻春","恨山","从寒","忆香","觅波","静曼","凡旋","以亦","念露","芷蕾","千兰","新波","代真","新蕾","雁玉","冷卉","紫山","千琴","恨天","傲芙","盼山","怀蝶","冰兰","山柏","翠萱","恨松","问旋","从南","白易","问筠","如霜","半芹","丹珍","冰彤","亦寒","寒雁","怜云","寻文","乐丹","翠柔","谷山","之瑶","冰露","尔珍","谷雪","乐萱","涵菡","海莲","傲蕾","青槐","冬儿","易梦","惜雪","宛海","之柔","夏青","亦瑶","妙菡","春竹","痴梦","紫蓝","晓巧","幻柏","元风","冰枫","访蕊","南春","芷蕊","凡蕾","凡柔","安蕾","天荷","含玉","书兰","雅琴","书瑶","春雁","从安","夏槐","念芹","怀萍","代曼","幻珊","谷丝","秋翠","白晴","海露","代荷","含玉","书蕾","听白","访琴","灵雁","秋春","雪青","乐瑶","含烟","涵双","平蝶","雅蕊","傲之","灵薇","绿春","含蕾","从梦","从蓉","初丹。听兰","听蓉","语芙","夏彤","凌瑶","忆翠","幻灵","怜菡","紫南","依珊","妙竹","访烟","怜蕾","映寒","友绿","冰萍","惜霜","凌香","芷蕾","雁卉","迎梦","元柏","代萱","紫真","千青","凌寒","紫安","寒安","怀蕊","秋荷","涵雁","以山","凡梅","盼曼","翠彤","谷冬","新巧","冷安","千萍","冰烟","雅阳","友绿","南松","诗云","飞风","寄灵","书芹","幼蓉","以蓝","笑寒","忆寒","秋烟","芷巧","水香","映之","醉波","幻莲","夜山","芷卉","向彤","小玉","幼南","凡梦","尔曼","念波","迎松","青寒","笑天","涵蕾","碧菡","映秋","盼烟","忆山","以寒","寒香","小凡","代亦","梦露","映波","友蕊","寄凡","怜蕾","雁枫","水绿","曼荷","笑珊","寒珊","谷南","慕儿","夏岚","友儿","小萱","紫青","妙菱","冬寒","曼柔","语蝶","青筠","夜安","觅海","问安","晓槐","雅山","访云","翠容","寒凡","晓绿","以菱","冬云","含玉","访枫","含卉","夜白","冷安","灵竹","醉薇","元珊","幻波","盼夏","元瑶","迎曼","水云","访琴","谷波","乐之","笑白","之山","妙海","紫霜","平夏","凌旋","孤丝","怜寒","向萍","凡松","青丝","翠安","如天","凌雪","绮菱","代云","南莲","寻南","春文","香薇","冬灵","凌珍","采绿","天春","沛文","紫槐","幻柏","采文","春梅","雪旋","盼海","映梦","安雁","映容","凝阳","访风","天亦","平绿","盼香","觅风","小霜","雪萍","半雪","山柳","谷雪","靖易","白薇","梦菡","飞绿","如波","又晴","友易","香菱","冬亦","问雁","妙春","海冬","半安","平春","幼柏","秋灵","凝芙","念烟","白山","从灵","尔芙","迎蓉","念寒","翠绿","翠芙","靖儿","妙柏","千凝","小珍","天巧。妙旋","雪枫","夏菡","元绿","痴灵","绮琴","雨双","听枫","觅荷","凡之","晓凡","雅彤","香薇","孤风","从安","绮彤","之玉","雨珍","幻丝","代梅","香波","青亦","元菱","海瑶","飞槐","听露","梦岚","幻竹","新冬","盼翠","谷云","忆霜","水瑶","慕晴","秋双","雨真","觅珍","丹雪","从阳","元枫","痴香","思天","如松","妙晴","谷秋","妙松","晓夏","香柏","巧绿","宛筠","碧琴","盼兰","小夏","安容","青曼","千儿","香春","寻双","涵瑶","冷梅","秋柔","思菱","醉波","醉柳","以寒","迎夏","向雪","香莲","以丹","依凝","如柏","雁菱","凝竹","宛白","初柔","南蕾","书萱","梦槐","香芹","南琴","绿海","沛儿","晓瑶","听春","凝蝶","紫雪","念双","念真","曼寒","凡霜","飞雪","雪兰","雅霜","从蓉","冷雪","靖巧","翠丝","觅翠","凡白","乐蓉","迎波","丹烟","梦旋","书双","念桃","夜天","海桃","青香","恨风","安筠","觅柔","初南","秋蝶","千易","安露","诗蕊","山雁","友菱","香露","晓兰","白卉","语山","冷珍","秋翠","夏柳","如之","忆南","书易","翠桃","寄瑶","如曼","问柳","香梅","幻桃","又菡","春绿","醉蝶","亦绿","诗珊","听芹","新之","易巧","念云","晓灵","静枫","夏蓉","如南","幼丝","秋白","冰安","秋白","南风","醉山","初彤","凝海","紫文","凌晴","香卉","雅琴","傲安","傲之","初蝶","寻桃","代芹","诗霜","春柏","绿夏","碧灵","诗柳","夏柳","采白","慕梅","乐安","冬菱","紫安","宛凝","雨雪","易真","安荷","静竹","代柔","丹秋","绮梅","依白","凝荷","幼珊","忆彤","凌青","之桃","芷荷","听荷","代玉","念珍","梦菲","夜春","千秋","白秋","谷菱","飞松","初瑶","惜灵","恨瑶","梦易","新瑶","曼梅","碧曼","友瑶","雨兰","夜柳","香蝶","盼巧","芷珍","香卉","含芙","夜云","依萱","凝雁","以莲","易容","元柳","安南","幼晴","尔琴","飞阳","白凡","沛萍","雪瑶","向卉","采文","乐珍","寒荷","觅双","白桃","安卉","迎曼","盼雁","乐松","涵山","恨寒","问枫","以柳","含海","秋春","翠曼","忆梅","涵柳","梦香","海蓝","晓曼","代珊","春冬","恨荷","忆丹","静芙","绮兰","梦安","紫丝","千雁","凝珍","香萱","梦容","冷雁","飞柏","天真","翠琴","寄真","秋荷","代珊","初雪","雅柏","怜容","如风","南露","紫易","冰凡","海雪","语蓉","碧玉","翠岚","语风","盼丹","痴旋","凝梦","从雪","白枫","傲云","白梅","念露","慕凝","雅柔","盼柳","半青","从霜","怀柔","怜晴","夜蓉","代双","以南","若菱","芷文","寄春","南晴","恨之","梦寒","初翠","灵波","巧春","问夏","凌春","惜海"}
}

State["随机常量"] = tonumber(Rnd_Word("0123456789", 5))

mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"17|0|0x323333,9|8|0x323333,0|17|0x323333,17|17|0x323333,2|6|0xffffff,18|7|0xffffff,10|17|0xffffff,9|-1|0xffffff",90,0,0,749,1333)
	dialog(x..y,0)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y + 110, 4)
			mSleep(math.random(500, 700))
			toast("生日", 1)
			mSleep(1000)
		else
			mSleep(500)
			randomTap(x - 200, y, 4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
		end