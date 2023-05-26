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
    leaderboardArray[2][i] = message
end

rednet.close("left")
end

local function bubbleSort()
    local n = #leaderboardArray[1]

    repeat
        local swapped = false
        for i = 1, n - 1 do
            if leaderboardArray[2][i] > leaderboardArray[2][i + 1] then
                leaderboardArray[1][i], leaderboardArray[1][i + 1] = leaderboardArray[1][i + 1], leaderboardArray[1][i]
                leaderboardArray[2][i], leaderboardArray[2][i + 1] = leaderboardArray[2][i + 1], leaderboardArray[2][i]
                leaderboardArray[3][i], leaderboardArray[3][i + 1] = leaderboardArray[3][i + 1], leaderboardArray[3][i]
                swapped = true
            end
        end
        n = n - 1
    until not swapped
end

local function drawScreen()
    --initialise
    leaderboard.clear()
    local n = #leaderboardArray[1]

    leaderboard.setBackgroundColour(colors.black)
    leaderboard.setCursorPos(1,1)

    leaderboard.setTextScale(2)
    leaderboard.write("Richest Gamblers")

    --leaderboard.setTextScale(3)
    for i = 1, n do
        leaderboard.setCursorPos(1, i+2)
        leaderboard.write(leaderboardArray[3][i] .. ": " .. leaderboardArray[2][i])
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