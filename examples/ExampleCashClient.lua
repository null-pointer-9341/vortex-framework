-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Find the framework
local framework = require(replicatedStorage:WaitForChild("framework"):WaitForChild("VortexFramework"))

-- Get the service
local CashService = framework.getServerService("CashService")

-- Connect right away, events sent before this returns are not received.
CashService.Changed:Connect(function(newAmount)
    print("Cash is now " .. newAmount)
end)

print("Balance:", CashService:Get())
print("Spent 30:", CashService:Spend(30))

CashService.Ping:Fire("hello from the client")
