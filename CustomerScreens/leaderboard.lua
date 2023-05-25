-------------declarations of variables-------------
local leaderboard = peripheral.wrap("monitor_0")
leaderboard.setTextScale(3)
local leaderboardArray = {
    {"CHz01G", "FeR21l", "mNE48r", "QNz23f", "OmX901", "PlK51e", "YrT42P"},
    {0,0,0,0,0,0,0}
}

-------------Functions-------------
local function readFromFiles()
--read all files into array (idk how files are stored)
end

local function bubbleSort()
    local n #leaderboardArray[1]

    for i = 1, n do
        for j = 1, n-i

        end
    end
end

-------------main loop-------------
while true do

leaderboard.clear()

--read and sort file information
readFromFiles()
bubbleSort()



end