require("TSLib")
local ts 				= require('ts')
local sz 				= require("sz")
local json 				= ts.json
local ts_enterprise_lib = require("ts_enterprise_lib")

local model 			= {}

model.id_card_num       = ""

function model:click(click_x,click_y)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 3)
	mSleep(math.random(500, 600))
end

function model:getIdCardNum()
    ::get_idCard_data::
	local category = "idCard-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
		self.id_card_num = string.gsub(data,"%s+","")
		toast(self.id_card_num, 1)
		mSleep(1000)
	else
		dialog("sfz号码获取失败或者数据已经用完，请重新上传新数据:"..tostring(plugin_ok).."----"..tostring(api_ok), 60)
		mSleep(1000)
		goto get_idCard_data
	end
end

function model:checkIdCard()
    while (true) do
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x + 300, y + 10)
            mSleep(500)
            inputKey(self.id_card_num)
            mSleep(1000)
            key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			mSleep(500)
			keyDown(key)
			keyUp(key)
			mSleep(200)
			moveTowards(404,1094,90,300,10)
            -- tap(592,1262)
            -- mSleep(1000)
			break
        end
    end
    
    while (true) do
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0xffffff, "34|-1|0xffffff,69|-5|0xffffff,-128|-28|0x07c160,-132|26|0x07c160,32|-30|0x07c160,32|28|0x07c160,201|-28|0x07c160,187|24|0x07c160", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            break
        else
			moveTowards(404,1094,90,300,10)
        end
        
        --系统连接异常
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "17|0|0x576b95,44|1|0x576b95,55|10|0x576b95,-57|-183|0x1a1a1a,-56|-169|0x1a1a1a,-51|-155|0x1a1a1a,-34|-174|0x1a1a1a,-4|-175|0x1a1a1a,-18|-151|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
        end
    end
    
    while (true) do   
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0xffffff, "34|-1|0xffffff,69|-5|0xffffff,-128|-28|0x07c160,-132|26|0x07c160,32|-30|0x07c160,32|28|0x07c160,201|-28|0x07c160,187|24|0x07c160", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
        end
        
        --证件与姓名不匹配
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "28|0|0x1a1a1a,244|-10|0x576b95,283|6|0x576b95,422|-14|0x576b95,-96|-206|0x1a1a1a,-90|-193|0x1a1a1a,-62|-202|0x1a1a1a,124|-197|0x1a1a1a,217|-203|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            while (true) do
                mSleep(500)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "success-data"
			data = self.id_card_num.."----成功"
            break
        end
		
		--名下绑定超过n个微信号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "245|-12|0x576b95,351|-13|0x576b95,423|-10|0x576b95,52|-307|0x1a1a1a,61|-296|0x1a1a1a,79|-306|0x1a1a1a,104|-291|0x1a1a1a,143|-309|0x1a1a1a,145|-279|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x, y)
			while (true) do
                mSleep(500)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "error-data"
			data = self.id_card_num.."----失败"
            break
		end
		
		--名下绑定超过n个微信号: 间距较宽
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "34|0|0x1a1a1a,236|0|0x576b95,432|-4|0x576b95,41|-322|0x1a1a1a,42|-314|0x1a1a1a,42|-306|0x1a1a1a,55|-306|0x1a1a1a,99|-305|0x1a1a1a,224|-149|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
			while (true) do
                mSleep(500)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "error-data"
			data = self.id_card_num.."----失败"
            break
        end
        
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "16|0|0x576b95,44|-3|0x576b95,54|-2|0x576b95,12|-211|0x1a1a1a,33|-210|0x1a1a1a,27|-201|0x1a1a1a,94|-198|0x1a1a1a,102|-201|0x1a1a1a,120|-194|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            while (true) do
                mSleep(500)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "error-data"
			data = self.id_card_num.."----证件有误"
            break
        end
        
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,48|0|0x576b95,42|-214|0x1a1a1a,51|-188|0x1a1a1a,70|-192|0x1a1a1a,62|-200|0x1a1a1a,83|-206|0x1a1a1a,107|-210|0x1a1a1a,115|-196|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(x, y)
            while (true) do
                mSleep(500)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "error-data"
			data = self.id_card_num.."----证件有误"
            break
        end
        
        --是否放弃绑定银行卡
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "38|16|0x576b95,89|15|0x576b95,109|13|0x576b95,173|-137|0x1a1a1a,145|-127|0x1a1a1a,179|-127|0x1a1a1a,161|-111|0x1a1a1a,63|-114|0x1a1a1a,-20|-140|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            self:click(65, 84)
			mSleep(500)
            while (true) do
                mSleep(200)
                if getColor(533,757) ~= 0xffffff then
                    self:click(533, 757)
                end
                
                mSleep(200)
                x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
                    self:click(x + 500, y + 10)
                    mSleep(500)
                    for var=1,20 do
                        mSleep(100)
                        keyDown("DeleteOrBackspace")
                        keyUp("DeleteOrBackspace")  
                    end
                    break
                end
            end
            category = "error-data"
			data = self.id_card_num.."----失败"
            break
        end
    end
    
	::pushData::
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
	if plugin_ok and api_ok then
		toast("插入数据成功", 1)
		mSleep(1000)
	else
		toast("插入数据失败，重新插入:"..tostring(plugin_ok).."----"..tostring(api_ok), 1)
		mSleep(1000)
		goto pushData
	end
end

function model:main()
	while true do
	    self:getIdCardNum()
		self:checkIdCard()
	end
end

model:main()