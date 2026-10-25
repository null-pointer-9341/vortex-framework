--[[

    This is an example module, and it showcases  how to use sevicing and networking from the framework.
    In case of any questions, you can read the documentation.

]]

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Get the framework
local framework = require(replicatedStorage.framework.VortexFramework)

local CashService = framework.createService({
    Name = "CashService",

    -- Everything in `Client` is reachable from the client, nothing else is.
    Client = {
        Changed = framework.createSignal(),
        Ping = framework.createSignal(),
    },
})

local cash = {}

-- Other modules use this through Vortex.getService("CashService")
function CashService:Get(player)
    return cash[player] or 0
end

function CashService:Add(player, amount)
    cash[player] = self:Get(player) + amount
    self.Client.Changed:Fire(player, cash[player])
end

function CashService:TrySpend(player, amount)
    if self:Get(player) < amount then
        return false
    end
    self:Add(player, -amount)
    return true
end

-- Client API `self` is the Client table, `self.Server` is the service.
-- The client can send anything, so validate every argument.
function CashService.Client:Get(player)
    return self.Server:Get(player)
end

function CashService.Client:Spend(player, amount)
    if type(amount) ~= "number" or amount ~= amount or amount <= 0 then
        return false
    end
    return self.Server:TrySpend(player, amount)
end

-- Required by the framework because it runs in sequence with every other module's init.
function CashService.init()
    CashService.Client.Ping:Connect(function(player, text)
        print(player.Name .. " pinged: " .. tostring(text))
    end)

    players.PlayerRemoving:Connect(function(player)
        cash[player] = nil
    end)
end

-- Runs after every module finished `init`, so other services exist now.
function CashService:onStart()
    for _, player in ipairs(players:GetPlayers()) do
        self:Add(player, 100)
    end
    players.PlayerAdded:Connect(function(player)
        self:Add(player, 100)
    end)
end

return CashService
