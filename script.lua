-- Stellar GUI Library for Roblox
-- Улучшенная версия с исправлениями и новыми функциями

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Stellar = {}
Stellar.__index = Stellar

-- Темы цветов
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 150, 200),
        Text = Color3.fromRGB(240, 240, 240),
        Success = Color3.fromRGB(0, 180, 100),
        Warning = Color3.fromRGB(200, 140, 0),
        Danger = Color3.fromRGB(200, 50, 50),
        Info = Color3.fromRGB(80, 180, 220)
    },
    Light = {
        Primary = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(230, 230, 240),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(30, 30, 40),
        Success = Color3.fromRGB(0, 160, 80),
        Warning = Color3.fromRGB(180, 120, 0),
        Danger = Color3.fromRGB(180, 40, 40),
        Info = Color3.fromRGB(60, 160, 200)
    },
    Purple = {
        Primary = Color3.fromRGB(25, 20, 35),
        Secondary = Color3.fromRGB(40, 30, 55),
        Accent = Color3.fromRGB(140, 80, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Success = Color3.fromRGB(100, 220, 140),
        Warning = Color3.fromRGB(255, 180, 60),
        Danger = Color3.fromRGB(255, 80, 100),
        Info = Color3.fromRGB(160, 120, 255)
    },
    Red = {
        Primary = Color3.fromRGB(30, 15, 15),
        Secondary = Color3.fromRGB(50, 25, 25),
        Accent = Color3.fromRGB(220, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        Success = Color3.fromRGB(80, 200, 100),
        Warning = Color3.fromRGB(255, 160, 40),
        Danger = Color3.fromRGB(220, 60, 60),
        Info = Color3.fromRGB(200, 100, 100)
    }
}

-- Глобальные переменные
local Configurations = {}
local CurrentTheme = "Dark"
local Colors = Themes.Dark

-- Вспомогательные функции
local function SaveConfiguration(configName, data)
    if not writefile then
        return false
    end
    
    local success, result = pcall(function()
        if not isfolder("Stellar") then
            makefolder("Stellar")
        end
        
        local configFolder = "Stellar/Configs"
        if not isfolder(configFolder) then
            makefolder(configFolder)
        end
        
        writefile(configFolder .. "/" .. configName .. ".json", HttpService:JSONEncode(data))
    end)
    
    return success
end

local function LoadConfiguration(configName)
    if not readfile then
        return nil
    end
    
    local success, result = pcall(function()
        local configFolder = "Stellar/Configs"
        local filePath = configFolder .. "/" .. configName .. ".json"
        
        if isfile(filePath) then
            return HttpService:JSONDecode(readfile(filePath))
        end
    end)
    
    return success and result or nil
end

local function SaveKey(key)
    if not writefile then
        return false
    end
    
    local success, result = pcall(function()
        if not isfolder("Stellar") then
            makefolder("Stellar")
        end
        
        writefile("Stellar/Key.txt", key)
    end)
    
    return success
end

local function LoadKey()
    if not readfile then
        return nil
    end
    
    local success, result = pcall(function()
        if isfile("Stellar/Key.txt") then
            return readfile("Stellar/Key.txt")
        end
    end)
    
    return success and result or nil
end

-- Создание основного окна
function Stellar:CreateWindow(options)
    options = options or {}
    local window = {
        Name = options.Name or "Stellar Interface",
        LoadingTitle = options.LoadingTitle or "Stellar GUI Suite",
        LoadingSubtitle = options.LoadingSubtitle or "by Developer",
        Theme = options.Theme or "Dark",
        ConfigurationSaving = options.ConfigurationSaving or {
            Enabled = false,
            FolderName = "Stellar",
            FileName = "Config"
        },
        KeySystem = options.KeySystem or false,
        KeySettings = options.KeySettings or {
            Title = "Key System",
            Subtitle = "Enter your key",
            Note = "Contact admin to get key",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"default123"}
        }
    }
    
    setmetatable(window, self)
    
    -- Установка темы
    CurrentTheme = window.Theme
    Colors = Themes[CurrentTheme] or Themes.Dark
    
    -- Проверка ключа если включена система
    if window.KeySystem then
        local keyVerified = self:VerifyKeySystem(window.KeySettings)
        if not keyVerified then
            return nil
        end
    end
    
    -- Загрузка конфигурации
    if window.ConfigurationSaving.Enabled then
        local loadedConfig = LoadConfiguration(window.ConfigurationSaving.FileName)
        if loadedConfig then
            Configurations = loadedConfig
            print("Конфигурация загружена:", Configurations)
        end
    end
    
    -- Создание GUI с защитой от удаления
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StellarGUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Основной фрейм (прямоугольный)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
    mainFrame.BackgroundColor3 = Colors.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    shadow.ZIndex = -1
    
    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = window.Name
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Кнопка сворачивания
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 35, 0, 35)
    minimizeButton.Position = UDim2.new(1, -70, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Text = "─"
    minimizeButton.TextColor3 = Colors.Text
    minimizeButton.TextSize = 16
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Colors.Text
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    -- Контейнер для элементов
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -55)
    container.Position = UDim2.new(0, 10, 0, 45)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Colors.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = container
    
    -- Функционал перемещения
    local dragging = false
    local dragStart, frameStart
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale, frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
        )
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateInput(input)
        end
    end)
    
    -- Функция подтверждения закрытия
    local function showCloseConfirmation()
        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        overlay.BackgroundTransparency = 0.3
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 10
        overlay.Parent = mainFrame
        
        local confirmationFrame = Instance.new("Frame")
        confirmationFrame.Size = UDim2.new(0, 300, 0, 150)
        confirmationFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        confirmationFrame.BackgroundColor3 = Colors.Primary
        confirmationFrame.BorderSizePixel = 0
        confirmationFrame.ZIndex = 11
        confirmationFrame.Parent = overlay
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.BackgroundTransparency = 1
        title.Text = "Подтверждение"
        title.TextColor3 = Colors.Text
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.Parent = confirmationFrame
        
        local message = Instance.new("TextLabel")
        message.Size = UDim2.new(1, -20, 0, 40)
        message.Position = UDim2.new(0, 10, 0, 50)
        message.BackgroundTransparency = 1
        message.Text = "Вы уверены, что хотите закрыть?"
        message.TextColor3 = Colors.Text
        message.TextSize = 14
        message.Font = Enum.Font.Gotham
        message.TextWrapped = true
        message.Parent = confirmationFrame
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, -20, 0, 40)
        buttonContainer.Position = UDim2.new(0, 10, 1, -50)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = confirmationFrame
        
        local noButton = Instance.new("TextButton")
        noButton.Size = UDim2.new(0.4, 0, 1, 0)
        noButton.BackgroundColor3 = Colors.Secondary
        noButton.BorderSizePixel = 0
        noButton.Text = "НЕТ"
        noButton.TextColor3 = Colors.Text
        noButton.TextSize = 14
        noButton.Font = Enum.Font.Gotham
        noButton.Parent = buttonContainer
        
        local yesButton = Instance.new("TextButton")
        yesButton.Size = UDim2.new(0.4, 0, 1, 0)
        yesButton.Position = UDim2.new(0.6, 0, 0, 0)
        yesButton.BackgroundColor3 = Colors.Danger
        yesButton.BorderSizePixel = 0
        yesButton.Text = "ДА"
        yesButton.TextColor3 = Colors.Text
        yesButton.TextSize = 14
        yesButton.Font = Enum.Font.Gotham
        yesButton.Parent = buttonContainer
        
        noButton.MouseButton1Click:Connect(function()
            overlay:Destroy()
        end)
        
        yesButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    end
    
    -- Обработчики кнопок
    minimizeButton.MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
        if container.Visible then
            mainFrame.Size = UDim2.new(0, 500, 0, 500)
            minimizeButton.Text = "─"
        else
            mainFrame.Size = UDim2.new(0, 500, 0, 35)
            minimizeButton.Text = "+"
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        showCloseConfirmation()
    end)
    
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.Container = container
    window.Config = Configurations
    
    return window
end

-- Система проверки ключа (ИСПРАВЛЕННАЯ)
function Stellar:VerifyKeySystem(keySettings)
    -- Если ключ уже сохранен и включено сохранение
    if keySettings.SaveKey then
        local savedKey = LoadKey()
        if savedKey then
            for _, validKey in ipairs(keySettings.Key) do
                if savedKey == validKey then
                    print("Ключ найден в сохранениях:", savedKey)
                    -- Сохраняем ключ в конфигурации
                    if self.ConfigurationSaving.Enabled then
                        Configurations["SavedKey"] = savedKey
                        SaveConfiguration(self.ConfigurationSaving.FileName, Configurations)
                    end
                    return true
                end
            end
        end
    end
    
    -- Создание интерфейса для ввода ключа
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystemGUI"
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyGui.Parent = player.PlayerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Colors.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = keyGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = keySettings.Title
    title.TextColor3 = Colors.Accent
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 70)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = keySettings.Subtitle
    subtitle.TextColor3 = Colors.Text
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, -40, 0, 40)
    note.Position = UDim2.new(0, 20, 1, -100)
    note.BackgroundTransparency = 1
    note.Text = keySettings.Note
    note.TextColor3 = Colors.Warning
    note.TextSize = 12
    note.Font = Enum.Font.Gotham
    note.TextWrapped = true
    note.Parent = mainFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 40)
    inputBox.Position = UDim2.new(0, 20, 0, 120)
    inputBox.BackgroundColor3 = Colors.Secondary
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = "Enter key here..."
    inputBox.TextColor3 = Colors.Text
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.Parent = mainFrame
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -40, 0, 40)
    submitButton.Position = UDim2.new(0, 20, 0, 180)
    submitButton.BackgroundColor3 = Colors.Accent
    submitButton.BorderSizePixel = 0
    submitButton.Text = "ПРОВЕРИТЬ КЛЮЧ"
    submitButton.TextColor3 = Colors.Text
    submitButton.TextSize = 16
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = mainFrame
    
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -40, 0, 20)
    errorLabel.Position = UDim2.new(0, 20, 0, 230)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Colors.Danger
    errorLabel.TextSize = 12
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.Parent = mainFrame
    
    local validKey = false
    
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = inputBox.Text
        
        -- Проверка ключа
        for _, validKeyValue in ipairs(keySettings.Key) do
            if keySettings.GrabKeyFromSite then
                -- Загрузка ключа с сайта
                local success, siteKey = pcall(function()
                    return game:HttpGet(validKeyValue)
                end)
                
                if success and enteredKey == siteKey then
                    validKey = true
                    break
                end
            else
                if enteredKey == validKeyValue then
                    validKey = true
                    break
                end
            end
        end
        
        if validKey then
            if keySettings.SaveKey then
                SaveKey(enteredKey)
                -- Сохраняем ключ в конфигурации
                if self.ConfigurationSaving.Enabled then
                    Configurations["SavedKey"] = enteredKey
                    SaveConfiguration(self.ConfigurationSaving.FileName, Configurations)
                end
            end
            keyGui:Destroy()
        else
            errorLabel.Text = "Неверный ключ! Попробуйте снова."
        end
    end)
    
    -- Ожидание валидации
    while keyGui.Parent do
        if validKey then
            break
        end
        wait()
    end
    
    return validKey
end

-- Создание секции
function Stellar:CreateSection(options)
    local section = {
        Name = options.Name or "Section",
        Parent = options.Parent or self.Container
    }
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "SectionFrame"
    sectionFrame.Size = UDim2.new(1, 0, 0, 35)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = section.Parent
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "│ " .. string.upper(section.Name)
    sectionLabel.TextColor3 = Colors.Accent
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(1, 0, 0, 1)
    underline.Position = UDim2.new(0, 0, 1, -1)
    underline.BackgroundColor3 = Colors.Secondary
    underline.BorderSizePixel = 0
    underline.Parent = sectionLabel
    
    return sectionFrame
end

-- Создание кнопки
function Stellar:CreateButton(options)
    local button = {
        Name = options.Name or "Button",
        Callback = options.Callback or function() end,
        Parent = options.Parent or self.Container
    }
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, 0, 0, 35)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = button.Parent
    
    local buttonElement = Instance.new("TextButton")
    buttonElement.Name = "Button"
    buttonElement.Size = UDim2.new(1, 0, 1, 0)
    buttonElement.BackgroundColor3 = Colors.Secondary
    buttonElement.BorderSizePixel = 0
    buttonElement.Text = button.Name
    buttonElement.TextColor3 = Colors.Text
    buttonElement.TextSize = 13
    buttonElement.Font = Enum.Font.Gotham
    buttonElement.TextWrapped = true
    buttonElement.Parent = buttonFrame
    
    -- Анимации
    buttonElement.MouseEnter:Connect(function()
        TweenService:Create(buttonElement, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
    end)
    
    buttonElement.MouseLeave:Connect(function()
        TweenService:Create(buttonElement, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
    end)
    
    buttonElement.MouseButton1Click:Connect(function()
        TweenService:Create(buttonElement, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Primary}):Play()
        wait(0.1)
        TweenService:Create(buttonElement, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play()
        button.Callback()
    end)
    
    return buttonFrame
end

-- Создание переключателя
function Stellar:CreateToggle(options)
    local toggle = {
        Name = options.Name or "Toggle",
        Default = options.Default or false,
        Callback = options.Callback or function() end,
        Parent = options.Parent or self.Container,
        Config = options.Config or nil
    }
    
    -- Загрузка сохраненного состояния
    if toggle.Config and Configurations[toggle.Config] ~= nil then
        toggle.Default = Configurations[toggle.Config]
        print("Загружено состояние для", toggle.Config, ":", toggle.Default)
    end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = toggle.Parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = toggle.Name
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggleButton.BackgroundColor3 = toggle.Default and Colors.Success or Colors.Secondary
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = toggle.Default and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = Colors.Text
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local isToggled = toggle.Default
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if isToggled then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Success}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10.5)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)}):Play()
        end
        
        -- Сохранение состояния
        if toggle.Config then
            Configurations[toggle.Config] = isToggled
            if self.ConfigurationSaving.Enabled then
                SaveConfiguration(self.ConfigurationSaving.FileName, Configurations)
                print("Сохранено состояние для", toggle.Config, ":", isToggled)
            end
        end
        
        toggle.Callback(isToggled)
    end)
    
    return toggleFrame
end

-- Создание слайдера
function Stellar:CreateSlider(options)
    local slider = {
        Name = options.Name or "Slider",
        Range = options.Range or {0, 100},
        Default = options.Default or 50,
        Callback = options.Callback or function() end,
        Parent = options.Parent or self.Container,
        Config = options.Config or nil,
        Suffix = options.Suffix or ""
    }
    
    -- Загрузка сохраненного значения
    if slider.Config and Configurations[slider.Config] ~= nil then
        slider.Default = Configurations[slider.Config]
        print("Загружено значение для", slider.Config, ":", slider.Default)
    end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 55)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = slider.Parent
    
    local topContainer = Instance.new("Frame")
    topContainer.Size = UDim2.new(1, 0, 0, 20)
    topContainer.BackgroundTransparency = 1
    topContainer.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = slider.Name
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = topContainer
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(slider.Default) .. slider.Suffix
    valueLabel.TextColor3 = Colors.Accent
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = topContainer
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0, 0, 1, -25)
    sliderTrack.BackgroundColor3 = Colors.Secondary
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new(0, -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local minValue, maxValue = slider.Range[1], slider.Range[2]
    local currentValue = math.clamp(slider.Default, minValue, maxValue)
    
    local function updateSlider(positionX)
        local absoluteSize = sliderTrack.AbsoluteSize.X
        local relativePosition = math.clamp(positionX, 0, absoluteSize)
        local percentage = relativePosition / absoluteSize
        local value = math.floor(minValue + (maxValue - minValue) * percentage)
        
        currentValue = value
        valueLabel.Text = tostring(value) .. slider.Suffix
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        -- Сохранение значения
        if slider.Config then
            Configurations[slider.Config] = value
            if self.ConfigurationSaving.Enabled then
                SaveConfiguration(self.ConfigurationSaving.FileName, Configurations)
                print("Сохранено значение для", slider.Config, ":", value)
            end
        end
        
        slider.Callback(value)
    end
    
    -- Инициализация
    local initialPercentage = (currentValue - minValue) / (maxValue - minValue)
    updateSlider(initialPercentage * sliderTrack.AbsoluteSize.X)
    
    -- Обработка ввода
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local positionX = input.Position.X - sliderTrack.AbsolutePosition.X
            updateSlider(positionX)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local positionX = input.Position.X - sliderTrack.AbsolutePosition.X
            updateSlider(positionX)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderFrame
end

-- Создание выпадающего списка
function Stellar:CreateDropdown(options)
    local dropdown = {
        Name = options.Name or "Dropdown",
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        Default = options.Default or options.Options[1],
        Callback = options.Callback or function() end,
        Parent = options.Parent or self.Container,
        Config = options.Config or nil
    }
    
    -- Загрузка сохраненного значения
    if dropdown.Config and Configurations[dropdown.Config] ~= nil then
        dropdown.Default = Configurations[dropdown.Config]
        print("Загружено значение для", dropdown.Config, ":", dropdown.Default)
    end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = dropdown.Parent
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 35)
    dropdownButton.BackgroundColor3 = Colors.Secondary
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = dropdown.Name .. ": " .. tostring(dropdown.Default)
    dropdownButton.TextColor3 = Colors.Text
    dropdownButton.TextSize = 13
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextWrapped = true
    dropdownButton.Parent = dropdownFrame
    
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -25, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031090990"
    arrow.ImageColor3 = Colors.Text
    arrow.Rotation = 0
    arrow.Parent = dropdownButton
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 0, 40)
    optionsFrame.BackgroundColor3 = Colors.Primary
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdownFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsFrame
    
    local isOpen = false
    local selectedOption = dropdown.Default

    -- Создание опций
    for _, option in ipairs(dropdown.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Colors.Secondary
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Colors.Text
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = dropdown.Name .. ": " .. option
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            
            -- Сохранение значения
            if dropdown.Config then
                Configurations[dropdown.Config] = option
                if self.ConfigurationSaving.Enabled then
                    SaveConfiguration(self.ConfigurationSaving.FileName, Configurations)
                    print("Сохранено значение для", dropdown.Config, ":", option)
                end
            end
            
            dropdown.Callback(option)
            isOpen = false
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            optionsFrame.Visible = false
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            optionsFrame.Visible = true
            local totalHeight = #dropdown.Options * 32
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            optionsFrame.Visible = false
        end
    end)
    
    return dropdownFrame
end

return Stellar
