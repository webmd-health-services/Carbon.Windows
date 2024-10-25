
function Get-CEventLog
{
    <#
    .SYNOPSIS
    Gets logs from Windows Event Viewer.

    .DESCRIPTION
    The `Get-CEventLog` function gets logs from the Windows Event Viewer. It is meant to be a drop-in replacement for
    the depricated `Get-EventLog` cmdlet. Use the `List` parameter to list all of the available event logs. Use the
    `LogName` parameter to get all of the available event log entries in a specific log.

    The `Newest` parameter can be used to get the latest logs. The `EntryType` parameter can be used to filter by the
    type of log entry. The `Message` parameter can be used to filter by the message of the log entry by matching the
    text within the log.

    .EXAMPLE
    Get-CEventLog -List

    Demonstrates listing all of the available Windows Event Logs.

    .EXAMPLE
    Get-CEventLog -LogName 'Application'

    Demonstrates getting all of the available event logs in the 'Application' log.

    .EXAMPLE
    Get-CEventLog -LogName 'System' -Newest 5

    Demonstrates getting the latest 5 logs from the 'System' event logs.

    .EXAMPLE
    Get-CEventLog -LogName 'Security' -EntryType 'Error' -Message '*SQL*'

    Demonstrates getting the event logs from the 'Security' log that have are of type 'Error' and contain 'SQL' in the
    message.
    #>
    [CmdletBinding(DefaultParameterSetName='list')]
    param(
        # List all event log categories.
        [Parameter(Mandatory, ParameterSetName='list')]
        [switch] $List,

        # The name of the log to view.
        [Parameter(Mandatory, ParameterSetName='logs')]
        [String] $LogName,

        # The number of latest logs to return.
        [Parameter(ParameterSetName='logs')]
        [int] $Newest,

        # The entry type to filter for.
        [Parameter(ParameterSetName='logs')]
        [System.Diagnostics.EventLogEntryType] $EntryType,

        # The message to filter for.
        [Parameter(ParameterSetName='logs')]
        [String] $Message
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($List)
    {
        return [System.Diagnostics.EventLog]::GetEventLogs()
    }

    if ($LogName)
    {
        $log = [System.Diagnostics.EventLog]::New($LogName)

        $entries = $log.Entries

        if ($EntryType)
        {
            $entries = $entries | Where-Object EntryType -Like $EntryType
        }

        if ($Message)
        {
            $entries = $entries | Where-Object Message -Like $Message
        }

        if ($Newest)
        {
            $entries = $entries | Select-Object -Last $Newest
        }

        return $entries
    }
}