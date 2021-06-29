local ts = require("ts")
local json = ts.json 
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")
require("TSLib")

function imgupload2(_url,path,imageName)
	local respbody = {}
	local _file = imageName;
	local _end ='\r\n'..[[--abcd--]]..'\r\n'
	local reqfile= io.open(path)

	local size = io.open(path):seek("end")

	local info = "[*] uploading "..path.." to url : ".._url.."  size:  "..tostring(size).."bytes"    

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

function main()
	local w,h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 100,
		views = {
			{
				["type"] = "Label",
				["text"] = "抖音脚本",
				["size"] = 30,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "循环次数",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的循环次数",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择任务",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "点赞,关注,特价点赞,特价关注",
				["select"] = "0",  
				["countperline"] = "2",
			},
			
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, back_time, word_way = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
	
	for i = 1, tonumber(back_time) do
		::token::
		header_send = {ContentType = "application/x-www-form-urlencoded"}
		body_send = {
			["account"] = "bit001",
			["password"] = "bit123456"
		}
		ts.setHttpsTimeOut(60) 
		code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/script/login", header_send, body_send)
		
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.status == 200 then
				token = tmp.data.token
				toast(token)
			end
		else
			goto token
		end
		
		if word_way == "0" then
			uniqueKey = "dy_zpsj"
		elseif word_way == "1" then
			uniqueKey = "dy_zpgz"
		elseif word_way == "2" then
			uniqueKey = "dy_tjzpsj"
		elseif word_way == "3" then
			uniqueKey = "dy_tjzpgz"
		end
		
		::get_id::
		header_send = {ContentType = "application/x-www-form-urlencoded"}
		body_send = {
			["token"] = token,
		}
		ts.setHttpsTimeOut(60) 
		code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/get/subList", header_send, body_send)
		
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.status == 200 then
				data_list = tmp.data
				for k,v in pairs(data_list) do
					if v["uniqueKey"] == uniqueKey then
						if v["openSelection"] then
							task_id = v["id"]
							break
						else
							dialog("当前任务openSelection为false",0)
							lua_exit()
						end
					end
				end
			end
		else
			goto get_id
		end
		
		::get_task::
		header_send = {ContentType = "application/x-www-form-urlencoded"}
		body_send = {
			["token"] = token,
			["ids"] = task_id,
		}
		ts.setHttpsTimeOut(60) 
		code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/get/task", header_send, body_send)
		
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.status == 200 then
				push_id = tmp.data.id
				if word_way == "0" or word_way == "2" then
					url = strSplit(tmp.data.url2, ":")[2]
					if type(url) == "nil" then
						toast("重新获取任务",1)
						mSleep(1000)
						goto token
					end
				else
					url = strSplit(tmp.data.url3, ":")[2]
					if type(url) == "nil" then
						toast("重新获取任务",1)
						mSleep(1000)
						goto token
					end
				end
			elseif tmp.status == 100 then
				toast(tmp.description,1)
				mSleep(8000)
				goto token
			end
		else
			goto get_task
		end
		
		openURL("snssdk1128:"..url)
		
		while true do
			mSleep(500)
			x, y = findMultiColorInRegionFuzzy(0xe9e8e7,"563|18|0xffffff,554|8|0xffffff,530|-12|0xffffff,530|8|0xffffff,552|-12|0xffffff", 90, 0, 0, 640, 1136)
			if x~=-1 and y~=-1 then
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0xfe2c55,"16|0|0xfe2c55,-1|17|0xfe2c55,23|17|0xfe2c55", 90, 0, 0, 640, 1136)
				if x~=-1 and y~=-1 then
					toast("准备操作",1)
					mSleep(2000)
					if word_way == "0" or word_way == "2" then
						mSleep(500)
						tap(274,448)
						mSleep(50)
						tap(274,449)
						mSleep(500)
						toast("点赞",1)
						break
					else
						moveTowards( 476,  332, 180, 400, 50)
						mSleep(2000)
						while true do
							mSleep(500)
							x, y = findMultiColorInRegionFuzzy(0xfe2c55,"157|-9|0xfe2c55,0|36|0xfe2c55,155|34|0xfe2c55", 90, 0, 0, 640, 1136)
							if x~=-1 and y~=-1 then
								mSleep(500)
								tap(x,y)
								mSleep(500)
								toast("关注",1)
								break
							end
						end
					end
				else
					toast("视频消失",1)
					mSleep(1000)
					goto token
				end
			end
			
			if word_way == "1" or word_way == "3" then
				mSleep(500)
				x, y = findMultiColorInRegionFuzzy(0xfe2c55,"157|-9|0xfe2c55,0|36|0xfe2c55,155|34|0xfe2c55", 90, 0, 0, 640, 1136)
				if x~=-1 and y~=-1 then
					mSleep(500)
					tap(x,y)
					mSleep(500)
					toast("关注",1)
					break
				end
			end
		end
		
		mSleep(2000)
		snapshot("test.jpg", 0, 0, 640, 1136,0.7);
		
		url="http://oss.06km.com:8081/mz/oss/pic/upload/scriptImg";
		local _file1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'
		aa = imgupload2(url, userPath() .. "/res/test.jpg",_file1);
		tmp = json.decode(aa)
		
		::push_task::
		header_send = {ContentType = "application/x-www-form-urlencoded"}
		body_send = {
			["token"] = token,
			["id"] = push_id,
			["picUrl"] = tmp.data.url
		}
		ts.setHttpsTimeOut(60) 
		code,status_resp, body_resp = ts.httpsPost("http://jb.06km.com/mz/scriptApi/task/scriptSubmit", header_send, body_send)
		
		if code == 200 then
			tmp = json.decode(body_resp)
			if tmp.status == 200 then
				if tmp.description == "OK" then
					toast("提交成功",1)
					mSleep(1000)
				end
			elseif tmp.status == 100 then
				toast(tmp.description,1)
				mSleep(8000)
				goto push_task
			end
		else
			goto push_task
		end
	end
end

main()
