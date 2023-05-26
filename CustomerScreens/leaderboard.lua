-------------declarations of variables-------------
local leaderboard = peripheral.wrap("monitor_2")
local leaderboardArray = {
    {"CHz01G", "FeR21l", "mNE48r", "QNz23f", "OmX901", "PlK51e", "YrT42P"},
    {0,0,0,0,0,0,0},
    {"Ross","Andrey","Matthew","Xander","Sanders","Momo","Struan"}
}

-------------Functions-------------
local function readFromFiles()
local n = #leaderboardArray[1]
rednet.open("left")

for i = 1, n do
    rednet.send(5, leaderboardArray[1][i], "Read")
    local id, message = rednet.receive()
    leaderboardArray[2][i] = tonumber(message)
end

rednet.close("left")
end

local function bubbleSort()
    local n = #leaderboardArray[1]

    repeat
        local swapped = false
        for i = 1, n - 1 do
            if leaderboardArray[2][i] < leaderboardArray[2][i + 1] then
                leaderboardArray[1][i], leaderboardArray[1][i + 1] = leaderboardArray[1][i + 1], leaderboardArray[1][i]
                leaderboardArray[2][i], leaderboardArray[2][i + 1] = leaderboardArray[2][i + 1], leaderboardArray[2][i]
                leaderboardArray[3][i], leaderboardArray[3][i + 1] = leaderboardArray[3][i + 1], leaderboardArray[3][i]
                swapped = true
            end
        end
        n = n - 1
    until not swapped
end

local function writeCentered(text, line)
    local width, _ = leaderboard.getSize()
    local x = math.floor((width - #text) / 2 + 1)
    leaderboard.setCursorPos(x, line)
    leaderboard.write(text)
end

local function drawScreen()
    --initialise
    leaderboard.clear()
    local n = #leaderboardArray[1]

    leaderboard.setBackgroundColour(colors.lightGray)
    leaderboard.setTextColor(colors.black)

    leaderboard.setCursorPos(1,1)
    writeCentered("Richest Gamblers", 1)

    leaderboard.setTextScale(2)
    local pos={0,0,0}
    local temp=1
    for i=1,#leaderboardArray[2]-1 do
        if leaderboardArray[2][i]>leaderboardArray[2][i+1] and pos[3]==0 then
            pos[temp]=i
            temp=temp+1
        end
        if i==#leaderboardArray[2]-1 and pos[3]==0 then
            pos[3]=#leaderboardArray[2]
        end
    end
    --leaderboard.setTextScale(3)
    for i = 1, n do
        if i <= pos[1] then
            leaderboard.setTextColor(colors.red)
        elseif i <= pos[2] then
            leaderboard.setTextColor(colors.orange)
        elseif i <= pos[3] then
            leaderboard.setTextColor(colors.yellow)
        else
            leaderboard.setTextColor(colors.black)
        end
        writeCentered(leaderboardArray[3][i] .. ": " .. leaderboardArray[2][i], i+2)
    end
end

-------------main loop-------------
while true do

 --read and sort file information
readFromFiles()
bubbleSort()
drawScreen()

-- polls every 15 minutes to be low-performance impacting
os.sleep(900)

end