-- Aegis-Linoria
-- Library:     https://github.com/christianfbi19/Aegis-Linoria
-- Addons from: https://github.com/violin-suzutsuki/LinoriaLib

local repo      = 'https://raw.githubusercontent.com/christianfbi19/Aegis-Linoria/refs/heads/main/'
local addonsRepo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library     = loadstring(game:HttpGet(repo       .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(addonsRepo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(addonsRepo .. 'addons/SaveManager.lua'))()

--  MWindow

local Window = Library:CreateWindow({
    Title        = 'Aegis Linoria',
    Center       = true,
    AutoShow     = true,
    TabPadding   = 0,
    MenuFadeTime = 0.2,
})

--  Tabs

local Tabs = {
    Main            = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--  MTab

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

-- callback:
-- Passing callbacks via element parameters (Callback = function(Value)...) works,
-- but :OnChanged() is the RECOMMENDED approach.
-- Create UI elements first, then wire up :OnChanged() calls below them.

-- Toggle
LeftGroupBox:AddToggle('MyToggle', {
    Text    = 'This is a toggle',
    Default = true,
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

Toggles.MyToggle:OnChanged(function()
    print('MyToggle changed to:', Toggles.MyToggle.Value)
end)

Toggles.MyToggle:SetValue(false) -- prints: "MyToggle changed to: false"

-- Button  (with a chained sub-button)
LeftGroupBox:AddButton({
    Text        = 'Button',
    Func        = function() print('You clicked a button!') end,
    DoubleClick = false,
    Tooltip     = 'This is the main button',
}):AddButton({
    Text        = 'Sub button',
    Func        = function() print('You clicked a sub button!') end,
    DoubleClick = true,  -- must click twice to trigger
    Tooltip     = 'This is a sub button (double-click me!)',
})

-- Labels
LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('This is a label\n\nwhich wraps its text!', true)

-- Divider
LeftGroupBox:AddDivider()

-- Slider
LeftGroupBox:AddSlider('MySlider', {
    Text     = 'This is a slider',
    Default  = 0,
    Min      = 0,
    Max      = 5,
    Rounding = 1,   -- number of decimal places
    Compact  = false,

    Callback = function(Value)
        print('[cb] MySlider changed to:', Value)
    end
})

Options.MySlider:OnChanged(function()
    print('MySlider changed to:', Options.MySlider.Value)
end)

Options.MySlider:SetValue(3) -- prints: "MySlider changed to: 3"

-- Textbox
LeftGroupBox:AddInput('MyTextbox', {
    Default     = 'My textbox!',
    Numeric     = false,  -- true = numbers only
    Finished    = false,  -- true = only fires on Enter

    Text        = 'This is a textbox',
    Tooltip     = 'This is a tooltip',
    Placeholder = 'Placeholder text',

    Callback = function(Value)
        print('[cb] Text updated:', Value)
    end
})

Options.MyTextbox:OnChanged(function()
    print('Text updated:', Options.MyTextbox.Value)
end)

-- Dropdown  (single-select)
LeftGroupBox:AddDropdown('MyDropdown', {
    Values  = { 'This', 'is', 'a', 'dropdown' },
    Default = 1,
    Multi   = false,
    Text    = 'A dropdown',
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        print('[cb] Dropdown changed to:', Value)
    end
})

Options.MyDropdown:OnChanged(function()
    print('Dropdown changed to:', Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue('This')

-- Dropdown  (multi-select)
LeftGroupBox:AddDropdown('MyMultiDropdown', {
    Values  = { 'This', 'is', 'a', 'dropdown' },
    Default = 1,
    Multi   = true,
    Text    = 'A multi-select dropdown',
    Tooltip = 'You can pick more than one option',

    Callback = function(Value)
        print('[cb] Multi dropdown changed:', Value)
    end
})

Options.MyMultiDropdown:OnChanged(function()
    print('Multi dropdown changed:')
    for key, value in next, Options.MyMultiDropdown.Value do
        print(key, value)  -- e.g.  This   true
    end
end)

Options.MyMultiDropdown:SetValue({ This = true, is = true })

-- Player dropdown  (auto-populated from the server)
LeftGroupBox:AddDropdown('MyPlayerDropdown', {
    SpecialType = 'Player',
    Text        = 'A player dropdown',
    Tooltip     = 'Lists everyone currently in the server',

    Callback = function(Value)
        print('[cb] Player dropdown changed:', Value)
    end
})

-- Color picker  (attached to a label)
LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default      = Color3.new(0, 1, 0),  -- bright green
    Title        = 'Some color',
    Transparency = 0,  -- remove this line to disable the transparency slider

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

Options.ColorPicker:OnChanged(function()
    print('Color changed!',        Options.ColorPicker.Value)
    print('Transparency changed!', Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Keybind  (attached to a label)
LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
    Default         = 'MB2',
    SyncToggleState = false,
    Mode            = 'Toggle',  -- Always | Toggle | Hold

    Text = 'A keybind',
    NoUI = false,

    Callback = function(Value)
        print('[cb] Keybind clicked!', Value)
    end,

    ChangedCallback = function(New)
        print('[cb] Keybind changed to:', New)
    end
})

Options.KeyPicker:OnClick(function()
    print('Keybind clicked! State:', Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
    print('Keybind changed to:', Options.KeyPicker.Value)
end)

task.spawn(function()
    while true do
        task.wait(1)
        if Options.KeyPicker:GetState() then
            print('KeyPicker is being held down')
        end
        if Library.Unloaded then break end
    end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Toggle' })

-- ─────────────────────────────────────────────
--  MAIN TAB  —  Left groupbox #2  (scroll demo)
-- ─────────────────────────────────────────────

local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Groupbox #2')
LeftGroupBox2:AddLabel('Oh no...\nThis label spans multiple lines!\n\nWe\'re gonna run out of UI space...\nJust kidding! Scroll down!\n\n\nHello from below!', true)

--  MRTab

local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab 1 toggle' })

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab 2 toggle' })

--  MRGTab

-- Dependency boxes show/hide elements based on another element's state.
-- e.g. only show a slider when its parent toggle is enabled.

local RightGroupbox = Tabs.Main:AddRightGroupbox('Groupbox #3')
RightGroupbox:AddToggle('ControlToggle', { Text = 'Dependency box toggle' })

local Depbox = RightGroupbox:AddDependencyBox()
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' })

-- Dependency boxes can be nested!
local SubDepbox = Depbox:AddDependencyBox()
SubDepbox:AddSlider('DepboxSlider',     { Text = 'Slider',   Default = 50, Min = 0, Max = 100, Rounding = 0 })
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1,  Values = { 'a', 'b', 'c' } })

Depbox:SetupDependencies({
    { Toggles.ControlToggle, true }  -- pass `false` to show only when toggle is OFF
})

SubDepbox:SetupDependencies({
    { Toggles.DepboxToggle, true }
})

--  Watermark

Library:SetWatermarkVisibility(true)

local FrameTimer   = tick()
local FrameCounter = 0
local FPS          = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS          = FrameCounter
        FrameTimer   = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Aegis-Linoria demo | %d fps | %d ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library.KeybindFrame.Visible = true

--  Unload handler

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end)

--  UI Settings tab

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI    = true,
    Text    = 'Menu keybind',
})

Library.ToggleKeybind = Options.MenuKeybind

--  Addons: ThemeManager + SaveManager

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Don't save theme settings inside configs
SaveManager:IgnoreThemeSettings()

-- Don't save the menu keybind per-config
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- Folder layout:
--   MyScriptHub/           ← theme storage
--   MyScriptHub/my-game/   ← config storage
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/my-game')

-- Builds the config panel on the RIGHT side of the UI Settings tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds the theme panel on the LEFT side of the UI Settings tab
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Load whatever config the user marked as autoload (if any)
SaveManager:LoadAutoloadConfig()
