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
				["list"] = "关注,点赞,转发,评论赞,评论",
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
				if getColor(452,  120) == 0xffffff or getColor(385,  119) == 0xffffff or getColor(592,   91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		elseif phoneType == "1" then
			while (true) do
--				--跳过广告
--				mSleep(math.random(500,700))
--				if getColor(663,   58) == 0xffffff and getColor(687,   65) == 0xffffff then
--					mSleep(math.random(500,700))
--					tap(663,   58)
--					mSleep(math.random(500,700))
--				end

				--启动页
				mSleep(math.random(500,700))
				if getColor(400,  528) == 0xff004f and getColor(400,  528) == 0xff004f then
					mSleep(3000)
				end

				mSleep(math.random(500,700))
				if getColor(531,  119) == 0xffffff or getColor(456,  119) == 0xffffff or getColor(702,  91) == 0xffffff then
					toast("准备操作",1)
					mSleep(1000)
					break
				end
			end
		end
		
		for var= 0, 300 do
			wait = 0
			mSleep(math.random(500,700))
			moveTowards(283,  944, math.random(70,100), 600, 50)
			mSleep(math.random(2500,4000))
			while true do
				if phoneType == "0" then
					mSleep(math.random(500,700))
					x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
					if x~=-1 and y~=-1 then
						mSleep(math.random(1500, 2500))
						randomsTap(x + 10,y + 120,5)
						mSleep(math.random(1500, 2500))
						break
					else
						wait = wait + 1
					end
				elseif phoneType == "1" then
					mSleep(math.random(500,700))
					x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
					if x~=-1 and y~=-1 then
						mSleep(math.random(1500, 2500))
						randomsTap(x + 10,y + 120,5)
						mSleep(math.random(1500, 2500))
						break
					else
						wait = wait + 1
					end
				end
				
				if wait > 10 then
					break
				end
			end
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
			elseif task_list[1] == "3" then
				task_type = 16
			elseif task_list[1] == "4" then
				task_type = 4
			end
		end

		::open_app::
		closeApp("com.ss.iphone.ugc.Aweme")
		mSleep(math.random(1500,3000))

		while true do
			task = get_task(token,discount,task_type)
			if task ~= nil then
				if task.data.type == 1 then
					dz_num = 0
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..anchor_id.."\r\n"..aweme_id, 1)
					mSleep(1000)

					openURL("snssdk1128://aweme/detail/"..aweme_id.."?refer=web&gd_label=click_wap_detail_download_feature&appParam=%7B%22__type__%22%3A%22wap%22%2C%22position%22%3A%22900718067%22%2C%22parent_group_id%22%3A%226553813763982626051%22%2C%22webid%22%3A%226568996356873356814%22%2C%22gd_label%22%3A%22click_wap%22%7D&needlaunchlog=1")
					mSleep(math.random(3000, 4500))
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomsTap(x + 10,y + 120,5)
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
								randomsTap(x + 10,y + 120,5)
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
					mSleep(500)
					push_task(token,id)
					mSleep(math.random(500,700))
					closeApp("com.ss.iphone.ugc.Aweme")
					mSleep(math.random(1500,3000))
					
				elseif task.data.type == 2 then
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..anchor_id.."\r\n"..aweme_id, 1)

					mSleep(1000)
					openURL("snssdk1128://user/profile/"..anchor_id)
					mSleep(math.random(6000, 8000))
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|45|0xfe2c55,74|26|0xfe2c55,7|22|0xfe2c55,-7|28|0xffffff,62|29|0xffffff", 90, 0, 0, 639, 1135)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								break
							end
						elseif phoneType == "1" then
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "-1|38|0xfe2c55,62|20|0xfe2c55,-43|13|0xfe2c55,-22|20|0xffffff,50|24|0xffffff", 90, 0, 0, 749, 1333)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								break
							end
						end
					end
					
					snapshot_bool = true
					if phoneType == "0" then
						while true do
							if snapshot_bool then
								mSleep(math.random(500,700))
								x,y = findMultiColorInRegionFuzzy( 0xebeced, "2|18|0xebeced,11|23|0xebeced,21|2|0xebeced,40|14|0xebeced,54|14|0xebeced,73|13|0xebeced,109|13|0xebeced,57|-15|0x393a44,63|31|0x393a44", 90, 0, 0, 639, 1135)
								if x~=-1 and y~=-1 then
									snapshot_bool = false
									mSleep(math.random(500,700))
									snapshot("test.jpg", 0, 0, 749, 1333,0.7);
									mSleep(math.random(500,700))
									toast("关注截图成功",1)
									mSleep(math.random(500,700))
									push_task(token,id)
									break
								end
							end

							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|45|0xfe2c55,74|26|0xfe2c55,7|22|0xfe2c55,-7|28|0xffffff,62|29|0xffffff", 90, 0, 0, 639, 1135)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								delete_task(token,id)
								task_type = 1 
								goto open_app
							end
							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
						end
					elseif phoneType == "1" then
						while true do
							if snapshot_bool then
								mSleep(math.random(500,700))
								x, y = findMultiColorInRegionFuzzy(0x161823,"3|20|0x161823,11|23|0x161823,19|2|0x161823,40|15|0x161823,53|19|0x161823,69|13|0x161823,108|20|0x161823", 90, 0, 0, 749,  1333)
								if x~=-1 and y~=-1 then
									snapshot_bool = false
									mSleep(math.random(500,700))
									snapshot("test.jpg", 0, 0, 749, 1333,0.7);
									mSleep(math.random(500,700))
									toast("关注截图成功",1)
									mSleep(math.random(500,700))
									push_task(token,id)
									break
								end
							end

							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "-1|38|0xfe2c55,62|20|0xfe2c55,-43|13|0xfe2c55,-22|20|0xffffff,50|24|0xffffff", 90, 0, 0, 749, 1333)
							if x~=-1 and y~=-1 then
								mSleep(math.random(500,700))
								randomTap(x,y,5)
								mSleep(math.random(500,700))
								delete_task(token,id)
								task_type = 1 
								goto open_app
							end
							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
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
					if phoneType == "0" then
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
					elseif phoneType == "1" then
						while true do
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
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
										inputText("很有意思呀！！！")
										mSleep(2000)
										while (true) do
											mSleep(500)
											x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "-9|-11|0xfe2c55,16|-16|0xfe2c55,18|8|0xfe2c55,-9|7|0xfe2c55,6|3|0xffffff,-1|-7|0xffffff,13|-5|0xffffff,35|2|0xffffff", 90, 0, 0, 749, 1333)
											if x~=-1 and y~=-1 then
												mSleep(500)
												tap(x,y)
												mSleep(3000)
												break
											end
										end
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
					end

					--个人中心
					openURL("snssdk1128://user/profile/id")
					mSleep(3000)
					if phoneType == "0" then
						while (true) do
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy( 0xface15, "54|0|0xface15,117|0|0xface15,199|0|0xface15", 90, 0, 0, 639, 1135)
							if x >= 214 then
								mSleep(500)
								moveTowards( 283,  844, math.random(70,90), 50,10)
								mSleep(2000)
								break
							else
								mSleep(500)
								tap(300,y-60)
								mSleep(500)
							end
						end
					elseif phoneType == "1" then
						while (true) do
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy( 0x161823, "13|0|0x161823,21|-3|0x161823,40|-14|0x161823,40|-5|0x161823,31|3|0x161823,45|3|0x161823,54|3|0x161823", 90, 0, 0, 749, 1333)
							if x~=-1 and y~=-1 then
								mSleep(500)
								tap(x + 320,y)
								mSleep(2000)
							end
							
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy( 0x161823, "0|8|0x161823,15|3|0x161823,23|11|0x161823,40|0|0x161823,37|18|0x161823,44|23|0x161823", 90, 0, 0, 749, 1333)
							if x~=-1 and y~=-1 then
								mSleep(500)
								moveTowards( 283,  1044, math.random(70,90), 250)
								mSleep(2000)
								break
							end
						end
					end
					
					mSleep(1000)
					snapshot("test.jpg", 0, 0, 749, 1333,0.7);
					mSleep(math.random(500,700))
					toast("转发截图成功",1)
					mSleep(math.random(500,700))
					push_task(token,id)
				elseif task.data.type == 16 then
					plz_num = 0
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..tostring(anchor_id).."\r\n"..aweme_id, 1)
					mSleep(1000)

					openURL("snssdk1128://aweme/detail/"..aweme_id)
					mSleep(3000)
					if phoneType == "0" then
						while true do
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
								toast("评论",1)						
								break
							else
								plz_num = plz_num + 1
							end

							if plz_num > 10 then
								delete_task(token,id)
								goto start
							end

							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
						end
					elseif phoneType == "1" then
						while true do
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
								toast("评论",1)
								break
							else
								plz_num = plz_num + 1
							end

							if plz_num > 10 then
								delete_task(token,id)
								goto start
							end

							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
						end
					end
					
					plz = 0
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x, y = findMultiColorInRegionFuzzy(0xd6d5d8,"-8|-10|0xd6d5d9,1|15|0xd5d5d8,15|-7|0xd5d4d8,-7|7|0xd6d5d9,10|7|0xd5d5d8", 90, 525, 308, 639,  1038)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x,y, 2)
								mSleep(math.random(1500, 2500))
								plz = plz + 1
								plz_num = 0
							else
								plz_num = plz_num + 1
							end
						elseif phoneType == "1" then
							mSleep(math.random(500,700))
							x, y = findMultiColorInRegionFuzzy(0xd2d0d2,"1|-9|0xd1d0d1,-8|-13|0xd1d0d1,-15|-4|0xd1d0d1,-1|13|0xd2d0d2,16|-7|0xd2d0d2,9|4|0xd2d0d2,-4|7|0xd2d0d2", 90, 651, 361, 749,  1235)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x,y, 2)
								mSleep(math.random(1500, 2500))
								plz = plz + 1
								plz_num = 0
							else
								plz_num = plz_num + 1
							end
						end
						
						if plz >= 5 then
							mSleep(1000)
							snapshot("test.jpg", 0, 0, 749, 1333,0.7);
							mSleep(math.random(500,700))
							toast("评论赞截图成功:"..plz,1)
							mSleep(math.random(500,700))
							push_task(token,id)
							break
						end
						
						if plz_num > 15 then
							mSleep(500)
							moveTowards( 283,  844, math.random(70,90), 30,10)
							mSleep(2000)
						elseif plz_num > 20 then
							delete_task(token,id)
							goto start
						end
					end
				elseif task.data.type == 4 then
					plz_num = 0
					id = task.data.id
					anchor_id = task.data.anchor_id
					aweme_id = task.data.aweme_id
					toast(id.."\r\n"..tostring(anchor_id).."\r\n"..aweme_id, 1)
					mSleep(1000)

					openURL("snssdk1128://aweme/detail/"..aweme_id)
					mSleep(3000)
					if phoneType == "0" then
						while true do
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
								toast("评论",1)						
								break
							else
								plz_num = plz_num + 1
							end

							if plz_num > 10 then
								delete_task(token,id)
								goto start
							end

							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
						end
					elseif phoneType == "1" then
						while true do
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
								toast("评论",1)
								break
							else
								plz_num = plz_num + 1
							end

							if plz_num > 10 then
								delete_task(token,id)
								goto start
							end

							mSleep(math.random(500,700))
							isfront = isFrontApp("com.ss.iphone.ugc.Aweme")
							if isfront == 0 then
								goto open_app
							end
						end
					end
					pl_text = "优秀"
					while true do
						if phoneType == "0" then
							mSleep(math.random(500,700))
							x, y = findMultiColorInRegionFuzzy(0x8a8b91,"-1|15|0x8a8b91,13|3|0x8a8b91,-27|6|0x8a8b91,5|26|0x8a8b91,80|13|0x8b8c91,74|4|0x8b8c91,88|3|0x8b8c91,-60|18|0xffffff", 90, 0, 818, 639,  1138)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x - 200, y, 2)
								mSleep(math.random(1500, 2500))
								inputStr(pl_text)
								mSleep(math.random(1500, 2500))
								key = "ReturnOrEnter"
								keyDown(key)
								mSleep(100)
								keyUp(key)
								mSleep(3000)
								break
							end
							
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
							end
							
						elseif phoneType == "1" then
							mSleep(math.random(500,700))
							x, y = findMultiColorInRegionFuzzy(0x8a8b91,"-1|15|0x8a8b91,13|3|0x8a8b91,-27|6|0x8a8b91,5|26|0x8a8b91,80|13|0x8b8c91,74|4|0x8b8c91,88|3|0x8b8c91,-60|18|0xffffff", 90, 0, 1212, 749,  1330)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x,y, 2)
								mSleep(math.random(1500, 2500))
								inputStr(pl_text)
								mSleep(3000)
								while (true) do
									mSleep(500)
									x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "-9|-11|0xfe2c55,16|-16|0xfe2c55,18|8|0xfe2c55,-9|7|0xfe2c55,6|3|0xffffff,-1|-7|0xffffff,13|-5|0xffffff,35|2|0xffffff", 90, 0, 0, 749, 1333)
									if x~=-1 and y~=-1 then
										mSleep(500)
										tap(x,y)
										mSleep(3000)
										break
									end
								end
								break
							end
							
							mSleep(math.random(500,700))
							x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
							if x~=-1 and y~=-1 then
								mSleep(math.random(1500, 2500))
								randomTap(x + 8,y + 270, 3)
								mSleep(math.random(1500, 2500))
							end
						end
					end
					
					mSleep(1000)
					snapshot("test.jpg", 0, 0, 749, 1333,0.7);
					mSleep(math.random(500,700))
					toast("评论赞截图成功",1)
					mSleep(math.random(500,700))
					push_task(token,id)
				end
			else
				closeApp("com.ss.iphone.ugc.Aweme")
				mSleep(1000)
				openURL("snssdk1128://")
				mSleep(5000)
				for var= 0, 10 do
					mSleep(math.random(500,700))
					moveTowards( 283,  944, math.random(70,100), 500,50)
					mSleep(math.random(2500,4000))
					loveClick = math.random(0,1)
					if loveClick == 0 then
						loveClick_bool = false
					else
						loveClick_bool = true
					end
					
					if loveClick_bool then
						while true do
							if phoneType == "0" then
								mSleep(math.random(500,700))
								x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "19|2|0xfe2c55,16|18|0xfe2c55,0|18|0xfe2c55,10|11|0xffffff", 100, 491, 241, 639,  900)
								if x~=-1 and y~=-1 then
									mSleep(math.random(1500, 2500))
									randomsTap(x + 10,y + 120,5)
									mSleep(math.random(1500, 2500))
									break
								end
							elseif phoneType == "1" then
								mSleep(math.random(500,700))
								x,y = findMultiColorInRegionFuzzy( 0xfe2c55, "23|3|0xfe2c55,17|19|0xfe2c55,-1|19|0xfe2c55,9|10|0xffffff", 100, 600, 336, 749,  1000)
								if x~=-1 and y~=-1 then
									mSleep(math.random(1500, 2500))
									randomsTap(x + 10,y + 120,5)
									mSleep(math.random(1500, 2500))
									break
								end
							end
						end
					end
					toast("点赞关注暂无任务,"..(65 - var * 5).."秒后重新获取",1)
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

				if task_type == 8 or task_type == 16 or task_type == 4 then
					task_type = 1
				end
			end
		end
	end
end

main()