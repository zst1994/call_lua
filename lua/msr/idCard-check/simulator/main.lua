-- 模拟器 idCard-check
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

function model:copyInput(str)
	mSleep(300)
	inputText(str)
	mSleep(500)
end

function model:getIdCardNum()
	::get_idCard_data::
	local category = "idCard-data"
	ts_enterprise_lib.timeout = 25
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
		self.id_card_num = string.gsub(data,"%s+","")
		toast(self.id_card_num, 1)
		mSleep(1000)
	else
		toast("sfz号码获取失败或者数据已经用完，请重新上传新数据:"..tostring(plugin_ok).."----"..tostring(api_ok), 1)
		mSleep(1000)
		goto get_idCard_data
	end
end

function model:checkIdCard()
--	while (true) do
--		mSleep(50)
--		x,y = findMultiColorInRegionFuzzy( 0x191919, "7|0|0x191919,7|7|0x191919,7|14|0x191919,30|-3|0x191919,30|7|0x191919,30|14|0x191919,24|11|0x191919,36|11|0x191919", 90, 0, 0, 539, 959)
--		if x ~= -1 then
----			self:click(x + 300, y + 10)
--			self:copyInput("杨辉曜")

--			--性别
--			self:click(x + 300, y + 10 + 80)
--			while (true) do
--				mSleep(50)
--				if getColor(321,  888) == 0x07c160 then
--					self:click(321,  888)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "7|0|0x191919,7|7|0x191919,7|14|0x191919,30|-3|0x191919,30|7|0x191919,30|14|0x191919,24|11|0x191919,36|11|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end

--			--证件类型
--			self:click(x + 300, y + 10 + 80 * 2)
--			while (true) do
--				mSleep(50)
--				if getColor(321,  888) == 0x07c160 then
--					self:click(101,  739)
--					self:click(321,  888)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "7|0|0x191919,7|7|0x191919,7|14|0x191919,30|-3|0x191919,30|7|0x191919,30|14|0x191919,24|11|0x191919,36|11|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end
--			break
--		end
--	end

	while (true) do
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
		if x1 ~= -1 then
			self:click(x + 300, y + 5)
--			self:copyInput("H0648209100")
			self:copyInput(self.id_card_num)

--			--证件生效期
--			self:click(x + 300, y + 5 + 80)
--			while (true) do
--				mSleep(50)
--				if getColor(321,  888) == 0x07c160 then
--					self:click(321,  888)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end

--			--证件失效期
--			self:click(x + 300, y + 5 + 80 * 2)
--			while (true) do
--				mSleep(50)
--				if getColor(321,  888) == 0x07c160 then
--					self:click(321,  888)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end

--			--职业
--			self:click(x + 300, y + 5 + 80 * 3)
--			while (true) do
--				mSleep(50)
--				if getColor(49,  734) == 0x191919 then
--					self:click(349,  734)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end

--			--地址
--			self:click(x + 300, y + 5 + 80 * 4)
--			while (true) do
--				mSleep(50)
--				if getColor(291,  194) == 0x191919 and getColor(211,  803) == 0xf2f2f2 then
--					self:click(306,  323)
--				end

--				--允许
--				mSleep(50)
--				x,y = findMultiColorInRegionFuzzy( 0x009688, "-8|-4|0x009688,11|-4|0x009688,27|-1|0x009688,25|-8|0x009688,-104|-2|0x009688,-99|-3|0x009688,-74|-5|0x009688", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					self:click(x,  y)
--				end

--				--选择地区
--				if getColor(400,  202) == 0xffffff and getColor(408,  133) == 0xededed then
--					self:click(306,  569)
--					mSleep(500)
--					self:click(306,  569)
--					break
--				end
--			end

--			while (true) do
--				mSleep(50)
--				if getColor(291,  194) == 0x191919 and getColor(211,  803) == 0xf2f2f2 then
--					self:copyInput("天门街3巷6号")
--				end

--				--确定
--				mSleep(50)
--				if getColor(211,  803) == 0x07c160 then
--					self:click(211,  803)
--				end

--				mSleep(50)
--				x1,y1 = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
--				if x1 ~= -1 then
--					break
--				end
--			end
			break
		end
	end
	
	::tocheck::
	--下一步
	while (true) do
		mSleep(50)
		if getColor(329,  803) == 0x07c160 then
			self:click(329,  803)
			break
		else
			moveTowards(272,794,90,300,10)
		end
	end

	while (true) do   
		--证件与姓名不匹配
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x191919, "6|1|0x191919,3|-9|0x191919,142|1|0x576b95,153|1|0x576b95,170|1|0x576b95,199|1|0x576b95,265|-5|0x576b95,61|-117|0x191919,87|-124|0x191919", 90, 0, 0, 539, 959)
		if x ~= -1 then
			self:click(x, y)
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
				if x ~= -1 then
					self:click(x + 376, y + 7)
					break
				end
			end
			category = "success-data"
			data = self.id_card_num.."----成功"
			break
		end

		--名下绑定超过n个微信号
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x191919, "5|-2|0x191919,5|-11|0x191919,142|-1|0x576b95,153|-1|0x576b95,173|-1|0x576b95,265|-7|0x576b95,61|-154|0x191919,68|-161|0x191919,73|-146|0x191919", 90, 0, 0, 539, 959)
		if x ~= -1 then
			self:click(x, y)
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
				if x ~= -1 then
					self:click(x + 376, y + 7)
					break
				end
			end
			category = "error-data"
			data = self.id_card_num.."----失败"
			break
		end

--		--名下绑定超过n个微信号: 间距较宽
--		mSleep(50)
--		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "34|0|0x1a1a1a,236|0|0x576b95,432|-4|0x576b95,41|-322|0x1a1a1a,42|-314|0x1a1a1a,42|-306|0x1a1a1a,55|-306|0x1a1a1a,99|-305|0x1a1a1a,224|-149|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--		if x ~= -1 then
--			self:click(x, y)
--			while (true) do
--				mSleep(500)
--				x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--				if x ~= -1 then
--					self:click(x + 500, y + 10)
--					mSleep(500)
--					for var=1,20 do
--						mSleep(100)
--						keyDown("DeleteOrBackspace")
--						keyUp("DeleteOrBackspace")  
--					end
--					break
--				end
--			end
--			category = "error-data"
--			data = self.id_card_num.."----失败"
--			break
--		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "21|1|0x576b95,51|2|0x576b95,49|-8|0x576b95,-38|-123|0x191919,-26|-122|0x191919,-16|-122|0x191919,41|-126|0x191919,44|-120|0x191919,54|-127|0x191919", 90, 0, 0, 539, 959)
		if x ~= -1 then
			self:click(x, y)
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
				if x ~= -1 then
					self:click(x + 376, y + 7)
					break
				end
			end
			category = "error-data"
			data = self.id_card_num.."----证件有误"
			break
		end

--		mSleep(50)
--		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,48|0|0x576b95,42|-214|0x1a1a1a,51|-188|0x1a1a1a,70|-192|0x1a1a1a,62|-200|0x1a1a1a,83|-206|0x1a1a1a,107|-210|0x1a1a1a,115|-196|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--		if x ~= -1 then
--			self:click(x, y)
--			while (true) do
--				mSleep(500)
--				x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "4|7|0x1a1a1a,13|7|0x1a1a1a,21|7|0x1a1a1a,53|7|0x1a1a1a,74|-5|0x1a1a1a,91|-4|0x1a1a1a,83|3|0x1a1a1a,84|9|0x1a1a1a,86|18|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--				if x ~= -1 then
--					self:click(x + 500, y + 10)
--					mSleep(500)
--					for var=1,20 do
--						mSleep(100)
--						keyDown("DeleteOrBackspace")
--						keyUp("DeleteOrBackspace")  
--					end
--					break
--				end
--			end
--			category = "error-data"
--			data = self.id_card_num.."----证件有误"
--			break
--		end

		--是否放弃绑定银行卡
		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "28|8|0x576b95,43|6|0x576b95,61|9|0x576b95,44|-89|0x1a1a1a,52|-89|0x1a1a1a,62|-94|0x1a1a1a,74|-86|0x1a1a1a,90|-87|0x1a1a1a,122|-101|0x1a1a1a", 90, 0, 0, 539, 959)
		if x ~= -1 then
			self:click(25, 66)
			while (true) do
				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x576b95, "8|0|0x576b95,14|0|0x576b95,10|6|0x576b95,11|10|0x576b95,14|16|0x576b95,8|11|0x576b95,53|4|0xffffff,-208|9|0x191919,-210|15|0x191919", 90, 0, 0, 539, 959)
				if x ~= -1 then
					self:click(x, y)
				end

				mSleep(50)
				x,y = findMultiColorInRegionFuzzy( 0x191919, "12|0|0x191919,5|5|0x191919,5|10|0x191919,5|-3|0x191919,-14|5|0x191919,-24|8|0x191919,-32|6|0x191919,-36|6|0x191919,-46|7|0x191919", 90, 0, 0, 539, 959)
				if x ~= -1 then
					self:click(x + 376, y + 7)
					break
				end
			end
			category = "error-data"
			data = self.id_card_num.."----失败"
			break
		end
	end

	::pushData::
	ts_enterprise_lib.timeout = 25
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
	if plugin_ok or api_ok then
		toast("插入数据成功", 1)
		mSleep(1000)
		self:getIdCardNum()
--		self:copyInput("H0620374901")
		self:copyInput(self.id_card_num)
		goto tocheck
	else
		toast("插入数据失败，重新插入:"..tostring(plugin_ok).."----"..tostring(api_ok), 1)
		mSleep(1000)
		goto pushData
	end
end

function model:main()
	self:getIdCardNum()
	self:checkIdCard()
end

model:main()