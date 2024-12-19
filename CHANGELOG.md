
# Carbon.Windows Changelog

## 1.1.1

### Fixed

* `Register-CBackConnectionHostName` adds duplicate hostnames.
* `Carbon.Windows` requires admin privileges to import.

## 1.1.0

> Released 5 Dec 2024

Added functions:

* `Get-CEventLog`, for fetching available event logs.
* `Install-CEventLog`, which creates an event log with specified sources only if the log and the sources do not exist.
* `New-CEventLog`, for creating an event log or registering a new source to an event log.
* `Remove-CEventLog`, for removing an event log or event source.
* `Test-CEventLog`, which checks if an event log or an event source exists.
* `Uninstall-CEventLog`, which removes an event log or event source only if it exists.

## 1.0.0

> Released 16 Aug 2023

Added functions:

* `Get-CBackConnectionHostName`, for getting the currently configured back connection hostnames.
* `Register-CBackConnectionHostName`, for adding a back connection hostname.
* `Unregister-CBackConnectionHostName`, for removing a back connection hostname.
