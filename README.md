
# Carbon.Windows

## Overview

The "Carbon.Windows" PowerShell module is used to manage Windows.

## System Requirements

* Windows PowerShell 5.1 and .NET 4.6.1+
* PowerShell 7+

## Installing

To install globally:

```powershell
Install-Module -Name 'Carbon.Windows'
Import-Module -Name 'Carbon.Windows'
```

To install privately:

```powershell
Save-Module -Name 'Carbon.Windows' -Path '.'
Import-Module -Name '.\Carbon.Windows'
```

## Commands

* `Get-CBackConnectionHostName`, for getting the list of currently configured back connection hostnames.
* `Get-CEventLog`, for fetching available event logs.
* `Install-CEventLog`, which creates an event log with specified sources only if the log and the sources do not exist.
* `New-CEventLog`, for creating an event log or registering a new source to an event log.
* `Register-CBackConnectionHostName`, for adding a back connection hostname, if it isn't already configured.
* `Remove-CEventLog`, for removing an event log or event source.
* `Test-CEventLog`, which checks if an event log or an event source exists.
* `Uninstall-CEventLog`, which removes an event log or event source only if it exists.
* `Unregister-CBackConnectionHostName`, for removing a back connection hostname, if it exists.
