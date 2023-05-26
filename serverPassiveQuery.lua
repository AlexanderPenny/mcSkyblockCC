local run=true
rednet.open("top")
while run do
    print("Waiting For Query")
    local id,message,protocol=rednet.receive()
    print("Recieved "..protocol.." Request from ID "..id.." stating "..message)
    if protocol=="Read" then
        local dataFile=fs.open("/Data/"..message..".txt","r")
        print("/Data/"..message..".txt")
        local val=dataFile.readLine()
        print("Sending value "..val.." to "..id)
        rednet.send(id,val)
        dataFile.close()
    elseif protocol=="Write" then
        dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","w")
        dataFile.write(string.sub(message,8,message:len()))
        dataFile.close()
        print()
        print("Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
        rednet.send(id,"Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
    else
        rednet.send(id,"Invalid Protocol used in Network")
    end
end