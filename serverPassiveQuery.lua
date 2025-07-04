--function definitions

local function getOwnerChecksum(id)
    --returns checksum that owns id
    local dataFile=fs.open("/Data/registeredComputers.txt","r")
    local val=dataFile.readLine()
    local found=false
    local data=nil
    while val~=nil and found==false do
        if tonumber(string.sub(val,1,val:len()-7))==id then
            found=true
            data=val
            string.sub(data,data:len()-5,data:len())
        end
        val=dataFile.readLine()
    end
    if found then
        return string.sub(data,data:len()-5,data:len())
    else
        return -1
    end
    dataFile.close()




    return checksum
end

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
 
local function writeValue(id,message) --MAKE ID CHECKS SO CAN ONLY BE DONE BY VERIFIED OFFICIAL BANK COMPS
    --banks main account checksum
    if "UiQ83O"==getOwnerChecksum(id) then
        dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","w")
        dataFile.write(string.sub(message,8,message:len()))
        dataFile.close()
        print()
        print("Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
        rednet.send(id,"Successfully updated Account with checksum "..string.sub(message,1,6).." to value "..string.sub(message,8,message:len()))
    else
        print("Computer of id "..id.." is not authorised to use this protocol")
        rednet.send(id,"Computer of id "..id.." is not authorised to use this protocol")
    end
    
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

local function transaction(id,message)
    --transactingFromChecksum:transactingToChecksum:Value 
    local dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","r")
    local losingAccountValue=tonumber(dataFile.readLine())
    dataFile.close()
    transactionValue=tonumber(string.sub(message,15,message:len()))
    print("losing "..losingAccountValue.." transacting "..transactionValue)
    if transactionValue<0 then
        print("Sending value must be greater than or equal to 0")
        rednet.send(id,"Sending value must be greater than or equal to 0")
    else
        if losingAccountValue<transactionValue then
            print("Insufficient funds")
            rednet.send(id,"Insufficient funds")
        else
            local dataFile=fs.open("/Data/"..string.sub(message,1,6)..".txt","w")
            dataFile.write(losingAccountValue-transactionValue)
            dataFile.close()
        end
        
        local dataFile=fs.open("/Data/"..string.sub(message,8,13)..".txt","r")
        local gainingAccountValue=tonumber(dataFile.readLine())
        dataFile.close()
        local dataFile=fs.open("/Data/"..string.sub(message,8,13)..".txt","w")
        dataFile.write(gainingAccountValue+transactionValue)
        dataFile.close()
        print("Successfully completed transaction with Accounts with checksums "..string.sub(message,1,6).." and "..string.sub(message,8,13)..", transaction value "..transactionValue)
        rednet.send(id,"Successfully completed transaction of "..transactionValue)
    end
end

local function register(id,message)
    --message=checksum
    --currently needs you to manually delete empty line after first registeration
    local dataFile=fs.open("/Data/registeredComputers.txt","r")
    local validRegister=true
    local val=dataFile.readLine()
    while val~=nil and validRegister==true do
        if tonumber(string.sub(val,1,val:len()-7))==id then
            print("Computer already has a registered account")
            rednet.send(id,"Computer already has a registered account")
            validRegister=false
        end
        val=dataFile.readLine()
    end
    dataFile.close()
    if validRegister then
        local dataFile=fs.open("/Data/registeredComputers.txt","a")
        dataFile.write(id..":"..message.."\n")
        dataFile.close()
    end
end
 
--main loop below

local run=true
rednet.open("top")
rednet.open("left")
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
    elseif protocol=="Transaction" then
        transaction(id,message)
    elseif protocol=="Register" then
        register(id,message)
    elseif protocol=="getChecksum" then
        rednet.send(id,getChecksum(message))
    else
        rednet.send(id,"Invalid Protocol used in Network")
    end
end