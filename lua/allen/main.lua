--微博
require "TSLib"
local ts                	= require("ts")
local json 					= ts.json
local model 				= {}

model.app_bid 				= "com.sina.weibo"
model.awz_bid               = ""
model.awz_next_url          = ""

math.randomseed(getRndNum())

function model:click(click_x, click_y, ms)
	mSleep(math.random(150, 250))
	randomTap(click_x, click_y, 5)
	mSleep(ms and ms or math.random(400, 500))
end

function model:doubleClick(click_x, click_y)
	mSleep(math.random(150, 250))
	randomTap(click_x, click_y, 5)
	mSleep(math.random(50, 60))
	randomTap(click_x, click_y, 5)
	mSleep(math.random(400, 500))
end

function model:randomMove()
    change = true
    time_ratio = math.random(12, 15) / 10
    
    t1 = ts.ms()
	while true do
		mSleep(math.random(150, 250))
		moveTowards(300, 1000, math.random(70, 90), 300, 10) 
		mSleep(math.random(1500, 2000))
		
		t2 = ts.ms()
    	diff_time = os.difftime(t2, t1)
    	look_times = tonumber(look_times)
    	if diff_time > 60 * look_times then
    	    self:myToast("浏览完成")
    		break
    	elseif diff_time > 60 * look_times / time_ratio then
    	    if change then
        	    self:click(300, 84, 1000)
        	    self:doubleClick(71,1273)
        	    change = false
    	    end
    	end
    	
	    self:myToast("距离重启脚本还有"..(60 * look_times - diff_time) .. "秒",1)
	end
end

function model:myToast(str, ms)
	toast(str,1)
	mSleep(ms and ms or 500)
end

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/wb_config.txt") 
	if tab then 
		self.awz_bid = string.gsub(tab[1],"%s+","")
		self.awz_next_url = string.gsub(tab[2],"%s+","")
		self:myToast("获取配置信息成功")
		log("获取配置信息成功:" .. self.awz_bid .. "====" .. self.awz_next_url)
	else
		dialog("文件不存在,请检查配置文件路径",5)
		goto read_file
	end
end

function model:closeRunApp(bid)
    closeApp(bid)
    mSleep(500)
    runApp(bid)
    mSleep(1000)
end

function model:setAirplane()
    setAirplaneMode(true)
    mSleep(math.random(2000, 3000))
    setAirplaneMode(false)
    mSleep(math.random(2000, 3000))
end

function model:setNextData()
    ::run_again::
    self:closeRunApp(self.awz_bid)
    
    while true do
        mSleep(50)
        if getColor(147,456) == 0x6f7179 then
		    self:myToast("准备切换下一条数据")
			break
        end
	
		mSleep(50)
		flag = isFrontApp(self.awz_bid)
		if flag == 0 then
		    self:myToast("当前应用不在前台，重新打开应用")
			goto run_again
		end
    end

    ::nextrecord::
    header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60)
	status_resp, header_resp,body_resp = ts.httpGet(self.awz_next_url, header_send, body_send)
	if status_resp == 200 then
		local tmp = json.decode(body_resp)
	    if tmp.result == 1 then
			self:myToast("切换成功")
			log("切换成功")
		else 
		    self:myToast("数据切换失败：" .. result .. "====" .. tostring(body_resp))
		    log("数据切换失败：" .. result .. "====" .. tostring(body_resp))
			goto nextrecord
	    end
    else
        self:myToast("请求切换数据异常", 3000)
	    log("请求切换数据异常")
		goto nextrecord
	end
end

function model:weibo()
    self:closeRunApp(self.app_bid)
    
    while (true) do
        mSleep(50)
        if getColor(71,1273) == 0x333333 and getColor(735,726) == 0xffffff then
            self:myToast("进入首页，开始流程操作")
            break
        end
    end
    
    wayList = strSplit(runWay,'@')
	for i= 1, #wayList do
	    if wayList[i] == "0" then
	        if tonumber(look_times) > 0 then
	            while (true) do
	                mSleep(50)
        	        if getColor(302,119) == 0xfd9500 or getColor(443,119) == 0xff3900 then
        	            break
        	        end
	            end
	            
	            self:click(443, 84, 1000)
	            self:doubleClick(71,1273)
	            self:randomMove()
	        else
	            dialog("请检查浏览分钟数设置是否正确",0)
	            luaExit()
	        end
	    elseif wayList[i] == "1" then
	        while (true) do
	            -- 点击红包
    	        mSleep(50)
    	        if getColor(632, 85) ~= 0xf5f5f5 then
    	            self:click(632, 85)
    	        end
    	        
    	        -- 判断红包页面是否加载完成
    	        mSleep(50)
    	        if getColor(686, 171) ~= 0xeeeeee and getColor(461, 95) == 0x333333 then
    	            self:myToast("进入红包", 2000)
    	            break
    	        end
	        end
	    elseif wayList[i] == "2" then
	        while (true) do
	            -- 点击红包
    	        mSleep(50)
    	        if getColor(632, 85) ~= 0xf5f5f5 then
    	            self:click(632, 85)
    	        end
    	        
    	        -- 判断红包页面是否加载完成
    	        mSleep(50)
    	        if getColor(686, 171) ~= 0xeeeeee and getColor(461, 95) == 0x333333 then
    	            mSleep(math.random(2000, 3000))
    	            break
    	        end
	        end
	        
	        ::to_again::
	        --点击打卡王
	        while (true) do
    	        mSleep(50)
    	        if getColor(657, 630) == 0xffffff then
    	            self:click(450, 562, 3000)
    	            break
    	        else
    	            mSleep(math.random(150, 250))
            		moveTowards(642,564, math.random(160, 180), 400, 10) 
            		mSleep(math.random(1000, 1200))
    	        end
	        end
	        
    	    while (true) do
    	        -- 判断打卡王页面加载是否成功，失败返回重新进入
    	        mSleep(50)
    	        if getColor(56,806) == 0xfef8e5 then
    	            break
    	        else
    	            self:click(71, 83)
    	            goto to_again
    	        end
	        end
	    end
	end
end

function model:index()
    self:setAirplane()
    self:setNextData()
    self:weibo()
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
				["text"] = "微博脚本",
				["size"] = 20,
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
				["text"] = "选择脚本流程",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "CheckBoxGroup",                    
				["list"] = "首页关注推荐浏览,点红包,打卡王",
				["select"] = "0",  
				["countperline"] = "3",
			},
			{
				["type"] = "Label",
				["text"] = "设置浏览时间（分）",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请设置浏览分钟数",
				["text"] = "1",       
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, runWay, look_times = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end
    
    log("======================")
    self:getConfig()
	self:index()
end

model:main()
