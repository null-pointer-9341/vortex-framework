--[[

      _  _  ___    _____ _   __  __ ___ ___ ___ ___ _  _  ___   ___  _   ___ _____   _____ _  _ ___ ___   ___  ___ ___ _  _ _____ 
     | \| |/ _ \  |_   _/_\ |  \/  | _ \ __| _ \_ _| \| |/ __| | _ \/_\ / __|_   _| |_   _| || |_ _/ __| | _ \/ _ \_ _| \| |_   _|
     | .` | (_) |   | |/ _ \| |\/| |  _/ _||   /| || .` | (_ | |  _/ _ \\__ \ | |     | | | __ || |\__ \ |  _/ (_) | || .` | | |  
     |_|\_|\___/    |_/_/ \_\_|  |_|_| |___|_|_\___|_|\_|\___| |_|/_/ \_\___/ |_|     |_| |_||_|___|___/ |_|  \___/___|_|\_| |_|  
    
    Unless you know what you're doing.
    The following code is for the framework itself, editing it may result in loss of functionality, errors.
    
]]

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- Everything the module hands back to whoever requires it
local ReturnInformation = {
    modules = {
        
    }
}

-- Variables
local root = replicatedStorage:FindFirstChild("shared")
local modules = root and root:FindFirstChild("modules")
local rootFolders = {}
local startedModules = {}

-- Service state
local services = {}
local pendingStart = {}
local initializing = false
local initialized = false

-- Networking state
local network = nil
local serverProxies = {}
local clientSignals = {}
local pendingRequests = {} -- client only: request id -> { done = boolean, results = table }
local nextRequestId = 0

-- Constants
local DEBUG_MODE = true -- Flip this off to silence the console output. It's safe to change if you want to.

local IS_SERVER = runService:IsServer()
local SIDE = IS_SERVER and "Server" or "Client"

local NETWORK_FOLDER_NAME = "VortexNetwork"
local NETWORK_REMOTE_NAMES = { "Event", "Request", "Response" }
local NETWORK_TIMEOUT = 10 -- How long (in seconds) to wait for a service or the network folder before giving up. You SHOULD be able to change it.
local RESEND_INTERVAL = 1 -- How long (in seconds) the client waits before sending a `manifest` request again if no answer came.

-- Functions
-- Error handling
local function fail(code: string, message: string, ...)
    error(string.format("[VortexFramework][%s] %s: " .. message, SIDE, code, ...), 3)
end

local function log(message: string)
    if not DEBUG_MODE then return end

    print(string.format("[VortexFramework][%s] %s", SIDE, message))
end

-- Private API
local function newModule(foundModule: ModuleScript) 
    if not foundModule then
        fail("E-002", "module is missing.")
    end
    if not foundModule:IsA("ModuleScript") then
        fail("E-003", "%s is not a %s.", foundModule.Name, "ModuleScript")
    end
    if ReturnInformation.modules[foundModule.Name] then
        fail("E-009", "%s is a duplicate module name.", foundModule.Name)
    end
    local moduleData = require(foundModule)
    if type(moduleData) ~= "table" or next(moduleData) == nil then 
        fail("E-004", "%s is empty or does not return a table.", foundModule.Name)
    end
    log("Module named " .. foundModule.Name .. " passed all checks, so it's going into ReturnInformation.modules now.")
    ReturnInformation.modules[foundModule.Name] = moduleData
    
    return foundModule.Name
end

local function initateModule(moduleName: string)
    if not moduleName then
        fail("E-005", "moduleName is missing.")
    end
    if typeof(moduleName) ~= "string" then
        fail("E-006", "moduleName is not a string.")
    end
    
    local foundModule = ReturnInformation.modules[moduleName]
    if not foundModule then
        fail("E-007", "foundModule is missing.")
    end
    
    local init = foundModule.init
    if type(init) ~= "function" then 
        fail("E-008", "foundModule is missing a `init`. Check the Documentation (the Module Requirements section) to see what each module needs.")
    end
    
    init()
end

-- Follows a path like "A/B/C" starting from `base`. ".." steps up to the parent, "." just stays where it is.
local function resolvePath(base: Instance, path: string)
    local current = base
    for segment in string.gmatch(path, "[^/]+") do
        if segment == ".." then
            current = current.Parent
        elseif segment ~= "." then
            current = current:FindFirstChild(segment)
        end
        
        if not current then
            return nil
        end
    end
    
    return current
end

-- Signals
-- A basic signal. The networking signals are built on top of this one.
local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
    if not self.Connected then return end
    
    self.Connected = false
    local list = self._signal._connections
    local index = table.find(list, self)
    if index then
        table.remove(list, index)
    end
end

function Signal:Connect(handler: (...any) -> ())
    if type(handler) ~= "function" then
        fail("E-024", "the handler given to Connect is not a function.")
    end
    
    local connection = setmetatable({
        Connected = true,
        _signal = self,
        _handler = handler,
    }, Connection)
    table.insert(self._connections, connection)
    
    return connection
end

function Signal:Once(handler: (...any) -> ())
    if type(handler) ~= "function" then
        fail("E-024", "the handler given to Once is not a function.")
    end
    
    local connection
    connection = self:Connect(function(...)
        connection:Disconnect()
        handler(...)
    end)
    
    return connection
end

function Signal:Wait()
    local thread = coroutine.running()
    local connection
    connection = self:Connect(function(...)
        connection:Disconnect()
        task.spawn(thread, ...)
    end)
    
    return coroutine.yield()
end

function Signal:DisconnectAll()
    for _, connection in ipairs(self._connections) do
        connection.Connected = false
    end
    self._connections = {}
end

-- Runs each handler in its own thread. The framework uses this internally, so you shouldn't need to call it yourself.
function Signal:_dispatch(...)
    for _, connection in ipairs(table.clone(self._connections)) do
        if connection.Connected then
            task.spawn(connection._handler, ...)
        end
    end
end

-- The server's version of a signal. This is what `createSignal` gives you.
local ServerSignal = setmetatable({}, { __index = Signal })
ServerSignal.__index = ServerSignal

function ServerSignal:_bind(serviceName: string, signalName: string)
    self._serviceName = serviceName
    self._signalName = signalName
end

function ServerSignal:Fire(player: Player, ...)
    if not self._signalName then
        fail("E-022", "this signal isn't inside a service's `Client` table, so it can't be fired.")
    end
    if typeof(player) ~= "Instance" or not player:IsA("Player") then
        fail("E-023", "the first argument of Fire has to be a Player. If you want to send to everyone, use FireAll.")
    end
    
    network.event:FireClient(player, self._serviceName, self._signalName, ...)
end

function ServerSignal:FireAll(...)
    if not self._signalName then
        fail("E-022", "this signal isn't inside a service's `Client` table, so it can't be fired.")
    end
    
    network.event:FireAllClients(self._serviceName, self._signalName, ...)
end

function ServerSignal:FireExcept(ignored: Player, ...)
    if not self._signalName then
        fail("E-022", "this signal isn't inside a service's `Client` table, so it can't be fired.")
    end
    
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= ignored then
            network.event:FireClient(player, self._serviceName, self._signalName, ...)
        end
    end
end

-- The client's version of a signal. A server service hands one of these out for each of its signals.
local ClientSignal = setmetatable({}, { __index = Signal })
ClientSignal.__index = ClientSignal

function ClientSignal:Fire(...)
    network.event:FireServer(self._serviceName, self._signalName, ...)
end

-- Servicing (private)
local function waitForServiceInternal(name: string, timeout: number)
    local deadline = os.clock() + timeout
    while not services[name] and os.clock() < deadline do
        task.wait()
    end
    
    return services[name]
end

-- Gives every signal inside `Client` its service name and signal name. It's safe to call this multiple times.
local function bindClientMembers(service)
    if not IS_SERVER then return end
    
    for memberName, member in pairs(service.Client) do
        if type(memberName) == "string" and type(member) == "table" and getmetatable(member) == ServerSignal then
            member:_bind(service.Name, memberName)
        end
    end
end

local function startServices()
    local queue = pendingStart
    pendingStart = {}
    
    for _, service in ipairs(queue) do
        bindClientMembers(service)
        
        if type(service.onStart) == "function" then
            log("Running `onStart` of service " .. service.Name .. ".")
            task.spawn(service.onStart, service)
        end
    end
end

-- Networking (private)
-- Server side: works out the answer to a client request. A client either asks what a service looks like ("manifest")
-- or wants to call one of its `Client` functions ("call"). The first returned value is always true / false.
local function handleRequest(player: Player, kind: any, serviceName: any, memberName: any, ...)
    if type(kind) ~= "string" or type(serviceName) ~= "string" then
        return false, "malformed request."
    end
    
    -- We only wait while the server is still starting up. After that, a client can't tie up threads by asking for services that don't exist.
    local service = waitForServiceInternal(serviceName, initialized and 0 or NETWORK_TIMEOUT)
    if not service then
        return false, string.format("service `%s` does not exist.", serviceName)
    end
    
    local client = service.Client
    bindClientMembers(service)
    
    if kind == "manifest" then
        local methods, signals = {}, {}
        for name, member in pairs(client) do
            if type(name) == "string" then
                if type(member) == "function" then
                    table.insert(methods, name)
                elseif type(member) == "table" and getmetatable(member) == ServerSignal then
                    table.insert(signals, name)
                end
            end
        end
        table.sort(methods)
        table.sort(signals)
        
        return true, methods, signals
    elseif kind == "call" then
        if type(memberName) ~= "string" then
            return false, "malformed request."
        end
        
        local method = rawget(client, memberName)
        if type(method) ~= "function" then
            return false, string.format("`%s` is not a client function of service `%s`.", memberName, serviceName)
        end
        
        local results = table.pack(pcall(method, client, player, ...))
        if not results[1] then
            warn(string.format("[VortexFramework][Server] %s.%s errored: %s", serviceName, memberName, tostring(results[2])))
            return false, "the server function errored."
        end
        
        return true, table.unpack(results, 2, results.n)
    end
    
    return false, "unknown request."
end

-- Server side: a client fired one of the signals inside a `Client` table.
local function onServerEvent(player: Player, serviceName: any, signalName: any, ...)
    if type(serviceName) ~= "string" or type(signalName) ~= "string" then return end
    
    local service = services[serviceName]
    if not service then return end
    
    local signal = rawget(service.Client, signalName)
    if type(signal) ~= "table" or getmetatable(signal) ~= ServerSignal then return end
    
    signal:_dispatch(player, ...)
end

-- Server side: a client sent a request, answer it on the response remote with the same id.
local function onServerRequest(player: Player, id: any, kind: any, serviceName: any, memberName: any, ...)
    if type(id) ~= "number" then return end
    
    log(string.format("Request %d from %s: %s %s", id, player.Name, tostring(kind), tostring(serviceName)))
    
    local results = table.pack(pcall(handleRequest, player, kind, serviceName, memberName, ...))
    if not results[1] then
        warn("[VortexFramework][Server] request failed: " .. tostring(results[2]))
        network.response:FireClient(player, id, false, "the server errored while handling the request.")
        return
    end
    
    network.response:FireClient(player, id, table.unpack(results, 2, results.n))
end

-- Server side: gets the network folder ready.
-- The framework does NOT create any remotes itself (some engines don't deliver messages sent through remotes that were
-- created while the game runs), so ReplicatedStorage has to contain, made by hand in the editor:
--   VortexNetwork (Folder)
--     Event (RemoteEvent)
--     Request (RemoteEvent)
--     Response (RemoteEvent)
local function setupServerNetwork()
    local folder = replicatedStorage:FindFirstChild(NETWORK_FOLDER_NAME)
    if not folder then
        fail("E-030", "there's no `%s` folder inside of ReplicatedStorage. Create it by hand, with the RemoteEvents Event, Request and Response inside of it.", NETWORK_FOLDER_NAME)
    end
    
    log("Found the " .. NETWORK_FOLDER_NAME .. " folder.")
    
    local remotes = {}
    for _, remoteName in ipairs(NETWORK_REMOTE_NAMES) do
        local remote = folder:FindFirstChild(remoteName)
        if not remote then
            fail("E-031", "there's no `%s` inside of %s. Create a RemoteEvent with that name by hand.", remoteName, NETWORK_FOLDER_NAME)
        end
        if not remote:IsA("RemoteEvent") then
            fail("E-029", "`%s` inside of %s is not a RemoteEvent.", remoteName, NETWORK_FOLDER_NAME)
        end
        remotes[remoteName] = remote
    end
    
    network = { event = remotes.Event, request = remotes.Request, response = remotes.Response }
    
    network.event.OnServerEvent:Connect(onServerEvent)
    network.request.OnServerEvent:Connect(onServerRequest)
    
    -- The stamp goes on last, it tells the client the folder is finished.
    local stamp = string.format("%d-%d", os.time(), math.random(1000, 9999))
    folder:SetAttribute("Stamp", stamp)
    
    log("Network ready. Stamp: " .. stamp)
end

-- Client side: the server fired one of its signals.
local function onClientEvent(serviceName: any, signalName: any, ...)
    local signals = clientSignals[serviceName]
    local signal = signals and signals[signalName]
    if signal then
        signal:_dispatch(...)
    end
end

-- Client side: the server answered a request, store the answer for the code that is waiting for it.
local function onClientResponse(id: any, ...)
    if DEBUG_MODE then
        local types = {}
        for index = 1, select("#", ...) do
            table.insert(types, typeof((select(index, ...))))
        end
        log("Response " .. tostring(id) .. ": " .. table.concat(types, ", "))
    end
    
    local pending = pendingRequests[id]
    if pending and not pending.done then
        pending.results = table.pack(...)
        pending.done = true
    end
end

-- Client side: finds the folder the server made. Only a finished folder with a stamp counts.
local function findNetworkFolder()
    for _, child in ipairs(replicatedStorage:GetChildren()) do
        if child.Name == NETWORK_FOLDER_NAME
            and child:GetAttribute("Stamp")
            and child:FindFirstChild("Event")
            and child:FindFirstChild("Request")
            and child:FindFirstChild("Response") then
            return child
        end
    end
    
    return nil
end

local function ensureClientNetwork()
    if network then return network end
    
    local deadline = os.clock() + NETWORK_TIMEOUT
    local folder = findNetworkFolder()
    while not folder and os.clock() < deadline do
        task.wait()
        folder = findNetworkFolder()
    end
    if not folder then
        fail("E-026", "could not find the network folder. Make sure the framework is also required on the server.")
    end
    
    -- Check again, since another thread may have finished setting up the network while we were waiting above.
    if network then return network end
    
    log(string.format("Using network folder with stamp %s.", tostring(folder:GetAttribute("Stamp"))))
    
    network = {
        event = folder.Event,
        request = folder.Request,
        response = folder.Response,
    }
    network.event.OnClientEvent:Connect(onClientEvent)
    network.response.OnClientEvent:Connect(onClientResponse)
    
    return network
end

-- Client side: sends a request to the server and waits for the answer.
-- It waits by checking a flag (not by yielding and hoping to be resumed), so nothing else can wake it up with a wrong answer.
-- A `manifest` request is sent again every RESEND_INTERVAL seconds until the answer arrives, because asking for a manifest
-- twice changes nothing. Other requests are only sent once, so a server function never runs twice.
-- Returns true plus the results, or false plus an error message.
local function sendRequest(kind: string, serviceName: string, memberName: string?, ...)
    local net = ensureClientNetwork()
    
    nextRequestId += 1
    local id = nextRequestId
    local pending = { done = false, results = nil }
    pendingRequests[id] = pending
    
    log(string.format("Sending request %d: %s %s", id, kind, serviceName))
    
    local args = table.pack(...)
    local canResend = kind == "manifest"
    local lastSent = nil
    local deadline = os.clock() + NETWORK_TIMEOUT + 5
    
    while not pending.done and os.clock() < deadline do
        if lastSent == nil or (canResend and os.clock() - lastSent >= RESEND_INTERVAL) then
            lastSent = os.clock()
            -- memberName is never nil on the wire (an empty string stands for "none"), some engines drop remotes that contain a nil.
            net.request:FireServer(id, kind, serviceName, memberName or "", table.unpack(args, 1, args.n))
        end
        task.wait()
    end
    pendingRequests[id] = nil
    
    if not pending.done then
        return false, "the server did not answer in time. If the server never printed \"Request " .. id .. " from ...\", check that the " .. NETWORK_FOLDER_NAME .. " folder with its three RemoteEvents exists inside of ReplicatedStorage."
    end
    
    return table.unpack(pending.results, 1, pending.results.n)
end

local function invokeServerMethod(serviceName: string, methodName: string, ...)
    local results = table.pack(sendRequest("call", serviceName, methodName, ...))
    if not results[1] then
        fail("E-028", "%s.%s failed: %s", serviceName, methodName, tostring(results[2]))
    end
    
    return table.unpack(results, 2, results.n)
end

-- Public API
function ReturnInformation.init(modulesFolder: Folder)
    local start = 0
    if DEBUG_MODE then start = os.clock() end
    
    if not modulesFolder then
        fail("E-001", "%s is missing in %s.", "modulesFolder", "ReturnInformation.init")
    end
    
    log("Passed modulesFolder check")
    
    initializing = true
    
    if not table.find(rootFolders, modulesFolder) then
        table.insert(rootFolders, modulesFolder)
    end

    local loadedModules = {}
    for _, moduleInFolder in pairs(modulesFolder:GetChildren()) do 
        if moduleInFolder:IsA("ModuleScript") then
            log("Checking " .. moduleInFolder.Name .. ".")
            local ModuleObject = newModule(moduleInFolder)
            table.insert(loadedModules, ModuleObject)
        end
    end
    
    log("Moving on to the initialization sequence")
    for _, ModuleObject in ipairs(loadedModules) do
        initateModule(ModuleObject)
    end
    
    initializing = false
    initialized = true
    startServices()
    
    if DEBUG_MODE then
        local elapsed = os.clock() - start
        log("Finished. Time took: " .. elapsed)
    end
    
    return 1
end

-- Requiring a module from inside another module.
-- With an absolute path, we start from the folder you gave to init.
-- With a relative path, pass `script` as relativeTo and the path is resolved from there.
function ReturnInformation.require(path: string, relativeTo: Instance?)
    if type(path) ~= "string" or path == "" then
        fail("E-010", "path is missing or is not a string.")
    end
    
    local foundModule
    if relativeTo ~= nil then
        if typeof(relativeTo) ~= "Instance" then
            fail("E-011", "relativeTo is not an Instance. Pass `script` if you want a relative path.")
        end
        
        foundModule = resolvePath(relativeTo, path)
    else
        if #rootFolders == 0 then
            fail("E-012", "there's no modules folder yet. Run ReturnInformation.init before using an absolute path.")
        end
        
        for _, rootFolder in ipairs(rootFolders) do
            foundModule = resolvePath(rootFolder, path)
            if foundModule then break end
        end
    end
    
    if not foundModule then
        fail("E-013", "no module was found at path `%s`.", path)
    end
    if not foundModule:IsA("ModuleScript") then
        fail("E-003", "%s is not a %s.", foundModule.Name, "ModuleScript")
    end
    
    local moduleData = require(foundModule)
    if type(moduleData) ~= "table" or next(moduleData) == nil then 
        fail("E-004", "%s is empty or does not return a table.", foundModule.Name)
    end
    
    if not startedModules[foundModule] then
        startedModules[foundModule] = true
        
        if type(moduleData.start) == "function" then
            log("Running `start` of " .. foundModule.Name .. ".")
            moduleData.start()
        end
    end
    
    return moduleData
end

-- Servicing
-- Registers a service and hands it back. Other code finds it by `definition.Name`.
function ReturnInformation.createService(definition)
    if type(definition) ~= "table" then
        fail("E-014", "the service definition is not a table.")
    end
    
    local name = definition.Name
    if type(name) ~= "string" or name == "" then
        fail("E-015", "the service definition is missing a `Name` string.")
    end
    if services[name] then
        fail("E-016", "%s is a duplicate service name.", name)
    end
    
    if IS_SERVER then
        if definition.Client == nil then
            definition.Client = {}
        elseif type(definition.Client) ~= "table" then
            fail("E-017", "`Client` of service %s is not a table.", name)
        end
        
        definition.Client.Server = definition
    end
    
    services[name] = definition
    bindClientMembers(definition)
    table.insert(pendingStart, definition)
    log("Service named " .. name .. " was created.")
    
    if initialized and not initializing then
        task.defer(startServices)
    end
    
    return definition
end

-- Returns a service from this side. Errors if it doesn't exist (yet).
function ReturnInformation.getService(name: string)
    if type(name) ~= "string" or name == "" then
        fail("E-018", "the service name is missing or is not a string.")
    end
    
    local service = services[name]
    if not service then
        fail("E-019", "no service named %s exists. Create it with createService first (or use waitForService).", name)
    end
    
    return service
end

-- Works like getService, except it waits until the service exists.
function ReturnInformation.waitForService(name: string, timeout: number?)
    if type(name) ~= "string" or name == "" then
        fail("E-018", "the service name is missing or is not a string.")
    end
    
    local seconds = timeout or NETWORK_TIMEOUT
    local service = waitForServiceInternal(name, seconds)
    if not service then
        fail("E-020", "service %s was not created within %s seconds.", name, tostring(seconds))
    end
    
    return service
end

-- Networking
-- Creates a signal. Put it inside a service's `Client` table.
function ReturnInformation.createSignal()
    if not IS_SERVER then
        fail("E-021", "createSignal can only be used on the server.")
    end
    
    return setmetatable({ _connections = {} }, ServerSignal)
end

-- Client only. Returns the `Client` part of a server service (this yields). Calls and signals work the way the documentation describes.
function ReturnInformation.getServerService(name: string)
    if IS_SERVER then
        fail("E-025", "getServerService can only be used on the client. On the server, use getService.")
    end
    if type(name) ~= "string" or name == "" then
        fail("E-018", "the service name is missing or is not a string.")
    end
    
    local cached = serverProxies[name]
    if cached then return cached end
    
    local ok, methods, signals = sendRequest("manifest", name)
    if not ok then
        fail("E-027", "could not get server service %s: %s", name, tostring(methods))
    end
    if type(methods) ~= "table" or type(signals) ~= "table" then
        fail("E-027", "the server sent a bad manifest for %s (got %s and %s).", name, typeof(methods), typeof(signals))
    end
    
    -- Another thread may have got the same service while this one was waiting for the server.
    if serverProxies[name] then
        return serverProxies[name]
    end
    
    local proxy = {}
    local signalMap = {}
    
    for _, methodName in ipairs(methods) do
        proxy[methodName] = function(_, ...)
            return invokeServerMethod(name, methodName, ...)
        end
    end
    
    for _, signalName in ipairs(signals) do
        local signal = setmetatable({
            _connections = {},
            _serviceName = name,
            _signalName = signalName,
        }, ClientSignal)
        
        proxy[signalName] = signal
        signalMap[signalName] = signal
    end
    
    clientSignals[name] = signalMap
    serverProxies[name] = proxy
    log("Server service named " .. name .. " is ready.")
    
    return proxy
end

if IS_SERVER then
    setupServerNetwork()
end

return ReturnInformation
