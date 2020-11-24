local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")

require("TSLib")

function alipay(account)
	while true do
		mSleep(500)
		openURL("alipayqr://platformapi/startapp?saId=20000116")
		mSleep(2000)
		x, y = findMultiColorInRegionFuzzy(0x2a83ff,"169|-9|0xffaa18,344|-3|0xf84a33,534|-1|0x2a83ff", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			tap(408, 185)
			mSleep(500)
			break
		end
	end

	while true do
		mSleep(500)
		if getColor(686,1218) == 0xb9d6ff then
			mSleep(500)
			inputStr(account)
			mSleep(500)
		end
		
		mSleep(500)
		if getColor(686,1218) == 0x1677ff then
			mSleep(500)
			tap(686,1218)
			mSleep(500)
			break
		end
	end

	while true do
		mSleep(500)
		if getColor(686,1218) == 0xb9d6ff then
			mSleep(500)
			inputStr("1")
			mSleep(500)
		end
		
		mSleep(500)
		if getColor(686,1218) == 0x1677ff then
			mSleep(500)
			tap(686,1218)
			mSleep(500)
			break
		end
	end

	while true do
		mSleep(500)
		if getColor(91,1191) == 0x1a77fa and getColor(638,1205) == 0x1a77fa then
			mSleep(500)
			tap(638,1205)
			mSleep(500)
			break
		end
	end

	while true do
		mSleep(500)
		if getColor(629,1279) == 0 then
			for i = 1, 3 do
				mSleep(500)
				tap(376, 1180)
				mSleep(500)
			end
			
			for i = 1, 3 do
				mSleep(500)
				tap(625, 1068)
				mSleep(500)
			end
			break
		end
	end
	
	while true do
		mSleep(500)
		if getColor(419,262) == 0x108ee9 and getColor(655,84) == 0x333333 then
			mSleep(500)
			tap(655,84)
			mSleep(500)
			break
		end
	end
	
	while true do
		mSleep(500)
		if getColor(91,89) == 0x1677ff then
			mSleep(500)
			tap(42,84)
			mSleep(500)
			break
		end
	end
end

table=readFile(userPath().."/lua/支付宝.txt") 
if table then 
	for i=1,#table,1 do
		alipay(table[i]:atrim())
	end
	
	dialog("全部转账成功",0)
else
	dialog("文件不存在")
end
	












