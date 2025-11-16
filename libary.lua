-- Stellar GUI Library v3.1 - Enhanced Version
local Stellar = {}

-- Конфигурация по умолчанию (Black Theme)
Stellar.Configuration = {
    WindowBackground = Color3.fromRGB(20, 20, 20),
    TabBackground = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 85, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    BorderColor = Color3.fromRGB(40, 40, 40),
    SuccessColor = Color3.fromRGB(0, 200, 0),
    WarningColor = Color3.fromRGB(255, 165, 0),
    ErrorColor = Color3.fromRGB(255, 50, 50)
}

Stellar.KeySystem = {
    Enabled = false,
    Title = "Stellar Key System",
    Keys = {"12345", "stellar2024", "admin"},
    Input = "",
    FileName = "stellar_key.txt",
    CopyLink = "" -- Добавлен параметр для ссылки
}

Stellar.Saving = {
    Enabled = true,
    FolderName = "StellarConfigs",
    FileName = "stellar_settings"
}

-- Анимации
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function tweenObject(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Функция для копирования в буфер обмена
local function copyToClipboard(text)
    local Clipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if Clipboard then
        Clipboard(text)
        return true
    else
        return false
    end
end

-- Создание главного окна
function Stellar:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Visible = true
    Window.Settings = {}
    
    -- Применение кастомной темы если есть
    if config.Theme then
        for key, value in pairs(config.Theme) do
            if Stellar.Configuration[key] then
                Stellar.Configuration[key] = value
            end
        end
    end
    
    -- Система ключей
    if config.KeySystem then
        Stellar.KeySystem.Enabled = config.KeySystem.Enabled or false
        Stellar.KeySystem.Title = config.KeySystem.Title or "Stellar Key System"
        Stellar.KeySystem.Keys = config.KeySystem.Keys or {"default"}
        Stellar.KeySystem.Input = config.KeySystem.Input or ""
        Stellar.KeySystem.CopyLink = config.KeySystem.CopyLink or ""
    end
    
    -- Система сохранения
    if config.ConfigurationSaving then
        Stellar.Saving.Enabled = config.ConfigurationSaving.Enabled or true
        Stellar.Saving.FolderName = config.ConfigurationSaving.FolderName or "StellarConfigs"
        Stellar.Saving.FileName = config.ConfigurationSaving.FileName or "stellar_settings"
    end
    
    -- Проверка ключа если включена система
    if Stellar.KeySystem.Enabled then
        local keyValid = false
        
        -- Попытка загрузить сохраненный ключ
        if isfile(Stellar.KeySystem.FileName) then
            local savedKey = readfile(Stellar.KeySystem.FileName)
            for _, validKey in pairs(Stellar.KeySystem.Keys) do
                if savedKey == validKey then
                    keyValid = true
                    break
                end
            end
        end
        
        if not keyValid then
            keyValid = Stellar:ShowKeySystem()
            if not keyValid then
                return nil
            end
        end
    end
    
    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StellarGUI"
    ScreenGui.Parent = game.CoreGui
    
    -- Главный контейнер
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    MainFrame.BackgroundColor3 = Stellar.Configuration.WindowBackground
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Stellar.Configuration.BorderColor
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Заголовок для перетаскивания
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Size = UDim2.new(1, 0, 0, 35)
    TitleFrame.Position = UDim2.new(0, 0, 0, 0)
    TitleFrame.BackgroundColor3 = Stellar.Configuration.Accent
    TitleFrame.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "Stellar GUI v3.1"
    Title.TextColor3 = Stellar.Configuration.TextColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleFrame
    
    -- Кнопки управления окном
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Stellar.Configuration.ErrorColor
    CloseButton.TextColor3 = Stellar.Configuration.TextColor
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleFrame
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -65, 0, 5)
    MinimizeButton.BackgroundColor3 = Stellar.Configuration.WarningColor
    MinimizeButton.TextColor3 = Stellar.Configuration.TextColor
    MinimizeButton.Text = "_"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 14
    MinimizeButton.Parent = TitleFrame
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
    MinimizeCorner.Parent = MinimizeButton
    
    -- Контейнер для табов
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -20, 0, 35)
    TabsContainer.Position = UDim2.new(0, 10, 0, 40)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = TabsContainer
    
    -- Контейнер для контента
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -90)
    ContentContainer.Position = UDim2.new(0, 10, 0, 80)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    local ContentScrolling = Instance.new("ScrollingFrame")
    ContentScrolling.Name = "ContentScrolling"
    ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
    ContentScrolling.BackgroundTransparency = 1
    ContentScrolling.ScrollBarThickness = 3
    ContentScrolling.ScrollBarImageColor3 = Stellar.Configuration.BorderColor
    ContentScrolling.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 15)
    ContentLayout.Parent = ContentScrolling
    
    -- Перетаскивание окна
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleFrame.InputBegan:Connect(function(input)
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
    
    TitleFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Функционал кнопок управления
    CloseButton.MouseButton1Click:Connect(function()
        Stellar:ShowConfirmation("Закрыть GUI?", "Вы уверены что хотите закрыть Stellar GUI?", function(result)
            if result then
                tweenObject(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
                wait(0.3)
                ScreenGui:Destroy()
            end
        end)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if Window.Visible then
            tweenObject(MainFrame, {Size = UDim2.new(0, 550, 0, 35)}, 0.3)
        else
            tweenObject(MainFrame, {Size = UDim2.new(0, 550, 0, 450)}, 0.3)
        end
        Window.Visible = not Window.Visible
    end)
    
    -- Анимации при наведении (без свечения)
    CloseButton.MouseEnter:Connect(function()
        tweenObject(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        tweenObject(CloseButton, {BackgroundColor3 = Stellar.Configuration.ErrorColor}, 0.2)
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        tweenObject(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(200, 120, 0)}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        tweenObject(MinimizeButton, {BackgroundColor3 = Stellar.Configuration.WarningColor}, 0.2)
    end)
    
    -- Функция создания таба
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Visible = false
        
        -- Кнопка таба
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.BackgroundColor3 = Stellar.Configuration.TabBackground
        TabButton.Text = name
        TabButton.TextColor3 = Stellar.Configuration.TextColor
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 13
        TabButton.Parent = TabsContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Контент таба
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Stellar.Configuration.BorderColor
        TabContent.Visible = false
        TabContent.Parent = ContentScrolling
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 10)
        TabContentLayout.Parent = TabContent
        
        -- Обработчик клика с анимацией
        TabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(Window.Tabs) do
                existingTab:SetVisible(false)
            end
            Tab:SetVisible(true)
        end)
        
        -- Анимация при наведении на таб
        TabButton.MouseEnter:Connect(function()
            if not Tab.Visible then
                tweenObject(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not Tab.Visible then
                tweenObject(TabButton, {BackgroundColor3 = Stellar.Configuration.TabBackground}, 0.2)
            end
        end)
        
        -- Функция видимости
        function Tab:SetVisible(state)
            TabContent.Visible = state
            if state then
                tweenObject(TabButton, {BackgroundColor3 = Stellar.Configuration.Accent}, 0.3)
                Window.CurrentTab = Tab
            else
                tweenObject(TabButton, {BackgroundColor3 = Stellar.Configuration.TabBackground}, 0.3)
            end
            Tab.Visible = state
        end
        
        -- Функция создания секции
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Stellar.Configuration.TabBackground
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Stellar.Configuration.TextColor
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = "Elements"
            ElementsContainer.Size = UDim2.new(1, -20, 0, 0)
            ElementsContainer.Position = UDim2.new(0, 10, 0, 30)
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Parent = SectionFrame
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.Padding = UDim.new(0, 8)
            ElementsLayout.Parent = ElementsContainer
            
            -- Функция создания кнопки
            function Section:CreateButton(config)
                local Button = Instance.new("TextButton")
                Button.Name = config.Name
                Button.Size = UDim2.new(1, 0, 0, 32)
                Button.BackgroundColor3 = Stellar.Configuration.Accent
                Button.Text = config.Name
                Button.TextColor3 = Stellar.Configuration.TextColor
                Button.Font = Enum.Font.GothamSemibold
                Button.TextSize = 13
                Button.Parent = ElementsContainer
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                -- Анимация кнопки (без свечения)
                Button.MouseEnter:Connect(function()
                    tweenObject(Button, {BackgroundColor3 = Color3.fromRGB(20, 100, 255)}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    tweenObject(Button, {BackgroundColor3 = Stellar.Configuration.Accent}, 0.2)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    tweenObject(Button, {Size = UDim2.new(0.95, 0, 0, 28)}, 0.1)
                    tweenObject(Button, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
                    if config.Callback then
                        config.Callback()
                    end
                end)
                
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 40)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
            end
            
            -- Функция создания тоггла
            function Section:CreateToggle(config)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = config.Name
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = ElementsContainer
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Toggle"
                ToggleButton.Size = UDim2.new(0, 50, 0, 25)
                ToggleButton.Position = UDim2.new(1, -55, 0, 2)
                ToggleButton.BackgroundColor3 = Stellar.Configuration.BorderColor
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 12)
                ToggleCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 21, 0, 21)
                ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
                ToggleIndicator.BackgroundColor3 = Stellar.Configuration.TextColor
                ToggleIndicator.Parent = ToggleButton
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(0, 10)
                IndicatorCorner.Parent = ToggleIndicator
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Name
                ToggleLabel.TextColor3 = Stellar.Configuration.TextColor
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextSize = 13
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local state = config.CurrentValue or false
                
                local function updateToggle()
                    if state then
                        tweenObject(ToggleButton, {BackgroundColor3 = Stellar.Configuration.Accent}, 0.2)
                        tweenObject(ToggleIndicator, {Position = UDim2.new(0, 27, 0, 2)}, 0.2)
                    else
                        tweenObject(ToggleButton, {BackgroundColor3 = Stellar.Configuration.BorderColor}, 0.2)
                        tweenObject(ToggleIndicator, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                    end
                    if config.Flag then
                        Window.Settings[config.Flag] = state
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                    if config.Callback then
                        config.Callback(state)
                    end
                end)
                
                -- Загрузка сохраненного состояния
                if config.Flag and Stellar.Saving.Enabled then
                    local success, saved = pcall(function()
                        return readfile(Stellar.Saving.FolderName .. "/" .. Stellar.Saving.FileName .. ".json")
                    end)
                    if success and saved then
                        local data = game:GetService("HttpService"):JSONDecode(saved)
                        if data[config.Flag] ~= nil then
                            state = data[config.Flag]
                            updateToggle()
                        end
                    end
                end
                
                updateToggle()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 38)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
            end
            
            -- Функция создания слайдера
            function Section:CreateSlider(config)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = config.Name
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = ElementsContainer
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, 0, 0, 18)
                SliderLabel.Position = UDim2.new(0, 0, 0, 0)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Name
                SliderLabel.TextColor3 = Stellar.Configuration.TextColor
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextSize = 13
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "ValueLabel"
                ValueLabel.Size = UDim2.new(0, 60, 0, 18)
                ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(config.CurrentValue or config.Range[1]) .. (config.Suffix or "")
                ValueLabel.TextColor3 = Stellar.Configuration.Accent
                ValueLabel.Font = Enum.Font.GothamSemibold
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.Size = UDim2.new(1, 0, 0, 6)
                SliderTrack.Position = UDim2.new(0, 0, 0, 25)
                SliderTrack.BackgroundColor3 = Stellar.Configuration.BorderColor
                SliderTrack.Parent = SliderFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 3)
                TrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Stellar.Configuration.Accent
                SliderFill.Parent = SliderTrack
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = SliderFill
                
                local currentValue = config.CurrentValue or config.Range[1]
                local range = config.Range[2] - config.Range[1]
                
                local function updateSlider(value)
                    currentValue = math.clamp(math.floor(value), config.Range[1], config.Range[2])
                    local percentage = (currentValue - config.Range[1]) / range
                    tweenObject(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.2)
                    ValueLabel.Text = currentValue .. (config.Suffix or "")
                    
                    if config.Flag then
                        Window.Settings[config.Flag] = currentValue
                    end
                    
                    if config.Callback then
                        config.Callback(currentValue)
                    end
                end
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local connection
                        connection = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
                            if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                                local relativeX = math.clamp(moveInput.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
                                local percentage = relativeX / SliderTrack.AbsoluteSize.X
                                local value = config.Range[1] + (percentage * range)
                                updateSlider(value)
                            end
                        end)
                        
                        game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
                
                updateSlider(currentValue)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 58)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
            end
            
            -- Функция создания дропдауна
            function Section:CreateDropdown(config)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = config.Name
                DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = ElementsContainer
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(1, 0, 0, 32)
                DropdownButton.BackgroundColor3 = Stellar.Configuration.BorderColor
                DropdownButton.Text = config.Name .. ": " .. config.CurrentOption
                DropdownButton.TextColor3 = Stellar.Configuration.TextColor
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextSize = 13
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Name = "Arrow"
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 6)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Stellar.Configuration.TextColor
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.TextSize = 12
                DropdownArrow.Parent = DropdownButton
                
                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "Options"
                DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                DropdownOptions.Position = UDim2.new(0, 0, 0, 37)
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.Visible = false
                DropdownOptions.Parent = DropdownFrame
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Padding = UDim.new(0, 5)
                OptionsLayout.Parent = DropdownOptions
                
                local isOpen = false
                local currentOption = config.CurrentOption
                
                local function updateDropdown()
                    DropdownButton.Text = config.Name .. ": " .. currentOption
                    tweenObject(DropdownArrow, {Rotation = isOpen and 180 or 0}, 0.2)
                    
                    if config.Flag then
                        Window.Settings[config.Flag] = currentOption
                    end
                    
                    if config.Callback then
                        config.Callback(currentOption)
                    end
                end
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    DropdownOptions.Visible = isOpen
                    
                    if isOpen then
                        for _, option in pairs(config.Options) do
                            local OptionButton = Instance.new("TextButton")
                            OptionButton.Name = option
                            OptionButton.Size = UDim2.new(1, 0, 0, 28)
                            OptionButton.BackgroundColor3 = Stellar.Configuration.TabBackground
                            OptionButton.Text = option
                            OptionButton.TextColor3 = Stellar.Configuration.TextColor
                            OptionButton.Font = Enum.Font.Gotham
                            OptionButton.TextSize = 12
                            OptionButton.Parent = DropdownOptions
                            
                            local OptionCorner = Instance.new("UICorner")
                            OptionCorner.CornerRadius = UDim.new(0, 4)
                            OptionCorner.Parent = OptionButton
                            
                            OptionButton.MouseEnter:Connect(function()
                                tweenObject(OptionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                            end)
                            
                            OptionButton.MouseLeave:Connect(function()
                                tweenObject(OptionButton, {BackgroundColor3 = Stellar.Configuration.TabBackground}, 0.2)
                            end)
                            
                            OptionButton.MouseButton1Click:Connect(function()
                                currentOption = option
                                updateDropdown()
                                toggleDropdown()
                            end)
                        end
                        DropdownOptions.Size = UDim2.new(1, 0, 0, #config.Options * 33)
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 32 + (#config.Options * 33))
                    else
                        DropdownOptions:ClearAllChildren()
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                    end
                    
                    SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + (isOpen and (#config.Options * 33) or 0))
                    TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
                end
                
                DropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                -- Анимация кнопки
                DropdownButton.MouseEnter:Connect(function()
                    tweenObject(DropdownButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    tweenObject(DropdownButton, {BackgroundColor3 = Stellar.Configuration.BorderColor}, 0.2)
                end)
                
                updateDropdown()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 40)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
            end
            
            table.insert(Window.Tabs, Tab)
            return Section
        end
        
        -- Активируем первый таб
        if #Window.Tabs == 0 then
            Tab:SetVisible(true)
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Функция сохранения настроек
    function Window:SaveConfiguration()
        if not Stellar.Saving.Enabled then return end
        
        local success, message = pcall(function()
            if not isfolder(Stellar.Saving.FolderName) then
                makefolder(Stellar.Saving.FolderName)
            end
            
            local data = game:GetService("HttpService"):JSONEncode(Window.Settings)
            writefile(Stellar.Saving.FolderName .. "/" .. Stellar.Saving.FileName .. ".json", data)
        end)
        
        if success then
            Stellar:Notify({
                Title = "Сохранение",
                Content = "Настройки успешно сохранены!",
                Duration = 2
            })
        else
            Stellar:Notify({
                Title = "Ошибка",
                Content = "Не удалось сохранить настройки: " .. message,
                Duration = 3
            })
        end
    end
    
    -- Функция загрузки настроек
    function Window:LoadConfiguration()
        if not Stellar.Saving.Enabled then return end
        
        local success, data = pcall(function()
            return readfile(Stellar.Saving.FolderName .. "/" .. Stellar.Saving.FileName .. ".json")
        end)
        
        if success and data then
            local loadedSettings = game:GetService("HttpService"):JSONDecode(data)
            Window.Settings = loadedSettings
            Stellar:Notify({
                Title = "Загрузка",
                Content = "Настройки успешно загружены!",
                Duration = 2
            })
            return loadedSettings
        end
        return nil
    end
    
    -- Функция сброса настроек
    function Window:ResetConfiguration()
        Stellar:ShowConfirmation("Сброс настроек", "Вы уверены что хотите сбросить все настройки?", function(result)
            if result then
                Window.Settings = {}
                if isfile(Stellar.Saving.FolderName .. "/" .. Stellar.Saving.FileName .. ".json") then
                    delfile(Stellar.Saving.FolderName .. "/" .. Stellar.Saving.FileName .. ".json")
                end
                Stellar:Notify({
                    Title = "Сброс",
                    Content = "Все настройки сброшены!",
                    Duration = 2
                })
            end
        end)
    end
    
    -- Автоматическая загрузка настроек при создании
    if Stellar.Saving.Enabled then
        Window:LoadConfiguration()
    end
    
    return Window
end

-- Система ключей
function Stellar:ShowKeySystem()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "StellarKeySystem"
    KeyGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "KeyFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 280) -- Увеличил высоту для кнопки Copy Link
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
    MainFrame.BackgroundColor3 = Stellar.Configuration.WindowBackground
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Stellar.Configuration.BorderColor
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Size = UDim2.new(1, 0, 0, 40)
    TitleFrame.Position = UDim2.new(0, 0, 0, 0)
    TitleFrame.BackgroundColor3 = Stellar.Configuration.Accent
    TitleFrame.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Stellar.KeySystem.Title
    Title.TextColor3 = Stellar.Configuration.TextColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = TitleFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "KeyInput"
    InputBox.Size = UDim2.new(0.8, 0, 0, 40)
    InputBox.Position = UDim2.new(0.1, 0, 0.25, 0)
    InputBox.BackgroundColor3 = Stellar.Configuration.TabBackground
    InputBox.TextColor3 = Stellar.Configuration.TextColor
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 14
    InputBox.PlaceholderText = "Введите ключ доступа..."
    InputBox.Parent = MainFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputBox
    
    -- Кнопка Submit
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0.35, 0, 0, 35)
    SubmitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    SubmitButton.BackgroundColor3 = Stellar.Configuration.SuccessColor
    SubmitButton.TextColor3 = Stellar.Configuration.TextColor
    SubmitButton.Text = "ПОДТВЕРДИТЬ"
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 12
    SubmitButton.Parent = MainFrame
    
    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitButton
    
    -- Кнопка Copy Link
    local CopyLinkButton = Instance.new("TextButton")
    CopyLinkButton.Name = "CopyLinkButton"
    CopyLinkButton.Size = UDim2.new(0.35, 0, 0, 35)
    CopyLinkButton.Position = UDim2.new(0.55, 0, 0.6, 0)
    CopyLinkButton.BackgroundColor3 = Stellar.Configuration.Accent
    CopyLinkButton.TextColor3 = Stellar.Configuration.TextColor
    CopyLinkButton.Text = "COPY LINK"
    CopyLinkButton.Font = Enum.Font.GothamBold
    CopyLinkButton.TextSize = 12
    CopyLinkButton.Parent = MainFrame
    
    local CopyLinkCorner = Instance.new("UICorner")
    CopyLinkCorner.CornerRadius = UDim.new(0, 6)
    CopyLinkCorner.Parent = CopyLinkButton
    
    local result = false
    
    SubmitButton.MouseButton1Click:Connect(function()
        local inputKey = InputBox.Text
        for _, validKey in pairs(Stellar.KeySystem.Keys) do
            if inputKey == validKey then
                -- Сохранение ключа в файл
                writefile(Stellar.KeySystem.FileName, inputKey)
                result = true
                KeyGui:Destroy()
                return
            end
        end
        Stellar:Notify({
            Title = "Ошибка",
            Content = "Неверный ключ доступа!",
            Duration = 3
        })
    end)
    
    CopyLinkButton.MouseButton1Click:Connect(function()
        if Stellar.KeySystem.CopyLink and Stellar.KeySystem.CopyLink ~= "" then
            local success = copyToClipboard(Stellar.KeySystem.CopyLink)
            if success then
                Stellar:Notify({
                    Title = "Успех",
                    Content = "Ссылка скопирована в буфер обмена!",
                    Duration = 2
                })
            else
                Stellar:Notify({
                    Title = "Ошибка",
                    Content = "Не удалось скопировать ссылку",
                    Duration = 2
                })
            end
        else
            Stellar:Notify({
                Title = "Информация",
                Content = "Ссылка не указана в настройках",
                Duration = 2
            })
        end
    end)
    
    -- Анимации кнопок
    SubmitButton.MouseEnter:Connect(function()
        tweenObject(SubmitButton, {BackgroundColor3 = Color3.fromRGB(0, 180, 0)}, 0.2)
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        tweenObject(SubmitButton, {BackgroundColor3 = Stellar.Configuration.SuccessColor}, 0.2)
    end)
    
    CopyLinkButton.MouseEnter:Connect(function()
        tweenObject(CopyLinkButton, {BackgroundColor3 = Color3.fromRGB(20, 100, 255)}, 0.2)
    end)
    
    CopyLinkButton.MouseLeave:Connect(function()
        tweenObject(CopyLinkButton, {BackgroundColor3 = Stellar.Configuration.Accent}, 0.2)
    end)
    
    -- Ожидание результата
    repeat wait() until not KeyGui.Parent
    return result
end

-- Система подтверждения
function Stellar:ShowConfirmation(title, message, callback)
    local ConfirmGui = Instance.new("ScreenGui")
    ConfirmGui.Name = "StellarConfirmation"
    ConfirmGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ConfirmFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    MainFrame.BackgroundColor3 = Stellar.Configuration.WindowBackground
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Stellar.Configuration.BorderColor
    MainFrame.Parent = ConfirmGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Size = UDim2.new(1, 0, 0, 35)
    TitleFrame.Position = UDim2.new(0, 0, 0, 0)
    TitleFrame.BackgroundColor3 = Stellar.Configuration.Accent
    TitleFrame.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "Подтверждение"
    Title.TextColor3 = Stellar.Configuration.TextColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = TitleFrame
    
    local Message = Instance.new("TextLabel")
    Message.Name = "Message"
    Message.Size = UDim2.new(0.9, 0, 0, 60)
    Message.Position = UDim2.new(0.05, 0, 0.3, 0)
    Message.BackgroundTransparency = 1
    Message.Text = message or "Вы уверены?"
    Message.TextColor3 = Stellar.Configuration.TextColor
    Message.Font = Enum.Font.Gotham
    Message.TextSize = 14
    Message.TextWrapped = true
    Message.Parent = MainFrame
    
    local YesButton = Instance.new("TextButton")
    YesButton.Name = "YesButton"
    YesButton.Size = UDim2.new(0.4, 0, 0, 35)
    YesButton.Position = UDim2.new(0.08, 0, 0.75, 0)
    YesButton.BackgroundColor3 = Stellar.Configuration.SuccessColor
    YesButton.TextColor3 = Stellar.Configuration.TextColor
    YesButton.Text = "ДА"
    YesButton.Font = Enum.Font.GothamBold
    YesButton.TextSize = 14
    YesButton.Parent = MainFrame
    
    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 6)
    YesCorner.Parent = YesButton
    
    local NoButton = Instance.new("TextButton")
    NoButton.Name = "NoButton"
    NoButton.Size = UDim2.new(0.4, 0, 0, 35)
    NoButton.Position = UDim2.new(0.52, 0, 0.75, 0)
    NoButton.BackgroundColor3 = Stellar.Configuration.ErrorColor
    NoButton.TextColor3 = Stellar.Configuration.TextColor
    NoButton.Text = "НЕТ"
    NoButton.Font = Enum.Font.GothamBold
    NoButton.TextSize = 14
    NoButton.Parent = MainFrame
    
    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 6)
    NoCorner.Parent = NoButton
    
    YesButton.MouseButton1Click:Connect(function()
        callback(true)
        ConfirmGui:Destroy()
    end)
    
    NoButton.MouseButton1Click:Connect(function()
        callback(false)
        ConfirmGui:Destroy()
    end)
end

-- Функция уведомления
function Stellar:Notify(config)
    local Notification = Instance.new("ScreenGui")
    Notification.Name = "StellarNotification"
    Notification.Parent = game.CoreGui
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
    NotificationFrame.Position = UDim2.new(1, -320, 1, -100)
    NotificationFrame.BackgroundColor3 = Stellar.Configuration.WindowBackground
    NotificationFrame.BorderSizePixel = 1
    NotificationFrame.BorderColor3 = Stellar.Configuration.BorderColor
    NotificationFrame.Parent = Notification
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotificationFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -10, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Notification"
    Title.TextColor3 = Stellar.Configuration.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = NotificationFrame
    
    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -35)
    Content.Position = UDim2.new(0, 10, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Text = config.Content or ""
    Content.TextColor3 = Stellar.Configuration.TextColor
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 12
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.TextWrapped = true
    Content.Parent = NotificationFrame
    
    -- Анимация появления
    tweenObject(NotificationFrame, {Position = UDim2.new(1, -320, 1, -120)}, 0.3)
    
    wait(config.Duration or 5)
    
    -- Анимация исчезновения
    tweenObject(NotificationFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.3)
    wait(0.3)
    Notification:Destroy()
end

-- Функция смены темы
function Stellar:ChangeTheme(newTheme)
    for key, value in pairs(newTheme) do
        if Stellar.Configuration[key] then
            Stellar.Configuration[key] = value
        end
    end
end

return Stellar
