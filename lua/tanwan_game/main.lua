require "TSLib"
local ts 				= require('ts')

local model 			= {}

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:click(click_x, click_y, ms)
	mSleep(math.random(500, 700))
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(500, 700))
end

function model:myToast(str,ms)
	toast(str,1)
	mSleep(ms and ms or 1000)
end

function  model:index()
	::read::
	local bool = isFileExist(userPath() .. "/res/index.txt")
	if bool then
		index = readFileString(userPath() .. "/res/index.txt")
		account = keyWork .. index
		if tonumber(index) + 1 > 10000000 then
			dialog("测试范围超过10000000", 0)
			luaExit()
		else
			writeFileString(userPath().."/res/index.txt",tostring(tonumber(index) + 1),"w")
		end
	else
		::save::
		bool = writeFileString(userPath().."/res/index.txt","1000000","w") --将 string 内容存入文件，成功返回 true
		if bool then
			self:myToast("保存初始值成功")
			goto read
		else
			self:myToast("保存初始值失败,重新保存")
			goto save
		end
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "106|6|0xffffff,-165|5|0xffcb1a,47|-21|0xffcb1a,60|36|0xffcb1a,265|13|0xffcb1a,-146|104|0x0077dd,210|106|0x0077dd", 90, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:click(356,  891)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "108|6|0xffffff,-152|3|0xffcb1a,55|-22|0xffcb1a,251|-11|0xffcb1a,65|27|0xffcb1a,-141|100|0x0077dd,213|101|0x0077dd", 90, 0, 0, 719, 1279)
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
	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "108|6|0xffffff,-152|3|0xffcb1a,55|-22|0xffcb1a,251|-11|0xffcb1a,65|27|0xffcb1a,-141|100|0x0077dd,213|101|0x0077dd", 90, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:myToast("登陆失败，继续下一个")
			break
		end
		
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x363636, "6|0|0x363636,15|-8|0x363636,35|4|0x363636,41|2|0x363636,47|2|0x363636,41|-7|0x363636,41|7|0x363636", 90, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:click(x, y)
			self:myToast("取消")
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x7fff00, "15|-12|0x7fff00,17|17|0x7fff00,-18|-6|0x7fff00,-18|18|0x7fff00", 90, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			self:myToast("成功登陆")
			while (true) do
				mSleep(50)
				if getColor(403,  685) == 0xffffff and getColor(308,  456) == 0xf5f0ea then
					self:click(180,  619)
					break
				else
					self:click(25,  704)
				end
			end
			
			while (true) do
				mSleep(50)
				if getColor(403,  685) == 0xffffff and getColor(238,  851) == 0x363636 then
					self:click(238,  851)
					break
				end
			end
			break
		end
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
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, keyWork, keyPass = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if keyWork == "" or keyWork == "默认值" then
		dialog("首字母不能为空，请重新运行脚本设置首字母", 3)
		luaExit()
	end

	for var= 1, 10 do
		self:index()
	end

end

model:main()

