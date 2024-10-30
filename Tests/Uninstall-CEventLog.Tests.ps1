
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'Uninstall-CEventLog.Tests'

    function WhenUninstallingEventLog
    {
        Uninstall-CEventLog -LogName $script:logName
    }
}

Describe 'Uninstall-CEventLog' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'should not throw an error when uninstalling an event log that does not exist' {
        { WhenUninstallingEventLog } | Should -Not -Throw
        { WhenUninstallingEventLog } | Should -Not -Throw
    }
}