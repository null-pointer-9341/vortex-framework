# Changes

All changes to Vortex Framework are recorded below.

## [1.2.0] - 2026-10-25

### Breaking

- The framework **does not create network remotes anymore**. You will have to create it once manually, inside of `ReplicatedStorage`:
  `VortexNetwork` (Folder) with the RemoteEvents `Event`, `Request` and `Response` inside of it.
  Some engines ignore any messages sent via remotes that were created during runtime which made all client requests time out.
- The server does not delete the `VortexNetwork` folders on start anymore.

### Added

- Error `E-029`: something in `VortexNetwork` is not a RemoteEvent.
- Error `E-030`: the `VortexNetwork` folder is not found in `ReplicatedStorage`.
- Error `E-031`: one of the required remotes `Event`, `Request`, `Response` is missing from the folder.
- The client asks for the service manifest again each second (`RESEND_INTERVAL`) until the server responds. Function calls will be sent just once, thus a server function will never be run twice.
- Timeout error message now contains the location where you can find more information.

### Changed

- The client never sends `nil` value in a request (an empty string means "no member name") since some engines drop messages containing `nil` values.
- The second response to a request will be ignored.
- `E-027` now also includes "the server did not respond".
- The log entry of the client regarding the network folder does not include the number of folders anymore.
- Documentation: Networking chapter mentions the manual creation of the folder, resending behavior and new errors.

## [1.1.0]

- Servicing: `createService`, `getService`, `waitForService`, `init`, `onStart`.
- Networking: server services with a `Client` table, signals (`createSignal`), `getServerService` on client side.
- Module in Module (MIM) and Module in relative path (MIRP) via `ReturnInformation.require`.

## [1.0.0]

- First release: module loading with `init` and sample modules.
