-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local background = display.newImageRect(
    "octobeats_bg_0001.png", 2048, 1536
)
background.x = display.contentCenterX
background.y = display.contentCenterY

local oct_size = 100
local a = oct_size
local b = oct_size / (1 + math.sqrt(2))

local oct_vertices = {
    a, b,
    b, a,
    -b, a,
    -a, b,
    -a, -b,
    -b, -a,
    b, -a,
    a, -b
}
local oct = display.newPolygon(
    display.contentCenterX,
    display.contentCenterY,
    oct_vertices
)
oct.fill = {type="none"}
oct.strokeWidth = 5
