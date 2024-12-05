
function Test-CEventLog
{
    <#
    .SYNOPSIS
    Tests if an event log exists.

    .DESCRIPTION
    The `Test-CEventLog` function checks to see if an event log or event source exists. Use the `LogName` parameter to
    test if an event log exists. Use the `Source` parameter to test if an event source exists.

    .EXAMPLE
    Test-CEventLog -LogName 'TestApp'

    Demonstrates testing if the `TestApp` event log exists.

    .EXAMPLE
    Test-CEventLog -Source 'TestLog'

    Demonstrate testing if the `TestLog` event source exists.
    #>
    [CmdletBinding(DefaultParameterSetName='LogName')]
    param(
        [Parameter(Mandatory, ParameterSetName='LogName')]
        [String] $LogName,

        [Parameter(Mandatory, ParameterSetName='Source')]
        [String] $Source
    )

    #Requires -RunAsAdministrator
    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($LogName)
    {
        return [Diagnostics.EventLog]::Exists($LogName)
    }
    return [Diagnostics.EventLog]::SourceExists($Source)
}