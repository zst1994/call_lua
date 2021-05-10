--仟夏工作室
require "TSLib"
local ts 					= require('ts')
local json 					= ts.json

local model 				= {}

model.awz_bid 				= ''
model.next_url 				= ''
model.getcurrent_url 		= ''
model.setcurrent_url 		= ''
model.setcurrent_file 		= ''
model.mm_bid                = "com.wemomo.momoappdemo1"

math.randomseed(getRndNum())

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/config.txt") 
	if tab then 
		self.awz_bid = string.gsub(tab[1],"%s+","")
		self.next_url = string.gsub(tab[2],"%s+","")
		self.getcurrent_url = string.gsub(tab[3],"%s+","")
		self.setcurrent_url = string.gsub(tab[4],"%s+","")
		self.setcurrent_file = string.gsub(tab[5],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在,请检查配置文件路径",5)
		goto read_file
	end
end

function model:run_app(bid)
	::run_again::
	runApp(bid)
	mSleep(3000)

	while true do
		mSleep(200)
		flag = isFrontApp(bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				break
			end
		else
			goto run_again
		end
	end
end

function model:set_awz_request(url)
	::new_phone::
	status_resp, header_resp,body_resp = ts.httpGet(url)
	if status_resp == 200 then
		tmp = json.decode(body_resp)
		if tmp.result == 1 then
			toast("指令执行完成",1)
			mSleep(1000)
		else 
			toast(tostring(body_resp), 1)
			mSleep(4000)
			goto new_phone
		end
	end
end

function model:set_awz_sysversion()
	self:set_awz_request(self.getcurrent_url)

	txt = readFile(self.setcurrent_file)--读取文件内容，返回全部内容的 string
	for k,v in ipairs(txt) do
		strList = strSplit(v,":")
		if strList[1] == 'SystemVersion' then
			txt[k] = strList[1] .. ":" .. sysVersion
			break
		end
	end

	bool = writeFile(self.setcurrent_file,txt,"w",1) --将 table 内容存入文件，成功返回 true
	if bool then
		toast("写入成功",1)
	else
		toast("写入失败",1)
	end

	self:set_awz_request(self.setcurrent_url)
end

function model:mm()
	::run_again::
	mSleep(500)
	closeApp(self.mm_bid)
	mSleep(1000)
	runApp(self.mm_bid)
	mSleep(1000)

	while (true) do
		mSleep(50)
		if getColor(22, 1293) == 0xfdfcfd then
			mSleep(200)
			randomTap(676, 1288, 4)
			mSleep(500)
			toast("更多", 1)
			mSleep(500)
		end

		mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "0|5|0x323333,-7|2|0x323333,-7|11|0x333434,1|9|0x323333,16|5|0x323333,28|7|0x323333,27|0|0x323333,18|11|0x333434,20|2|0x333434", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(200)
			randomTap(x, y, 4)
			mSleep(500)
			toast("点点", 1)
			mSleep(500)
			break
		end

		self:tapDailog()

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			closeApp(self.awz_bid)
			mSleep(1000)
			self:run_app(self.awz_bid)
			self:set_awz_sysversion()
			goto run_again
		end
	end

	while (true) do
		--点击去试试
		mSleep(100)
		if getColor(294,  944) == 0x3bb3fa and getColor(487,  955) == 0x3bb3fa and getColor(122,  955) == 0xffffff then
			mSleep(200)
			randomTap(487,  955, 4)
			mSleep(500)
		end

		--点击爱心
		mSleep(100)
		if getColor(88, 1185) == 0xdfdfdf then
			mSleep(200)
			randomTap(487,  1196, 4)
			mSleep(500)
		end

		--上传封面
		mSleep(100)
		if getColor(110,  984) == 0x3bb3fa and getColor(641,  980) == 0x3bb3fa or
		getColor(96,  1114) == 0x3bb3fa and getColor(645,  1112) == 0x3bb3fa then
			if getColor(110,  984) == 0x3bb3fa and getColor(641,  980) == 0x3bb3fa then
				mSleep(200)
				randomTap(371,  983, 4)
				mSleep(500)
			else
				mSleep(200)
				randomTap(371,  1122, 4)
				mSleep(500)
			end

			while (true) do
				mSleep(100)
				if getColor(15,  930) ~= 0xffffff then
					mSleep(200)
					randomTap(374, 1012, 4)
					mSleep(500)
				end

				mSleep(100)
				if getColor(209,  246) == 0xf6f6f6 then
					mSleep(200)
					break
				end
			end

			while (true) do
				mSleep(100)
				x,y = findMultiColorInRegionFuzzy( 0x007aff, "6|15|0x007aff,16|-4|0x007aff,15|8|0x007aff,26|8|0x007aff,21|12|0x007aff,18|22|0x007aff", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(200)
					randomTap(x, y, 4)
					mSleep(500)
					toast("相册", 1)
					mSleep(500)
				end

				mSleep(100)
				if getColor(209,  246) == 0xf6f6f6 then
					index = math.random(1, 10)
					if index < 3 then
						mSleep(200)
						randomTap(373 + (index - 1) * 240,  254, 4)
						mSleep(500)
					elseif index >= 3 and index < 6 then
						mSleep(200)
						randomTap(144 + (index - 1) * 240,  492, 4)
						mSleep(500)
					elseif index >= 6 and index < 9 then
						mSleep(200)
						randomTap(144 + (index - 1) * 240,  727, 4)
						mSleep(500)
					elseif index >= 9 and index <= 10 then
						mSleep(200)
						randomTap(144 + (index - 1) * 240,  966, 4)
						mSleep(500)
					end
				end

				--完成
				mSleep(100)
				if getColor(622,   71) == 0x00c0ff and getColor(699,   67) == 0x00c0ff then
					mSleep(200)
					randomTap(660,   68, 4)
					mSleep(500)
					break
				end
			end

			while (true) do
				--保存
				mSleep(100)
				if getColor(623,   83) == 0x3bb3fa and getColor(714,   83) == 0x3bb3fa then
					mSleep(200)
					randomTap(661,   86, 4)
					mSleep(500)
					toast("保存",1)
					mSleep(500)
				end

				mSleep(100)
				x,y = findMultiColorInRegionFuzzy( 0x007aff, "10|0|0x007aff,39|-4|0x007aff,40|8|0x007aff,61|8|0x007aff,74|8|0x007aff,74|-9|0x007aff,112|-8|0x007aff,112|-1|0x007aff,111|12|0x007aff", 90, 0, 0, 749, 1333)
				if x ~= -1 then
					mSleep(200)
					randomTap(x, y, 4)
					mSleep(500)
					toast("继续保存", 1)
					mSleep(500)
				end

				--点击爱心
				mSleep(100)
				if getColor(88, 1185) == 0xdfdfdf then
					mSleep(200)
					break
				end
			end
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x006ee5, "6|17|0x006ee5,23|14|0x006ee5,24|4|0x006ee5,42|8|0x006ee5,74|8|0x006ee5,70|3|0x006ee5,54|3|0x006ee5", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(200)
			randomTap(x, y, 4)
			mSleep(500)
			toast("好", 1)
			mSleep(500)
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "29|0|0x18d9f1,7|18|0x18d9f1,52|5|0x18d9f1,42|-5|0x18d9f1,57|3|0x18d9f1,68|3|0x18d9f1,77|3|0x18d9f1,98|5|0x18d9f1,132|5|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(200)
			randomTap(x, y, 4)
			mSleep(1000)
			randomTap(51,   85, 4)
			mSleep(500)
			toast("点赞次数上限", 1)
			mSleep(500)
			break
		end
	end
end

function model:tapDailog()
	--跳过屏蔽通讯录
	mSleep(50)
	x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
	if x ~= -1 then
		mSleep(200)
		randomTap(x, y, 4)
		mSleep(500)
		toast("跳过屏蔽通讯录", 1)
		mSleep(500)
	end

	--跳过：招呼一下/分享到动态
	mSleep(50)
	if getColor(669,82) == 0xbde1f7 and getColor(702,82) == 0xbde1f7 then
		mSleep(200)
		tap(669,82)
		mSleep(500)
		toast("跳过：招呼一下", 1)
		mSleep(500)
	end
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
				["text"] = "设置系统版本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入您要设置的系统版本",
				["text"] = "默认值",       
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, sysVersion = showUI(MyJsonString)

	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	self:getConfig()
	self:run_app(self.awz_bid)
	self:set_awz_request(self.next_url)
	self:mm()
end

model:main()