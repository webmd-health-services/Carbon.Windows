
function Remove-CEventLog
{
    <#
    .SYNOPSIS
    Removes an event log.

    .DESCRIPTION
    The `Remove-CEventLog` function removes an event log from the local computer and unregisters all of the associated
    event sources. If the event log does not exist, an error is written. If the `Source` parameter is specified, only
    the provided sources will be unregistered. The log associated with the sources will not be removed. If the source
    does not exist, an error is thrown.

    .EXAMPLE
    Remove-CEventLog -LogName 'TestApp'

    Demonstrates removing the `TestApp` event log.

    .EXAMPLE
    Remove-CEventLog -Source 'TestLog'

    Demonstrates unregistering the `TestLog` event source regardless of the Log it belongs to.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='LogName')]
    param(
        # The name of the log to remove.
        [Parameter(Mandatory, ParameterSetName='LogName')]
        [String[]] $LogName,

        # The name of the event source to remove.
        [Parameter(Mandatory, ParameterSetName='Source')]
        [String[]] $Source
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($LogName)
    {
        foreach ($log in $LogName)
        {
            if (-not (Test-CEventLog -LogName $log))
            {
                Write-Error -Message "Event log '${LogName}' does not exist." -ErrorAction $ErrorActionPreference
                return
            }

            if ($PSCmdlet.ShouldProcess("event log '$LogName'", "delete"))
            {
                [Diagnostics.EventLog]::Delete($LogName)
            }
        }
        return
    }

    foreach ($s in $Source)
    {
        if (-not (Test-CEventLog -Source $s))
        {
            Write-Error -Message "Event log source '${s}' does not exist." -ErrorAction $ErrorActionPreference
            return
        }

        if ($PSCmdlet.ShouldProcess("event log source '${s}'", "uninstall"))
        {
            [Diagnostics.EventLog]::DeleteEventSource($s)
        }
    }
}