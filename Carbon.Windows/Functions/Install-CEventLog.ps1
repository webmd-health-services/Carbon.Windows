
function Install-CEventLog
{
    <#
    .SYNOPSIS
    Creates an event log.

    .DESCRIPTION
    The `Install-CEventLog` function is a drop-in replacement for the `New-EventLog` function that is available in
    Windows PowerShell, but with support for PowerShell.

    This function is idempotent and will not write an error if the event log source already exists.

    .EXAMPLE
    Install-CEventLog -LogName 'TestApp' -Source 'TestLog'

    Demonstrates creating a `TestLog` event log and registers `TestApp` as a source for the log.
    #>
    [CmdletBinding()]
    param(
        # The name of the log to be created.
        [Parameter(Mandatory)]
        [String] $LogName,

        # The source of
        [Parameter(Mandatory)]
        [String[]] $Source
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    New-CEventLog -LogName $LogName -Source $Source -ErrorAction 'SilentlyContinue'
}