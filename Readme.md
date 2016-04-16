ZAP Remote
==========

This is a web controlled remote for the [Etekcity Remote Controlled Electrical Outlets](http://www.etekcity.com/product/100068.html)

What you'll need
----------------

1. [NodeMCU Dev Kit](http://nodemcu.com/index_en.html#fr_54747661d775ef1a3600009e) or any ESP8266 board (you'll have to install nodemcu on it though).
2. A 433MHz transmitter, like [this one from SparkFun](https://www.sparkfun.com/products/10534)
3. A 3.3V power supply
4. Some wires

How it works
------------

The transmitter in the ZAP remote is based on a [HS 2260A-R4](http://www.princeton.com.tw/Portals/0/Product/PT2260_4.pdf) remote control encoder and works in the 433MHz low power device band. [LPD433](https://en.wikipedia.org/wiki/LPD433)

The remote controls 5 outlets, and has 10 buttons, one ON/OFF pair for each outlet. It transmits an unique code for each button. If you keep the button pressed it sends the same code over and over.

You can find the wireless frame format in the HS2260 datasheet. But all you care now is  the following:

1. the frame is 12-bit long (8-bit address + 4-bit data)
2. the encoding is base 3, so there's a 0, 1 and F (the documentation calls it _float_, I don't know why)
3. there's a synchronization bit that follows each frame.

You can easily determine the address and data values transmitted by each button, if you have a 433MHz receiver and a digital scope. A SRD should do it too. If you don't have any of these, use an arduino (you'll have to write some code, though).

Once you find out the codes sent by your remote, put them in the _cmd_strings_ table.


Upload the files
----------------

Now, upload the files on the ESP8266. I use [nodemcu-uploader](https://github.com/kmpm/nodemcu-uploader)

  for file in *lua;  do python nodemcu-uploader.py --port /dev/ttyUSB0 --baud 9600 upload $file ; done


Wiring
------

Wiring is really simple:

NodeMCU -- RF Transmitter  
3V3 -- VCC  
GND -- GND  
D3  -- DATA


Change your init.lua
--------------------

I intentionally didn't include init.lua in the source files. All you need to do in init.lua is:

  dofile('server.lua')
 

That's it
---------

Now power it up, look in the DHCP logs and see what IP address it got, then open it in a browser. Something like this: http://192.168.1.125/

