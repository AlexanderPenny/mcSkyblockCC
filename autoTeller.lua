-- --------------------------
-- Copyright (c) 2026 Alexander L. Penny & Struan D. A. Dundas
-- Licensed under the MIT License - see LICENSE file for details
-- Project Link - https://github.com/AlexanderPenny/mcSkyblockCC
-- --------------------------

local screenSizeX,screenSizeY=term.getSize()
local run=true
while run do
    paintutils.drawLine((screenSizeX/5),screenSizeY/6,(screenSizeX/5),3*(screenSizeY/6),colours.green)
    paintutils.drawLine(4*(screenSizeX/5)+1,screenSizeY/6,4*(screenSizeX/5)+1,3*(screenSizeY/6),colours.green)
    paintutils.drawLine(2,screenSizeY-1,screenSizeX-1,screenSizeY-1,colours.green)
    sleep(500)
    term.setBackgroundColor(colours.black)
    term.clear()
    paintutils.drawLine((screenSizeX/10),screenSizeY/2,3*(screenSizeX/10),(screenSizeY/2))
    paintutils.drawLine(2,screenSizeY-1,screenSizeX-1,screenSizeY-1,colours.green)
    sleep(500)
    term.setBackgroundColor(colours.black)
    term.clear()
end