
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function New-TestHostName
    {
        return "$([IO.Path]::GetRandomFileName()).register-cbackconnectionhostname"
    }

    function ThenRegistered
    {
        param(
            [String[]] $HostName
        )

        ThenBackConnectionHostName -Is ($script:currentHostNames + $HostName)
    }

    function WhenRegistering
    {
        param(
            [String] $HostName
        )

        Register-CBackConnectionHostName -HostName $HostName
    }
}

Describe 'Register-CBackConnectionHostName' {
    BeforeEach {
        $Global:Error.Clear()
        $script:hostname = New-TestHostName
        [String[]] $script:currentHostNames = Get-CBackConnectionHostName
    }

    AfterEach {
        Set-CRegistryKeyValue -Path $BackConnectionHostNameKeyPath `
                              -Name $BackConnectionHostNameValueName `
                              -Strings $script:currentHostNames
    }

    It 'adds hostname' {
        WhenRegistering $script:hostname
        ThenRegistered $script:hostname
    }

    It 'accepts pipeline input' {
        $hostname2 = New-TestHostName
        $hostname3 = New-TestHostName
        $script:hostname, $hostname2, $hostname3 | Register-CBackConnectionHostName
        ThenRegistered $script:hostname, $hostname2, $hostname3
    }

    It 'handles non-existent registry value' {
        Remove-CRegistryKeyValue -Path $BackConnectionHostNameKeyPath -Name $BAckConnectionHostNameValueName
        WhenRegistering $script:hostname
        ThenBackConnectionHostName -Is $script:hostname
        ThenError -IsEmpty
    }

    It 'only sets registry value if changed' {
        WhenRegistering $script:hostname
        ThenRegistered $script:hostname
        Mock -CommandName 'Set-CRegistryKeyValue' -ModuleName 'Carbon.Windows'
        WhenRegistering $script:hostname
        Should -Not -Invoke 'Set-CRegistryKeyValue' -ModuleName 'Carbon.Windows'
    }
}
