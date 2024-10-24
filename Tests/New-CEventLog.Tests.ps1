
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'New-CEventLog.Test'

    function CleanUpEventLog
    {
        [System.Diagnostics.EventLog]::Delete($script:logName)
    }

    function GivenEventSource
    {
        param (
            [String[]] $Source
        )

        foreach ($s in $Source)
        {
            [void] $script:source.Add($s)
        }
    }

    function WhenCreatingEventLog
    {
        New-CEventLog -LogName $script:logName -Source $script:source
    }

    function ThenEventLogIsCreated
    {
        $log = [System.Diagnostics.EventLog]::New($script:logName)
        $log | Should -Not -BeNullOrEmpty
    }

    function ThenEventLogHasSource
    {
        foreach ($s in $script:source)
        {
            [System.Diagnostics.EventLog]::SourceExists($s, $script:logName) | Should -Be $true
        }
    }
}

Describe 'New-CEventLog' {
    BeforeEach {
        $script:source = [System.Collections.ArrayList]::New()
    }

    It 'should create an event log with the given source' {
        GivenEventSource -Source 'Carbon.Windows'
        WhenCreatingEventLog
        ThenEventLogIsCreated
    }

    It 'should create an event log with multiple sources' {
        GivenEventSource -Source 'Carbon.Windows', 'Carbon.Windows.Tests'
        WhenCreatingEventLog
        ThenEventLogIsCreated
    }

    AfterEach {
        CleanUpEventLog
    }
}