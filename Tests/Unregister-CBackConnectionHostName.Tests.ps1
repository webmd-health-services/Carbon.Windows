
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function New-TestHostName
    {
        return "$([IO.Path]::GetRandomFileName()).unregister-cbackconnectionhostname"
    }

    function ThenUnregistered
    {
        param(
            [String[]] $HostName
        )

        Get-CBackConnectionHostName | Should -Not -Contain $HostName
    }

    function WhenUnregistering
    {
        param(
            [String] $HostName
        )

        Unregister-CBackConnectionHostName -HostName $HostName
    }
}

Describe 'Register-CBackConnectionHostName' {
    BeforeEach {
        $Global:Error.Clear()
        [String[]] $script:currentHostNames = Get-CBackConnectionHostName
        $script:hostname = New-TestHostName
        $script:hostname | Register-CBackConnectionHostName
    }

    AfterEach {
        Set-CRegistryKeyValue -Path $BackConnectionHostNameKeyPath `
                              -Name $BackConnectionHostNameValueName `
                              -Strings $script:currentHostNames
    }

    It 'removes hostname' {
        WhenUnregistering $script:hostname
        ThenUnregistered $script:hostname
    }

    It 'accepts pipeline input' {
        $hostname2 = New-TestHostName
        $hostname3 = New-TestHostName
        $script:hostname, $hostname2, $hostname3 | Register-CBackConnectionHostName
        $script:hostname, $hostname2, $hostname3 | Unregister-CBackConnectionHostName
        ThenUnregistered $script:hostname, $hostname2, $hostname3
    }

    It 'handles non-existent registry value' {
        Remove-CRegistryKeyValue -Path $BackConnectionHostNameKeyPath -Name $BackConnectionHostNameValueName
        WhenUnregistering $script:hostname
        ThenBackConnectionHostName -Is @()
        ThenError -IsEmpty
    }

    It 'only sets registry value if changed' {
        WhenUnregistering $script:hostname
        ThenUnregistered $script:hostname
        Mock -CommandName 'Set-CRegistryKeyValue' -ModuleName 'Carbon.Windows'
        WhenUnregistering $script:hostname
        Should -Not -Invoke 'Set-CRegistryKeyValue' -ModuleName 'Carbon.Windows'
    }
}
