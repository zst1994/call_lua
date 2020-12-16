require "TSLib"--使用本函数库必须在脚本开头引用并将文件放到设备 lua 目录下

tab = readFile(userPath().."/res/qq.txt") 
if tab then
	data = strSplit(string.gsub(tab[1],"%s+",""),"----")
	account = data[1]
	pass = data[2]

	mSleep(500)
	if getColor(239,  629) == 0x12b7f5 then
		mSleep(500)
		randomTap(395,  357, 4)
		mSleep(500)
		inputKey(account)
		mSleep(500)
		randomTap(447,  477, 4)
		mSleep(500)
		inputKey(pass)
		mSleep(500)
		randomTap(239,  629, 4)
		mSleep(500)
		table.remove(tab, 1)
		writeFile(userPath().."/res/qq.txt",tab,"w",1)
	end
else
	dialog("文件不存在")
end
