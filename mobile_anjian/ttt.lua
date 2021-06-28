function TryRemoveUtf8BOM(ret)
	if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then
		ret=string.char( string.byte(ret,4,string.len(ret)) )
	end
	return ret;
end

function QMPlugin.writeFileByte(file_path, wdata)
	hex = string.match(TryRemoveUtf8BOM(wdata),"(%w+)");
	for i = 1, string.len(hex),2 do
		local code = string.sub(hex, i, i+1);
		data = data..string.char(tonumber(code,16));
	end
	
	local file = io.open(file_path, 'wb');
	file:write(data);
	file:close();
	
	os.execute('chown mobile ' .. file_path)
	return true
end