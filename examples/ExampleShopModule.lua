-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Find the framework
local framework = require(replicatedStorage:WaitForChild("framework"):WaitForChild("VortexFramework"))

-- Create a new service
local ShopService = framework.createService({
    Name = "ShopService",
})

function ShopService:onStart()
    -- Safe here: every module has finished init, so CashService exists.
    self.Cash = framework.getService("CashService")
end

function ShopService:Buy(player, price)
    return self.Cash:TrySpend(player, price)
end

function ShopService.init() end

return ShopService
