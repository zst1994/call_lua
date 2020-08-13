--require "TSLib"
--local ts = require("ts")
--local json = ts.json

----获取token
--header_send = {ContentType = "application/x-www-form-urlencoded"}
--body_send = {
--	["username"] = "18239773375",
--	["password"] = "123456qq"
--}
--ts.setHttpsTimeOut(60) 
--code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/dl.html", header_send, body_send)

--if code == 200 then
--	tmp = json.decode(body_resp)
--	dialog(tmp.token,0)
--end


----领取任务
--header_send = {ContentType = "application/x-www-form-urlencoded"}
--body_send = {
--	["token"] = tmp.token,
--}
--ts.setHttpsTimeOut(60) 
--code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/getdydztask.html", header_send, body_send)

--if code == 200 then
--	local tmp = json.decode(body_resp)
--	url = strSplit(tmp.url, ":")[2]
--	dialog(url, 0)
--end

----打开抖音指定视频
--openURL("snssdk1128:"..url)




require "TSLib"
local ts = require("ts")
local json = ts.json

--获取token
::lingqurenwu::
header_send = {ContentType = "application/x-www-form-urlencoded"}
body_send = {
	["username"] = "18239773375",
	["password"] = "123456qq"
}
ts.setHttpsTimeOut(60) 
code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/dl.html", header_send, body_send)

if code == 200 then
	tmp = json.decode(body_resp)
	token = tmp.token
--	dialog(tmp.token,0)
end

--领取关注
header_send = {ContentType = "application/x-www-form-urlencoded"}
body_send = {
	["token"] = token,
}
ts.setHttpsTimeOut(60) 
code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/getdygztask.html", header_send, body_send)

if code == 200 then
	tmp = json.decode(body_resp)

	if tmp.msg == "关注任务领取成功" then
		url = strSplit(tmp.url, ":")[2]
		apply_id = tmp.apply_id
		task_id = tmp.task_id
		nLog(tmp.msg)
		nLog(tmp.fl)
	else
		nLog(tmp.msg)
		mSleep(3000)
	end
end


--领取点赞任务
--header_send = {ContentType = "application/x-www-form-urlencoded"}
--body_send = {
--	["token"] = token,

--}
--ts.setHttpsTimeOut(60) 
--code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/getdydztask.html", header_send, body_send)

--if code == 200 then
--	tmp = json.decode(body_resp)
--	if tmp.msg == "点赞任务领取成功" then
--		url = strSplit(tmp.url, ":")[2]
--		nLog(tmp.msg)
--		nLog(tmp.fl)

--	else
--		nLog(tmp.msg)
--		mSleep(3000)
--		goto lingqurenwu
--	end
--end


--打开抖音指定视频
openURL("snssdk1128:"..url)
mSleep(5000)
moveTowards( 700,  150, 180, 600, 50)
mSleep(2000)

header_send = {ContentType = "application/x-www-form-urlencoded"}
body_send = {
	["token"] = token,
	["apply_id"] = apply_id,
	["task_id"] = task_id,
}

ts.setHttpsTimeOut(60) 
code,status_resp, body_resp = ts.httpsPost("http://uu.douzhuanapp.com/index.php/api/dl/tjdytask", header_send, body_send)
if code == 200 then
	tmp = json.decode(body_resp)
	nLog(tmp.msg)
	nLog(tmp.code)
end

--提交任务：请求后带token  apply_id   task_id gzs
--（gzs 工作室代码）http://uu.douzhuanapp.com/index.php/api/dl/tjdytask?token=de7e69a6a3bb4a4dcbf2ce4f30a21e86&apply_id=&task_id=&gzs=jiucaiwang
--{"msg":"任务提交成功","code":"0"}  0 成功提交
--{"msg":"任务信息错误","code":"1"} 
--{"msg":"任务已完成，请勿重复提交","code":"2"} 
--{"msg":"任务已结束，请到审核中任务查看","code":"3"} 
--{"msg":"任务提交失败","code":"4"} 
--{"msg":"请重新登录","code":"5"}