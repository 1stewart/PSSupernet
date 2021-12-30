function ConvertTo-Supernet {
    <#
    .SYNOPSIS
        Convert subnets to supernet(s)
    .DESCRIPTION
        Convert subnets to supernet(s), including ordering them sequentially and identifying where
          you may be exposing an unwanted amount of addresses by swapping
    .PARAMETER IPAddress
        An array of IP addresses (including CIDRs) to calculate supernets for
    .PARAMETER Tolerance
        An optional integer to specify how many extra IP addresses you'd accept when converting from
          subnets to supernets.
    .PARAMETER KeepInvalid
        An optional boolean for whether non-sequential or non-supernettable IP addresses will be kept
          in an index. Useful if you need to re-merge the lists afterwards.
    .INPUTS
        Supports pipeline input
    .OUTPUTS
        System.Object. A custom object with a list of subnets, the supernet, a differential count, and
          whether the tolerance count makes it suitable or not
    .EXAMPLE
        ConvertTo-Supernet.ps1 -IPAddress @('192.168.1.0/24','192.168.2.0/24', '192.168.3.0/24')
    .EXAMPLE
        ConvertTo-Supernet.ps1 -IPAddress @('192.168.1.0/24','192.168.2.0/24', '192.168.3.0/24') -Tolerance 100
    .EXAMPLE
        @('192.168.1.0/24','192.168.2.0/24', '192.168.3.0/24') | ConvertTo-Supernet.ps1
    .LINK
        https://github.com/1stewart/pssupernet

    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$IPAddress,
        [int]$Tolerance = -1,
        [boolean]$KeepInvalid = $true,
        [AllowEmptyString()]
        [ValidateSet('Human','none','JSON')]
        [string]$Format = 'none'
    )

    BEGIN {
        [array]$Output = @()
        # Remove duplicates, and sort IPs (since they include CIDRs, order on IP only)
        [string[]]$IPAddress = $IPAddress | Select-Object -Unique | Sort-Object {$_.Split('/')[0] -as [version]}
        # Separate IP addresses in to sequential collections
        [object]$RangeTable = Convert-IPAddressToRange -IPAddress $IPAddress
        [object]$IPRanges = Split-SequentialIPRange -IPRange $RangeTable
    }

    PROCESS {
        foreach ($Collection in $IPRanges) {
            if ($Collection.Collection -ne -1) {
                # Convert to array of binary
                [array]$BinaryIPAddresses = Convert-IPAddressToBinary -IPAddress $Collection.Ranges
                # Identify first bit that is different in addresses
                [int]$Difference = Get-HostAddressDifference -BinaryIPAddress $BinaryIPAddresses

                [string]$Supernet = Convert-BinaryIPAddressToNetwork -BinaryIPAddress $BinaryIPAddresses -Difference $Difference

                # Get difference in usable addresses between combined subnets and supernet
                [int]$CollectionUsableAddresses = Get-UsableAddressCount -IPRange $Collection.Ranges
                [int]$SupernetUsableAddresses = Get-UsableAddressCount -IPRange $Supernet
                [int]$Differential = $SupernetUsableAddresses - $CollectionUsableAddresses

                # Figure out if we care about tolerance, or if the difference is too high for our parameter
                if ($Tolerance -ne -1 -and $Differential -gt $Tolerance) {
                    $Output += @("$($Collection.Ranges -join ',')|$Supernet|$Differential|NO")
                } elseif ($Tolerance -eq -1 -or $Differential -lt $Tolerance) {
                    $Output += @("$($Collection.Ranges -join ',')|$Supernet|$Differential|YES")
                }
            }
        }
        if ($KeepInvalid -eq $true) {
            [array]$InvalidIPAddresses = (($IPRanges | Where-Object {$_.Collection -eq -1}).Ranges -join ',')
            if ($InvalidIPAddresses.Count -gt 0) {
                # this is all the IPs that can't be supernetted, for if you need to merge supernetted + original input
                $Output += @("$($InvalidIPAddresses)|$null|0|$null")
            }
        }
    }

    END {
        $BaseObject = foreach ($Row in $Output) {
            [PSCustomObject]@{
                Subnets = @($($Row.split('|'))[0])
                Supernet = $($Row.split('|'))[1]
                Differential = $($Row.split('|'))[2]
                Suitable = $($Row.split('|'))[3]
            }
        }
        if ($Format -eq 'Human') {
            # user can control output, but default format-table will be illegible on most screens
            $BaseObject | Format-Table -Property @{Expression = 'Subnets'; Width = 100}, Supernet, Differential, Suitable
        } elseif ($Format -eq 'JSON') {
            $BaseObject | ConvertTo-Json
        } elseif ($null -eq $Format -or $Format -eq 'None') {
            $BaseObject
        }
    }

}