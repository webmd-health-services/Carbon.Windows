
function Remove-CEventLog
{
    <#
    .SYNOPSIS
    Removes an event log.

    .DESCRIPTION
    The `Remove-CEventLog` function removes an event log from the local computer.

    This function will write an error if the event log does not already exist.

    .EXAMPLE
    Remove-CEventLog -LogName 'TestApp'

    Demonstrates removing the `TestApp` event log.
    #>
    [CmdletBinding()]
    param(
        # The name of the log to remove.
        [Parameter(Mandatory)]
        [String] $LogName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ([Diagnostics.EventLog]::GetEventLogs().LogDisplayName -like $LogName)
    {
        [Diagnostics.EventLog]::Delete($LogName)
        return
    }
    Write-Error -Message "Event log '$LogName' does not exist."
}