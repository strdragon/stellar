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

-- Key System
function Stellar:CreateKeySystem(config)
    local KeySystem = {
        ValidKeys = config.Key or {},
        SaveKey = config.SaveKey or false,
        KeyFile = config.FileName or "StellarKey",
        Title = config.Title or "Key System",
        Subtitle = config.Subtitle or "Enter your key",
        Note = config.Note or "No method of obtaining the key is provided"
    }
    
    -- Проверка сохраненного ключа
    if KeySystem.SaveKey then
        local success, saved = pcall(function()
            return readfile(KeySystem.KeyFile .. ".txt")
        end)
        if success and table.find(KeySystem.ValidKeys, saved) then
            return true
        end
    end
    
    -- Создание окна для ввода ключа
    local KeyWindow = {
        Authenticated = false
    }
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarKeySystem",
        DisplayOrder = 999,
        Parent = Player:WaitForChild("PlayerGui")
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Stellar.Themes.Red.Main,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = KeySystem.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = TopBar
    })
    
    local Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -40, 1, -80),
        Position = UDim2.new(0, 20, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local Subtitle = Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = KeySystem.Subtitle,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = Content
    })
    
    local KeyInput = Create("TextBox", {
        Name = "KeyInput",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Enter your key here...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = Content
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = KeyInput
    })
    
    local Note = Create("TextLabel", {
        Name = "Note",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Text = KeySystem.Note,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = Content
    })
    
    local ButtonContainer = Create("Frame", {
        Name = "ButtonContainer",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -50),
        BackgroundTransparency = 1,
        Parent = Content
    })
    
    local CheckButton = Create("TextButton", {
        Name = "CheckButton",
        Size = UDim2.new(0, 120, 0, 35),
        Position = UDim2.new(0.5, -130, 0, 0),
        BackgroundColor3 = Stellar.Themes.Red.Main,
        BorderSizePixel = 0,
        Text = "Check Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = ButtonContainer
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = CheckButton
    })
    
    local CopyButton = Create("TextButton", {
        Name = "CopyButton",
        Size = UDim2.new(0, 120, 0, 35),
        Position = UDim2.new(0.5, 10, 0, 0),
        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
        BorderSizePixel = 0,
        Text = "Copy Link",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = ButtonContainer
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = CopyButton
    })
    
    local Status = Create("TextLabel", {
        Name = "Status",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, 10),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = Content
    })
    
    -- Функционал кнопок
    CheckButton.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        if table.find(KeySystem.ValidKeys, key) then
            Status.Text = "✓ Key accepted!"
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            if KeySystem.SaveKey then
                pcall(function()
                    writefile(KeySystem.KeyFile .. ".txt", key)
                end)
            end
            
            task.wait(1)
            KeyWindow.Authenticated = true
            ScreenGui:Destroy()
        else
            Status.Text = "✗ Invalid key!"
            Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    CopyButton.MouseButton1Click:Connect(function()
        if config.GrabKeyFromSite and config.Key and #config.Key > 0 then
            local keySite = config.Key[1]
            pcall(function()
                setclipboard(keySite)
            end)
            Status.Text = "Link copied to clipboard!"
            Status.TextColor3 = Color3.fromRGB(100, 150, 255)
        else
            Status.Text = "No link available"
            Status.TextColor3 = Color3.fromRGB(255, 150, 100)
        end
    end)
    
    -- Анимации кнопок
    CheckButton.MouseEnter:Connect(function()
        Tween(CheckButton, {BackgroundColor3 = Stellar.Themes.Red.Accent}, 0.2)
    end)
    
    CheckButton.MouseLeave:Connect(function()
        Tween(CheckButton, {BackgroundColor3 = Stellar.Themes.Red.Main}, 0.2)
    end)
    
    CopyButton.MouseEnter:Connect(function()
        Tween(CopyButton, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}, 0.2)
    end)
    
    CopyButton.MouseLeave:Connect(function()
        Tween(CopyButton, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.2)
    end)
    
    -- Ожидание аутентификации
    repeat
        RunService.Heartbeat:Wait()
    until KeyWindow.Authenticated or not ScreenGui.Parent
    
    return KeyWindow.Authenticated
end

-- Основной класс Window
function Stellar:CreateWindow(config)
    local Window = {
        Tabs = {},
        CurrentTheme = config.Theme or "Red",
        ConfigSaving = config.ConfigurationSaving or {Enabled = false},
        IsMinimized = false
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
    
    local MinimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = "_",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
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
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
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
    
    -- Функция сворачивания
    MinimizeButton.MouseButton1Click:Connect(function()
        Window.IsMinimized = not Window.IsMinimized
        if Window.IsMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 30)}, 0.3)
            Tween(MinimizeButton, {Text = "+"}, 0.2)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 400)}, 0.3)
            Tween(MinimizeButton, {Text = "_"}, 0.2)
        end
    end)
    
    -- Функция закрытия с подтверждением
    CloseButton.MouseButton1Click:Connect(function()
        Window:ConfirmDestroy()
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
            
            -- Функции Section (исправленный слайдер и другие элементы)
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
                
                return Button
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
                
                local function StartDragging()
                    dragging = true
                end
                
                local function StopDragging()
                    dragging = false
                end
                
                Handle.MouseButton1Down:Connect(StartDragging)
                Track.MouseButton1Down:Connect(StartDragging)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        StopDragging()
                    end
                end)
                
                Track.MouseButton1Down:Connect(function()
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativeX = mousePos.X - Track.AbsolutePosition.X
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
            
            -- Другие элементы (Dropdown, Textbox, Keybind и т.д.) остаются аналогичными
            
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
    
    function Window:ConfirmDestroy()
        local ConfirmFrame = Create("Frame", {
            Name = "ConfirmFrame",
            Size = UDim2.new(0, 300, 0, 150),
            Position = UDim2.new(0.5, -150, 0.5, -75),
            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Background,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = ConfirmFrame
        })
        
        local Title = Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
            BorderSizePixel = 0,
            Text = "Confirm Close",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Parent = ConfirmFrame
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = Title
        })
        
        local Message = Create("TextLabel", {
            Name = "Message",
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, 50),
            BackgroundTransparency = 1,
            Text = "Are you sure you want to close Stellar GUI?",
            TextColor3 = Stellar.Themes[Window.CurrentTheme].Text,
            TextWrapped = true,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = ConfirmFrame
        })
        
        local ButtonContainer = Create("Frame", {
            Name = "ButtonContainer",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 1, -50),
            BackgroundTransparency = 1,
            Parent = ConfirmFrame
        })
        
        local CancelButton = Create("TextButton", {
            Name = "CancelButton",
            Size = UDim2.new(0, 120, 0, 35),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(80, 80, 80),
            BorderSizePixel = 0,
            Text = "Cancel",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = ButtonContainer
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = CancelButton
        })
        
        local ConfirmButton = Create("TextButton", {
            Name = "ConfirmButton",
            Size = UDim2.new(0, 120, 0, 35),
            Position = UDim2.new(1, -120, 0, 0),
            BackgroundColor3 = Stellar.Themes[Window.CurrentTheme].Main,
            BorderSizePixel = 0,
            Text = "Confirm",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            Parent = ButtonContainer
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = ConfirmButton
        })
        
        CancelButton.MouseButton1Click:Connect(function()
            ConfirmFrame:Destroy()
        end)
        
        ConfirmButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
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

-- Загрузка библиотеки
return Stellar
