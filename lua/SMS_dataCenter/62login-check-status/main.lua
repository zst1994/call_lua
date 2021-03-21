require("TSLib")
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.awz_bid 			= "AWZ"
model.axj_bid 			= "YOY"

model.wc_bid 			= "com.tencent.xin"
model.wc_folder         = "/Library/WechatPrivate/"
model.wc_file           = "/Library/WechatPrivate/wx.dat"

model.account           = ""
model.password          = ""
model.six_two_data      = ""

model.subName           = ""

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end

function model:_hexStringToFile(hex,file)
	local data = '';
	if hex==nil or string.len(hex)<2 then
		toast('error',1)
		return
	end
	hex = string.match(hex,"(%w+)");
	for i = 1, string.len(hex),2 do
		local code = string.sub(hex, i, i+1);
		data =data..string.char(tonumber(code,16));
	end
	local file = io.open(file, 'wb');
	file:write(data);
	file:close();
end

function model:_writeData() --写入62
	local wxdataPath = appDataPath(self.wc_bid) .. self.wc_folder;
	newfolder(wxdataPath)
	os.execute('chown mobile ' .. wxdataPath)
	self:_hexStringToFile(self.six_two_data, appDataPath(self.wc_bid) .. self.wc_file)
	os.execute('chown mobile ' .. appDataPath(self.wc_bid) .. self.wc_file)
end

function model:getAccount()
    ::get_account::
    header_send = {}
    body_send = {}
    ts.setHttpsTimeOut(60)
    status_resp, header_resp,body_resp = ts.httpGet("http://47.104.246.33/phone1.php?cmd=getphone", header_send, body_send)
	if status_resp == 200 then
		if #string.gsub(body_resp,"%s+","") > 0 then
		    toast(body_resp,1)
			return body_resp
		else
			toast("获取数据失败，重新获取:"..tostring(res),1)
			mSleep(30000)
			goto get_account
		end
	else
		toast("获取数据失败，重新获取:"..tostring(res),1)
		mSleep(5000)
		goto get_account
	end
end

function model:write_six_two()
    getData = self:getAccount()
	data = self:TryRemoveUtf8BOM(getData)
	if data ~= "" and data ~= nil then
		local data = strSplit(data,"|")
		if #data > 2 then
			self.account = data[1]
			self.password = data[2]
			self.six_two_data = data[3]
		end	
		self:_writeData()
		toast("写入成功！") 
		result = true
	else
		dialog("登录失败！原因：写入62数据无效！", 0) 
		result = false
	end	
	return result
end

function model:six_two_login()
	if self:write_six_two() then
		mSleep(2000)
	else
		dialog("登录失败！请检查数据！", 0)
		luaExit()
	end	
end

function model:clear_App()
	name = getAppName(self.awz_bid) 
	if #name > 0 then
		clear_bid = self.awz_bid 
	else 
		clear_bid = self.axj_bid
	end

	::run_again::
	closeApp(clear_bid)
	mSleep(500)
	runApp(clear_bid)
	mSleep(1000)

	while true do
		mSleep(200)
		flag = isFrontApp(clear_bid)
		if flag == 1 then
			if getColor(147,456) == 0x6f7179 then
				break
			end
		else
			goto run_again
		end
	end

	::new_phone::
	local sz = require("sz");
	local szhttp = require("szocket.http")
	local res, code = szhttp.request("http://127.0.0.1:1688/cmd?fun=newrecord")
	if code == 200 then
		local resJson = sz.json.decode(res)
		local result = resJson.result
		if result == 3 then
			toast("新机成功，但是ip重复了",1)
		elseif result == 1 then
			toast("新机成功",1)
		else 
			toast("失败，请手动查看问题", 1)
			mSleep(3000)
			goto run_again
		end
	end 
end

function model:clear_data ()
	local sz = require("sz")
	local sqlite3 = sz.sqlite3	
	del_sql = function ()
		local db = sqlite3.open("/private/var/Keychains/keychain-2.db")
		db:exec("delete from genp where agrp not like '%apple%'")
		db:exec("delete from cert")
		db:exec("delete from keys")
		db:exec("delete from inet")
		db:exec("delete from sqlite_sequence")
		assert(db:close() == sqlite3.OK)
	end

	delFileEx = function (path)
		os.execute("rm -rf "..path);
	end

	clearCache = function ()
		os.execute("su mobile -c uicache");
	end

	newfolder = function (path)
		os.execute("mkdir "..path);
	end

	if self.wc_bid == nil or type(self.wc_bid) ~= "string" then 
		dialog("清理传入的bid有问题") 
		return false 
	end

	toast("清理中,请勿中止",10);
	mSleep(888)
	::getDataPath::
	local dataPath = appDataPath(self.wc_bid);
	if dataPath == nil then
		goto getDataPath
	end

	local flag = appIsRunning(self.wc_bid);
	if flag == 1 then
		closeApp(self.wc_bid); 
		mSleep(1500)
	end

	delFileEx(dataPath.."/Documents") 
	delFileEx(dataPath.."/tmp")
	delFileEx(dataPath.."/Library/APCfgInfo.plist") 
	delFileEx(dataPath.."/Library/APWsjGameConfInfo.plist") 
	delFileEx(dataPath.."/Library/Preferences/*")
	delFileEx(dataPath..self.wc_folder.."*")
	mSleep(500)
	newfolder(dataPath.."/Documents") 
	newfolder(dataPath.."/tmp")
	os.execute("chmod -R 777 ar/Keychains");
	del_sql();
	clearKeyChain(self.wc_bid);--指定清除应用钥匙串信息Keychains
	--	local str = clearIDFAV();
	--	dialog(str)
	clearCookies();
	toast("清理",2);
	os.execute("chmod -R 777 "..dataPath.."/Documents");
	os.execute("chmod -R 777 "..dataPath.."/tmp");
	os.execute("chmod -R 777 "..dataPath.."/Library");
	os.execute("chmod -R 777 "..dataPath.."/Library/Preferences");
	mSleep(500)
	clearCache();
	toast("清理成功",1)
end

function model:loginAccount()
	::run_app::
	mSleep(200)
	runApp(self.wc_bid)
	mSleep(1000)
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 1100, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(200)
			tap(x - 350, y + 20)
			mSleep(500)
			toast("登录",1)
			mSleep(500)
			break
		end

		mSleep(200)
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "31|-1|0x576b95,55|9|0x576b95,96|0|0x576b95,225|-4|0x576b95,275|7|0x576b95,295|1|0x576b95,329|4|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(200)
			tap(x, y)
			mSleep(500)
			toast("微信号/QQ/邮箱登录",1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(200)
	    x,y = findMultiColorInRegionFuzzy(0x000000, "-5|0|0x000000,5|0|0x000000,11|0|0x000000,23|-1|0x000000,47|-1|0x000000,47|-7|0x000000,47|-14|0x000000,9|99|0x000000,49|95|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            writePasteboard(self.account)
            mSleep(200)
			randomTap(x + 300, y,5)
			mSleep(200)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(500)
			break
        end
	end
	
	while (true) do
		mSleep(200)
	    x,y = findMultiColorInRegionFuzzy(0x000000, "-5|0|0x000000,5|0|0x000000,11|0|0x000000,23|-1|0x000000,47|-1|0x000000,47|-7|0x000000,47|-14|0x000000,9|99|0x000000,49|95|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            writePasteboard(self.password)
            mSleep(200)
			randomTap(x + 300, y + 90,5)
			mSleep(200)
			keyDown("RightGUI")
			keyDown("v")
			keyUp("v")
			keyUp("RightGUI")
			mSleep(500)
        end
        
        mSleep(200)
        x,y = findMultiColorInRegionFuzzy(0xffffff, "38|7|0xffffff,339|8|0x07c160,11|-34|0x07c160,-304|3|0x07c160,20|8|0x07c160", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			tap(x, y)
			mSleep(500)
			toast("登录",1)
			mSleep(500)
			break
        end
	end
	
	while (true) do
	    --出现滑块
	    mSleep(100)
	    if getColor(110,702) == 0x007aff and getColor(697,705) == 0xe4e4e4 then
	        mSleep(500)
			toast("出现滑块",1)
			mSleep(500)
			self.subName = "出现滑块"
			break
	    end
	    
	    --该微信帐号因使用了微信外挂、非官方客户端或模拟器，将永久限制登录，请尽快卸载对应的非法软件。若帐号内有资金，可轻触“确定”按相关指引进行操作。
	    mSleep(50)
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "27|0|0x576b95,-330|-6|0x181819,-11|-329|0x000000,7|-331|0x000000,17|-334|0x000000,26|-319|0x000000,-26|-286|0x000000,-16|-270|0x000000,24|-289|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该微信帐号因使用了微信外挂、非官方客户端或模拟器，将永久限制登录，请尽快卸载对应的非法软件。若帐号内有资金，可轻触“确定”按相关指引进行操作。",1)
			mSleep(500)
			self.subName = "该微信帐号因使用了微信外挂、非官方客户端或模拟器，将永久限制登录，请尽快卸载对应的非法软件。若帐号内有资金，可轻触“确定”按相关指引进行操作。"
			break
        end
        
        --帐号或密码错误，请出现填写
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-1|0x576b95,40|0|0x576b95,-110|-155|0x000000,-100|-155|0x000000,-89|-156|0x000000,-72|-162|0x000000,-61|-158|0x000000,-27|-158|0x000000,8|-177|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("帐号或密码错误，请出现填写")
			mSleep(500)
			self.subName = "帐号或密码错误，请出现填写"
			break
        end
        
-- 	    --该微信账号因使用外挂被限制登录
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|-1|0x576b95,40|1|0x576b95,-7|-313|0x1a1a1a,3|-300|0x1a1a1a,20|-303|0x1a1a1a,36|-311|0x1a1a1a,35|-293|0x1a1a1a,-4|-136|0x1a1a1a,9|-137|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(200)
-- 			tap(x - 300, y)
-- 			mSleep(500)
-- 			toast("微信账号因使用外挂被限制登录",1)
-- 			mSleep(500)
-- 			self.subName = "微信账号因使用外挂被限制登录"
-- 			break
--         end
	end
	
-- 	::login::
-- 	while true do
-- 	    --安全验证
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x10aeff, "83|-12|0x10aeff,36|-17|0xffffff,-135|371|0x1aad19,-138|425|0x1aad19,212|368|0x1aad19,202|425|0x1aad19", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(100)
--             toast("安全验证1",1)
-- 			mSleep(500)
--             category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
--         end
        
--         --安全验证
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x1aad19, "175|-23|0x1aad19,184|47|0x1aad19,338|17|0x1aad19,137|-401|0x10aeff,216|-399|0x10aeff,178|-401|0xffffff,246|-217|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(100)
--             toast("安全验证2",1)
-- 			mSleep(500)
--             category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
--         end
		
-- 		--安全验证
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy( 0x10aeff, "47|-13|0x10aeff,22|9|0xffffff,97|152|0x191919,-138|783|0x07c160,-140|819|0x07c160,190|781|0x07c160,190|824|0x07c160", 90, 0, 0, 749, 1333)
-- 		if x ~= -1 then
--             mSleep(100)
--             toast("安全验证3",1)
-- 			mSleep(500)
-- 			category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
--         end
		
-- 		--安全验证
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy( 0x10aeff, "28|4|0xffffff,52|8|0x10aeff,105|160|0x191919,-122|784|0x07c160,19|836|0x07c160,199|784|0x07c160,28|784|0x07c160", 90, 0, 0, 749, 1333)
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("安全验证4",1)
-- 			mSleep(500)
-- 			category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
-- 		end
        
--         --绑定手机号
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0xb4b4b4, "35|-1|0xb4b4b4,74|-3|0xb4b4b4,-32|-481|0x171717,-25|-477|0x171717,38|-481|0x171717,64|-476|0x171717,110|-486|0x171717,110|-475|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(100)
--             toast("绑定手机号",1)
-- 			mSleep(500)
--             category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
--         end
        
--         --匹配通讯录
--         mSleep(200)
--     	x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "321|10|0x576b95,317|-11|0x576b95,39|-356|0x1a1a1a,224|-358|0x1a1a1a,259|-356|0x1a1a1a", 90, 0, 0, 749, 1333)
--     	if x~=-1 and y~=-1 then
--     		mSleep(math.random(500, 700))
--     		toast("匹配通讯录",1)
--     		mSleep(500)
--     		category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
--     	end
    	
--     	--wc界面
--     	mSleep(200)
-- 		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("wc界面",1)
-- 			category = "success-data"
-- 			data = self.infoData.."----成功"
--             break
-- 		end
        
--         --密码错误
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "45|-1|0x576b95,-210|-162|0x1a1a1a,-193|-166|0x1a1a1a,-163|-165|0x1a1a1a,-58|-157|0x1a1a1a,-37|-157|0x1a1a1a,12|-165|0x1a1a1a,66|-160|0x1a1a1a,170|-164|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("密码错误",1)
-- 			category = "error-data"
-- 			data = self.infoData.."----密码错误"
-- 			break
-- 		end
		
-- 		--批量注册
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,46|0|0x576b95,-180|-231|0x1a1a1a,-169|-234|0x1a1a1a,-161|-216|0x1a1a1a,-138|-241|0x202020,-137|-226|0x1a1a1a,-129|-220|0x1a1a1a,88|-149|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("批量注册",1)
-- 			category = "error-data"
-- 			data = self.infoData.."----批量注册"
-- 			break
--         end
	    
-- 	    --长期未登陆
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|3|0x576b95,39|-1|0x576b95,-292|-275|0x1a1a1a,-287|-265|0x1a1a1a,-249|-276|0x1a1a1a,-234|-276|0x1a1a1a,-211|-276|0x1a1a1a,-176|-267|0x1a1a1a,-143|-266|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("长期未登陆",1)
-- 			category = "error-data"
-- 			data = self.infoData.."----长期未登陆"
-- 			break
--         end
        
--         --手机自助冻结
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x576b95, "12|2|0x576b95,40|-1|0x576b95,-7|-239|0x1a1a1a,7|-229|0x1a1a1a,1|-219|0x1a1a1a,30|-238|0x1a1a1a,43|-232|0x1a1a1a,37|-226|0x1a1a1a,37|-216|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("手机自助冻结",1)
-- 			category = "error-data"
-- 			data = self.infoData.."----手机自助冻结"
-- 			break
--         end
        
--         --指定日期才能提取
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x10aeff, "82|-4|0x10aeff,34|7|0xefeff4,-141|543|0x04be02,-136|586|0x04be02,206|546|0x04be02,202|587|0x04be02,22|176|0x000000,46|160|0x000000,82|172|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			toast("指定日期才能提取",1)
-- 			category = "error-data"
-- 			data = self.infoData.."----指定日期才能提取"
-- 			break
--         end
        
--         --提取资产或还款
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x07c160, "262|-5|0x07c160,70|0|0xffffff,153|7|0xffffff,-84|-864|0x020202,5|-869|0x020202,47|-852|0x020202,262|-858|0x020202,279|-860|0x020202,334|-874|0x020202", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(math.random(500, 700))
-- 			toast("提取资产或还款",1)
-- 			mSleep(500)
-- 			category = "success-data"
-- 			data = self.infoData.."----成功"
-- 			break
--         end
        
--         --提取资产或还款
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x07c160, "180|1|0x07c160,51|1|0xffffff,134|6|0xffffff,-93|-861|0x171717,-47|-864|0x171717,12|-858|0x171717,238|-857|0x171717,255|-856|0x171717,284|-855|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(math.random(500, 700))
-- 			toast("提取资产或还款",1)
-- 			mSleep(500)
-- 			category = "success-data"
-- 			data = self.infoData.."----成功"
-- 			break
--         end
        
--         --滑块
--         mSleep(200)
-- 		if getColor(108,699) == 0x007aff then
-- 		    mSleep(200)
-- 		    if getColor(348,464) ~= 0xbfbfbf and getColor(108,363) ~= 0xefefef then
--     			x_lens = self:moves()
--     			if tonumber(x_lens) > 0 then
--     				mSleep(math.random(500, 700))
--     				moveTowards(108, 699, 10, x_len-65)
--     				mSleep(3000)
--     			else
--     				mSleep(math.random(500, 1000))
--     				tap(57,86)
--     				mSleep(math.random(3000, 6000))
-- 					goto login
--     			end
--     		else
--     		    mSleep(math.random(500, 1000))
-- 				tap(695,786)
-- 				mSleep(math.random(3000, 6000))
-- 		    end
-- 		end
		
-- 		--操作频繁
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|4|0x576b95,39|1|0x576b95,-93|-175|0x1a1a1a,-94|-163|0x1a1a1a,-84|-167|0x1a1a1a,-73|-167|0x1a1a1a,-14|-175|0x1a1a1a,-7|-166|0x1a1a1a,225|-162|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x ~= -1 then
--             mSleep(math.random(500, 700))
-- 			toast("操作频率过快",1)
-- 			mSleep(500)
-- 			category = "caozuo-data"
-- 			data = self.infoData.."----操作频率过快"
-- 			break
--         end
        
--         --连接失败
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "11|0|0x576b95,40|-1|0x576b95,-234|-163|0x1a1a1a,-200|-167|0x1a1a1a,-155|-174|0x1a1a1a,-62|-164|0x1a1a1a,-25|-161|0x1a1a1a,110|-167|0x1a1a1a,217|-164|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("连接失败",1)
-- 			mSleep(500)
-- 			self:vpn()
-- 			mSleep(500)
-- 			goto login
--         end
        
--         --大量发布垃圾信息
-- 		mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,45|-3|0x576b95,-284|-232|0x1a1a1a,-270|-240|0x1a1a1a,-269|-218|0x1a1a1a,-251|-231|0x1a1a1a,-237|-244|0x1a1a1a,-230|-235|0x1a1a1a,-217|-227|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("大量发布垃圾信息",1)
-- 			mSleep(500)
--         end
		
-- 		--该微信账号因使用外挂被限制登录
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|-1|0x576b95,40|1|0x576b95,-7|-313|0x1a1a1a,3|-300|0x1a1a1a,20|-303|0x1a1a1a,36|-311|0x1a1a1a,35|-293|0x1a1a1a,-4|-136|0x1a1a1a,9|-137|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("微信账号因使用外挂被限制登录1",1)
-- 			mSleep(500)
--         end
        
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-2|0x576b95,39|0|0x576b95,-7|-353|0x1a1a1a,3|-340|0x1a1a1a,21|-344|0x1a1a1a,35|-349|0x1a1a1a,36|-334|0x1a1a1a,-92|-142|0x1a1a1a,-33|-144|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("微信账号因使用外挂被限制登录2",1)
-- 			mSleep(500)
--         end
        
--         --恶意营销
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy( 0x576b95, "28|3|0x576b95,-47|-286|0x1a1a1a,-21|-286|0x1a1a1a,-22|-272|0x1a1a1a,-33|-258|0x1c1c1c,-39|-264|0x1a1a1a,-195|-155|0x1a1a1a,-195|-146|0x1a1a1a,-179|-147|0x1a1a1a", 90, 0, 0, 749, 1333)
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("恶意营销1",1)
-- 			mSleep(500)
-- 		end

-- 		--恶意营销
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,44|-2|0x576b95,-184|-151|0x1a1a1a,-165|-155|0x1a1a1a,-165|-150|0x1a1a1a,-173|-140|0x1a1a1a,-143|-148|0x1a1a1a,-131|-149|0x1a1a1a,-124|-148|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("恶意营销2",1)
-- 			mSleep(500)
-- 		end
		
-- 		--外挂封号
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy( 0x576b95, "17|-2|0x576b95,46|-2|0x576b95,-388|-303|0x1a1a1a,-356|-300|0x1a1a1a,-320|-303|0x1a1a1a,-32|-145|0x1a1a1a,3|-139|0x1a1a1a,22|-152|0x1a1a1a,22|-144|0x1a1a1a", 90, 0, 0, 749, 1333)
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("外挂封号1",1)
-- 			mSleep(500)
-- 		end
		
-- 		--外挂封号
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,45|1|0x576b95,-1|-359|0x1a1a1a,9|-342|0x1a1a1a,26|-352|0x1a1a1a,41|-355|0x1a1a1a,42|-340|0x1a1a1a,-86|-141|0x1a1a1a,-27|-148|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("外挂封号2",1)
-- 			mSleep(500)
-- 		end
  
--         --涉嫌传播骚扰
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,40|0|0x576b95,-192|-269|0x1a1a1a,-175|-283|0x1a1a1a,-174|-278|0x1a1a1a,-175|-271|0x1a1a1a,-157|-272|0x1a1a1a,-143|-279|0x1a1a1a,-143|-266|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("涉嫌传播骚扰1",1)
-- 			mSleep(500)
--         end
        
--         --涉嫌传播骚扰
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-3|0x576b95,39|1|0x576b95,-194|-226|0x1a1a1a,-185|-244|0x1a1a1a,-172|-239|0x1a1a1a,-176|-231|0x1a1a1a,-159|-232|0x1a1a1a,-143|-239|0x1a1a1a,-144|-223|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("涉嫌传播骚扰2",1)
-- 			mSleep(500)
--         end
        
--         --解封环境异常
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "11|3|0x576b95,39|-1|0x576b95,-173|-310|0x1a1a1a,-158|-302|0x1a1a1a,-138|-320|0x1a1a1a,-138|-304|0x1a1a1a,-120|-308|0x1a1a1a,-90|-304|0x1a1a1a,-57|-309|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("解封环境异常",1)
-- 			mSleep(500)
--         end
        
--         --参与赌博
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "10|2|0x576b95,39|0|0x576b95,17|-230|0x1a1a1a,26|-231|0x1a1a1a,35|-233|0x1a1a1a,38|-220|0x1a1a1a,54|-227|0x1a1a1a,69|-234|0x1a1a1a,69|-220|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("参与赌博1",1)
-- 			mSleep(500)
--         end
        
--         --参与赌博
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,39|-1|0x576b95,17|-270|0x1a1a1a,27|-275|0x1a1a1a,36|-276|0x1a1a1a,38|-261|0x1a1a1a,55|-269|0x1a1a1a,70|-270|0x1a1a1a,69|-262|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("参与赌博2",1)
-- 			mSleep(500)
--         end
        
--         --被投诉组织或参与网络赌博
-- 	    mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "18|0|0x576b95,46|-4|0x576b95,-392|-230|0x1a1a1a,-382|-229|0x1a1a1a,-374|-239|0x1a1a1a,-371|-223|0x1a1a1a,-355|-231|0x1a1a1a,-340|-236|0x1a1a1a,-341|-224|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("被投诉组织或参与网络赌博",1)
-- 			mSleep(500)
--         end
        
--         -- 多人投诉
--         mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|0|0x576b95,45|1|0x576b95,-77|-229|0x1a1a1a,-62|-228|0x1a1a1a,-62|-241|0x1a1a1a,-41|-227|0x1a1a1a,-20|-234|0x1a1a1a,28|-149|0x1a1a1a,88|-147|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("多人投诉",1)
-- 			mSleep(500)
-- 		end
		
-- 		--被投诉限制登录
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "18|1|0x576b95,45|-2|0x576b95,-323|-183|0x1a1a1a,-310|-188|0x1a1a1a,-305|-184|0x1a1a1a,-279|-184|0x1a1a1a,-355|-261|0x1a1a1a,-319|-262|0x1a1a1a,-82|-138|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
-- 		if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("被投诉限制登录",1)
-- 			mSleep(500)
-- 		end
		
-- 		-- 被投诉并确有违规
-- 		mSleep(200)
-- 		x,y = findMultiColorInRegionFuzzy(0x576b95, "11|2|0x576b95,39|0|0x576b95,55|-223|0x1a1a1a,64|-238|0x1a1a1a,70|-232|0x1a1a1a,72|-227|0x1a1a1a,69|-222|0x1a1a1a,92|-231|0x1a1a1a,112|-229|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("被投诉并确有违规",1)
-- 			mSleep(500)
-- 		end
	    
-- 	    --提取账号内财产
-- 	    mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x04be02, "4|32|0x04be02,481|-8|0x04be02,472|30|0x04be02,460|-113|0x04be02,453|-68|0x04be02,25|-114|0x04be02,23|-76|0x04be02,136|-251|0x0d7aff", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x + 200, y + 40)
-- 			mSleep(math.random(500, 700))
-- 			toast("提取账号内财产",1)
-- 			mSleep(500)
--         end
        
--         --账号存在异常
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "11|0|0x576b95,39|0|0x576b95,-73|-274|0x1a1a1a,-72|-263|0x1a1a1a,-72|-256|0x1a1a1a,-51|-268|0x1a1a1a,-25|-266|0x1a1a1a,-38|-251|0x1a1a1a,83|-140|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("账号存在异常1",1)
-- 			mSleep(500)
--         end
	    
-- 	    --账号存在异常
--         mSleep(200)
-- 	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-1|0x576b95,39|-2|0x576b95,-74|-322|0x1a1a1a,-73|-311|0x1a1a1a,-67|-299|0x1a1a1a,-52|-315|0x1a1a1a,-26|-315|0x1a1a1a,-39|-298|0x1a1a1a,-104|-144|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("账号存在异常2",1)
-- 			mSleep(500)
--         end
        
--         --投诉涉嫌诈骗行为
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "12|2|0x576b95,39|0|0x576b95,91|-264|0x1a1a1a,111|-278|0x1a1a1a,111|-270|0x1a1a1a,111|-263|0x1a1a1a,-118|-144|0x1a1a1a,-105|-146|0x1a1a1a,-97|-150|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("投诉涉嫌诈骗行为",1)
-- 			mSleep(500)
--         end
        
--         --涉嫌传播非法营销
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-3|0x576b95,44|-2|0x576b95,-37|-275|0x1a1a1a,-27|-273|0x1a1a1a,-16|-274|0x1a1a1a,-26|-260|0x1a1a1a,-2|-270|0x1a1a1a,13|-280|0x1a1a1a,14|-265|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("涉嫌传播非法营销",1)
-- 			mSleep(500)
--         end
        
--         --打招呼存在异常
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,39|0|0x576b95,57|-308|0x1a1a1a,68|-321|0x1a1a1a,74|-309|0x1a1a1a,90|-309|0x1a1a1a,101|-322|0x1a1a1a,106|-307|0x1a1a1a,107|-295|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(x, y)
-- 			mSleep(math.random(500, 700))
-- 			toast("打招呼存在异常",1)
-- 			mSleep(500)
--         end

--         --返回操作
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x04be02, "140|-34|0x04be02,147|30|0x04be02,366|0|0x04be02,97|-368|0x10aeff,198|-372|0x10aeff,144|-356|0xefeff4,107|-178|0x000000,191|-182|0x000000,214|-189|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
-- 			mSleep(math.random(500, 700))
-- 			tap(276, 1286)
-- 			mSleep(math.random(3500, 4700))
-- 			for var=1, 5 do
-- 			    mSleep(200)
--                 if getColor(309,626) == 0x5a5a5b then
--                     mSleep(math.random(500, 700))
--         			tap(276, 1286)
--         			mSleep(math.random(500, 700))
--         			break
--                 end
-- 			end
-- 			toast("返回操作",1)
-- 			mSleep(500)
--         end
        
--         --提取失败，需解封
--         mSleep(200)
--         x,y = findMultiColorInRegionFuzzy(0x10aeff, "74|8|0x10aeff,-197|390|0x04be02,-197|438|0x04be02,30|385|0x04be02,49|445|0x04be02,348|390|0x04be02,110|181|0x000000,3|194|0x000000,87|189|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
--         if x~=-1 and y~=-1 then
--             mSleep(500)
--             toast("提取失败，需解封",1)
--             mSleep(1000)
--         	category = "error-data"
--         	data = self.infoData.."----资金安全"
--         	break
--         end
-- 	end

    ::push::
	header_send = {}
    body_send = {}
    ts.setHttpsTimeOut(60)
    status_resp, header_resp,body_resp = ts.httpGet("http://47.104.246.33/phone1.php?cmd=poststatus&phone=" .. self.account .. "&status=" .. self.subName, header_send, body_send)
	if status_resp == 200 then
		if reTxtUtf8(body_resp) == "反馈成功" then
			toast("号码状态标记成功",1)
		else
		    oast("号码标记失败，重新标记:"..tostring(body_resp),1)
		    mSleep(3000)
			goto push
		end
	else
		toast("号码标记失败，重新标记:"..tostring(body_resp),1)
		mSleep(3000)
		goto push
	end

	::over::
end
	
function model:main()
	while true do
		self:clear_App()
		self:clear_data()
		self:six_two_login()
		self:loginAccount()
		toast('一个流程结束，进行下一个',1)
	end
end

model:main()


