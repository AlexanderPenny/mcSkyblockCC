local speaker=peripheral.find("speaker")
local run=true
while run do
    speaker.playSound("entity.creeper.primed")
    os.sleep(1)
end