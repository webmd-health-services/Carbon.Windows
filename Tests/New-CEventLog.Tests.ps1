
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    Uninstall-CEventLog -LogName 'New-CEventLog.Test'

    function WhenCreatingEventLog
    {
        param(
            [Parameter(Mandatory)]
            [String[]] $WithSource,

            [Parameter(Mandatory)]
            [String] $WithLogName
        )

        New-CEventLog -LogName $WithLogName -Source $WithSource -ErrorAction 'Stop'
    }

    function ThenEventLogIsCreated
    {
        param(
            [Parameter(Mandatory)]
            [String] $WithLogName
        )

        $log = [Diagnostics.EventLog]::New($WithLogName)
        $log | Should -Not -BeNullOrEmpty
    }

    function ThenSourceExists
    {
        param(
            [Parameter(Mandatory)]
            [String[]] $WithSource
        )

        foreach ($source in $WithSource)
        {
            [Diagnostics.EventLog]::SourceExists($source) | Should -Be $true
        }
    }
}

Describe 'New-CEventLog' {
    BeforeEach {
        $Global:Error.Clear()
    }

    AfterEach {
        Uninstall-CEventLog -LogName 'New-CEventLog.Test'
    }

    It 'should create an event log with the given source' {
        WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows'
        ThenEventLogIsCreated -WithLogName 'New-CEventLog.Test'
        ThenSourceExists -WithSource 'Carbon.Windows'
    }

    It 'should create an event log with multiple sources' {
        WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows', 'Carbon.Windows.Tests'
        ThenEventLogIsCreated -WithLogName 'New-CEventLog.Test'
        ThenSourceExists -WithSource 'Carbon.Windows', 'Carbon.Windows.Tests'
    }

    It 'should throw an error when creating an event log with an existing source' {
        { WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows' } | Should -Not -Throw
        { WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows' } | Should -Throw '*exists*'
    }

    It 'should not throw when registering multiple sources' {
        { WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows' } | Should -Not -Throw
        { WhenCreatingEventLog -WithLogName 'New-CEventLog.Test' -WithSource 'Carbon.Windows.Tests' } | Should -Not -Throw
    }
}