require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

function delFolder()
	while (true) do
		local bool,kind = isFileExist(appDataPath("com.wemomo.momoappdemo1").."/Library")
		if bool then
			mSleep(500)
			flag = ts.hlfs.removeDir(appDataPath("com.wemomo.momoappdemo1").."/Library")--删除 hello 文件夹及所有文件
			if flag then
				toast("删除成功",1)
			else
				toast("删除失败或没有此文件夹",1)
			end
		else
			toast("文件路径不存在了,已经删除成功",1)
			break
		end
		mSleep(1000)
	end
end

function getMMId(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		b = string.find(l, 'u.(%d%d%d%d%d%d%d%d%d)_main.sqlite')
		if type(b) ~= "nil" then
			c = string.match(l, '%d%d%d%d%d%d%d%d%d')
			toast("陌陌id:"..c,1)
			mSleep(1000)
			return c
		end
	end
end

function updateNoteName()
	::get_phone::
	mSleep(500)
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request("http://127.0.0.1:8844/cmd?fun=change&remark="..mm_id)
	if code == 200 then
		local tmp = json.decode(res)
		if tmp.retcode == 1 then
			toast("修改备份记录:"..tmp.msg,1)
			mSleep(1000)
		else
			goto get_phone
		end
	else
		toast("接口返回错误",1)
		mSleep(1000)
		goto get_phone
	end
end

function nextNote()
	::next::
	mSleep(500)
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request("http://127.0.0.1:8844/cmd?fun=nextrecord")
	if code == 200 then
		local tmp = json.decode(res)
		if tmp.retcode == 1 then
			toast("切换下一条记录:"..tmp.msg,1)
			mSleep(5000)
		else
			goto next
		end
	else
		toast("接口返回错误",1)
		mSleep(1000)
		goto next
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
				["text"] = "获取陌陌id修改记录脚本",
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
				["text"] = "设置循环次数",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的循环次数",
				["text"] = "默认值",       
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, loop_time = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
	
	for var= 1, tonumber(loop_time) do
		delFolder()
		mm_id = getMMId(appDataPath("com.wemomo.momoappdemo1").."/Documents")
		updateNoteName()
		nextNote()
	end
end

main()
