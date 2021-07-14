--抖音私信
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.dy_id           = "com.ss.iphone.ugc.Aweme"
model.count 		  = 0

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:click(click_x, click_y, ms)
	mSleep(math.random(300, 400))
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(500, 600))
end

function model:doubleClick(click_x, click_y, ms)
	mSleep(math.random(300, 400))
	randomTap(click_x, click_y, 5)
	mSleep(100)
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(500, 600))
end

function model:myToast(str,ms)
	toast(str,1)
	mSleep(ms and ms or math.random(500, 600))
end

function model:load_over()
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xface15, "50|0|0xface15,111|0|0xface15,174|0|0xface15,196|0|0xface15", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y)
			self:myToast("加载完成")
			break
		end
		
		self:click_know()
	end
end

function model:gzColor()
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x8b8c91, "-3|8|0x8b8c91,20|8|0x8b8c91,18|0|0x8b8c91,34|-1|0x8b8c91,41|5|0x8b8c91,48|17|0x8b8c91,47|8|0x8b8c91,35|8|0x8b8c91", 100, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		self:myToast("关注")
		return true
	end
end

function model:fsColor()
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x8b8c91, "0|22|0x8b8c91,13|10|0x8b8c91,16|16|0x8b8c91,13|23|0x8b8c91,25|22|0x8b8c91,47|22|0x8b8c91,45|16|0x8b8c91,34|16|0x8b8c91,41|9|0x8b8c91", 100, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		self:myToast("粉丝列表")
		return true
	end
end

function model:doGZSX()
	data = strSplit(selectGZSXWay, "@")
	for i = 1, #data do
		if data[i] == "0" then
			while (true) do
				if self.count < tonumber(gz_count) then
					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0xffffff, "-43|-6|0xfe2c55,-2|-23|0xfe2c55,-1|18|0xfe2c55,19|-2|0xfe2c55", 90, 0, 0, 749, 1333)
					if x ~= -1 then
						self:click(x, y)
						self:myToast("关注")
					end

					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|15|0x007aff,27|0|0x007aff,41|0|0x007aff,51|3|0x007aff,73|7|0x007aff,91|19|0x007aff,52|-200|0x000000,57|-175|0x000000,70|-176|0x000000", 90, 0, 0, 749, 1333)
					if x ~= -1 then
						self:click(x, y)
						self:myToast("私密账号")
						break
					end

					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0xebeced, "0|10|0xebeced,0|23|0xebeced,-32|11|0x393a44,0|-17|0x393a44,3|34|0x393a44,20|13|0xebeced", 90, 0, 0, 749, 1333)
					if x ~= -1 then
						break
					end
				end
			end
		elseif data[i] == "1" then
			while (true) do
				if self.count < tonumber(sx_count) then
					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0x50525a, "-20|-20|0x50525a,15|-33|0x50525a,-9|-10|0xffffff,-36|46|0x161823,-28|50|0x161823,-11|50|0x161823,-2|58|0x161823,12|57|0x161823,22|50|0x161823", 90, 0, 0, 749, 1333)
--					x,y = findMultiColorInRegionFuzzy( 0x50525a, "-14|-18|0x50525a,-174|-17|0x50525a,-203|-11|0x50525a,163|0|0x50525a,188|0|0x50525a,356|-8|0x50525a", 90, 0, 0, 749, 1333)
					if x ~= -1 then
						self:click(x,   y)
						self:myToast("私信")
						break
					else
						self:click(687,  84, 1000)
					end
				end
			end

			content_list = strSplit(content, "-")
			writePasteboard(content_list[1])
			while (true) do
				mSleep(50)
				if getColor(419, 1267) == 0x242630 then
					self:click(419, 1267, tonumber(interval_time) * 1000)
					keyDown("RightGUI")
					keyDown("v")
					keyUp("v")
					keyUp("RightGUI")
					mSleep(500)
					key = "ReturnOrEnter"
					keyDown(key)
					keyUp(key)
					mSleep(200)
					break
				end
			end
		end
	end
end

function model:click_know()
	--青少年模式，我知道了
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x161823, "98|0|0x161823,-221|0|0xffffff,342|0|0xffffff,-50|-113|0xfe2c55,40|-114|0xfe2c55,119|-107|0xfe2c55", 100, 700, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
	end
	
	--发现通讯录好友
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x50525a, "15|0|0x50525a,7|10|0x50525a,27|1|0x50525a,45|1|0x50525a,67|1|0x50525a,276|-2|0x161823,293|2|0x161823,386|0|0x161823,390|-6|0x161823", 100, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
	end
end

function model:selectUserGZFS(url)
	openURL(url)
	mSleep(1000)

	self:load_over()

	while (true) do
		if selectUserFenSi == "0" then
			if self:gzColor() then
				break
			end
		elseif selectUserFenSi == "1" then
			if self:fsColor() then
				break
			end
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "19|8|0xffffff,40|8|0xffffff,-51|4|0xfe2c55,95|5|0xfe2c55,21|-18|0xfe2c55,28|33|0xfe2c55", 90, 0, 0, 749, 654)
		if x ~= -1 then
			self.count = self.count + 1
			if self.count < tonumber(gz_count) or self.count < tonumber(sx_count) then
				self:click(x - 320, y)
				self:doGZSX()

				while (true) do
					mSleep(50)
					x,y = findMultiColorInRegionFuzzy( 0xface15, "41|0|0xface15,90|0|0xface15,134|0|0xface15,168|0|0xface15", 90, 0, 0, 749, 513)
					if x ~= -1 then
						break
					else
						self:click(50, 80)
					end
				end
				self:myToast("已操作" .. self.count)
			else
				self.count = 0
				break
			end
		else
			mSleep(500)
			moveTowards(404,1194,90,200,10)
			mSleep(2500)
		end
	end
end

function model:sameCity(url)
	openURL(url)

	city_bool = false
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "0|-16|0xfe2c55,0|17|0xfe2c55,-17|1|0xfe2c55,19|1|0xfe2c55", 100, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(235, 82, 2000)
			self:doubleClick(72, 1285)
			city_bool = true
		else
			mSleep(500)
			moveTowards(404,1194,90,900,50)
			mSleep(2500)
		end

		mSleep(50)
		if city_bool then
			if isColor(694,   92, 0xabadb9, 90) then
				self:myToast("同城")
				break
			end
		end
		
		self:click_know()
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "0|-16|0xfe2c55,0|17|0xfe2c55,-17|1|0xfe2c55,19|1|0xfe2c55", 90, 500, 0, 749, 1333)
		if x ~= -1 then
			self.count = self.count + 1
			if self.count < tonumber(gz_count) or self.count < tonumber(sx_count) then
				self:click(x, y - 50)
				self:doGZSX()

				while (true) do
					mSleep(50)
					if getColor(46, 1332) == 0xffffff and getColor(104, 1331) == 0xffffff then
						break
					else
						self:click(50, 80)
					end
				end
				self:myToast("已操作" .. self.count)
			else
				self.count = 0
				break
			end
		else
			mSleep(500)
			moveTowards(404,959,90,600,50)
			mSleep(1000)
		end
	end
end

function model:serachKeyWord(url)
	openURL(url)

	writePasteboard(search_keyword)
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xface15, "73|1|0xface15,125|0|0xface15,-18|577|0xe8e8e9,68|579|0xe8e8e9,166|590|0xe8e8e9,152|630|0xface15,187|638|0xface15,203|638|0xface15,229|638|0xface15", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(461,   88, 5000)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(1000)
			key = "ReturnOrEnter"
			keyDown(key)
			mSleep(200)
			keyUp(key)
			mSleep(1000)
			break
		else
			self:click(358,  172)
		end
		
		self:click_know()
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "19|8|0xffffff,40|8|0xffffff,-51|4|0xfe2c55,95|5|0xfe2c55,21|-18|0xfe2c55,28|33|0xfe2c55", 90, 0, 0, 749, 654)
		if x ~= -1 then
			self.count = self.count + 1
			if self.count < tonumber(gz_count) or self.count < tonumber(sx_count) then
				self:click(x - 320, y)
				self:doGZSX()

				while (true) do
					mSleep(50)
					if getColor(358,  209) == 0xface15 then
						break
					else
						self:click(50, 80)
					end
				end
				self:myToast("已操作" .. self.count)
			else
				self.count = 0
				break
			end
		else
			mSleep(500)
			moveTowards(404,1194,90,200,10)
			mSleep(2500)
		end
	end
end

function model:recommend()
	recom_count = 0
	recomEndBool = false
	while (true) do
		while (true) do
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "0|-16|0xfe2c55,0|17|0xfe2c55,-17|1|0xfe2c55,19|1|0xfe2c55", 100, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y, 1000)
				self:click(x, y + 249)
				break
			else
				mSleep(500)
				moveTowards(404,994,90,900,50)
				mSleep(2500)
			end
			
			self:click_know()
		end


		while (true) do
			mSleep(50)
			if getColor(369, 1181) == 0x5f5f5f and getColor(381, 1180) == 0x5f5f5f then
				self:click(701, 398, 1000)
				self:myToast("暂时没有更多了")
				break
			else
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x505052, "1|-9|0x505052,-16|-7|0x505052,0|15|0x505052,12|-7|0x505052", 100, 0, 0, 749, 1333)
				if x ~= -1 then
					self:click(x, y, 1000)
					--作者标记
					mSleep(50)
					x1,y1 = findMultiColorInRegionFuzzy( 0xfe2c55, "1|-18|0xfe2c55,-47|-16|0xfe2c55,-50|3|0xfe2c55,-33|-3|0xfffeff,-15|-12|0xfffefe,-23|-19|0xfe2c55,-24|3|0xfe2c55", 90, 0, y - 50, x, y + 50)
					if x1 ~= -1 then
						mSleep(500)
						moveTowards(404,1194,90,50,10)
						mSleep(2000)
						self:myToast("作者")
					else
						self.count = self.count + 1
						recom_count = recom_count + 1
						if self.count < tonumber(gz_count) or self.count < tonumber(sx_count) then
							self:click(64, y)
							self:doGZSX()

							while (true) do
								mSleep(50)
								x,y = findMultiColorInRegionFuzzy( 0x505052, "1|-9|0x505052,-16|-7|0x505052,0|15|0x505052,12|-7|0x505052", 100, 0, 0, 749, 1333)
								if x ~= -1 then
									break
								else
									self:click(50, 80)
								end
							end
							self:myToast("已操作" .. self.count .. "--" .. recom_count)
						else
							self.count = 0
							recomEndBool = true
							break
						end
					end
				else
					mSleep(500)
					moveTowards(404,1194,90,100,10)
					mSleep(2500)
				end

				--还没有评论
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x4d4f57, "-6|-9|0x4d4f57,1|-8|0xf3f3f4,8|-10|0x4d4f57,-75|1|0x4d4f57,-99|-6|0x4d4f57,-158|-9|0xf3f3f4,-36|-3|0xf3f3f4", 100, 0, 0, 749, 1333)
				if x ~= -1 then
					self:click(701, 398, 1000)
					self:click(701, 398, 1000)
					self:myToast("还没有评论")
					break
				end

				if recom_count >= tonumber(recomCount) then
					self:click(701, 398, 1000)
					mSleep(500)
					moveTowards(404,994,90,900,50)
					mSleep(2500)
					self:myToast("切换下一个视频")
					recom_count = 0
					break
				end
			end
		end
		
		if recomEndBool then
			break
		end
	end
end

function model:index()
	closeApp(self.dy_id)
	mSleep(500)

	openURL("snssdk1128://")
	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "0|-16|0xfe2c55,0|17|0xfe2c55,-17|1|0xfe2c55,19|1|0xfe2c55", 100, 0, 0, 749, 1333)
		if x ~= -1 then
			self:doubleClick(72, 1285)
			mSleep(5000)
			break
		else
			mSleep(500)
			moveTowards(404,1194,90,900,50)
			mSleep(2500)
		end
		
		self:click_know()
	end

	selectWay_list = strSplit(selectWay, "@")
	for i = 1, #selectWay_list do
		if selectWay_list[i] == "0" then
			self:selectUserGZFS("snssdk1128://user/profile/" .. dy_uid .. "?refer=web&gd_label=click_wap_profile_bottom&type=need_follow&needlaunchlog=1")
		elseif selectWay_list[i] == "1" then
			self:selectUserGZFS("snssdk1128://user/profile/id?refer=web&gd_label=click_wap_profile_follow&type=need_follow&needlaunchlog=1")
		elseif selectWay_list[i] == "2" then
			self:sameCity("snssdk1128://feed?refer=web&gd_label=click_wap_profile_follow")
		elseif selectWay_list[i] == "3" then
			self:serachKeyWord("snssdk1128://search")
		elseif selectWay_list[i] == "4" then
			self:recommend()
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
				["text"] = "选择流程",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				--["type"] = "CheckBoxGroup",
				["type"] = "RadioGroup",
				["list"] = "选择一个抖音号,自己粉丝列表,同城用户,搜索关键词,推荐视频",
				["select"] = "0",
				["countperline"] = "3"
			},
			{
				["type"] = "Label",
				["text"] = "选择第一第二个流程关注私信进入的位置",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "关注的用户,粉丝列表",
				["select"] = "0",  
				["countperline"] = "4",
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
				["text"] = "输入关键词搜索",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入关键词搜索",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置推荐的每个视频评论关注私信数量",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "设置推荐的每个视频评论关注私信数量",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "设置私信时间间隔(秒)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "设置私信时间间隔(秒)",
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

	ret, selectWay, selectUserFenSi, selectGZSXWay, gz_count, sx_count, dy_uid, search_keyword, recomCount, interval_time, content = showUI(MyJsonString)
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