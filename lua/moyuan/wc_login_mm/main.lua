--陌陌-wc注册
require "TSLib"
local ts = require("ts")
local json = ts.json
local sz = require("sz") --登陆
local http = require("szocket.http")

local model = {}

model.awz_bid = "com.superdev.AMG"
model.mm_bid = "com.wemomo.momoappdemo1"

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
	else
	    toast("距离重启脚本还有"..(120 - os.difftime(t2, t1)) .. "秒",1)
	    mSleep(1000)
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
				
				self:vpn_connection()
			end
			break
		end
	end
end

function model:vpn_connection()
    --vpn连接
	mSleep(200)
	x,y = findMultiColorInRegionFuzzy(0x1382ff, "-4|4|0x1382ff,5|10|0x1382ff,2|19|0x1382ff,12|-1|0x1382ff,17|8|0x1382ff,10|13|0x1382ff,24|13|0x1382ff,13|26|0x1382ff,17|19|0x1382ff", 90, 0, 0, 750, 1334, { orient = 2 })
    if x ~= -1 then
        mSleep(500)
        randomTap(x,y,4)
        mSleep(500)
        setVPNEnable(true)
        toast("好",1)
        mSleep(3000)
    end
end

function model:getIP()
    ::ip_addresss::
	status_resp, header_resp,body_resp = ts.httpGet("http://myip.ipip.net")
	toast(body_resp,1)
	if status_resp == 200 then--打开网站成功
	    local i,j = string.find(body_resp, "%d+%.%d+%.%d+%.%d+")
        local ipaddr =string.sub(body_resp,i,j)
		return ipaddr
	else
		toast("请求ip位置失败："..tostring(body_resp),1)
		mSleep(1000)
		goto ip_addresss
	end
end

function model:vpn()
	::get_vpn::
	old_data = self:getIP() --获取IP
	if old_data and old_data ~= "" then
        toast(old_data, 1)
    else
        goto get_vpn
    end

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
	    mSleep(1000)
		new_data = self:getIP() --获取IP
		if new_data and new_data ~= "" then
            toast(new_data, 1)
    		if new_data ~= old_data then
    			mSleep(1000)
    			toast("vpn链接成功")
    			mSleep(1000)
    			break
    		end
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
			mSleep(math.random(500, 700))
			randomTap(x - 160, y, 4)
			mSleep(math.random(500, 700))
			toast("手机号登录注册", 1)
			mSleep(1000)
		end
		
		--wc图标
		mSleep(math.random(200, 300))
		x,y = findMultiColorInRegionFuzzy(0x0ec600, "0|-49|0x0ec600,-50|-1|0x0ec600,-11|38|0x0ec600,38|-1|0x0ec600,104|-541|0xd8d8d8,97|-616|0xd8d8d8", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
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
	
	t1 = ts.ms()
	while true do
		--wc图标
	    mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0x0ec600, "0|-49|0x0ec600,-50|-1|0x0ec600,-11|38|0x0ec600,38|-1|0x0ec600,104|-541|0xd8d8d8,97|-616|0xd8d8d8", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x, y, 4)
			mSleep(math.random(3500, 5000))
        end
	
	    --授权
	    mSleep(200)
	    x,y = findMultiColorInRegionFuzzy(0xffffff, "-97|-26|0x48516d,-107|46|0x48516d,198|-35|0x48516d,201|42|0x48516d,286|-30|0x2f3753,278|51|0x2f3753,579|-26|0x2f3753,582|31|0x2f3753,374|-1166|0xff7fa3", 90, 0, 0, 750, 1334, { orient = 2 })
        if x ~= -1 then
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
		mSleep(2000)
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
		["名字"] = {"梦琪","忆柳","之桃","慕青","问兰","尔岚","元香","bai初夏","沛菡","傲珊","曼文","乐菱","痴珊","恨玉","惜文","香寒","新柔","语蓉","海安","夜蓉","涵柏","水桃","醉蓝","春儿","语琴","从彤","傲晴","语兰","又菱","碧彤","元霜","怜梦","紫寒","妙彤","曼易","南莲","紫翠","雨寒","易烟","如萱","若南","寻真","晓亦","向珊","慕灵","以蕊","寻雁","映易","雪柳","孤岚","笑霜","海云","凝天","沛珊","寒云","冰旋","宛儿","绿真","盼儿","晓霜","碧凡","夏菡","曼香","若烟","半梦","雅绿","冰蓝","灵槐","平安","书翠","翠风","香巧","代云","梦曼","幼翠","友巧","听寒","梦柏","醉易","访旋","亦玉","凌萱","访卉","怀亦","笑蓝","春翠","靖柏","夜蕾","冰夏","梦松","书雪","乐枫","念薇","靖雁","寻春","恨山","从寒","忆香","觅波","静曼","凡旋","以亦","念露","芷蕾","千兰","新波","代真","新蕾","雁玉","冷卉","紫山","千琴","恨天","傲芙","盼山","怀蝶","冰兰","山柏","翠萱","恨松","问旋","从南","白易","问筠","如霜","半芹","丹珍","冰彤","亦寒","寒雁","怜云","寻文","乐丹","翠柔","谷山","之瑶","冰露","尔珍","谷雪","乐萱","涵菡","海莲","傲蕾","青槐","冬儿","易梦","惜雪","宛海","之柔","夏青","亦瑶","妙菡","春竹","痴梦","紫蓝","晓巧","幻柏","元风","冰枫","访蕊","南春","芷蕊","凡蕾","凡柔","安蕾","天荷","含玉","书兰","雅琴","书瑶","春雁","从安","夏槐","念芹","怀萍","代曼","幻珊","谷丝","秋翠","白晴","海露","代荷","含玉","书蕾","听白","访琴","灵雁","秋春","雪青","乐瑶","含烟","涵双","平蝶","雅蕊","傲之","灵薇","绿春","含蕾","从梦","从蓉","初丹。听兰","听蓉","语芙","夏彤","凌瑶","忆翠","幻灵","怜菡","紫南","依珊","妙竹","访烟","怜蕾","映寒","友绿","冰萍","惜霜","凌香","芷蕾","雁卉","迎梦","元柏","代萱","紫真","千青","凌寒","紫安","寒安","怀蕊","秋荷","涵雁","以山","凡梅","盼曼","翠彤","谷冬","新巧","冷安","千萍","冰烟","雅阳","友绿","南松","诗云","飞风","寄灵","书芹","幼蓉","以蓝","笑寒","忆寒","秋烟","芷巧","水香","映之","醉波","幻莲","夜山","芷卉","向彤","小玉","幼南","凡梦","尔曼","念波","迎松","青寒","笑天","涵蕾","碧菡","映秋","盼烟","忆山","以寒","寒香","小凡","代亦","梦露","映波","友蕊","寄凡","怜蕾","雁枫","水绿","曼荷","笑珊","寒珊","谷南","慕儿","夏岚","友儿","小萱","紫青","妙菱","冬寒","曼柔","语蝶","青筠","夜安","觅海","问安","晓槐","雅山","访云","翠容","寒凡","晓绿","以菱","冬云","含玉","访枫","含卉","夜白","冷安","灵竹","醉薇","元珊","幻波","盼夏","元瑶","迎曼","水云","访琴","谷波","乐之","笑白","之山","妙海","紫霜","平夏","凌旋","孤丝","怜寒","向萍","凡松","青丝","翠安","如天","凌雪","绮菱","代云","南莲","寻南","春文","香薇","冬灵","凌珍","采绿","天春","沛文","紫槐","幻柏","采文","春梅","雪旋","盼海","映梦","安雁","映容","凝阳","访风","天亦","平绿","盼香","觅风","小霜","雪萍","半雪","山柳","谷雪","靖易","白薇","梦菡","飞绿","如波","又晴","友易","香菱","冬亦","问雁","妙春","海冬","半安","平春","幼柏","秋灵","凝芙","念烟","白山","从灵","尔芙","迎蓉","念寒","翠绿","翠芙","靖儿","妙柏","千凝","小珍","天巧。妙旋","雪枫","夏菡","元绿","痴灵","绮琴","雨双","听枫","觅荷","凡之","晓凡","雅彤","香薇","孤风","从安","绮彤","之玉","雨珍","幻丝","代梅","香波","青亦","元菱","海瑶","飞槐","听露","梦岚","幻竹","新冬","盼翠","谷云","忆霜","水瑶","慕晴","秋双","雨真","觅珍","丹雪","从阳","元枫","痴香","思天","如松","妙晴","谷秋","妙松","晓夏","香柏","巧绿","宛筠","碧琴","盼兰","小夏","安容","青曼","千儿","香春","寻双","涵瑶","冷梅","秋柔","思菱","醉波","醉柳","以寒","迎夏","向雪","香莲","以丹","依凝","如柏","雁菱","凝竹","宛白","初柔","南蕾","书萱","梦槐","香芹","南琴","绿海","沛儿","晓瑶","听春","凝蝶","紫雪","念双","念真","曼寒","凡霜","飞雪","雪兰","雅霜","从蓉","冷雪","靖巧","翠丝","觅翠","凡白","乐蓉","迎波","丹烟","梦旋","书双","念桃","夜天","海桃","青香","恨风","安筠","觅柔","初南","秋蝶","千易","安露","诗蕊","山雁","友菱","香露","晓兰","白卉","语山","冷珍","秋翠","夏柳","如之","忆南","书易","翠桃","寄瑶","如曼","问柳","香梅","幻桃","又菡","春绿","醉蝶","亦绿","诗珊","听芹","新之","易巧","念云","晓灵","静枫","夏蓉","如南","幼丝","秋白","冰安","秋白","南风","醉山","初彤","凝海","紫文","凌晴","香卉","雅琴","傲安","傲之","初蝶","寻桃","代芹","诗霜","春柏","绿夏","碧灵","诗柳","夏柳","采白","慕梅","乐安","冬菱","紫安","宛凝","雨雪","易真","安荷","静竹","代柔","丹秋","绮梅","依白","凝荷","幼珊","忆彤","凌青","之桃","芷荷","听荷","代玉","念珍","梦菲","夜春","千秋","白秋","谷菱","飞松","初瑶","惜灵","恨瑶","梦易","新瑶","曼梅","碧曼","友瑶","雨兰","夜柳","香蝶","盼巧","芷珍","香卉","含芙","夜云","依萱","凝雁","以莲","易容","元柳","安南","幼晴","尔琴","飞阳","白凡","沛萍","雪瑶","向卉","采文","乐珍","寒荷","觅双","白桃","安卉","迎曼","盼雁","乐松","涵山","恨寒","问枫","以柳","含海","秋春","翠曼","忆梅","涵柳","梦香","海蓝","晓曼","代珊","春冬","恨荷","忆丹","静芙","绮兰","梦安","紫丝","千雁","凝珍","香萱","梦容","冷雁","飞柏","天真","翠琴","寄真","秋荷","代珊","初雪","雅柏","怜容","如风","南露","紫易","冰凡","海雪","语蓉","碧玉","翠岚","语风","盼丹","痴旋","凝梦","从雪","白枫","傲云","白梅","念露","慕凝","雅柔","盼柳","半青","从霜","怀柔","怜晴","夜蓉","代双","以南","若菱","芷文","寄春","南晴","恨之","梦寒","初翠","灵波","巧春","问夏","凌春","惜海"}
	}

	State["随机常量"] = tonumber(self:Rnd_Word("0123456789", 5))

	Nickname = self:Rnd_Word(State["姓氏"], 1, 3) .. State["名字"][math.random(1, #State["名字"])]

	t1 = ts.ms()
	while true do
		mSleep(500)
		if getColor(149,  187) == 0x323233 or getColor(149,187) == 0x323333 or getColor(149,  187) == 0x313232 then
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
			mSleep(1000)
			tap(x + 300, y + 121)
			mSleep(1500)
			for var = 1, 50 do
				mSleep(50)
				keyDown("DeleteOrBackspace")
				mSleep(50)
				keyUp("DeleteOrBackspace")
			end
			mSleep(500)
			inputStr(Nickname)
			mSleep(1000)
			toast("输入昵称", 1)
			mSleep(500)
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
		
		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
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
		
		flag = isFrontApp(self.mm_bid)
		if flag == 0 then
			runApp(self.mm_bid)
			mSleep(3000)
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
			self.subName = "未注册过"
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
		
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy(0xcdcecf, "5|1|0xcdcecf,4|13|0xcdcecf,13|5|0xcdcecf,17|6|0xcdcecf,29|5|0xcdcecf,32|11|0xcdcecf,38|0|0xcdcecf,47|9|0xcdcecf,44|19|0xcdcecf", 90, 581, 4, 749, 272, { orient = 2 })
        if x ~= -1 and y ~= -1 then
			mSleep(math.random(500, 700))
			randomTap(x + 20, y + 10, 4)
			mSleep(math.random(500, 700))
			toast("上传照片4", 1)
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
				while (true) do
				    mSleep(200)
				    if getColor(678,   83) == 0xffffff then
    					mSleep(2000)
    					randomTap(55,   82, 4)
    					mSleep(500)
    				elseif getColor(678,  131) == 0xffffff then
    					mSleep(2000)
    					randomTap(55,   128, 4)
    					mSleep(500)
    				else
    					mSleep(2000)
    					randomTap(55,   128, 4)
    					mSleep(500)
    				end
    				
    				mSleep(200)
					if getColor(678,   83) == 0x323333 then
						mSleep(500)
						break
					end
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
					    toast("搜索好友结束，进行下一步操作",1)
					    mSleep(500)
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
						else
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
				toast("个人资料1",1)
				mSleep(500)
			end
			
			--个人资料
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xa9a9a9, "11|13|0xa9a9a9,11|22|0xa9a9a9,43|14|0xa9a9a9,69|1|0xa9a9a9,163|13|0xa9a9a9,194|3|0xa9a9a9,216|18|0xa9a9a9,233|16|0xa9a9a9,264|10|0xa9a9a9", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("个人资料2",1)
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
			
			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入1",1)
				mSleep(500)
			end
			
			--填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xacacad, "226|-350|0xf9f9f9,-20|-137|0x5eb1f5,-8|-68|0x5eb1f5,143|-109|0x5eb1f5,-110|-900|0x323232,-70|-891|0x323232,-20|-894|0x323232,42|-900|0x323232,58|-908|0x323232", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入2",1)
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
		    --填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "33|3|0xaaaaaa,76|10|0xaaaaaa,-123|-97|0x3bb3fa,197|-89|0x3bb3fa,50|-889|0x323333,-64|-893|0x323333,-12|-890|0x323333,27|-886|0x323333,89|-892|0x323333", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入1",1)
				mSleep(500)
			end
			
		    --填写你的收入
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xacacad, "226|-350|0xf9f9f9,-20|-137|0x5eb1f5,-8|-68|0x5eb1f5,143|-109|0x5eb1f5,-110|-900|0x323232,-70|-891|0x323232,-20|-894|0x323232,42|-900|0x323232,58|-908|0x323232", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("填写你的收入2",1)
				mSleep(500)
            end
		
		    --你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323333, "278|-5|0x323333,306|2|0x323333,340|0|0x323333,380|0|0x323333,36|968|0x3bb3fa,318|1004|0x3bb3fa,583|955|0x3bb3fa,311|925|0x3bb3fa,309|970|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("你的家乡1",1)
				mSleep(500)
			end
			
			--你的家乡
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x323232, "278|-6|0x323232,297|3|0x323232,315|1|0x323232,332|-2|0x323232,363|-2|0x323232,380|-2|0x323232,33|966|0x5eb1f5,570|969|0x5eb1f5,320|929|0x5eb1f5", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				tap(x, y)
				mSleep(500)
				toast("你的家乡2",1)
				mSleep(500)
            end
		
		    --立即展示
			mSleep(200)
			if getColor(242,949) == 0x5fb0f3 and getColor(516,945) == 0x5fb0f3 then
				mSleep(500)
				randomTap(641,328, 4)
				mSleep(500)
				toast("立即展示",1)
				mSleep(500)
			end
			
			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xaaaaaa, "0|54|0xaaaaaa,-25|27|0xaaaaaa,25|27|0xaaaaaa,-75|-50|0xf6f6f6,73|-42|0xf6f6f6,79|100|0xf6f6f6,-73|99|0xf6f6f6,-14|39|0xf6f6f6,14|16|0xf6f6f6", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 180,y,4)
				mSleep(500)
			end
			
			--点击头像
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xababab, "-9|-10|0xababab,-10|10|0xababab,-10|0|0xffffff,-382|-263|0x000000,-376|-252|0x000000,-359|-252|0x000000,-350|-256|0x000000,-317|-257|0x000000,-277|-258|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 610,y,4)
				mSleep(500)
            end
		
		    --头像管理
		    mSleep(200)
		    x,y = findMultiColorInRegionFuzzy(0xababab, "0|-16|0xababab,-18|0|0xababab,15|0|0xababab,-1|18|0xababab,-34|18|0xf9f9f9,31|20|0xf9f9f9,-187|929|0x5eb1f5,99|951|0x5eb1f5,373|919|0x5eb1f5", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 180,y,4)
				mSleep(500)
				toast("头像管理1",1)
				mSleep(500)
            end
            
            --头像管理
		    mSleep(200)
            x,y = findMultiColorInRegionFuzzy(0xaaaaaa, "1|-20|0xaaaaaa,-17|-1|0xaaaaaa,18|-2|0xaaaaaa,0|17|0xaaaaaa,-35|40|0xf9f9f9,-164|901|0x3bb3fa,103|952|0x3bb3fa,368|917|0x3bb3fa,-3|54|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x - 180,y,4)
				mSleep(500)
				toast("头像管理2",1)
				mSleep(500)
            end

			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0xff3b30, "6|0|0xff3b30,12|0|0xff3b30,23|0|0xff3b30,30|0|0xff3b30,41|1|0xff3b30,62|3|0xff3b30", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y + 120,4)
				mSleep(500)
				toast("相册1",1)
				mSleep(500)
			end
			
			--相册
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3479f7, "3|16|0x3479f7,13|13|0x3479f7,24|2|0x3479f7,54|19|0x3479f7,61|3|0x3479f7,61|9|0x3479f7,71|18|0x3479f7,61|16|0x3479f7,62|23|0x3479f7", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y - 245,4)
				mSleep(500)
				toast("相册2",1)
				mSleep(500)
			end

			--点击图片选择作为头像
			mSleep(200)
			if getColor(139,  262) == 0xababab and getColor(207,  314) == 0xf6f6f6 then
				mSleep(500)
				randomTap(370,  298,4)
				mSleep(500)
			end
			
			--点击图片选择作为头像
			mSleep(200)
			if getColor(123,130) == 0x333233 and getColor(204,365) == 0xf5f5f5 then
				mSleep(500)
				randomTap(370,  341,4)
				mSleep(500)
			end
			
			--点击图片选择作为头像
			mSleep(200)
			if getColor(123,130) == 0x323333 and getColor(204,365) == 0xf6f6f6 then
				mSleep(500)
				randomTap(370,  341,4)
				mSleep(500)
			end

			--继续
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0x3bb3fa, "-12|0|0x3bb3fa,-4|16|0x3bb3fa,-3|-9|0x3bb3fa,24|-9|0x3bb3fa,28|-3|0x3bb3fa,22|8|0x3bb3fa,28|4|0x3bb3fa,34|8|0x3bb3fa", 90, 592, 7, 747, 298, { orient = 2 })
            if x ~= -1 then
				mSleep(500)
				randomTap(x,   y,4)
				mSleep(500)
				toast("继续1",1)
				mSleep(500)
			end
			
			--继续
			mSleep(200)
			if getColor(589,179) == 0x000000 and getColor(549,84) == 0xebebeb then
				mSleep(500)
				randomTap(663,   86,4)
				mSleep(500)
				toast("继续2",1)
				mSleep(500)
			end

			--完成
			mSleep(200)
			if getColor(621,   70) == 0x00c0ff and getColor(675,   61) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("完成1",1)
				mSleep(500)
				break
			end
			
			--完成
			mSleep(200)
			if getColor(617,117) == 0x56bdf9 or getColor(617,117) == 0x00c0ff and getColor(681,108) == 0xffffff then
				mSleep(500)
				randomTap(621,   108,4)
				mSleep(500)
				toast("完成2",1)
				mSleep(500)
				break
			end

			self:timeOutRestart(t1)
		end
		
		t1 = ts.ms()
		while true do
		   	--保存
			mSleep(200)
			if getColor(628,   85) == 0x3bb3ff  and getColor(690,   79) == 0xffffff then
				mSleep(500)
				randomTap(621,   61,4)
				mSleep(500)
				toast("保存1",1)
				mSleep(500)
			end
			
			--保存
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy(0xffffff, "-284|3|0x5eb1f5,284|7|0x5eb1f5,13|-37|0x5eb1f5,100|-923|0xabaaac,100|-939|0xabaaac,83|-922|0xabaaac,116|-922|0xabaaac,101|-904|0xabaaac,148|-899|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("保存2",1)
				mSleep(500)
            end
		    
		    --保存
			mSleep(200)
		    x,y = findMultiColorInRegionFuzzy(0xffffff, "-282|1|0x3bb3fa,21|34|0x3bb3fa,296|0|0x3bb3fa,31|-33|0x3bb3fa,-79|-921|0xaaaaaa,-64|-922|0xaaaaaa,-80|-938|0xaaaaaa,-91|-921|0xaaaaaa,-82|-865|0xf9f9f9", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(x,y,4)
				mSleep(500)
				toast("保存3",1)
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
		end

		t1 = ts.ms()
		while true do
			--编辑
			mSleep(200)
			x,y = findMultiColorInRegionFuzzy( 0x323333, "2|5|0x323333,4|14|0x323333,-31|9|0xffffff,12|6|0xffffff,19|10|0x323333,27|10|0x323333,36|10|0x323333,34|5|0x323333,53|0|0xffffff", 90, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(500)
				randomTap(55,   y + 7, 4)
				mSleep(500)
			end
			
			mSleep(200)
			if getColor(329,65) == 0x000000  and getColor(433,72) == 0x000000 then
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
	toast(new_name,1)
	mSleep(1000)
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
		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)
        
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
