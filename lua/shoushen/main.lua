require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model				= {}
model.awz_bid 			= ""
model.awz_url			= ""
model.thinrecord_url    = ""
model.file_url			= ""

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/config.txt") 
	if tab then 
		self.awz_bid = string.gsub(tab[1],"%s+","")
		self.awz_url = string.gsub(tab[2],"%s+","")
		self.thinrecord_url = string.gsub(tab[3],"%s+","")
		self.file_url = string.gsub(tab[4],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在,请检查配置文件路径",5)
		goto read_file
	end
end

function model:main()
	self:getConfig()
	
	::run_again::
	runApp(self.awz_bid)

	while true do
		mSleep(200)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				toast("准备操作",1)
				mSleep(1000)
				break
			end
		else
			toast("当前应用不在前台，重新打开",1)
			mSleep(3000)
			goto run_again
		end
	end

	::new_phone::
	header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
	status_resp, header_resp, body_resp  = ts.httpGet(self.awz_url, header_send, body_send)
	toast(body_resp,1)
	mSleep(1000)
	if status_resp == 200 then
		local resJson = json.decode(body_resp)
		local result = resJson.result
		if result == 1 then
			toast("成功",1)
			mSleep(1000)
		else 
			toast("失败，请手动查看问题"..tostring(body_resp), 1)
			log("失败，请手动查看问题"..tostring(body_resp))
			mSleep(4000)
			goto new_phone
		end
	else
		goto new_phone
	end
	
	getcurrentrecordparam = readFile(self.file_url)
	if tab then 
		recordID = strSplit(string.gsub(getcurrentrecordparam[1],"%s+",""), ":")[2]
		toast(recordID,1)
		log(recordID)
		mSleep(1000)
	else
		dialog("参数文件不存在,请检查配置文件路径",5)
		goto new_phone
	end
	
	::thinrecord::
	header_send = {}
	body_send = {}
	ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
	status_resp, header_resp, body_resp  = ts.httpGet(self.thinrecord_url .. recordID, header_send, body_send)
	toast(body_resp,1)
	mSleep(1000)
	if status_resp == 200 then
		local resJson = json.decode(body_resp)
		local result = resJson.result
		if result == 1 then
			toast("瘦身成功",1)
			mSleep(1000)
		else 
			toast("失败，请手动查看问题"..tostring(body_resp), 1)
			log("失败，请手动查看问题"..tostring(body_resp))
			mSleep(4000)
			goto thinrecord
		end
	else
		goto thinrecord
	end
end

model:main()