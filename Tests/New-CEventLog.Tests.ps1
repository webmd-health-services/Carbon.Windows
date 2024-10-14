
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'New-CEventLog' {
    BeforeEach {
    }

    # It 'should mock SourceExists' {
    #     $DebugPreference = 'Continue'
    #     Mock -CommandName 'Get-Log' -ModuleName 'Carbon.Windows' -MockWith {
    #         Write-Debug 'This is being mocked'
    #     }.GetNewClosure()
    #     $DebugPreference = 'SilentlyContinue'
    #     Get-CEventLog -List
    # }
}