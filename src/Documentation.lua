--[[

     /$$    /$$                      /$$                               /$$$$$$$$                                                                           /$$      
    | $$   | $$                     | $$                              | $$_____/                                                                          | $$      
    | $$   | $$ /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$  /$$   /$$      | $$     /$$$$$$  /$$$$$$  /$$$$$$/$$$$   /$$$$$$  /$$  /$$  /$$  /$$$$$$   /$$$$$$ | $$   /$$
    |  $$ / $$//$$__  $$ /$$__  $$|_  $$_/   /$$__  $$|  $$ /$$/      | $$$$$ /$$__  $$|____  $$| $$_  $$_  $$ /$$__  $$| $$ | $$ | $$ /$$__  $$ /$$__  $$| $$  /$$/
     \  $$ $$/| $$  \ $$| $$  \__/  | $$    | $$$$$$$$ \  $$$$/       | $$__/| $$  \__/ /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$| $$ | $$ | $$| $$  \ $$| $$  \__/| $$$$$$/ 
      \  $$$/ | $$  | $$| $$        | $$ /$$| $$_____/  >$$  $$       | $$   | $$      /$$__  $$| $$ | $$ | $$| $$_____/| $$ | $$ | $$| $$  | $$| $$      | $$_  $$ 
       \  $/  |  $$$$$$/| $$        |  $$$$/|  $$$$$$$ /$$/\  $$      | $$   | $$     |  $$$$$$$| $$ | $$ | $$|  $$$$$$$|  $$$$$/$$$$/|  $$$$$$/| $$      | $$ \  $$
        \_/    \______/ |__/         \___/   \_______/|__/  \__/      |__/   |__/      \_______/|__/ |__/ |__/ \_______/ \_____/\___/  \______/ |__/      |__/  \__/
    
    Vortex Framework, revision 1.
    This is an advanced framework system, which has been created for the sake of relible-ifying module requires.
    
    In case of wonder, this is fully open source and usable without the requirement of listing credits.
    Of course, I won't be mad if you do add them. :)
    The only exception is distrubtion of this system under your own name.
    
    The usage, and help section is located near the bottom section of the documentation, if you are looking for
    extra detail about it's creation you can check the GitHub repository under the link:
    - currently-unavaliable
    
    Also, another thing about the GitHub repository, is contribution.
    All contribution details are located inside the Contributing tab.
    
    Also, this framework allows for module diagnostics (Showing the time it took to finish initation for all modules inside a folder)
    You simply need to enable the `DEBUG_MODE` flag (constant), it is located in the Constants section of the framework code.
    
    Also I think it might be worth noting that part of the documentation has been written with the help of AI due to me not being able
    to figure out my code meaning. (Yes, I actually forgot a chunk of code and what it does due to my inactivity)
    The code however has NOT been written using AI.
    
    
    ---------------------------------------------------------------------------------------------------------
    
     $$$$$$\  $$$$$$$\  $$$$$$$$\ $$$$$$$\  $$$$$$\ $$$$$$$$\  $$$$$$\  
    $$  __$$\ $$  __$$\ $$  _____|$$  __$$\ \_$$  _|\__$$  __|$$  __$$\ 
    $$ /  \__|$$ |  $$ |$$ |      $$ |  $$ |  $$ |     $$ |   $$ /  \__|
    $$ |      $$$$$$$  |$$$$$\    $$ |  $$ |  $$ |     $$ |   \$$$$$$\  
    $$ |      $$  __$$< $$  __|   $$ |  $$ |  $$ |     $$ |    \____$$\ 
    $$ |  $$\ $$ |  $$ |$$ |      $$ |  $$ |  $$ |     $$ |   $$\   $$ |
    \$$$$$$  |$$ |  $$ |$$$$$$$$\ $$$$$$$  |$$$$$$\    $$ |   \$$$$$$  |
     \______/ \__|  \__|\________|\_______/ \______|   \__|    \______/ 
    
    Created and developed by @rusted010101.
    Version 1.2.0
    
    System, revision 1, contributed by:
    - rusted010101
    
    Blame:
    - Initial Commit.
    - Update with Framework and Example Modules.
    - Updated all stubs.
    - Add Module in Module.
    - Add Servicing and Networking.
    - Networking uses a hand-made VortexNetwork folder, manifest requests are resent.
    
    
    ---------------------------------------------------------------------------------------------------------
    
    $$$$$$$\   $$$$$$\   $$$$$$\  $$\   $$\ $$\      $$\ $$$$$$$$\ $$\   $$\ $$$$$$$$\  $$$$$$\ $$$$$$$$\ $$$$$$\  $$$$$$\  $$\   $$\ 
    $$  __$$\ $$  __$$\ $$  __$$\ $$ |  $$ |$$$\    $$$ |$$  _____|$$$\  $$ |\__$$  __|$$  __$$\\__$$  __|\_$$  _|$$  __$$\ $$$\  $$ |
    $$ |  $$ |$$ /  $$ |$$ /  \__|$$ |  $$ |$$$$\  $$$$ |$$ |      $$$$\ $$ |   $$ |   $$ /  $$ |  $$ |     $$ |  $$ /  $$ |$$$$\ $$ |
    $$ |  $$ |$$ |  $$ |$$ |      $$ |  $$ |$$\$$\$$ $$ |$$$$$\    $$ $$\$$ |   $$ |   $$$$$$$$ |  $$ |     $$ |  $$ |  $$ |$$ $$\$$ |
    $$ |  $$ |$$ |  $$ |$$ |      $$ |  $$ |$$ \$$$  $$ |$$  __|   $$ \$$$$ |   $$ |   $$  __$$ |  $$ |     $$ |  $$ |  $$ |$$ \$$$$ |
    $$ |  $$ |$$ |  $$ |$$ |  $$\ $$ |  $$ |$$ |\$  /$$ |$$ |      $$ |\$$$ |   $$ |   $$ |  $$ |  $$ |     $$ |  $$ |  $$ |$$ |\$$$ |
    $$$$$$$  | $$$$$$  |\$$$$$$  |\$$$$$$  |$$ | \_/ $$ |$$$$$$$$\ $$ | \$$ |   $$ |   $$ |  $$ |  $$ |   $$$$$$\  $$$$$$  |$$ | \$$ |
    \_______/  \______/  \______/  \______/ \__|     \__|\________|\__|  \__|   \__|   \__|  \__|  \__|   \______| \______/ \__|  \__|
    
    Since, this is probably one of the best and most advanced Framework currently on the market, I'll try to make it reasonably
    long, so that you don't spend an entire day reading documentation.
    
    So first of all, the divisions, you have the BIG text which just shows the current tab, we are on DOCUMENTATION right now.
    
    The smaller-ish text, which are the sections, this is basically a sub-tab for just dividing into smaller elements, also this
    will usually have a short summary at the top.
    
    The *** at the end of a text means that an improvement could be made in the subject of speech.
    
      __  __         _      _       ___               _                       _      
     |  \/  |___  __| |_  _| |___  | _ \___ __ _ _  _(_)_ _ ___ _ __  ___ _ _| |_ ___
     | |\/| / _ \/ _` | || | / -_) |   / -_) _` | || | | '_/ -_) '  \/ -_) ' \  _(_-<
     |_|  |_\___/\__,_|\_,_|_\___| |_|_\___\__, |\_,_|_|_| \___|_|_|_\___|_||_\__/__/
                                              |_|
    > This section will specify what each ModuleScript requires to have inside itself in order to function.
    > If you already know how to work with this framework, you can skip this.
    
    Each module requires 1 function headers.
    `init` - This gets ran thru all the modules in sequence.
    
    Each module can also have 2 additional optional headers.
    `start` - This is used for Module in Module and Module in relative path, I'll explain it as short as possible.
    You don't call it yourself. The framework runs it once, the first time the module is loaded thru `ReturnInformation.require`,
    right before the module is handed back to whoever asked for it.
    
    `onEnd` - stub ***
    
    A module is also allowed to be a service (see the Servicing section), in that case it can simply return the service
    table, and put its `init` inside of it.
    
      __  __         _      _       _        __  __         _      _     
     |  \/  |___  __| |_  _| |___  (_)_ _   |  \/  |___  __| |_  _| |___ 
     | |\/| / _ \/ _` | || | / -_) | | ' \  | |\/| / _ \/ _` | || | / -_)
     |_|  |_\___/\__,_|\_,_|_\___| |_|_||_| |_|  |_\___/\__,_|\_,_|_\___|
     
     > If you already know how to work with the framework to require modules inside of modules, you can skip this section.
     
     If you want to require modules which are inside of other modules, you will require to use a custom function.
     
     But first of all, let me tell you why this is all neccesary, so whenever you run a ModuleScript thru a script (the "requirer")
     it runs from the "requirer" relative path.
     Meaning in order to run module in module, you would need to use an absolute path.
     
     You can read this article to find out more about relative vs absolute paths, if you are unsure of the differences:
     - https://www.newline.co/30-days-of-webdev/day-25-relative-file-path-vs-absolute-file-paths
     
     This will also be named MIM most of the time.
     
     The custom function is `ReturnInformation.require(path)`.
     `path` is the absolute path of the module, written as names split by `/`.
     It starts from the modules folder you gave to `ReturnInformation.init`, so `ReturnInformation.init` must run first.
     
     Example, with this layout:
     modules (Folder)
       Combat (ModuleScript)
         Hitbox (ModuleScript)
     
     local Vortex = require(path.to.Vortex)
     local Hitbox = Vortex.require("Combat/Hitbox")
     
     The module you require still needs to return a table which is not empty.
     If you gave `ReturnInformation.init` more than one folder, they are searched in the order they were given.
     
      __  __         _      _       _                _      _   _                      _   _    
     |  \/  |___  __| |_  _| |___  (_)_ _    _ _ ___| |__ _| |_(_)_ _____   _ __  __ _| |_| |_  
     | |\/| / _ \/ _` | || | / -_) | | ' \  | '_/ -_) / _` |  _| \ V / -_) | '_ \/ _` |  _| ' \ 
     |_|  |_\___/\__,_|\_,_|_\___| |_|_||_| |_| \___|_\__,_|\__|_|\_/\___| | .__/\__,_|\__|_||_|
                                                                           |_|
     > This is really similar to MIM (Module in Module) so if you already know how to work with MIM, you should be able to do this.
     > Simply changing the parameter will patch the MIM to work with the relative path.
     
     The function is the same, but you also give it a second parameter, the module which is asking (almost always `script`):
     `ReturnInformation.require(path, script)`
     
     Now `path` starts from that module instead of the modules folder.
     `Hitbox` is a child of it, `..` goes up to the parent, and `.` stays where it is.
     
     Example, from a module called Combat:
     local Vortex = require(path.to.VortexFramework)
     local Hitbox = Vortex.require("Hitbox", script)
     local Health = Vortex.require("../Health", script)
     
     In the example above Hitbox is inside of Combat, and Health is next to Combat.
     Same as MIM, the module needs to return a table which is not empty, and `start` runs only the first time.
      ___              _    _           
     / __| ___ _ ___ _(_)__(_)_ _  __ _ 
     \__ \/ -_) '_\ V / / _| | ' \/ _` |
     |___/\___|_|  \_/|_\__|_|_||_\__, |
                                  |___/ 
     > Services let modules talk to each other without requiring each other (or knowing where the other one is stored).
     > MIM and MIRP are still there and still work exactly the same, a service is just another way to share a module.
     > If you only need to require a module you can skip this section.
     
     A service is a table with a unique `Name`. Whoever creates it registers it inside of the framework, and everybody else
     can ask the framework for it by that name. Every side (server / client) has its own services, a service made on the
     server is not visible to the client, that is what the Networking section is for.
     
     There are 3 functions:
     `ReturnInformation.createService(definition)` - Registers the service, and returns it (the same table you gave).
     `ReturnInformation.getService(name)` - Returns an existing service, errors if there is none.
     `ReturnInformation.waitForService(name, timeout?)` - Same as `getService`, but yields until it exists (default 10 seconds).
     
     The definition can contain:
     `Name` - (string) Required, must be unique for the side the service is on.
     `Client` - (table) Server only, optional. This is the part of the service the client can use, see the Networking section.
     `init` - (function) Optional. If you return the service from its ModuleScript, `ReturnInformation.init` calls it
     like any other module `init`, which also fulfils the "returns a table which is not empty" rule.
     `onStart` - (function) Optional. Gets called as `service:onStart()` once every module in the folder finished its `init`.
     It runs in its own thread, so it is allowed to yield. 
     Anything else you put inside is yours: methods, state, constants.
     
     Lifecycle, in order:
     1. `ReturnInformation.init(folder)` requires every module in the folder, that is where `createService` usually runs.
     2. Every module's `init` runs.
     3. Every service created so far gets `onStart`.
     Services created later (for example inside a module that was loaded thru MIM) get `onStart` right after they are created.
     
     Because of that, inside of `init` you should only create services, if you need another service, get it in `onStart`
     (or inside of a method), since the other module might not have created it yet.
     Do not yield on `waitForService` inside of `init`, `init` runs in sequence, so you would block the module that creates it.
     
     Example, two modules on the server:
     
     -- modules/CashService (ModuleScript)
     local Vortex = require(path.to.Vortex)
     
     local CashService = Vortex.createService({
         Name = "CashService",
     })
     
     local cash = {}
     
     function CashService:Get(player)
         return cash[player] or 0
     end
     
     function CashService:Add(player, amount)
         cash[player] = self:Get(player) + amount
     end
     
     function CashService.init()
         -- nothing to set up, but every module needs an `init`
     end
     
     return CashService
     
     -- modules/ShopService (ModuleScript)
     local Vortex = require(path.to.Vortex)
     
     local ShopService = Vortex.createService({
         Name = "ShopService",
     })
     
     function ShopService:onStart()
         self.Cash = Vortex.getService("CashService") -- every module finished init, so this is safe
     end
     
     function ShopService:Buy(player, price)
         if self.Cash:Get(player) < price then return false end
         self.Cash:Add(player, -price)
         return true
     end
     
     function ShopService.init() end
     
     return ShopService
      _  _     _                  _   _           
     | \| |___| |___ __ _____ _ _| |_(_)_ _  __ _ 
     | .` / -_)  _\ V  V / _ \ '_| / / | ' \/ _` |
     |_|\_\___|\__|\_/\_/\___/_| |_\_\_|_||_\__, |
                                        |___/ 
    > On top of patching issues and including MIM / MIRP this framework has Networking built in.
    > If you aren't interested for client/server communications then you can skip this part.
    
    Networking is built on top of services, so you never write RemoteEvent code yourself.
    You only create the network folder once (see the end of this section).
    A server service has a `Client` table, everything you put inside of it is what the client is allowed to use:
    - Functions become methods the client can call, the client gets whatever you return (works like a RemoteFunction).
    - Signals (made with `ReturnInformation.createSignal()`) become two way events (works like a RemoteEvent).
    Everything else inside of `Client` is not sent anywhere, and everything outside of `Client` is never reachable
    from the client, so the client can not call the rest of your service.
    
    `ReturnInformation.createSignal()` - Server only, makes a signal you place inside of `Client`.
    `ReturnInformation.getServerService(name)` - Client only, yields until it has the server service (default 10 seconds),
    returns a table which has the methods and signals of the `Client` table of that service.
    
    On the server:
    `Client` functions are written as `function Service.Client:Name(player, ...)`.
    `self` is the `Client` table, `self.Server` is the service itself, so you can reach the rest of it.
    `signal:Fire(player, ...)` - sends to one player.
    `signal:FireAll(...)` - sends to everyone.
    `signal:FireExcept(player, ...)` - sends to everyone except one player.
    `signal:Connect(function(player, ...) end)` - listens to what clients send, `Once` and `Wait` exist as well.
    
    On the client:
    `Service:Name(...)` - calls the server function (colon, like any method), yields until the server answers.
    `Service.Signal:Connect(function(...) end)` - listens to the server, `Once` and `Wait` exist as well.
    `Service.Signal:Fire(...)` - sends to the server.
    
    Example, the CashService from above, now with a client part:
    
    -- server, modules/CashService (ModuleScript)
    local Vortex = require(path.to.Vortex)
    
    local CashService = Vortex.createService({
        Name = "CashService",
        Client = {
            Changed = Vortex.createSignal(), -- server -> client
            Ping = Vortex.createSignal(),    -- client -> server
        },
    })
    
    local cash = {}
    
    function CashService.Client:Get(player)
        return self.Server:Get(player)
    end
    
    function CashService:Get(player)
        return cash[player] or 0
    end
    
    function CashService:Add(player, amount)
        cash[player] = self:Get(player) + amount
        self.Client.Changed:Fire(player, cash[player])
    end
    
    function CashService.init()
        CashService.Client.Ping:Connect(function(player, text)
            print(player.Name .. " pinged: " .. tostring(text))
        end)
    end
    
    return CashService
    
    -- client, any LocalScript or ModuleScript
    local Vortex = require(path.to.Vortex)
    local CashService = Vortex.getServerService("CashService")
    
    print(CashService:Get())
    
    CashService.Changed:Connect(function(newAmount)
        print("Cash is now " .. newAmount)
    end)
    
    CashService.Ping:Fire("hello")
    
    Things you should know:
    - The members of `Client` have to be in place before the client asks for the service, which is always the case if
    you write them when the module loads (like in the example). The client gets a snapshot of the names when it asks.
    - A signal only works while it is inside of a service's `Client` table, calling `Fire` on one that is not errors.
    - `getServerService` caches, you can call it as many times as you want and you get the same table back.
    - Signal events that were sent before `getServerService` returned are not received, connect right after you get it.
    - While the server is still starting up (before `ReturnInformation.init` finished) it will wait for a service the
    client asks for. After that, asking for a service which does not exist fails right away.
    - If a `Client` function errors, the error is printed on the server and the client gets an error saying that the server
    function errored, the real message is not sent to the client on purpose.
    - Never trust what the client gives you, everything a client sends (arguments of methods, arguments of signals)
    can be anything, so check it. The framework only checks the names (service and member), not your arguments.
    - Arguments follow the normal Roblox remote rules (no functions, metatables are lost, and so on).
    - `getServerService` does not need `ReturnInformation.init` to have run on the client, it only needs the server one.
    - The framework does NOT create any remotes itself, you have to make them once by hand. Put this inside of ReplicatedStorage:
        VortexNetwork (Folder)
            Event (RemoteEvent)
            Request (RemoteEvent)
            Response (RemoteEvent)
    All services share them, nothing else has to be created. The names have to be exactly like this.
    The module also has to be required on the server, because the server is what connects them.
    - If the client asks for a service and gets no answer, it asks again every second until the answer comes (or the timeout ends).
    
    Error codes, in case you meet one:
        E-001 modulesFolder is missing.
        E-002 module is missing.
        E-003 the thing is not a ModuleScript.
        E-004 module is empty or does not return a table.
        E-005 moduleName is missing.
        E-006 moduleName is not a string.
        E-007 foundModule is missing.
        E-008 module is missing an `init`.
        E-009 duplicate module name.
        E-010 path is missing or is not a string.
        E-011 relativeTo is not an Instance.
        E-012 absolute path used before `init`.
        E-013 no module at that path.
        E-014 service definition is not a table.
        E-015 service definition is missing a `Name`.
        E-016 duplicate service name.
        E-017 `Client` of a service is not a table.
        E-018 service name is missing or is not a string.
        E-019 `getService` did not find the service.
        E-020 `waitForService` timed out.
        E-021 `createSignal` was used on the client.
        E-022 `Fire` on a signal which is not inside of a service's `Client` table.
        E-023 first argument of `Fire` is not a Player.
        E-024 the handler given to `Connect` / `Once` is not a function.
        E-025 `getServerService` was used on the server.
        E-026 the client could not find the network folder (is the framework required on the server?).
        E-027 the server refused or did not answer `getServerService` (the service does not exist, or the network folder is missing).
        E-028 a server method called from the client failed.
        E-029 something inside of `VortexNetwork` is not a RemoteEvent.
        E-030 the `VortexNetwork` folder is missing from ReplicatedStorage.
        E-031 one of the three remotes (Event, Request, Response) is missing from the folder.
]]
