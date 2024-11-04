
function New-CEventLog
{
    <#
    .SYNOPSIS
    Creates an event log.

    .DESCRIPTION
    The `New-CEventLog` is a drop-in replacement for the `New-EventLog` function that is available in Windows
    PowerShell, but with support for PowerShell.

    This function will write an error if the event log source already exists.

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
        if ([Diagnostics.EventLog]::SourceExists($s))
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