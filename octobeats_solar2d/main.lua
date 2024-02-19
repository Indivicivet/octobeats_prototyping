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
    a, -b,
    b, -a,
    -b, -a,
    -a, -b,
    -a, b,
    -b, a,
    b, a,
    a, b
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

local diag = 1 / math.sqrt(2)
local note_directions = {
    {1, 0},
    {diag, -diag},
    {0, -1},
    {-diag, -diag},
    {-1, 0},
    {-diag, diag},
    {0, 1},
    {diag, diag}
}

local function spawnNote()
    local note_display = display.newCircle(
        GAMEPLAY_MID_X,
        GAMEPLAY_MID_Y,
        30
    )
    note_display.fill = {type="none"}
    note_display.strokeWidth = 5
    note_display.dir_idx = math.random(0, 7)
    local dir = note_directions[note_display.dir_idx + 1]
    note_display.dir_x = dir[1]
    note_display.dir_y = dir[2]
    table.insert(t_note_display, note_display)
end


local function noteButtonPressed(idx)
    --- counting counter clockwise from RHS = 0
    local other_vertex_idx = (idx + 7) % 8
    local disp = display.newLine(
        GAMEPLAY_MID_X + oct_vertices[2 * idx + 1],
        GAMEPLAY_MID_Y + oct_vertices[2 * idx + 2],
        GAMEPLAY_MID_X + oct_vertices[2 * other_vertex_idx + 1],
        GAMEPLAY_MID_Y + oct_vertices[2 * other_vertex_idx + 2]
    )
    disp.strokeWidth = 30

    local function clearNotePressIndicator()
        display.remove(disp)
    end

    timer.performWithDelay(100, clearNotePressIndicator)
end


local function handleKeyPress(event)
    if (event.phase == "up") then
        return
    end
    if (event.keyName == "numPad1" or event.keyName == "end") then
        noteButtonPressed(5)
    end
    if (event.keyName == "numPad2" or event.keyName == "down") then
        noteButtonPressed(6)
    end
    if (event.keyName == "numPad3" or event.keyName == "pageDown") then
        noteButtonPressed(7)
    end
    if (event.keyName == "numPad4" or event.keyName == "left") then
        noteButtonPressed(4)
    end
    -- if we want numPad5 functionality (center button), we'll have to force NumLock on
    if (event.keyName == "numPad6" or event.keyName == "right") then
        noteButtonPressed(0)
    end
    if (event.keyName == "numPad7" or event.keyName == "home") then
        noteButtonPressed(3)
    end
    if (event.keyName == "numPad8" or event.keyName == "up") then
        noteButtonPressed(2)
    end
    if (event.keyName == "numPad9" or event.keyName == "pageUp") then
        noteButtonPressed(1)
    end
end


Runtime:addEventListener("key", handleKeyPress)


-- todo :: no idea if this is working proper.
-- (todo :: actually make this based on frames since that's how Solar2D works...)
local BPM = 180
local BEATS_PER_SECOND = BPM / 60
local UPDATE_RATE = 100
local FRAMES_PER_BEAT = UPDATE_RATE / BEATS_PER_SECOND

local frames_t = 0

local function mainLoop()
    frames_t = frames_t + 1
    while frames_t > FRAMES_PER_BEAT do
        spawnNote()
        frames_t = frames_t - FRAMES_PER_BEAT
    end
    for i, note_display in ipairs(t_note_display) do
        note_display.x = note_display.x + note_display.dir_x * 3
        note_display.y = note_display.y + note_display.dir_y * 3
    end
    timer.performWithDelay(1 / UPDATE_RATE, mainLoop)
end

mainLoop()
