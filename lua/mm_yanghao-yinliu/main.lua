--陌陌养号
require "TSLib"
local ts                	= require("ts")
local plist                 = ts.plist
local json 					= ts.json
local model 				= {}

model.appBid 				= "com.wemomo.momoappdemo1"
model.appUrlScheme 			= "momochat://"

model.ageFilePath       	= userPath().."/res/ageGroup.txt"
model.ageLocationPath   	= userPath().."/res/ageLocation.txt"
model.sendMessUserPath  	= userPath().."/res/sendMessUser.plist"

model.choice            	= false
model.content               = ""

model.API                   = "CkjuQGtZUNumzQvjgTQ082Ih"
model.Secret                = "XsYel9kpUUhG3OwFHfu9h2cKbXlhPpzj"
model.tab_CHN_ENG           = {
	language_type           = "CHN_ENG",
	detect_direction        = "true",
	detect_language         = "true",
	ocrType                 = 1
}

math.randomseed(getRndNum())

function model:click(click_x,click_y)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 5)
	mSleep(math.random(500, 600))
end

function model:doubleClick(click_x,click_y)
	mSleep(math.random(200, 300))
	randomTap(click_x, click_y, 5)
	mSleep(math.random(50, 60))
	randomTap(click_x, click_y, 5)
	mSleep(math.random(500, 600))
end

function model:randomMove()
	for var= 1, math.random(1, 5) do
		mSleep(math.random(200, 300))
		moveTowards(300, 1000, math.random(70, 90), 300, 10) 
		mSleep(math.random(2000, 2500))
	end
end

function model:saveStringFile(filePath,data,mode,toastString)
	::save::
	bool = writeFileString(filePath, data, mode, 1)
	if bool then
		toast(toastString,1)
		mSleep(1000)
	else
		toast("存储失败",1)
		mSleep(1000)
		goto save
	end
end

function model:mingyan()
	::my::
	status_resp, header_resp,body_resp = ts.httpGet("http://api.eei8.cn/say/api.php?charset=utf-8&encode=json")
	if status_resp == 200 then
		tmp = json.decode(body_resp)
		if tmp.text then
			return tmp.text
		else
			toast("重新获取名言数据",1)
			mSleep(3000)
			goto my
		end
	else
		toast("重新获取名言数据",1)
		mSleep(3000)
		goto my
	end
end

function model:savePerson(snapIndex, x)
	::getBaiDuToken::
	local code,access_token = getAccessToken(self.API,self.Secret)
	if code then
		::snap::
		local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"
		if snapIndex == "0" then
			--内容
			if x > 430 then
				snapshot(content_name, x - 390, y - 27, x - 3, y + 22) 
			else
				snapshot(content_name, x - 250, y - 27, x - 3, y + 22) 
			end
		else
			snapshot(content_name, 187,  42, 598,  88) 
		end

		local code, body = baiduAI(access_token,content_name,self.tab_CHN_ENG)
		if code then
			local tmp = json.decode(body)
			if #tmp.words_result > 0 then
				self.content = string.lower(tmp.words_result[1].words)
				return true, body
			else
				return false, body
			end
		else
			toast("识别失败\n" .. tostring(body),1)
			return false, body
		end

		if content ~= nil and #content >= 1 then
			toast("识别内容：\r\n" .. self.content,1)
		else
			toast("识别内容失败,重新截图识别" .. tostring(body),1)
			return false, body
		end
	else
		toast("获取token失败",1)
		goto getBaiDuToken
	end
end

function model:diffSex(sexFindColor,sexStrColor1,sexStrColor2)
	mSleep(100)
	x,y = findMultiColorInRegionFuzzy( sexFindColor, sexStrColor1, 90, 0, 0, 330, 430)
	if x ~= -1 then
		mSleep(200)
		--判断位置是否大于300，大于300再滚动一个距离，可能有图片，防止下次重新打招呼
		if y > 300 then
			mSleep(500)
			moveTowards(418,  824, 90, 200, 5)
			mSleep(1000)
		end

		--判断是否是在线用户
		mSleep(200)
		if getColor(x + 470, y - 45) ~= 0xffffff then
			self:click(x,  y)
			while (true) do
				mSleep(200)
				if getColor(673, 1247) ~= 0xffffff and getColor(513, 1247) == 0xffffff then
					--随机关注
					num = math.random(1, 2)
					if num == 1 then
						self:click(673, 1247)
					end
					break
				end
			end

			while (true) do
				mSleep(200)
				if getColor(673, 1247) ~= 0xffffff and getColor(328, 1254) == 0xffffff then
					--打招呼
					self:click(673, 1247)
				else
					--打招呼(禁止添加新关注直接点击打招呼)
					self:click(124, 1247)
				end

				mSleep(200)
				if getColor(630, 1196) == 0xaaaaaa and getColor(641, 1196) == 0xaaaaaa then
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( sexFindColor, sexStrColor2, 100, 0, 0, 749, 1333)
					if x ~= -1 then
						saveBool, returnBody = self:savePerson("0", x)
						if saveBool then
							tmp2 = plist.read(self.sendMessUserPath)           
							if tostring(tmp2[self.content]) ~= 'nil' then
								self:click(53, 81)
								self:click(53, 81)
								toast("已经发过消息不需要重新发",1)
								mSleep(1000)
								break
							else
								tmp2[self.content] = 1
								toast(x .. "--" .. self.content .. ':' .. tmp2[self.content],1)
								mSleep(1000)

								plist.write(self.sendMessUserPath, tmp2) 

								num = math.random(1, #reply_terms)
								self:click(473, 1203)
								writePasteboard(reply_terms[num])
								mSleep(500)
								keyDown("RightGUI")
								keyDown("v")
								keyUp("v")
								keyUp("RightGUI")
								mSleep(200)
								key = "ReturnOrEnter"
								keyDown(key)
								keyUp(key)
								self:click(53, 81)
								self:click(53, 81)
								break
							end
						else
							self:click(53, 81)
							self:click(53, 81)
							toast("识别失败\n" .. tostring(returnBody),1)
							mSleep(1000)
							break
						end
					end
				end
			end

			while (true) do
				--判断是否返回首页
				mSleep(200)
				if getColor(64, 1312) == 0x0fc9e1 then
					--判断是否是在附近的人的页面，不是就切换
					mSleep(200)
					if getColor(298,  148) ~= 0xffffff then
						mSleep(500)
						moveTowards(418,  824, 90, 200, 5)
						mSleep(1000)
						break
					end
				end
			end
		else
			mSleep(500)
			moveTowards(418,  824, 90, 200, 5)
			mSleep(1000)
		end
	else
		mSleep(500)
		moveTowards(418,  824, 90, 200, 5)
		mSleep(2000)
	end
end

function model:diffFollowFans(sexFindColor,sexStrColor)
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy( sexFindColor, sexStrColor, 100, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(x, y)
		while (true) do
			mSleep(200)
			if getColor(163, 1239) == 0xffffff and getColor(66, 1244) ~= 0xffffff then
				self:click(553, 1244)
			end

			mSleep(200)
			if getColor(286,  216) == 0x323333 then
				break
			elseif getColor(335, 1240) == 0xffffff and getColor(66, 1244) ~= 0xffffff then
				self:click(53, 83)
			end
		end
	else
		mSleep(500)
		moveTowards(418,  824, 90, 200, 5)
		mSleep(2000)
	end
end

--附近动态点赞
function model:fabulous()
	while (true) do
		mSleep(100)
		if getColor(18, 1289) == 0xfdfcfd then
			self:click(95,  112)
			self:doubleClick(75, 1290)
			self:randomMove()
			break
		end
	end

	count = 0
	while (true) do
		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "-14|7|0xaaaaaa,-14|-5|0xaaaaaa,3|-8|0xaaaaaa,10|-8|0xaaaaaa,6|11|0xaaaaaa,-10|11|0xaaaaaa,-1|-18|0xaaaaaa", 100, 0, 0, 300, 1333)
		if x ~= -1 then
			self:click(x,  y)
			count = count + 1
		else
			self:randomMove()
		end

		if count > tonumber(fabulous_times) then
			toast("附近动态点赞流程完成",1)
			mSleep(1000)
			break
		end
	end
end

--附近打招呼
function model:hit_call()
	--关注打招呼
	while (true) do
		--判断是否进入首页
		mSleep(100)
		if getColor(64, 1312) == 0x0fc9e1 then
			--判断是否是在附近的人的页面，不是就切换
			mSleep(200)
			if getColor(298,  148) ~= 0xffffff then
				if self.choice then
					self:click(702,  108)
				end
				toast("下一步操作",1)
				mSleep(1000)
				break
			else
				self:click(336,  121)
			end
		else
			self:click(64, 1312)
		end
	end

	while (true) do
		--筛选条件
		mSleep(100)
		if self.choice then
			if getColor(118, 1246) == 0x3bb3fa and getColor(602, 1234) == 0x3bb3fa then
				if lookUser == "0" then
					self:click(93,  516)
				elseif lookUser == "1" then
					self:click(275,  514)
				elseif lookUser == "2" then
					self:click(456,  513)
				end

				-- 设置年龄段
				if oldAgeItem[1] == "18" then
					mSleep(math.random(200, 300))
					moveTowards(43, 680, 0, 30 * (tonumber(newAgeItem[1]) - 18), 10) 
				else
					if newAgeItem[1] > oldAgeItem[1] then
						mSleep(math.random(200, 300))
						moveTowards(43 + 30 * (tonumber(oldAgeItem[1]) - 18), 680, 0, 30 * (tonumber(newAgeItem[1]) - tonumber(oldAgeItem[1])), 10) 
					elseif newAgeItem[1] < oldAgeItem[1] then
						mSleep(math.random(200, 300))
						moveTowards(43 + 30 * (tonumber(oldAgeItem[1]) - 18), 680, 180, 25 * (tonumber(oldAgeItem[1]) - tonumber(newAgeItem[1])), 10) 
					end
				end

				if oldAgeItem[2] == "40" then
					mSleep(math.random(200, 300))
					moveTowards(707, 680, 180, 25 * (40 - tonumber(newAgeItem[2])), 10) 
				else
					if newAgeItem[2] > oldAgeItem[2] then
						mSleep(math.random(200, 300))
						moveTowards(707 - 25 * (40 - tonumber(oldAgeItem[2])), 680, 0, 30 * (tonumber(newAgeItem[2]) - tonumber(oldAgeItem[2])), 10) 
					elseif newAgeItem[2] < oldAgeItem[2] then
						mSleep(math.random(200, 300))
						moveTowards(707 - 25 * (40 - tonumber(oldAgeItem[2])), 680, 180, 25 * (tonumber(oldAgeItem[2]) - tonumber(newAgeItem[2])), 10) 
					end
				end

				mSleep(500)
				if getColor(643,  781) == 0xffffff then
					if onLinePeople == "1" then
						self:click(643,  781)
					end
				elseif getColor(637,  781) == 0x3bb3fa then
					if onLinePeople == "0" then
						self:click(643,  781)
					end
				end
				self:click(118, 1246)
				break
			end
		else
			self:doubleClick(75, 1290)
			break
		end
	end

	t1 = ts.ms()
	while (true) do
		-- 判断性别再判断是否有在线字样颜色不是白色
		-- 男
		self:diffSex(0x4cd3ea, "-21|-4|0x4cd3ea,36|-5|0x4cd3ea,4|-11|0x4cd3ea,4|7|0x4cd3ea", "59|0|0x4cd3ea,21|0|0x4cd3ea,21|-10|0x4cd3ea,21|11|0x4cd3ea,21|-5|0xffffff")

		--女
		self:diffSex(0xff79b8, "32|-5|0xff79b8,14|-14|0xff79b8,13|6|0xff79b8,-21|-4|0xff79b8", "27|0|0xff79b8,58|0|0xff79b8,26|10|0xff79b8,26|-11|0xff79b8,11|4|0xffffff")

		t2 = ts.ms()
		if os.difftime(t2, t1) > 120 then
			toast("附近打招呼流程完成",1)
			mSleep(1000)
			break
		else
			toast("倒计时剩余：" .. 120 - os.difftime(t2, t1),1)
			mSleep(1000)
		end
	end
end

--点点匹配
function model:matching()
	while (true) do
		--判断是否进入首页
		mSleep(100)
		if getColor(64, 1312) == 0x0fc9e1 then
			self:click(676, 1288)
			toast("更多", 1)
			mSleep(500)
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "-15|1|0x323333,-8|-6|0x323333,-2|-7|0x323333,-6|4|0x333434,6|2|0xffffff,14|-2|0x323333,19|-6|0x333434,25|-7|0x323333,25|4|0x333434", 90, 550, 0, 749, 1333)
		if x ~= -1 then
			self:click(x,y)
			toast("点点", 1)
			mSleep(500)
			break
		end
	end

	dz_time = 0
	while (true) do
		--点击爱心
		mSleep(50)
		if getColor(88, 1185) == 0xdfdfdf then
			self:click(487, 1196)
		else
			--点点
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "-15|1|0x323333,-8|-6|0x323333,-2|-7|0x323333,-6|4|0x333434,6|2|0xffffff,14|-2|0x323333,19|-6|0x333434,25|-7|0x323333,25|4|0x333434", 90, 550, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
			end

			--点击去试试
			mSleep(50)
			if getColor(294,  944) == 0x3bb3fa and getColor(487,  955) == 0x3bb3fa and getColor(122,  955) == 0xffffff then
				self:click(487, 955)
			end

			--上传封面
			mSleep(50)
			if getColor(110,  984) == 0x3bb3fa and getColor(641,  980) == 0x3bb3fa or
			getColor(96,  1114) == 0x3bb3fa and getColor(645,  1112) == 0x3bb3fa then
				if getColor(110,  984) == 0x3bb3fa and getColor(641,  980) == 0x3bb3fa then
					self:click(371, 983)
				else
					self:click(371, 1122)
				end

				while (true) do
					mSleep(100)
					if getColor(15,  930) ~= 0xffffff then
						self:click(374, 1012)
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
						self:click(x, y)
						toast("相册", 1)
						mSleep(500)
					end

					mSleep(100)
					if getColor(209,  246) == 0xf6f6f6 then
						index = math.random(1, 10)
						if index < 3 then
							self:click(373 + (index - 1) * 240,  254)
						elseif index >= 3 and index < 6 then
							self:click(144 + (index - 1) * 240,  492)
						elseif index >= 6 and index < 9 then
							self:click(144 + (index - 1) * 240,  727)
						elseif index >= 9 and index <= 10 then
							self:click(144 + (index - 1) * 240,  966)
						end
					end

					--完成
					mSleep(100)
					if getColor(622,   71) == 0x00c0ff and getColor(699,   67) == 0x00c0ff then
						self:click(660, 68)
						break
					end
				end

				while (true) do
					--保存
					mSleep(100)
					if getColor(623,   83) == 0x3bb3fa and getColor(714,   83) == 0x3bb3fa then
						self:click(661, 86)
						toast("保存",1)
						mSleep(500)
					else
						self:click(661, 86)
					end

					mSleep(100)
					x,y = findMultiColorInRegionFuzzy( 0x007aff, "10|0|0x007aff,39|-4|0x007aff,40|8|0x007aff,61|8|0x007aff,74|8|0x007aff,74|-9|0x007aff,112|-8|0x007aff,112|-1|0x007aff,111|12|0x007aff", 90, 0, 0, 749, 1333)
					if x ~= -1 then
						self:click(x, y)
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

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x006ee5, "6|17|0x006ee5,23|14|0x006ee5,24|4|0x006ee5,42|8|0x006ee5,74|8|0x006ee5,70|3|0x006ee5,54|3|0x006ee5", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				toast("好", 1)
				mSleep(500)
			end

			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "29|0|0x18d9f1,7|18|0x18d9f1,52|5|0x18d9f1,42|-5|0x18d9f1,57|3|0x18d9f1,68|3|0x18d9f1,77|3|0x18d9f1,98|5|0x18d9f1,132|5|0x18d9f1", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(x, y)
				self:click(51, 85)
				dz_time = dz_time + 1
				if dz_time > 1 then
					toast("点赞次数上限", 1)
					mSleep(500)
					break
				end
			end

			--旗舰会员
			mSleep(50)
			x,y = findMultiColorInRegionFuzzy( 0xffffff, "67|-4|0xffffff,-279|2|0xffa73c,45|43|0xffa73c,37|-38|0xffa73c,352|0|0xffa73c", 90, 0, 0, 749, 1333)
			if x ~= -1 then
				self:click(51, 85)
				self:click(51, 85)
				break
			end
		end
	end

	self:doubleClick(75, 1290)
	toast("点点匹配流程完成",1)
	mSleep(1000)
end

--关注粉丝
function model:follow_fans()
	while (true) do
		--判断是否进入首页
		mSleep(100)
		if getColor(64, 1312) == 0x0fc9e1 then
			self:click(676, 1288)
			toast("更多", 1)
			mSleep(500)
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "-13|9|0xaaaaaa,-13|-9|0xaaaaaa,-15|-1|0xaaaaaa,3|4|0xaaaaaa,14|-1|0xaaaaaa,14|6|0xaaaaaa,26|6|0xaaaaaa,25|-1|0xaaaaaa,18|11|0xaaaaaa", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x,y)
			toast("粉丝", 1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "-13|9|0xaaaaaa,-13|-9|0xaaaaaa,-15|-1|0xaaaaaa,3|4|0xaaaaaa,14|-1|0xaaaaaa,14|6|0xaaaaaa,26|6|0xaaaaaa,25|-1|0xaaaaaa,18|11|0xaaaaaa", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x,y)
		end

		-- 男
		self:diffFollowFans(0x4cd3ea, "10|5|0x4cd3ea,32|-5|0x4cd3ea,3|-16|0x4cd3ea,-21|-7|0x4cd3ea,48|-6|0xffffff")

		--女
		self:diffFollowFans(0xff79b8, "10|5|0xff79b8,32|-5|0xff79b8,3|-16|0xff79b8,-21|-7|0xff79b8,48|-6|0xffffff")

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "1|9|0xaaaaaa,1|21|0xaaaaaa,-8|14|0xaaaaaa,33|13|0xaaaaaa,87|13|0xaaaaaa,119|13|0xaaaaaa,154|9|0xaaaaaa,173|15|0xaaaaaa,173|21|0xaaaaaa", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(51, 85)
			self:doubleClick(75, 1290)
			toast("粉丝已加载全部内容",1)
			mSleep(1000)
			break
		end
	end
end

--发动态
function model:send_circle()
	while (true) do
		--判断是否进入首页
		mSleep(100)
		if getColor(64, 1312) == 0x0fc9e1 then
			self:click(676, 1288)
			toast("更多", 1)
			mSleep(500)
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "-22|1|0x323333,-45|-2|0x323333,-50|2|0x323333,18|2|0x323333,27|-6|0x323333,40|-6|0x323333,36|13|0x323333,30|9|0x323333,-6|-17|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x,y)
			toast("我的动态", 1)
			mSleep(500)
			break
		end
	end

	content = self:mingyan()

	while (true) do
		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "-22|1|0x323333,-45|-2|0x323333,-50|2|0x323333,18|2|0x323333,27|-6|0x323333,40|-6|0x323333,36|13|0x323333,30|9|0x323333,-6|-17|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			self:click(x,y)
		end

		mSleep(100)
		if getColor(674,   78) == 0x323333 then
			self:click(674, 78)
		elseif getColor(641,   84) == 0xf3f3f3 and getColor(694,   86) == 0xaaaaaa then
			writePasteboard(content)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(1000)
		elseif getColor(641,   84) == 0x3bb3fa then
			self:click(641, 84)
			break
		end
	end

	while (true) do
		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "-22|1|0x323333,-45|-2|0x323333,-50|2|0x323333,18|2|0x323333,27|-6|0x323333,40|-6|0x323333,36|13|0x323333,30|9|0x323333,-6|-17|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			break
		else
			self:click(51, 85)
		end
	end

	self:doubleClick(75, 1290)
	toast("发动态流程完成",1)
	mSleep(1000)
end

--回复消息
function model:reply_mess()
	--回复消息
	t1 = ts.ms()
	while (true) do
		t2 = ts.ms()
		if os.difftime(t2, t1) > 120 or getColor(415, 1262) == 0xfdfcfd then
			toast("回复消息流程完成",1)
			mSleep(1000)
			break
		else
			toast("倒计时剩余：" .. 120 - os.difftime(t2, t1),1)
			mSleep(1000)
		end

		--判断是否进入首页
		mSleep(100)
		if getColor(64, 1312) == 0x0fc9e1 then
			self:click(376, 1281)
		end

		mSleep(100)
		x,y = findMultiColorInRegionFuzzy( 0xf85543, "0|-25|0xf85543,-12|-11|0xf85543,13|-11|0xf85543", 90, 600, 0, 749, 1333)
		if x ~= -1 then
			self:click(376, 1281)
			mSleep(100)
			if getColor(x + 7, y - 38) == 0xaaaaaa then
				mSleep(500)
				moveTowards(x, y - 10,250, 300, 10)
				mSleep(500)
			else
				self:click(x, y - 10)
				while (true) do
					mSleep(200)
					if getColor(689, 1284) == 0x323333 then
						saveBool, returnBody = self:savePerson("1", x)
						if saveBool then
							tmp2 = plist.read(self.sendMessUserPath)           
							if tostring(tmp2[self.content]) ~= 'nil' then
								mess_reply_terms = strSplit(messReplyTerms, "-")
								if tmp2[self.content] > #mess_reply_terms then
									self:click(53, 81)
									toast("回复消息已经达到回复术语上限",1)
									mSleep(1000)
									break
								else
									writePasteboard(mess_reply_terms[tonumber(tmp2[self.content])])
									tmp2[self.content] = tonumber(tmp2[self.content]) + 1
								end
							else
								tmp2[self.content] = 1
								num = math.random(1, #reply_terms)
								writePasteboard(reply_terms[num])
							end
						else
							self:click(53, 81)
							toast("识别失败\n" .. tostring(returnBody),1)
							mSleep(1000)
							break
						end

						toast(self.content .. ':' .. tmp2[self.content],1)
						mSleep(1000)
						plist.write(self.sendMessUserPath, tmp2) 
						self:click(513, 1170)
						mSleep(500)
						keyDown("RightGUI")
						keyDown("v")
						keyUp("v")
						keyUp("RightGUI")
						mSleep(200)
						key = "ReturnOrEnter"
						keyDown(key)
						keyUp(key)
						mSleep(math.random(1000, 1500))
						self:click(53, 81)
						break
					end
				end
			end
		else
			mSleep(200)
			moveTowards(300, 1000, math.random(70, 90), 300, 10) 
			mSleep(3000)
		end
	end
end

-- 弹窗模块
function model:closeDialog()
	--给陌陌评价
	mSleep(50)
	x,y = findMultiColorInRegionFuzzy( 0x007aff, "35|2|0x007aff,49|3|0x007aff,-43|-357|0x000000,-28|-355|0x000000,-9|-350|0x000000,26|-350|0x000000,60|-350|0x000000,97|-350|0x000000", 90, 0, 0, 749, 1333)
	if x ~= -1 then
		self:click(53, 81)
		toast("给陌陌评价",1)
		mSleep(500)
	end
end

function model:mm()
	closeApp(self.appBid)
	mSleep(2000)
	openURL(self.appUrlScheme)
	mSleep(1000)

	while (true) do
		mSleep(200)
		if getColor(21, 1288) == 0xfdfcfd then
			self:click(70, 1288)
		end

		mSleep(200)
		if getColor(64, 1312) == 0x0fc9e1 then
			break
		end

		self:closeDialog()
	end

	wayList = strSplit(way,'@')

	for i= 1, #wayList do
		if wayList[i] == "0" then
			if fabulous_times ~= '' and fabulous_times ~= '默认值' and tonumber(fabulous_times) > 0 then
				self:fabulous()
			else
				dialog("请检查点赞次数设置是否正确", 0)
				luaExit()
			end
		elseif wayList[i] == "1" then
			choice_txt = readFileString(self.ageFilePath)--读取文件内容，返回全部内容的 string
			if choice_txt then
				choice = strSplit(choice_txt, "|")
				oldAgeItemStr = choice[2]

				if string.gsub(choice_txt,"%s+","") ~= lookUser .. "|" .. string.gsub(setAgeItem,"%s+","") .. "|" .. onLinePeople then
					self:saveStringFile(self.ageFilePath, lookUser .. "|" .. setAgeItem .. "|" .. onLinePeople, "w", "保存筛选条件成功")
					self.choice = true
				else
					toast("筛选条件一样不需要筛选",1)
					mSleep(1000)
				end
			else
				oldAgeItemStr = "18-40"
				self:saveStringFile(self.ageFilePath, lookUser .. "|" .. setAgeItem .. "|" .. onLinePeople, "w", "保存筛选条件成功")
				self.choice = true
			end

			toast("旧年龄段：" .. oldAgeItemStr,1)
			mSleep(1000)

			oldAgeItem = strSplit(oldAgeItemStr, "-")
			newAgeItem = strSplit(setAgeItem, "-")

			reply_terms = strSplit(firstReplyTerms, "-")
			self:hit_call()
		elseif wayList[i] == "2" then
			self:matching()
		elseif wayList[i] == "3" then
			if gz_fans ~= '' and gz_fans ~= '默认值' and tonumber(gz_fans) > 0 then
				self:follow_fans()
			else
				dialog("请检查关注粉丝数量设置是否正确", 0)
				luaExit()
			end
		elseif wayList[i] == "4" then
			self:send_circle()
		elseif wayList[i] == "5" then
			if messReplyTerms ~= '' and messReplyTerms ~= '默认值' then
				reply_terms = strSplit(firstReplyTerms, "-")
				self:reply_mess()
			else
				dialog("请检查回复术语是否设置正确", 0)
				luaExit()
			end
		end
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
				["text"] = "养号引流脚本",
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
				["list"] = "点赞,随机关注/打招呼,点点匹配,随机关注粉丝,发动态,回复消息",
				["select"] = "0",  
				["countperline"] = "3",
			},
			{
				["type"] = "Label",
				["text"] = "随机点赞次数",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请设置点赞次数",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "选择想看的用户",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "全部,女,男",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设置年龄段(用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请设置年龄段",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "是否只看在线的人",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "默认,在线",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "随机打招呼术语(多个术语用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入打招呼术语",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "回复消息术语(多个术语用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入回复术语",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "随机关注粉丝数量",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请设置关注粉丝数量",
				["text"] = "默认值",       
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, way, fabulous_times, lookUser, setAgeItem, onLinePeople, firstReplyTerms, messReplyTerms, gz_fans = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	self:mm()
end

model:main()
