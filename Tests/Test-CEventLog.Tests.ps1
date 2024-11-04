
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'Test-CEventLog.Tests'
    Uninstall-CEventLog -LogName $script:logName

    function GivenEventLog
    {
        Install-CEventLog -LogName $script:logName -Source 'Carbon.Windows'
    }

    function WhenTestingEventLog
    {
        $script:result = Test-CEventLog -LogName $script:logName
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

    It 'should return false when the event log does not exist' {
        WhenTestingEventLog
        ThenEventLogDoesntExist
    }

    It 'should return true when the event log exists' {
        GivenEventLog
        WhenTestingEventLog
        ThenEventLogExists
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }
}