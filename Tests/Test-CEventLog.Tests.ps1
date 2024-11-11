
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    Uninstall-CEventLog -LogName 'Test-CEventLog.Test'

    function GivenEventLog
    {
        param(
            [String] $WithLogName,
            [String] $WithSource
        )
        Install-CEventLog -LogName $WithLogName -Source $WithSource
    }

    function WhenTestingEventLog
    {
        param(
            [String] $WithLogName
        )
        $script:result = Test-CEventLog -LogName $WithLogName
    }

    function ThenEventLogExists
    {
        $script:result | Should -Be $true
    }

    function ThenEventLogDoesntExist
    {
        $script:result | Should -Be $false
    }
}

Describe 'Test-CEventLog' {
    BeforeEach {
        $script:result = $null
    }

    AfterEach {
        Uninstall-CEventLog -LogName 'Test-CEventLog.Test'
    }

    It 'should return false when the event log does not exist' {
        WhenTestingEventLog -WithLogName 'Test-CEventLog.Test'
        ThenEventLogDoesntExist
    }

    It 'should return true when the event log exists' {
        GivenEventLog -WithLogName 'Test-CEventLog.Test' -WithSource 'Carbon.Windows'
        WhenTestingEventLog -WithLogName 'Test-CEventLog.Test'
        ThenEventLogExists
    }
}