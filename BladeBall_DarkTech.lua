-- Blade Ball - Dark Tech by Yadier
-- LeftControl to toggle UI

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configuraciones
local autoParry = false
local autoCurve = false
local autoSkill = false
local lobbyTraining = false
local autoSpam = false
local cameraLock = false
local autoAFK = false
local autoPlay = false
local autoJump = false
local ballDetection = false

-- Cooldown
local lastParryTime = 0
local parryCooldown = 0.5

-- Habilidades que bloquean la bola
local blockSkills = {
    Freeze = false,
    RagingDeflect = false,
    Invisibility = false,
    BlackHole = false,
    AerodynamicSlash = false,
    Telekinesis = false,
    FlashCounter = false,
    HellHook = false,
    Swap = false,
    Rapture = false,
    Infinity = false,
    Tact = false,
    DeathSlash = false,
    Dribble = false,
    Singularity = false,
    TimeHole = false
}

-- UI Toggle
local guiEnabled = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
        guiEnabled = not guiEnabled
        if game.CoreGui:FindFirstChild("DarkTechUI") then
            game.CoreGui.DarkTechUI.Enabled = guiEnabled
        end
    end
end)

-- Función para auto parry
local function autoParryFunction()
    local ball = workspace:FindFirstChild("Ball")
    if ball and (autoParry or autoSkill) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
        if dist < 20 then
            local velocity = ball.Velocity.Magnitude
            if velocity > 80 and tick() - lastParryTime > parryCooldown then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                lastParryTime = tick()
            end
        end
    end
end

-- Función de detección de bola
local function ballDetectionFunction()
    if ballDetection and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local ball = workspace:FindFirstChild("Ball")
        if ball then
            local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
            -- Acción al detectar la bola (puedes personalizar esto)
        end
    end
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    if autoAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
    end
    if autoPlay then
        -- Lógica para auto play
    end
    if autoJump then
        -- Lógica para salto automático
    end
    autoParryFunction()
    ballDetectionFunction()
end)

-- Guardar configuración
local function saveConfig()
    local config = {
        autoParry = autoParry,
        autoCurve = autoCurve,
        autoSkill = autoSkill,
        lobbyTraining = lobbyTraining,
        autoSpam = autoSpam,
        cameraLock = cameraLock,
        autoAFK = autoAFK,
        autoPlay = autoPlay,
        autoJump = autoJump,
        ballDetection = ballDetection,
        blockSkills = blockSkills
    }
    writefile("DarkTech_Config.txt", HttpService:JSONEncode(config))
end

-- Cargar configuración
local function loadConfig()
    if isfile("DarkTech_Config.txt") then
        local config = HttpService:JSONDecode(readfile("DarkTech_Config.txt"))
        autoParry = config.autoParry
        autoCurve = config.autoCurve
        autoSkill = config.autoSkill
        lobbyTraining = config.lobbyTraining
        autoSpam = config.autoSpam
        cameraLock = config.cameraLock
        autoAFK = config.autoAFK
        autoPlay = config.autoPlay
        autoJump = config.autoJump
        ballDetection = config.ballDetection
        blockSkills = config.blockSkills
    end
end

-- Crear UI básica
local function createUI()
    if game.CoreGui:FindFirstChild("DarkTechUI") then
        game.CoreGui.DarkTechUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DarkTechUI"
    ScreenGui.Parent = game.CoreGui

    local function createToggleButton(name, initialState, position, callback)
        local button = Instance.new("TextButton")
        button.Text = name .. ": " .. (initialState and "ON" or "OFF")
        button.Size = UDim2.new(0, 200, 0, 30)
        button.Position = position
        button.Parent = ScreenGui

        button.MouseButton1Click:Connect(function()
            initialState = not initialState
            button.Text = name .. ": " .. (initialState and "ON" or "OFF")
            callback(initialState)
        end)
    end

    local yStart = 0.1
    local yIncrement = 0.05
    local i = 0

    createToggleButton("Auto Parry", autoParry, UDim2.new(0.5, -100, yStart + yIncrement * i, 0), function(state) autoParry = state end)
    i = i + 1
    createToggleButton("Auto Skill", autoSkill, UDim2.new(0.5, -100, yStart + yIncrement * i, 0), function(state) autoSkill = state end)
    i = i + 1
    createToggleButton("Auto AFK", autoAFK, UDim2.new(0.5, -100, yStart + yIncrement * i, 0), function(state) autoAFK = state end)
    i = i + 1
    createToggleButton("Auto Jump", autoJump, UDim2.new(0.5, -100, yStart + yIncrement * i, 0), function(state) autoJump = state end)
    i = i + 1
    createToggleButton("Ball Detection", ballDetection, UDim2.new(0.5, -100, yStart + yIncrement * i, 0), function(state) ballDetection = state end)
    i = i + 1

    local saveButton = Instance.new("TextButton")
    saveButton.Text = "Guardar Configuración"
    saveButton.Size = UDim2.new(0, 200, 0, 30)
    saveButton.Position = UDim2.new(0.5, -100, yStart + yIncrement * (i + 1), 0)
    saveButton.Parent = ScreenGui
    saveButton.MouseButton1Click:Connect(saveConfig)
end

-- Inicialización
loadConfig()
createUI()
