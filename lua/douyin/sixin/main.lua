--抖音私信
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.dy_id           = "com.ss.iphone.ugc.Aweme"

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

function model:selectOneDyId()
	openURL("snssdk1128://user/profile/"..dy_uid.."?refer=web&gd_label=click_wap_profile_bottom&type=need_follow&needlaunchlog=1")
	
end

function model:toMineUserProfile()
	openURL("snssdk1128://user/profile/id?refer=web&gd_label=click_wap_profile_follow&type=need_follow&needlaunchlog=1")
end

function model:index()
	selectWay_list = strSplit(selectWay, "@")
	for i = 1, #selectWay_list do
		if selectWay_list[i] == "0" then
			self:selectOneDyId()
		elseif selectWay_list[i] == "0" then
			self:toMineUserProfile()
		elseif selectWay_list[i] == "0" then
		elseif selectWay_list[i] == "0" then
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
		["timer"] = 100,
		views = {
			{
				["type"] = "Label",
				["text"] = "抖音私信脚本",
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
				["text"] = "选择关注私信",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "CheckBoxGroup",
				["list"] = "关注,私信",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "选择流程",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "CheckBoxGroup",
				["list"] = "选择一个抖音号,自己粉丝列表,同城用户,搜索关键词",
				["select"] = "0",
				["countperline"] = "3"
			},
			{
				["type"] = "Label",
				["text"] = "设置关注数量",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "设置关注数量",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置评论数量",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "设置评论数量",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "输入抖音号uid",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入抖音号uid",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置时间间隔",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "设置时间间隔(秒)",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置私信内容(多个内容用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入私信内容",
				["text"] = "默认值"
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, selectGZSXWay, selectWay, gz_count, sx_count, dy_uid, diff_time, content = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if gz_count == "" or gz_count == "默认值" or sx_count == "" or sx_count == "默认值"  then
		dialog("关注或者私信数量不能为空或者默认值，请重新运行设置", 3)
		luaExit()
	end

	if selectWay == "0" then
		if dy_uid == "" or dy_uid == "默认值" then
			dialog("当前选择一个抖音号，抖音uid需要设置，不能为空或者默认值，请重新运行设置", 3)
			luaExit()
		end
	end

	self:index()
end

model:main()