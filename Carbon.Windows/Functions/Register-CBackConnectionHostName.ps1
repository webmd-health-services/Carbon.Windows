
function Register-CBackConnectionHostName
{
    <#
    .SYNOPSIS
    Adds hostnames to the back connection hostname list.

    .DESCRIPTION
    The `Register-CBackConnectionHostName` function adds a hostname to the list of back connection hostnames. If the
    hostname is already in the list, it does nothing. You can pass a single hostname to the `HostName` parameter or pipe
    in multiple hostnames.

    .EXAMPLE
    Register-CBackConnectionHostName -HostName 'example.com'

    Demonstrates how to add an item to the back connection hostnames list by passing a single hostname to the `HostName`
    parameter.

    .EXAMPLE
    'example.com', 'example2.com' | Register-CBackConnectionHostName

    Demonstrates how to add multiple hostnames to the back connction hostnames list by pipeling them to the
    `Register-CBackConnectionHostName` function.
    #>
    [CmdletBinding()]
    param(
        # The hostname to add to the list.
        [Parameter(Mandatory, ValueFromPipeline)]
        [String] $HostName
    )

    begin
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

        [String[]] $curHostNames = Get-CBackConnectionHostName
        $hostnamesToAdd = [Collections.Generic.List[String]]::New()
    }

    process
    {

        if ($curHostNames -contains $HostName)
        {
            return
        }

        [void]$hostnamesToAdd.Add($HostName)
    }

    end
    {
        if ($hostnamesToAdd.Count -eq 0)
        {
            return
        }

        $newValue = & {
            if ($curHostNames)
            {
                $curHostNames | Write-Output
            }
            $hostnamesToAdd | Select-Object -Unique | Write-Output
        }

        Set-CRegistryKeyValue -Path $script:backConnHostNamesKeyPath `
                              -Name $script:backConnHostNamesValueName `
                              -Strings $newValue
    }
}