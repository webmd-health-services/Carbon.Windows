
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'New-CEventLog.Test'

    Uninstall-CEventLog -LogName $script:logName

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
        New-CEventLog -LogName $script:logName -Source $script:source -ErrorAction 'SilentlyContinue'
    }

    function ThenEventLogIsCreated
    {
        $log = [Diagnostics.EventLog]::New($script:logName)
        $log | Should -Not -BeNullOrEmpty
    }

    function ThenEventLogHasSource
    {
        foreach ($s in $script:source)
        {
            [Diagnostics.EventLog]::SourceExists($s, $script:logName) | Should -Be $true
        }
    }

    function ThenError
    {
        $Global:Error[0].Exception.Message | Should -Match 'The source exists'
    }
}

Describe 'New-CEventLog' {
    BeforeEach {
        $script:source = [Collections.ArrayList]::New()
        $Global:Error.Clear()
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

    It 'should throw an error when creating an event log with an existing source' {
        GivenEventSource -Source 'Carbon.Windows'
        WhenCreatingEventLog
        WhenCreatingEventLog
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }
}