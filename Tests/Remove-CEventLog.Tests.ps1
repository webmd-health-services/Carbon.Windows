
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

        $script:logName = $WithLogName
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
            $script:logName = $WithLogName
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
        $script:logName = ''
    }

    AfterEach {
        if ($script:logName)
        {
            Uninstall-CEventLog -LogName $script:logName
        }
    }

    It 'should remove event log' {
        GivenEventLog -WithLogName 'Remove-CEventLog1.Test' -WithSource 'Carbon.Windows1'
        WhenRemovingEventLog -WithLogName 'Remove-CEventLog1.Test'
        ThenEventLogRemoved -WithLogName 'Remove-CEventLog1.Test'
    }

    It 'should error when event log does not exist' {
        GivenEventLog -WithLogName 'Remove-CEventLog2.Test' -WithSource 'Carbon.Windows2'
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog2.Test' } | Should -Not -Throw
        { WhenRemovingEventLog -WithLogName 'Remove-CEventLog2.Test' } | Should -Throw '*does not exist.'
    }

    It 'should only remove an event source' {
        GivenEventLog -WithLogName 'Remove-CEventLog3.Test' -WithSource 'Carbon.Windows3'
        WhenRemovingEventLog -WithSource 'Carbon.Windows3'
        ThenEventSourceRemoved -WithSource 'Carbon.Windows3'
    }

    It 'should error if an event source doesn''t exist' {
        GivenEventLog -WithLogName 'Remove-CEventLog4.Test' -WithSource 'Carbon.Windows4'
        { WhenRemovingEventLog -WithSource 'Carbon.Windows4' } | Should -Not -Throw
        ThenEventSourceRemoved -WithSource 'Carbon.Windows4'
        { WhenRemovingEventLog -WithSource 'Carbon.Windows4' } | Should -Throw '*does not exist.'
    }
}