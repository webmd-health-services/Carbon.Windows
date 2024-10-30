
function Uninstall-CEventLog
{
    <#
    .SYNOPSIS
    Removes an event log.

    .DESCRIPTION
    The `Uninstall-CEventLog` function removes an event log from the local computer.

    This function will not write an error if the event log does not already exist.

    .EXAMPLE
    Uninstall-CEventLog -LogName 'TestApp'

    Demonstrates removing the `TestApp` event log.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $LogName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    Remove-CEventLog -LogName $LogName -ErrorAction 'SilentlyContinue'
}