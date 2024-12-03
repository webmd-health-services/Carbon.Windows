
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function GivenEventLog
    {
        param(
            [String] $WithLogName,
            [String] $WithSource
        )

        Install-CEventLog -LogName $WithLogName -Source $WithSource
    }

    function WhenUninstallingEventLog
    {
        param(
            [String] $LogName
        )

        $script:logName = $LogName
        Uninstall-CEventLog -LogName $LogName
    }

    function ThenEventLogDoesntExist
    {
        param(
            [String] $WithLogName
        )

        Get-CEventLog -List |
            Select-Object -ExpandProperty 'Log' |
            Should -Not -Contain $WithLogName
    }
}

Describe 'Uninstall-CEventLog' {
    BeforeEach {
        $Global:Error.Clear()
        $script:logName = ''
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }

    It 'should not throw an error when uninstalling an event log that does not exist' {
        { WhenUninstallingEventLog -LogName 'Uninstall-CEventLog.Tests' } | Should -Not -Throw
        { WhenUninstallingEventLog -LogName 'Uninstall-CEventLog.Tests' } | Should -Not -Throw
    }

    It 'should remove an existing event log' {
        GivenEventLog -WithLogName 'Uninstall-CEventLog.Tests' -WithSource 'Uninstall-CEventLog.Tests'
        WhenUninstallingEventLog -LogName 'Uninstall-CEventLog.Tests'
        ThenEventLogDoesntExist -WithLogName 'Uninstall-CEventLog.Tests'
    }
}