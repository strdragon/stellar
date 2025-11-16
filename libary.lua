-- Stellar GUI Library
local Stellar = {}

-- Сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Локальные переменные
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Конфигурация темы
Stellar.Themes = {
    Red = {
        Main = Color3.fromRGB(220, 20, 60),
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(180, 10, 50)
    },
    Blue = {
        Main = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 90, 180)
    },
    Green = {
        Main = Color3.fromRGB(50, 180, 70),
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(40, 150, 60)
    },
    Purple = {
        Main = Color3.fromRGB(140, 50, 200),
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(120, 40, 170)
    }
}

-- Вспомогательные функции
local function Create(class, properties)
    local obj = Instance.new(class)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

local function Tween(Object, Goals, Duration)
    local Tween = TweenService:Create(Object, TweenInfo.new(Duration), Goals)
    Tween:Play()
    return Tween
end

-- Основной класс Window
function Stellar:CreateWindow(config)
    local Window = {
        Tabs = {},
        CurrentTheme = config.Theme or "Red",
        ConfigSaving = config.ConfigurationSaving or {Enabled = false}
    }
    
    -- Создание основного интерфейса
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarGUI",
        DisplayOrder = 10,
        Parent = Player:WaitForChild("PlayerGui")
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    local UICorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Stellar Window",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = TopBar
    })
    
    local CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = TopBar
    })
    
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = TabContainer
    })
    
    local UIListLayout = Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -120, 1, -30),
        Position = UDim2.new(0, 120, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Функционал перетаскивания
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function Update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
    
    -- Закрытие окна
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Функции Window
    function Window:CreateTab(tabConfig)
        local Tab = {
            Name = tabConfig.Name,
            Sections = {}
        }
        
        local TabButton = Create("TextButton", {
            Name = "TabButton",
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, (#Window.Tabs * 35) + 5),
            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
            BorderSizePixel = 0,
            Text = tabConfig.Name,
            TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = TabList
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = TabButton
        })
        
        local TabContent = Create("ScrollingFrame", {
            Name = "TabContent",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = #Window.Tabs == 0,
            Parent = ContentContainer
        })
        
        local ContentLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Content.Visible = false
                Tween(otherTab.Button, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main}, 0.2)
        end)
        
        if #Window.Tabs == 0 then
            Tween(TabButton, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main}, 0.2)
        end
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        -- Функции Tab
        function Tab:CreateSection(sectionConfig)
            local Section = {
                Name = sectionConfig.Name
            }
            
            local SectionFrame = Create("Frame", {
                Name = "SectionFrame",
                Size = UDim2.new(1, -20, 0, 40),
                BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SectionFrame
            })
            
            local SectionTitle = Create("TextLabel", {
                Name = "SectionTitle",
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundTransparency = 1,
                Text = sectionConfig.Name,
                TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                Parent = SectionFrame
            })
            
            local ElementContainer = Create("Frame", {
                Name = "ElementContainer",
                Size = UDim2.new(1, 0, 1, -30),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = SectionFrame
            })
            
            local ElementLayout = Create("UIListLayout", {
                Parent = ElementContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })
            
            Section.Frame = SectionFrame
            Section.ElementContainer = ElementContainer
            
            -- Функции Section
            function Section:CreateButton(buttonConfig)
                local Button = Create("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(1, -10, 0, 30),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
                    BorderSizePixel = 0,
                    Text = buttonConfig.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Button
                })
                
                Button.MouseButton1Click:Connect(function()
                    if buttonConfig.Callback then
                        buttonConfig.Callback()
                    end
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Accent}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main}, 0.2)
                end)
            end
            
            function Section:CreateToggle(toggleConfig)
                local Toggle = {
                    Value = toggleConfig.Default or false
                }
                
                local ToggleFrame = Create("Frame", {
                    Name = "ToggleFrame",
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "ToggleButton",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 10, 0.5, -10),
                    BackgroundColor3 = Toggle.Value and Stellar.Themes[Window.CurrentTheme].Main or Color3.fromRGB(80, 80, 80),
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = ToggleFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ToggleButton
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "ToggleLabel",
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 40, 0, 0),
                    BackgroundTransparency = 1,
                    Text = toggleConfig.Name,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = ToggleFrame
                })
                
                local function UpdateToggle()
                    Tween(ToggleButton, {
                        BackgroundColor3 = Toggle.Value and Stellar.Themes[Window.CurrentTheme].Main or Color3.fromRGB(80, 80, 80)
                    }, 0.2)
                    
                    if toggleConfig.Callback then
                        toggleConfig.Callback(Toggle.Value)
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    UpdateToggle()
                end)
                
                function Toggle:Set(value)
                    Toggle.Value = value
                    UpdateToggle()
                end
                
                return Toggle
            end
            
            function Section:CreateSlider(sliderConfig)
                local Slider = {
                    Value = sliderConfig.Default or sliderConfig.Min
                }
                
                local SliderFrame = Create("Frame", {
                    Name = "SliderFrame",
                    Size = UDim2.new(1, -10, 0, 50),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = SliderFrame
                })
                
                local SliderLabel = Create("TextLabel", {
                    Name = "SliderLabel",
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = sliderConfig.Name,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    Name = "ValueLabel",
                    Size = UDim2.new(0, 60, 0, 20),
                    Position = UDim2.new(1, -70, 0, 5),
                    BackgroundTransparency = 1,
                    Text = tostring(Slider.Value),
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = SliderFrame
                })
                
                local Track = Create("Frame", {
                    Name = "Track",
                    Size = UDim2.new(1, -20, 0, 4),
                    Position = UDim2.new(0, 10, 1, -15),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Parent = SliderFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Track
                })
                
                local Fill = Create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
                    BorderSizePixel = 0,
                    Parent = Track
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Fill
                })
                
                local Handle = Create("TextButton", {
                    Name = "Handle",
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, -6, 0.5, -6),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = Track
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Handle
                })
                
                local function UpdateSlider()
                    local percent = (Slider.Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    Handle.Position = UDim2.new(percent, -6, 0.5, -6)
                    ValueLabel.Text = tostring(Slider.Value)
                    
                    if sliderConfig.Callback then
                        sliderConfig.Callback(Slider.Value)
                    end
                end
                
                local dragging = false
                
                Handle.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                Track.MouseButton1Down:Connect(function(x, y)
                    dragging = true
                    local relativeX = x - Track.AbsolutePosition.X
                    local percent = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
                    Slider.Value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent)
                    UpdateSlider()
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativeX = mousePos.X - Track.AbsolutePosition.X
                        local percent = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
                        Slider.Value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent)
                        UpdateSlider()
                    end
                end)
                
                UpdateSlider()
                
                function Slider:Set(value)
                    Slider.Value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                    UpdateSlider()
                end
                
                return Slider
            end
            
            function Section:CreateDropdown(dropdownConfig)
                local Dropdown = {
                    Value = dropdownConfig.Default,
                    Options = dropdownConfig.Options or {},
                    Open = false
                }
                
                local DropdownFrame = Create("Frame", {
                    Name = "DropdownFrame",
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("TextButton", {
                    Name = "DropdownButton",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = DropdownFrame
                })
                
                local DropdownLabel = Create("TextLabel", {
                    Name = "DropdownLabel",
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Dropdown.Value or dropdownConfig.Name,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = DropdownFrame
                })
                
                local Arrow = Create("TextLabel", {
                    Name = "Arrow",
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = DropdownFrame
                })
                
                local OptionsFrame = Create("ScrollingFrame", {
                    Name = "OptionsFrame",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 3,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    Visible = false,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = OptionsFrame
                })
                
                local OptionsLayout = Create("UIListLayout", {
                    Parent = OptionsFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                local function ToggleDropdown()
                    Dropdown.Open = not Dropdown.Open
                    OptionsFrame.Visible = Dropdown.Open
                    
                    if Dropdown.Open then
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, math.min(#Dropdown.Options * 30, 150))}, 0.2)
                        Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                    end
                end
                
                local function SelectOption(option)
                    Dropdown.Value = option
                    DropdownLabel.Text = option
                    ToggleDropdown()
                    
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(option)
                    end
                end
                
                for _, option in pairs(Dropdown.Options) do
                    local OptionButton = Create("TextButton", {
                        Name = "OptionButton",
                        Size = UDim2.new(1, -10, 0, 25),
                        Position = UDim2.new(0, 5, 0, 0),
                        BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                        BorderSizePixel = 0,
                        Text = option,
                        TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        Parent = OptionsFrame
                    })
                    
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = OptionButton
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectOption(option)
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary}, 0.2)
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
                
                function Dropdown:Set(options)
                    Dropdown.Options = options
                    -- Очистка и пересоздание опций
                    for _, child in pairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in pairs(options) do
                        local OptionButton = Create("TextButton", {
                            Name = "OptionButton",
                            Size = UDim2.new(1, -10, 0, 25),
                            Position = UDim2.new(0, 5, 0, 0),
                            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                            BorderSizePixel = 0,
                            Text = option,
                            TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            Parent = OptionsFrame
                        })
                        
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = OptionButton
                        })
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            SelectOption(option)
                        end)
                    end
                end
                
                return Dropdown
            end
            
            function Section:CreateTextbox(textboxConfig)
                local Textbox = {
                    Value = textboxConfig.Default or ""
                }
                
                local TextboxFrame = Create("Frame", {
                    Name = "TextboxFrame",
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = TextboxFrame
                })
                
                local Textbox = Create("TextBox", {
                    Name = "Textbox",
                    Size = UDim2.new(1, -20, 1, -10),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = textboxConfig.Default or "",
                    PlaceholderText = textboxConfig.Placeholder or "Enter text...",
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = TextboxFrame
                })
                
                Textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and textboxConfig.Callback then
                        textboxConfig.Callback(Textbox.Text)
                    end
                end)
                
                function Textbox:Set(value)
                    Textbox.Text = value
                end
                
                return Textbox
            end
            
            function Section:CreateKeybind(keybindConfig)
                local Keybind = {
                    Value = keybindConfig.Default or Enum.KeyCode.Unknown,
                    Listening = false
                }
                
                local KeybindFrame = Create("Frame", {
                    Name = "KeybindFrame",
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Parent = self.ElementContainer
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Create("TextButton", {
                    Name = "KeybindButton",
                    Size = UDim2.new(0, 80, 0, 20),
                    Position = UDim2.new(1, -90, 0.5, -10),
                    BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
                    BorderSizePixel = 0,
                    Text = Keybind.Value.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    Parent = KeybindFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindButton
                })
                
                local KeybindLabel = Create("TextLabel", {
                    Name = "KeybindLabel",
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keybindConfig.Name,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = KeybindFrame
                })
                
                local function UpdateKeybind()
                    if Keybind.Listening then
                        KeybindButton.Text = "..."
                        KeybindButton.BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Accent
                    else
                        KeybindButton.Text = Keybind.Value.Name
                        KeybindButton.BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main
                    end
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    Keybind.Listening = not Keybind.Listening
                    UpdateKeybind()
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if Keybind.Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Keybind.Value = input.KeyCode
                            Keybind.Listening = false
                            UpdateKeybind()
                            
                            if keybindConfig.Callback then
                                keybindConfig.Callback(Keybind.Value)
                            end
                        end
                    elseif input.KeyCode == Keybind.Value and keybindConfig.Callback then
                        keybindConfig.Callback(Keybind.Value)
                    end
                end)
                
                function Keybind:Set(value)
                    Keybind.Value = value
                    UpdateKeybind()
                end
                
                return Keybind
            end
            
            function Section:CreateLabel(labelConfig)
                local LabelFrame = Create("Frame", {
                    Name = "LabelFrame",
                    Size = UDim2.new(1, -10, 0, 20),
                    BackgroundTransparency = 1,
                    Parent = self.ElementContainer
                })
                
                local Label = Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = labelConfig.Text,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = labelConfig.Alignment or Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = LabelFrame
                })
            end
            
            function Section:CreateParagraph(paragraphConfig)
                local ParagraphFrame = Create("Frame", {
                    Name = "ParagraphFrame",
                    Size = UDim2.new(1, -10, 0, 60),
                    BackgroundTransparency = 1,
                    Parent = self.ElementContainer
                })
                
                local Paragraph = Create("TextLabel", {
                    Name = "Paragraph",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = paragraphConfig.Text,
                    TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    Parent = ParagraphFrame
                })
            end
            
            return Section
        end
        
        return Tab
    end
    
    function Window:Notify(notificationConfig)
        local Notification = Create("Frame", {
            Name = "Notification",
            Size = UDim2.new(0, 300, 0, 80),
            Position = UDim2.new(1, 10, 1, -90),
            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Secondary,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = Notification
        })
        
        local Title = Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = notificationConfig.Title,
            TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            Parent = Notification
        })
        
        local Content = Create("TextLabel", {
            Name = "Content",
            Size = UDim2.new(1, -20, 1, -40),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundTransparency = 1,
            Text = notificationConfig.Content,
            TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = Notification
        })
        
        -- Анимация появления
        Notification.Position = UDim2.new(1, 10, 1, 10)
        Tween(Notification, {Position = UDim2.new(1, 10, 1, -90)}, 0.3)
        
        -- Автоматическое закрытие
        if notificationConfig.Duration then
            task.wait(notificationConfig.Duration)
            Tween(Notification, {Position = UDim2.new(1, 10, 1, 10)}, 0.3)
            task.wait(0.3)
            Notification:Destroy()
        end
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:ChangeTheme(themeName)
        if Stellar.Themes[themeName] then
            Window.CurrentTheme = themeName
            -- Обновление цветов всех элементов
            TopBar.BackgroundColor3 = Stellar.Themes[themeName].Main
            TabContainer.BackgroundColor3 = Stellar.Themes[themeName].Secondary
            MainFrame.BackgroundColor3 = Stellar.Themes[themeName].Background
        end
    end
    
    return Window
end

-- Key System
function Stellar:CreateKeySystem(config)
    local KeySystem = {
        ValidKeys = config.Keys or {},
        SaveKey = config.SaveKey or false,
        KeyFile = config.FileName or "StellarKey"
    }
    
    local KeyWindow = Stellar:CreateWindow({
        Name = config.Title or "Key System",
        Theme = "Red"
    })
    
    local MainTab = KeyWindow:CreateTab({Name = "Authentication"})
    local AuthSection = MainTab:CreateSection({Name = "Key Verification"})
    
    local KeyInput = AuthSection:CreateTextbox({
        Placeholder = "Enter your key...",
        Callback = function(value)
            -- Проверка ключа
        end
    })
    
    local CheckButton = AuthSection:CreateButton({
        Name = "Check Key",
        Callback = function()
            -- Проверка ключа
        end
    })
    
    if config.GrabKeyFromSite then
        local CopyButton = AuthSection:CreateButton({
            Name = "Copy Link",
            Callback = function()
                -- Копирование ссылки
            end
        })
    end
    
    return KeySystem
end

-- Загрузка библиотеки
return Stellar
