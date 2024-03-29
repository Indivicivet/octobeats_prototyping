-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

math.randomseed(1)  --os.time()

local BPM = 140
local UPDATE_RATE = 60  -- it just always is...
local BEATS_PER_SECOND = BPM / 60
local FRAMES_PER_BEAT = UPDATE_RATE / BEATS_PER_SECOND

-- gameplay stuff; "speed"
local BEAT_COUNT_IN = 2
local BEAT_CENTER_TIME = 1

-- gameplay stuff: timings
local BEATS_MAX_OVERSTEP = 0.2
local BEATS_MAX_PREHIT = 0.2

local NULL_PRESS_PENALTY = 0.2

local HEIGHT = 720

local GAMEPLAY_MID_X = display.contentCenterX
local GAMEPLAY_MID_Y = display.contentCenterY

local oct_size = HEIGHT * 0.5 * 0.8

local click_sound = audio.loadSound("click_0001.wav")

local background = display.newImageRect(
    "octobeats_bg_0001.png", HEIGHT * 3, HEIGHT * 2
)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- background decoration, maybe doesn't help gameplay intuition...?
for ii = -1, 1 do
    for jj = -1, 1 do
        if ii ~= 0 or jj ~= 0 then
            local bg_square = display.newRect(
                GAMEPLAY_MID_X + 0.7 * oct_size * ii,
                GAMEPLAY_MID_Y + 0.7 * oct_size * jj,
                0.4 * oct_size,
                0.4 * oct_size
            )
            bg_square.fill = {type="none"}
            bg_square.strokeWidth = 5
            bg_square.alpha = 0.4
        end
    end
end

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

local notes_hit = 0
local notes_missed = 0
local null_presses = 0

local scoretext_x = display.contentCenterX - oct_size - HEIGHT * 0.15
local notes_hit_text = display.newText(
    "---",
    scoretext_x,
    display.contentCenterY - 100,
    native.systemFont,
    HEIGHT * 0.1
)
local null_presses_text = display.newText(
    null_presses,
    scoretext_x,
    display.contentCenterY,
    native.systemFont,
    HEIGHT * 0.1
)
null_presses_text:setTextColor(1, 0, 0)
local score_text = display.newText(
    "---",
    scoretext_x,
    display.contentCenterY + 150,
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


local frame = 0
local frames_since_last_spawn = 0


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
    note_display.target_hit_time = (
        frame
        + FRAMES_PER_BEAT * (BEAT_COUNT_IN + BEAT_CENTER_TIME)
    )
    note_display.hit_state = "NONE"
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
    local hit_a_note = false
    for i, note_display in ipairs(t_note_display) do
        local ahead_beats = (note_display.target_hit_time - frame) / FRAMES_PER_BEAT 
        if (
            note_display.dir_idx == idx
            and ahead_beats < BEATS_MAX_PREHIT
            and ahead_beats > -BEATS_MAX_OVERSTEP
        ) then
            hit_a_note = true
            note_display.hit_state = "HIT"
            note_display.stroke = {0, 1, 0}
            notes_hit = notes_hit + 1
        end
    end
    if not hit_a_note then
        null_presses = null_presses + 1
    end

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
local function mainLoop()
    frame = frame + 1
    frames_since_last_spawn = frames_since_last_spawn + 1
    while frames_since_last_spawn > FRAMES_PER_BEAT do
        spawnNote()
        frames_since_last_spawn = frames_since_last_spawn - FRAMES_PER_BEAT
    end
    for i, note_display in ipairs(t_note_display) do
        local beat_time_left = (note_display.target_hit_time - frame) / UPDATE_RATE
        local radial = math.max(
            1 - beat_time_left,
            0.2
        ) * oct_size
        if radial > 0 then
            note_display.x = GAMEPLAY_MID_X + radial * note_display.dir_x;
            note_display.y = GAMEPLAY_MID_Y + radial * note_display.dir_y;
        end
        if beat_time_left < 0 and beat_time_left > -1.01 / 60 then
            audio.play(click_sound)
        end
        if beat_time_left < -BEATS_MAX_OVERSTEP then
            if note_display.hit_state == "NONE" then
                note_display.stroke = {1, 0, 0}
                note_display.hit_state = "MISSED" -- currently unused, maybe for future
                notes_missed = notes_missed + 1
            end
            note_display.alpha = math.min(1, 1 + 2 * (beat_time_left + BEATS_MAX_OVERSTEP))
        end
    end

    notes_hit_text.text = string.format("%d / %d", notes_hit, notes_hit + notes_missed)
    null_presses_text.text = null_presses

    if notes_hit > 0 or notes_missed > 0 then
        local score = (notes_hit - null_presses * NULL_PRESS_PENALTY) / (notes_hit + notes_missed)
        score_text.text = string.format("%.1f%%", score * 100)
    end

    timer.performWithDelay(1, mainLoop) -- 60fps cap?
end

mainLoop()
