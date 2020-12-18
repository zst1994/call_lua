--陌陌-qq号码注册
require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

local model 			= {}

model.awz_bid 			= "com.superdev.AMG"
model.mm_bid           = "com.wemomo.momoappdemo1"

model.qqAcount         = ""
model.qqPassword       = ""


model.mm_accountId     = ""
model.renameRecordUrl  = ""

math.randomseed(getRndNum()) -- 随机种子初始化真随机数

--[[随机内容(UTF-8中文字符占3个字符)]]
function model:Rnd_Word(strs,i,Length)
	local ret=""
	local z
	if Length == nil then Length = 1 end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6)+State["随机常量"])  
	math.random(string.len(strs) / Length)
	for i=1, i do
		z = math.random(string.len(strs)/Length)
		ret = ret..string.sub(strs,(z * Length)-(Length - 1),(z * Length))
	end
	return ret
end

--遍历文件
function model:getList(path)
	local a = io.popen("ls "..path);
	local f = {};
	for l in a:lines() do
		table.insert(f,l)
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

	toast("滑动",1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 33, 503, 712, 892)
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
		dialog("文件不存在",1)
		mSleep(math.random(1000, 1500))
	end
end

function model:renameRecord(updateResultName)
	::runAgain1::
	runApp(self.awz_bid)
	mSleep(3 *1000)
	while true do
		mSleep(500)
		if getColor(596,443) == 0x6f7179 then
			local sz = require("sz")
			local http = require("szocket.http")
			local res, code = http.request(self.renameRecordUrl..updateResultName)
			if code == 200 then
				local resJson = sz.json.decode(res)
				local result = resJson.result
				if result == 1 then
					toast("修改成功",1)
					mSleep(1000)
				end
			end 
			break
		end

		flag = isFrontApp(self.awz_bid)
		if  flag == 0 then
			closeApp(self.awz_bid)
			mSleep(3000)
			goto runAgain1
		end
	end
end

function model:newMMApp()
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
			--AMG新机
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
end

function model:vpn()
	::get_vpn::
	old_data = getNetIP() --获取IP  
	toast(old_data,1)

	mSleep(math.random(500, 1500))
	flag = getVPNStatus()
	if flag.active then
		toast("打开状态",1)
		setVPNEnable(false)
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

	t1 = ts.ms() 
	setVPNEnable(true)
	mSleep(1000*math.random(2, 4))

	while true do
		new_data = getNetIP() --获取IP  
		toast(new_data,1)
		if new_data ~= old_data then
			mSleep(1000)
			toast("vpn链接成功")
			mSleep(1000)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 10 then
			setVPNEnable(false)
			setVPNEnable(false)
			setVPNEnable(false)
			mSleep(2000)
			toast("ip地址一样，重新打开",1)
			mSleep(2000)
			goto get_vpn
		end
	end
end

function model:getMMId(path)
	local a = io.popen("ls " .. path)
	local f = {}
	for l in a:lines() do
		b = string.find(l, 'u.(%d%d%d%d%d%d%d%d%d)_main.sqlite')
		if type(b) ~= "nil" then
			c = string.match(l, '%d%d%d%d%d%d%d%d%d')
			toast("陌陌id:"..c,1)
			mSleep(1000)
			return c
		end
	end
end

function model:mm(password, sex)
	runApp(self.mm_bid)
	mSleep(1000)
	t1 = ts.ms()

	while true do
		--同意
		mSleep(math.random(200, 300))
		if getColor(298,941) == 0x3bb3fa and getColor(520,941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376,944,4)
			mSleep(500)
		end

		--允许
		mSleep(math.random(200, 300))
		if getColor(533,770) == 0x7aff and getColor(495,771) == 0x7aff then
			mSleep(500)
			randomTap(495,771,4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0", 100, 0, 940, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x - 160, y, 4)
			mSleep(math.random(500, 700))
			toast("手机号登录注册",1)
			mSleep(1000)
			break
		end

		flag = isFrontApp(self.mm_bid)
		if  flag ==0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--同意
		mSleep(math.random(200, 300))
		if getColor(298,941) == 0x3bb3fa and getColor(520,941) == 0x3bb3fa then
			mSleep(500)
			randomTap(376,944,4)
			mSleep(500)
		end

		--允许
		mSleep(math.random(200, 300))
		if getColor(533,770) == 0x7aff and getColor(495,771) == 0x7aff then
			mSleep(500)
			randomTap(495,771,4)
			mSleep(500)
		end

		--手机号登录注册
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0xffffff,"73|2|0xffffff,222|-5|0xffffff,-201|-1|0,116|-63|0,421|-1|0,109|55|0,254|1|0,-27|-2|0", 100, 0, 940, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x - 160, y, 4)
			mSleep(math.random(500, 700))
		end

		--qq图标
		mSleep(math.random(200, 300))
		x, y = findMultiColorInRegionFuzzy(0x36b6ff,"3|-27|0x36b6ff,38|12|0x36b6ff,2|54|0x36b6ff,-40|16|0x36b6ff", 100, 0, 1040, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x, y, 4)
			mSleep(math.random(3500, 5700))
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120 then
			lua_restart()
		end
	end

	tab = readFile(userPath().."/res/qq.txt") 
	if tab then
		data = strSplit(string.gsub(tab[1],"%s+",""),"----")
		self.qqAcount = data[1]
		self.qqPassword = data[2]
	else
		dialog("文件不存在,请检查", 0)
		goto over
	end

	t1 = ts.ms()
	while (true) do
		mSleep(math.random(200, 300))
		if getColor(239,  629) == 0x12b7f5 then
			mSleep(500)
			randomTap(395,  357, 4)
			mSleep(500)
			inputKey(self.qqAcount)
			mSleep(500)
			randomTap(447,  477, 4)
			mSleep(500)
			inputKey(self.qqPassword)
			mSleep(500)
			randomTap(239,  629, 4)
			mSleep(500)
			table.remove(tab, 1)
			writeFile(userPath().."/res/qq.txt",tab,"w",1)
		end

		mSleep(math.random(200, 300))
		if getColor(116,  949) == 0x007aff then
			x_lens = self:moves()
			if tonumber(x_lens) > 0 then
				mSleep(math.random(500, 700))
				moveTowards( 116,  949, 10, x_len - 65)
				mSleep(3000)
				randomTap(370, 1024, 4)
				mSleep(500)
			else
				mSleep(math.random(500, 1000))
				randomTap(603, 1032,10)
				mSleep(math.random(3000, 6000))
			end
			break
		end

		flag = isFrontApp(self.mm_bid)
		if  flag ==0 then
			runApp(self.mm_bid)
			mSleep(3000)
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120 then
			lua_restart()
		end
	end
	
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

	Nickname = self:Rnd_Word(State["姓氏"],1,3)..self:Rnd_Word(State["名字"],1,3)

	t1 = ts.ms()
	while true do
		--填写资料
		mSleep(400)
		if getColor(253,195) == 0x323333 and getColor(346,246) == 0x323333 then
			mSleep(500)
			randomTap(437,380,4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
			break
		end

		mSleep(400)
		if getColor(253,195) == 0x323232 and getColor(346,246) == 0x323232 then
			mSleep(500)
			randomTap(437,380,4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
			break
		end

		mSleep(400)
		if getColor(150,194) == 0x343434 and getColor(350,169) == 0x343434 then
			mSleep(500)
			randomTap(437,292,4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		mSleep(400)
		x, y = findMultiColorInRegionFuzzy(0x323333,"17|0|0x323333,9|8|0x323333,0|17|0x323333,17|17|0x323333,2|6|0xffffff,18|7|0xffffff,10|17|0xffffff,9|-1|0xffffff", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x, y + 110, 4)
			mSleep(math.random(500, 700))
			toast("生日",1)
			mSleep(1000)
			break
		else
			mSleep(500)
			randomTap(x - 200, y, 4)
			mSleep(1000)
			inputStr(Nickname)
			mSleep(1000)
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
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
		if getColor(38,873) == 0x848484 and getColor(57,1012) == 0xffffff then
			mSleep(500)
			if topBottom == 1 then
				mSleep(500)
				for i = 1 , year do
					mSleep(500)
					randomTap(212,1045,4)
				end

				for i = 1 , month do
					mSleep(500)
					randomTap(363,1045,4)
				end

				for i = 1 , day do
					mSleep(500)
					randomTap(526,1045,4)
				end
			else
				mSleep(500)
				for i = 1 , year do
					mSleep(500)
					randomTap(212,1182,4)
				end

				for i = 1 , month do
					mSleep(500)
					randomTap(363,1182,4)
				end

				for i = 1 , day do
					mSleep(500)
					randomTap(526,1182,4)
				end
			end

			while true do
				mSleep(400)
				if getColor(432,732) == 0xffffff then
					mSleep(500)
					break
				else
					mSleep(500)
					randomTap(431,708,4)
					mSleep(1000)
				end
			end
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--性别
		mSleep(400)
		if getColor(252,826) == 0xd8d8d8 then
			mSleep(500)
			if sex == "0" then
				mSleep(500)
				randomTap(190,612,4)
				mSleep(500)
			else
				mSleep(500)
				randomTap(550,612,4)
				mSleep(500)
			end
		end

		--下一步
		mSleep(400)
		if getColor(470,842) == 0x18d9f1 then
			mSleep(500)
			randomTap(470,842,4)
			mSleep(500)
			toast("下一步",1)
			mSleep(1000)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		mSleep(400)
		x, y = findMultiColorInRegionFuzzy(0xf6f6f6,"-75|-88|0x18d9f1,-18|-44|0x18d9f1,47|-57|0x18d9f1,92|-113|0xf6f6f6,-8|-187|0xf6f6f6,-131|367|0xd8d8d8,144|374|0xd8d8d8", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(math.random(500, 700))
			randomTap(x, y, 4)
			mSleep(math.random(500, 700))
			toast("上传照片",1)
			mSleep(1000)
		end

		--相册
		mSleep(400)
		if getColor(342,1013) == 0x7aff and getColor(401,1010) == 0x7aff then
			mSleep(500)
			randomTap(401,1010,4)
			mSleep(500)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--相册
		mSleep(400)
		if getColor(653,83) == 0x7aff and getColor(388,86) == 0 then
			mSleep(500)
			randomTap(538,221,4)
			mSleep(500)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--相册:时刻
		mSleep(400)
		if getColor(653,83) == 0x7aff and getColor(397,78) == 0 then
			mSleep(500)
			randomTap(90,328,4)
			mSleep(500)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--相册:时刻
		mSleep(400)
		if getColor(244,1015) == 0x18d9f1 and getColor(536,1000) == 0x18d9f1 then
			mSleep(500)
			randomTap(536,1000,4)
			mSleep(500)
			break
		else
			mSleep(500)
			randomTap(689,1254,4)
			mSleep(500)
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--跳过他们在附近
		mSleep(400)
		if getColor(683,83) == 0x323333 and getColor(712,80) == 0x323333 then
			mSleep(500)
			randomTap(689,80,4)
			mSleep(500)
		end

		--跳过屏蔽通讯录
		mSleep(400)
		if getColor(491,813) == 0x7aff and getColor(520,827) == 0x7aff 
		or getColor(481,808) == 0x57cff and getColor(520,815) == 0x57cff 
		or getColor(481,808) == 0x47cff and getColor(520,815) == 0x47cff then
			mSleep(500)
			randomTap(237,827,4)
			mSleep(500)
		end

		--跳过屏蔽通讯录
		mSleep(400)
		x, y = findMultiColorInRegionFuzzy(0x10000,"19|12|0x10000,71|8|0x10000,119|-5|0x10000", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(237,827,4)
			mSleep(500)
		end

		--想访问通讯录
		mSleep(400)
		if getColor(499,819) == 0x7aff and getColor(517,831) == 0x7aff then
			mSleep(500)
			randomTap(517,831,4)
			mSleep(500)
		end

		--首页
		mSleep(400)
		if getColor(64,1312) == 0xfc9e1 and getColor(85,1304) == 0xfc9e1 then
			mSleep(500)
			randomTap(672,1287,4)
			mSleep(500)
		end

		--立即展示
		mSleep(400)
		x, y = findMultiColorInRegionFuzzy(0xd0d0d3,"-133|616|0x3ab3fb,-263|580|0x3ab3fb,-271|648|0x3ab3fb,-311|624|0xffffff,-292|614|0xffffff,-277|611|0xffffff,-253|604|0xffffff,-224|616|0xffffff,-422|619|0x3ab3fb", 90, 0, 0, 749, 1333)
		if x~=-1 and y~=-1 then
			mSleep(500)
			randomTap(x,y,4)
			mSleep(500)
			toast("立即展示",1)
			mSleep(1000)
		end

		--更多
		mSleep(400)
		if getColor(665,1310) == 0xf6aa00 then
			mSleep(500)
			randomTap(693,230,4)
			mSleep(500)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--编辑
		mSleep(400)
		if getColor(651,80) == 0x323333 and getColor(621,82) == 0xffffff then
			mSleep(200)
			while true do
				mSleep(300)
				x, y = findMultiColorInRegionFuzzy(0x323333,"2|19|0x323333,0|8|0xffffff,-15|112|0x323333,3|126|0x323333,18|109|0x323333,-7|113|0xffffff,-1|227|0x323333,2|217|0xffffff", 100, 0, 0, 125, 1333)
				if x~=-1 and y~=-1 then
					mSleep(500)
					touchDown(1, x + 123,y + 209)
					mSleep(500)
					while true do
						mSleep(500)
						if getColor(x + 123,y + 159) == 0x2a2a2a then
							mSleep(500)
							touchUp(1, x + 123,y + 209)
							mSleep(500)
							randomTap(x + 123,y + 159,3)
							mSleep(500)
							break
						else
							mSleep(1000)
						end

						t2 = ts.ms() 

						if os.difftime (t2, t1) > 120000 then
							lua_restart()
						end
					end
					mSleep(500)
					randomTap(50,82,4)
					mSleep(500)
					self.mm_accountId = readPasteboard()
					toast(self.mm_accountId,1)
					mSleep(1000)
					break
				else
					mSleep(500)
					moveTowards(379,884,90,400,10)
					mSleep(3000)
				end

				--自拍狂魔：下次再说
				mSleep(400)
				if getColor(180,1022) == 0x3bb3fa and getColor(561,1040) == 0x3bb3fa then
					mSleep(500)
					randomTap(369,1129,4)
					mSleep(500)
				end

				t2 = ts.ms() 

				if os.difftime (t2, t1) > 120000 then
					lua_restart()
				end
			end
		end

		--自拍狂魔：下次再说
		mSleep(400)
		if getColor(180,1022) == 0x3bb3fa and getColor(561,1040) == 0x3bb3fa then
			mSleep(500)
			randomTap(369,1129,4)
			mSleep(500)
		end

		--更多
		mSleep(400)
		if getColor(665,1310) == 0xf6aa00 then
			mSleep(500)
			randomTap(693,80,4)
			mSleep(500)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

	t1 = ts.ms()
	while true do
		--设置
		mSleep(400)
		if getColor(346,88) == 0 and getColor(392,86) == 0 then
			mSleep(500)
			randomTap(577,209,4)
			mSleep(500)
		end

		--.密码修改    2.密码修改  图标没加载出来    3.密码修改  图标加载一个
		mSleep(400) 
		if getColor(37,684) == 0x3cc9ff and getColor(39,771) == 0xff5075 
		or getColor(101,683) == 0x323232 and getColor(73,679) == 0x323232 
		or getColor(37,684) == 0x3fc9ff and getColor(46,773) == 0x343434 then
			mSleep(500)
			randomTap(617,681,4)
			mSleep(500)
		end

		--重置密码
		mSleep(400)
		if getColor(642,87) == 0x3bb3fa and getColor(687,88) == 0x3bb3fa then
			mSleep(500)
			randomTap(396,194,4)
			mSleep(500)
			while true do
				mSleep(400)
				if getColor(712,193) == 0xcccccc then
					break
				else
					mSleep(500)
					inputStr(password)
					mSleep(1000)
				end

				t2 = ts.ms() 

				if os.difftime (t2, t1) > 120000 then
					lua_restart()
				end
			end

			mSleep(500)
			randomTap(396,279,4)
			mSleep(500)
			while true do
				mSleep(400)
				if getColor(712,281) == 0xcccccc then
					break
				else
					mSleep(500)
					inputStr(password)
					mSleep(1000)
				end

				t2 = ts.ms() 

				if os.difftime (t2, t1) > 120000 then
					lua_restart()
				end
			end
			mSleep(500)
			randomTap(666,81,4)
			mSleep(5000)
			break
		end

		t2 = ts.ms() 

		if os.difftime (t2, t1) > 120000 then
			lua_restart()
		end
	end

--	self:renameRecord(self.mm_accountId.."/"..self.phone)
	mm_id = self:getMMId(appDataPath(self.mm_bid).."/Documents")
	dialog(mm_id, time)

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
				["text"] = "陌陌脚本",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "照片文件夹路径是在触动res下，文件夹名字是picFile",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "号码文件路径是在触动res下，文件名字是phoneNum.txt",
				["size"] = 20,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "====================",
				["size"] = 15,
				["align"] = "center",
				["color"] = "255,0,0",
			},
			{
				["type"] = "Label",
				["text"] = "设置密码",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "Edit",        
				["prompt"] = "输入密码",
				["text"] = "默认值",       
			},
			{
				["type"] = "Label",
				["text"] = "性别选择",
				["size"] = 15,
				["align"] = "center",
				["color"] = "0,0,255",
			},
			{
				["type"] = "RadioGroup",                    
				["list"] = "女生,男生",
				["select"] = "0",  
				["countperline"] = "4",
			},
		}
	}

	local MyJsonString = json.encode(MyTable)

	ret, password, sex = showUI(MyJsonString)
	if ret == 0 then
		dialog("取消运行脚本", 3)
		luaExit()
	end

	while true do
		closeApp(self.awz_bid, 0)
		closeApp(self.mm_bid, 0)
		setVPNEnable(false)
		mSleep(1000)
		self:vpn()
		self:newMMApp()
		self:mm(password,sex)
	end
end

model:main()







