
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'Get-CEventLogs.Tests'

    function GivenEventLog
    {
        New-CEventLog -LogName $script:logName -Source 'Get-CEventLogs.Tests'
    }

    function GivenLogEntry
    {
        param(
            [String] $Message,
            [System.Diagnostics.EventLogEntryType] $EntryType = 'Error'
        )
        [System.Diagnostics.EventLog]::WriteEntry($script:logName, $Message, $EntryType)
    }

    function WhenGettingEventLogs
    {
        param(
            [switch] $List,
            [String] $LogName,
            [int] $Newest,
            [System.Diagnostics.EventLogEntryType] $EntryType,
            [String] $Message
        )

        $script:result = Get-CEventLog @PSBoundParameters
    }

    function ThenEventLogsAreListed
    {
        $script:result | Should -BeOfType 'System.Diagnostics.EventLog'
    }

    function CleanUpEventLog
    {
        [System.Diagnostics.EventLog]::Delete($script:logName)
    }
}

Describe 'Get-CEventLog' {
    BeforeEach {
        $script:result = $null
        Start-Sleep -Seconds 1
    }

    It 'should list event logs' {
        WhenGettingEventLogs -List
        ThenEventLogsAreListed
    }

    It 'should list event logs including the defaults' {
        GivenEventLog
        WhenGettingEventLogs -List
        ThenEventLogsAreListed
        $script:result.Log | Should -Contain $script:logName
        CleanUpEventLog
    }

    It 'should match event logs by message' {
        GivenEventLog
        foreach ($x in 1..5) {
            GivenLogEntry -Message "Test message $x"
        }
        foreach ($x in 1..5) {
            GivenLogEntry -Message "This is not a test message $x"
        }
        WhenGettingEventLogs -LogName $script:logName -Message 'Test*'

        $script:result | Should -HaveCount 5
        $script:result | ForEach-Object { $_.Message | Should -Not -Match 'This is not a test message*' }

        CleanUpEventLog
    }

    It 'should match event logs by entry type' {
        GivenEventLog
        foreach ($x in 1..4) {
            GivenLogEntry -Message "Test message $x" -EntryType 'Information'
        }
        foreach ($x in 1..6) {
            GivenLogEntry -Message "This is not a test message $x" -EntryType 'Error'
        }

        WhenGettingEventLogs -LogName $script:logName -EntryType 'Information'
        $script:result | Should -HaveCount 4
        $script:result | ForEach-Object { $_.EntryType | Should -Be 'Information' }
        CleanUpEventLog
    }

    It 'should select the most recent 5 event logs' {
        GivenEventLog
        foreach ($x in 1..10) {
            GivenLogEntry -Message "Test message $x"
        }

        foreach ($x in 1..10) {
            GivenLogEntry -Message "This is not a test message $x"
        }

        Start-Sleep -Seconds 10
        foreach ($x in 1..10) {
            GivenLogEntry -Message "These should be returned $x"
        }

        WhenGettingEventLogs -LogName $script:logName -Newest 10
        $script:result | Should -HaveCount 10
        $script:result | ForEach-Object { $_.Message | Should -Match 'These should*' }
        CleanUpEventLog
    }
}