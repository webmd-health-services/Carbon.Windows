
function New-CEventLog
{
    <#
    .SYNOPSIS
    Creates an event log.

    .DESCRIPTION
    The `New-CEventLog` creates a new Windows Event Log on the local computer and registers event sources for the log.

    This function will write an error if the event log exists.

    .EXAMPLE
    New-CEventLog -LogName 'TestApp' -Source 'TestLog'

    Demonstrates creating a `TestLog` event log and registers `TestApp` as a source for the log.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The name of the log to be created.
        [Parameter(Mandatory)]
        [String] $LogName,

        # The source of the events to be written to the log.
        [Parameter(Mandatory)]
        [String[]] $Source
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    foreach ($s in $Source)
    {
        if (Test-CEventLog -LogName $LogName)
        {
            Write-Error -Message "Event log source '${s}' already exists." -ErrorAction $ErrorActionPreference
            return
        }
        if ($PSCmdlet.ShouldProcess("$s event log source '${LogName}'", "install"))
        {
            [Diagnostics.EventLog]::CreateEventSource($s, $LogName)
        }
    }
}