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
    display.contentCenterY + 20,
    oct_vertices
)
oct.fill = {type="none"}
oct.strokeWidth = 5
oct.alpha = 0.7

local score = 0

local score_text = display.newText(
    score, display.contentCenterX, 40, native.systemFont, 50
)
