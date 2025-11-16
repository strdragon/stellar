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
    if not config.Enabled then
        return true
    end
    
    local KeySystem = {
        ValidKeys = config.Key or {},
        SaveKey = config.SaveKey or false,
        KeyFile = config.FileName or "StellarKey",
        Title = config.Title or "Key System",
        Subtitle = config.Subtitle or "Enter your key",
        Note = config.Note or "No method of obtaining the key is provided",
        KeyLink = config.KeyLink or ""
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
        if KeySystem.KeyLink and KeySystem.KeyLink ~= "" then
            pcall(function()
                setclipboard(KeySystem.KeyLink)
            end)
            Status.Text = "Link copied to clipboard!"
            Status.TextColor3 = Color3.fromRGB(100, 150, 255)
        elseif config.GrabKeyFromSite and config.Key and #config.Key > 0 then
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
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if KeyWindow.Authenticated then
            connection:Disconnect()
        end
    end)
    
    while not KeyWindow.Authenticated do
        RunService.Heartbeat:Wait()
        if not ScreenGui.Parent then
            break
        end
    end
    
    return KeyWindow.Authenticated
end

-- Основной класс Window
function Stellar:CreateWindow(config)
    local Window = {
        Tabs = {},
        CurrentTheme = config.Theme or "Red",
        ConfigSaving = config.ConfigurationSaving or {Enabled = false},
        IsMinimized = false,
        CloseDialogSettings = config.CloseDialog or {
            Title = "Confirm Close",
            Message = "Are you sure you want to close Stellar GUI?",
            ConfirmText = "Confirm",
            CancelText = "Cancel"
        }
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
    
    -- Упрощенные функции создания элементов
    function Window:CreateTab(tabName)
        local tabConfig = {Name = tabName}
        return self:CreateTab(tabConfig)
    end
    
    function Window:CreateTab(tabConfig)
        -- Если передано только имя, а не таблица
        if type(tabConfig) == "string" then
            tabConfig = {Name = tabConfig}
        end
        
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
        
        -- Упрощенные функции для Tab
        function Tab:CreateSection(sectionName)
            local sectionConfig = {Name = sectionName}
            return self:CreateSection(sectionConfig)
        end
        
        function Tab:CreateSection(sectionConfig)
            if type(sectionConfig) == "string" then
                sectionConfig = {Name = sectionConfig}
            end
            
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
            
            -- Упрощенные функции для Section
            function Section:CreateButton(buttonName, callback)
                local buttonConfig = {Name = buttonName, Callback = callback}
                return self:CreateButton(buttonConfig)
            end
            
            function Section:CreateToggle(toggleName, defaultValue, callback)
                local toggleConfig = {Name = toggleName, Default = defaultValue, Callback = callback}
                return self:CreateToggle(toggleConfig)
            end
            
            function Section:CreateSlider(sliderName, min, max, defaultValue, callback)
                local sliderConfig = {Name = sliderName, Min = min, Max = max, Default = defaultValue, Callback = callback}
                return self:CreateSlider(sliderConfig)
            end
            
            function Section:CreateDropdown(dropdownName, options, defaultValue, callback)
                local dropdownConfig = {Name = dropdownName, Options = options, Default = defaultValue, Callback = callback}
                return self:CreateDropdown(dropdownConfig)
            end
            
            function Section:CreateTextbox(textboxName, placeholder, defaultValue, callback)
                local textboxConfig = {Name = textboxName, Placeholder = placeholder, Default = defaultValue, Callback = callback}
                return self:CreateTextbox(textboxConfig)
            end
            
            function Section:CreateKeybind(keybindName, defaultKey, callback)
                local keybindConfig = {Name = keybindName, Default = defaultKey, Callback = callback}
                return self:CreateKeybind(keybindConfig)
            end
            
            function Section:CreateLabel(labelText, alignment)
                local labelConfig = {Text = labelText, Alignment = alignment}
                return self:CreateLabel(labelConfig)
            end
            
            function Section:CreateParagraph(paragraphText)
                local paragraphConfig = {Text = paragraphText}
                return self:CreateParagraph(paragraphConfig)
            end
            
            -- Оригинальные функции (остаются для обратной совместимости)
            function Section:CreateButton(buttonConfig)
                if type(buttonConfig) == "string" then
                    buttonConfig = {Name = buttonConfig}
                end
                
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
            
            -- ... (остальные оригинальные функции CreateToggle, CreateSlider и т.д. остаются такими же)
            
            return Section
        end
        
        return Tab
    end
    
    -- Остальные функции Window (Notify, ConfirmDestroy, Destroy, ChangeTheme) остаются такими же
    function Window:Notify(notificationConfig)
        -- ... (код уведомлений)
    end
    
    function Window:ConfirmDestroy()
        -- ... (код подтверждения закрытия)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:ChangeTheme(themeName)
        if Stellar.Themes[themeName] then
            Window.CurrentTheme = themeName
            TopBar.BackgroundColor3 = Stellar.Themes[themeName].Main
            TabContainer.BackgroundColor3 = Stellar.Themes[themeName].Secondary
            MainFrame.BackgroundColor3 = Stellar.Themes[themeName].Background
        end
    end
    
    return Window
end

-- Загрузка библиотеки
return Stellar
