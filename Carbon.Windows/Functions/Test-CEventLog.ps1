
function Test-CEventLog
{
    <#
    .SYNOPSIS
    Tests if an event log exists.

    .DESCRIPTION
    The `Test-CEventLog` function checks to see if an event log exists. It returns `$true` if the event log exists,
    `$false` otherwise.

    .EXAMPLE
    Test-CEventLog -LogName 'TestApp'

    Demonstrates testing if the `TestApp` event log exists.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $LogName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    return [Diagnostics.EventLog]::SourceExists($LogName)
}