require "TSLib"
local ts 				= require('ts')
local json 				= ts.json
phone= "4509154096"

mSleep(500)
x,y = findMultiColorInRegionFuzzy( 0x191919, "5|13|0x191919,38|-7|0x191919,21|4|0x191919,57|8|0x191919,39|10|0x191919,54|18|0x444444,-77|5|0x1485ee", 90, 0, 680, 749, 1333)
if x~=-1 and y~=-1 then
	mSleep(500)
	dialog(x..y,0)
	mSleep(1000)
end