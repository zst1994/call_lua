--输入手机号码
require "TSLib"
local ts 				= require('ts')

tab = readFile(userPath().."/res/testPhone.txt") 
if tab then
    writePasteboard(tab[1])
    
    while (true) do
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0xffffff, "51|1|0xffffff,140|17|0xffffff,-207|15|0xd8d8d8,94|-33|0xd8d8d8,358|9|0xd8d8d8,84|54|0xd8d8d8,-120|122|0x18d9f1,-68|115|0x18d9f1,-182|116|0x18d9f1", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(500)
    		randomTap(x + 80,  y - 166, 4)
    		mSleep(700)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(500)
        end
        
        mSleep(50)
        if getColor(241,520) == 0x18d9f1 then
            mSleep(500)
    		randomTap(241,520, 4)
    		mSleep(500)
    		break
        end
    end
	
	table.remove(tab, 1)
	writeFile(userPath().."/res/testPhone.txt",tab,"w",1)
	mSleep(2000)
else
	dialog("文件不存在")
end
