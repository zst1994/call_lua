local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")
require("TSLib")


function imgupload2(_url,path,imageName,_table1,_table2,_table3,_table4,_table5,_end)
	local respbody = {}
	local _file = imageName;

	local reqfile= io.open(path)
	if reqfile == nil then
		dialog("file not found")
		return
	end
	local size = io.open(path):seek("end")
	if  size ==  0 then
		dialog("empty file")
		return
	end

	local  res , code , rsp_body = http.request {
		method = "POST",
		url = _url,
		headers = {
			["Content-Type"] =  "multipart/form-data;boundary=abcd",
			["Content-Length"] = #_file + size + #_table1 + #_table2 + #_table3 + #_table4 + #_table5 + #_end,
		},
		source = ltn12.source.cat(ltn12.source.string(_table1),ltn12.source.string(_table2),ltn12.source.string(_table3),ltn12.source.string(_table4),ltn12.source.string(_table5),ltn12.source.string(_file),ltn12.source.file(reqfile),ltn12.source.string(_end)),
		sink = ltn12.sink.table(respbody)
	}

	if code  == 200 then
		return code
	else
		return nil
	end
end

function get_token(username,password)
	--获取token
	::getToken::
	header_send = {
		["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	}
	body_send = {
		["username"] = username,
		["loginpw"] = password,
	}
	ts.setHttpsTimeOut(60)
	code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/account/raw/login", header_send,body_send)
	nLog(body_resp)
	toast(body_resp,1)
	if code == 200 then
		local tmp = json.decode(body_resp)
		token = tmp.data.token
		return token
	else
		toast("获取token失败",1)
		goto getToken
	end
end

function get_task(token,discount,task_type)
	if discount == "0" then
		b_discount = false
	else
		b_discount = true
	end

	--获取任务
	::getTask::
	header_send = {
		["Token"] = token,
	}

	body_send = {
		["b_discount"] = b_discount,
		["access"] = task_type,
		["exam_status"] = 0 ,
	}
	ts.setHttpsTimeOut(60)
	code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/pull/one", header_send,body_send)
	toast(body_resp,1)
	nLog(body_resp)
	mSleep(math.random(500,700))
	if code == 200 then
		if #(body_resp:atrim()) > 0 then
			local tmp = json.decode(body_resp)
			if tmp.code == 0 then
				return tmp
			elseif tmp.code == 1207 then
				toast(tmp.msg,1)
				return nil
			else
				toast("获取任务失败",1)
				mSleep(5000)
				goto getTask
			end
		else
			toast("获取任务失败",1)
			mSleep(5000)
			goto getTask
		end
	else
		toast("获取任务失败"..tostring(body_resp),1)
		mSleep(5000)
		goto getTask
	end
end

function push_task(token,push_id)
	--获取上传参数
	::get_push_code::
	header_send = {
		["Token"] = token,
	}
	body_send = {}
	ts.setHttpsTimeOut(60)
	code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/oss/shot_img", header_send,body_send)
	if code == 200 then
		local tmp = json.decode(body_resp)
		tmp_accessid = tmp.data.accessid
		tmp_signature = tmp.data.signature
		tmp_prefix = tmp.data.prefix
		tmp_expire = tmp.data.expire
		tmp_dir = tmp.data.dir
		tmp_policy = tmp.data.policy
	else
		goto get_push_code
	end

	--上传截图
	url = "https://yun.zqzan.com/"
	local _table1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="key"]]..'\r\n\r\n'..[[]]..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'..[[]]
	local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="policy"]]..'\r\n\r\n'..[[]]..tmp_policy..[[]]
	local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="OSSAccessKeyId"]]..'\r\n\r\n'..[[]]..tmp_accessid..[[]]
	local _table4 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="signature"]]..'\r\n\r\n'..[[]]..tmp_signature..[[]]
	local _table5 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="success_action_status"]]..'\r\n\r\n'..[[200]]
	local _file1  = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'
	local _end    = '\r\n'..[[--abcd--]]..'\r\n'

	aa = imgupload2(url, userPath() .. "/res/test.jpg",_file1,_table1,_table2,_table3,_table4,_table5,_end);
	--aa返回200标识上传截图成功，然后进行绑定操作
	if aa == 200 then
		--提交任务
		::push::
		header_send = {
			["Token"] = token,
		}
		body_send = {
			["doit_id"] = push_id,
			["shot_img"] = "https://zqzan.oss-cn-shanghai.aliyuncs.com/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/submit/task", header_send,body_send)
		if code == 200 then
			local tmp = json.decode(body_resp)
			toast(tmp.msg, 1)
		else
			goto push
		end
	end
end

function delete_task(token,push_id)
	--放弃任务
	::giveup::
	header_send = {
		["Token"] = token,
	}
	body_send = {
		["doit_id"] = push_id,
	}
	ts.setHttpsTimeOut(60)
	code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/giveup/task", header_send,body_send)
	if code == 200 then
		if #(body_resp:atrim()) > 0 then
			local tmp = json.decode(body_resp)
			toast(tmp.msg, 1)
		else
			goto giveup
		end
	else
		goto giveup
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
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "用户名",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "输入用户名",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "用户名密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "输入密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "操作类型",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "养号,任务",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "特价援助",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "无,特价",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择任务",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "CheckBoxGroup",                    
				["list"] = "关注,点赞,转发",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设备型号",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "se,6",
				["select"] = "0",  
				["countperline"] = "4",
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, username, password, workType, discount, taskType, phoneType = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
	
	if workType == "0" then
		::open_app::
		closeApp("com.ss.iphone.ugc.Aweme")
		mSleep(1000)
		openURL("snssdk1128://")
		if phoneType == "0" then
			while (true) do
				--启动页
				mSleep(math.random(500,700))
				if getColor(366,  432) == 0xff004f and getColor(328,  414) == 0xff004f then
					mSleep(3000)
				end

				mSleep(math.random(500,700))
				if getColor(385,  119) == 0xffffff or getColor(592,   91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		elseif phoneType == "1" then
			while (true) do
				--跳过广告
				mSleep(math.random(500,700))
				if getColor(663,   58) == 0xffffff and getColor(687,   65) == 0xffffff then
					mSleep(math.random(500,700))
					tap(663,   58)
					mSleep(math.random(500,700))
				end

				--启动页
				mSleep(math.random(500,700))
				if getColor(400,  528) == 0xff004f and getColor(400,  528) == 0xff004f then
					mSleep(3000)
				end

				mSleep(math.random(500,700))
				if getColor(456,  119) == 0xffffff or getColor(702,  91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		end
		
		for var= 0, 300 do
			mSleep(math.random(500,700))
			moveTowards( 283,  944, 80, 500,50)
			mSleep(math.random(2500,4000))
			toast("养号:"..var,1)
			mSleep(math.random(2500,4000))
		end
	else
		::start::
		mSleep(math.random(500,700))
		token = get_token(username,password)
		toast(token,1)
		mSleep(1000)
		task_list = strSplit(taskType,"@")
		if #task_list == 2 then
			task_type = 3
		else
			if task_list[1] == "0" then
				task_type = 2
			elseif task_list[1] == "1" then
				task_type = 1
			elseif task_list[1] == "2" then
				task_type = 8
			end
		end

		::open_app::
		closeApp("com.ss.iphone.ugc.Aweme")
		mSleep(1000)
		openURL("snssdk1128://")
		if phoneType == "0" then
			while (true) do
				--启动页
				mSleep(math.random(500,700))
				if getColor(366,  432) == 0xff004f and getColor(328,  414) == 0xff004f then
					mSleep(3000)
				end

				mSleep(math.random(500,700))
				if getColor(385,  119) == 0xffffff or getColor(592,   91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		elseif phoneType == "1" then
			while (true) do
				--跳过广告
				mSleep(math.random(500,700))
				if getColor(663,   58) == 0xffffff and getColor(687,   65) == 0xffffff then
					mSleep(math.random(500,700))
					tap(663,   58)
					mSleep(math.random(500,700))
				end

				--启动页
				mSleep(math.random(500,700))
				if getColor(400,  528) == 0xff004f and getColor(400,  528) == 0xff004f then
					mSleep(3000)
				end

				mSleep(math.random(500,700))
				if getColor(456,  119) == 0xffffff or getColor(702,  91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		end

		while true do
			mSleep(math.random(500,700))
			isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
			if isfront == 0 then
				goto open_app
			end

			task = get_task(token,discount,task_type)
			if task ~= nil then
				if task.data.type == 1 then
					dz_num = 0
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..anchor_id.."\r\n"..aweme_id, 1)
					mSleep(1000)

					openURL("snssdk1128://aweme/detail/"..aweme_id)
					mSleep(3000)
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								tap(274,520)
								mSleep(100)
								tap(270,510)
								mSleep(100)
								tap(270,510)
								mSleep(100)
								tap(270,510)
								mSleep(10)
								tap(270,510)
								mSleep(math.random(1500, 2500))
								toast("点赞",1)
								break
							else
								dz_num = dz_num + 1
							end
						elseif phoneType =="1" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								tap(274,520)
								mSleep(100)
								tap(270,510)
								mSleep(100)
								tap(270,510)
								mSleep(100)
								tap(270,510)
								mSleep(10)
								tap(270,510)
								mSleep(math.random(1500, 2500))
								toast("点赞",1)
								break
							else
								dz_num = dz_num + 1
							end
						end

						if dz_num > 10 then
							delete_task(token,id)
							goto start
						end

						mSleep(math.random(500,700))
						isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
						if isfront == 0 then
							goto open_app
						end
					end
					mSleep(1000)
					snapshot("test.jpg", 0, 0, 749, 1333,0.7);
					mSleep(math.random(500,700))
					toast("截图成功",1)
					mSleep(math.random(500,700))
					push_task(token,id)

				elseif task.data.type == 2 then
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..anchor_id.."\r\n"..aweme_id, 1)
					mSleep(1000)

					mSleep(1000)
					openURL("snssdk1128://user/profile/"..anchor_id.."?refer=web&gd_label=click_wap_profile_bottom&type=need_follow&needlaunchlog=1")
					mSleep(math.random(4000, 7000))
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xebeced, "2|18|0xebeced,11|23|0xebeced,21|2|0xebeced,40|14|0xebeced,54|14|0xebeced,73|13|0xebeced,109|13|0xebeced,57|-15|0x393a44,63|31|0x393a44", 90, 0, 0, 639, 1135)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								snapshot("test.jpg", 0, 0, 749, 1333,0.7);
								mSleep(math.random(500,700))
								toast("截图成功",1)
								mSleep(math.random(500,700))
								push_task(token,id)
								break
							end

							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|45|0xfe2c55,74|26|0xfe2c55,7|22|0xfe2c55,-7|28|0xffffff,62|29|0xffffff", 90, 0, 0, 639, 1135)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								delete_task(token,id)
								task_type = 1 
								goto start
							end
						elseif phoneType == "1" then
							mSleep(math.random(500,700))
							x, y = findMultiColorInRegionFuzzy(0x161823,"3|20|0x161823,11|23|0x161823,19|2|0x161823,40|15|0x161823,53|19|0x161823,69|13|0x161823,108|20|0x161823", 90, 0, 0, 749,  1333)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								snapshot("test.jpg", 0, 0, 749, 1333,0.7);
								mSleep(math.random(500,700))
								toast("截图成功",1)
								mSleep(math.random(500,700))
								push_task(token,id)
								break
							end
							
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "-1|38|0xfe2c55,62|20|0xfe2c55,-43|13|0xfe2c55,-22|20|0xffffff,50|24|0xffffff", 90, 0, 0, 749, 1333)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								delete_task(token,id)
								task_type = 1 
								goto start
							end
						end

						mSleep(math.random(500,700))
						isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
						if isfront == 0 then
							goto open_app
						end
					end
				elseif task.data.type == 8 then
					dz_num = 0
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..anchor_id.."\r\n"..aweme_id, 1)
					mSleep(1000)

					openURL("snssdk1128://aweme/detail/"..aweme_id)
					mSleep(3000)
					while true do
						mSleep(math.random(500,700))
						x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
						if x~=-1 and y~=-1 then
							mSleep(math.random(1500, 2500))
							randomTap(x + 8,y + 420, 3)
							mSleep(math.random(1500, 2500))
							while (true) do
								mSleep(500)
								x,y = findMultiColorInRegionFuzzy( 0xface15, "-6|23|0xffffff,19|25|0xffffff,-26|42|0xface15,11|54|0xface15,41|15|0xface15,6|34|0xface15", 90, 0, 0, 639, 1135)
								if x~=-1 and y~=-1 then
									mSleep(math.random(1500, 2500))
									randomTap(x,y, 2)
									mSleep(math.random(2500, 3000))
									key = "ReturnOrEnter"
									keyDown(key)
									mSleep(100)
									keyUp(key)
									mSleep(3000)
									break
								end
							end
							toast("转发",1)
							break
						else
							dz_num = dz_num + 1
						end

						if dz_num > 10 then
							delete_task(token,id)
							goto start
						end

						mSleep(math.random(500,700))
						isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
						if isfront == 0 then
							goto open_app
						end
					end
					--个人中心
					openURL("snssdk1128://user/profile/id")
					while (true) do
						mSleep(500)
						x,y = findMultiColorInRegionFuzzy( 0xface15, "54|0|0xface15,117|0|0xface15,199|0|0xface15", 90, 0, 0, 639, 1135)
						if x >= 214 then
							mSleep(500)
							moveTowards( 283,  1044, 80, 1000,50)
							mSleep(2000)
							break
						else
							mSleep(500)
							tap(300,y-60)
							mSleep(500)
						end
					end
					
					mSleep(1000)
					snapshot("test.jpg", 0, 0, 749, 1333,0.7);
					mSleep(math.random(500,700))
					toast("截图成功",1)
					mSleep(math.random(500,700))
					push_task(token,id)
				end
			else
				closeApp("com.ss.iphone.ugc.Aweme")
				mSleep(1000)
				openURL("snssdk1128://")
				mSleep(5000)
				for var= 0, 20 do
					mSleep(math.random(500,700))
					moveTowards( 283,  944, 80, 500,50)
					mSleep(math.random(2500,4000))
					toast("点赞关注暂无任务,"..(100 - var * 5).."秒后重新获取",1)
					mSleep(math.random(2500,4000))
				end

				if #task_list == 2 then
					if task_type == 3 then
						task_type = 1 
					elseif task_type == 1 then
						task_type = 2
					elseif task_type == 2 then
						task_type = 3
					end
				end
				
				if task_type == 8 then
					task_type = 1
				end
			end
		end
	end
end

main()