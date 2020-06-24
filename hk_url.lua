require "TSLib"
function get_hkUrl(country_num)
	filepath=appDataPath('com.tencent.xin')..'/Documents/MMappedKV/maycrashcpmap_v2'
	local file = io.open(filepath,'r')
	local text = file:read("*all")
	file:close()
	if text then
		local link='https%3a%2f%2fweixin110.qq.com%2fsecurity%2freadtemplate%3ft%3dsignup%5Fverify%2fw%5Fintro%26regcc%3d'..country_num..'%26regmobile%3d'..text:match('mobile=(%d+)&regid')..'%26regid%3d'..text:match('regid=(%d%p%d+)&scen')..'%26scene%3dget_reg_verify_code%26wechat_real_lang%3dzh_CN'
		return link
	else
		toast('文件不存在',1)
	end
end
--country_num = "86"
--hk_url = get_hkUrl(country_num) 
--nLog(urlEncoder(urlDecoder(hk_url)))
--nLog(urlEncoder(readPasteboard()))
::get_token::
local sz = require("sz")        --登陆
local http = require("szocket.http")
local res, code = http.request("http://47.56.103.47/api.php?action=Login&user=dd123321&pwd=dd123321")
dialog(res, time)
mSleep(500)
if code == 200 then
	data = strSplit(res, ",")
	if data[1] == "ok" then
		tokens = data[2]
	else
		toast("请求接口或者参数错误,脚本重新运行",1)
		lua_restart()
	end
else
	toast("获取token失败，重新获取",1)
	mSleep(1000)
	goto get_token
end

::get_phone::
local sz = require("sz")        --登陆
local http = require("szocket.http")
local res, code = http.request("http://47.56.103.47/api.php?action=GetNumber&token="..tokens.."&pid=3364")
dialog(res, time)
mSleep(500)
if code == 200 then
	data = strSplit(res, ",")
	if data[1] == "ok" then
		telphone = data[2]
	elseif data[1] == "no" then
		toast("暂无号码",1)
		mSleep(1000)
		goto get_phone
	else
		toast("请求接口或者参数错误，脚本重新运行",1)
		lua_restart()
	end
else
	toast("获取手机号码失败，重新获取",1)
	mSleep(1000)
	goto get_phone
end