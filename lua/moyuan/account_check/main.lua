--陌陌-账号检测
require "TSLib"
local ts                = require("ts")
local json 				= ts.json
local model 			= {}

model.sex               = "性别未检测到"
model.beforDay          = "天数未检测到"

model.content_num       = "0"
model.accountFilePath   = userPath() .. "/res/accountData.txt"
model.errorFilePath     = userPath() .. "/res/errorAccount.txt"
model.successFilePath   = userPath() .. "/res/successAccount.txt"
model.API               = "CkjuQGtZUNumzQvjgTQ082Ih"
model.Secret            = "XsYel9kpUUhG3OwFHfu9h2cKbXlhPpzj"
model.tab_CHN_ENG       = {
	language_type = "CHN_ENG",
	detect_direction = "true",
	detect_language = "true",
	ocrType = 1
}

function model:click(click_x,click_y)
	mSleep(200)
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

function isColor(x,y,c,s)   --封装函数，函数名 isColor
    local fl,abs = math.floor,math.abs
    s = fl(0xff*(100-s)*0.01)
    local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
    local rr,gg,bb = getColorRGB(x,y)
    if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
        return true
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
			toast("识别失败\n" .. tostring(body),1)
			mSleep(1000)
			goto snap
		end

		if content ~= nil and #content >= 1 then
			toast("识别内容：\r\n" .. self.content_num,1)
			mSleep(1000)
		else
			toast("识别内容失败,重新截图识别" .. tostring(body),1)
			mSleep(1000)
			goto snap
		end
	else
		toast("获取token失败",1)
		mSleep(1000)
		goto getBaiDuToken
	end
end

function model:shibieDay()
    mSleep(200)
    x,y = findMultiColorInRegionFuzzy(0x323333, "0|9|0x323333,0|18|0x323333,8|6|0x323333,8|18|0x323333,15|15|0x323333,24|15|0x323333,33|15|0x323333", 100, 11, 835, 445, 1036, { orient = 2 })
    if x ~= -1 then
        left_x = x + 57
        left_y = y - 20
        right_x = x + 183
        right_y = y + 40
    else
        mSleep(200)
        x,y = findMultiColorInRegionFuzzy(0x323333, "0|11|0x323333,0|18|0x323333,8|17|0x323333,7|8|0x323333,16|16|0x323333,24|16|0x323333,33|17|0x323333", 100, 11, 835, 445, 1036, { orient = 2 })
        if x ~= -1 then
            left_x = x + 57
            left_y = y - 20
            right_x = x + 183
            right_y = y + 40
        else
            left_x = 0
        end
    end
    
    if left_x > 0 then
        ::getBaiDuToken1::
    	local code,access_token = getAccessToken(self.API,self.Secret)
    	if code then
    		::snap1::
    		local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"
    
    		--内容
    		snapshot(content_name, left_x, left_y, right_x, right_y) 
    		mSleep(500)
    		local code, body = baiduAI(access_token,content_name,self.tab_CHN_ENG)
    		if code then
    			local tmp = json.decode(body)
    			if #tmp.words_result > 0 then
    				self.beforDay = string.lower(tmp.words_result[1].words)
    			end
    		else
    			toast("识别失败\n" .. tostring(body),1)
    			mSleep(1000)
    			goto snap1
    		end
    
    		if self.beforDay ~= nil and #self.beforDay >= 1 then
    			toast("识别内容：\r\n" .. self.beforDay,1)
    			mSleep(1000)
    		end
    	else
    		toast("获取token失败",1)
    		mSleep(1000)
    		goto getBaiDuToken1
    	end
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
            
            writePasteboard(searchAccount)
			while (true) do
				--输入好友账号
				mSleep(200)
				if getColor(420,  284) == 0xf3f3f3 then
					self:click(420,  284)
					keyDown("RightGUI")
					keyDown("v")
					keyUp("v")
					keyUp("RightGUI")
				end
                
				--输入好友账号
				mSleep(200)
				if getColor(470,  334) == 0xf3f3f3 then
					self:click(470,  334)
					keyDown("RightGUI")
					keyDown("v")
					keyUp("v")
					keyUp("RightGUI")
				end

				--搜索用户
				mSleep(200)
				if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
					self:click(108,  179)
					toast("搜索",1)
					mSleep(500)
					break
				end
			end
			
            while (true) do
				mSleep(200)
				if getColor(77, 1243) ~= 0xffffff and getColor(52,  84) == 0xffffff or getColor(77, 1243) ~= 0xffffff and getColor(52,132) == 0xffffff then
					mSleep(200)
					if getColor(362,798) == 0x3bb3fa then
					    mSleep(200)
					    if isColor(76,1056,0x6cdaed,90) or isColor(76,1056,0xa0e6f3,90) then --90 为模糊值，值越大要求的精确度越高
                            self.sex = "男"
                        elseif isColor(72,1027,0xfe81bc,90) or isColor(72,1027,0xfca7d0,90) then --90 为模糊值，值越大要求的精确度越高
                            self.sex = "女"
                        end
					
					    self:shibieDay()
						self:saveStringFile(self.errorFilePath, searchAccount .. "----账号异常" .. "----" .. self.sex .. "----" .. self.beforDay, "a", "账号异常保存成功")
					elseif getColor(362,798) == 0xffffff then
					    mSleep(200)
					    if getColor(68,911) == 0x4cd3ea then
                            self.sex = "男"
					    elseif getColor(68,911) == 0xff79b8 then
                            self.sex = "女"
					    end
				        
						self:shibie()
						self:shibieDay()
						self:saveStringFile(self.successFilePath, searchAccount .. "----" .. self.content_num .. "----" .. self.sex .. "----" .. self.beforDay, "a", "正常账号保存成功")
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
						    if getColor(52,  84) == 0xffffff then
							    self:click(52,   84)
							else
							    self:click(52, 132)
						    end
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