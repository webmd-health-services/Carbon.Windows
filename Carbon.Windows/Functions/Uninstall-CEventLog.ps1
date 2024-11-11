
function Uninstall-CEventLog
{
    <#
    .SYNOPSIS
    Removes an event log.

    .DESCRIPTION
    The Uninstall-CEventLog function removes an event log from the local computer, if it exists. If the event log
    doesn't exist, the function does nothing.

    .EXAMPLE
    Uninstall-CEventLog -LogName 'TestApp'

    Demonstrates removing the `TestApp` event log.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [String] $LogName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if (Test-CEventLog -LogName $LogName)
    {
        Remove-CEventLog -LogName $LogName
    }
}