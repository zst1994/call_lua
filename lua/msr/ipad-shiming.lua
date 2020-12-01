require("TSLib")
local ts 				= require('ts')
local json 				= ts.json
local ts_enterprise_lib = require("ts_enterprise_lib")

local model 			= {}

model.wc_bid = ""
model.awz_bid = ""
model.awz_url = ""

model.idCard_user = ""
model.idCard_numCode = ""

function model:clear_App()
	::run_again::
	mSleep(500)
	closeApp(self.awz_bid) 
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(1, 3))

	while true do
		--AWZ，AXJ
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(657,1307) == 0x0950d0 or getColor(652,1198) == 0x0950d0 then
				toast("准备newApp",1)
				break
			end
		else
			goto run_again
		end
	end

	mSleep(1000)
	if getColor(56,1058) == 0x6f7179 then
		mSleep(math.random(500, 1000))
		tap(225,826)
		mSleep(math.random(500, 1000))
		while true do
			if getColor(376, 735) == 0xffffff or getColor(379, 562) == 0xffffff then
				toast("newApp成功",1)
				break
			end
		end
	else
		::new_phone::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request(self.awz_url)
		if code == 200 then
			local resJson = sz.json.decode(res)
			local result = resJson.result
			if result == 3 then
				toast("新机成功，但是ip重复了",1)
			elseif result == 1 then
				toast("新机成功",1)
			else 
				toast("失败，请手动查看问题："..tostring(res), 1)
				mSleep(3000)
				goto run_again
			end
		end 
	end
end

function model:getConfig()
    ::configFile::
	tab = readFile(userPath().."/res/config.txt") 
	if tab then 
	    self.wc_bid = string.gsub(tab[1],"%s+","")
		self.awz_bid = string.gsub(tab[2],"%s+","")
		self.awz_url = string.gsub(tab[3],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在,请检测配置文件")
		goto configFile
	end
end

function model:run()
	mSleep(1000)
	closeApp(self.wc_bid)
	mSleep(2000)
	self:clear_App()
end

function model:loginAccount()
	::run_app::
	mSleep(1000)
	runApp(self.wc_bid)
	mSleep(2000)
	while (true) do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "22|0|0x1a1a1a,30|0|0x1a1a1a,49|0|0x1a1a1a,350|1|0x1a1a1a,380|4|0x1a1a1a,433|-1|0x1a1a1a,484|-2|0xffffff,589|-1|0xb3b3b3", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomsTap(x + 50, y, 4)
			mSleep(math.random(500, 700))
			break
		end

		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
	    mSleep(500)
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "-8|-13|0x576b95,10|-13|0x576b95,-303|-414|0x1a1a1a,-286|-427|0x1a1a1a,-286|-397|0x1a1a1a,-82|-403|0x1a1a1a,-45|-404|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("匹配通讯录",1)
			mSleep(500)
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("微信界面",1)
			break
		end
		
		mSleep(500)
		if getColor(232,  430) ==  0x000000 then
			mSleep(500)
			toast("等待扫码",1)
			mSleep(5000)
		end
		
		mSleep(500)
		if getColor(385,  463) == 0x18aa48 or getColor(384,  496) == 0x18aa48 then
			mSleep(500)
			randomsTap(385,  463, 5)
			mSleep(2000)
			toast("二维码失效",1)
			mSleep(5000)
		end
		
		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			runApp(self.wc_bid)
	        mSleep(2000)
		end
	end

    while (true) do
        mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "-4|-26|0x07c160,-569|-17|0xf5f5f5,-54|6|0xf5f5f5", 90, 0, 1190, 749, 1333)
		if x~=-1 and y~=-1 then
		    toast("我",1)
		    mSleep(1000)
			break
		else
			mSleep(math.random(500, 700))
			tap(659, 1269)
			mSleep(math.random(500, 700))
		end
		
		mSleep(500)
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "-8|-13|0x576b95,10|-13|0x576b95,-303|-414|0x1a1a1a,-286|-427|0x1a1a1a,-286|-397|0x1a1a1a,-82|-403|0x1a1a1a,-45|-404|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("匹配通讯录",1)
			mSleep(500)
        end
	    
	    mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			runApp(self.wc_bid)
	        mSleep(2000)
		end
	end

	while (true) do
		--支付
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy(0x00c777, "-16|-1|0x00c777,29|-1|0x00c777,77|-13|0x1a1a1a,108|-13|0x1a1a1a,96|-4|0x1a1a1a,121|4|0x1a1a1a,144|3|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 200, y + 20)
			mSleep(math.random(500, 700))
			toast("支付",1)
			mSleep(500)
		end

		--三个点
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x181818, "-7|-2|0xededed,-14|-2|0x181818,-26|2|0xededed,7|0|0xededed,14|-2|0x181818,30|-2|0xededed,-292|5|0x171717,21|77|0x3cb371,23|319|0x3cb371", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("三个点",1)
			mSleep(500)
		end

		--实名认证
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(379,  192)
			mSleep(math.random(500, 700))
			toast("实名认证",1)
			mSleep(500)
			break
		end
	end
    
	::smrz::
	while (true) do
	    --实名认证
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x171717, "25|-1|0x171717,11|7|0x171717,37|13|0x171717,57|18|0x171717,82|13|0x171717,106|8|0x171717,123|5|0x171717,173|11|0xededed", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(379,  192)
			mSleep(math.random(500, 700))
		end
		
		--立即认证
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "110|10|0xffffff,-124|-27|0x07c160,-123|38|0x07c160,49|-23|0x07c160,55|40|0x07c160,228|-21|0x07c160,226|37|0x07c160,12|-779|0x07c160,90|-780|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("立即认证",1)
			mSleep(500)
		end

		--同意
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "-15|3|0x07c160,10|6|0x07c160,32|7|0x07c160,-605|8|0x2c2b31,-584|8|0x2c2b31,-559|4|0x2c2b31,-536|3|0x2c2b31,-297|13|0xffffff", 90, 0, 1220, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("同意",1)
			mSleep(1000)
			break
		end
	end
    
	mSleep(500)
	::getIdCard::
	local category = "idCard-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
		toast(data, 1)
		mSleep(1000)
		local data = strSplit(data,"----")
		if #data > 0 then
			self.idCard_user = data[1]
			self.idCard_numCode = data[2]
		end	
	else
		dialog("身份信息已经用完，请重新上传新数据", 0)
		goto getIdCard
	end
	
	while (true) do
		mSleep(500)
		if getColor(249,  270) == 0x1a1a1a  and getColor(498,  266) == 0x1a1a1a then
		    toast("准备输入信息",1)
		    mSleep(1000)
			while (true) do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 90, 630, 89, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					tap(425,  638)
					mSleep(500)
					toast("选择证件类型",1)
		            mSleep(1000)
					break
				else
					mSleep(500)
					tap(390, 526)
					mSleep(500)
					inputStr(self.idCard_user)
					toast("输入姓名",1)
		            mSleep(1000)
				end
			end
			break
		end
	end

	while (true) do
		mSleep(500)
		if getColor(270, 1234) == 0x07c160  and getColor(363,  654) == 0x1a1a1a then
			mSleep(500)
			tap(370, 1035)
			mSleep(500)
			while (true) do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy( 0x484848, "0|6|0x484848,15|6|0x484848,9|17|0x484848,33|6|0x484848,51|10|0x484848,77|4|0x484848,32|17|0x484848", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					tap(374, 1224)
					mSleep(math.random(500, 700))
					break
				end
			end
			break
		end
	end

	while (true) do
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "0|7|0x1a1a1a,17|7|0x1a1a1a,17|0|0x1a1a1a,16|12|0x1a1a1a,9|18|0x1a1a1a,12|28|0x1a1a1a,185|405|0xc2c2c2,236|417|0xc2c2c2,280|12|0xb3b3b3", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			tap(x + 150,  y)
			mSleep(math.random(500, 700))
			inputKey(self.idCard_numCode)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			mSleep(100)
			keyDown(key)
			keyUp(key)
			break
		end
	end
    
	while (true) do
	    mSleep(500)
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "0|7|0x1a1a1a,17|7|0x1a1a1a,17|0|0x1a1a1a,16|12|0x1a1a1a,9|18|0x1a1a1a,12|28|0x1a1a1a,185|405|0xc2c2c2,236|417|0xc2c2c2", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(math.random(500, 700))
			tap(x + 200,y + 130)
			mSleep(math.random(500, 700))
        end
	
		mSleep(500)
		if getColor(312,   86) == 0x171717  and getColor(428,   85) == 0x171717 then
			mSleep(300)
			y =  math.random(218, 1077)
			mSleep(500)
			tap(378, y)
			mSleep(math.random(500, 700))
			toast("职业选择",1)
			mSleep(1000)
		end

		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "50|13|0xffffff,-126|-20|0x07c160,-124|41|0x07c160,45|-20|0x07c160,49|45|0x07c160,220|-12|0x07c160,221|47|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x,y)
			mSleep(math.random(500, 700))
			break
		end
	end

	while (true) do
		--添加银行卡
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "1|12|0x1a1a1a,-1|29|0x1a1a1a,9|-1|0x1a1a1a,19|8|0x1a1a1a,18|28|0x1a1a1a,201|3|0x1a1a1a,210|12|0x1a1a1a,33|155|0x576b95,165|150|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(65,   84)
			mSleep(math.random(500, 700))
			while (true) do
				mSleep(500)
				if getColor(535,  778) == 0x576b95 then
					mSleep(500)
					tap(535,  778)
					mSleep(500)
					break
				end
				toast("添加银行卡",1)
				mSleep(1000)
				break
			end

			while (true) do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy( 0xffffff, "50|13|0xffffff,-126|-20|0x07c160,-124|41|0x07c160,45|-20|0x07c160,49|45|0x07c160,220|-12|0x07c160,221|47|0x07c160", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					tap(65,   84)
					mSleep(math.random(500, 700))
					break
				end
			end
			goto smrz
		end
	end
end

function model:main()
	self:getConfig()
	self:run()
	self:loginAccount()
	toast('一个流程结束，进行下一个',1)
end

model:main()



