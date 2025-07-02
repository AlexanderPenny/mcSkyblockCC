--protocol defininitons
 
local function getChecksum(message)
        local dataFile=fs.open("/Data/info.txt","r")
        for line in dataFile.readLine do 
            if message==line:sub(line:find("-")+1,line:len()) then
                dataFile.close()
                return line:sub(0,line:find("-")-1)
            end
        end
        dataFile.close()
        return("Invalid Checksum")
end
 
local function writeValue(id,message)
    dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","w")
    dataFile.write(string.sub(message,8,message:len()))
    dataFile.close()
    print()
    print("Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
    rednet.send(id,"Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
end
 
local function readValue(id,message)
    local dataFile=fs.open("/Data/"..message..".txt","r")
    print("/Data/"..message..".txt")
    local val=dataFile.readLine()
    print("Sending value "..val.." to "..id)
    rednet.send(id,val)
    dataFile.close()
end
 
local function updateValue(id,message)
    local dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","r")
    local val=tonumber(dataFile.readLine())
    dataFile.close()
    dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","w")
    dataFile.write(tonumber(string.sub(message,8,message:len()))+val)
    print("Successfully updated Account with checksum "..string.sub(message,1,6).." incremented value by "..string.sub(message,8,message:len()))
    rednet.send(id,("Successfully updated Account with checksum "..string.sub(message,1,6).." incremented value by "..string.sub(message,8,message:len())))
    dataFile.close()
end
 
--main loop below
 
local run=true
rednet.open("top")
while run do
    print("Waiting For Query")
    local id,message,protocol=rednet.receive()
    print("Recieved "..protocol.." Request from ID "..id.." stating "..message)
    if protocol=="Read" then
        readValue(id,message)
    elseif protocol=="Write" then
        writeValue(id,message)
    elseif protocol=="Update" then
        updateValue(id,message)
    elseif protocol=="getChecksum" then
        rednet.send(id,getChecksum(message))
    else
        rednet.send(id,"Invalid Protocol used in Network")
    end
end