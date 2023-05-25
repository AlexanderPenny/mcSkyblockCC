local run=true
local i=0
local xSize, ySize = term.getSize()
local loadingStr="£££ WIN BIG £££"
local textScale=2
local monitor = peripheral.find("monitor")
local idle,main=true,false
monitor.setTextScale(textScale)
while run do
    if idle then
        i=i+1
        term.setCursorPos(math.ceil((xSize/2)-loadingStr:len()/2),math.ceil(ySize/2))
        term.setBackgroundColour(2^i)
        print(loadingStr)
        if i==15 then
            --if loadingStr=="£££ WIN BIG £££" then
            --    loadingStr="£ £ £ WIN BIG £ £ £"
            --else
            --    loadingStr="£££ WIN BIG £££"
            --end
            i=0
        end
    end
    os.sleep(0.01)
    term.clear()
end