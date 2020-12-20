--陌陌-qq号码注册
require "TSLib"
local ts = require("ts")
local json = ts.json
local sz = require("sz") --登陆
local http = require("szocket.http")

local model = {}

model.awz_bid = "com.superdev.AMG"
model.mm_bid = "com.wemomo.momoappdemo1"

model.qqAcount = ""
model.qqPassword = ""

model.mm_accountId = ""
model.subName = ""

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

--检查AMG是否在前台
function model:Check_AMG()
	if isFrontApp(self.awz_bid) == 0 then
		runApp(self.awz_bid)
		mSleep(3000)
	end
end

--检查执行结果
function model:Check_AMG_Result()
	::get_amg_result::
	mSleep(3000) --根据所选应用数量和备份文件大小来增加等待时间，如果有开智能飞行模式，建议时间在15秒以上，当然，运行脚本时不建议开智能飞行，直接用脚本判断IP更准确
	local result_file = "/var/mobile/amgResult.txt"
	if isFileExist(result_file) then
		local amg_result = readFileString(result_file)
		if amg_result == "0" then
			return false
		elseif amg_result == "1" then
			return true
		elseif amg_result == "2" then
			toast("执行中", 1)
			goto get_amg_result
		end
	end
end

local AMG = {
	New = (function()
			--一键新机
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=newRecord")
			if code == 200 then
				return model:Check_AMG_Result()
			end
		end),
	Get_Name = (function()
			--获取当前记录名称
			model:Check_AMG()
			local res, code = http.request("http://127.0.0.1:8080/cmd?fun=getCurrentRecordName")
			if code == 200 then
				if model:Check_AMG_Result() == true then
					return res
				end
			end
		end),
	Rename = (function(old_name, new_name) --重命名
			model:Check_AMG()
			local res, code =
			http.request("http://127.0.0.1:8080/cmd?fun=setRecordName&oldName=" .. old_name .. "&newName=" .. new_name)
			if code == 200 then
				return model:Check_AMG_Result()
			end
		end)
}

--[[随机内容(UTF-8中文字符占3个字符)]]
function model:Rnd_Word(strs, i, Length)
	local ret = ""
	local z
	if Length == nil then
		Length = 1
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) + State["随机常量"])
	math.random(string.len(strs) / Length)
	for i = 1, i do
		z = math.random(string.len(strs) / Length)
		ret = ret .. string.sub(strs, (z * Length) - (Length - 1), (z * Length))
	end
	return ret
end

--遍历文件
function model:getList(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		table.insert(f, l)
	end
	a:close()
	return f
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动", 1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 33, 503, 712, 892)
	mSleep(500)
	ts.img.binaryzationImg(userPath() .. "/res/test_3.jpg", mns)
	mSleep(500)
	if self:file_exists(userPath() .. "/res/tmp.jpg") then
		toast("正在计算", 1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath() .. "/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333)
		mSleep(math.random(500, 1000))
		if type(point) == "table" and #point ~= 0 then
			mSleep(500)
			x_len = point[1].x
			toast(x_len, 1)
			return x_len
		else
			x_len = 0
			return x_len
		end
	else
		dialog("文件不存在", 1)
		mSleep(math.random(1000, 1500))
	end
end

function model:renameRecord(updateResultName)
	::runAgain1::
	runApp(self.awz_bid)
	mSleep(3 * 1000)
	while true do
		mSleep(500)
		if getColor(596, 443) == 0x6f7179 then
			local sz = require("sz")
			local http = require("szocket.http")
			local res, code = http.request(self.renameRecordUrl .. updateResultName)
			if code == 200 then
				local resJson = sz.json.decode(res)
				local result = resJson.result
				if result == 1 then
					toast("修改成功", 1)
					mSleep(1000)
				end
			end
			break
		end

		flag = isFrontApp(self.awz_bid)
		if flag == 0 then
			closeApp(self.awz_bid)
			mSleep(3000)
			goto runAgain1
		end
	end
end

function model:timeOutRestart(t1)
	t2 = ts.ms()

	if os.difftime(t2, t1) > 120 then
		lua_restart()
	end
end

function model:newMMApp()
	while true do
		mSleep(500)
		--一键新机
		if AMG.New() == true then
			while true do
				if getColor(266, 601) == 0xffffff then
					toast("newApp成功", 1)
					break
				end
			end
			break
		end
	end
end

function model:vpn()
	::get_vpn::
	old_data = getNetIP() --获取IP
	toast(old_data, 1)

	mSleep(math.random(500, 1500))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态", 1)
		setVPNEnable(false)
		setVPNEnable(false)
		for var = 1, 10 do
			mSleep(math.random(200, 500))
			toast("等待vpn切换" .. var, 1)
			mSleep(math.random(200, 500))
		end
		goto get_vpn
	else
		toast("关闭状态", 1)
	end

	t1 = ts.ms()
	setVPNEnable(true)
	mSleep(1000 * math.random(2, 4))

	while true do
		new_data = getNetIP() --获取IP
		toast(new_data, 1)
		if new_data ~= old_data then
			mSleep(1000)
			toast("vpn链接成功")
			mSleep(1000)
			break
		end

		t2 = ts.ms()

		if os.difftime(t2, t1) > 10 then
			setVPNEnable(false)
			setVPNEnable(false)
			setVPNEnable(false)
			mSleep(2000)
			toast("ip地址一样，重新打开", 1)
			mSleep(2000)
			goto get_vpn
		end
	end
end

function model:getMMId(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		b = string.find(l, "u.(%d%d%d%d%d%d%d%d%d)_main.sqlite")
		if type(b) ~= "nil" then
			c = string.match(l, "%d%d%d%d%d%d%d%d%d")
			toast("陌陌id:" .. c, 1)
			mSleep(1000)
			return c
		end
	end
end

function model:downImage()
	--	list = self:getList(userPath().."/res/*.png")
	list = self:getList(userPath() .. "/res/picFile")

	if #list > 0 then
		return list[math.random(1, #list)]
	else
		dialog("文件夹路径没有照片了", 0)
		lua_exit()
	end
end

function model:deleteImage(path)
	::delete::
	bool = delFile(path)
	if bool then
		toast("删除成功", 1)
	else
		toast("删除失败", 1)
		mSleep(1000)
		goto delete
	end
end

function model:mm(password, sex, searchFriend, searchAccount, changeHeader)
	runApp(self.mm_bid)
	mSleep(1000)
	t1 = ts.ms()

	runAgain = false
	while true do
		--同意
		mSleep(math.random(200, 300))
		if getColor(298, 941) == 0x3bb3fa and getColor(520, 941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376, 944, 4)
			mSleep(500)
		end

		--允许
		mSleep(math.random(200, 300))
		if getColor(533, 770) == 0x7aff and getColor(495, 771) == 0x7aff then
			mSleep(500)
			randomTap(495, 771, 4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
		if x ~= -1 and y ~= -1 then
			if runAgain then
				mSleep(math.random(500, 700))
				randomTap(x - 160, y, 4)
				mSleep(math.random(500, 700))
				toast("手机号登录注册", 1)
				mSleep(1000)
				closeApp(self.mm_bid)
				mSleep(2000)
				break
			else
				mSleep(1000)
				closeApp(self.mm_bid)
				mSleep(2000)
				runAgain = true
			end
		end
		
		--注册登录
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录",1)
			mSleep(500)
		end

		--qq图标
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(1000)
			closeApp(self.mm_bid)
			mSleep(2000)
			break
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while true do
		--注册登录
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy( 0xffffff, "105|1|0xffffff,211|3|0x18d9f1,95|-37|0x18d9f1,-48|-4|0x18d9f1,83|39|0x18d9f1", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("注册登录",1)
			mSleep(500)
		end
		
		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
		end
		
		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
		end

		--同意
		mSleep(math.random(200, 300))
		if getColor(298, 941) == 0x3bb3fa and getColor(520, 941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376, 944, 4)
			mSleep(500)
		end

		--允许
		mSleep(math.random(200, 300))
		if getColor(533, 770) == 0x7aff and getColor(495, 771) == 0x7aff then
			mSleep(500)
			randomTap(495, 771, 4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0",100,0,940,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x - 160, y, 4)
			mSleep(math.random(500, 700))
		end

		--qq图标
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff",100,0,1040,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y, 4)
			mSleep(math.random(3500, 5000))
			break
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end
		
		self:timeOutRestart(t1)
	end
	
	huakuai = false
	inputAgain = false
	::hk::
	
	t1 = ts.ms()
	while (true) do
		mSleep(math.random(200, 300))
		if getColor(239, 629) == 0x12b7f5 then
		    if inputAgain then
		        mSleep(500)
		        randomTap(620,  357, 3)
		        mSleep(1000)
		        for var=1,20 do
                    mSleep(100)
                    keyDown("DeleteOrBackspace")
                    keyUp("DeleteOrBackspace")  
		        end
                mSleep(500)
		        randomTap(620,  469, 3)
		        mSleep(1000)
		        for var=1,20 do
                    mSleep(100)
                    keyDown("DeleteOrBackspace")
                    keyUp("DeleteOrBackspace")  
                end
		    end
		    
			mSleep(5000)
			while (true) do
				mSleep(200)
				if getColor(676,  357) == 0xbbbbbb or getColor(599,354) == 0xffffff then
					mSleep(500)
					randomTap(447, 477, 4)
					mSleep(500)
					break
				else
				    mSleep(500)
					randomTap(395, 357, 4)
					mSleep(2000)
					inputStr(self.qqAcount)
					mSleep(1000)
				end
			end

			while (true) do
				mSleep(200)
				if getColor(677,  469) == 0xbbbbbb or getColor(163,471) == 0x000000 then
				    mSleep(500)
        			randomTap(239, 629, 4)
        			mSleep(500)
        			table.remove(tab, 1)
        			writeFile(userPath() .. "/res/qq.txt", tab, "w", 1)
					break
				else
					mSleep(500)
					randomTap(447, 477, 4)
					mSleep(500)
					inputStr(self.qqPassword)
					mSleep(1000)
				end
			end
		end
		
		mSleep(200)
		if getColor(391,541) == 0x12b7f5 and getColor(379,884) == 0x000000 then
		    mSleep(500)
		    randomTap(379,884,4)
		    mSleep(500)
		    inputAgain = true
		end

		mSleep(math.random(200, 300))
		if getColor(116, 949) == 0x007aff then
			if huakuai then
				x_lens = self:moves()
				if tonumber(x_lens) > 0 then
					mSleep(math.random(500, 700))
					moveTowards(116, 949, 10, x_len - 65)
					mSleep(3000)
					randomTap(370, 1024, 4)
					mSleep(2000)
				else
					mSleep(math.random(500, 1000))
					randomTap(603, 1032, 10)
					mSleep(math.random(3000, 6000))
				end
				break
			else
				mSleep(math.random(500, 1000))
				randomTap(603, 1032, 10)
				mSleep(math.random(3000, 6000))
				huakuai = true
				goto hk
			end
		end

		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		self:timeOutRestart(t1)
	end

	State = {
		["随机常量"] = 0,
		["姓氏"] = "赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
		"姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍" ..
		"史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾" ..
		"孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈" ..
		"项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡" ..
		"田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸" ..
		"左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄曲家封芮羿储靳汲邴糜松井" ..
		"段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎" ..
		"祖武符刘景詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲邰从鄂索咸籍赖卓蔺屠" ..
		"蒙池乔阴鬱胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛" ..
		"寿通边扈燕冀郟浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈" ..
		"廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂" ..
		"晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权" ..
		"逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台" ..
		"公冶宗政濮阳淳于单于太叔申屠公孙仲孙轩辕令狐钟离宇文长孙慕容鲜" ..
		"于闾丘司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良" ..
		"拓拔夹谷宰父谷粱晋楚闫法汝鄢涂钦段干百里东郭南门呼延归海羊舌微" ..
		"生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱" ..
		"阳佟第五言福百家姓终",
		["名字"] = "安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
		"濮存罡禄瑛瑛嗣嫚朵寅添渟黎臻舞绢城骥彰渺禾教祖剑黎莞咸浓芦澹帅臻渟添禾亭添亭霖深策臻稷辞" ..
		"悟悟澄涉城鸥黎悟乔恒黎鲲涉莞霖甲深婕乔程澹男岳深涉益澹悟箫乔多职适芦瑛澄婕朵适祖霖瑛坤嫚" ..
		"涉男珂箫芦黎珹绢芦程识嗣珂瑰枝允黎庸嗣赐罡纵添禄霖男延甲彰咸稷箫岳悟职祖恒珂庸琅男莞庸浓" ..
		"多罡延瑛濮存爵添剑益骥澄延迪寅婕程霖识瑰识程群教朵悟舞岳浓箫城适程禾嫚罡咸职铃爵渺添辞嫚" ..
		"浓寅鲲嗣瑛鸥多教瑛迪坤铃珹群黎益澄程莞深坤澹禄职澹赩澄藉群箫骥定彰寅臻渟枝允珹深群黎甲鲲" ..
		"亭黎藏浓涤渟莞寅辞嗣坤迪嫚添策庸策藉瑰彰箫益莞渺乔彰延舞祖婕澹渺鸥纵嗣瑛藏濮存婕职程芦群" ..
		"禾嫚程辞祖黎职浓桦藏渟禾彰帅辞铃铃黎允绢濮存剑辞禾瑰添延添悟赐祖咸莞男绢策婕藉禾浓珹涤祖" ..
		"汉骥舞瑛多稷赐莞渟黎舞桦黎群藏渺黎坤桦咸迪澈舞允稷咸剑定亭澄濮存鲲臻全鸥多赐程添瑛亭帅悟" ..
		"甲男帅涤适纵渟鲲亭悟琅亭添允舞禾庸咸瑛教鲲允箫芦允瑛咸鸥帅悟延珂黎珹箫爵剑霖剑霖禄鸥悟涉" ..
		"彰群悟辞帅渺莞澄桦瑛适臻益霖珹亭澹辞坤程嗣铃箫策澈枝赐莞爵渟禄群枝添芦群浓赐职益城澄赩琅" ..
		"延群乔珹鲲祖群悟黎定庸澄芦延霖罡鲲咸渺纵亭禄鸥赩涤剑澹藏纵濮存澄芦剑延瑰稷黎益赩澄允悟澈" ..
		"甲嗣绢朵益甲悟涤婕群咸臻箫鲲寅鸥桦益珂舞允庸芦藉寅渺咸赐澄程剑瑰霖瑰铃帅男铃悟识瑰仕仕城" ..
		"允莞全朵涤铃剑渺稷剑珂铃箫全仕益纵芦桦珂濮存城朵朵咸程剑澄定澈爵寅庸定莞瑛教彰黎箫仕黎桦" ..
		"赩深赩爵迪悟珹涤琅添箫桦帅瑛黎黎策识寅嫚涉迪策汉舞定彰允男祖教澄群瑛濮存男禾教莞禾鸥澈濮" ..
		"存岳城嫚深舞教岳澄亭禾坤朵亭职莞稷寅瑰城庸亭舞禾瑛恒坤浓彰莞澄澈鸥臻稷教琅辞益剑藉黎添瑛" ..
		"延舞坤仕岳多婕骥迪帅黎悟全澄识益甲桦纵适罡彰澄禾婕程黎城涤浓枝箫咸渟岳渟澹臻珹识珹澄箫辞" ..
		"浓鲲识悟允悟禾识群祖迪渟鲲群庸莞珹悟澹瑰悟鸥汉群甲莞庸职琅莞桦鲲朵深乔辞允彰渺朵瑰亭瑰朵" ..
		"定深男识群职霖益男舞城允舞爵赩枝罡罡群澹芦藉爵悟渟澹禾多庸箫坤乔芦甲濮存多渟藉珹赐汉纵亭" ..
		"禾城枝剑露以玉春飞慧娜悠亦元晔曜霜宁桃彦仪雨琴青筠逸曼代菀孤昆秋蕊语莺丝红羲盛静南淑震晴" ..
		"彭祯山霞凝柔隽松翠高骊雅念皓双洛紫瑞英思歆蓉娟波芸荷笑云若宏夏妍嘉彩如鹏寄芝柳凌莹蝶舒恬" ..
		"虹清爽月巧乾勋翰芳罗刚鸿运枫阳葳杰怀悦凡哲瑶凯然尚丹奇弘顺依雪菡君畅白振馨寻涵问洁辉忆傲" ..
		"伟经润志华兰芹修晨木宛俊博韶天锐溪燕家沈放明光千永溶昊梅巍真尔馥莲怜惜佳广香宇槐珺芷帆秀" ..
		"理柏书沛琪仙之竹向卉欣旻晓冬幻和雁淳浩歌荣懿文幼岚昕牧绿轩工旭颜醉玑卓觅叶夜灵胜晗恨流佁" ..
		"乐火音采睿翎萱民画梦寒泽怡丽心石邵玮佑旺壮名一学谷韵宜冰赫新蕾美晖项琳平树又炳骏气海毅敬" ..
		"曦婉爰伯珊影鲸容晶婷林子昌梧芙澍诗星冉初映善越原茂国腾孟水烟半峯莉绮德慈敏才戈梓景智盼霁" ..
		"琇苗熙姝从谊风发钰玛忍婀菲昶可荌小倩妙涛姗方图迎惠晤宣康娅玟奕锦濯穆禧伶丰良祺珍曲喆扬拔" ..
		"驰绣烁叡长雯颖辰慕承远彬斯薇成聪爱朋萦田致世实愫进瀚朝强铭煦朗精艺熹建忻晏冷佩东古坚滨菱" ..
		"囡银咏正儿瑜宝蔓端蓓芬碧人开珠昂琬洋璠桐舟姣琛亮煊信今年庄淼沙黛烨楠桂斐胤骄兴尘河晋卿易" ..
		"愉蕴雄访湛蓝媛骞娴儒妮旋友娇泰基礼芮羽妞意翔岑苑暖玥尧璇阔燎偲靖行瑾资漪晟冠同齐复吉豆唱" ..
		"韫素盈密富其翮熠绍澎淡韦诚滢知鹍苒抒艳义婧闳琦壤杨芃洲阵璟茵驹涆来捷嫒圣吟恺璞西旎俨颂灿" ..
		"情玄利痴蕙力潍听磊宸笛中好任轶玲螺郁畴会暄峻略琼琰默池温炫季雰司杉觉维饮湉许宵茉贤昱蕤珑" ..
		"锋纬渊超萍嫔大霏楚通邈飙霓谧令厚本邃合宾沉昭峰业豪达彗纳飒壁施欢姮甫湘漾闲恩莎祥启煜鸣品" ..
		"希融野化钊仲蔚生攸能衍菁迈望起微鹤荫靓娥泓金琨筱赞典勇斌媚寿喜飇濡宕茜魁立裕弼翼央莘绚焱" ..
		"奥萝米衣森荃航璧为跃蒙庆琲倚穹武甜璐俏茹悌格穰皛璎龙材湃农福旷童亘苇范寰瓃忠虎颐蓄霈言禹" ..
		"章花健炎籁暮升葛贞侠专懋澜量纶布皎源耀鸾慨曾优栋妃游乃用路余珉藻耘军芊日赡勃卫载时三闵姿" ..
		"麦瑗泉郎怿惬萌照夫鑫樱琭钧掣芫侬丁育浦磬献苓翱雍婵阑女北未陶干自作伦珧溥桀州荏举杏茗洽焕" ..
		"吹甘硕赋漠颀妤诺展俐朔菊秉苍津空洮济尹周江荡简莱榆贝萧艾仁漫锟谨魄蔼豫纯翊堂嫣誉邦果暎珏" ..
		"临勤墨薄颉棠羡浚兆环铄"
	}

	State["随机常量"] = tonumber(self:Rnd_Word("0123456789", 5))

	Nickname = self:Rnd_Word(State["姓氏"], 1, 3) .. self:Rnd_Word(State["名字"], 1, 3)

	t1 = ts.ms()
	while true do
	    mSleep(math.random(200, 300))
		if getColor(116, 949) == 0x007aff then
		    mSleep(math.random(500, 1000))
			randomTap(603, 1032, 10)
			mSleep(math.random(3000, 6000))
		    goto hk
		end
		
		mSleep(200)
		if getColor(149,  187) == 0x323233 or getColor(149,187) == 0x323333 then
	   	    mSleep(500)
			key = "ReturnOrEnter"
			keyDown(key)
			keyUp(key)
			toast("收起键盘",1)
			mSleep(500)
		end
	    
		--填写资料
		mSleep(500)
		x, y = findMultiColorInRegionFuzzy(0x323333,"16|-1|0x323333,8|7|0x323333,10|19|0x323333,24|26|0x323333,30|13|0x323333,25|-7|0x323333,54|-3|0x323333,83|8|0x323333,66|-8|0x323333",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			tap(x + 70, y + 121)
			mSleep(1000)
			for var = 1, 20 do
				mSleep(100)
				keyDown("DeleteOrBackspace")
				keyUp("DeleteOrBackspace")
			end
			mSleep(500)
			inputStr(Nickname)
			mSleep(1000)
			toast("输入昵称", 1)
			mSleep(500)
			break
		end

		mSleep(200)
		if getColor(239, 629) == 0x12b7f5 or getColor(676, 258) == 0x808080 then
			toast("切换下一个账号", 1)
			mSleep(500)
			goto over
		end

		--已经注册过，需要绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			toast("已经注册过，需要绑定手机号码", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end
		
		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
			self.subName = "注册过"
			goto get_mmId
		end
        
		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while true do
		mSleep(400)
		x, y = findMultiColorInRegionFuzzy(0x323333,"17|0|0x323333,9|8|0x323333,0|17|0x323333,17|17|0x323333,2|6|0xffffff,18|7|0xffffff,10|17|0xffffff,9|-1|0xffffff",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y + 110, 4)
			mSleep(math.random(500, 700))
			toast("生日", 1)
			mSleep(1000)
			break
		else
			mSleep(500)
			randomTap(x - 200, y, 4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
		end

		self:timeOutRestart(t1)
	end

	--上下
	topBottom = math.random(1, 2)
	--年份
	year = math.random(1, 5)
	--月份
	month = math.random(1, 6)
	--日期
	day = math.random(1, 15)

	t1 = ts.ms()
	while true do
		--生日
		mSleep(400)
		if getColor(38, 873) == 0x848484 and getColor(57, 1012) == 0xffffff then
			mSleep(500)
			if topBottom == 1 then
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, 1100, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, 1100, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, 1100, 4)
				end
			else
				mSleep(500)
				for i = 1, year do
					mSleep(500)
					randomTap(212, 1229, 4)
				end

				for i = 1, month do
					mSleep(500)
					randomTap(363, 1229, 4)
				end

				for i = 1, day do
					mSleep(500)
					randomTap(526, 1229, 4)
				end
			end

			while true do
				mSleep(400)
				if getColor(432, 732) == 0xffffff then
					if sex == "0" then
						mSleep(500)
						randomTap(190, 612, 4)
						mSleep(500)
					else
						mSleep(500)
						randomTap(550, 612, 4)
						mSleep(500)
					end
					break
				else
					mSleep(500)
					randomTap(431, 708, 4)
					mSleep(1000)
				end
			end
			break
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while true do
		--下一步
		mSleep(400)
		if getColor(470, 842) == 0x18d9f1 then
			mSleep(500)
			randomTap(470, 842, 4)
			mSleep(500)
			toast("下一步", 1)
			mSleep(1000)
			break
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while true do
		--首页
		mSleep(200)
		if getColor(206, 109) == 0x323333 and getColor(370, 99) == 0x323333 or
		getColor(45, 109) == 0x323333 and getColor(222, 95) == 0x323333 then
			mSleep(500)
			toast("首页1", 1)
			mSleep(500)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323333, "17|15|0x323333,25|-6|0x323333,35|8|0x323333,53|6|0x323333,77|9|0x323333,73|-3|0x323333,104|1|0x323333,135|8|0x323333,200|6|0xffffff", 100, 0, 0, 421,179, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页2", 1)
			mSleep(500)
			break
		end

		--首页
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x3ee1ec, "13|-3|0xfdfdfd,30|5|0x3ee1ec,-2|38|0x13cae2,10|38|0x13cae2,25|31|0x13cae2", 100, 0, 0, 750, 1150, { orient = 2 })
		if x ~= -1 then
			mSleep(500)
			toast("首页3", 1)
			mSleep(500)
			break
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x18d9f1,"121|-9|0x18d9f1,64|55|0x18d9f1,62|36|0xf6f6f6,-28|12|0xf6f6f6,164|-4|0xf6f6f6,58|328|0xd8d8d8",90,0,0,750,1334,{orient = 2})
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(675,   83, 4)
			mSleep(math.random(500, 700))
			toast("上传照片1", 1)
			mSleep(1000)
		end

		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8",90,0,0,749,1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(675,   83, 4)
			mSleep(math.random(500, 700))
			toast("上传照片2", 1)
			mSleep(1000)
		end

		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0xcdcdcd, "13|5|0xcdcdcd,17|5|0xcdcdcd,25|8|0xffffff,32|8|0xcdcdcd,46|8|0xcdcdcd,39|1|0xcdcdcd,-448|824|0x18d9f1,-86|815|0x18d9f1,-298|819|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x + 20, y + 10, 4)
			mSleep(math.random(500, 700))
			toast("上传照片3", 1)
			mSleep(1000)
		end
		
		--下一步
		mSleep(400)
		if getColor(113,839) == 0x18d9f1 or getColor(632,841) == 0x18d9f1 then
			mSleep(500)
			randomTap(470, 842, 4)
			mSleep(500)
		end

		--跳过
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x323333,"4|10|0x323333,13|4|0x323333,17|4|0x323333,32|7|0x323333,47|7|0x323333,42|-1|0x323333,59|5|0xffffff,-20|3|0xffffff,25|27|0xffffff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x + 20, y + 10, 4)
			mSleep(500)
			toast("跳过", 1)
			mSleep(500)
		end

		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end
		
		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			randomTap(x + 10, y + 5, 3)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end

		--有新版本
		mSleep(200)
		if getColor(265, 944) == 0x3bb3fa and getColor(491, 949) == 0x3bb3fa then
			mSleep(500)
			randomTap(377, 1042, 4)
			mSleep(500)
			toast("有新版本", 1)
			mSleep(500)
		end

		--绑定手机号码
		mSleep(200)
		if getColor(672, 85) == 0x323333 and getColor(702, 85) == 0x323333 then
			mSleep(500)
			randomTap(672, 85, 4)
			mSleep(500)
			toast("绑定手机号码", 1)
			mSleep(500)
		end

		--跳过屏蔽通讯录
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"20|4|0x007aff,15|3|0x007aff,36|5|0x007aff,38|9|0x007aff,56|6|0x007aff,284|14|0x007aff,304|13|0x007aff,317|12|0x007aff,328|5|0x007aff",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("跳过屏蔽通讯录", 1)
			mSleep(500)
		end

		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end
		
		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
		end

		self:timeOutRestart(t1)
	end

	time = 0
	while (true) do
		--更多
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x + 10, y - 10, 4)
			mSleep(1000)
			randomTap(x + 10, y - 10, 4)
			mSleep(500)
			toast("更多",1)
			mSleep(500)
			break
		end
		
		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("绑定手机", 1)
			mSleep(500)
		end
		
		--绑定手机
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			randomTap(x + 10, y + 5, 3)
			mSleep(500)
			toast("绑定手机2", 1)
			mSleep(500)
		end
		
		--定位服务未开启
		mSleep(200)
		x, y = findMultiColorInRegionFuzzy(0x007aff,"11|1|0x007aff,41|2|0x007aff,40|-188|0x000000,66|-188|0x000000,54|-177|0x000000,79|-177|0x000000,119|-181|0x000000,192|-180|0x000000,260|-185|0x000000",90,0,0,750,1334,{orient = 2})
		if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启", 1)
			mSleep(500)
		end
		
		--定位服务未开启
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x087dff, "11|1|0x087dff,41|0|0x087dff,248|-6|0x087dff,276|-7|0x087dff,336|1|0x087dff,41|-190|0x010101,66|-189|0x010101,62|-177|0x010101,64|-168|0x010101", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("定位服务未开启2", 1)
			mSleep(500)
		end
	end

	if searchFriend == "0" then
		t1 = ts.ms()
		while true do
		    --绑定手机
    		mSleep(200)
    		x,y = findMultiColorInRegionFuzzy( 0x303031, "-11|-11|0x303031,12|-11|0x303031,-11|13|0x303031,12|12|0x303031,-1|11|0xffffff,-389|571|0x4ebbfb,-72|572|0x4ebbfb", 90, 0, 0, 749, 1333)
    		if x ~= -1 then
    			mSleep(500)
    			randomTap(x, y, 4)
    			mSleep(500)
    			toast("绑定手机", 1)
    			mSleep(500)
    		end
    		
    	    --绑定手机
    		mSleep(200)
    		x,y = findMultiColorInRegionFuzzy(0x323232, "13|6|0x323232,17|10|0x323232,32|8|0x323232,47|8|0x323232,-355|93|0x323232,-344|94|0x323232,-305|99|0x323232,-255|101|0x323232,-233|96|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
            if x ~= -1 then
    			mSleep(500)
    			randomTap(x + 10, y + 5, 3)
    			mSleep(500)
    			toast("绑定手机2", 1)
    			mSleep(500)
    		end
    		
    		--更多
    		mSleep(200)
    		x,y = findMultiColorInRegionFuzzy( 0x323333, "6|0|0x323333,12|0|0x323333,-3|-26|0x565656,37|-26|0x565656,54|-20|0xfdfcfd,-32|-20|0xfdfcfd", 100, 0, 0, 749, 1333)
    		if x~=-1 and y~=-1 then
    			mSleep(500)
    			randomTap(x + 10, y - 10, 4)
    			mSleep(1000)
    		end
		
			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("好友",1)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(420,  284) == 0xf3f3f3 then
				mSleep(500)
				randomTap(420,  284, 4)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(500)
			end

			--输入好友账号
			mSleep(200)
			if getColor(470,  334) == 0xf3f3f3 then
				mSleep(500)
				randomTap(470,  334, 4)
				mSleep(1000)
				inputStr(searchAccount)
				mSleep(1000)
			end

			--搜索用户
			mSleep(200)
			if getColor(55,  184) == 0xffaf1a and getColor(108,  179) == 0x000000 then
				mSleep(500)
				randomTap(108,  179, 4)
				mSleep(500)
				toast("搜索",1)
				mSleep(500)
			end

			--返回到更多页面
			mSleep(200)
			if getColor(678,   83) == 0xffffff or getColor(678,  131) == 0xffffff then
				if getColor(678,   83) == 0xffffff then
					mSleep(2000)
					randomTap(55,   82, 4)
					mSleep(500)
				elseif getColor(678,  131) == 0xffffff then
					mSleep(2000)
					randomTap(55,   128, 4)
					mSleep(500)
				end

				while (true) do
					mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						randomTap(678,   83, 4)
						mSleep(500)
					end

					--好友
					mSleep(200)
					x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
					if x~=-1 and y~=-1 then
						break
					else
						mSleep(200)
						if getColor(420,  284) == 0xf3f3f3 then
							mSleep(500)
							randomTap(55,   82, 4)
							mSleep(500)
						elseif getColor(470,  334) == 0xf3f3f3 then
							mSleep(500)
							randomTap(55,   132, 4)
							mSleep(500)
						end
					end
				end
				break
			end
			self:timeOutRestart(t1)
		end
	end

	if changeHeader == "0" then
		t1 = ts.ms()
		while true do
			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "30|-11|0xaaaaaa,68|-15|0xaaaaaa,62|-4|0xaaaaaa,69|0|0xaaaaaa,52|0|0xaaaaaa,84|-3|0xaaaaaa,101|-3|0xaaaaaa,17|-7|0xffffff,-82|-5|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("个人资料",1)
				mSleep(500)
			end

			--下次再说
			mSleep(200)
			if getColor(255, 1031) == 0x3bb3fa and getColor(557, 1020) == 0x3bb3fa then
				mSleep(500)
				randomTap(370, 1131, 4)
				mSleep(500)
				toast("下次再说",1)
				mSleep(500)
			end

			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x, y, 4)
				mSleep(500)
				toast("编辑",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		while true do
			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 180,y,4)
				mSleep(500)
			end

			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y + 120,4)
				mSleep(500)
				toast("相册",1)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				mSleep(500)
				randomTap(370,  298,4)
				mSleep(500)
			end

			--继续
			mSleep(200)
			if getColor(663,   86) == 0x3bb3fa and getColor(701,   88) == 0x3bb3fa then
				mSleep(500)
				randomTap(663,   86,4)
				mSleep(500)
				toast("继续",1)
				mSleep(500)
			end

			--完成
			mSleep(200)
			if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("完成",1)
				mSleep(500)
			end

			--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("保存",1)
				mSleep(500)
			end

			--好的
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x3bb3fa, "116|-1|0xffffff,39|-230|0x323333,54|-229|0x323333,56|-249|0x323333,92|-232|0x323333,123|-245|0x323333,168|-244|0x323333,218|-244|0xffffff,174|-234|0x323333", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("好的",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
		end

		t1 = ts.ms()
		while true do
			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(55,   87, 4)
				mSleep(500)
			end

			--好友
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xb0b0b0, "2|12|0xaaaaaa,23|2|0xaaaaaa,24|7|0xafafaf,83|3|0xffffff,205|8|0xaaaaaa,360|12|0xaaaaaa,556|7|0xaaaaaa,589|-15|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				break
			end

			self:timeOutRestart(t1)
		end
	end

	t1 = ts.ms()
	while true do
		--更多
		mSleep(200)
		if getColor(665, 1310) == 0xf6aa00 then
			mSleep(500)
			randomTap(693, 80, 4)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		mSleep(200)
		if getColor(664, 1253) == 0xf8aa05 or getColor(664, 1253) == 0xf6aa00 then
			mSleep(500)
			randomTap(696,  130, 4)
			mSleep(500)
			toast("进入设置",1)
			mSleep(500)
			break
		end

		self:timeOutRestart(t1)
	end

	t1 = ts.ms()
	while true do
		--设置
		mSleep(200)
		if getColor(342, 80) == 0 and getColor(386, 79) == 0 then
			mSleep(500)
			randomTap(577, 209, 4)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--设置
		mSleep(200)
		if getColor(342, 127) == 0 and getColor(386, 145) == 0 then
			mSleep(500)
			randomTap(577, 254, 4)
			mSleep(500)
			toast("设置",1)
			mSleep(500)
		end

		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x323333, "12|16|0x323333,2|16|0x323333,23|16|0x323333,35|17|0x323333,40|13|0x323333,58|11|0x323333,68|11|0x323333,99|10|0x323333,128|10|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x, y, 4)
			mSleep(500)
			toast("密码修改",1)
			mSleep(500)
		end

		--重置密码
		mSleep(200)
		if getColor(642,   87) == 0x3bb3fa and getColor(689, 87) == 0x3bb3fa then
			mSleep(500)
			randomTap(396, 194, 4)
			mSleep(500)
			toast("重置密码",1)
			mSleep(500)
			while true do
				mSleep(400)
				if getColor(712, 193) == 0xcccccc then
					break
				else
					mSleep(500)
					inputStr(password)
					mSleep(1000)
				end

				self:timeOutRestart(t1)
			end

			mSleep(500)
			randomTap(396, 279, 4)
			mSleep(500)
			while true do
				mSleep(400)
				if getColor(712, 281) == 0xcccccc then
					break
				else
					mSleep(500)
					inputStr(password)
					mSleep(1000)
				end

				self:timeOutRestart(t1)
			end
			mSleep(500)
			randomTap(666, 81, 4)
			mSleep(5000)
			break
		end

		self:timeOutRestart(t1)
	end

	::get_mmId::
	self.mm_accountId = self:getMMId(appDataPath(self.mm_bid) .. "/Documents")

	--重命名当前记录名
	local old_name = AMG.Get_Name()
	local new_name = self.mm_accountId .. "----" .. self.subName
	if AMG.Rename(old_name, new_name) == true then
		toast("重命名当前记录 " .. old_name .. " 为 " .. new_name, 3)
	end

	::over::
end

function model:main()
	local w, h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 30,
		views = {
			{
				["type"] = "Label",
				["text"] = "陌陌脚本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "照片文件夹路径是在触动res下，文件夹名字是picFile",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "号码文件路径是在触动res下，文件名字是phoneNum.txt",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0"
			},
			{
				["type"] = "Label",
				["text"] = "设置密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入密码",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "性别选择",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "女生,男生",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "是否需要搜索好友",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "需要,不需要",
				["select"] = "0",
				["countperline"] = "4"
			},
			{
				["type"] = "Label",
				["text"] = "设置搜索好友用户名",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "Edit",
				["prompt"] = "输入搜索好友用户名",
				["text"] = "默认值"
			},
			{
				["type"] = "Label",
				["text"] = "是否需要换头像",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255"
			},
			{
				["type"] = "RadioGroup",
				["list"] = "换头像,不换头像",
				["select"] = "0",
				["countperline"] = "4"
			}
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, password, sex, searchFriend, searchAccount, changeHeader = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	if searchFriend == "0" then
		if searchAccount == "" or searchAccount == "默认值" then
			dialog("搜索好友用户名不能为空，请重新运行脚本设置搜索好友用户名", 3)
			luaExit()
		end
	end

	while true do
		tab = readFile(userPath() .. "/res/qq.txt")
		if tab then
			if #tab > 0 then
				data = strSplit(string.gsub(tab[1], "%s+", ""), "----")
				self.qqAcount = data[1]
				self.qqPassword = data[2]
			else
				dialog("没账号了", 0)
				lua_exit()
			end
		else
			dialog("文件不存在,请检查", 0)
			lua_exit()
		end

		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)
        
        changeHeader = "1"
		if changeHeader == "0" then
			clearAllPhotos()
			mSleep(500)
			clearAllPhotos()
			mSleep(500)
			fileName = self:downImage()
			toast(fileName, 1)
			mSleep(1000)
            
	--		saveImageToAlbum(fileName)
			saveImageToAlbum(userPath() .. "/res/picFile/" .. fileName)
			mSleep(500)
	--		saveImageToAlbum(fileName)
			saveImageToAlbum(userPath() .. "/res/picFile/" .. fileName)
			mSleep(2000)
            
	--		self:deleteImage(fileName)
			self:deleteImage(userPath() .. "/res/picFile/" .. fileName)
		end

		self:vpn()
		self:newMMApp()
		self:mm(password, sex, searchFriend, searchAccount, changeHeader)
	end
end

model:main()
-- model:mm(password, "0")
