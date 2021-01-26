--陌陌

--rets, input1,input2,input3,input4,input5,input6,input7,input8,input9,input10,input11,input12,input13,input14,input15,input16,input17= showUI("{\"style\":\"default\","
--	.."\"width\":\"2000\","
--	.."\"height\":\"2000\","
--	.."\"config\":\"陌陌.dat\","
--	.."\"timer\":\"99\","
--	.."\"orient\":\"0\","
--	.."\"title\":\"提供一手线报免费用脚本\","
--	.."\"cancelname\":\"取消\","
--	.."\"okname\":\"开始\","  
--	.."\"views\":["
--	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
--	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
--	.."{\"type\":\"Label\",\"text\":\"\",\"size\":20,\"align\":\"center\",\"color\":\"0,123,123\"},"
--	.."{\"type\":\"CheckBoxGroup\",\"list\":\"蜜蜂通道1,其他授权通道,修改名字\",\"select\":\"2\"},"-------------------1
--	.."{\"type\":\"Label\",\"text\":\"--年--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------2
--	.."{\"type\":\"Edit\",\"prompt\":\"年\",\"text\":\"\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\"},"-------------------2
--	.."{\"type\":\"Label\",\"text\":\"--月--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------3
--	.."{\"type\":\"Edit\",\"prompt\":\"\",\"text\":\"\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\"},"-------------------3
--	.."{\"type\":\"Label\",\"text\":\"--号段--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------4
--	.."{\"type\":\"Edit\",\"prompt\":\"6\",\"text\":\"45\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------4
--	.."{\"type\":\"CheckBoxGroup\",\"list\":\"aa,bb\",\"select\":\"0\"},"-------------------5
--	.."{\"type\":\"RadioGroup\",\"list\":\"a,b,c\",\"select\":\"0\"},"-------------------6
--	.."{\"type\":\"Label\",\"text\":\"--aaa--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------7
--	.."{\"type\":\"Edit\",\"prompt\":\"680\",\"text\":\"4000\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------7
--	.."{\"type\":\"Label\",\"text\":\"--注册多少个--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------8
--	.."{\"type\":\"Edit\",\"prompt\":\"请填写数字\",\"text\":\"30\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------8
--	.."{\"type\":\"Label\",\"text\":\"--运行次数--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------9
--	.."{\"type\":\"Edit\",\"prompt\":\"请填写数字\",\"text\":\"30\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"number\"},"-------------------9
--	.."{\"type\":\"Label\",\"text\":\"--邀请码--\",\"size\":15,\"align\":\"center\",\"color\":\"255,0,0\"},"-------------------10
--	.."{\"type\":\"Edit\",\"prompt\":\"请填写邀请码\",\"text\":\"30\",\"size\":15,\"align\":\"left\",\"color\":\"255,0,0\",\"kbtype\":\"default\"},"-------------------10
--	.."]}")

--writePasteboard(input10)
--str = readPasteboard()

require "TSLib"
local ts = require("ts")
local json = ts.json


qqList = {}

phoneNum = ""
codeUrl = ""
yzm = ""

function timeOutRestart(t1)
	t2 = ts.ms()

	if os.difftime(t2, t1) > 30 then
		return true
	else
		return false
	end
end

function getPhoneCodeUrl_1()
	qqList = readFile(userPath() .. "/res/phone_code.txt")
	if qqList then
		if #qqList > 0 then
			data = strSplit(string.gsub(qqList[1], "%s+", ""), "|")
			phoneNum = data[1]
			codeUrl = data[2]
			toast("获取账号成功",1)
			mSleep(1000)
			table.remove(qqList, 1)
			writeFile(userPath() .. "/res/phone_code.txt", qqList, "w", 1)
			mSleep(1000)
		else
			dialog("没账号了", 0)
			luaExit()
		end
	else
		dialog("文件不存在,请检查", 0)
		lua_exit()
	end
end

function getCode_1()
	t1 = ts.ms()
	::get_code::
	status_resp, header_resp,body_resp = ts.httpGet("http://139.5.177.41/napi/view?token=" .. codeUrl)
	if status_resp == 200 then
		tmp = json.decode(body_resp)
		if tmp.flag == "true" or tmp.flag == true then      --http://refresh.rola-ip.co接口返回
			yzm = string.match(tmp.message,"%d%d%d%d%d%d")
			return true
		else
			toast("获取验证码失败",1)
			mSleep(3000)
			if timeOutRestart(t1) then
				return false
			else
				goto get_code
			end
		end
	else
		toast("获取验证码失败",1)
		mSleep(3000)
		if timeOutRestart(t1) then
			return false
		else
			goto get_code
		end
	end
end

function getPhoneCodeUrl()
	qqList = readFile(userPath() .. "/res/phone_code.txt")
	if qqList then
		if #qqList > 0 then
			data = strSplit(string.gsub(qqList[1], "%s+", ""), "----")
			phoneNum = data[1]
			codeUrl = data[2]
			toast("获取账号成功",1)
			mSleep(1000)
			table.remove(qqList, 1)
			writeFile(userPath() .. "/res/phone_code.txt", qqList, "w", 1)
			mSleep(1000)
		else
			dialog("没账号了", 0)
			luaExit()
		end
	else
		dialog("文件不存在,请检查", 0)
		lua_exit()
	end
end

function getCode()
	t1 = ts.ms()
	::get_code::
	status_resp, header_resp,body_resp = ts.httpGet(codeUrl)
	if status_resp == 200 then
		codeBack = string.match(body_resp,"陌陌科技")
		if type(codeBack) ~= "nil" then
			yzm = string.match(body_resp,"%d%d%d%d%d%d")
			return true
		else
			tmp = json.decode(body_resp)
			if tmp.status == "fail" then      --http://refresh.rola-ip.co接口返回
				toast("暂时获取不到验证码"..tmp.message,1)
				mSleep(3000)
				if timeOutRestart(t1) then
					return false
				else
					goto get_code
				end
			else
				toast("获取验证码失败",1)
				mSleep(3000)
				if timeOutRestart(t1) then
					return false
				else
					goto get_code
				end
			end
		end
	else
		toast("获取验证码失败",1)
		mSleep(3000)
		if timeOutRestart(t1) then
			return false
		else
			goto get_code
		end
	end
end

function mm()
	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x9fa3aa, "38|-7|0xffffff,-197|162|0xd8d8d8,66|126|0xd8d8d8,49|216|0xd8d8d8,326|169|0xd8d8d8,85|169|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(500)
			tap(x,y)
			mSleep(500)
			inputStr(phoneNum)
			mSleep(500)
		end

		mSleep(200)
		if getColor(231,  520) == 0x18d9f1 and getColor(543,  510) == 0x18d9f1 then
			mSleep(500)
			tap(543,  510)
			mSleep(500)
			break
		end
	end

	while (true) do
		mSleep(200)
		x,y = findMultiColorInRegionFuzzy( 0x18d9f1, "29|-1|0x18d9f1,33|129|0xd8d8d8,517|137|0xd8d8d8,285|83|0xd8d8d8,280|166|0xd8d8d8,271|126|0xffffff,181|124|0xffffff", 90, 0, 0, 749, 1333)
		if x ~= -1 and y ~= -1 then
			mSleep(200)
			if getCode() then
				mSleep(200)
				for i = 1, #(yzm) do
					mSleep(300)
					num = string.sub(yzm,i,i)
					if num == "0" then
						mSleep(300)
						tap(373, 1281)
					elseif num == "1" then
						mSleep(300)
						tap(132,  961)
					elseif num == "2" then
						mSleep(300)
						tap(377,  957)
					elseif num == "3" then
						mSleep(300)
						tap(634,  956)
					elseif num == "4" then
						mSleep(300)
						tap(128, 1073)
					elseif num == "5" then
						mSleep(300)
						tap(374, 1061)
					elseif num == "6" then
						mSleep(300)
						tap(628, 1065)
					elseif num == "7" then
						mSleep(300)
						tap(129, 1165)
					elseif num == "8" then
						mSleep(300)
						tap(378, 1170)
					elseif num == "9" then
						mSleep(300)
						tap(633, 1164)
					end
				end
				return true
			else
				return false
			end
		end
	end
end

function main()
	::getPhoneAgain::
	getPhoneCodeUrl()

	if mm() then
		toast("进行下一步操作",1)
	else
		mSleep(500)
		tap(56,   83)
		mSleep(500)
		while (true) do
			mSleep(200)
			if getColor(231,  520) == 0x18d9f1 and getColor(543,  510) == 0x18d9f1 then
				mSleep(500)
				tap(519,  348)
				mSleep(500)
				for var= 1, 20 do
					mSleep(200)
					keyDown("DeleteOrBackspace")
					keyUp("DeleteOrBackspace")   
				end

				::write::
				mSleep(500)
				bool = writeFileString(userPath().."/res/phone_code_error",phoneNum .. "----" .. codeUrl, "a", 1) --将 string 内容存入文件，成功返回 true
				if bool then
					toast("获取不到验证码数据写入成功",1)
				else
					toast("获取不到验证码数据写入失败，重新写入",1)
					goto write
				end
				break
			end
		end
		goto getPhoneAgain
	end
end

main()
