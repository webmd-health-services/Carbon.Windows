
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function WhenInstallingCEventLog
    {
        param(
            [String] $LogName
        )

        $script:logName = $LogName
        Install-CEventLog -LogName 'Install-CEventLog.Tests' -Source 'Install-CEventLog.Tests'
    }
}

Describe 'Install-CEventLog' {
    BeforeEach {
        $script:logName = ''
    }

    AfterEach {
        Uninstall-CEventLog -LogName $script:logName
    }

    It 'should not throw an error when installing an event log that already exists' {
        { WhenInstallingCEventLog -LogName 'Install-CEventLog.Tests' } | Should -Not -Throw
        { WhenInstallingCEventLog -LogName 'Install-CEventLog.Tests' } | Should -Not -Throw
    }
}