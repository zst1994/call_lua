require "TSLib"
local t,sz = pcall(require,"sz")
local http,ltn12
local username,password,yzmId,token
token=""
if t then
	http = require"szocket.http"
	ltn12 = require"ltn12"
	else
	http = require"socket.http"
	ltn12 = require"ltn12"
end
http.TIMEOUT=60
local function fmt(p, ...)
	if select('#', ...) == 0 then
		return p
	else return string.format(p, ...) end
end

local function tprintf(t, p, ...)
	t[#t+1] = fmt(p, ...)
end

--添加数据
local function append_data(r, k, data, extra)
	tprintf(r, "content-disposition: form-data; name=\"%s\"", k)
	if extra.filename then
		tprintf(r, "; filename=\"%s\"", extra.filename)
	end
	if extra.content_type then
		tprintf(r, "\r\ncontent-type: %s", extra.content_type)
	end
	if extra.content_transfer_encoding then
		tprintf(
			r, "\r\ncontent-transfer-encoding: %s",
			extra.content_transfer_encoding
		)
	end
	tprintf(r, "\r\n\r\n")
	tprintf(r, data)
	tprintf(r, "\r\n")
end

--生成封包边界
local function gen_boundary()
	local t = {"BOUNDARY-"}
	for i=2,17 do t[i] = string.char(math.random(65, 90)) end
	t[18] = "-BOUNDARY"
	return table.concat(t)
end

--数据封包
local function encode(t, boundary)
	boundary = boundary or gen_boundary()
	local r = {}
	local _t
	for k,v in pairs(t) do
		tprintf(r, "--%s\r\n", boundary)
		_t = type(v)
		if _t == "string" then
			append_data(r, k, v, {})
		elseif _t == "table" then
			assert(v.data, "invalid input")
			local extra = {
				filename = v.filename or v.name,
				content_type = v.content_type,
				--content_transfer_encoding = v.content_transfer_encoding or "binary",
			}
			append_data(r, k, v.data, extra)
		else
			error(string.format("unexpected type %s", _t))
		end
	end
	tprintf(r, "--%s--\r\n", boundary)
	return table.concat(r), boundary
end

local function lzReadFileByte(file)
	local f = io.open(file,"rb")
	local retbyte = f:read("*all")
	f:close()
	return retbyte
end

--查询余额
local function lzPoint(user, pwd)
	local response_body = {}
	local post_data = string.format("user_name=%s&user_pw=%s", user, pwd);  
	res, code = http.request{  
		url = "http://v1-http-api.jsdama.com/api.php?mod=php&act=point",  
		method = "POST",  
		headers =   
		{  
			["Content-Type"] = "application/x-www-form-urlencoded",  
			["Content-Length"] = #post_data,  
		},  
		source = ltn12.source.string(post_data),  
		sink = ltn12.sink.table(response_body)  
	}
	--解析返回结果
	local strExp = "data\":(.*)}";
	local strBody = table.concat(response_body);
	local strResult = string.match(strBody, strExp);
	return strResult;
end
--图片识别
local function lzRecoginze(user, pwd, imagefile, yzmtype)
	local pBuffer = lzReadFileByte(imagefile);
	local rq = {
		user_name = user,
		user_pw = pwd,
		yzm_minlen = "0",
		yzm_maxlen = "0",
		yzmtype_mark = tostring(yzmtype),
		zztool_token = token,
		upload = { filename = "yzm.jpg", content_type = "image/jpeg", data = pBuffer }
	};
	local response_body = {};
	local boundary = gen_boundary();
	local post_data, bb = encode(rq, boundary);
	res, code = http.request{  
		url = "http://v1-http-api.jsdama.com/api.php?mod=php&act=upload",  
		method = "POST",  
		headers =   
		{  
			["Content-Type"] = fmt("multipart/form-data; boundary=%s", boundary),  
			["Content-Length"] = #post_data,  
		},  
		source = ltn12.source.string(post_data),  
		sink = ltn12.sink.table(response_body)
	}	
	--解析返回结果
	local strBody = table.concat(response_body);
	local bl,tbody=pcall(sz.json.decode,strBody)
	if bl then
		if tbody.result==true then
			local id, vcode = tbody.data.id,tbody.data.val
			if (id == nil or vcode == nil) then
				return false, id, vcode;
			else
				return true, id, vcode;
			end
		else 
			return false,nil,nil,tbody.data
		end
	else 
		return bl,nil,nil,"服务器返回json错误"
	end
end

--识别报错
local function lzReportError(user, pwd, yzmid)
	local response_body = {}
	local post_data = string.format("user_name=%s&user_pw=%s&yzm_id=%s", user, pwd, yzmid);  
	local res, code = http.request{
		url = "http://v1-http-api.jsdama.com/api.php?mod=php&act=error",  
		method = "POST",  
		headers =   
		{  
			["Content-Type"] = "application/x-www-form-urlencoded",  
			["Content-Length"] = #post_data,  
		},  
		source = ltn12.source.string(post_data),  
		sink = ltn12.sink.table(response_body)  
	}
	--解析返回结果
	local strExp = "result\":true";
	local strBody = table.concat(response_body);
	local strResult = string.match(strBody, strExp);
	if (strResult ~= nil) then
		return "report success";
	else
		return "report failed";
	end
end
local function info(user,pwd,tk)
	username=user;password=pwd;token=tk or token
end
local function lzBalance()
	return lzPoint(username, password)
end
local function ocrImage(path,type,timeout)
	http.TIMEOUT = timeout or 30
	local lzRe, yzmid, jieguo,err=lzRecoginze(username, password, path,type)
	if lzRe then yzmId=yzmid return jieguo,yzmid else return nil,err end
end
local function lzScreen(x1,y1,x2,y2,type,timeout,scale)
	scale=scale or 1
	local path=userPath().."/res/lztmp.png"
	snapshot("lztmp.png",x1,y1,x2,y2,scale)
	local ret1,ret2=ocrImage(path,type,timeout)
	os.remove(path)
	return ret1,ret2
end
local function lzReportError2(yzmid)
	yzmid=yzmid or yzmId
	return lzReportError(username, password, yzmid)
end

local lz={}

lz.point=lzPoint
lz.recoginze=lzRecoginze
lz.reportError=lzReportError

lz.ocrInfo=info
lz.ocrBalance=lzBalance
lz.ocrScreen=lzScreen
lz.ocrImage=ocrImage
lz.ocrReportError=lzReportError2




-----------------可修改区域-----------------
lz.ocrInfo("cx3881156cx", "Cx940912.", "dca22e0e65f1874097102c3bcb248143")--登陆函数，使用下方函数前必须已经调用过此函数！！！
balance = lz.ocrBalance()
if tonumber(balance) < 10 then
    dialog("当前点数低于10，请充值", 0)
    luaExit()
else
    toast("当前剩余点数：" .. balance, 1)
end

result, id = lz.ocrScreen(34, 265, 593, 903, "1303", 60)
if result ~= nil then
    toast(result, 1)
    mSleep(1000)
    data = strSplit(result,"|")
    for i = 1, #data do
        zb = strSplit(data[i],",")
        mSleep(500)
        tap(zb[1] + 34, zb[2] + 265)
        mSleep(500)
    end
else
    toast("识别失败", 1)
    mSleep(1000)
    report = lz.ocrReportError(id)
    log(report)
    toast(report, 1)
end
-----------------可修改区域-----------------