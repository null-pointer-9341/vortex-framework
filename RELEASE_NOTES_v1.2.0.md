## Vortex Framework 1.2.0

Now networking is functional in clients/servers where remote events are not delivered during runtime within engines. The only downside is that there is an initial set up phase involved.

### Breaking Changes Required

Manually create the structure inside `ReplicatedStorage`. This has to be done once manually.

```lua
VortexNetwork
	Event (RemoteEvent)
	Request (RemoteEvent)
	Response (RemoteEvent)
```

Now vortex doesn't set up the required structure anymore automatically. In case either of them isn't found then the whole script stops execution with errors specified as E-030 and E-031 accordingly.

### New Features

- Resend manifest request every second until getting response from server side.
- Added 3 more Error Codes, E-029, E-030, E-031.
- Timeout Error improved with better description.
- Updated Documentations. Networking and Error list sections respectively.

### Source Code

- VortexFramework.lua
- Documentation.lua

Changes Log Link: CHANGELOG.md
