-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Find the framework
local framework = require(replicatedStorage:WaitForChild("framework"):WaitForChild("VortexFramework"))

-- The `root` A.K.A. the folder with the actual modules.
local client_modules = script.Parent.Parent:WaitForChild("modules")
local shared_modules = replicatedStorage:WaitForChild("shared"):WaitForChild("modules")

-- Start the framework from the shared and client
framework.init(shared_modules)
framework.init(client_modules)
