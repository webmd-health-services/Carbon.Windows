
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function GivenEventLog
    {
        param(
            [String] $LogName
        )

        New-CEventLog -LogName $LogName -Source 'Get-CEventLogs.Tests'
        $script:logName = $LogName
    }

    function GivenLogEntry
    {
        param(
            [String] $Message,
            [String] $LogName,
            [Diagnostics.EventLogEntryType] $EntryType = 'Error'
        )

        [Diagnostics.EventLog]::WriteEntry($LogName, $Message, $EntryType)
    }

    function WhenGettingEventLogs
    {
        param(
            [switch] $List,
            [String] $LogName,
            [int] $Newest,
            [Diagnostics.EventLogEntryType] $EntryType,
            [String] $Message
        )

        if ($LogName)
        {
            $script:logName = $LogName
        }

        $script:result = Get-CEventLog @PSBoundParameters
    }

    function ThenEventLogsAreListed
    {
        $script:result | Should -BeOfType 'System.Diagnostics.EventLog'
        $script:result | Should -Not -BeNullOrEmpty
        $script:result.Count | Should -BeGreaterThan 0
    }
}

Describe 'Get-CEventLog' {
    BeforeEach {
        $script:result = $null
        $script:logName = ''
        Start-Sleep -Seconds 1
    }

    AfterEach {
        if ($script:logName)
        {
            Uninstall-CEventLog -LogName $script:logName
        }
    }

    It 'should list event logs' {
        GivenEventLog -LogName 'Get-CEventLogs1.Tests'
        WhenGettingEventLogs -List
        ThenEventLogsAreListed
    }

    It 'should list event logs including the defaults' {
        GivenEventLog -LogName 'Get-CEventLogs2.Tests'
        WhenGettingEventLogs -List
        ThenEventLogsAreListed
        $script:result.Log | Should -Contain 'Get-CEventLogs2.Tests'
    }

    It 'should match event logs by message' {
        GivenEventLog -LogName 'Get-CEventLogs3.Tests'
        foreach ($x in 1..5)
        {
            GivenLogEntry -Message "Test message $x" -LogName 'Get-CEventLogs3.Tests'
        }
        foreach ($x in 1..5)
        {
            GivenLogEntry -Message "This is not a test message $x" -LogName 'Get-CEventLogs3.Tests'
        }
        WhenGettingEventLogs -LogName 'Get-CEventLogs3.Tests' -Message 'Test*'

        $script:result | Should -HaveCount 5
        $script:result | ForEach-Object { $_.Message | Should -Not -Match 'This is not a test message*' }
    }

    It 'should match event logs by entry type' {
        GivenEventLog -LogName 'Get-CEventLogs4.Tests'
        foreach ($x in 1..4)
        {
            GivenLogEntry -Message "Test message $x" -EntryType 'Information' -LogName 'Get-CEventLogs4.Tests'
        }
        foreach ($x in 1..6)
        {
            GivenLogEntry -Message "This is not a test message $x" -EntryType 'Error' -LogName 'Get-CEventLogs4.Tests'
        }

        WhenGettingEventLogs -LogName 'Get-CEventLogs4.Tests' -EntryType 'Information'
        $script:result | Should -HaveCount 4
        $script:result | ForEach-Object { $_.EntryType | Should -Be 'Information' }
    }

    It 'should select the most recent 5 event logs' {
        GivenEventLog -LogName 'Get-CEventLogs5.Tests'
        foreach ($x in 1..10)
        {
            GivenLogEntry -Message "Test message $x" -LogName 'Get-CEventLogs5.Tests'
        }

        foreach ($x in 1..10)
        {
            GivenLogEntry -Message "This is not a test message $x" -LogName 'Get-CEventLogs5.Tests'
        }

        foreach ($x in 1..10)
        {
            GivenLogEntry -Message "These should be returned $x" -LogName 'Get-CEventLogs5.Tests'
        }

        WhenGettingEventLogs -LogName 'Get-CEventLogs5.Tests' -Newest 10
        $script:result | Should -HaveCount 10
        $script:result | ForEach-Object { $_.Message | Should -Match 'These should*' }
    }
}