local run=true
rednet.open("top")
while run do
    print("Waiting For Query")
    local id,message,protocol=rednet.receive()
    print("Recieved "..protocol.." Request from ID "..id.." stating "..message)
    if protocol=="Read" then
        local dataFile=fs.open("/Data/"..message..".txt","r")
        print("/Data/"..message..".txt")
        rednet.send(id,dataFile.readLine())
        dataFile.close()
    else -- Write -- currently non functional
        dataFile=fs.open("/Data/"..message,"w")
        dataFile.writeLine()
    end
end