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

local oct_vertices = {
    oct_size, oct_size / 2,
    oct_size / 2, oct_size,
    -oct_size / 2, oct_size,
    -oct_size, oct_size / 2,
    -oct_size, -oct_size / 2,
    -oct_size / 2, -oct_size,
    oct_size / 2, -oct_size,
    oct_size, -oct_size / 2
}
local oct = display.newPolygon(
    display.contentCenterX,
    display.contentCenterY,
    oct_vertices
)
oct.fill = {type="none"}
oct.strokeWidth = 5
