--陌陌-账号检测
require "TSLib"
local ts                = require("ts")
local json 				= ts.json
local model 			= {}

model.content_num       = "0"
model.accountFilePath   = userPath() .. "/res/accountData.txt"
model.errorFilePath     = userPath() .. "/res/errorAccount.txt"
model.successFilePath   = userPath() .. "/res/successAccount.txt"
model.API               = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
model.Secret            = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"
model.tab_CHN_ENG       = {
	language_type = "CHN_ENG",
	detect_direction = "true",
	detect_language = "true",
	ocrType = 3
}

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

function model:shibie()
	::getBaiDuToken::
	local code,access_token = getAccessToken(self.API,self.Secret)
	if code then
		::snap::
		local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"

		--内容
		snapshot(content_name, 119, 1028, 272, 1092) 
		mSleep(500)
		local code, body = baiduAI(access_token,content_name,self.tab_CHN_ENG)
		if code then
			local tmp = json.decode(body)
			if #tmp.words_result > 0 then
				content = string.lower(tmp.words_result[1].words)
				if #content >= 7 then
					self.content_num = string.sub(content,7,#content)
				else
					self.content_num = "0"
				end
			end
		else
			mSleep(500)
			toast("识别失败\n" .. tostring(body),1)
			mSleep(1000)
			goto snap
		end

		if content ~= nil and #content >= 1 then
			toast("识别内容：\r\n" .. self.content_num,1)
			mSleep(1000)
		else
			mSleep(500)
			toast("识别内容失败,重新截图识别" .. tostring(body),1)
			mSleep(1000)
			goto snap
		end
	else
		toast("获取token失败",1)
		goto getBaiDuToken
	end
end

function model:main()
	while (true) do
		mSleep(200)
		tab = readFile(self.accountFilePath) 
		if #tab > 0 then 
			searchAccount = strSplit(string.gsub(tab[1], "%s+", ""),"----")[1]
			table.remove(tab, 1)
			writeFile(self.accountFilePath, tab, "w", 1)

			while (true) do
				--输入好友账号
				mSleep(200)
				if getColor(420,  284) == 0xf3f3f3 then
					self:click(420,  284)
					mSleep(500)
					inputStr(searchAccount)
					mSleep(500)
				end

				--输入好友账号
				mSleep(200)
				if getColor(470,  334) == 0xf3f3f3 then
					self:click(470,  334)
					mSleep(500)
					inputStr(searchAccount)
					mSleep(1000)
				end

				--搜索用户
				mSleep(200)
				if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
					self:click(108,  179)
					toast("搜索",1)
					mSleep(500)
				end

				mSleep(200)
				if getColor(77, 1243) ~= 0xffffff and getColor(52,  84) == 0xffffff then
					mSleep(200)
					if getColor(669,  828) == 0x3bb3fa then
						self:saveStringFile(self.errorFilePath, searchAccount .. "----账号异常", "a", "账号异常保存成功")
					elseif getColor(669,  828) == 0xffffff then
						self:shibie()
						self:saveStringFile(self.successFilePath, searchAccount .. "----" .. self.content_num, "a", "正常账号保存成功")
					end

					while (true) do
						mSleep(200)
						x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "487|-3|0x3bb3fa,221|-39|0x3bb3fa,215|31|0x3bb3fa,132|-11|0xffffff,195|-2|0xffffff,224|0|0xffffff,318|-7|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
                        if x ~= -1 then
                            break
                        end
				-- 		if getColor(420,  284) == 0xf3f3f3 or getColor(470,  334) == 0xf3f3f3 then
				-- 			break
				-- 		end

						--搜索用户
						mSleep(200)
						if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
							self:click(678,   78)
						else
							self:click(52,   84)
						end
					end
					break
				end
			end
		else
			toast("文件不存在或者没数据了",1)
			mSleep(1000)
			break
		end
	end
end

model:main()