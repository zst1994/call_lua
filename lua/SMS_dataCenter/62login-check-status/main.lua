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
			mSleep(500)
            writePasteboard(self.account)
            mSleep(500)
			randomTap(x + 300, y,5)
			mSleep(700)
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
			mSleep(500)
            writePasteboard(self.password)
            mSleep(500)
			randomTap(x + 300, y + 90,5)
			mSleep(500)
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
        
		--匹配手机通讯录
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "4|15|0x007aff,-272|6|0x007aff,-254|-231|0x000000,-236|-231|0x000000,-209|-224|0x000000,-170|-233|0x000000,-138|-241|0x000000,-68|-229|0x000000,-34|-226|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("匹配手机通讯录")
			mSleep(500)
			self.subName = "匹配手机通讯录"
			break
		end
        
        --帐号或密码错误，请重新填写。
        mSleep(50)
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-1|0x576b95,40|0|0x576b95,-110|-155|0x000000,-100|-155|0x000000,-89|-156|0x000000,-72|-162|0x000000,-61|-158|0x000000,-27|-158|0x000000,8|-177|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("帐号或密码错误，请重新填写。")
			mSleep(500)
			self.subName = "帐号或密码错误，请重新填写。"
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
		
		--该微信帐号因使用了微信外挂、非官方客户端或模拟器，被限制登录，请尽快卸载对应的非法软件。若后续仍继续使用将永久限制登录。如需继续使用，请轻触“确定”申请解除限制。
	    mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "47|-4|0x576b95,-4|-381|0x000000,0|-376|0x000000,34|-385|0x000000,-2|-330|0x000000,14|-333|0x000000,-64|-246|0x000000,-60|-224|0x000000,-39|-135|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该微信帐号因使用了微信外挂、非官方客户端或模拟器，被限制登录，请尽快卸载对应的非法软件。若后续仍继续使用将永久限制登录。如需继续使用，请轻触“确定”申请解除限制。")
			mSleep(500)
			self.subName = "该微信帐号因使用了微信外挂、非官方客户端或模拟器，被限制登录，请尽快卸载对应的非法软件。若后续仍继续使用将永久限制登录。如需继续使用，请轻触“确定”申请解除限制。"
			break
        end
		
		--该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被永久限制登录，若帐号内有资金，可轻触“确定”按相关指引进行操作。
        mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "46|3|0x576b95,-52|-291|0x000000,-25|-277|0x000000,-46|-270|0x000000,-151|-241|0x000000,-146|-219|0x000000,-100|-242|0x000000,-45|-137|0x000000,-272|-151|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被永久限制登录，若帐号内有资金，可轻触“确定”按相关指引进行操作。")
			mSleep(500)
			self.subName = "该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被永久限制登录，若帐号内有资金，可轻触“确定”按相关指引进行操作。"
			break
        end
		
		--该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被限制登录，如需继续使用，请轻触“确定”申请解除限制。
        mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "48|0|0x576b95,-52|-292|0x000000,-27|-280|0x000000,-46|-273|0x000000,-154|-240|0x000000,-135|-241|0x000000,-114|-237|0x000000,-94|-237|0x000000,-152|-132|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被限制登录，如需继续使用，请轻触“确定”申请解除限制。")
			mSleep(500)
			self.subName = "该微信帐号因存在骚扰/恶意营销/欺诈等违规行为被限制登录，如需继续使用，请轻触“确定”申请解除限制。"
			break
        end
		
		--该帐号违反了《微信个人帐号使用规范》，请轻触“确定”了解详情后，继续登录微信。
        mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "49|-2|0x576b95,-153|-229|0x000000,-140|-238|0x000000,-118|-233|0x000000,-74|-232|0x000000,-39|-248|0x000000,-15|-233|0x000000,8|-236|0x000000,-27|-132|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该帐号违反了《微信个人帐号使用规范》，请轻触“确定”了解详情后，继续登录微信。")
			mSleep(500)
			self.subName = "该帐号违反了《微信个人帐号使用规范》，请轻触“确定”了解详情后，继续登录微信。"
			break
        end
		
		--该微信帐号因批量或者使用非法软件注册被限制登录，如需继续使用，请轻触“确定”申请解除限制。
        mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "48|1|0x576b95,-186|-235|0x000000,-179|-235|0x000000,-170|-235|0x000000,-143|-231|0x000000,-240|-198|0x000000,-219|-195|0x000000,-199|-189|0x000000,71|-129|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x - 300, y)
			mSleep(500)
			toast("该微信帐号因批量或者使用非法软件注册被限制登录，如需继续使用，请轻触“确定”申请解除限制。")
			mSleep(500)
			self.subName = "该微信帐号因批量或者使用非法软件注册被限制登录，如需继续使用，请轻触“确定”申请解除限制。"
			break
        end
		
		--你的微信号由于长期没有使用，已被回收。如果希望继续使用微信，请重新注册。
	    mSleep(50)
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "48|0|0x576b95,-49|-248|0x000000,-22|-220|0x000000,12|-245|0x000000,30|-235|0x000000,50|-237|0x000000,41|-148|0x000000,69|-146|0x000000,-156|-192|0x000000", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(200)
			tap(x, y)
			mSleep(500)
			toast("你的微信号由于长期没有使用，已被回收。如果希望继续使用微信，请重新注册。")
			mSleep(500)
			self.subName = "你的微信号由于长期没有使用，已被回收。如果希望继续使用微信，请重新注册。"
			break
        end
	end

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


