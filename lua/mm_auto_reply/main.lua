require "TSLib"
local ts                = require("ts")
local json 				= ts.json
local model 			= {}

model.appBid 			= "com.wemomo.momoappdemo1"
model.appUrlScheme 		= "momochat://"
model.ageFilePath       = userPath().."/res/ageGroup.txt"
model.ageLocationPath   = userPath().."/res/ageLocation.txt"
model.sendMessUserPath  = userPath().."/res/sendMessUser.plist"
model.choice            = false
model.API               = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
model.Secret            = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"
model.tab_CHN_ENG       = {
	language_type = "CHN_ENG",
	detect_direction = "true",
	detect_language = "true",
	ocrType = 3
}

math.randomseed(getRndNum())

function model:click(click_x,click_y)
	mSleep(500)
	randomTap(click_x,click_y,5)
	mSleep(500)
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

function model:mmAutomation()
	closeApp(self.appBid)
	mSleep(2000)
	openURL(self.appUrlScheme)
	mSleep(1000)

	if way == "0" then
		--关注打招呼
		while (true) do
			--判断是否进入首页
			mSleep(200)
			if getColor(64, 1312) == 0x0fc9e1 then
				--判断是否是在附近的人的页面，不是就切换
				mSleep(200)
				if getColor(298,  148) ~= 0xffffff then
					if self.choice then
						self:click(702,  108)
					end
				else
					self:click(336,  121)
				end
				toast("下一步操作",1)
				mSleep(2000)
				break
			end
		end

		while (true) do
			--筛选条件
			mSleep(200)
			if self.choice then
				mSleep(200)
				if getColor(118, 1246) == 0x3bb3fa and getColor(602, 1234) == 0x3bb3fa then
					mSleep(500)
					if lookUser == "0" then
						self:click(93,  516)
					elseif lookUser == "1" then
						self:click(275,  514)
					elseif lookUser == "2" then
						self:click(456,  513)
					end

					mSleep(500)
					if location then
						age_group = strSplit(ageGroup,"-")
						if #age_group == 2 then
							if string.gsub(location_txt,"%s+","") == "64-678-684-680" then
								age_left = (tonumber(age_group[1]) - oldAgeGroup[1] + 1) * 28
							else
								age_left = (tonumber(age_group[1]) - oldAgeGroup[1]) * 28
							end

							age_right = (oldAgeGroup[2] - tonumber(age_group[2])) * 28

							if age_left > 0 then
								fx_left = 0
								mSleep(500)
								moveTowards(tonumber(location[1]), tonumber(location[2]), fx_left, math.abs(age_left), 10)
							else
								fx_left = 180
								mSleep(500)
								moveTowards(tonumber(location[1]), tonumber(location[2]), fx_left, math.abs(age_left), 10)
							end

							if age_right > 0 then
								fx_right = 180
								mSleep(500)
								moveTowards(tonumber(location[3]), tonumber(location[4]), fx_right, math.abs(age_right), 10)
							else
								fx_right = 0
								age_right = age_right - 14
								mSleep(500)
								moveTowards(tonumber(location[3]), tonumber(location[4]), fx_right, math.abs(age_right), 10)
							end
							nLog("age_left:"..age_left)
							nLog("age_right:"..age_right)

							self:saveStringFile(userPath().."/res/ageLocation.txt", tonumber(location[1]) + age_left .. "-" .. location[2] .. "-" .. tonumber(location[3]) - age_right .. "-" .. location[4], "w", "保存数据成功")
							nLog(tonumber(location[1]) + age_left .. "-" .. location[2] .. "-" .. tonumber(location[3]) - age_right .. "-" .. location[4])
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

					mSleep(500)
					self:click(118, 1246)
					break
				end
			else
				mSleep(1000)
				moveTo(400,300,400,1000,20,70,1,1)
				mSleep(3000)
				break
			end
		end

		while (true) do
			--判断性别再判断是否有在线字样颜色不是白色
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x4cd3ea, "-21|-4|0x4cd3ea,36|-5|0x4cd3ea,4|-11|0x4cd3ea,4|7|0x4cd3ea", 90, 0, 0, 749, 430)
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
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy( 0x4cd3ea, "59|0|0x4cd3ea,21|0|0x4cd3ea,21|-10|0x4cd3ea,21|11|0x4cd3ea,21|-5|0xffffff", 100, 0, 0, 749, 1333)
							if x ~= -1 then
								::getBaiDuToken1::
								local code,access_token = getAccessToken(self.API,self.Secret)
								if code then
									local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"
									--内容
									if x > 430 then
										snapshot(content_name, x - 320, y - 27, x - 3, y + 22) 
									else
										snapshot(content_name, x - 180, y - 27, x - 3, y + 22) 
									end
									mSleep(500)
									local code, body = baiduAI(access_token,content_name,self.tab_CHN_ENG)
									if code then
										local tmp = json.decode(body)
										if #tmp.words_result > 0 then
											content_num = string.lower(tmp.words_result[1].words)
											ts.config.open(self.sendMessUserPath)
											key = ts.config.get(content_num)   
											if key then 
												self:click(53, 81)
												self:click(53, 81)
												mSleep(500)
												toast("已经发过消息不需要重新发",1)
												mSleep(1000)
												break
											else
												ts.config.save(content_num,1) 
											end
											ts.config.close(true)
										else
											self:click(53, 81)
											self:click(53, 81)
											mSleep(500)
											toast("识别失败\n" .. tostring(body),1)
											mSleep(1000)
											break
										end
									else
										self:click(53, 81)
										self:click(53, 81)
										mSleep(500)
										toast("识别失败\n" .. tostring(body),1)
										mSleep(1000)
										break
									end

									if content_num ~= nil and #content_num >= 1 then
										toast("识别内容：\r\n"..content_num,1)
										mSleep(1000)
									else
										self:click(53, 81)
										self:click(53, 81)
										mSleep(500)
										toast("识别内容失败,重新截图识别" .. tostring(body),1)
										mSleep(1000)
										break
									end
								else
									toast("获取token失败",1)
									goto getBaiDuToken1
								end
							end

							num = math.random(1, #reply_terms)
							self:click(473, 1203)
							mSleep(500)
							inputStr(reply_terms[num])
							mSleep(500)
							key = "ReturnOrEnter"
							keyDown(key)
							keyUp(key)
							self:click(53, 81)
							self:click(53, 81)
							break
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
				mSleep(1000)
			end
		end
	elseif way == "1" then
		--回复消息
		while (true) do
			--判断是否进入首页
			mSleep(200)
			if getColor(64, 1312) == 0x0fc9e1 then
				--判断是否是在附近的人的页面，不是就切换
				mSleep(200)
				self:click(376, 1281)
			end
			
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xf85543, "18|1|0xf85543,8|-10|0xf85543,9|11|0xf85543,-4|-51|0xaaaaaa,-5|-42|0xaaaaaa,19|-121|0xffffff,30|-150|0xffffff", 100, 0, 0, 749, 1233)
			if x ~= -1 then
				self:click(x, y)
				while (true) do
					mSleep(200)
					if getColor(689, 1284) == 0x323333 then
						::getBaiDuToken::
						local code,access_token = getAccessToken(API,Secret)
						if code then
							::snap1::
							local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"
							--内容
							snapshot(content_name, 187,  42, 598,  88) 
							mSleep(500)
							local code, body = baiduAI(access_token,content_name,tab_CHN_ENG)
							if code then
								local tmp = json.decode(body)
								if #tmp.words_result > 0 then
									content_num = string.lower(tmp.words_result[1].words)
									ts.config.open(self.sendMessUserPath)
									key = ts.config.get(content_num)   
									if key then 
										ts.config.delete(content_num)  
										ts.config.save(content_num,tonumber(key) + 1)
										self:click(477, 1170)
										mSleep(500)
										inputStr("1111111")
										mSleep(500)
										key = "ReturnOrEnter"
										keyDown(key)
										keyUp(key)
										mSleep(500)
										self:click(55, 84)
									end
									ts.config.close(true)
								else
									toast("识别内容失败\n" .. tostring(body),1)
									mSleep(3000)
									goto snap1
								end
							else
								toast("识别内容失败\n" .. tostring(body),1)
								mSleep(3000)
								goto snap1
							end

							if content_num ~= nil and #content_num >= 1 then
								toast("识别内容：\r\n"..content_num,1)
							else
								toast("识别内容失败,重新截图识别" .. tostring(body),1)
								mSleep(3000)
								goto snap1
							end
						else
							toast("获取token失败",1)
							goto getBaiDuToken
						end
						break
					end
				end
			else
				mSleep(500)
				moveTowards(418,  824, 90, 200, 5)
				mSleep(1000)
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
				["text"] = "私信回复脚本",
				["size"] = 25,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 25,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "选择脚本流程",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "随机关注/打招呼,回复消息",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择想看的用户",
				["size"] = 20,
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
				["text"] = "输入选择年龄段(两个年龄段用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入年龄段",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "是否只看在线的人",
				["size"] = 20,
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
				["text"] = "输入第一句随机打招呼术语(多个术语用-隔开)",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入回复术语",
				["text"] = "默认值",       
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, way, lookUser, ageGroup, onLinePeople, firstReplyTerms = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	::readAgeAgain::
	choice_txt = readFileString(self.ageFilePath)--读取文件内容，返回全部内容的 string
	if choice_txt then
		choice = strSplit(choice_txt, "|")
		oldAgeGroup = strSplit(choice[2], "-")
		toast(choice[2],1)
		mSleep(1000)

		if string.gsub(choice_txt,"%s+","") ~= lookUser .. "|" .. string.gsub(ageGroup,"%s+","") .. "|" .. onLinePeople then
			self:saveStringFile(self.ageFilePath, lookUser .. "|" .. string.gsub(ageGroup,"%s+","") .. "|" .. onLinePeople, "w", "保存年龄段成功")
			self.choice = true
		else
			toast("筛选条件一样不需要筛选",1)
			mSleep(1000)
		end
	else
		self:saveStringFile(self.ageFilePath, lookUser .. "|18-40|" .. onLinePeople, "w", "保存年龄段成功")
		self.choice = true
		goto readAgeAgain
	end

	::readLocationAgain::
	location_txt = readFileString(self.ageLocationPath)--读取文件内容，返回全部内容的 string
	if location_txt and choice[2] ~= string.gsub(ageGroup,"%s+","") then
		location = strSplit(location_txt, "-")
	elseif location_txt and choice[2] == string.gsub(ageGroup,"%s+","") then
		toast("年龄段一样",1)
		mSleep(1000)
	else
		self:saveStringFile(self.ageLocationPath, "64-678-684-680", "w", "保存数据成功")
		goto readLocationAgain
	end

	reply_terms = strSplit(firstReplyTerms, "-")

	self:mmAutomation()
end

model:main()