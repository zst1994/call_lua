--hk-wc-login
require "TSLib"
local ts 				= require('ts')

local model 				= {}

model.wc_bid 			= ""

model.awz_bid 			= ""
model.awz_newUrl        = ""

model.wcList            = ""
model.wcAcount          = ""
model.wcPassword        = ""

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/hk-config.txt") 
	if tab then 
		self.wc_bid = string.gsub(tab[1],"%s+","")
		self.awz_bid = string.gsub(tab[2],"%s+","")
		self.awz_newUrl = string.gsub(tab[3],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在,请检查配置文件路径",5)
		goto read_file
	end
end

function model:getAccount()
	self.wcList = readFile(userPath() .. "/res/wc_account.txt")
	if self.wcList then
		if #self.wcList > 0 then
			data = strSplit(string.gsub(self.wcList[1], "%s+", ""), "—-")
			self.wcAcount = data[1]
			self.wcPassword = data[2]
			toast("获取账号成功:" .. self.wcAcount .. "===" .. self.wcPassword,1)
			mSleep(1000)
		else
			dialog("没账号了", 0)
			luaExit()
		end
	else
		dialog("文件不存在,请检查", 0)
		luaExit()
	end
end

function model:clear_App()
	clear_bid = self.awz_bid
	::run_again::
	closeApp(clear_bid)
	mSleep(math.random(200, 500))
	runApp(clear_bid)
	mSleep(math.random(500, 1500))

	while true do
		mSleep(200)
		flag = isFrontApp(clear_bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				break
			end
		else
			goto run_again
		end
	end

	::new_phone::
	local sz = require("sz");
	local http = require("szocket.http")
	local res, code = http.request(self.awz_newUrl)
	if code == 200 then
		local resJson = sz.json.decode(res)
		local result = resJson.result
		if result == 3 then
			toast("newApp成功，不过ip重复了",1)
			mSleep(1000)
		elseif result == 1 then
			toast("newApp成功",1)
		else 
			toast("失败，请手动查看问题", 1)
			mSleep(4000)
			goto new_phone
		end
	end
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动",1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 30, 244, 719, 639)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	if self:file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(200)
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333);   
		if type(point) == "table"  and #point ~=0  then
			mSleep(500)
			x_len = point[1].x
			toast(x_len,1)
			return x_len
		else
			x_len = 0
			return x_len
		end
	else
		dialog("文件不存在",1)
		mSleep(math.random(1000, 1500))
	end
end

function model:wc()
    closeApp(self.wc_bid)
	mSleep(500)
	runApp(self.wc_bid)
	mSleep(1000)
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
		    mSleep(200)
			randomTap(256, 1240,5)
			mSleep(500)
			toast("登陆",1)
			mSleep(500)
		end
		
		--邮箱登陆按钮
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x576b95, "75|-6|0x576b95,104|4|0x576b95,-203|7|0x576b95,-214|2|0x576b95,-148|-384|0x181818,2|-374|0x181818", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			randomTap(x, y,5)
			mSleep(500)
			toast("邮箱登陆按钮",1)
			mSleep(500)
			break
        end
	end
	
	while true do
	    mSleep(200)
	    x,y = findMultiColorInRegionFuzzy(0x181818, "5|0|0x181818,10|0|0x181818,16|-1|0x181818,49|-2|0x181818,15|97|0x181818,38|94|0x181818,58|74|0x181818,55|95|0x181818", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            writePasteboard(self.wcAcount)
            mSleep(200)
			randomTap(x + 300, y,5)
			mSleep(200)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(200)
			key = "ReturnOrEnter"
            keyDown(key)
            keyUp(key)
            mSleep(200)
            writePasteboard(self.wcPassword)
            mSleep(200)
            keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(200)
			key = "ReturnOrEnter"
            keyDown(key)
            keyUp(key)
			break
        end
	end
	
	while (true) do
        mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			break
		end
        
        mSleep(200)
		if getColor(118,  704) == 0x007aff then
			x_lens = self:moves()
			if tonumber(x_lens) > 0 then
				mSleep(200)
				moveTowards( 108,  704, 10, x_len - 65)
				mSleep(3000)
				break
			else
				mSleep(200)
				randomTap(603, 1032,5)
				mSleep(math.random(3000, 6000))
			end
		end
	end
	
	while (true) do
	    mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			randomTap(372, 1105,5)
			mSleep(500)
			toast("安全验证",1)
			mSleep(500)
		end
		
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x000000, "17|-8|0x000000,17|5|0x000000,13|17|0x000000,31|9|0x000000,48|-5|0x000000,47|-1|0x000000,47|4|0x000000,48|17|0x000000,677|5|0xc8c8cd", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			randomTap(x + 300, y,5)
			mSleep(500)
            toast("短信验证",1)
			mSleep(500)
			table.remove(self.wcList, 1)
			writeFile(userPath() .. "/res/wc_account.txt", self.wcList, "w", 1)
			break
        end
	end
end

function model:main()
    self:getConfig()
    self:getAccount()
    self:clear_App()
    self:wc()
end

model:main()