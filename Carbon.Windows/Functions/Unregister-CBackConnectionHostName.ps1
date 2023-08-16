
function Unregister-CBackConnectionHostName
{
    <#
    .SYNOPSIS
    Removes hostnames from the back connection hostname list.

    .DESCRIPTION
    The `Unregister-CBackConnectionHostName` function removes a hostname from the list of back connection hostnames. If
    the hostname is not in the list, it does nothing. You can pass a single hostname to the `HostName` parameter or pipe
    in multiple hostnames.

    .EXAMPLE
    Unregister-CBackConnectionHostName -HostName 'example.com'

    Demonstrates how to remove an item from the back connection hostnames list by passing a single hostname to the
    `HostName` parameter.

    .EXAMPLE
    'example.com', 'example2.com' | Unregister-CBackConnectionHostName

    Demonstrates how to remove multiple hostnames from the back connction hostnames list by pipeling them to the
    `Register-CBackConnectionHostName` function.
    #>
    [CmdletBinding()]
    param(
        # The hostname to remove from the back connection hostname list.
        [Parameter(Mandatory, ValueFromPipeline)]
        [String] $HostName
    )

    begin
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

        $hostnamesToRemove = [Collections.Generic.List[String]]::New()
    }

    process
    {
        [void]$hostnamesToRemove.Add($HostName)
    }

    end
    {
        [String[]] $currentValues = Get-CBackConnectionHostName
        if ($null -eq $currentValues)
        {
            $currentValues = @()
        }

        [String[]] $newValues = $currentValues | Where-Object { $_ -notin $hostnamesToRemove }
        if ($null -eq $newValues)
        {
            $newValues = @()
        }

        if ($newValues.Count -eq $currentValues.Count)
        {
            return
        }

        Set-CRegistryKeyValue -Path $script:backConnHostNamesKeyPath `
                              -Name $script:backConnHostNamesValueName `
                              -Strings $newValues
    }
}