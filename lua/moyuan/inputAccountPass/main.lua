--输入Q账号和密码
require "TSLib"

tab = readFile(userPath().."/res/q_acount.txt") 
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
		writeFile(userPath().."/res/q_acount.txt",tab,"w",1)
	end
else
	dialog("文件不存在")
end



