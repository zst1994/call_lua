require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.game_id           = "com.lyflb.h5.jywtf"
model.proxy_id 			= "com.wanchen.blackhole"
-- model.proxy_id 			= "com.xiaoyu.whale"

model.changeIpCount     = 0

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

function model:changeIp()
	closeApp(self.proxy_id)
	mSleep(500)
	runApp(self.proxy_id)
	mSleep(1000)
	
	while (true) do
	    mSleep(50)
	    x,y = findMultiColorInRegionFuzzy(0xffffff, "-80|2|0xaedef4,7|-24|0xaedef4,86|-2|0xaedef4,7|22|0xaedef4,-129|1|0xd0d0d0,-289|-1|0xd0d0d0,-206|-24|0xd0d0d0", 90, 0, 0, 720, 1280, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            self:myToast("强制登录")
        end
        
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0xffffff, "76|14|0xffffff,-96|1|0x26a6ab,175|2|0x26a6ab,46|-36|0x26a6ab,39|38|0x26a6ab,-141|3|0x26a6ab,-420|-8|0x26a6ab,-328|-3|0xffffff,-243|7|0xffffff", 90, 0, 0, 720, 1280, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            self:myToast("同意")
        end
        
	    mSleep(50)
	    if getColor(177,274) == 0x6c747f and getColor(366,217) == 0xfcfcfc then
	        self:click(611, 128)
	    end
	    
	    mSleep(50)
	    if getColor(114,231) == 0xe0c450 then
	        self:click(312, 200)
	    end
	    
	    mSleep(50)
	    if getColor(671,321) == 0x39cfcc then
	        self:click(312, 505)
	        break
	    end
	end
	
	while (true) do
	    mSleep(50)
	    if getColor(326,763) == 0xffffff and getColor(406,783) == 0xffffff then
	        self:myToast("链接成功")
	        break
	    else
	        self:myToast("vpn链接中，请等候", 2000)
	    end
	end

-- 	while (true) do
-- 		--确定
-- 		mSleep(50)
-- 		x,y = findMultiColorInRegionFuzzy( 0x3699ff, "33|3|0x3699ff,7|3|0x3699ff,-16|3|0x3699ff,255|-3|0x808080,262|-3|0x808080,272|-10|0x808080,295|0|0x808080,309|0|0x808080", 90, 0, 0, 719, 1279)
-- 		if x ~= -1 and y ~= -1 then
-- 			self:click(x,  y)
-- 			self:myToast("确定")
-- 		end

-- 		--下次再说
-- 		mSleep(50)
-- 		x,y = findMultiColorInRegionFuzzy( 0x3699ff, "13|-16|0x3699ff,40|-13|0x3699ff,55|-6|0x3699ff,64|-6|0x3699ff,74|-6|0x3699ff,103|0|0x3699ff,270|7|0xacb2b5,270|-13|0xacb2b5,342|-13|0xacb2b5", 90, 0, 0, 719, 1279)
-- 		if x ~= -1 and y ~= -1 then
-- 			self:click(x,  y)
-- 			self:myToast("下次再说")
-- 		end

-- 		mSleep(50)
-- 		if getColor(355,  480) == 0x5072fe then
-- --			self:click(660,  106)
-- --			while (true) do
-- --				mSleep(50)
-- --				if getColor(383,   93) == 0x3c3c3c and getColor(403,  100) == 0x3c3c3c then
-- --					if proxy_status == "0" then
-- --						self:click(174, 200)
-- --					elseif proxy_status == "1" then
-- --						self:click(541, 196)
-- --					end
-- --					mSleep(1000)
-- --					self:click(333, 290)
-- --					self:click(361, 1208)
-- --					break
-- --				end
-- --			end
-- --			mSleep(1000)
-- 			self:click(362, 1026)
-- 		end

-- 		--网络连接请求确定
-- 		mSleep(50)
-- 		x,y = findMultiColorInRegionFuzzy( 0x009688, "-6|8|0x009688,-11|2|0x009688,-20|2|0x009688,23|3|0x009688,22|-3|0x009688,22|-9|0x009688,-113|0|0x009688,-101|2|0x009688,-142|2|0x009688", 90, 0, 0, 719, 1279)
-- 		if x ~= -1 and y ~= -1 then
-- 			self:click(x,  y)
-- 			self:myToast("网络连接请求确定")
-- 			break
-- 		end
-- 	end

-- 	while (true) do
-- 		--网络连接请求确定
-- 		mSleep(50)
-- 		x,y = findMultiColorInRegionFuzzy( 0x009688, "-6|8|0x009688,-11|2|0x009688,-20|2|0x009688,23|3|0x009688,22|-3|0x009688,22|-9|0x009688,-113|0|0x009688,-101|2|0x009688,-142|2|0x009688", 90, 0, 0, 719, 1279)
-- 		if x ~= -1 and y ~= -1 then
-- 			self:click(x,  y)
-- 			self:myToast("网络连接请求确定")
-- 		end

-- 		mSleep(50)
-- 		if getColor(359, 1036) == 0xf9fafe then
-- 			self:myToast("连接成功")
-- 			break
-- 		end
-- 	end
end

function model:index()
	::read_again::
	local bool = isFileExist(userPath() .. "/res/index.txt")
	if bool then
		index = readFileString(userPath() .. "/res/index.txt")
		account = keyWork .. index
		if tonumber(index) + 1 > tonumber(endCount) then
			dialog("测试范围超过" .. endCount, 0)
			luaExit()
		else
			writeFileString(userPath() .. "/res/index.txt", tostring(tonumber(index) + 1), "w")
		end
	else
		::save::
		bool = writeFileString(userPath() .. "/res/index.txt", beginCount, "w") --将 string 内容存入文件，成功返回 true
		if bool then
			self:myToast("保存初始值成功")
			goto read_again
		else
			self:myToast("保存初始值失败,重新保存")
			goto save
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "106|6|0xffffff,-165|5|0xffcb1a,47|-21|0xffcb1a,60|36|0xffcb1a,265|13|0xffcb1a,-146|104|0x0077dd,210|106|0x0077dd", 100, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:click(356,  891)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "108|6|0xffffff,-152|3|0xffcb1a,55|-22|0xffcb1a,251|-11|0xffcb1a,65|27|0xffcb1a,-141|100|0x0077dd,213|101|0x0077dd", 100, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:click(x + 212, y - 259)
			self:click(x + 212, y - 259)
			os.execute("input text ".. account)
			mSleep(200)
			self:click(x + 260, y - 162)
			os.execute("input text " .. keyPass)
			mSleep(200)
			self:click(x, y)
			break
		end
		
		flag = isFrontApp(self.game_id)
    	if  flag == 0 then
    		runApp(self.game_id)
    		mSleep(2000)
    	end
	end

	while (true) do
		--登录入口
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "108|6|0xffffff,-152|3|0xffcb1a,55|-22|0xffcb1a,251|-11|0xffcb1a,65|27|0xffcb1a,-141|100|0x0077dd,213|101|0x0077dd", 100, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:myToast("登陆失败，继续下一个")
			break
		end

		--取消
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x363636, "6|0|0x363636,15|-8|0x363636,35|4|0x363636,41|2|0x363636,47|2|0x363636,41|-7|0x363636,41|7|0x363636", 100, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			self:myToast("取消")
		end

		--快速找回账号密码
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0xffcc00, "-2|48|0xffcc00,-1|92|0xffcc00,29|1|0xcc6666,29|45|0xcc6666,29|95|0xcc6666,236|6|0xcc6666,236|52|0xcc6666,239|98|0xcc6666", 100, 0, 0, 720, 1280, { orient = 2 })
		if x ~= -1 then
			closeApp(self.game_id)
			mSleep(500)
			cleanApp(self.game_id)
			mSleep(1000)
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy(0x009688, "18|0|0x009688,30|-1|0x009688,-138|-5|0x009688,-132|-5|0x009688,-121|-4|0x009688,-103|-4|0x009688,-98|-4|0x009688,-98|7|0x009688", 90, 0, 0, 720, 1280, { orient = 2 })
				if x ~= -1 then
					self:click(x, y)
					self:myToast("允许")
				end

				--注册入口
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0xffffff, "106|6|0xffffff,-165|5|0xffcb1a,47|-21|0xffcb1a,60|36|0xffcb1a,265|13|0xffcb1a,-146|104|0x0077dd,210|106|0x0077dd", 100, 0, 0, 719, 1279)
				if x ~= -1 and y ~= -1 then
					self:click(356,  891)
					break
				end

				--登录入口
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0xffffff, "108|6|0xffffff,-152|3|0xffcb1a,55|-22|0xffcb1a,251|-11|0xffcb1a,65|27|0xffcb1a,-141|100|0x0077dd,213|101|0x0077dd", 100, 0, 0, 719, 1279)
				if x ~= -1 and y ~= -1 then
					break
				end

				flag = isFrontApp(self.game_id)
				if  flag == 0 then
					runApp(self.game_id)
					mSleep(2000)
				end
			end
			break
		end

		--成功登录
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x7fff00, "15|-12|0x7fff00,17|17|0x7fff00,-18|-6|0x7fff00,-18|18|0x7fff00", 100, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:myToast("成功登陆")
			luaExit()
--			while (true) do
--				mSleep(50)
--				if getColor(403,  685) == 0xffffff and getColor(308,  456) == 0xf5f0ea then
--					self:click(180,  619)
--					break
--				else
--					self:click(25,  704)
--				end
--			end

--			while (true) do
--				mSleep(50)
--				if getColor(403,  685) == 0xffffff and getColor(238,  851) == 0x363636 then
--					self:click(238,  851)
--					break
--				end
--			end

			--			::save_account::
			--			bool = writeFileString(userPath() .. "/res/success.txt", account .. "----" .. keyPass, "a", 1) --将 string 内容存入文件，成功返回 true
			--			if bool then
			--				self:myToast("保存账号成功")
			--			else
			--				self:myToast("保存账号失败,重新保存")
			--				goto save_account
			--			end
			break
		end
	end

	self.changeIpCount = self.changeIpCount + 1
	if self.changeIpCount >= 7 then
		self:myToast("准备切换ip")
		self:changeIp()
		self.changeIpCount = 0
	else
		self:myToast("当前数量:" .. self.changeIpCount)
	end
end

function model:main()
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
				["text"] = "试号脚本",
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
				["text"] = "首字母",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入首字母",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入密码",
				["text"] = "123456",       
			},
			{
				["type"] = "Label",
				["text"] = "开始的值",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入开始的值",
				["text"] = "123456",       
			},
			{
				["type"] = "Label",
				["text"] = "结束的值",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入结束的值",
				["text"] = "123456",       
			},
--			{
--				["type"] = "Label",
--				["text"] = "选择代理ip",
--				["size"] = 15,
--				["align"] = "center",
--				["color"] = "0,0,255"
--			},
--			{
--				["type"] = "RadioGroup",
--				["list"] = "动态,静态",
--				["select"] = "0",
--				["countperline"] = "4"
--			},
		}
	}
	local MyJsonString = json.encode(MyTable)
	ret, keyWork, keyPass, beginCount, endCount, proxy_status = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if keyWork == "" or keyWork == "默认值" then
		dialog("首字母不能为空，请重新运行脚本设置首字母", 3)
		luaExit()
	end

	while (true) do
		self:index()
	end
end

model:main()

