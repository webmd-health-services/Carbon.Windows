
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
* `Get-CEventLog`, as a drop in replacement for using `Get-EventLog` in PowerShell 7.
* `Install-CEventLog`, which creates an event log only if it doesn't already exist.
* `New-CEventLog`, as a drop in replacement for using `New-EventLog` in PowerShell 7.
* `Register-CBackConnectionHostName`, for adding a back connection hostname, if it isn't already configured.
* `Remove-CEventLog`, as a drop in replacement for using `Remove-EventLog` in PowerShell 7.
* `Test-CEventLog`, which checks if an event log exists.
* `Uninstall-CEventLog`, which removes an event log only if it doesn't already exist
* `Unregister-CBackConnectionHostName`, for removing a back connection hostname, if it exists.
