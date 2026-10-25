# Vortex Framework

This Vortex framework was created for reliable module requiring and has built in services and client/server netoworking.

- **Module loading**: `init` runs on every module in a folder, in order.
- **Module in Module (MIM)** and **relative paths (MIRP)**: `Vortex.require("Combat/Hitbox")` and `Vortex.require("../Health", script)`.
- **Services**: modules share code by name, without requiring each other.
- **Networking**: a server service has a `Client` table, and the client can call its functions and use its signals. You never write RemoteEvent code yourself.

Created and developed by [@rusted010101](https://github.com/null-pointer-9341) or [Vortex](https://playvortex.io/users/26469/profile). Current version: **1.2.0**. See [CHANGELOG.md](CHANGELOG.md).

## Setup

stub (this part isn't required, you can simply download the .vrtx file)

The full guide, including every error code, is in the [Documentation](src/Documentation.lua).

## Quick example

```lua
-- server: modules/CashService (ModuleScript)
local Vortex = require(game.ReplicatedStorage.framework.VortexFramework)

local CashService = Vortex.createService({
    Name = "CashService",
    Client = {
        Changed = Vortex.createSignal(),
    },
})

local cash = {}

function CashService:Get(player)
    return cash[player] or 0
end

function CashService.Client:Get(player)
    return self.Server:Get(player)
end

function CashService.init() end

return CashService
```

```lua
-- client: any LocalScript
local Vortex = require(game.ReplicatedStorage.framework.VortexFramework)
local CashService = Vortex.getServerService("CashService")

print(CashService:Get())
CashService.Changed:Connect(function(newAmount)
    print("Cash is now " .. newAmount)
end)
```

More complete examples (a cash service, a shop service, and the server and client starter scripts) are in [examples/](examples/).
Currently, most are included inside the .vrtx package.

## Debugging

Set `DEBUG_MODE` to `true` in the Constants section of `VortexFramework` to log module loading, requests, responses and timing.

## License

The framework is open source and can be used without listing credits. The one exception: do not distribute it under your own name.
