require("TSLib")
local ts 				= require('ts')
local sz 				= require("sz")
local json 				= ts.json
local ts_enterprise_lib = require("ts_enterprise_lib")

local model 			= {}

model.wc_bid = ""
model.wc_folder = ""
model.wc_file = ""
model.awz_bid = ""
model.awz_url = ""

model.account = ""
model.password = ""
model.six_two_data = ""

model.infoData = ""

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function model:getConfig()
	::read_file::
	tab = readFile(userPath().."/res/config1.txt") 
	if tab then 
		self.wc_bid = string.gsub(tab[1],"%s+","")
		self.wc_folder = string.gsub(tab[2],"%s+","")
		self.wc_file = string.gsub(tab[3],"%s+","")
		self.awz_bid = string.gsub(tab[4],"%s+","")
		self.awz_url = string.gsub(tab[5],"%s+","")
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在",5)
		goto read_file
	end
end

function model:TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end

function model:clear_App()
	::run_again::
	mSleep(500)
	closeApp(self.awz_bid) 
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(1, 3))

	while true do
		--AWZ，AXJ
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
			if getColor(657,1307) == 0x0950d0 or getColor(652,1198) == 0x0950d0 then
				toast("准备newApp",1)
				break
			end
		else
			goto run_again
		end
	end

	mSleep(1000)
	if getColor(56,1058) == 0x6f7179 then
		mSleep(math.random(500, 1000))
		tap(225,826)
		mSleep(math.random(500, 1000))
		while true do
			mSleep(200)
			if getColor(376, 735) == 0xffffff or getColor(379, 562) == 0xffffff then
				toast("newApp成功",1)
				break
			end
			
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x007aff, "2|17|0x007aff,11|20|0x007aff,24|3|0x007aff,46|10|0x007aff,53|5|0x007aff,61|21|0x007aff,52|20|0x007aff", 90, 0, 0, 749, 1333)
			if x ~= -1 and y ~= -1 then
				self.vpn()
				mSleep(1000)
				goto run_again
			end
			
		end
	else
		::new_phone::
		local sz = require("sz");
		local http = require("szocket.http")
		local res, code = http.request(self.awz_url)
		if code == 200 then
			local resJson = sz.json.decode(res)
			local result = resJson.result
			if result == 3 then
				toast("新机成功，但是ip重复了",1)
			elseif result == 1 then
				toast("新机成功",1)
			elseif result == 100 then
				self.vpn()
				mSleep(1000)
				goto run_again
			else 
				toast("失败，请手动查看问题："..tostring(res), 1)
				mSleep(3000)
				goto run_again
			end
		end 
	end
end

function model:clear_data (bid)
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

	if bid == nil or type(bid) ~= "string" then 
		dialog("清理传入的bid有问题") 
		return false 
	end

	toast("清理中,请勿中止",10);
	mSleep(888)
	::getDataPath::
	local dataPath = appDataPath(bid);
	if dataPath == nil then
		goto getDataPath
	end

	local flag = appIsRunning(bid);
	if flag == 1 then
		closeApp(bid); 
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
	clearKeyChain(bid);--指定清除应用钥匙串信息Keychains
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
	mSleep(1000)
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动",1)
	mSleep(500)
	keepScreen(true)
	mSleep(500)
	snapshot("test_3.jpg", 30, 244, 719, 639)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	mSleep(500)
	if self:file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(500)
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333);   
		mSleep(500)
		if type(point) == "table"  and #point ~=0  then
			x_len = point[1].x
			toast(x_len,1)
			return x_len
		else
			return 0
		end
	else
		dialog("文件不存在",1)
		mSleep(math.random(1000, 1500))
		return 0
	end
end

function model:vpn()
	mSleep(math.random(500, 700))
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(math.random(500, 700))
	old_data = getNetIP() --获取IP  
	toast(old_data,1)

	::get_vpn::
	mSleep(math.random(200, 500))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态",1)
		setVPNEnable(false)
		for var= 1, 10 do
			mSleep(math.random(200, 500))
			toast("等待vpn切换"..var,1)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("关闭状态",1)
	end

	setVPNEnable(true)
	mSleep(1000*math.random(10, 15))

	new_data = getNetIP() --获取IP  
	toast(new_data,1)
	if new_data == old_data then
		toast("vpn切换失败",1)
		mSleep(math.random(200, 500))
		setVPNEnable(false)
		mSleep(math.random(200, 500))
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "3|15|0x007aff,19|10|0x007aff,-50|-128|0x000000,-34|-147|0x000000,3|-127|0x000000,37|-132|0x000000,59|-135|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
		end

		--好
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "1|20|0x007aff,11|0|0x007aff,18|17|0x007aff,14|27|0x007aff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			randomsTap(x,y,10)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("vpn正常使用", 1)
	end
end

function model:timeOutRestart(t1)
	t2 = ts.ms()

	if os.difftime(t2, t1) > 40 then
		toast("超过60秒返回重新进入", 1)
		mSleep(500)
		return true
	else
		return false
	end
end

function model:loginAccount()
    ::getSixData::
	local category = "six-data"
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","get_data",category)
	if plugin_ok and api_ok then
	    self.infoData = data
	    toast(self.infoData, 1)
		data = self:TryRemoveUtf8BOM(self.infoData)
    	if data ~= "" and data ~= nil then
    		local data = strSplit(data,"----")
    		if #data > 2 then
    			self.account = data[1]
    			self.password = data[2]
    			self.six_two_data = data[3]
    		end	
    	else
    		dialog("62数据解析无效！", 5)
    		goto over
    	end	
	else
		dialog("62数据获取失败或者数据已经用完，请重新上传新数据:"..tostring(plugin_ok).."----"..tostring(api_ok), 60)
		mSleep(1000)
		goto getSixData
	end
	
	::run_app::
	mSleep(1000)
	runApp(self.wc_bid)
	mSleep(2000)
	while (true) do
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 1100, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x - 350, y + 20)
			mSleep(math.random(500, 700))
			toast("登录",1)
			mSleep(500)
			break
		end

		mSleep(math.random(200, 300))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "31|-1|0x576b95,55|9|0x576b95,96|0|0x576b95,225|-4|0x576b95,275|7|0x576b95,295|1|0x576b95,329|4|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("微信号/QQ/邮箱登录",1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "31|-1|0x576b95,55|9|0x576b95,96|0|0x576b95,225|-4|0x576b95,275|7|0x576b95,295|1|0x576b95,329|4|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
		end

		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "33|-4|0x576b95,56|3|0x576b95,72|-4|0x576b95,105|-1|0x576b95,162|3|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			while (true) do
				mSleep(math.random(200, 300))
				x1,y1 = findMultiColorInRegionFuzzy( 0xededed, "-9|0|0xbebebe,10|0|0xbebebe,1|-8|0xbebebe,1|11|0xbebebe,-4|-4|0xededed,5|-4|0xededed,5|5|0xededed,-4|5|0xededed", 90, 647, 0, 749, 648)
				if x1~=-1 and y1~=-1 then
					key = "ReturnOrEnter"
					keyDown(key)
					keyUp(key)
					break
				else
					mSleep(700)
					tap(x + 343, y - 209)
					mSleep(math.random(1500, 1700))
					inputKey(self.account)
					mSleep(500)
				end
			end
			toast("输入账号",1)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "33|-4|0x576b95,56|3|0x576b95,72|-4|0x576b95,105|-1|0x576b95,162|3|0x576b95", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			while (true) do
				mSleep(math.random(200, 300))
				x1,y1 = findMultiColorInRegionFuzzy( 0xededed, "-9|0|0xbebebe,10|0|0xbebebe,1|-8|0xbebebe,1|11|0xbebebe,-4|-4|0xededed,5|-4|0xededed,5|5|0xededed,-4|5|0xededed", 90, 647, 0, 749, 648)
				if x1~=-1 and y1~=-1 then
					mSleep(100)
					break
				else
					mSleep(700)
					tap(x + 343, y - 121)
					mSleep(math.random(1500, 1700))
					inputKey(self.password)
					mSleep(500)
				end
			end
			toast("输入密码",1)
			mSleep(500)
			break
		end
	end
    
    ::login::
	while (true) do
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "35|9|0xffffff,-304|-34|0x07c160,-306|32|0x07c160,1|-38|0x07c160,16|34|0x07c160,334|-35|0x07c160,336|27|0x07c160", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("登录",1)
			mSleep(500)
			break
		end
	end
	
	t1 = ts.ms()
	while true do
	    --安全验证
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x10aeff, "83|-12|0x10aeff,36|-17|0xffffff,-135|371|0x1aad19,-138|425|0x1aad19,212|368|0x1aad19,202|425|0x1aad19", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(100)
            toast("安全验证1",1)
			mSleep(500)
            category = "success-data"
			data = self.infoData.."----成功"
            break
        end
        
        --安全验证
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x1aad19, "175|-23|0x1aad19,184|47|0x1aad19,338|17|0x1aad19,137|-401|0x10aeff,216|-399|0x10aeff,178|-401|0xffffff,246|-217|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(100)
            toast("安全验证2",1)
			mSleep(500)
            category = "success-data"
			data = self.infoData.."----成功"
            break
        end
		
		--安全验证
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x10aeff, "47|-13|0x10aeff,22|9|0xffffff,97|152|0x191919,-138|783|0x07c160,-140|819|0x07c160,190|781|0x07c160,190|824|0x07c160", 90, 0, 0, 749, 1333)
		if x ~= -1 then
            mSleep(100)
            toast("安全验证3",1)
			mSleep(500)
			category = "success-data"
			data = self.infoData.."----成功"
            break
        end
        
        --绑定手机号
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0xb4b4b4, "35|-1|0xb4b4b4,74|-3|0xb4b4b4,-32|-481|0x171717,-25|-477|0x171717,38|-481|0x171717,64|-476|0x171717,110|-486|0x171717,110|-475|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(100)
            toast("绑定手机号",1)
			mSleep(500)
            category = "success-data"
			data = self.infoData.."----成功"
            break
        end
        
        --匹配通讯录
        mSleep(200)
    	x,y = findMultiColorInRegionFuzzy( 0x1a1a1a, "321|10|0x576b95,317|-11|0x576b95,39|-356|0x1a1a1a,224|-358|0x1a1a1a,259|-356|0x1a1a1a", 90, 0, 0, 749, 1333)
    	if x~=-1 and y~=-1 then
    		mSleep(math.random(500, 700))
    		toast("匹配通讯录",1)
    		mSleep(500)
    		category = "success-data"
			data = self.infoData.."----成功"
            break
    	end
    	
    	--wc界面
    	mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("wc界面",1)
			category = "success-data"
			data = self.infoData.."----成功"
            break
		end
        
        --密码错误
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "45|-1|0x576b95,-210|-162|0x1a1a1a,-193|-166|0x1a1a1a,-163|-165|0x1a1a1a,-58|-157|0x1a1a1a,-37|-157|0x1a1a1a,12|-165|0x1a1a1a,66|-160|0x1a1a1a,170|-164|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("密码错误",1)
			category = "error-data"
			data = self.infoData.."----密码错误"
			break
		end
		
		--批量注册
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,46|0|0x576b95,-180|-231|0x1a1a1a,-169|-234|0x1a1a1a,-161|-216|0x1a1a1a,-138|-241|0x202020,-137|-226|0x1a1a1a,-129|-220|0x1a1a1a,88|-149|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("批量注册",1)
			category = "error-data"
			data = self.infoData.."----批量注册"
			break
        end
	    
	    --长期未登陆
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|3|0x576b95,39|-1|0x576b95,-292|-275|0x1a1a1a,-287|-265|0x1a1a1a,-249|-276|0x1a1a1a,-234|-276|0x1a1a1a,-211|-276|0x1a1a1a,-176|-267|0x1a1a1a,-143|-266|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("长期未登陆",1)
			category = "error-data"
			data = self.infoData.."----长期未登陆"
			break
        end
        
        --手机自助冻结
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "12|2|0x576b95,40|-1|0x576b95,-7|-239|0x1a1a1a,7|-229|0x1a1a1a,1|-219|0x1a1a1a,30|-238|0x1a1a1a,43|-232|0x1a1a1a,37|-226|0x1a1a1a,37|-216|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("手机自助冻结",1)
			category = "error-data"
			data = self.infoData.."----手机自助冻结"
			break
        end
        
        --指定日期才能提取
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x10aeff, "82|-4|0x10aeff,34|7|0xefeff4,-141|543|0x04be02,-136|586|0x04be02,206|546|0x04be02,202|587|0x04be02,22|176|0x000000,46|160|0x000000,82|172|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("指定日期才能提取",1)
			category = "error-data"
			data = self.infoData.."----指定日期才能提取"
			break
        end
        
        --提取资产或还款
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x07c160, "262|-5|0x07c160,70|0|0xffffff,153|7|0xffffff,-84|-864|0x020202,5|-869|0x020202,47|-852|0x020202,262|-858|0x020202,279|-860|0x020202,334|-874|0x020202", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(math.random(500, 700))
			toast("提取资产或还款",1)
			mSleep(500)
			category = "success-data"
			data = self.infoData.."----成功"
			break
        end
        
        --提取资产或还款
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x07c160, "180|1|0x07c160,51|1|0xffffff,134|6|0xffffff,-93|-861|0x171717,-47|-864|0x171717,12|-858|0x171717,238|-857|0x171717,255|-856|0x171717,284|-855|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(math.random(500, 700))
			toast("提取资产或还款",1)
			mSleep(500)
			category = "success-data"
			data = self.infoData.."----成功"
			break
        end
        
        --滑块
        mSleep(math.random(200, 300))
		if getColor(108,699) == 0x007aff then
		    mSleep(200)
		    if getColor(348,464) ~= 0xbfbfbf and getColor(108,363) ~= 0xefefef then
    			x_lens = self:moves()
    			if tonumber(x_lens) > 0 then
    				mSleep(math.random(500, 700))
    				moveTowards(108, 699, 10, x_len-65)
    				mSleep(3000)
    			else
    				mSleep(math.random(500, 1000))
    				tap(57,86)
    				mSleep(math.random(3000, 6000))
					goto login
    			end
    		else
    		    mSleep(math.random(500, 1000))
				tap(695,786)
				mSleep(math.random(3000, 6000))
		    end
		    t1 = ts.ms()
		end
		
		--操作频繁
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|4|0x576b95,39|1|0x576b95,-93|-175|0x1a1a1a,-94|-163|0x1a1a1a,-84|-167|0x1a1a1a,-73|-167|0x1a1a1a,-14|-175|0x1a1a1a,-7|-166|0x1a1a1a,225|-162|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
            mSleep(math.random(500, 700))
			toast("操作频率过快",1)
			mSleep(500)
			category = "caozuo-data"
			data = self.infoData.."----操作频率过快"
			break
        end
        
        --连接失败
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|0|0x576b95,40|-1|0x576b95,-234|-163|0x1a1a1a,-200|-167|0x1a1a1a,-155|-174|0x1a1a1a,-62|-164|0x1a1a1a,-25|-161|0x1a1a1a,110|-167|0x1a1a1a,217|-164|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("连接失败",1)
			mSleep(500)
			self:vpn()
			mSleep(500)
			goto login
        end
        
        --大量发布垃圾信息
		mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,45|-3|0x576b95,-284|-232|0x1a1a1a,-270|-240|0x1a1a1a,-269|-218|0x1a1a1a,-251|-231|0x1a1a1a,-237|-244|0x1a1a1a,-230|-235|0x1a1a1a,-217|-227|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("大量发布垃圾信息",1)
			mSleep(500)
			t1 = ts.ms()
        end
		
		--该微信账号因使用外挂被限制登录
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "12|-1|0x576b95,40|1|0x576b95,-7|-313|0x1a1a1a,3|-300|0x1a1a1a,20|-303|0x1a1a1a,36|-311|0x1a1a1a,35|-293|0x1a1a1a,-4|-136|0x1a1a1a,9|-137|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("微信账号因使用外挂被限制登录1",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-2|0x576b95,39|0|0x576b95,-7|-353|0x1a1a1a,3|-340|0x1a1a1a,21|-344|0x1a1a1a,35|-349|0x1a1a1a,36|-334|0x1a1a1a,-92|-142|0x1a1a1a,-33|-144|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("微信账号因使用外挂被限制登录2",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --恶意营销
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "28|3|0x576b95,-47|-286|0x1a1a1a,-21|-286|0x1a1a1a,-22|-272|0x1a1a1a,-33|-258|0x1c1c1c,-39|-264|0x1a1a1a,-195|-155|0x1a1a1a,-195|-146|0x1a1a1a,-179|-147|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("恶意营销1",1)
			mSleep(500)
			t1 = ts.ms()
		end

		--恶意营销
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,44|-2|0x576b95,-184|-151|0x1a1a1a,-165|-155|0x1a1a1a,-165|-150|0x1a1a1a,-173|-140|0x1a1a1a,-143|-148|0x1a1a1a,-131|-149|0x1a1a1a,-124|-148|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("恶意营销2",1)
			mSleep(500)
			t1 = ts.ms()
		end
		
		--外挂封号
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "17|-2|0x576b95,46|-2|0x576b95,-388|-303|0x1a1a1a,-356|-300|0x1a1a1a,-320|-303|0x1a1a1a,-32|-145|0x1a1a1a,3|-139|0x1a1a1a,22|-152|0x1a1a1a,22|-144|0x1a1a1a", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("外挂封号1",1)
			mSleep(500)
			t1 = ts.ms()
		end
		
		--外挂封号
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-1|0x576b95,45|1|0x576b95,-1|-359|0x1a1a1a,9|-342|0x1a1a1a,26|-352|0x1a1a1a,41|-355|0x1a1a1a,42|-340|0x1a1a1a,-86|-141|0x1a1a1a,-27|-148|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("外挂封号2",1)
			mSleep(500)
			t1 = ts.ms()
		end
  
        --涉嫌传播骚扰
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,40|0|0x576b95,-192|-269|0x1a1a1a,-175|-283|0x1a1a1a,-174|-278|0x1a1a1a,-175|-271|0x1a1a1a,-157|-272|0x1a1a1a,-143|-279|0x1a1a1a,-143|-266|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("涉嫌传播骚扰1",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --涉嫌传播骚扰
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-3|0x576b95,39|1|0x576b95,-194|-226|0x1a1a1a,-185|-244|0x1a1a1a,-172|-239|0x1a1a1a,-176|-231|0x1a1a1a,-159|-232|0x1a1a1a,-143|-239|0x1a1a1a,-144|-223|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("涉嫌传播骚扰2",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --解封环境异常
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|3|0x576b95,39|-1|0x576b95,-173|-310|0x1a1a1a,-158|-302|0x1a1a1a,-138|-320|0x1a1a1a,-138|-304|0x1a1a1a,-120|-308|0x1a1a1a,-90|-304|0x1a1a1a,-57|-309|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("解封环境异常",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --参与赌博
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "10|2|0x576b95,39|0|0x576b95,17|-230|0x1a1a1a,26|-231|0x1a1a1a,35|-233|0x1a1a1a,38|-220|0x1a1a1a,54|-227|0x1a1a1a,69|-234|0x1a1a1a,69|-220|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("参与赌博1",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --参与赌博
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,39|-1|0x576b95,17|-270|0x1a1a1a,27|-275|0x1a1a1a,36|-276|0x1a1a1a,38|-261|0x1a1a1a,55|-269|0x1a1a1a,70|-270|0x1a1a1a,69|-262|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("参与赌博2",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --被投诉组织或参与网络赌博
	    mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "18|0|0x576b95,46|-4|0x576b95,-392|-230|0x1a1a1a,-382|-229|0x1a1a1a,-374|-239|0x1a1a1a,-371|-223|0x1a1a1a,-355|-231|0x1a1a1a,-340|-236|0x1a1a1a,-341|-224|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("被投诉组织或参与网络赌博",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        -- 多人投诉
        mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|0|0x576b95,45|1|0x576b95,-77|-229|0x1a1a1a,-62|-228|0x1a1a1a,-62|-241|0x1a1a1a,-41|-227|0x1a1a1a,-20|-234|0x1a1a1a,28|-149|0x1a1a1a,88|-147|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("多人投诉",1)
			mSleep(500)
			t1 = ts.ms()
		end
		
		--被投诉限制登录
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "18|1|0x576b95,45|-2|0x576b95,-323|-183|0x1a1a1a,-310|-188|0x1a1a1a,-305|-184|0x1a1a1a,-279|-184|0x1a1a1a,-355|-261|0x1a1a1a,-319|-262|0x1a1a1a,-82|-138|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("被投诉限制登录",1)
			mSleep(500)
			t1 = ts.ms()
		end
		
		-- 被投诉并确有违规
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "11|2|0x576b95,39|0|0x576b95,55|-223|0x1a1a1a,64|-238|0x1a1a1a,70|-232|0x1a1a1a,72|-227|0x1a1a1a,69|-222|0x1a1a1a,92|-231|0x1a1a1a,112|-229|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("被投诉并确有违规",1)
			mSleep(500)
			t1 = ts.ms()
		end
	    
	    --提取账号内财产
	    mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x04be02, "4|32|0x04be02,481|-8|0x04be02,472|30|0x04be02,460|-113|0x04be02,453|-68|0x04be02,25|-114|0x04be02,23|-76|0x04be02,136|-251|0x0d7aff", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 200, y + 40)
			mSleep(math.random(500, 700))
			toast("提取账号内财产",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --账号存在异常
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "11|0|0x576b95,39|0|0x576b95,-73|-274|0x1a1a1a,-72|-263|0x1a1a1a,-72|-256|0x1a1a1a,-51|-268|0x1a1a1a,-25|-266|0x1a1a1a,-38|-251|0x1a1a1a,83|-140|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("账号存在异常1",1)
			mSleep(500)
			t1 = ts.ms()
        end
	    
	    --账号存在异常
        mSleep(math.random(200, 300))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "11|-1|0x576b95,39|-2|0x576b95,-74|-322|0x1a1a1a,-73|-311|0x1a1a1a,-67|-299|0x1a1a1a,-52|-315|0x1a1a1a,-26|-315|0x1a1a1a,-39|-298|0x1a1a1a,-104|-144|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("账号存在异常2",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --投诉涉嫌诈骗行为
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "12|2|0x576b95,39|0|0x576b95,91|-264|0x1a1a1a,111|-278|0x1a1a1a,111|-270|0x1a1a1a,111|-263|0x1a1a1a,-118|-144|0x1a1a1a,-105|-146|0x1a1a1a,-97|-150|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("投诉涉嫌诈骗行为",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --涉嫌传播非法营销
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "17|-3|0x576b95,44|-2|0x576b95,-37|-275|0x1a1a1a,-27|-273|0x1a1a1a,-16|-274|0x1a1a1a,-26|-260|0x1a1a1a,-2|-270|0x1a1a1a,13|-280|0x1a1a1a,14|-265|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("涉嫌传播非法营销",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --打招呼存在异常
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x576b95, "12|0|0x576b95,39|0|0x576b95,57|-308|0x1a1a1a,68|-321|0x1a1a1a,74|-309|0x1a1a1a,90|-309|0x1a1a1a,101|-322|0x1a1a1a,106|-307|0x1a1a1a,107|-295|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("打招呼存在异常",1)
			mSleep(500)
			t1 = ts.ms()
        end

        --返回操作
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x04be02, "140|-34|0x04be02,147|30|0x04be02,366|0|0x04be02,97|-368|0x10aeff,198|-372|0x10aeff,144|-356|0xefeff4,107|-178|0x000000,191|-182|0x000000,214|-189|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(276, 1286)
			mSleep(math.random(3500, 4700))
			for var=1, 5 do
			    mSleep(200)
                if getColor(309,626) == 0x5a5a5b then
                    mSleep(math.random(500, 700))
        			tap(276, 1286)
        			mSleep(math.random(500, 700))
        			break
                end
			end
			toast("返回操作",1)
			mSleep(500)
			t1 = ts.ms()
        end
        
        --提取失败，需解封
        mSleep(math.random(200, 300))
        x,y = findMultiColorInRegionFuzzy(0x10aeff, "74|8|0x10aeff,-197|390|0x04be02,-197|438|0x04be02,30|385|0x04be02,49|445|0x04be02,348|390|0x04be02,110|181|0x000000,3|194|0x000000,87|189|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
        if x~=-1 and y~=-1 then
            mSleep(500)
            toast("提取失败，需解封",1)
            mSleep(1000)
        	category = "error-data"
        	data = self.infoData.."----资金安全"
        	break
        end
        
        timeOut = self:timeOutRestart(t1)
        if timeOut then
            mSleep(math.random(500, 700))
			tap(57, 85)
			mSleep(math.random(500, 700))
			self:vpn()
			mSleep(500)
            goto login
        end
	end
	
	::pushData::
	local plugin_ok,api_ok,data = ts_enterprise_lib:plugin_api_call("DataCenter","insert_data",category,data)
	if plugin_ok and api_ok or plugin_ok then
		toast("插入数据成功", 1)
		mSleep(1000)
	else
		toast("插入数据失败，重新插入:"..tostring(plugin_ok).."----"..tostring(api_ok), 1)
		mSleep(1000)
		goto pushData
	end
	::over::
end
	
function model:main()
	while true do
		self:getConfig()
		self:clear_App()
		self:clear_data(self.wc_bid)
		if vpn_status == "0" then
		    self:vpn()
		else
		    mSleep(100)
		    setVPNEnable(false)
		    mSleep(100)
		end
		self:loginAccount()
		toast('一个流程结束，进行下一个',1)
	end
end

model:main()


