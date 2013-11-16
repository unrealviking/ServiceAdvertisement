#!/bin/lua5.1

local socket = require("socket")
local json = require("dkjson")

-- command line options
local ip = arg[1]
local port = arg[2]
--local typ = arg[3]

-- usage and check for sufficient arguments
if not arg[2] then
   print("usage: client <ip> <port>\n")
   return 1
end

-- variables
local ads = {}

-- some constants
local tbl = {}
tbl["type"] = "req_get"
tbl["target"] = "all"
local REQ_ALL = json.encode(tbl).."\n"

-- some functions
local print_ad = function(ad)
   print(ad.checksum.." , "..ad.contend)
end

local receive = function(client) 
   local msg,err = client:receive('*l')
   if err then
	  print("Error receive: "..err)
	  return nil
   else
	  local obj,pos,err = json.decode(msg,1,nil)
	  if err then 
		 print("Error decode: "..err)
	  else
		 return obj
	  end
   end
end

local send = function(client,obj)
   local str = json.encode(obj)
   local suc,err,last = client:send(str.."\n")
   if not suc then
	  print("Error send: "..err)
	  return nil
   else
	  return true
   end
end

local get_all = function(client)
   local REQ = {}
   REQ["type"] = "req_get"
   REQ["target"] = "all"
   -- request all 
   if send(REQ) then
	  local newads = receive(client)
	  if not newads then
		 print("no ads received")
	  else
		 for i,ad in ipairs(newads) do
			print("## append to ad-list ##")
			print_ad(ad)
			table.insert(ads,ad)
			print("## end append ##")
		 end
	  end
   end
end

local get_by_checksum = function(client,checksum) 
   -- request
   local tbl = {}
   tbl["type"] = "req_get"
   tbl["target"] = cs
   if send(client,tbl) then
	  local newad = receive(client)
	  if not newad then
		 print("no ad received")
	  else
		 print("# append to ad-list #")
		 print_ad(newad)
		 table.insert(ads,newad)
		 print("# end append #")
	  end
   end
end

-- connect
local client = socket.try(socket.connect(ip,port))

-- main loop
while true do
   -- prompt
   io.write("> ")
   local command = io.read("*line")
   -- interpret
   if command == "list local" then
	  print("# List all local ads")
	  for i,ad in ipairs(ads) do
		 print(i,ad.checksum,ad.contend)
	  end
	  print("# end list local ads")
   elseif command == "list remote" then
	  -- send request
	  local tbl = {}
	  tbl["type"] = "req_list"
	  if send(client,tbl) then
		 -- read
		 local list = receive(client)
		 if not list then
			print("# no list received")
		 else
			print("# list remote ads")
			print("index","checksum")
			for i,cs in ipairs(list) do
			   print(i,cs)
			end
			print("# end list")
		 end
	  end
   elseif command == "create" then
	  print("# Create new ad")
	  local ad = {}
	  io.write("checksum: ")
	  ad.checksum = io.read("*line")
	  io.write("contend: ")
	  ad.contend = io.read("*line")
	  table.insert(ads,ad)
   elseif command == "get all" then
	  print("# get all remote ads")
	  get_all(client)
   elseif command == "get checksum" then
	  print("# get remote ad")
	  -- get user input
	  io.write("remote checksum: ")
	  local cs = io.read("*number")
	  get_by_checksum(client,cs)
   elseif command == "add index" then
	  print("# add local ad to remote server")
	  io.write("local index: ")
	  local index = io.read("*number")
	  if ads[index] then
		 local tbl = {}
		 tbl["type"] = "req_add"
		 tbl["ad"] = ads[index]
		 send(client,tbl)
	  else
		 print("not a valid index")
	  end
   elseif command == "help" then
	  print("list local")
	  print("list remote")
	  print("create")
	  print("help")
	  print("get all")
	  print("get checksum")
	  print("add")
   elseif command == "exit" then
	  break
   else 
	  print("type help for a list of available commmands")
   end
end
