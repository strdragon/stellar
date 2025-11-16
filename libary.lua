-- Stellar GUI Library (Rectangular with Tabs on Top)
local Stellar = {}

-- Конфигурация
Stellar.Configuration = {
    WindowBackground = Color3.fromRGB(25, 25, 25),
    TabBackground = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 85, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    BorderColor = Color3.fromRGB(50, 50, 50)
}

-- Создание главного окна
function Stellar:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StellarGUI"
    ScreenGui.Parent = game.CoreGui
    
    -- Главный контейнер
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Stellar.Configuration.WindowBackground
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Stellar.Configuration.BorderColor
    MainFrame.Parent = ScreenGui
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Stellar.Configuration.Accent
    Title.Text = config.Name or "Stellar GUI"
    Title.TextColor3 = Stellar.Configuration.TextColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = MainFrame
    
    -- Контейнер для табов
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -20, 0, 30)
    TabsContainer.Position = UDim2.new(0, 10, 0, 35)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabsContainer
    
    -- Контейнер для контента
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -75)
    ContentContainer.Position = UDim2.new(0, 10, 0, 70)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Функция создания таба
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Visible = false
        
        -- Кнопка таба
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(0, 80, 0, 25)
        TabButton.BackgroundColor3 = Stellar.Configuration.TabBackground
        TabButton.Text = name
        TabButton.TextColor3 = Stellar.Configuration.TextColor
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = TabsContainer
        
        -- Контент таба
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent
        
        -- Обработчик клика
        TabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(Window.Tabs) do
                existingTab:SetVisible(false)
            end
            Tab:SetVisible(true)
        end)
        
        -- Функция видимости
        function Tab:SetVisible(state)
            TabContent.Visible = state
            if state then
                TabButton.BackgroundColor3 = Stellar.Configuration.Accent
                Window.CurrentTab = Tab
            else
                TabButton.BackgroundColor3 = Stellar.Configuration.TabBackground
            end
        end
        
        -- Функция создания секции
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.BackgroundColor3 = Stellar.Configuration.TabBackground
            SectionFrame.BorderSizePixel = 1
            SectionFrame.BorderColor3 = Stellar.Configuration.BorderColor
            SectionFrame.Parent = TabContent
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -10, 1, 0)
            SectionTitle.Position = UDim2.new(0, 5, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Stellar.Configuration.TextColor
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = "Elements"
            ElementsContainer.Size = UDim2.new(1, -10, 0, 0)
            ElementsContainer.Position = UDim2.new(0, 5, 0, 35)
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Parent = SectionFrame
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.Padding = UDim.new(0, 5)
            ElementsLayout.Parent = ElementsContainer
            
            -- Функция создания кнопки
            function Section:CreateButton(config)
                local Button = Instance.new("TextButton")
                Button.Name = config.Name
                Button.Size = UDim2.new(1, 0, 0, 25)
                Button.BackgroundColor3 = Stellar.Configuration.Accent
                Button.Text = config.Name
                Button.TextColor3 = Stellar.Configuration.TextColor
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 12
                Button.Parent = ElementsContainer
                
                Button.MouseButton1Click:Connect(function()
                    if config.Callback then
                        config.Callback()
                    end
                end)
                
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 30)
            end
            
            -- Функция создания тоггла
            function Section:CreateToggle(config)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = config.Name
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = ElementsContainer
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Toggle"
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -45, 0, 2)
                ToggleButton.BackgroundColor3 = Stellar.Configuration.BorderColor
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Name
                ToggleLabel.TextColor3 = Stellar.Configuration.TextColor
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local state = config.CurrentValue or false
                
                local function updateToggle()
                    if state then
                        ToggleButton.BackgroundColor3 = Stellar.Configuration.Accent
                    else
                        ToggleButton.BackgroundColor3 = Stellar.Configuration.BorderColor
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                    if config.Callback then
                        config.Callback(state)
                    end
                end)
                
                updateToggle()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 30)
            end
            
            -- Функция создания слайдера
            function Section:CreateSlider(config)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = config.Name
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = ElementsContainer
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, 0, 0, 15)
                SliderLabel.Position = UDim2.new(0, 0, 0, 0)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Name .. ": " .. config.CurrentValue
                SliderLabel.TextColor3 = Stellar.Configuration.TextColor
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.Size = UDim2.new(1, 0, 0, 5)
                SliderTrack.Position = UDim2.new(0, 0, 0, 20)
                SliderTrack.BackgroundColor3 = Stellar.Configuration.BorderColor
                SliderTrack.Parent = SliderFrame
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Stellar.Configuration.Accent
                SliderFill.Parent = SliderTrack
                
                local currentValue = config.CurrentValue or config.Range[1]
                local range = config.Range[2] - config.Range[1]
                
                local function updateSlider(value)
                    currentValue = math.clamp(value, config.Range[1], config.Range[2])
                    local percentage = (currentValue - config.Range[1]) / range
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    SliderLabel.Text = config.Name .. ": " .. currentValue .. (config.Suffix or "")
                    
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
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 45)
            end
            
            -- Функция создания дропдауна
            function Section:CreateDropdown(config)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = config.Name
                DropdownFrame.Size = UDim2.new(1, 0, 0, 25)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = ElementsContainer
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(1, 0, 0, 25)
                DropdownButton.BackgroundColor3 = Stellar.Configuration.BorderColor
                DropdownButton.Text = config.Name .. ": " .. config.CurrentOption
                DropdownButton.TextColor3 = Stellar.Configuration.TextColor
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextSize = 12
                DropdownButton.Parent = DropdownFrame
                
                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "Options"
                DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                DropdownOptions.Position = UDim2.new(0, 0, 0, 30)
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.Visible = false
                DropdownOptions.Parent = DropdownFrame
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Parent = DropdownOptions
                
                local isOpen = false
                local currentOption = config.CurrentOption
                
                local function updateDropdown()
                    DropdownButton.Text = config.Name .. ": " .. currentOption
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
                            OptionButton.Size = UDim2.new(1, 0, 0, 20)
                            OptionButton.BackgroundColor3 = Stellar.Configuration.TabBackground
                            OptionButton.Text = option
                            OptionButton.TextColor3 = Stellar.Configuration.TextColor
                            OptionButton.Font = Enum.Font.Gotham
                            OptionButton.TextSize = 11
                            OptionButton.Parent = DropdownOptions
                            
                            OptionButton.MouseButton1Click:Connect(function()
                                currentOption = option
                                updateDropdown()
                                toggleDropdown()
                            end)
                        end
                        DropdownOptions.Size = UDim2.new(1, 0, 0, #config.Options * 25)
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 25 + (#config.Options * 25))
                    else
                        DropdownOptions:ClearAllChildren()
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 25)
                    end
                    
                    SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + (isOpen and (#config.Options * 25) or 0))
                end
                
                DropdownButton.MouseButton1Click:Connect(toggleDropdown)
                updateDropdown()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Size.Y.Offset + 30)
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
    
    return Window
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
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -10, 0, 20)
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Notification"
    Title.TextColor3 = Stellar.Configuration.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = NotificationFrame
    
    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -30)
    Content.Position = UDim2.new(0, 5, 0, 25)
    Content.BackgroundTransparency = 1
    Content.Text = config.Content or ""
    Content.TextColor3 = Stellar.Configuration.TextColor
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 12
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.Parent = NotificationFrame
    
    wait(config.Duration or 5)
    Notification:Destroy()
end

return Stellar
