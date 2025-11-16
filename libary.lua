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
        print("Key system disabled")
        return true
    end
    
    print("Key system enabled, checking key...")
    
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
            print("Saved key found and valid")
            return true
        else
            print("No valid saved key found")
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
    while not KeyWindow.Authenticated and ScreenGui.Parent do
        RunService.Heartbeat:Wait()
    end
    
    return KeyWindow.Authenticated
end

-- Основной класс Window (остальной код остается таким же как в предыдущей версии)
function Stellar:CreateWindow(config)
    -- ... (остальной код создания окна такой же как в предыдущей версии)
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
    
    -- ... (остальной код создания интерфейса)
    
    return Window
end

-- Загрузка библиотеки
return Stellar
