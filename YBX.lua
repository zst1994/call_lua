require "TSLib"
local ts 				= require('ts')

--将指定文件中的内容按行读取
function readFile(path)
	local file = io.open(path,"r");
	if file then
		local _list = {};
		for l in file:lines() do
			table.insert(_list,l)
		end
		file:close();
		return _list
	end
end

--131 1341 9383
list = readFile(userPath().."/res/data.txt")
list1 = readFile(userPath().."/res/data1.txt")
data_sel = readFile(userPath().."/res/data_sel.txt")
nLog(#list.."\t\t\t"..#list1,1)
mSleep(1000)

--异常签收
while (true) do
	mSleep(250)
	if getColor(617,  633) == 0xff9b00 then
		break
	else
		mSleep(250)
		tap(606,  591)
		mSleep(250)
	end
end

--选择类型
while (true) do
	mSleep(250)
	if getColor(268,  737) == 0x797979 then
		mSleep(250)
		tap(268,  737)
		mSleep(250)
		break
	end
end

--自定义
while (true) do
	mSleep(250)
	if getColor(70, 1203) == 0x666666 then
		mSleep(250)
		tap(70, 1203)
		mSleep(250)
		break
	end
end

--输入自定义
while (true) do
	mSleep(250)
	if getColor(195,  930) == 0xefeff4 then
		mSleep(250)
		tap(193,  925)
		mSleep(1000)
		--伯恩厂信号屏蔽疫情原因封厂无法派件自取  请电3556615查询
		inputStr("请电3556615查询")
		mSleep(1000)
	end
	
	mSleep(250)
	if getColor(703,  501) == 0xf5d85f then
		mSleep(250)
		tap(703,  501)
		mSleep(250)
		break
	end
end

push = false
if #list > 0 then
	for i = tonumber(data_sel[1]) + 1, #list do
--	for i = 51, #list do
		nLog(i.."==="..list[i])
		if #(list[i]:atrim()) > 0 then
			mSleep(300)
			while true do
				--继续签收
				mSleep(250)
				if getColor(556,743) == 0xff3b30 or getColor(556,727) == 0xff3b30 then
					mSleep(250)
					tap(556,743)
					mSleep(250)
				end
				
				--重新扫描
				mSleep(250)
				if getColor(498,750) == 0x7aff then
					mSleep(250)
					tap(498,750)
					mSleep(250)
				end
				
				mSleep(250)
				if getColor(270,  505) == 0x000000 and getColor(265,  464) == 0xffffff then
					mSleep(250)
					tap(265,  464)
					mSleep(250)
					while (true) do
						mSleep(250)
						if getColor(431,  600) == 0xbdc0c7 then
							mSleep(250)
							tap(520,  598)
							mSleep(250)
							inputStr((list[i]):atrim())
							mSleep(250)
							push = true
						end
						
						if push then
							mSleep(260)
							if getColor(533,  716) == 0xfc9026 then
								mSleep(250)
								tap(533,  716)
								mSleep(250)
							end
							
							--继续签收
							mSleep(250)
							if getColor(556,743) == 0xff3b30 or getColor(556,727) == 0xff3b30 then
								mSleep(250)
								tap(556,743)
								mSleep(250)
							end
							
							--重新扫描
							mSleep(250)
							if getColor(498,750) == 0x7aff then
								mSleep(250)
								tap(498,750)
								mSleep(250)
							end
							
							mSleep(250)
							if getColor(270,  505) == 0x000000 and getColor(265,  464) == 0xffffff then
								break
							end
						end
					end
					break
				end
			end
			
			push = false
			if i == #list then
				mSleep(150)
				writeFileString(userPath().."/res/data_sel.txt","0","w",0) --将 string 内容存入文件，成功返回 true
				toast("数据推送完成",1)
				mSleep(2000)
			else
				mSleep(150)
				writeFileString(userPath().."/res/data_sel.txt",tostring(i),"w",0) --将 string 内容存入文件，成功返回 true
			end
		end
	end
end

--选择类型
mSleep(1000)
while true do
	mSleep(250)
	if getColor(356,  740) == 0x797979 then
		mSleep(250)
		tap(356,  740)
		mSleep(250)
		break
	end
end

--扫描件未到
while true do
	mSleep(250)
	if getColor(174, 1267) == 0x676767 and getColor(258, 1265) == 0x666666 then
		mSleep(250)
		tap(160, 1265)
		mSleep(1000)
		tap(685,  851)
		mSleep(1000)
		break
	else
		mSleep(250)
		moveTowards( 359, 1231, 90, 275)
		mSleep(2000)
	end
end

push = false
if #list1 > 0 then
	for i = tonumber(data_sel[1]) + 1, #list1 do
--	for i = 51, #list do
		nLog(i.."==="..list1[i])
		if #(list1[i]:atrim()) > 0 then
			mSleep(300)
			while true do
				--继续签收
				mSleep(250)
				if getColor(556,743) == 0xff3b30 or getColor(556,727) == 0xff3b30 then
					mSleep(250)
					tap(556,743)
					mSleep(250)
				end
				
				--重新扫描
				mSleep(250)
				if getColor(498,750) == 0x7aff then
					mSleep(250)
					tap(498,750)
					mSleep(250)
				end
				
				mSleep(250)
				if getColor(270,  505) == 0x000000 and getColor(265,  464) == 0xffffff then
					mSleep(250)
					tap(265,  464)
					mSleep(250)
					while (true) do
						mSleep(250)
						if getColor(431,  600) == 0xbdc0c7 then
							mSleep(250)
							tap(520,  598)
							mSleep(250)
							inputStr((list1[i]):atrim())
							mSleep(250)
							push = true
						end
						
						if push then
							mSleep(260)
							if getColor(533,  716) == 0xfc9026 then
								mSleep(250)
								tap(533,  716)
								mSleep(250)
							end
							
							--继续签收
							mSleep(250)
							if getColor(556,743) == 0xff3b30 or getColor(556,727) == 0xff3b30 then
								mSleep(250)
								tap(556,743)
								mSleep(250)
							end
							
							--重新扫描
							mSleep(250)
							if getColor(498,750) == 0x7aff then
								mSleep(250)
								tap(498,750)
								mSleep(250)
							end
							
							mSleep(250)
							if getColor(270,  505) == 0x000000 and getColor(265,  464) == 0xffffff then
								break
							end
						end
					end
					break
				end
			end
			
			push = false
			if i == #list1 then
				mSleep(150)
				writeFileString(userPath().."/res/data_sel.txt","0","w",0) --将 string 内容存入文件，成功返回 true
				dialog("数据推送完成",60)
			else
				mSleep(150)
				writeFileString(userPath().."/res/data_sel.txt",tostring(i),"w",0) --将 string 内容存入文件，成功返回 true
			end
		end
	end
end




--18521872214    cc123456

--list = readFile(userPath().."/res/data.txt")
--data_sel = readFile(userPath().."/res/data_sel.txt")
--nLog(#list.."\t\t\t",1)
--mSleep(1000)

----异常签收
--while (true) do
--	mSleep(250)
--	if getColor(606,  542) == 0xff3030 then
--		break
--	else
--		mSleep(250)
--		tap(606,  542)
--		mSleep(250)
--	end
--end

----选择类型
--while (true) do
--	mSleep(250)
--	if getColor(453,  723) == 0xaaaaaa then
--		mSleep(250)
--		tap(453,  723)
--		mSleep(250)
--		break
--	end
--end

----自定义
--while (true) do
--	mSleep(250)
--	if getColor(70, 1203) == 0x666666 then
--		mSleep(250)
--		tap(70, 1203)
--		mSleep(250)
--		break
--	end
--end

----输入自定义
--while (true) do
--	mSleep(250)
--	if getColor(193,  925) == 0xefeff4 then
--		mSleep(250)
--		tap(193,  925)
--		mSleep(1000)
--		--伯恩厂信号屏蔽疫情原因封厂无法派件自取  请电3556615查询
--		inputStr("伯恩厂信号屏蔽疫情原因封厂无法派件自取")
--		mSleep(1000)
--	end
	
--	mSleep(250)
--	if getColor(676,  497) == 0xf5d85f then
--		mSleep(250)
--		tap(676,  497)
--		mSleep(250)
--		break
--	end
--end

--if #list > 0 then
--	for i = tonumber(data_sel[1]) + 1, #list do
----	for i = 51, #list do
--		nLog(i.."==="..list[i])
--		mSleep(300)
--		while true do
--			--继续签收
--			mSleep(250)
--			if getColor(556,743) == 0xff3b30 or getColor(556,727) == 0xff3b30 then
--				mSleep(250)
--				tap(556,743)
--				mSleep(250)
--			end
			
--			--重新扫描
--			mSleep(250)
--			if getColor(498,750) == 0x7aff then
--				mSleep(250)
--				tap(498,750)
--				mSleep(250)
--			end
			
--			mSleep(250)
--			if getColor(72,644) == 0x333333 then
--				mSleep(250)
--				tap(523,641)
--				mSleep(250)
--				inputStr((list[i]):atrim())
--				mSleep(250)
--				break
--			end
--		end

--		while true do
--			mSleep(250)
--			if getColor(278,800) == 0xf1d24d then
--				mSleep(250)
--				tap(278,800)
--				mSleep(250)
--				break
--			end
--		end

--		if i == #list then
--			mSleep(150)
--			writeFileString(userPath().."/res/data_sel.txt","0","w",0) --将 string 内容存入文件，成功返回 true
--			toast("数据推送完成",1)
--			mSleep(2000)
--		else
--			mSleep(150)
--			writeFileString(userPath().."/res/data_sel.txt",tostring(i),"w",0) --将 string 内容存入文件，成功返回 true
--		end
--	end
--end