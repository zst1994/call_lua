--陌陌-发短信
require "TSLib"
local ts              = require("ts")
local json            = ts.json

local model           = {}

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:click(click_x, click_y, ms)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(500, 600))
end

function model:myToast(str,ms)
	toast(str,1)
	mSleep(ms and ms or math.random(500, 600))
end

function model:input(str,ms)
    writePasteboard(str)
	mSleep(200)
	keyDown("RightGUI")
	keyDown("v")
	keyUp("v")
	keyUp("RightGUI")
	mSleep(200)
	key = "ReturnOrEnter"
	keyDown(key)
	keyUp(key)
	mSleep(ms and ms or 200)
end

function model:index()
	while (true) do
		mSleep(50)
		if getColor(689,1284) == 0x323333 and getColor(591,1178) == 0xfefefe then
		    self:click(591, 1178, 1000)
		    self:input(firstMess, 500)
		    self:input(secondMess, 500)
		    self:input(thirdMess, 500)
		    self:input(fourMess, 500)
		    self:click(54, 83, 1000)
	    else
	        self:myToast("等到进入回复消息界面", 2000)
		end
	end
end

function model:main()
	local w, h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 40,
		views = {
			{
				["type"] = "Label",
				["text"] = "陌陌发短信脚本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "照片文件夹路径是在触动res下，文件夹名字是picFile",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "号码文件路径是在触动res下，文件名字是phoneNum.txt",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "第一句回复内容",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入第一句回复内容",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "第二句回复内容",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入第二句回复内容",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "第三句回复内容",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入第三句回复内容",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "第四句回复内容",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入第四句回复内容",
				["text"] = "默认值"
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, firstMess, secondMess, thirdMess, fourMess = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	self:index()
end

model:main()
