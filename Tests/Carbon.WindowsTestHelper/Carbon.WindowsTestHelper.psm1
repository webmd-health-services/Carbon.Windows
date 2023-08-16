
$BackConnectionHostNameKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0'
$BackConnectionHostNameValueName = 'BackConnectionHostNames'

function ThenBackConnectionHostName
{
    param(
        [String[]] $Is
    )

    Get-CBackConnectionHostName | Should -Be $Is
}

function ThenError
{
    param(
        [switch] $IsEmpty
    )

    if ($IsEmpty)
    {
        $Global:Error | Should -BeNullOrEmpty
    }
}

Export-ModuleMember -Variable '*' -Function '*'