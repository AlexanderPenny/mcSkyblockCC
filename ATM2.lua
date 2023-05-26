----------------------other variables----------------------
local menuMode = 0
-- 0 = main menu, 1 = withdraw money, 2 = deposit money
-- 3 = view balance, 4 = transfer money

--these are so that I can check if they are clicked (just string variables, but needed for width etc)
local button1, button2, button3, button4

--misc
local continueLoop = true
local mouseX, mouseY
--------------------------startup--------------------------
term.clear()
rednet.open("back")
print("Please Enter Debit Card Below")

--checking if the disk is present
while disk.isPresent("Bottom")==false do
    os.sleep(0.5)
end

--reading file information
print("Please wait, querying data...")
local dataFile=fs.open("/disk/CheckSum.txt","r")
rednet.send(5,dataFile.readLine(),"Read")
dataFile.close()
local id,message = rednet.receive()

--output information
print("Account Balance : "..message)
disk.eject("Bottom")

-------------------functions-------------------
local function checkClick()
    --check if the mouse has been clicked
    -- Check if the mouse has been clicked
    local event, button, x, y = os.pullEvent("mouse_click")

    mouseX = x
    mouseY = y
    
    if menuMode == 0 then
        if mouseX > (math.floor((width - #text) / 5 + 1)) and mouseX < (math.floor((width) / 5 + 1)) then
            --if here, then it is the left two buttons
                if mouseY > 6 and mouseY < 7 then
                    menuMode = 1 -- withdraw money
                elseif mouseY > 14 and mouseY < 15 then
                    menuMode = 2 -- deposit money
                end
            elseif mouseX > (math.floor((width - #text) / 1.3 + 1)) and mouseX < (math.floor((width) / 1.3 + 1)) then
            -- if here then it is the right two buttons
                if mouseY > 6 and mouseY < 7 then
                    menuMode = 3 -- view balance
                elseif mouseY > 14 and mouseY < 15 then
                    menuMode = 4 -- transfer money
                end
            end 
    end
end

local function getTerminalWidth() -- just so that its easier to write
    local width, height = term.getSize()
end

local function writeCentered(text, line)
    local width, _ = term.getSize()
    local x = math.floor((width - #text) / 2 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function writeLeft(text, line)
    local width, _ = term.getSize()
    local x = math.floor((width - #text) / 5 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function writeRight(text, line)
    local width, _ = term.getSize()
    local x = math.floor((width - #text) / 1.3 + 1)
    term.setCursorPos(x, line)
    term.write(text)
end

local function drawScreen()
    term.setBackgroundColor(colors.lightBlue)
    term.clear()

    if menuMode == 0 then
    --set text information
    getTerminalWidth()
    term.setTextColor(colors.black)

    --write text
    button1 = "[UNAVAILABLE]"
    button2 = "Check Balance"
    button3 = "[UNAVAILABLE]"
    button4 = "Transfer Cash"
    writeCentered("ATM", 1)
    writeLeft(button1, 6) -- withdraw money
    writeRight(button2, 6)
    writeLeft(button3, 14) -- deposit money
    writeRight(button4, 14)
    end
end

-------------------main atm loop-------------------
--reminder, variable for menus is called menuMode
while continueLoop == true do
    drawScreen()



    checkClick()
end

-------------------other-------------------
--ending statement
print("Remember to hold CTRL+S to log out.")
rednet.close()

-------------------notes-------------------
--NOTE: you cannot set text size on non-advanced terminals