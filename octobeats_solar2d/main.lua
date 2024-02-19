-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

math.randomseed(1)  --os.time()

local HEIGHT = 720

local GAMEPLAY_MID_X = display.contentCenterX
local GAMEPLAY_MID_Y = display.contentCenterY

local background = display.newImageRect(
    "octobeats_bg_0001.png", HEIGHT * 3, HEIGHT * 2
)
background.x = display.contentCenterX
background.y = display.contentCenterY

local oct_size = HEIGHT * 0.5 * 0.8
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
    GAMEPLAY_MID_X,
    GAMEPLAY_MID_Y,
    oct_vertices
)
oct.fill = {type="none"}
oct.strokeWidth = HEIGHT * 0.01
oct.alpha = 0.7

local score = 0

local score_text = display.newText(
    score,
    display.contentCenterX - oct_size - HEIGHT * 0.15,
    display.contentCenterY,
    native.systemFont,
    HEIGHT * 0.15
)

local t_note_display = {}

local function spawnNote()
    local note_display = display.newCircle(
        GAMEPLAY_MID_X + math.random() * 100,
        GAMEPLAY_MID_Y + math.random() * 100,
        10
    )
    table.insert(t_note_display, note_display)
end


local function handleKeyPress(event)
    if (event.phase == "up") then
        return
    end
    if (event.keyName == "numPad1" or event.keyName == "end") then
        spawnNote()
    end
    if (event.keyName == "numPad2" or event.keyName == "down") then
        spawnNote()
    end
    if (event.keyName == "numPad3" or event.keyName == "pageDown") then
        spawnNote()
    end
    if (event.keyName == "numPad4" or event.keyName == "left") then
        spawnNote()
    end
    -- if we want numPad5 functionality (center button), we'll have to force NumLock on
    if (event.keyName == "numPad6" or event.keyName == "right") then
        spawnNote()
    end
    if (event.keyName == "numPad7" or event.keyName == "home") then
        spawnNote()
    end
    if (event.keyName == "numPad8" or event.keyName == "up") then
        spawnNote()
    end
    if (event.keyName == "numPad9" or event.keyName == "pageUp") then
        spawnNote()
    end
end


Runtime:addEventListener("key", handleKeyPress)
