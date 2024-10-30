
#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:logName = 'New-CEventLog.Test'

    Uninstall-CEventLog -LogName $script:logName

    function GivenEventLog
    {
        Install-CEventLog -LogName $script:logName -Source 'Carbon.Windows'
    }

    function WhenRemovingEventLog
    {
        Remove-CEventLog -LogName $script:logName
    }

    function ThenError
    {
        $Global:Error[0].Exception.Message | Should -Match 'does not exist.'
    }

    function ThenEventLogRemoved
    {
        [Diagnostics.EventLog]::GetEventLogs().LogDisplayName | Should -Not -Contain $script:logName
    }
}

Describe 'Remove-CEventLog' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'should remove event log' {
        GivenEventLog
        WhenRemovingEventLog
        ThenEventLogRemoved
    }

    It 'should error when event log does not exist' {
        WhenRemovingEventLog
        ThenError
    }
}