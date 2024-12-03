
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

        $script:logName = $WithLogName
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
        $script:logName = ''
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }

    It 'should create an event log with the given source' {
        WhenCreatingEventLog -WithLogName 'New-CEventLog1.Test' -WithSource 'Carbon.Windows1'
        ThenEventLogIsCreated -WithLogName 'New-CEventLog1.Test'
        ThenSourceExists -WithSource 'Carbon.Windows1'
    }

    It 'should create an event log with multiple sources' {
        WhenCreatingEventLog -WithLogName 'New-CEventLog2.Test' -WithSource 'Carbon.Windows2', 'Carbon.Windows.Tests2'
        ThenEventLogIsCreated -WithLogName 'New-CEventLog2.Test'
        ThenSourceExists -WithSource 'Carbon.Windows2', 'Carbon.Windows.Tests2'
    }

    It 'should throw an error when creating an event log with an existing source' {
        { WhenCreatingEventLog -WithLogName 'New-CEventLog3.Test' -WithSource 'Carbon.Windows3' } | Should -Not -Throw
        { WhenCreatingEventLog -WithLogName 'New-CEventLog3.Test' -WithSource 'Carbon.Windows3' } | Should -Throw '*exists*'
    }

    It 'should not throw when registering multiple sources' {
        { WhenCreatingEventLog -WithLogName 'New-CEventLog4.Test' -WithSource 'Carbon.Windows4' } | Should -Not -Throw
        { WhenCreatingEventLog -WithLogName 'New-CEventLog4.Test' -WithSource 'Carbon.Windows.Tests4' } | Should -Not -Throw
        ThenEventLogIsCreated -WithLogName 'New-CEventLog4.Test'
        ThenSourceExists -WithSource 'Carbon.Windows4', 'Carbon.Windows.Tests4'
    }
}