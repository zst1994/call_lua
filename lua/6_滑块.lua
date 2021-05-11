require "TSLib"
local ts 				= require('ts')
local json 				= ts.json

function file_exists(file_name)
	local f = io.open(file_name, "r")
	return f ~= nil and f:close()
end

function moves()
	mns = 80
	mnm = "0|9|0,0|19|0,0|60|0,0|84|0,84|84|0,84|-1|0,61|-1|0,23|-1|0,23|84|0"

	toast("滑动",1)
	mSleep(math.random(500, 700))
	keepScreen(true)
	mSleep(1000)
	snapshot("test_3.jpg", 30, 244, 719, 639)
	mSleep(500)
	ts.img.binaryzationImg(userPath().."/res/test_3.jpg",mns)
	if file_exists(userPath().."/res/tmp.jpg") then
		toast("正在计算",1)
		mSleep(200)
		keepScreen(false)
		point = ts.imgFindColor(userPath().."/res/tmp.jpg", 0, mnm, 300, 4, 749, 1333);   
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

::getAgain::
x_lens = moves()
if tonumber(x_lens) > 0 then
	mSleep(math.random(500, 700))
	moveTowards(92,  700, 0, x_len - 65)
	mSleep(3000)
else
	mSleep(math.random(500, 1000))
	randomsTap(588, 693,10)
	mSleep(math.random(3000, 6000))
	toast("重新识别",1)
	mSleep(1000)
	goto getAgain
end