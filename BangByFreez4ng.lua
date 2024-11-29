-- Services et joueur local
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Configuration par défaut
local defaultKey = Enum.KeyCode.F -- Touche par défaut
local currentKey = defaultKey -- Touche active
local isFollowing = false
local followTask

local function showInstructions()
    -- Création du ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Cadre principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.6, 0, 0.4, 0)
    frame.Position = UDim2.new(0.2, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.ClipsDescendants = true
    frame.Visible = false

    -- Coins arrondis pour le cadre
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.05, 0)
    frameCorner.Parent = frame

    -- Texte principal
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0.8, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.Text = "Bienvenue sur le script 'Bang by Freez4ng' !\n\n"
        .. "Voici comment il fonctionne :\n\n"
        .. "- Appuyez sur [" .. tostring(currentKey):sub(14) .. "] pour bang la personne la plus proche.\n"
        .. "- Tapez dans le chat ':key <lettre>' pour changer la touche.\n\n"
        .. "Profitez-en !"
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 22
    textLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    textLabel.TextWrapped = true
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = frame
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top

    -- Bouton pour fermer la fenêtre
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.3, 0, 0.15, 0)
    closeButton.Position = UDim2.new(0.35, 0, 0.8, 0)
    closeButton.Text = "Fermer"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = frame

    -- Coins arrondis pour le bouton
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.2, 0)
    buttonCorner.Parent = closeButton

    -- Effet hover sur le bouton
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        }):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    -- Animation de fermeture
    closeButton.MouseButton1Click:Connect(function()
        local fadeOutTween = TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local textFadeOutTween = TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 1})
        local buttonFadeOutTween = TweenService:Create(closeButton, TweenInfo.new(0.5), {TextTransparency = 1})

        -- Lancer les animations
        fadeOutTween:Play()
        textFadeOutTween:Play()
        buttonFadeOutTween:Play()

        -- Détruire après l'animation
        fadeOutTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)

    -- Animation d'apparition
    frame.Visible = true
    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
end


-- Fonction pour créer un écran de chargement moderne
local function showModernLoadingUI()
    -- Création du ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Création du cadre principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 1 -- Commence totalement transparent
    frame.Parent = screenGui

    -- Texte principal
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "Loading...\nBang by Freez4ng"
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextSize = 60
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextTransparency = 1 -- Commence invisible
    textLabel.TextStrokeTransparency = 0.7
    textLabel.TextWrapped = true
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = frame

    -- Animation d'apparition
    local fadeInInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeInFrame = TweenService:Create(frame, fadeInInfo, {BackgroundTransparency = 0.3})
    local fadeInText = TweenService:Create(textLabel, fadeInInfo, {TextTransparency = 0})

    -- Animation de disparition
    local fadeOutInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local fadeOutFrame = TweenService:Create(frame, fadeOutInfo, {BackgroundTransparency = 1})
    local fadeOutText = TweenService:Create(textLabel, fadeOutInfo, {TextTransparency = 1})

    -- Lancement des animations
    fadeInFrame:Play()
    fadeInText:Play()

    task.wait(2.5) -- Temps d'attente avant disparition

    fadeOutText:Play()
    fadeOutFrame:Play()

    fadeOutFrame.Completed:Connect(function()
        screenGui:Destroy()
        showInstructions()
    end)
end

-- Fonction pour changer la touche via commande
local function changeKey(newKey)
    local keyCode = Enum.KeyCode[newKey:upper()]
    if keyCode then
        currentKey = keyCode -- Mise à jour de la touche active
        print("Nouvelle touche assignée : " .. newKey:upper())
    else
        print("Touche invalide : " .. newKey)
    end
end

-- Détection de commande dans le chat
local function onPlayerChatted(message)
    if string.sub(message, 1, 5) == ":key " then
        local newKey = string.sub(message, 6):upper() -- Extraire et formater la touche
        changeKey(newKey)
    end
end

-- Supprime toutes les animations en cours
local function clearAnimations(humanoid)
    for _, animTrack in ipairs(humanoid:GetPlayingAnimationTracks()) do
        animTrack:Stop()
    end
end

-- Trouver le joueur le plus proche
local function getClosestPlayer()
    local character = player.Character or player.CharacterAdded:Wait()
    local closestDistance = math.huge
    local closestPlayer = nil

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    return closestPlayer
end

-- Commencer le suivi
local function startFollowing()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then return end

    -- Désactiver les mouvements classiques et supprimer les animations
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    clearAnimations(humanoid)

    -- Lancer le suivi
    followTask = RunService.Heartbeat:Connect(function()
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart
            local targetPosition = targetRoot.Position

            -- Distance proche
            local followDistance = 1
            local basePosition = targetPosition - targetRoot.CFrame.LookVector * followDistance

            -- Oscillation avant-arrière
            local oscillation = math.sin(tick() * 50) * 0.5
            local followPosition = basePosition + targetRoot.CFrame.LookVector * math.max(oscillation, 0)

            -- Déplacement du joueur
            rootPart.CFrame = CFrame.new(followPosition, targetPosition)
        end
    end)
end

-- Arrêter le suivi
local function stopFollowing()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end

    if followTask then
        followTask:Disconnect()
        followTask = nil
    end
end

-- Détection de l'appui sur la touche pour "bang"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignorer si l'input est déjà traité par le jeu

    if input.KeyCode == currentKey then
        isFollowing = not isFollowing

        if isFollowing then
            startFollowing()
        else
            stopFollowing()
        end
    end
end)

player.Chatted:Connect(onPlayerChatted)

-- Afficher l'UI de chargement au lancement
showModernLoadingUI()