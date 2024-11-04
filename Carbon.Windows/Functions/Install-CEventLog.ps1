
function Install-CEventLog
{
    <#
    .SYNOPSIS
    Creates an event log.

    .DESCRIPTION
    The `Install-CEventLog` function creates an event log on the local computer. If the event log already exists, this
    function does nothing.

    .EXAMPLE
    Install-CEventLog -LogName 'TestApp' -Source 'TestLog'

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

    if (-not (Test-CEventLog -LogName $LogName))
    {
        New-CEventLog -LogName $LogName -Source $Source
    }
}