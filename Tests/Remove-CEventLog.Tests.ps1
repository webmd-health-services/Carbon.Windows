
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

    function WhenRemovingEventLog
    {
        param(
            [String] $WithLogName
        )
        Remove-CEventLog -LogName $WithLogName
    }

    function ThenError
    {
        $Global:Error[0].Exception.Message | Should -Match 'does not exist.'
    }

    function ThenEventLogRemoved
    {
        param(
            [String] $WithLogName
        )
        [Diagnostics.EventLog]::GetEventLogs().LogDisplayName | Should -Not -Contain $WithLogName
    }
}

Describe 'Remove-CEventLog' {
    BeforeEach {
        $Global:Error.Clear()
        Uninstall-CEventLog -LogName 'Remove-CEventLog.Test'
    }

    It 'should remove event log' {
        GivenEventLog -WithLogName 'Remove-CEventLog.Test' -WithSource 'Carbon.Windows'
        WhenRemovingEventLog -WithLogName 'Remove-CEventLog.Test'
        ThenEventLogRemoved -WithLogName 'Remove-CEventLog.Test'
    }

    It 'should error when event log does not exist' {
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog.Test' } | Should -Not -Throw
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog.Test' } | Should -Throw '*does not exist.'
    }
}