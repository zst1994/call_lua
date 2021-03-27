require "TSLib"
local ts                = require("ts")
local json 				= ts.json


::getBaiDuToken::

API = "CkjuQGtZUNumzQvjgTQ082Ih"
Secret  = "XsYel9kpUUhG3OwFHfu9h2cKbXlhPpzj"

tab = {
    language_type = "ENG",
	detect_direction = "true",
	detect_language = "false",
	ocrType = 1
}

code,access_token = getAccessToken(API, Secret)
if code then
    ::snap::
	pic_name = userPath() .. "/res/baiduAI_content_name1.jpg"

	--内容
	mSleep(500)
	snapshot(pic_name, 229, 778, 472, 852) 
	mSleep(100)

	code1, body = baiduAI(access_token, pic_name, tab)
	dialog(body,0)
	
	if code1 then
		tmp = json.decode(body)
		if #tmp.words_result > 0 then
			content_num = string.lower(tmp.words_result[1].words)
		else
			toast("识别内容失败，重新截图识别" .. tostring(body), 1)
			mSleep(3000)
			goto snap        
		end
	else
		toast("识别内容失败\n" .. tostring(body),1)
		mSleep(3000)
		goto snap
	end 

	if #content_num > 0 then
		toast("识别内容：\r\n"..content_num,1)
		mSleep(1000)
	else
		toast("识别内容失败,重新截图识别" .. tostring(body),1)
		mSleep(3000)
		goto snap 
	end
else
	toast("获取token失败",1)
	goto getBaiDuToken
end