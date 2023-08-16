
function Get-CBackConnectionHostName
{
    <#
    .SYNOPSIS
    Gets the back connection hostnames configured for the local computer.

    .DESCRIPTION
    The `Get-CBackConnectionHostName` function gets the current list of configured back connection hostnames.

    .EXAMPLE
    Get-CBackConnectionHostName

    Demonstrates how to get the back connection hostnames.
    #>
    [CmdletBinding()]
    param(
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    return Get-CRegistryKeyValue -Path $script:backConnHostNamesKeyPath -Name $script:backConnHostNamesValueName
}