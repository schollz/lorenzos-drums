local GGrid = {}

local MODE_INCREASE = 1
local MODE_DECREASE = 2
local MODE_ERASE = 3
local MODE_LENGTH = 4

function GGrid:new(args)
    local m = setmetatable({}, {
        __index = GGrid
    })
    local args = args == nil and {} or args

    m.grid_on = args.grid_on == nil and true or args.grid_on

    -- initiate the grid
    m.g = grid.connect()
    m.g.key = function(x, y, z)
        if m.grid_on then
            m:grid_key(x, y, z)
        end
    end
    print("grid columns: " .. m.g.cols)

    -- setup visual
    m.visual = {}
    m.grid_width = 16
    for i = 1, 8 do
        m.visual[i] = {}
        for j = 1, m.grid_width do
            m.visual[i][j] = 0
        end
    end

    m.mode = MODE_INCREASE
    m.mode_prev = MODE_INCREASE

    -- keep track of pressed buttons
    m.pressed_buttons = {}

    -- grid refreshing
    m.grid_refresh = metro.init()
    m.grid_refresh.time = 0.03
    m.grid_refresh.event = function()
        if m.grid_on then
            m:grid_redraw()
        end
    end
    m.grid_refresh:start()

    return m
end

function GGrid:grid_key(x, y, z)
    self:key_press(y, x, z == 1)
    self:grid_redraw()
end

function GGrid:key_press(row, col, on)
    if on then
        self.pressed_buttons[row .. "," .. col] = true
        if row == 7 then
            self.pressed_buttons[row .. "," .. col] = clock.run(function()
                clock.sleep(1)
                drm[g_sel_drm]:bank_save(col)
                self.just_saved = true
                msg("saved bank " .. col)
            end)
        end
    else
        if row == 7 then
            clock.cancel(self.pressed_buttons[row .. "," .. col])
            self.just_saved = false
        end
        self.pressed_buttons[row .. "," .. col] = nil
    end
    if row == 8 and col == 16 then
        if self.mode ~= MODE_LENGTH then
            self.mode_prev = self.mode
            self.mode = MODE_LENGTH
        else
            self.mode = self.mode_prev
        end
    end
    if not on then
        if row == 7 then
            if self.just_saved == nil or self.just_saved == false then
                -- do a load 
                drm[g_sel_drm]:bank_save(col)
                msg("loaded bank " .. col)
            end
        end
        do
            return
        end
    end
    if row == 8 and col <= 8 then
        self:set_drm(col)
    elseif row < 7 then
        self:adj_ptn(row, col)
    elseif row == 8 and col <= 11 then -- TODO allow prob/reverse
        self:change_ptn(col)
    elseif row == 8 and col == 15 then
        self:change_mode(col)
    end
end

function GGrid:change_mode(col)
    self.mode = self.mode + 1
    if self.mode > 3 then
        self.mode = 1
    end
end

function GGrid:set_mode(mode)
    self.mode = mode
end

function GGrid:change_ptn(col)
    self.mode = MODE_INCREASE
    if col == 9 then
        g_sel_ptn = 1
        do
            return
        end
    end
    local i = 2 * (col - 9)
    if math.floor(i / 2) == math.floor(g_sel_ptn / 2) then
        -- toggle between increase/decrease of current pattern
        g_sel_ptn = g_sel_ptn + (g_sel_ptn % 2 == 0 and 1 or -1)
    else
        g_sel_ptn = i
    end
end

function GGrid:get_pressed()
    local pressed = {}
    for k, _ in pairs(self.pressed_buttons) do
        local row, col = k:match("(%d+),(%d+)")
        table.insert(pressed, {tonumber(row), tonumber(col)})
    end
    return pressed
end

function GGrid:get_pressed_m()
    local pressed = {}
    for k, _ in pairs(self.pressed_buttons) do
        local row, col = k:match("(%d+),(%d+)")
        local m = (tonumber(row) - 1) * 16 + tonumber(col)
        if m < 128 then
            table.insert(pressed, m)
        end
    end
    return pressed
end

function GGrid:adj_ptn(row, col)
    if self.mode == MODE_LENGTH then
        print("adjusting length")
        local pressed = self:get_pressed_m()
        if #pressed == 1 then
            drm[g_sel_drm].ptn[g_sel_ptn]:set_finish(pressed[1])
        elseif #pressed == 2 then
            drm[g_sel_drm].ptn[g_sel_ptn]:set_start_finish(pressed[1], pressed[2])
        end
    elseif self.mode == MODE_ERASE then
        drm[g_sel_drm].ptn[g_sel_ptn]:gerase(row, col)
    elseif self.mode == MODE_INCREASE then
        drm[g_sel_drm].ptn[g_sel_ptn]:gdelta(row, col, 1)
    elseif self.mode == MODE_DECREASE then
        drm[g_sel_drm].ptn[g_sel_ptn]:gdelta(row, col, -1)
    end
end

function GGrid:set_drm(i)
    if i == g_sel_drm then
        -- toggle mute
        drm[i].muted = not drm[i].muted
    end
    g_sel_drm = i
end

function GGrid:get_visual()
    -- clear visual
    for row = 1, 8 do
        for col = 1, self.grid_width do
            self.visual[row][col] = self.visual[row][col] - 2
            if self.visual[row][col] < 0 then
                self.visual[row][col] = 0
            end
        end
    end

    -- show drum selectors
    for col, d in ipairs(drm) do
        local row = 8
        if d.muted then
            self.visual[row][col] = 1
        else
            self.visual[row][col] = (g_sel_drm == col and 8 or 3) + (d.playing and 7 or 0)
        end
    end

    -- show pattern selectors
    if g_sel_ptn == 1 then
        self.visual[8][9] = 10
    else
        self.visual[8][math.floor(g_sel_ptn / 2) + 9] = g_sel_ptn % 2 == 0 and 10 or 5
    end

    -- show mode
    if self.mode == MODE_LENGTH then
        self.visual[8][16] = 10
    elseif self.mode == MODE_ERASE then
        self.visual[8][15] = 0
    elseif self.mode == MODE_INCREASE then
        self.visual[8][15] = 10
    elseif self.mode == MODE_DECREASE then
        self.visual[8][15] = 3
    end

    -- show pattern
    local i = 0
    local d = drm[g_sel_drm].ptn[g_sel_ptn]
    for row = 1, 6 do
        for col = 1, 16 do
            i = i + 1
            self.visual[row][col] = ((i >= d.start and i <= d.finish) and 1 or 0) + d.data[i]
            if d.cur == i then
                self.visual[row][col] = self.visual[row][col] + 1
            end
        end
    end

    -- illuminate currently pressed button
    for k, _ in pairs(self.pressed_buttons) do
        local row, col = k:match("(%d+),(%d+)")
        self.visual[tonumber(row)][tonumber(col)] = 15
    end

    return self.visual
end

function GGrid:grid_redraw()
    self.g:all(0)
    local gd = self:get_visual()
    local s = 1
    local e = self.grid_width
    local adj = 0
    for row = 1, 8 do
        for col = s, e do
            if gd[row][col] ~= 0 then
                self.g:led(col + adj, row, gd[row][col])
            end
        end
    end
    self.g:refresh()
end

return GGrid
