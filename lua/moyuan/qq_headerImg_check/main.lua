--qq账号头像检查是不是企鹅
require "TSLib"
local ts = require("ts")

local model = {}

model.qqAcount = ""
model.qqPassword = ""

function model:getAccount()
	self.qqList = readFile(userPath() .. "/res/qq_account.txt")
	if self.qqList then
		if #self.qqList > 0 then
			data = strSplit(string.gsub(self.qqList[1], "%s+", ""), "----")
			self.qqAcount = data[1]
			self.qqPassword = data[2]
		else
			dialog("没账号了", 0)
			mSleep(500)
			luaExit()
		end
	else
		dialog("文件不存在,请检查", 0)
		lua_exit()
	end
end

function model:check_account()
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xb4b7c2, "152|-122|0x000000,162|-131|0x000000,193|-130|0x000000,-77|127|0x989eb4,-81|249|0x989eb4,-83|361|0x989eb4,-95|481|0x989eb4,-96|684|0x989eb4,402|4|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			toast("获取账号，进入界面成功", 1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(200)
		if getColor(x, y) and getColor(x, y) then
			mSleep(500)
			inputStr(self.qqAcount)
			mSleep(500)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			break
		end
	end

	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x03081a, "13|5|0x03081a,4|16|0x03081a,21|4|0x03081a,30|11|0x03081a,34|11|0x03081a,42|11|0x03081a,56|8|0xebedf5,-25|12|0xebedf5,13|-37|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy( 0xe82121, "33|-39|0x000000,39|-13|0xe82121,18|14|0xffffff,-22|0|0x000000,45|4|0x000000", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				title = "有企鹅头像"
				path = userPath().."/res/有企鹅头像.txt"
			else
				title = "没有企鹅头像"
				path = userPath().."/res/没有企鹅头像.txt"
			end
			
			::writeAgain::
			bool = writeFileString(path,self.qqAcount .. "----" .. self.qqPassword,"a",1) --将 string 内容存入文件，成功返回 true
			if bool then
				toast(title.."写入成功",1)
				mSleep(500)
			else
				toast(title.."写入失败",1)
				mSleep(500)
				goto writeAgain
			end
			mSleep(500)
			tap(51,   86)
			mSleep(500)
			break
		end
	end

	table.remove(self.qqList, 1)
	writeFile(userPath() .. "/res/qq_account.txt", self.qqList, "w", 1)
	mSleep(500)
end

function model:main()
	while (true) do
		self:getAccount()
		self:check_account()
	end
end

model:main()