local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")
require("TSLib")


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

url="http://oss.06km.com:8081/mz/oss/pic/upload/scriptImg";
local _file1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="tmp.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'
aa = imgupload2(url, userPath() .. "/res/" .. "tmp.jpg",_file1);
local tmp = json.decode(aa)
dialog(tmp["data"]["url"], 0)




