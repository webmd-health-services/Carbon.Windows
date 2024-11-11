
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    Uninstall-CEventLog -LogName $script:logName

    function WhenCreatingEventLog
    {
        param(
            [Parameter(Mandatory)]
            [String[]] $WithSource
        )
        New-CEventLog -LogName $script:logName -Source $WithSource -ErrorAction 'SilentlyContinue'
    }

    function ThenEventLogIsCreated
    {
        $log = [Diagnostics.EventLog]::New($script:logName)
        $log | Should -Not -BeNullOrEmpty
    }

    function ThenEventLogHasSource
    {
        param(
            [Parameter(Mandatory)]
            [String[]] $WithSource
        )
        foreach ($source in $WithSource)
        {
            [Diagnostics.EventLog]::SourceExists($source, $script:logName) | Should -Be $true
        }
    }

    function ThenError
    {
        $Global:Error[0].Exception.Message | Should -Match 'The source exists'
    }
}

Describe 'New-CEventLog' {
    BeforeEach {
        $script:logName = 'New-CEventLog.Test'
        $script:source = [Collections.ArrayList]::New()
        $Global:Error.Clear()
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }

    It 'should create an event log with the given source' {
        WhenCreatingEventLog -WithSource 'Carbon.Windows'
        ThenEventLogIsCreated -WithSource 'Carbon.Windows'
    }

    It 'should create an event log with multiple sources' {
        WhenCreatingEventLog -WithSource 'Carbon.Windows', 'Carbon.Windows.Tests'
        ThenEventLogIsCreated -WithSource 'Carbon.Windows', 'Carbon.Windows.Tests'
    }

    It 'should throw an error when creating an event log with an existing source' {
        GivenEventSource -Source 'Carbon.Windows'
        WhenCreatingEventLog -WithSource 'Carbon.Windows'
        WhenCreatingEventLog -WithSource 'Carbon.Windows'
    }
}