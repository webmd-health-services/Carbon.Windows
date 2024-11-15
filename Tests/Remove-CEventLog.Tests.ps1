
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
            [String] $WithLogName,
            [String] $WithSource
        )
        $params = @{}

        if ($WithLogName)
        {
            $params['LogName'] = $WithLogName
        }

        if ($WithSource)
        {
            $params['Source'] = $WithSource
        }

        Remove-CEventLog @params -ErrorAction 'Stop'
    }

    function ThenEventLogRemoved
    {
        param(
            [String] $WithLogName
        )
        [Diagnostics.EventLog]::GetEventLogs().LogDisplayName | Should -Not -Contain $WithLogName
    }

    function ThenEventSourceRemoved
    {
        param(
            [String] $WithSource
        )

        Test-CEventLog -Source $WithSource | Should -Be $false
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
        GivenEventLog -WithLogName 'Remove-CEventLog.Test' -WithSource 'Carbon.Windows'
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog.Test' } | Should -Not -Throw
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog.Test' } | Should -Throw '*does not exist.'
    }

    It 'should only remove an event source' {
        GivenEventLog -WithLogName 'Remove-CEventLog.Test' -WithSource 'Carbon.Windows'
        WhenRemovingEventLog -WithSource 'Carbon.Windows'
        ThenEventSourceRemoved -WithSource 'Carbon.Windows'
    }

    It 'should error if an event source doesn''t exist' {
        GivenEventLog -WithLogName 'Remove-CEventLog.Test' -WithSource 'Carbon.Windows'
        { WhenRemovingEventLog -WithSource 'Carbon.Windows' } | Should -Not -Throw
        ThenEventSourceRemoved -WithSource 'Carbon.Windows'
        { WhenRemovingEventLog -WithSource 'Carbon.Windows' } | Should -Throw '*does not exist.'
    }
}