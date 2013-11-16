#!/bin/lua5.1

local socket = require("socket")
local json = require("dkjson")

-- list of advertisements
local ads = {{checksum = 1,contend = "hallo"}}

-- some functions
local send_by_checksum = function(client,cs) 
   for i,ad in ipairs(ads) do
	  if ad.checksum == cs then
		 print("send requested ad")
		 local str = json.encode(ad)
		 client:send(str.."\n")
		 return
	  end
   end
   client:send("\n")
end

-- listen on new port
local newserver = function()
   local server = assert(socket.bind("*",0))
   local ip,port = server:getsockname()
   print("listen on port "..port)
   return server
end

local handle_request = function(client,request)
   -- decode
   local obj,pos,err = json.decode(request,1,nil)
   if err then
	  print("Error:",err)
   else
	  -- handle
	  if obj.type == "req_get" then
		 if obj.target == "all" then
			-- send all ads
			print("send all ads")
			local str = json.encode(ads)
			client:send(str.."\n")
		 else
			send_by_checksum(client,obj.target)
		 end
	  elseif obj.type == "req_add" then
		 -- add an ad
		 print("add new advertisement to list")
		 table.insert(ads,obj.ad)
	  elseif obj.type == "req_list" then
		 local list = {}
		 for i,ad in ipairs(ads) do
			table.insert(list,ad.checksum)
		 end
		 local str = json.encode(list)
		 client:send(str.."\n")
	  end
   end
end

local listen = function(server)
   while 1 do
	  -- wait for connection
	  local client = server:accept()
	  print("### connection opened ###")
	  -- read the request
	  local requ,err = client:receive('*l')
	  -- handle the request
	  if not err then
		 print("handle the request")
		 handle_request(client,requ)
	  else
		 print("Error: "..err)
	  end
	  -- close connection
	  client:close()
	  print("### connection closed ###")
   end
end

local server = newserver()
listen(server)
