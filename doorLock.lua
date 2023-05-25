local employeePassword = "wasd"
local userInput = nil
local adminPassword = "adminExit"
local triesLeft = 5

while userInput ~= adminPassword do
    print("Enter Employee Password")
    userInput = read()
    if userInput == employeePassword then
        print("Correct Password!")
        redstone.setOutput("left", true)
        os.sleep(1)
        term.clear()
        triesLeft = 5
        os.sleep(7)
        redstone.setOutput("left", false)
    elseif userInput ~= adminPassword then
        triesLeft = triesLeft - 1
        print("Error, wrong password, you have " .. triesLeft .. " tries left.")
        if triesLeft < 1 then
            triesLeft = 5
            term.clear()
            print("You have been locked out for three minutes.")
            os.sleep(180)
        end
    end
end

print("Admin exit command received, exiting loop.")