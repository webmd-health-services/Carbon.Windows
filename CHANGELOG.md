
# Carbon.Windows Changelog

## 1.1.0

> Released 04 Nov 24

Added functions:

* `Get-CEventLog`, as a drop in replacement for using `Get-EventLog` in PowerShell 7.
* `Install-CEventLog`,  which creates an event log only if it doesn't already exist.
* `New-CEventLog`, as a drop in replacement for using `New-EventLog` in PowerShell 7.
* `Remove-CEventLog`, as a drop in replacement for using `Remove-EventLog` in PowerShell 7.
* `Test-CEventLog`, which checks if an event log exists.
* `Uninstall-CEventLog`, which creates an event log only if it doesn't already exist.

## 1.0.0

> Released 16 Aug 2023

Added functions:

* `Get-CBackConnectionHostName`, for getting the currently configured back connection hostnames.
* `Register-CBackConnectionHostName`, for adding a back connection hostname.
* `Unregister-CBackConnectionHostName`, for removing a back connection hostname.
