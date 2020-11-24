local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")
require("TSLib")


--第一种方法
function imgupload2(_url,path,imageName)
	local respbody = {}
	local _file = imageName;
	local _end ='\r\n'..[[--abcd--]]..'\r\n'
	local reqfile= io.open(path)
	if reqfile == nil then
		print("file not found")
		return
	end
	local size = io.open(path):seek("end")
	if  size ==  0 then
		print("empty file")
		return
	end
	local info = "[*] uploading "..path.." to url : ".._url.."  size:  "..tostring(size).."bytes"    
	print(info)
	local  res , code , rsp_body = http.request {
		method = "POST",
		url = _url,
		headers = {
			["Content-Type"] =  "multipart/form-data;boundary=abcd",
			["Content-Length"] = #_file + size + #_end,
			["origin"] = "https://cli.im",
		},
		source = ltn12.source.cat(ltn12.source.string(_file),ltn12.source.file(reqfile),ltn12.source.string(_end)),
		sink = ltn12.sink.table(respbody)
	}
	if code  == 200 then
		return table.concat(respbody)
	else
		return nil
	end
end

url="https://upload.api.cli.im/upload.php?kid=cliim";
local _file1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="Filedata"; filename="1.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
aa = imgupload2(url, userPath() .. "/res/" .. "1.png",_file1);
if type(aa) ~= nil then
	tmp = json.decode(aa)["data"]["path"]
	toast(tmp,1)

--	--第一种解析
--	header_send = {
--		["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
--	}
--	body_send = {
--		["img"] = tmp,
--	}
--	ts.setHttpsTimeOut(60)
--	code,header_resp, body_resp = ts.httpsPost("https://cli.im/apis/up/deqrimg", header_send,body_send)
--	dialog(body_resp, time)
--	local tmp = json.decode(body_resp)
--	data = tmp["info"]["data"][1]
--	dialog(data, time)
--	nLog(data)

	--第二种解析
	local ts = require("ts")
	header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60) 
	code,header_resp, body_resp = ts.httpsGet("http://api.btstu.cn/aqrcode/api.php?url="..tmp, header_send,body_send)
	local tmp = json.decode(body_resp)
	dialog(tmp.qrurl,0)
else
	dialog("aa", time)
end





----第二种方法postman正常，但是请求就301重定向
--function imgupload2(_url,path,token,issos,imageName)
--	local respbody = {}
--	local _file = imageName;
--	local _end ='\r\n'..[[--abcd--]]..'\r\n'
--	local reqfile= io.open(path)
--	if reqfile == nil then
--		return
--	end
--	local size = io.open(path):seek("end")
--	if  size ==  0 then
--		return
--	end

--	local  res , code , rsp_body = http.request {
--		method = "POST",
--		url = _url,
--		headers = {
--			["Cache-Control"] = "no-cache",
--			["Postman-Token"] = "7b0db778-1029-4d0f-b251-63dcf73cc0da",
----			["Accept"] = "*/*",
----			["Accept-Encoding"] = "gzip, deflate, br",
----			["Accept-Language"] = "zh-CN,zh;q=0.9",
----			["Connection"] = "keep-alive",
----			["Sec-Fetch-Dest"] = "empty",
----			["Sec-Fetch-Mode"] = "cors",
----			["Sec-Fetch-Site"] = "same-origin",
--			["Content-Type"] =  "multipart/form-data;boundary=abcd",
--			["Content-Length"] =  #_file + size + #_end,
--			["Host"] =  "jiema.wwei.cn",
----			["Origin"] = "https://jiema.wwei.cn",
----			["Referer"] = "https://jiema.wwei.cn/",
--			["Cookie"] = "Hm_lvt_ee32a1614ffc926d0d8e45e76de43b91=1598235124; Hm_lvt_f09bc556daa9a9b9dbbaa1d3a0d313d8=1604898876,1604972556; Hm_lpvt_f09bc556daa9a9b9dbbaa1d3a0d313d8=1604972567; XSRF-TOKEN=eyJpdiI6Ill4RHFaRlV1WWhvTzROeVhwMTJ1Wmc9PSIsInZhbHVlIjoiNlVESXdlRENtVTNaNHlWaFNzSjcyYW10aTA0Y0FSVGNLWXdYNndKcHlGYXpwN1BVeWlNelJXNEhVeG1hdUhneSIsIm1hYyI6IjQ2OGRhNjk3YzU0M2RhNjFkNGQ0MDAwMjQ5NGE4YzczMWJjNDdiYTI2NmNjNWMyZmQxNjFkZDI5ODBjMDZjMjcifQ%3D%3D; laravel_session=eyJpdiI6ImNwUXNERUU0TWtmWmZSWVFxYzljVEE9PSIsInZhbHVlIjoiQ3pMTVJ3UnBtYlZqdVwvU1hmTXJwWVRpRlQxaGtjb0pDVkxvY0lnSlZSZWJCRGNIeXpUUlpTb290KzUwR2pCYVp1MXlwYVZsRXg1QklzSTczUU1RZmwrdzJLbGorU1FLRXRXeHFSR241SVwvVGZlY3paOEh0ZitENnBGRWU3dmh5UyIsIm1hYyI6ImQ2YjJjZDUyYWY2OTJlYmI0OTNjZTQ0ZTdhZTIzN2NmZTU3NGUxNTgzYjk0YzExOGFjODY1NzU1ZGY5YWE5NGIifQ%3D%3D",
--			["User-Agent"] = "PostmanRuntime/7.26.8",
--		},
--		source = ltn12.source.cat(ltn12.source.string(token),ltn12.source.string(issos),ltn12.source.string(_file),ltn12.source.file(reqfile),ltn12.source.string(_end)),
--		sink = ltn12.sink.table(respbody)
--	}

--	dialog(code, 0)
--	if code  == 200 then
--		return table.concat(respbody)
--	else
--		return nil
--	end
--end

--header_send = {
--	["Host"] = "jiema.wwei.cn",
--	["Cookie"] = "Hm_lvt_ee32a1614ffc926d0d8e45e76de43b91=1598235124; Hm_lvt_f09bc556daa9a9b9dbbaa1d3a0d313d8=1604898876,1604972556; Hm_lpvt_f09bc556daa9a9b9dbbaa1d3a0d313d8=1604972567; XSRF-TOKEN=eyJpdiI6Ill4RHFaRlV1WWhvTzROeVhwMTJ1Wmc9PSIsInZhbHVlIjoiNlVESXdlRENtVTNaNHlWaFNzSjcyYW10aTA0Y0FSVGNLWXdYNndKcHlGYXpwN1BVeWlNelJXNEhVeG1hdUhneSIsIm1hYyI6IjQ2OGRhNjk3YzU0M2RhNjFkNGQ0MDAwMjQ5NGE4YzczMWJjNDdiYTI2NmNjNWMyZmQxNjFkZDI5ODBjMDZjMjcifQ%3D%3D; laravel_session=eyJpdiI6ImNwUXNERUU0TWtmWmZSWVFxYzljVEE9PSIsInZhbHVlIjoiQ3pMTVJ3UnBtYlZqdVwvU1hmTXJwWVRpRlQxaGtjb0pDVkxvY0lnSlZSZWJCRGNIeXpUUlpTb290KzUwR2pCYVp1MXlwYVZsRXg1QklzSTczUU1RZmwrdzJLbGorU1FLRXRXeHFSR241SVwvVGZlY3paOEh0ZitENnBGRWU3dmh5UyIsIm1hYyI6ImQ2YjJjZDUyYWY2OTJlYmI0OTNjZTQ0ZTdhZTIzN2NmZTU3NGUxNTgzYjk0YzExOGFjODY1NzU1ZGY5YWE5NGIifQ%3D%3D",
--	["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36",
--}

--code,header_resp, body_resp = ts.httpsGet("https://jiema.wwei.cn/", header_send,body_send)
--a = strSplit(body_resp,"meta")
--b = strSplit(a[7],"content=")
--c = strSplit(b[2], "\">")
--token = strSplit(c[1], "\"")[2]
--nLog(token)

----url = "https://jiema.wwei.cn//fileupload.html?op=jiema&token="..token[1]
--url = "https://jiema.wwei.cn/wwei/file/temporaryFileUpload"

--local _token = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="_token"]]..'\r\n\r\n'..[[]]..token..[[]]
--local _isoss = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="isoss"]]..'\r\n'..[[1]]
--local _file1 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="1.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
--aa = imgupload2(url, userPath() .. "/res/1.png",_token,_isoss,_file1);
--dialog(tostring(aa), time)
--local tmp = json.decode(aa)["path"]
--dialog(tmp, 0)







--function imgupload2(_url,path,token,imageName)
--	local respbody = {}
--	local _file = imageName;
--	local _end ='\r\n'..[[--abcd--]]..'\r\n'
--	local reqfile= io.open(path)
--	if reqfile == nil then
--		print("file not found")
--		return
--	end
--	local size = io.open(path):seek("end")
--	if  size ==  0 then
--		print("empty file")
--		return
--	end
--	local info = "[*] uploading "..path.." to url : ".._url.."  size:  "..tostring(size).."bytes"    
--	print(info)
--	local  res , code , rsp_body = http.request {
--		method = "POST",
--		url = _url,
--		headers = {
--			["Content-Type"] =  "multipart/form-data;boundary=abcd",
--			["Content-Length"] =  #_file + size + #_end,
--			["Host"] =  "www.2vm.net.cn",
--			["Cookie"] = "PHPSESSID=krj1dbh418t7go208ljo0pchm0; Hm_lvt_c996967b3fe96e7b39bf93d6ecc6db2e=1604909317; Hm_lpvt_c996967b3fe96e7b39bf93d6ecc6db2e=1604909384",
--			["Postman-Token"] = "0df300c0-4446-4227-803a-dc8f158aa6ac",
--			["Cache-Control"] = "no-cache"
--		},
--		source = ltn12.source.cat(ltn12.source.string(token),ltn12.source.string(_file),ltn12.source.file(reqfile),ltn12.source.string(_end)),
--		sink = ltn12.sink.table(respbody)
--	}

--	dialog(code, 0)
--	if code  == 200 then
--		return table.concat(respbody)
--	else
--		return nil
--	end
--end


--url = "https://www.2vm.net.cn/home/index/upload"

--local _token = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="token"]]..'\r\n\r\n'..[[6b79a77180e9ec3a7ca351ebe54641a2]]
--local _file1 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="Filedata"; filename="1.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
--aa = imgupload2(url, userPath() .. "/res/1.png",_token,_file1);
--dialog(tostring(aa), time)
--local tmp = json.decode(aa)["path"]
--dialog(tmp, 0)





local ts = require("ts")
header_send = {}
body_send = {}
ts.setHttpsTimeOut(60) 
code,header_resp, body_resp = ts.httpsGet("http://api.btstu.cn/joingroup/api.php?uin=547329703", header_send,body_send)
dialog(body_resp, time)
