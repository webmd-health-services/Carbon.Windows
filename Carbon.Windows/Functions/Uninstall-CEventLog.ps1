
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
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='LogName')]
    param(
        [Parameter(Mandatory, ParameterSetName='LogName')]
        [String[]] $LogName,

        [Parameter(Mandatory, ParameterSetName='Source')]
        [String[]] $Source
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($LogName)
    {
        foreach ($log in $LogName)
        {
            if (Test-CEventLog -LogName $log)
            {
                Remove-CEventLog -LogName $log
            }
        }
        return
    }

    foreach ($s in $source)
    {
        if (Test-CEventLog -Source $s)
        {
            Remove-CEventLog -Source $s
        }
    }
}