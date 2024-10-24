
function New-CEventLog
{
    <#
    .SYNOPSIS
    Creates an event log.

    .DESCRIPTION
    The `New-CEventLog` is a drop-in replacement for the `New-EventLog` function that is available in Windows
    PowerShell, but with support for PowerShell Core.

    .EXAMPLE
    New-CEventLog -LogName 'TestApp' -Source 'TestLog'

    Demonstrates creating a `TestLog` event log and registers `TestApp` as a source for the log.
    #>
    [CmdletBinding(SupportsShouldProcess)]
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

    foreach ($s in $Source)
    {
        if (-not [System.Diagnostics.EventLog]::SourceExists($s))
        {
            if ($PSCmdlet.ShouldProcess("$s event log source '$LogName'", "install"))
            {
                [System.Diagnostics.EventLog]::CreateEventSource($s, $LogName)
            }
        }
    }
}