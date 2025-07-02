----------------------other variables----------------------
local menuMode = 0
-- 0 = main menu, 1 = withdraw money, 2 = deposit money
-- 3 = view balance, 4 = transfer money

--username list + checksums
local userArray = {
    {"CHz01G", "FeR21l", "mNE48r", "QNz23f", "OmX901", "PlK51e", "YrT42P"},
    {"Ross","Andrey","Matthew","Xander","Sanders","Momo","Struan"}
}
--misc
local continueLoop = true
local mouseX, mouseY = 0,0
local accountBalance = nil
local userInput = nil
------------------------functions------------------------
local function checkDiskPresent()
    term.setBackgroundColor(colors.red)
    term.clear()
    term.setCursorPos(1,1)
    rednet.open("back")
    print("Please Enter Debit Card Below")

    --checking if the disk is present
    while disk.isPresent("Bottom")==false do
        os.sleep(0.5)
    end

if accountBalance == nil then
    local dataFile=fs.open("/disk/CheckSum.txt","r")
    rednet.send(5,dataFile.readLine(),"Read")
    dataFile.close()
    local _,message = rednet.receive()
    accountBalance = message
end
end

local function getTerminalWidth() -- just so that its easier to write
    local width, height = term.getSize()
end

local function writeCentered(text, line)
    local width, height = term.getSize()
    local x = math.floor((width - 13) / 2 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function writeLeft(text, line)
    local width, height = term.getSize()
    local x = math.floor((width - 13) / 5 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function writeRight(text, line)
    local width, height = term.getSize()
    local x = math.floor((width - 13) / 1.3 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function checkClick()
    --check if the mouse has been clicked
    -- Check if the mouse has been clicked
    local event, button, x, y = os.pullEvent("mouse_up")

    --set variables
    mouseX = x
    mouseY = y
    local width, _ = term.getSize()
    
    if menuMode == 0 then
        --checking mouse position in relation to the buttons when mouse is clicked
        if mouseX > (math.floor((width - 13) / 5 + 1)) and mouseX < (math.floor((width - 13) / 5 + 1) + 13) then
            --if here, then it is the left two buttons
                if mouseY > 5 and mouseY < 8 then
                    menuMode = 1 -- withdraw money
                elseif mouseY > 13 and mouseY < 16 then
                    menuMode = 2 -- deposit money
                end
        elseif mouseX > (math.floor((width - 13) / 1.3 + 1)) and mouseX < (math.floor((width-13) / 1.3 + 1) + 13) then
            -- if here then it is the right two buttons
                if mouseY > 5 and mouseY < 8 then
                    menuMode = 3 -- view balance
                elseif mouseY > 13 and mouseY < 16 then
                    menuMode = 4 -- transfer money
                end
        elseif mouseX < 5 and mouseY < 2 then -- back button
                disk.eject("Bottom")
                os.shutdown()
        end
    elseif menuMode == 1 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 2 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 3 then
        if mouseX < 7 then
            if mouseY == 1 then -- back button
                menuMode = 0
            elseif mouseY == 3 then
                menuMode = 5
            elseif mouseY == 5 then
                menuMode = 6
            elseif mouseY == 7 then
                menuMode = 7
            elseif mouseY == 9 then
                menuMode = 8
            elseif mouseY == 11 then
                menuMode = 9
            elseif mouseY == 13 then
                menuMode = 10
            elseif mouseY == 15 then
                menuMode = 11
            end
        end
    elseif menuMode == 4 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
--------------menuModes within Menu 3, for transferring money--------------
    elseif menuMode == 5 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 6 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 7 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 8 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 9 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 10 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
    elseif menuMode == 11 then
        if mouseX < 5 and mouseY < 2 then -- back button
            menuMode = 0
        end
------------------end of menuModes within Menu 3------------------
    end
end

local function drawScreen()
    term.setBackgroundColor(colors.lightBlue)
    term.clear()

    if menuMode == 0 then
        --set text information
        getTerminalWidth()
        term.setTextColor(colors.black)

        --write text
        term.setCursorPos(1,1)
        term.write("EXIT")
        writeCentered("    ATM", 1)
        writeLeft("Withdraw Cash", 6) -- withdraw money
        writeRight("Check Balance", 6)
        writeLeft("Deposit Money", 14) -- deposit money
        writeRight("Transfer Cash", 14)
    elseif menuMode == 1 then
        term.setCursorPos(1,1)
        term.write("BACK")

        writeCentered("menu unavailable", 10)
    elseif menuMode == 2 then
        term.setCursorPos(1,1)
        term.write("BACK")

        writeCentered("menu unavailable", 10)
    elseif menuMode == 3 then
        term.setCursorPos(1,1)
        term.write("BACK")
        writeCentered("Balance", 1)

        --write account balance
        if accountBalance ~= nil then
            writeCentered("Balance: " .. accountBalance, 12)
        else -- if the file reading failed initially
            writeCentered("Account Balance: " .. "[ERROR]", 12)
        end
    elseif menuMode == 4 then
        term.setCursorPos(1,1)
        term.write("BACK")

        --write text
        writeCentered("Transfer Cash", 1)
        for i = 1, #userArray[1] do
            term.setCursorPos(1, 1+(i*2))
            term.write(userArray[2][i])
        end
        --------------menuModes within Menu 3, for transferring money--------------
    elseif menuMode == 5 then
        writeLeft("You are wanting to transfer to " .. userArray[menuMode-4], 4)
        writeLeft("How much would you like to transfer to them?", 5)
        local x = math.floor((width - 13) / 5 + 1)
        term.setCursorPos(x, 6)
        local validInput = false
        while validInput == false do
            userInput = term.read()
            userInput = tonumber(userInput)
            if userInput > 0 and userInput <= accountBalance then
                validInput = true
            end
        end
    elseif menuMode == 6 then

    elseif menuMode == 7 then

    elseif menuMode == 8 then

    elseif menuMode == 9 then

    elseif menuMode == 10 then

    elseif menuMode == 11 then
        
------------------end of menuModes within Menu 3------------------
    end
end

------------------------main atm loop------------------------
--reminder, variable for menus is called menuMode
while continueLoop == true do
    checkDiskPresent()
    drawScreen()
    checkClick()
end

------------------------other------------------------
--ending statement
print("Remember to hold CTRL+S to log out.")
rednet.close()

------------------------notes------------------------
--NOTE: you cannot set text size on non-advanced terminals
--all buttons should be 13 characters in length (on the main menu)