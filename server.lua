local pw = require "password"
local sw = require "rc_switch"

wifi.setmode(wifi.STATION)
wifi.sta.config(pw.ssid, pw.pass)

local pin=3
local plen = 160 -- pulse length 160 us
local rep = 3 -- send each frame this number of times

sw.init(pin, plen, rep)

local html = [[
<html>
<head><title>remote outlet switch</title></head>
<body>
<div>
<h3>remote outlet switch</h3>
<form method="POST" name="switch">
<p>
<input type="submit" name="b1" value="on"/>
1
<input type="submit" name="b1" value="off"/>
<p>
<input type="submit" name="b2" value="on"/>
2
<input type="submit" name="b2" value="off"/>
<p>
<input type="submit" name="b3" value="on"/>
3
<input type="submit" name="b3" value="off"/>
<p>
<input type="submit" name="b4" value="on"/>
4
<input type="submit" name="b4" value="off"/>
<p>
<input type="submit" name="b5" value="on"/>
5
<input type="submit" name="b5" value="off"/>
</form>
</div>
</body>
</html>
]]

srv=net.createServer(net.TCP, 4)
if srv then
  srv:listen(80,function(conn)
    conn:on("receive",function(conn,data)
      if debug then print(data) end

      button, state = string.match(data, "b(%d)=(%a+)")
      if button ~= nil then
        button = tonumber(button)
        sw.switch(button, state)
      end
      if string.find(data,"favicon.ico") == nil then
        conn:send(html)
      end
    end)

  conn:on("sent",function(conn) conn:close() end)

  end)
end

