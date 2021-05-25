require("TSLib")
local ts 				= require('ts')
local sz 				= require("sz")
local json 				= ts.json

local model 			= {}

model.app_bid	        = "com.skinp.yancai"
model.API               = "CkjuQGtZUNumzQvjgTQ082Ih"
model.Secret            = "XsYel9kpUUhG3OwFHfu9h2cKbXlhPpzj"
model.tab_CHN_ENG       = {
	language_type       = "CHN_ENG",
	detect_direction    = "true",
	detect_language     = "true",
	ocrType 			= 1
}

model.searchKey         = ""
model.searchIdx         = ""

function model:click(click_x,click_y)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 3)
	mSleep(math.random(500, 600))
end

function model:myToast(str)
	toast(str,1)
	mSleep(500)
end

function model:timeOutRestart(t1)
	t2 = ts.ms()

	diff_time = os.difftime(t2, t1)
	if diff_time > 120 then
		dialog("超过2分钟获取不到任务,脚本停止运行",20)
		luaExit()
	end
end

function model:uninstallApp()
	::uninstall::
	flag = ipaUninstall(frontAppBid())
	if flag == 1 then
		self:myToast("卸载成功")
	else
		self:myToast("卸载失败")
		goto uninstall
	end
end

function model:main()
	closeApp(self.app_bid)
	mSleep(500)
	runApp(self.app_bid)
	mSleep(1000)

	t1 = ts.ms()
	while (true) do
		mSleep(500)
		if getColor(11,   78) == 0xfd554a and getColor(686,  627) == 0xffffff then
			self:myToast("进入应用成功")
			break
		end

		mSleep(500)
		if getColor(11,   78) == 0xfd554a and getColor(686,  627) == 0xf6f5f8 then
			self:click(702,   68)
			self:myToast("暂无试玩任务")
		end

		self:timeOutRestart(t1)
	end

	while (true) do
		x,y = findMultiColorInRegionFuzzy( 0x091018, "9|0|0x091018,16|-2|0x091018,23|-2|0x091018,34|-1|0x091018,48|-4|0x091018,71|-1|0x091018,218|-5|0x091018,232|-5|0x091018,259|2|0x091018", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(634,  371)
			while (true) do
				x,y = findMultiColorInRegionFuzzy( 0x30bd09, "137|0|0x30bd09,389|0|0x30bd09,494|4|0x30bd09,492|95|0xffffff,-4|78|0xffffff", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					ocr_bool = false
					::ocr::
					ocr_text = ocrText(255,  825, 294,  866, 0)
					text = string.gsub(orc_text,"%s+","")
					if #self.searchIdx > 0 then
						self.searchIdx = tonumber(text)
						break
					else
						if not ocr_bool then
							self:click(375,  994)
							self:myToast("获取位置失败")
							mSleep(500)
							ocr_text = ocrText(183,  255, 217,  300, 0)
							ocr_bool = true
							goto ocr
						else
							dialog("获取位置失败", 0)
							luaExit()
						end
					end
				end
			end
			self.searchKey = readPasteboard()
			dialog(self.searchKey .. "\r\n".. self.searchIdx, time)
			break
		else
			self:click(137, 724)
		end
		
		x,y = findMultiColorInRegionFuzzy( 0x474747, "9|0|0x474747,15|0|0x474747,9|22|0x474747,39|22|0x474747,65|11|0x474747,110|3|0x474747,53|57|0xecf0f4,292|-20|0xd8d8d8", 100, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(373,  812)
			self:myToast("您已经下载过这个应用")
		end
	end
end

model:main()