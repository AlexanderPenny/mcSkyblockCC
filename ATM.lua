term.clear()
rednet.open("back")
print("Please Enter Debit Card Below")
while disk.isPresent("Bottom")==false do
    os.sleep(0.5)
end
print("Please wait, querying data...")
local dataFile=fs.open("/disk/CheckSum.txt","r")
rednet.send(5,dataFile.readLine(),"Read")
dataFile.close()
local id,message = rednet.receive()
print("Account Balance : "..message)
disk.eject("Bottom")
print("Remember to hold CTRL+S to log out.")
