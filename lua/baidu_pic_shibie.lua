require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

function shibie_baidu()
    content_name      = userPath() .. "/res/baiduAI_content_name1.jpg"
    API               = "CkjuQGtZUNumzQvjgTQ082Ih"
    Secret            = "XsYel9kpUUhG3OwFHfu9h2cKbXlhPpzj"
    tab_CHN_ENG       = {
    	language_type = "CHN_ENG",
    	detect_direction = "true",
    	detect_language = "true",
    	ocrType = 1
    }
    
    ::getBaiDuToken::
    code, access_token = getAccessToken(API, Secret)
    if code then
    	::snap::
    	--内容
    	mSleep(200)
    	x,y = findMultiColorInRegionFuzzy(0x222222, "0|-13|0x222222,0|-22|0x222222,0|-31|0x222222,-13|-19|0x222222,13|-18|0x222222,-3|71|0xf6f6f6,542|71|0xf6f6f6", 100, 0, 0, 640, 1136, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
            snapshot(content_name, x, y + 10, x + 567, y + 64)
            toast("一行数据",1)
        end
        
        mSleep(200)
        x,y = findMultiColorInRegionFuzzy(0x222222, "-1|-13|0x222222,-1|-22|0x222222,0|-31|0x222222,-13|-18|0x222222,13|-18|0x222222,2|105|0xf6f6f6,556|105|0xf6f6f6", 100, 0, 0, 640, 1136, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
            snapshot(content_name, x, y + 10, x + 567, y + 97)
            toast("两行数据",1)
        end
        
        mSleep(200)
        x,y = findMultiColorInRegionFuzzy(0x222222, "0|-12|0x222222,1|-21|0x222222,1|-30|0x222222,-12|-17|0x222222,14|-17|0x222222,11|140|0xf6f6f6,258|140|0xf6f6f6,574|140|0xf6f6f6", 100, 0, 0, 640, 1136, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
            snapshot(content_name, x, y + 10, x + 567, y + 130)
            toast("三行数据",1)
        end
        
    	mSleep(1000)
    	code1, body1 = baiduAI(access_token, content_name, tab_CHN_ENG)
    	dialog(body1,0)
    	if code1 then
    	    content = ""
    		local tmp = json.decode(body1)
    		if #tmp.words_result > 0 then
    		    for i = 1, #tmp.words_result do
    		        content = content .. tmp.words_result[i].words
    		    end
    		end
    	else
    		toast("识别失败\n" .. tostring(body),1)
    		mSleep(1000)
    		goto snap
    	end
    
    	if content ~= nil and #content >= 1 then
    		toast("识别内容：\r\n" .. content,1)
    		mSleep(1000)
    		return content
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

local m = TSVersions()
local a = ts.version()
local tp = getDeviceType()
if m <= "1.2.7" then
	dialog("请使用 v1.2.8 及其以上版本 TSLib",0)
	lua_exit()
end

if  tp >= 0  and tp <= 2 then
	if a <= "1.3.9" then
		dialog("请使用 iOS v1.4.0 及其以上版本 ts.so",0)
		lua_exit()
	end
elseif  tp >= 3 and tp <= 4 then
	if a <= "1.1.0" then
		dialog("请使用安卓 v1.1.1 及其以上版本 ts.so",0)
		lua_exit()
	end
end

content = shibie_baidu()
dialog(content,0)