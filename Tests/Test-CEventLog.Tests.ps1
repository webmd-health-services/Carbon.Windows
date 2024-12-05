
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
            [String] $WithLogName,
            [String] $WithSource
        )

        if ($WithLogName)
        {
            $script:result = Test-CEventLog -LogName $WithLogName
            $script:logName = $WithLogName
            return
        }
        $script:result = Test-CEventLog -Source $WithSource
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
        $script:logName = ''
    }

    AfterEach {
        if ($script:logName)
        {
            Uninstall-CEventLog -LogName $script:logName
        }
    }

    It 'should return false when the event log does not exist' {
        WhenTestingEventLog -WithLogName 'Test-CEventLog1.Test'
        ThenEventLogDoesntExist
    }

    It 'should return true when the event log exists' {
        GivenEventLog -WithLogName 'Test-CEventLog2.Test' -WithSource 'Carbon.Windows2'
        WhenTestingEventLog -WithLogName 'Test-CEventLog2.Test'
        ThenEventLogExists
    }

    It 'should return true if the event source exists' {
        GivenEventLog -WithLogName 'Test-CEventLog3.Test' -WithSource 'Carbon.Windows3'
        WhenTestingEventLog -WithLogName 'Test-CEventLog3.Test'
        ThenEventLogExists
        WhenTestingEventLog -WithSource 'Carbon.Windows3'
        ThenEventLogExists
    }

    It 'should return false if the event source does not exist' {
        GivenEventLog -WithLogName 'Test-CEventLog4.Test' -WithSource 'Carbon.Windows4'
        WhenTestingEventLog -WithLogName 'Test-CEventLog4.Test'
        ThenEventLogExists
        WhenTestingEventLog -WithSource 'Carbon.Windows4'
        ThenEventLogExists
        WhenTestingEventLog -WithSource 'Carbon.Windows4.NonExistent'
        ThenEventLogDoesntExist
    }
}