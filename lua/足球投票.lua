require("TSLib")
local ts = require("ts")

click = 0
math.randomseed(getRndNum())

while (true) do
	setAirplaneMode(true)
	mSleep(5000)
	setAirplaneMode(false)
	mSleep(5000)
	openURL('https://gdzqtp.dev.ganguomob.com/')
	mSleep(500)
	while (true) do
		mSleep(200)
		if getColor(282, 1090) == 0x555864 then
			mSleep(500)
			tap(388, 1217)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xe2d08a, "0|21|0xe2d08a,2|15|0xe2d08a,-10|15|0xe2d08a,-79|343|0xffffff,-219|342|0xffffff,-291|346|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(200)
			if getColor(x + 3, y + 266) == 0xebcd73 then
				mSleep(500)
				tap(x + 3, y + 266)
				mSleep(500)
				click = click + 1
				toast(click,1)
			else
				setAirplaneMode(true)
				mSleep(5000)
				setAirplaneMode(false)
				mSleep(5000)
			end
			break
		else
			mSleep(500)
			moveTowards(363, 1228,90,800,10)
			mSleep(1000)
		end
	end
end


