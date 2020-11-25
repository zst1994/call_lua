require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.awz_bid 			= ""
model.awz_url 			= ""
model.wc_bid 			= ""
model.nickName          = ""
model.wc_file           = ""
math.randomseed(getRndNum()) -- 随机种子初始化真随机数

function jsonDec(res)
	return json.decode(res)
end

function model:getConfig()
	tb = readFile(userPath().."/res/config.txt") 
	if table then 
		self.awz_bid = tb[1]
		self.wc_bid = tb[2]
		self.awz_url = tb[3]
		self.wc_file = tb[4]
		self.nickName = self:getNickName()
		toast("获取配置信息成功",1)
		mSleep(1000)
	else
		dialog("文件不存在")
	end
end

--随机字符串
function model:randomStr(str, num)
	local ret =''
	for i = 1, num do
		local rchr = math.random(1, string.len(str))
		ret = ret .. string.sub(str, rchr, rchr)
	end
	return ret
end

--[[随机内容(UTF-8中文字符占3个字符)]]
function model:Rnd_Word(strs,i,Length)
	local ret=""
	local z
	if Length == nil then Length = 1 end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6)+State["随机常量"])  
	math.random(string.len(strs)/Length)
	for i=1, i do
		z=math.random(string.len(strs)/Length)
		ret = ret..string.sub(strs,(z*Length)-(Length-1),(z*Length))
	end
	return(ret)
end

--检测指定文件是否存在
function model:file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function model:vpn()
	mSleep(math.random(500, 700))
	setVPNEnable(false)
	setVPNEnable(false)
	setVPNEnable(false)
	mSleep(math.random(1500, 3700))
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
	mSleep(1000*math.random(7, 12))

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

function model:clear_App()
	::run_again::
	mSleep(500)
	closeApp(self.awz_bid) 
	mSleep(math.random(1000, 1500))
	runApp(self.awz_bid)
	mSleep(1000*math.random(1, 3))

	while true do
		mSleep(500)
		flag = isFrontApp(self.awz_bid)
		if flag == 1 then
-- 			if getColor(657,1307) == 0x0950d0 or getColor(652,1198) == 0x0950d0 then
-- 			    toast("准备newApp",1)
-- 				break
-- 			end
			mSleep(500)
			x,y = findMultiColorInRegionFuzzy(0x007aff, "27|0|0x007aff,38|2|0x047cff,56|-1|0x007aff,77|4|0x007aff,87|-4|0x007aff,94|7|0x007aff,109|6|0x007aff,126|1|0x007aff", 90, 0, 0, 750, 1334, { orient = 2 })
			if x ~= -1 then
				mSleep(math.random(500, 1000))
				tap(x,y)
				mSleep(math.random(500, 1000))
				while true do
					if getColor(266,601) == 0xffffff then
						toast("newApp成功",1)
						break
					end
				end
				break
			end
		else
			goto run_again
		end
	end

-- 	::new_phone::
-- 	local sz = require("sz");
-- 	local http = require("szocket.http")
-- 	local res, code = http.request(self.awz_url)
-- 	if code == 200 then
-- 		local resJson = sz.json.decode(res)
-- 		local result = resJson.result
-- 		if result == 3 then
-- 			toast("新机成功，但是ip重复了",1)
-- 		elseif result == 1 then
-- 			toast("新机成功",1)
-- 		else 
-- 			toast("失败，请手动查看问题："..tostring(res), 1)
-- 			mSleep(3000)
-- 			goto run_again
-- 		end
-- 	end 
end

function model:moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动",1)
	::pic::
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 33, 503, 711, 892)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	mSleep(500)
	if self:file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(math.random(500, 1000))
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333);   
		mSleep(math.random(500, 1000))
		if type(point) == "table"  and #point ~=0  then
			mSleep(500)
			x_len = point[1].x
			toast(x_len,1)
			return x_len
		else
			x_len = 0
			return x_len
		end
	else
		toast("文件不存在,重新截图识别",1)
		mSleep(math.random(1000, 1500))
		goto pic
	end
end

function model:getNickName()
	State={
		["随机常量"] = 0,
		["姓氏"]="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶" ..
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
		["名字"]="安彤含祖赩涤彰爵舞深群适渺辞莞延稷桦赐帅适亭濮存城稷澄添悟绢绢澹迪婕箫识悟舞添剑深禄延涤" ..
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
	State["随机常量"] = tonumber(self:Rnd_Word("0123456789",5))

	name = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],1,3)
	return name
end

function model:timeOutRestart(t1,overMin)
	t2 = ts.ms()

	if os.difftime(t2, t1) > tonumber(overMin) * 60 then
		toast("超过"..overMin.."分钟重新运行", 1)
		mSleep(1000)
		return false
	else
		toast("辅助倒计时"..(tonumber(overMin) * 60 - os.difftime(t2, t1)).."秒", 1)
		mSleep(5000)
		return true
	end
end

function model:readFileBase64(path) 
	f = io.open(path,"rb")
	if f == null then
		toast("no file")
		mSleep(3000);
		return null;
	end 
	bytes = f:read("*all");
	f:close();
	return bytes:base64_encode();
end

function model:getList(path) 
	local a = io.popen("ls "..path) 
	local f = {}; 
	for l in a:lines() do 
		table.insert(f,l) 
	end 
	return f 
end 

function model:getData() --获取62数据 (可以用的)
	local Wildcard = self:getList("/var/mobile/Containers/Data/Application") 
	for var = 1,#Wildcard do 
		local file = io.open("/var/mobile/Containers/Data/Application/"..Wildcard[var]..self.wc_file,"rb") 
		if file then 
			local str = file:read("*a") 
			file:close() 
			require"sz" 
			local str = string.tohex(str) --16进制编码 
			return str 
		end 
	end 
end 

function model:ewm(phone,fz_connection,base_six_four,provCode,cityCode,ewm_url)
	if fz_connection == "0" then
		::put_work::
		header_send = {
			["Content-Type"] = "application/json;charset=utf-8",
		}
		body_send = {
			["appId"] = 15220491065,
			["sign"] = string.upper(("1522049106536F0329C59FFC56044AA44C25A70C70D"..phone):md5()),
			["taskKey"] = phone,
			["data"] = {
				["type"] = 2,
				["qrInfo"] = base_six_four,
				["expireTime"] = 300,
				["provCode"] = provCode,
				["cityCode"] = cityCode,
			},
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpPost("http://45.113.200.91:8089/simple/upload", header_send,body_send)
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.returnCode == 100 or tmp.returnCode == "100" then
				taskId = tmp.data.taskId
				toast("二维码辅助发布成功:"..taskId,1)
				mSleep(1000)
			elseif tmp.returnCode == 101 or tmp.returnCode == "101" then
				toast("二维码解析无效",1)
				mSleep(1000)
				return false
			elseif tmp.returnCode == 102 or tmp.returnCode == "102" then
				toast("签名验证失败",1)
				mSleep(1000)
				goto put_work
			elseif tmp.returnCode == 103 or tmp.returnCode == "103" then
				toast("余额不足或json转换错误",1)
				mSleep(1000)
				goto put_work
			elseif tmp.returnCode == 104 or tmp.returnCode == "104" then
				toast("账号不可用",1)
				mSleep(1000)
				goto put_work
			elseif tmp.returnCode == 105 or tmp.returnCode == "105" then
				toast("赏金过低",1)
				mSleep(1000)
				goto put_work
			elseif tmp.returnCode == 130 or tmp.returnCode == "130" then
				toast("省份码不正确",1)
				mSleep(1000)
				goto put_work
			else
				mSleep(500)
				toast("发布失败，6秒后重新发布",1)
				mSleep(6000)
				goto put_work
			end
		else
			goto put_work
		end
	elseif fz_connection == "1" then
	    ::put_work::
		header_send = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
		body_send = {
			["userKey"] = "9826103d266d4fc1beecd3ee2cea3cf9",
			["qrCodeUrl"] = urlEncoder(ewm_url),
			["phone"] = phone,
			["city"] = cityCode
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send,body_send)
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.success then
				orderId = tmp.obj.orderId
				toast("二维码辅助发布成功:"..orderId,1)
				mSleep(5000)
			else
				mSleep(500)
				toast("发布失败，6秒后重新发布:"..tostring(body_resp),1)
				mSleep(6000)
				goto put_work
			end
		else
			goto put_work
		end
	end

	t1 = ts.ms()
	while true do
		timeOutBool = self:timeOutRestart(t1,5)
		if not timeOutBool then
			if fz_connection == "0" then
				taskResult = 2
			elseif fz_connection == "1" then
			    _status = 2
			end
			break
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x7c160,"279|8|0x7c160,133|-829|0x7c160,160|-785|0x7c160,128|-659|0x191919,216|-659|0x191919", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(373, 1099)
			mSleep(math.random(500, 700))
			toast("返回注册流程",1)
			mSleep(1000)
			if fz_connection == "0" then
				taskResult = 1
			elseif fz_connection == "1" then
			    _status = 1
			end
			break
		end
	end

	if fz_connection == "0" then
		::push_work::
		header_send = {
			["Content-Type"] = "application/json;charset=utf-8",
		}
		body_send = {
			["appId"] = 15220491065,
			["sign"] = string.upper(("1522049106536F0329C59FFC56044AA44C25A70C70D"..phone):md5()),
			["taskKey"] = phone,
			["data"] = {
				["taskId"] = taskId,
				["taskResult"] = taskResult,
			},
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpPost("http://45.113.200.91:8089/simple/result", header_send,body_send)
		if code == 200 then
			mSleep(500)
			local tmp = json.decode(body_resp)
			if tmp.returnCode == 100 or tmp.returnCode == "100" then
				toast("扫码反馈结果成功",1)
				mSleep(1000)
				if taskResult == 1 then
					return true
				else
					return false
				end
			elseif tmp.returnCode == 102 or tmp.returnCode == "102" then
				toast("签名验证失败",1)
				mSleep(1000)
				goto push_work
			elseif tmp.returnCode == 103 or tmp.returnCode == "103" then
				toast("余额不足或json转换错误",1)
				mSleep(1000)
				goto push_work
			elseif tmp.returnCode == 104 or tmp.returnCode == "104" then
				toast("账号不可用",1)
				mSleep(1000)
				goto push_work
			elseif tmp.returnCode == 109 or tmp.returnCode == "109" then
				toast("已提交任务结果",1)
				mSleep(1000)
				if taskResult == 1 then
					return true
				else
					return false
				end
			else
				mSleep(500)
				toast("扫码反馈结果失败，6秒后重新反馈:"..tmp.returnCode,1)
				mSleep(6000)
				goto push_work
			end
		else
			goto push_work
		end
	elseif fz_connection == "1" then
		::push_work::
		header_send = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
		body_send = {
			["userKey"] = "9826103d266d4fc1beecd3ee2cea3cf9",
			["orderId"] = orderId,
			["status"] = _status,
		}
		ts.setHttpsTimeOut(60)
		code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
		if code == 200 then
			local tmp = json.decode(body_resp)
			if tmp.success then
				toast("标记成功",1)
				if _status == 1 then
					return true
				else
					return false
				end
			else
				toast("订单标记失败"..tostring(body_resp),1)
				mSleep(3000)
				goto push_work
			end
		else
			toast("订单标记失败"..tostring(body_resp),1)
			mSleep(3000)
			goto push_work
		end
	end
end

function model:pushAccountMess(phone,pass,sixTwo,sj)
	::send::
	local sz = require("sz")       
	local http = require("szocket.http")
	local res, code = http.request("http://47.92.208.220/import_data?phone="..phone.."&password="..pass.."&token="..sixTwo.."&time="..sj)
	if code == 200 then
		tmp = json.decode(res)
		if tmp.code == 200 then
			toast(tmp.message,1)
			mSleep(1000)
		else
			toast("重新上传",1)
			mSleep(1000)
			goto send
		end
	else
		toast("重新上传",1)
		mSleep(1000)
		goto send
	end
end

function model:sendPhoneCode()
    local API = "Hk8Ve2Duh6QCR5XUxLpRxPyv"
	local Secret  = "fD0az8pW8lNhGptCZC4TPfMWX5CyVtnh"

	local tab={
		detect_direction="true",
		detect_language="false",
		ocrType = 2
	}
    
    sendCodeTime = 0
	::getBaiDuToken::
	local code,access_token = getAccessToken(API,Secret)
	if code then
	    ::snap::
	    if sendCodeTime > 2 then
	        dialog("重新截图三次发短信失败，请手动操作发短信,取消界面后60秒后开始点击操作",0)
	        return false
	    end
        
		local content_name = userPath() .. "/res/baiduAI_content_name1.jpg"
		
		--内容
		snapshot(content_name, 10,556,232,661) 
		mSleep(100)
	
		local code, body = baiduAI(access_token,content_name,tab)
		if code then
			local tmp = json.decode(body)

			if #tmp.words_result > 0 then
			    sendCodeTime = 0
				content_num = string.lower(tmp.words_result[1].words)
			else
			    sendCodeTime = sendCodeTime + 1
				toast("识别内容失败，重新截图识别" .. tostring(body),1)
				mSleep(3000)
				goto snap        
			end
		else
		    sendCodeTime = sendCodeTime + 1
			toast("识别内容失败\n" .. tostring(body),1)
			mSleep(3000)
			goto snap
		end 

		if #content_num >= 4 then
		    sendCodeTime = 0
		    content_num = string.sub(content_num,#content_num - 1, #content_num)
			toast("识别内容：\r\n"..content_num,1)
			mSleep(1000)
		else
		    sendCodeTime = sendCodeTime + 1
			toast("识别内容失败,重新截图识别" .. tostring(body),1)
			mSleep(3000)
			goto snap 
		end
	else
		toast("获取token失败",1)
		goto getBaiDuToken
	end

	::send_message::
	mSleep(500)
	local sz = require("sz")        --登陆
	local http = require("szocket.http")
	local res, code = http.request("http://185.247.228.89:5566/register/api/uploadmsg.php?cpid="..getPhoneToken.."&phone="..phone.."&zc=zc"..content_num.."&upmobile=106903290212367")
	mSleep(500)
	if code == 200 then
		local status, data = pcall(jsonDec,res)
		if status then
			local tmp = data
			if tmp.status == "0" or tmp.status == "4" then
				mSleep(200)
				toast("发送短信成功",1)
				mSleep(1000)
				for var=1, 3 do
					toast("等待30秒继续操作:"..(var - 1) * 3,1)
					mSleep(3000)
				end
				mSleep(2000)
				tap(345,1082)
				mSleep(2000)
				return true
			else
				mSleep(500)
				toast("发送短信失败，失败信息:"..tostring(tmp.msg),1)
				mSleep(5000)
				goto send_message
			end
		else
			toast("json解析失败，重新发送短信", 1)
			mSleep(500)
			goto send_message
		end
	else
		toast("发送短信失败，重新发送"..tostring(res),1)
		mSleep(1000)
		goto send_message
	end
end

function model:vpn_connection()
    mSleep(500)
    x,y = findMultiColorInRegionFuzzy(0x007aff, "7|16|0x007aff,16|-4|0x007aff,15|8|0x007aff,27|9|0x007aff,19|22|0x007aff,22|16|0x007aff,14|14|0xe2e2e2,-5|9|0xe1e1e1,34|6|0xe5e5e5", 90, 53, 426, 709, 933, { orient = 2 })
    if x~=-1 and y~=-1 then
        mSleep(math.random(500, 700))
		tap(x, y)
		mSleep(math.random(500, 700))
		toast("vpn连接中断",1)
		mSleep(1000)
    end
end

function model:loginAccount(code_connection,getPhoneToken,getPhoneCity,loginPassword,overMin,add_wc_Id,fz_type,fz_connection,provCode,cityCode,addFriend,openScan)
	error_wc = false
	data_six_two = false

	::run_app::
	mSleep(500)
	closeApp(self.wc_bid)
	::nexts::
	mSleep(math.random(1000, 1500))
	runApp(self.wc_bid)
	mSleep(math.random(1000, 1500))

	while (true) do
		x,y = findMultiColorInRegionFuzzy(0x06ad56, "260|25|0x06ad56,117|14|0x9cdebc,-347|4|0xf2f2f2,-114|3|0xf2f2f2,-240|14|0x06ae56,-208|21|0x06ae56", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 50, y + 20)
			mSleep(math.random(500, 700))
			toast("注册1",1)
			mSleep(1000)
			break
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 50, y + 20)
			mSleep(math.random(500, 700))
			toast("注册2",1)
			mSleep(1000)
			break
		end
		
		self:vpn_connection()

		mSleep(math.random(500, 700))
		flag = isFrontApp(self.wc_bid)
		if flag == 0 then
			goto run_app
		end
	end

	while (true) do
		--微信版本7015
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0xf2f2f2,"458|9|0xf2f2f2,291|-94|0x576b95",100,0,0,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			toast("注册页面1",1)
			mSleep(1000)
			break
		end

		--微信版本709
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x9ce6bf,"194|0|0xd7f5e5,530|-7|0x9ce6bf,234|-36|0x9ce6bf,229|28|0x9ce6bf",90,0,700,749,1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(200, 500))
			toast("注册页面2",1)
			mSleep(1000)
			break
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(549, 1240,10)
			mSleep(math.random(500, 700))
		end

		x,y = findMultiColorInRegionFuzzy(0x06ad56, "260|25|0x06ad56,117|14|0x9cdebc,-347|4|0xf2f2f2,-114|3|0xf2f2f2,-240|14|0x06ae56,-208|21|0x06ae56", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 50, y + 20)
			mSleep(math.random(500, 700))
			toast("注册1",1)
			mSleep(1000)
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0x07c160, "171|-1|0x07c160,57|-5|0xffffff,-163|-3|0xf2f2f2,-411|1|0xf2f2f2,-266|-6|0x06ae56", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x + 50, y + 20)
			mSleep(math.random(500, 700))
			toast("注册2",1)
			mSleep(1000)
		end
		
		self:vpn_connection()
	end

	if code_connection == "0" then
		if #getPhoneCity:atrim() == 0 or getPhoneCity == "默认值" then
			getPhoneCity = ""
		end

		-- YEZIkvopYHEkUJXOFVl
		::get_phone::
		local sz = require("sz")        --登陆
		local http = require("szocket.http")
		local res, code = http.request("http://185.247.228.89:5566/register/api/fetch.php?cpid="..getPhoneToken.."&city="..getPhoneCity)

		mSleep(500)
		if code == 200 then
			local status, data = pcall(jsonDec,res)
			if status then
				local tmp = data
				if tmp.status == "0" then
					mSleep(200)
					telphone = tmp.data
					phone = telphone
					writeFileString(userPath().."/res/phone_data.txt",phone,"w")
				else
					mSleep(500)
					toast("获取手机号码失败，失败信息:"..tostring(tmp.msg),1)
					mSleep(5000)
					goto get_phone
				end
			else
				toast("json解析失败，重新获取号码", 1)
				mSleep(500)
				goto get_phone
			end
		else
			toast("获取手机号码失败，重新获取:"..tostring(tmp.msg),1)
			mSleep(1000)
			goto get_phone
		end
	end

	toast(phone,1)
	mSleep(1200)

	--昵称
	while (true) do
		mSleep(math.random(200, 500))
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "28|0|0x1a1a1a,4|18|0x1a1a1a,15|18|0x1a1a1a,26|18|0x1a1a1a,38|13|0x1a1a1a,45|12|0x1a1a1a,60|8|0x1a1a1a,56|15|0x1a1a1a", 100, 0, 300, 750, 900, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(1000, 1500))
			tap(x + 290, y - 243)
			mSleep(2000)
			inputStr(self.nickName)
			mSleep(500)
			toast("输入昵称",1)
			mSleep(1000)
		end
		
		self:vpn_connection()

		--检测是否有删除按钮
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0xcccccc, "11|-9|0xcccccc,20|0|0xcccccc,11|10|0xcccccc,10|-1|0xffffff,5|-5|0xffffff,15|4|0xffffff,15|-5|0xffffff,7|4|0xffffff", 100, 630, 89, 749, 1333)
		if x~=-1 and y~=-1 then
			break
		end
	end

	--输入手机号码
	while (true) do
		mSleep(math.random(500, 1000))
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "28|0|0x1a1a1a,4|18|0x1a1a1a,15|18|0x1a1a1a,26|18|0x1a1a1a,38|13|0x1a1a1a,45|12|0x1a1a1a,60|8|0x1a1a1a,56|15|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 1000))
			tap(x + 330,y - 83)
			mSleep(1000)
			break
		end
		
		self:vpn_connection()
	end

	for i = 1, #phone do
		num = string.sub(phone,i,i)
		mSleep(math.random(400, 600))
		keyDown(num)
		mSleep(200)
		keyUp(num)
	end

	--输入密码
	while (true) do
		mSleep(math.random(500, 1000))
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "28|0|0x1a1a1a,4|18|0x1a1a1a,15|18|0x1a1a1a,26|18|0x1a1a1a,38|13|0x1a1a1a,45|12|0x1a1a1a,60|8|0x1a1a1a,56|15|0x1a1a1a", 100, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 1000))
			tap(x + 330, y + 20)
			mSleep(math.random(1000, 1500))
			inputStr(loginPassword)
			mSleep(1000)
			break
		end
		
		self:vpn_connection()
	end

	--勾选协议
	while true do
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xffffff, "-273|-23|0x07c160,375|49|0x07c160,76|-24|0x07c160,-25|21|0x07c160,88|13|0xffffff", 100, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x - 226, y - 85)
			mSleep(math.random(1000, 1500))
			tap(x, y)
			mSleep(1000)
			break
		end

		--输入密码
		mSleep(math.random(500, 1000))
		x,y = findMultiColorInRegionFuzzy(0x1a1a1a, "28|0|0x1a1a1a,4|18|0x1a1a1a,15|18|0x1a1a1a,26|18|0x1a1a1a,38|13|0x1a1a1a,45|12|0x1a1a1a,60|8|0x1a1a1a,56|15|0x1a1a1a", 100, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 1000))
			tap(x + 330, y + 20)
			mSleep(math.random(1000, 1500))
			inputStr(loginPassword)
			mSleep(1000)
		end
		
		self:vpn_connection()
	end

	--隐私协议
	while true do
		--注册页面下一步
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xffffff, "-273|-23|0x07c160,375|49|0x07c160,76|-24|0x07c160,-25|21|0x07c160,88|13|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(1000, 1500))
			tap(x, y)
			mSleep(1000)
		end

		--微信版本7015
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xfafafa, "51|12|0xfafafa,-113|-4|0xf2f2f2,205|13|0xf2f2f2,-11|-75|0xededed,-205|-147|0x777777,-189|-144|0x777777,-37|-145|0x777777,105|35|0xf2f2f2,403|82|0xededed", 100, 0, 1000, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y - 143)
			mSleep(math.random(500, 1000))
		end

		--微信版本709
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xfdfdfd, "53|12|0xfdfdfd,-120|-15|0xf2f2f2,-121|38|0xf2f2f2,216|42|0xf2f2f2,217|-17|0xf2f2f2,69|-48|0xededed,-201|-147|0x777777,-35|-145|0x777777", 100, 0, 1000, 750, 1334)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y - 143)
			mSleep(math.random(500, 1000))
		end

		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xffffff, "-119|35|0x07c160,231|-17|0x07c160,231|-17|0x07c160,49|83|0xededed", 90, 1, 1182, 747, 1330, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(1000, 1500))
			toast("隐私指引下一步",1)
			mSleep(1000)
			break
		end
		
		self:vpn_connection()
	end

	--安全验证
	while (true) do
		mSleep(math.random(700, 900))
		x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(1000, 1500))
			tap(372, 1105)
			mSleep(math.random(1000, 1500))
			toast("安全验证",1)
			mSleep(1000)
			break
		end

		--隐私指引   微信版本7015
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xfafafa, "51|12|0xfafafa,-113|-4|0xf2f2f2,205|13|0xf2f2f2,-11|-75|0xededed,-205|-147|0x777777,-189|-144|0x777777,-37|-145|0x777777,105|35|0xf2f2f2,403|82|0xededed", 100, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y - 143)
			mSleep(math.random(500, 1000))
		end

		--隐私指引   微信版本709
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy( 0xfdfdfd, "53|12|0xfdfdfd,-120|-15|0xf2f2f2,-121|38|0xf2f2f2,216|42|0xf2f2f2,217|-17|0xf2f2f2,69|-48|0xededed,-201|-147|0x777777,-35|-145|0x777777", 100, 0, 1000, 750, 1334)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y - 143)
			mSleep(math.random(500, 1000))
		end

		--隐私指引： 下一步
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0xffffff, "-119|35|0x07c160,231|-17|0x07c160,231|-17|0x07c160,49|83|0xededed", 90, 1, 1182, 747, 1330, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(1000, 1500))
		end
		
		self:vpn_connection()
	end

	if fz_type == "0" or fz_type == "1" then
		toast("辅助注册",1)
		mSleep(1000)
		::get_pic::
		while (true) do
			mSleep(math.random(500, 700))
			if getColor(118,  948) == 0x007aff and getColor(191, 953) == 0x007aff then
				x_lens = self:moves()
				if tonumber(x_lens) > 0 then
					mSleep(math.random(500, 700))
					moveTowards( 108,  952, 10, x_len-65)
					mSleep(3000)
					break
				else
					mSleep(math.random(500, 1000))
					tap(603, 1032)
					mSleep(math.random(3000, 6000))
					goto get_pic
				end
			end

			mSleep(math.random(700, 900))
			x, y = findMultiColorInRegionFuzzy(0x10aeff,"55|8|0x10aeff,-79|817|0x7c160,116|822|0x7c160", 100, 0, 0, 749, 1333)
			if x~=-1 and y~=-1 then
				mSleep(math.random(1000, 1500))
				tap(372, 1105)
				mSleep(math.random(1000, 1500))
				toast("安全验证",1)
			end
		end

		if fz_type == "0" then
			t1 = ts.ms()
			while true do
				timeOutBool = self:timeOutRestart(t1,overMin)
				if not timeOutBool then
					goto over
				end

				mSleep(math.random(500, 700))
				x,y = findMultiColorInRegionFuzzy(0x7c160,"279|8|0x7c160,133|-829|0x7c160,160|-785|0x7c160,128|-659|0x191919,216|-659|0x191919", 90, 0, 0, 749, 1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					tap(373, 1099)
					mSleep(math.random(500, 700))
					toast("返回注册流程",1)
					mSleep(1000)
					break
				end
				
				self:vpn_connection()
			end
		elseif fz_type == "1" then
			--二维码识别
			while (true) do
				mSleep(math.random(500, 700))
				if getColor(132,  766) == 0x000000 and getColor(132, 1014) == 0x000000 then
					mSleep(math.random(500, 700))
					snapshot("1.png", 109,  701, 442, 1073)
					mSleep(math.random(1000, 1500))
					base_six_four = self:readFileBase64(userPath().."/res/1.png") 
					toast("准备发布任务",1)
					mSleep(1000)
					break
				end
				
				self:vpn_connection()
			end
			
			--提取二维码url
			if fz_connection == "1" then
				::ewm_go::
				header_send = {
					["Content-Type"] = "application/x-www-form-urlencoded",
				}
				body_send = {
					["base64"] = urlEncoder("data:image/png;base64,"..base_six_four),
				}
				ts.setHttpsTimeOut(60)
				code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/decode", header_send,body_send)
				if code == 200 then
					ewm_url = body_resp  
					toast(ewm_url,1)
					mSleep(1000)
				else
					toast("二维码失败失败:"..body_resp,1)
					mSleep(6000)
					goto ewm_go
				end
			else
			    ewm_url = ""
			end

			ewm_bool = self:ewm(phone,fz_connection,base_six_four,provCode,cityCode,ewm_url)
			if ewm_bool then
				mSleep(500)
				toast("辅助成功",1)
				mSleep(500)
			else
				mSleep(500)
				toast("辅助失败，进行下一个注册",1)
				mSleep(500)
				goto over
			end
		end
	end
    
	yzm_error_num = 0
	
    ::yzm_error::
	yzm_error_bool = false
	
	if code_connection == "0" then
		while true do
		    --微信版本7015
			mSleep(math.random(500, 700))
			x,y = findMultiColorInRegionFuzzy(0x07c160, "583|-1|0x07c160,285|12|0xffffff,200|157|0x06ae56,358|158|0x06ae56,432|149|0x06ae56,37|-619|0x181818,198|-626|0x181818", 90, 0, 0, 750, 1334, { orient = 2 })
			if x~=-1 and y~=-1 then
				toast("准备识别发送短信内容与号码",1)
				mSleep(500)
				sendBool = self:sendPhoneCode(705)
				if not sendBool then
				    for var=1, 12 do
						toast("等待60秒继续操作:"..(var - 1) * 5,1)
						mSleep(4500)
					end
				    mSleep(2000)
    				tap(345,1082)
    				mSleep(2000)
				end
				break
			end
			
			--微信版本709
			mSleep(math.random(500, 700))
            x,y = findMultiColorInRegionFuzzy(0x06ae56, "147|7|0x06ae56,-104|6|0xf2f2f2,386|1|0xf2f2f2,-200|-136|0x07c160,387|-121|0x07c160,27|-125|0xffffff,173|-125|0xffffff,119|-764|0x181818,-152|-771|0x181818", 90, 0, 0, 750, 1334, { orient = 2 })
            if x~=-1 and y~=-1 then
                toast("准备识别发送短信内容与号码",1)
				mSleep(500)
				sendBool = self:sendPhoneCode(710)
				if not sendBool then
				    for var=1, 12 do
						toast("等待60秒继续操作:"..(var - 1) * 5,1)
						mSleep(4500)
					end
				    mSleep(2000)
    				tap(345,1082)
    				mSleep(2000)
				end
				break
            end
            
            self:vpn_connection()
		end
	end

	while true do
	    --验证码不正确，请重新输入
	    mSleep(math.random(500, 700))
	    x,y = findMultiColorInRegionFuzzy(0x576b95, "17|1|0x576b95,45|-2|0x576b95,-173|-165|0x1a1a1a,-121|-165|0x1a1a1a,-60|-159|0x1a1a1a,14|-162|0x1a1a1a,176|-161|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
       if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("验证码不正确，请重新输入",1)
			if not yzm_error_bool then
				for var=1, 4 do
					toast("等待20秒继续操作:"..(var - 1) * 5,1)
					mSleep(4500)
				end
				mSleep(2000)
				tap(345,1082)
				mSleep(2000)
				yzm_error_bool = true
			else
				yzm_error_num = yzm_error_num + 1
				if yzm_error_num > 1 then
					toast("重新发送验证码两次不正确，进行下一个号码操作",1)
					mSleep(1000)
					goto over
				else
					mSleep(1000)
					goto yzm_error
				end
			end
		end

		--不是我的，继续注册
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x6ae56,"36|1|0x6ae56,136|5|0x6ae56,181|-7|0x6ae56,294|-7|0x6ae56,371|0|0xf2f2f2,-98|-3|0xf2f2f2", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("不是我的，继续注册",1)
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x576b95,"28|-1|0x576b95,-84|141|0x36030,164|141|0x36030,-208|-180|0,-121|-230|0", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("手机号近期注册过微信",1)
			break
		end

		mSleep(math.random(500, 700))
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			toast("通讯录前账号状态异常",1)
			error_wc = true
			break
		end

		--好
		x,y = findMultiColorInRegionFuzzy(0x007aff, "5|15|0x007aff,16|-5|0x007aff,19|14|0x007aff,26|8|0x007aff,20|-189|0x000000,53|-197|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("好",1)
			mSleep(1000)
		end
        
        --微信版本7015
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|5|0x576b95,16|-4|0x576b95,-242|-250|0x1a1a1a,-219|-248|0x1a1a1a,-172|-245|0x1a1a1a,-11|-258|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("通讯录1",1)
			break
		end
		
		--微信版本709
		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x1565fc,"6|13|0x1565fc,17|-5|0x1565fc,19|6|0x1565fc,17|20|0x1565fc", 90, 0, 0, 749,  1333)
		if x~=-1 and y~=-1 then
		    mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("通讯录2",1)
			break
		end
		
		--微信版本714
		x,y = findMultiColorInRegionFuzzy( 0x576b95, "4|15|0x576b95,13|-5|0x576b95,19|14|0x576b95,-309|11|0x576b95,-244|4|0x576b95,-240|-256|0x000000,-171|-244|0x000000,-119|-246|0x000000,-6|-259|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
		    mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("通讯录3",1)
			break
		end
		
		self:vpn_connection()
	end

	while true do
		--好
		x,y = findMultiColorInRegionFuzzy(0x007aff, "5|15|0x007aff,16|-5|0x007aff,19|14|0x007aff,26|8|0x007aff,20|-189|0x000000,53|-197|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
		if x ~= -1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
		end

		--通讯录
		mSleep(math.random(500, 700))
		x,y = findMultiColorInRegionFuzzy(0x576b95, "17|5|0x576b95,16|-4|0x576b95,-242|-250|0x1a1a1a,-219|-248|0x1a1a1a,-172|-245|0x1a1a1a,-11|-258|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
		end

		--允许位置
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy(0x007aff, "22|-1|0x007aff,39|-15|0x007aff,45|-4|0x007aff,37|7|0x007aff,-39|-6|0xf6f6f6", 90, 0, 0, 750, 1334, { orient = 2 })
		if x~=-1 and y~=-1 then    
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("允许访问位置",1)
		end
		
		--允许位置714
		mSleep(500)
		x,y = findMultiColorInRegionFuzzy( 0x007aff, "9|5|0x007aff,31|0|0x007aff,47|0|0x007aff,-329|-316|0x000000,-321|-313|0x000000,19|-328|0x000000,64|-315|0x000000,-39|-278|0x000000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then    
			mSleep(math.random(500, 700))
			tap(x, y)
			mSleep(math.random(500, 700))
			toast("允许访问位置",1)
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"483|-9|0x7c160,155|2|0xffffff,159|95|0x576b95,225|92|0x576b95,246|99|0x576b95", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then    
			mSleep(math.random(500, 700))
			tap(375, 1274)
			mSleep(math.random(500, 700))
			toast("加朋友",1)
		end

		mSleep(math.random(500, 700))
		x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
		if x~=-1 and y~=-1 then
			if addFriend == "0" then
				mSleep(math.random(500, 700))
				tap(694, 85)
				mSleep(math.random(500, 700))
			end
			toast("微信界面",1)
			data_six_two = true
			break
		end

		mSleep(math.random(500, 700))
		if getColor(362,797) == 0x576b95 and getColor(391,800) == 0x576b95 then
			toast("通讯录后账号状态异常",1)
			error_wc = true
			break
		end
		
		self:vpn_connection()
	end

	if data_six_two then
		--添加朋友
		if addFriend == "0" then
			while true do
			    self:vpn_connection()
			    
				--微信界面
				mSleep(math.random(500, 700))
				x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
				if x~=-1 and y~=-1 then
					mSleep(math.random(500, 700))
					tap(694, 85)
					mSleep(math.random(500, 700))
				end

				mSleep(500)
				if getColor(711,564) == 0x4c4c4c and getColor(711,158) == 0x4c4c4c then
					mSleep(500)
					tap(575,306)
					mSleep(500)
					toast("添加朋友",1)
					mSleep(1000)
				end

				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0x171717, "4|16|0x171717,8|11|0x171717,14|6|0x171717,19|15|0x171717,23|11|0x171717,45|2|0x171717,47|10|0x171717", 90, 0, 0, 750, 1334, { orient = 2 })
				if x~=-1 and y~=-1 then
					mSleep(500)
					tap(557,171)
					mSleep(500)
					--添加微信号
					wcIdData = strSplit(add_wc_Id, "-")
					for k,v in ipairs(wcIdData) do
						mSleep(500)
						inputStr(v)
						mSleep(1000)
						while true do
							--搜索
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy(0x07c160, "79|-1|0x07c160,72|68|0x07c160,5|65|0x07c160,35|30|0x07c160,117|31|0x1a1a1a,158|22|0x1a1a1a", 90, 0, 0, 750, 1334, { orient = 2 })
							if x ~= -1 then
								mSleep(500)
								tap(439,189)
								mSleep(1000)
							end

							--添加到通讯录
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy(0x576b95, "6|21|0x576b95,30|8|0x576b95,51|10|0x576b95,79|14|0x576b95,143|15|0x576b95,177|19|0x576b95", 90, 0, 0, 750, 1334, { orient = 2 })
							if x~=-1 and y~=-1 then
								mSleep(500)
								tap(x,y)
								mSleep(500)
								break
							end

							--视频通话
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy(0x576b95, "23|8|0x576b95,14|19|0x576b95,35|18|0x576b95,55|8|0x5a6e97,104|14|0x576b95,118|14|0x576b95,139|14|0x576b95,154|11|0x576b95", 90, 0, 0, 750, 1334, { orient = 2 })
							if x~=-1 and y~=-1 then
								break
							end
						end

						while true do
							--视频通话
							mSleep(500)
							x,y = findMultiColorInRegionFuzzy(0x576b95, "23|8|0x576b95,14|19|0x576b95,35|18|0x576b95,55|8|0x5a6e97,104|14|0x576b95,118|14|0x576b95,139|14|0x576b95,154|11|0x576b95", 90, 0, 0, 750, 1334, { orient = 2 })
							if x~=-1 and y~=-1 then
								mSleep(500)
								tap(45,85)
								mSleep(500)
							end

							mSleep(500)
							if getColor(603,84) == 0x8e8e93 and getColor(621,83) == 0x8e8e93 then
								mSleep(500)
								tap(621,83)
								mSleep(500)
								break
							end
						end
					end
					mSleep(500)
					tap(694,81)
					mSleep(1000)
					break
				end
			end
		else
			if openScan == "0" then
				while true do
					--微信界面
					mSleep(math.random(500, 700))
					x, y = findMultiColorInRegionFuzzy(0x7c160,"191|19|0,565|19|0,104|13|0xfafafa,616|24|0xfafafa", 90, 0, 1013, 749,  1333)
					if x~=-1 and y~=-1 then
						mSleep(math.random(500, 700))
						tap(694, 85)
						mSleep(math.random(500, 700))
					end

					mSleep(500)
					if getColor(711,564) == 0x4c4c4c and getColor(711,158) == 0x4c4c4c then
						mSleep(500)
						tap(575,306)
						mSleep(500)
						toast("添加朋友",1)
						mSleep(1000)
						break
					end
				end
			end
		end
	end

	if data_six_two or error_wc then
		six_data = self:getData()
		mSleep(500)
		toast(six_data);
		mSleep(500)
		time = getNetTime()
		sj=os.date("%Y年%m月%d日%H点%M分%S秒",time)
		mSleep(200)
		toast(sj)       --或这样
		mSleep(500)
		if data_six_two then
			file_path = userPath().."/res/six_data.txt"
		elseif error_wc then 
			file_path = userPath().."/res/six_data_error.txt"
		end

		writeFileString(file_path,phone.."----"..loginPassword.."----"..six_data.."----"..sj,"a",1)
		mSleep(500)
		
		self:pushAccountMess(phone,loginPassword,six_data,sj)
	end

	if data_six_two then
		if openScan == "0" then
			--扫一扫
			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0x272727, "-127|3|0x1485ee,-91|35|0x1485ee,-91|6|0x1485ee,-127|33|0x1485ee,-118|10|0xffffff,-100|28|0xffffff", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(500)
					tap(x,y)
					mSleep(500)
					toast("扫一扫",1)
					mSleep(1000)
					break
				end
			end

			while true do
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0x007aff, "7|15|0x007aff,17|-5|0x007aff,20|15|0x007aff,28|-199|0x000000,47|-201|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(500)
					tap(x,y)
					mSleep(500)
				end
                
                --微信版本7015
				mSleep(500)
				x,y = findMultiColorInRegionFuzzy(0xffffff, "-149|-28|0x07c160,-155|30|0x07c160,185|-23|0x07c160,183|19|0x07c160,84|-262|0x191919,181|-287|0x191919", 90, 0, 0, 750, 1334, { orient = 2 })
				if x ~= -1 then
					mSleep(500)
					tap(x,y)
					mSleep(500)
					for var=1, 6 do
						toast("等待30秒继续操作:"..(var - 1) * 5,1)
						mSleep(4500)
					end
					break
				end
				
				--微信版本709
				x,y = findMultiColorInRegionFuzzy(0xffffff, "-157|-26|0x07c160,-155|27|0x07c160,191|-28|0x07c160,188|17|0x07c160,-104|-483|0x000000,103|-481|0x000000,120|-484|0x000000", 90, 0, 0, 750, 1334, { orient = 2 })
                if x ~= -1 then
					mSleep(500)
					tap(x,y)
					mSleep(500)
					for var=1, 6 do
						toast("等待30秒继续操作:"..(var - 1) * 5,1)
						mSleep(4500)
					end
					break
				end
			end
		end
	end

	::over::
end

function model:main()
	local w,h = getScreenSize()
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["config"] = "save_001.dat",
		["timer"] = 100,
		views = {
			{
				["type"] = "Label",
				["text"] = "注册脚本",
				["size"] = 30,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "选择接码平台",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "兜兜",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "接码平台token",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入接码平台token",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "接码平台获取指定号码城市",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入获取指定号码的城市",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置注册密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入注册密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置二维码等待超时时间",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入二维码等待超时时间",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置需要添加的微信号，多个用-隔开",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入需要添加的微信号",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "提取62数据流程",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "注册提取62,直接提取62",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择辅助类型",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "手动辅助,二维码辅助",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "选择二维码辅助平台",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "极速,联盟",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "设置辅助平台辅助省份码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入需要设置辅助平台辅助省份码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "设置辅助平台辅助城市码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "请输入需要设置辅助平台辅助城市码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "是否需要添加好友",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "添加好友,不添加好友",
				["select"] = "0",  
				["countperline"] = "4",
			},
			{
				["type"] = "Label",
				["text"] = "是否需要打开扫一扫",
				["size"] = 20,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "需要,不需要",
				["select"] = "0",  
				["countperline"] = "4",
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, code_connection, getPhoneToken, getPhoneCity, loginPassword, overMin, add_wc_Id, getSixDataWay, fz_type, fz_connection, provCode, cityCode, addFriend, openScan = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	local m = TSVersions()
	local a = ts.version()
	local tp = getDeviceType()
	if m <= "1.3.3" then
		dialog("请使用 v1.3.3 及其以上版本 TSLib",0)
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
    
    if addFriend == "0" then
    	if add_wc_Id == "" or add_wc_Id == "默认值" then
    		dialog("添加的微信号不能为空，请重新运行脚本设置添加的微信号", 3)
    		luaExit()
    	end
    end

	if getSixDataWay == "0" then
		while true do
			self:getConfig()
			self:vpn()
			self:clear_App()
			self:loginAccount(code_connection,getPhoneToken,getPhoneCity,loginPassword,overMin,add_wc_Id,fz_type,fz_connection,provCode,cityCode,addFriend,openScan)
		end
	else
		self:getConfig()
		tb = readFile(userPath().."/res/phone_data.txt") 
		if table then 
			phone = tb[1]
			six_data = self:getData()
			mSleep(500)
			toast(six_data);
			mSleep(500)
			time = getNetTime()
			sj = os.date("%Y年%m月%d日%H点%M分%S秒",time)
			mSleep(200)
			toast(sj)       --或这样
			mSleep(500)
			file_path = userPath().."/res/six_data.txt"

			writeFileString(file_path,phone.."----qazwsx112233----"..six_data.."----"..sj,"a",1)
			
			self:pushAccountMess(phone,"qazwsx112233",six_data,sj)
			
			toast("62数据写入成功",1)
			mSleep(1000)
		else
			dialog("文件不存在")
		end
	end
end

model:main()
