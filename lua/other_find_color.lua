-- 另一种找色的方法，应该找色速度会更快，等待测试
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.mm_bid            = "com.wemomo.momoappdemo1"

model.login             = {
	{  366,  755, 0xffffff},
	{  388,  758, 0xffffff},
	{   93,  735, 0x18d9f1},
	{  369,  712, 0x18d9f1},
	{  670,  763, 0x18d9f1},
	{  376,  798, 0x18d9f1},
	{  238,  357, 0x323333},
	{   95,  352, 0x323333},
}

function model:format_table(tab)
	b = {}
	for k, v in ipairs(tab) do
		for kk, vv in ipairs(v) do
			table.insert(b,vv)
		end
	end
	return b
end

function model:bise_mo(arg)
	local arg = self:format_table(arg)
	local fl,abs = math.floor,math.abs
	local s = fl(0xff*0.05)
	for i= 1, #arg, 3 do
		local r,g,b = fl(arg[i + 2] / 0x10000), fl(arg[i + 2] % 0x10000 / 0x100), fl(arg[i + 2] % 0x100)
		local rr,gg,bb = getColorRGB(arg[i], arg[i + 1])
		if abs(r - rr) >= s or abs(g - gg) >= s or abs(b - bb) >= s then
			return false
		end
	end
	return true
end

function model:main()
	closeApp(self.mm_bid)
	mSleep(1000)
	runApp(self.mm_bid)
	mSleep(2000)

	t1 = ts.ms()
	while (true) do
		mSleep(500)
		t2 = ts.ms()
		if os.difftime(t2, t1) > 10 then
			self:main()
		end

		if self:bise_mo(self.login) then
			tap(366,  755)
			break
		end
	end
end

model:main()



