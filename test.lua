local ts = require("ts")
local json = ts.json --使用 JSON 模組前必須插入這一句
local sz = require("sz")
local socket = require ("socket");
local http = require("szocket.http")
require("TSLib")


--local sz = require("sz")
--local cjson = sz.json
--local http = sz.i82.http
--headers = {}
--headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36'
--headers['Referer'] = 'https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/'
--headers_send = cjson.encode(headers)
--dialog(headers_send,0)
--status_resp, headers_resp, body_resp = http.get("https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/",5,headers_send)
--if status_resp ~= nil then
--    dialog(status_resp,0)
--    dialog(headers_resp,0)
--    if status_resp == 200 then
--        dialog(string.len(body_resp),0)
--    end
--end



function HttpUtil()
	local self = {}
	-- get请求
	self.httpget = function(u)
		local t = {}
		local r, c, h = http.request{
			url = u,
			-- 20160708 如果传入的是table的话， 就需要用一个容器来接收http body的内容， 也就是sink那个参数
			sink = ltn12.sink.table(t)}
		for k,v in pairs(h) do
			dialog(k..v, time)
		end
		
		return r, c, h, table.concat(t)
	end

	self.httpPost = function(u,inParam)
		-- 参考 http://www.stutostu.com/?p=1285
--        ngx.log(ngx.WARN,"url:"..u)
--        ngx.log(ngx.WARN,"inParam:"..inParam)
		local response_body = {}
		local post_data = inParam
		local res, code = http.request{
			url = u,
			method = "POST",
			headers =
			{
				["Content-Type"] = "application/json",
				["Content-Length"] = #post_data,
			},
			source = ltn12.source.string(post_data),
			sink = ltn12.sink.table(response_body)
		}
		res = table.concat(response_body)
--		ngx.log(ngx.WARN,"res:"..res)
--		ngx.log(ngx.WARN,"code:"..code)

		return res,code

	end

	return self
end


--local httputil = HttpUtil()
--local url = "https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/"
--local resStr --响应结果
--local res,code = httputil.httpget(url)
--dialog(res..code, time)
--if code ~= 301 then
----	ngx.log(ngx.WARN,"非200状态，code:"..code)
--	return resStr
--end
--resStr = res
--dialog(resStr, 0)

 
function http.get(u)
   local t = {}
   local r, c, h = http.request{
      url = u,
      sink = ltn12.sink.table(t)}
   return r, c, h, table.concat(t)
end
 
url = "https://share.huoshan.com/hotsoon/s/QKAE4BhV8b8/"
r,c,h,body=http.get(url)
if c~= 301 then
    return
end
dialog(body)


--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["base64"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/decode", header_send,body_send)
--nLog(code..body_resp, time)




--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["userKey"] = "1875b88a1fd7484abfd531ddca810422",
----	["qrCodeImg"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--	["qrCodeUrl"] = urlEncoder("https://weixin110.qq.com/s/3ae2f306ac7"),
--	["phone"] = "13511111111" ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send,body_send)
--nLog(body_resp)
--dialog(body_resp, time)


--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded",
--}
--body_send = {
--	["userKey"] = "1875b88a1fd7484abfd531ddca810422",
----	["qrCodeImg"] = urlEncoder("data:image/png;base64,"..readFileBase64(userPath().."/res/222.png")),
--	["orderId"] = "200828112247742NCTFO",
--	["status"] = 2,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://api.qianxing666.com/api/open-api/orders/mark", header_send,body_send)
--nLog(body_resp)
--dialog(body_resp, time)



--nLog(urlDecoder("data%3aimage%2fpng%3bbase64%2ciVBORw0KGgoAAAANSUhEUgAAAQQAAAEECAYAAADOCEoKAAAbU0lEQVR4Xu2d7XqbOQ5Dm%2fu%2f6O7jzmzz0STnyMJLyx3sX5EECFKw7Gm7Lz9%2f%2fvz5o%2f%2brAlWgCvz48eOlhtA9qAJV4P8K1BC6C1WgCvxWoIbQZagCVaCG0B2oAlXgTwX6QuhWVIEq0BdCd6AKVIG%2bELoDVaAKfKMAfmV4eXn5zwhIfySDtKD8KSGJ5xSPXZwJPf8WrYzWRs8awhslSTBaHso3Q0vEEM8ExkSNCT3%2fFq3MPIyeNYQagtmlh8SYBd4lVkN4r2ANoYawe6cuy68hZKU1etYQagjZrQtWMwu8C9cXQl8IX%2b4QLSAtD%2bXvLq%2fNJ562zqPjJvT8W7QyszJ69oXQF4LZpYfEmAXeJVZD6AuhL4TdWzSUX0PICm303H4hGJBsW%2fdVM58E1AvVoHzDnDBMjUTMbi%2bmD8JI1CAtJjCIQ%2bqceiG9bzxqCId9ZaChppaH6pjl%2ba6G6YMwEjWozwkM4pA6p15I7xrCh0mQYAnBafiEQfmpc9KCcEwfhJGoMcGTMKbOSS%2fSu4ZQQ7j79xRaclrOWz4taKLGBE%2fCmDonvUjvGkINoYYg%2fq6OuUhTl37na5rpo78h9DeET3fMLM%2fOcvaFkLeQvhAWNCWxEgu6e4l%2bPdnEJ9ZC23eH7vZi%2biCMRA0SYAKDOKTOqRfSu18Z%2bpWhXxmEAZuLlLrUO3VqCAvqkVh9IbwXc%2fcSTOhtZkYrkuBJGFPn1IuZ6chvCEQ0IRg1azgkalAvhEH55msFYRgtDI8TYqhX4mi0IAxTg3jQOXFI7MXYV4YTBDMcSHRTIzFYqkE8JvogjlPn1CvxIC3NK8TUIB50bvokHqoG%2fT83RUDE9zQShM6pWepjavDEk%2fpMfBIYLQyPE2J29TRaEIapsasVcUjsRV8IH6ZEoicGTxhmcYgHYVC%2b4XBKDPVKPI0WhGFqEA86Jw41hAsuM4meGDxh0GIkBp%2fow%2fCciNnV02hBGKbGrhbEIbEXfSFcYCo0eDNYqkELSBiUT%2fgnnVOvxNVoQRimBvGgc%2bJQQ7jgMpPoicETBi1GYvCJPgzPiZhdPY0WhGFq7GpBHBJ70RfCBaZCgzeDpRq0gIRB%2bYR%2f0jn1SlyNFoRhahAPOicONYQLLjOJ%2fiyDp%2bVKnJNWBoP0TGAQD%2bJwyycepgbxoHPiUEOoIdAOXXpuFpQI0EVKYOxyqCF8UDAxNKpBQzPntDyGQ6KG4fpdDHEwnwS7HEy%2b4Ul1aCYJjF0ONYQawpc7RAtMy2fOzSWY4EFcDU%2bqQX0kMHY51BBqCDUEukXie7UogX%2fVu4bwqqLRImGw%2fctNbzaXRCfBzSWgGOLQrwyk4Nq5mSnNxNRYY%2fVnNHEwe6Fq9O8yeBd%2blsHvLp%2fJN8tFdUjPBMYuh35l6FeGfmWgW9SvDO8UImMTcmKIMUfioWr0heBfCDQ1Ggjlm08j8zQ0OLsxtFxTWuz2YXhO9Ep9EAezF6pGDaGGQMv42Tktl7lohEsYlG%2fODU%2fiYWoYLt%2fFEIcawgf1SDAzNKpBQzUYVMNwSOAQDzonngmOhEEczbnhSTxMDcOlhrCr0pv8xNCoBtFNLIbhkMChXuiceCY4EgZxNOeGJ%2fEwNQyXGsKuSjWEoIJrpSYuCWGsMf482lxm4mFq7HIlDv3K0K8Muzu2lU8LmrgkhLHVwL%2fJhifxMDV2uRKHGkINYXfHtvJpQROXhDC2GqghfCpf%2f6TiwtcOWsCpS5DAoV7onC5rgiNhEEdzbngSD1PDcOlvCLsqLVxmMzQaPNE1GFTDcEjgEA86J54JjoRBHM254Uk8TA3D5T9jCLtiJPLN0J5l8KQH9Up9Uv2pc%2brD8KBeDQbVMDwmYqgX08fIV4YJMQiDxLrlk2CmBvGgc%2bJA%2bbdz4pnAMDx2Y6gPU596NRhUw%2fCYiKFeTB81hPDXjt3Bm6ERRmIxCGPinPowHEhPg0E1DI%2bJGOrF9FFDqCFM7OpdGLTgpihdAoNBNQyPiRjqxfRRQ6ghTOzqXRi04KYoXQKDQTUMj4kY6sX0UUOoIUzs6l0YtOCmKF0Cg0E1DI%2bJGOrF9FFDqCFM7OpdGLTgpihdAoNBNQyPiRjqxfRRQ6ghTOzqXRi04KYoXQKDQTUMj4kY6sX0sW0IE41OYZBgEcFfXr5thzjcknd5UP4Ng3hQDcpP9JGoQX1M7d4EjprJ7j%2bQMtHIFAYJRstD%2bYkFTtSgPmoIUxs3i6P2s4bwOhQSjC4S5Scuc6IG9VFDmL2oU2hqP2sINYTPFpKWh0yF8hPGlqhBfUxd1gkcNZMaQg2hhjBxHR%2bPUUNYnAEJRp8mlJ%2f4REvUoD76lWFxcZ4kXO1nXwh9IfSF8CQ3epNmDWFRQBKMPlkpP%2fHpnqhBffSFsLg4TxKu9rMvhL4Q%2bkJ4khu9STNiCJscmv5BAfPpTKKZwVINOk%2fwJIyJ8wmtJvqYwsA%2fqThF5L%2bCk7hoE0ue4HnCTCe0OqHPFIcaQkpJWSdx0SaWPMFTSnJp2IRWlzYwXLyGMC04%2fF0GQ2diyWsIZhJ%2fX0wNYXimiYtWQ%2fBDm9DKszk%2fsoYwPKMawqzgNYQ1vWsIa3ptR9cQtiVcKlBDWJLrRw1hTa%2ft6BrCtoRLBWoIS3KxIZywwAkORpaJ5aFeDIfdGpRvtJqImdDC9EF6JXgaHrsxiufEn1Q0RL5rlgayK9T%2f83d5Gh7Ui%2bGwW4PyTR8TMRNamD5IrwRPw2M3RvGsIbzKbATbHcrEclEfxGG3x1Q%2b9XHDoV5MDeKbwKAaxCFxbrTA3xASjRgifSH8o4DRimZCNSg%2fsXyJGtRHDWFNZaVnXwh9Iayt1Vy0WuDAP1pLHZGBJngSh8S54llDqCEklu2KGmqBawhaeqVnDaGGoDdqOFAtcA1BT0XpWUOoIeiNGg5UC1xD0FNReu4aggLZ%2fAs9BkOr8k0gfVckjCmexCNxTlpQr5RvOBJG4kfFBE%2fTywkxSs8awuuodpfDCH7CYhgOpAX1SvmGA2HUEIyKay%2fg7f%2fsmBgatWUwqIY5313iKZ6ml90Y0oJ6pXzDjzBqCEbFGsKaSm%2bid5fYLPDd5IYTSQvqlfJNO4RRQzAq1hDWVKohfKoXXWi6rJRvhkQYNQSjYg1hTaUaQg3h7o15rkRlsP1R8XWou59qRvBnWSHSgnqlfKMDYfSFYFTsC2FNpb4Q%2bkK4e2OeK1EZbF8IfSF8ttb0CU%2fLRfnmKhFGXwhGxQNfCER7YnkMBi2gqUG90jlxoPzUOfWa4JnAoBqkh%2bmDMEwN4pE4T%2fAc%2bXMI1Cw1Qvm3cxqKwUjUMFy%2fiyEOu%2fVtPumV4JnAoBrUr%2bmDMEwN4pE4T%2fCsIbyZBA2WBE8MlTgkMEwN6jXBM4FBNahX0wdhmBrEI3Ge4FlDqCF8uouJ5aIlT2BQDeJgLjNhmBrEI3Ge4FlDqCHUEOA2Ji5a4sJTjQTPGkINoYZQQ%2fitQA2hhlBDqCHUED7bAfouSE8yetKZc%2bJgaiRiqNcEzwQG1SAtTB%2bEYWoQj8R5gie%2bECaIEoYRPCEG8aBz4nDLN73s4hCG4UkcTsAgjuY8oYXBoZhT9Kwh0KQWzs1y0eANHOEQBuUbDidgGJ4Uk9CCMMz5KXrWEMy0ZIxZLhq8gSIcwqB8w%2bEEDMOTYhJaEIY5P0XPGoKZlowxy0WDN1CEQxiUbzicgGF4UkxCC8Iw56foWUMw05IxZrlo8AaKcAiD8g2HEzAMT4pJaEEY5vwUPWsIZloyxiwXDd5AEQ5hUL7hcAKG4UkxCS0Iw5yfomcNwUxLxpjlosEbKMIhDMo3HE7AMDwpJqEFYZjzU%2fSsIZhpyRizXDR4A0U4hEH5hsMJGIYnxSS0IAxzfoqeNQQzLRljlosGb6AIhzAo33A4AcPwpJiEFoRhzk%2fRc8QQjCDfxZihJQTdrUH5RoepXokL9WJ4TmDs8qT8Ww%2fUq6lBWtA5cbjlJ3jUEN5MggSloVA%2bDd0snxk88TQ8qJdTMHZ5Ur6ZialhNL%2f6Q9FwqCHUED7dE1ryGsKrbKSVuYgUY%2fRO8Kgh1BBqCHAb6TImLmINgRR4c04DST2jabDEg%2fJNy4SR6pW4UC%2bG5wTGLk%2fK71cGmuIDzs3y0WAnahAHI90ET8ODejE8CSeBsVuD8msINMUHnJvlo8FO1CAORroJnoYH9WJ4Ek4CY7cG5dcQaIoPODfLR4OdqEEcjHQTPA0P6sXwJJwExm4Nyq8h0BQvOJ9YrgRt4jm1XLs8KN9oZXo1dR4dk9Di0T1YfDOzI%2f4rQ2Ioplkr3FdxxNNwOKEGcTA6mV5NnUfHJLR4dA8W38yshmDVDP2JNVpANbSXl29ZUw3iYCQhDFPjhJiEFif0YTiYmdUQjJL%2fxtDyKME3L3PiOy31YSQxvZo6j45JaPHoHiy%2bmVkNwarZF8I7pcxyLUj7sNAawnvpawgLq0jLYy7JCTWIg5HE9GrqPDomocWje7D4ZmY1BKtmXwh9ISzsyomhNYTwVOjTRAne3xDCU9krRzPdq35WttrPnxB1gmCmEZLe9LGLYzCI57Oc72qV6pM0fxaepIfpI6EFfmUgEGokcW7EIBzTxy6OwSCez3K%2bq1WqT9L8WXiSHqaPhBY1hDeTMKJ%2fNzgaCA39mc53tUr1Spo%2fC0%2fSw%2fSR0KKGUEOgXfz03CzoXYUXkxKXYBHyrnDiSUWN3oShavQ3hNdRGMH6QvhHgV2t6ALY88QlsFg7ccSTahu9CUPVqCHUEGgZPzs3y3VP3dWcxCVYxbwnnnhSTaM3YagaNYQaAi1jDeEehd7n0GUlBHWZE%2f9Ju4ZQQ6BlrCHco1ANYV%2b1LyoYdyRw49C7OAaDeD7L%2ba5WqT5J82fhSXqYPhJaHPFfGUyzJFhCjAkM4kkcbuekF2FQ%2fg1jtwblJ%2fo0NYhHQgvDw%2bB8V4f6SHGoIRgl%2f42hoZihUw1Dh3AIg%2fJrCNnnvjFxmjvNlPIthxqCUbKG8IdKZCpTC0zjIx7UhzFH4mAvY18I%2fypghkKiJwY%2fgUE8iYNZLsIweu%2fWoPxEn6YG8UhoYXgYnBpCDcHsUvzT2Szn7kWifNO44Ul1iIfBoBrEwZg41Zji0K8MNIk35zSUU5Zrgif1ShyM7IRhahAPg0E1DA%2bD0xdCXwhml%2fpCuEulf5LoMpuLSjUMPYNTQ6ghmF2qIdylUg3ho2zGlPArw8YsfqeSwxqixIMwKD9xbvognoka1IvBoBp0Tn1Svj2f6MVyuTLO6JnQooYQnKIZCA02UYNaMhhUg86pT8q35xO9WC5Xxhk9E1rUEIJTNAOhwSZqUEsGg2rQOfVJ%2bfZ8ohfL5co4o2dCixpCcIpmIDTYRA1qyWBQDTqnPinfnk%2f0YrlcGWf0TGhRQwhO0QyEBpuoQS0ZDKpB59Qn5dvziV4slyvjjJ4JLWoIwSmagdBgEzWoJYNBNeic%2bqR8ez7Ri%2bVyZZzRM6FFDSE4RTMQGmyiBrVkMKgGnVOflG%2fPJ3qxXK6MM3omtKghBKdoBkKDTdSglgwG1aBz6pPy7flEL5bLlXFGz4QWaAiGyJVC3GqbRolnogb1aTCoRuKctEhgTNRI6PksWlCviT4I4zbTGsKbzd4V3Qg%2bcZF2%2b5jgaDASej6LFtRrog%2fCqCF82Mpd0Y3g5iLsxuz2sYufyk%2fo%2bSxaUK%2bJPgijhlBDSN3dS%2bqYBSbgxEUijMQ59ZrogzBqCDWExC5fVsMsMIEnLhJhJM6p10QfhFFDqCEkdvmyGmaBCTxxkQgjcU69JvogjBpCDSGxy5fVMAtM4ImLRBiJc%2bo10Qdh1BBqCIldvqyGWWACT1wkwkicU6%2bJPgijhlBDSOzyZTXMAhN44iIRRuKcek30QRjKEBLNUjNElPITHE0N4mlqUC8JDMODYogn5Zs%2bCMPUIB6EQfm38wQPwiGehkOkBv1%2fO1Ij5nyXKOUbDokYMxTCoV4SGMTBnBNPqmH6IAxTg3gQBuXXEIxCizE0FBo85S%2fSuTuceJrC1EsCw%2fCgGOJJ%2baYPwjA1iAdhUH4NwSi0GENDocFT%2fiKdu8OJpylMvSQwDA%2bKIZ6Ub%2fogDFODeBAG5dcQjEKLMTQUGjzlL9K5O5x4msLUSwLD8KAY4kn5pg%2fCMDWIB2FQfg3BKLQYQ0OhwVP%2bIp27w4mnKUy9JDAMD4ohnpRv%2biAMU4N4EAbl1xCMQosxNBQaPOUv0rk7nHiawtRLAsPwoBjiSfmmD8IwNYgHYVB%2bDcEotBhDQ6HBU%2f4inbvDiacpTL0kMAwPiiGelG%2f6IAxTg3gQBuXXEIxCwzGnDJV4JBbYSLvLg%2fITl8BgmF53Y2gmhifV2OVo8g1PqmP6wH8ghUAmzqfEoF6IhxGcMMz5Lg%2fKryG8n8LUXL%2bbvZkZ7Y7po4ZAKr45p6EYwRfgvgzd5UH5NYQaQmJPL6thFpjAE5eVeCQwqI%2fb%2bS4Pyq8h1BDMHj4sxiwwkUtcVuKRwKA%2baghGodcYmgnNNGGOa4w%2fjzY8CYe0%2bLVbE3%2bXgYjS%2bZQYuzyM4IRhzkkP4kH5iUtgMEyvuzEnaLHbg%2fkQMBikRQ3BqPgmhpbcCL4I%2bWn4Lg%2fKryH0K0NiTy%2brYRaYwBOXlXgkMKgP82lBPKiPGkINwezhw2LMAhM5uiSUn7iIBsPEkB7UK%2bXXEGoIX%2b6hWR5a4t0FpXzCN5fZ1KAYw%2fMEPamPUwxhSk%2bjx9UxplfiQLtlMPBHRQIhkma5CMM0QjwIg%2fLNueGZ4EE4ExikxxSHBA71MnFOMzUcSAuDUUMwSssYJfjLi6z2dRjh0GIYAoRBNaY4JHCol4nzXb3NK9hg1BCC01aC1xC04lN6akIXBppeCZ7M0WDUEEjlhXMleA1BKzqlpyZ0YaDpleBrCKTQm3MSa6HUl6FmqAkehDOBQXpNcUjgUC8T5zRTw4G0MBh9IRilZYwSvC8Eqab758%2fpEmiwBwea3SGKpIXBqCGQygvnSvAaglZ0Sk9N6MJA0yvBjxgCkfgvnZPgCS3MYhAPU4O4Egbln8DhxjHBg3o1Wp3Aw3DAFwKJ8V86N4Pf1UMNDV4Zpgbx3O31BA41hPdTNjOpIdDNeHO%2be0kMlBpaDcFI%2bSvG6KmLfRFo9uIEHoZDDWFhG8zgF8p9GqqGVkPQMhs9dbEawq5Uf1d%2bDcHPM3ERE3oneFDXhucJPAyHvhBo2v3KsKDQa6hZPipsLhrVSPAgDMPzBB6GQw2Bpl1DWFCohvCVWOYy3iX0wn4aDjWEhSmYT4KFcv0NAcRK6G0uwe7MDM8TeBgOaAim2V1BT8k3gn3H1WhFGKbGKXrt8pjQIoGRqHG1Vrf6tDvUx68a9I%2bsEshuoyflG8FqCLmJkd6J3UtgJGrsqkYcagi7Cn%2bSb0SvIeSEJ71rCGu%2fyZBepHdfCB922whWQ6ghfFSALmJCMbObxEPV6FeGNReuISTW%2b58atKC04IZJAiNRw3D9LoY49CvDrsL9ynCBgmslaclrCGsfVqQX6d2vDP3KsHaDw9G0oLTghk4CI1HDcO0LYVelcD4NnuDMAhOGqUE8nuV8QosERqLG7kyIQ78y7CrcrwwXKLhWkpY8YY4JjESNNWX%2bjCYOxxiCIborRiLfLBf1QjUo3%2fRBGLcahEM1KD%2bxXMTBaDHB0%2fCgGNOr6YVwJs63%2f2DS0zQq%2fuky6oUGT%2flmoIRRQ3ivIumVmAnNjTiYmRHG1HkN4Y3StDw0eMo3QyUMs1xUw%2fDcrUH5RosJnoYHxZheTS%2bEM3FeQ6ghfLpntOS04JRvlpswEl9tDA%2bKMb2aXghn4ryGUEOoIWzetBrCwiXa1DqWnhga1Uh8ChBGvzL0N4TYpfikUF8IC%2bZGl7WG8ComaWWW2uhJOKaG4fJdDHEwJr7LIZVfQ6gh9CvD5m2qISxcIvPDz%2bY8fqXTJ0FiaFSDOBgtEjVIT4NBNeictErNjHg8yznNJKGn0WLkhWCaMWS%2fi5kQlPogDjWE9xMkvUjv3Z05KT%2bhBdUw%2fdYQFl47tKBmIBM1aPCGJ9Wgc%2bqzL4S8OSbmWkOoIdDdvuu8hrAmG13mhJ6GUQ2hhmD2ZDkmscCmxjKxQxNqCOHBTAhKC0oc%2bhtC%2fpkcXqOHlaPdod0zX8FMc30h9IVg9mQ5JrHApsYysUMTagjhwUwISgtKHPpC6Avhq7Wn3aHd6wvhg7ITgtJQiEMNoYZQQxD%2fjzKJxwJdRrrMCYedwDBaGR6mzk4MzcOY4w7%2b%2f3MNjwTOCTVo7kaL%2foaw8BsCDZ0GkjAd4jB10YiHWj7xj9YQDp0bHlTjWc5p%2f4wWNYQawiX7rpavhhDVvoawcJlJrMSn9wSG2SDDw9TZiakh7Kh3Xy7NXc1k9%2f%2b5SYEc8ElAYtUQ7lvCr7KeZS%2byXT%2b2Gu24mkkN4XWIRrDvRk4DSZiOWTnDw9TZiTFaTvA0PHb6PCmX9DRa9DeEha8dNHwaSA3hvYJGL9Kczs0loBrPck56Gi1qCDWES%2fZdLd8BXyUvaf5BRWsIC5eZxEp8ek9gTO2a6eVqLsZUruaQqv8sevaFsGAqtBxm6M%2by5KYX0mP3%2fFm0Mn0%2bi541hBrCp%2fv8LAtsLuMJMc%2biZw2hhlBDGHCMGsIbkSfEoOel4UA1aG8mMIhD6tz0ksL6qs7uPK7mt1L%2fWfTsC6EvhL4QVm72nbE1hL4QPl2dZ%2fnUe5YFvvN%2bjqc9i559IfSF0BfCgD3UEAZEXoEwA6FPb1ODOBEG5d%2fOiQdhUL7hkMBI1DBcd2MmeJ6A8Wu3Jv4uw%2b5AEvnmEpwyFOqXejmhD%2bJ463GCJ2lpzid4noBRQ%2fiwDacMhZaULtsJfRDHGsL7KZ8wsxpCDYG858vzxAInatzdwELiBM8TMGoINYSFa5H%2fRJu4BHc3%2bCZxgucJGDWEGsLd9yWxwIkadzewkDjB8wSMGkINYeFa9IXwlVjm9xISuoZACoXPzdBOGQq1Tr2c0Adx7I%2bKeYOlvaG96AuhLwTaof6oOPSfR%2bmyGoOlYRJGxBCIxDOdk2ATQzEYJ%2fCkuZ7SB%2fEkLX9dksC%2f7GRwvuNqOOxi1BAOfCEkBm9qJC7K1Quc6CPRZ4LH7mU1HHYxagg1hLu%2fEtBFSyywqUE86NxcogQPg3O1wZIWNYQaQg3h50%2b8JzWENxIlxEDFDwkgF09okcBI1CDJCYPyjVaEYWoQDzonDv0N4YOCE0OhoU2d03IktEhgJGqQpoRB%2bUYrwjA1iAedE4caQg3hyx1KLCgtoMFI1EhclKu%2f8xotqA86Jy1rCDWEGoL4b%2b900cxlpstoahAPOicONQRSsOdVoAr8tQrgP5Dy13bexqpAFfhDgRpCl6IKVIHfCtQQugxVoArUELoDVaAK%2fKlAXwjdiipQBfpC6A5UgSrQF0J3oApUgW8U6FeGrkcVqAK%2fFfgf0ERlbFq709oAAAAASUVORK5CYII%3d"))

--::put_work::
--header_send = {}
--body_send = string.format("userKey=%s&qrCodeImg=%s&phone=%s","1875b88a1fd7484abfd531ddca810422","data:image/png;base64,"..readFileBase64(userPath().."/res/222.png"),"13511111111")
--ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
--status_resp, header_resp, body_resp  = ts.httpPost("http://api.qianxing666.com/api/open-api/orders/submit", header_send, body_send, true)
--dialog(body_resp, time)
--if status_resp == 200 then
--	local tmp = json.decode(body_resp)
--	if tmp.success then
--		taskId = tmp.obj.orderId
--		toast("发布成功,id:"..tmp.obj.orderId,1)
--	else
--		goto put_work
--	end
--else
--	goto put_work
--end 
--while (true) do
--	mSleep(500)
--	x,y = findMultiColorInRegionFuzzy( 0x161823, "13|0|0x161823,21|-3|0x161823,40|-14|0x161823,40|-5|0x161823,31|3|0x161823,45|3|0x161823,54|3|0x161823", 90, 0, 0, 749, 1333)
--	if x~=-1 and y~=-1 then
--		mSleep(500)
--		tap(x + 320,y)
--		mSleep(2000)
--	end

--	x,y = findMultiColorInRegionFuzzy( 0x161823, "0|8|0x161823,15|3|0x161823,23|11|0x161823,40|0|0x161823,37|18|0x161823,44|23|0x161823", 90, 0, 0, 749, 1333)
--	if x~=-1 and y~=-1 then
--		mSleep(500)
--		moveTowards( 283,  1044, math.random(70,90), 250)
--		mSleep(2000)
--		break
--	end
--end

--CS2008251013381507020
--8148887206
--http://124.156.99.83/usa1?voice=6b889f9bf8241d76ada0f0ac504bcb62ee4078c8d159aef3853cbf203d7bb2020c7e62d486b890d5




--openURL("snssdk1128://aweme/detail/6864418736191966467?refer=web&gd_label=click_wap_detail_download_feature&appParam=%7B%22__type__%22%3A%22wap%22%2C%22position%22%3A%22900718067%22%2C%22parent_group_id%22%3A%226553813763982626051%22%2C%22webid%22%3A%226568996356873356814%22%2C%22gd_label%22%3A%22click_wap%22%7D&needlaunchlog=1")
--base_six_four = readFileBase64(userPath().."/res/111.png") 
--dialog(base_six_four:base64_decode(), time)
--::ewm_go::
--token = "c97f4c3afad288a06d092df40ab77dc2"
--header_send = {}
--body_send = string.format("qr=%s&token=%s",base_six_four,token)

--ts.setHttpsTimeOut(60)--安卓不支持设置超时时间 
--status_resp, header_resp, body_resp  = ts.httpPost("https://www.sojson.com/qr/deqrByImages.shtml", header_send, body_send, true)
--mSleep(1000)
--dialog(body_resp, time)

--http://b.bshare.cn/barCode?site=weixin&url=

--local sz = require("sz");
--local http = require("szocket.http")
--local res, code = http.request("http://s.jiathis.com/qrcode.php?url="..userPath().."/res/111.png")
--dialog(res, time)
--if code == 200 then
--	tmp = json.decode(res)
--	if tmp.code == "200" then
--		toast(tmp.message, 1)
--		order_sn = tmp.data.order_sn
--	end
--end
--				--个人中心
--				openURL("snssdk1128://user/profile/id")
--				while (true) do
--					mSleep(500)
--					x,y = findMultiColorInRegionFuzzy( 0xface15, "54|0|0xface15,117|0|0xface15,199|0|0xface15", 90, 0, 0, 639, 1135)
--					if x >= 214 then
--						mSleep(500)
--						moveTowards( 283,  1044, 80, 1000,50)
--						mSleep(2000)
--						break
--					else
--						mSleep(500)
--						tap(300,y-60)
--						mSleep(500)
--					end
--				end
----获取token
--header_send = {
--	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
--}
--body_send = {
--	["username"] = "17811602486",
--	["loginpw"] = "qazwsx123" ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/account/raw/login", header_send,body_send)
--dialog(body_resp, time)
--local tmp = json.decode(body_resp)
--token = tmp.data.token
--dialog(token, time)
--nLog(token)


------获取签到参数
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/oss/sign_img", header_send,body_send)

----local tmp = json.decode(body_resp)
----tmp_accessid = tmp.data.accessid
----tmp_signature = tmp.data.signature
----tmp_prefix = tmp.data.prefix
----tmp_expire = tmp.data.expire
----tmp_dir = tmp.data.dir
----tmp_policy = tmp.data.policy

--http://qr.liantu.com/api.php?text=C:\Users\admin\Desktop\111.png
--url = "https://www.sojson.com/qr/zxing.html"

----local _table1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="key"]]..'\r\n\r\n'..[[]]..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'..[[]]
----local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="policy"]]..'\r\n\r\n'..[[]]..tmp_policy..[[]]
----local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="OSSAccessKeyId"]]..'\r\n\r\n'..[[]]..tmp_accessid..[[]]
----local _table4 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="signature"]]..'\r\n\r\n'..[[]]..tmp_signature..[[]]
----local _table5 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="id"]]..'\r\n\r\n'..[[WU_FILE_0]]
----local _file1  = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'

--local _file1  = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="111.png"]]..'\r\n'..[[Content-Type: image/png]]..'\r\n\r\n'
--local _table1 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="charset"]]..'\r\n\r\n'..[[UTF-8]]
--local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="en"]]..'\r\n\r\n'..[[Nh01QnxgsJRHk245OQiYWD cZtwbHio/HRIzEEAMqqxjIoNnfrkAu1pyczEsnRh34FPsfgoo5aeJIhGC NMW6hmcuibY7CQf1Zx2JaaGHcMYVBlgzdhCXyKBqB3bk012covQ3SODP7hrCjUyhpJUPlj7DCOuk4mFFHC6CItztjE=]]
--local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="ip"]]..'\r\n\r\n'..[[R6b60JKNA1KglT50kNxyFQm5DsVsnQHkrBqz8nBAhmO/DrSEVxZMa0UBxxVw6PaO1uqvY2MsTR7UQkX2kne9eo0q0Dk5liOtQIX9fBJIyYTCvZkWTBUxOXxOJH6YaMb3VkY/WD3I FMyaRep0ZO9xNVCEmz657Kowmx4oM4PMFs=]]

--local _end    = '\r\n'..[[--abcd--]]..'\r\n'

--aa = imgupload2(url, userPath() .. "/res/111.png",_file1,_table1,_table2,_table3,_end);
----aa返回200标识上传截图成功，然后进行绑定操作
--dialog(aa, time)

------上传图片
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----	["img_url"] = "https://zqzan.oss-cn-shanghai.aliyuncs.com/sign/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/do/sign", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)


------绑定抖音号
----header_send = {
----	["Token"] = token,
----}
----body_send = {
----	["shot_img"] = "https://yun.zqzan.com/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
----	["short_url"] = "https://v.douyin.com/JMKcGXX/" ,
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/do/oauth", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)

------解绑
----header_send = {
----	["Token"] = token,
----}

----body_send = {}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/undo/oauth", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)
----nLog(token)


------绑定支付宝
----header_send = {
----	["Token"] = token,
----}

----body_send = {
----	["alipay_account"] = 支付宝账号,
----	["alipay_realname"] = 姓名 ,
----}
----ts.setHttpsTimeOut(60)
----code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/cash/alipay", header_send,body_send)
----local tmp = json.decode(body_resp)
----dialog(tmp.msg, time)
----nLog(token)


----获取任务
--header_send = {
--	["Token"] = token,
--}

--body_send = {
--	["b_discount"] = true,
--	["access"] = 79 ,
--	["exam_status"] = 0 ,
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/pull/one", header_send,body_send)
--dialog(body_resp, time)
--nLog(body_resp)
--local tmp = json.decode(body_resp)
--id = tmp.data.id
--dialog(tmp.msg, time)
--nLog(token)

--openURL("snssdk1128://aweme/detail/"..id)
--mSleep(20000)
--snapshot("test.jpg", 0, 0, 749, 1333,0.7);
--mSleep(2000)
--toast("截图成功",1)
--mSleep(2000)

----获取上传参数
--header_send = {
--	["Token"] = token,
--}
--body_send = {
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/oss/shot_img", header_send,body_send)

--local tmp = json.decode(body_resp)
--tmp_accessid = tmp.data.accessid
--tmp_signature = tmp.data.signature
--tmp_prefix = tmp.data.prefix
--tmp_expire = tmp.data.expire
--tmp_dir = tmp.data.dir
--tmp_policy = tmp.data.policy

----上传截图
--url = "https://yun.zqzan.com/"

--local _table1 = [[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="key"]]..'\r\n\r\n'..[[]]..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'..[[]]
--local _table2 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="policy"]]..'\r\n\r\n'..[[]]..tmp_policy..[[]]
--local _table3 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="OSSAccessKeyId"]]..'\r\n\r\n'..[[]]..tmp_accessid..[[]]
--local _table4 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="signature"]]..'\r\n\r\n'..[[]]..tmp_signature..[[]]
--local _table5 = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="success_action_status"]]..'\r\n\r\n'..[[200]]
--local _file1  = '\r\n'..[[--abcd]]..'\r\n'..[[Content-Disposition: form-data; name="file"; filename="test.jpg"]]..'\r\n'..[[Content-Type: image/jpeg]]..'\r\n\r\n'

--local _end    = '\r\n'..[[--abcd--]]..'\r\n'

--aa = imgupload2(url, userPath() .. "/res/test.jpg",_file1,_table1,_table2,_table3,_table4,_table5,_end);
----aa返回200标识上传截图成功，然后进行绑定操作
--dialog(aa, time)

----提交任务
--header_send = {
--	["Token"] = token,
--}
--body_send = {
--	["doit_id"] = id,
--	["shot_img"] = "https://zqzan.oss-cn-shanghai.aliyuncs.com/"..tmp_dir..'/'..tmp_prefix..tmp_expire..'.png'.."@!fwidth",
--}
--ts.setHttpsTimeOut(60)
--code,header_resp, body_resp = ts.httpsPost("http://zcore.zqzan.com/app/douyin/submit/task", header_send,body_send)
--local tmp = json.decode(body_resp)
--dialog(tmp.msg, time)



