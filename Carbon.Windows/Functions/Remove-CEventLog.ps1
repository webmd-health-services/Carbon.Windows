
function Remove-CEventLog
{
    <#
    .SYNOPSIS
    Removes an event log.

    .DESCRIPTION
    The `Remove-CEventLog` function removes an event log from the local computer.

    This function will write an error if the event log does not exist.

    .EXAMPLE
    Remove-CEventLog -LogName 'TestApp'

    Demonstrates removing the `TestApp` event log.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The name of the log to remove.
        [Parameter(Mandatory)]
        [String] $LogName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if (-not (Test-CEventLog -LogName $LogName))
    {
        Write-Error -Message "Event log '${LogName}' does not exist." -ErrorAction $ErrorActionPreference
    }

    if ($PSCmdlet.ShouldProcess("event log '$LogName'", "delete"))
    {
        [Diagnostics.EventLog]::Delete($LogName)
    }
}