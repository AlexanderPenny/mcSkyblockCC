--clears screen and opens port to bank network
term.clear()
rednet.open("back")
--waits for disk to be present
print("Please Enter Debit Card Below")
while disk.isPresent("Bottom")==false do
    os.sleep(0.5)
end
--Queries stored checksum with database to find bank balance
print("Please wait, querying data...")
local dataFile=fs.open("/disk/CheckSum.txt","r")
--send signal to db
rednet.send(5,dataFile.readLine(),"Read")
dataFile.close()
--waits for return message from db
local id,message = rednet.receive()
-- prints balance to terminal and returns disk
print("Account Balance : "..message)
disk.eject("Bottom")
print("Remember to hold CTRL+S to log out.")
