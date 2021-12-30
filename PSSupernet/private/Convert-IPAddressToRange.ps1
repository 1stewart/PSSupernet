function Convert-IPAddressToRange {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidatePattern('^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$')]
        [string[]]$IPAddress
    )

    BEGIN {
        [array]$Output = @()
    }

    PROCESS {
        foreach ($Range in $IPAddress) {
            [System.Net.IPAddress]$NetworkAddress = ($Range.Split('/'))[0]
            [int]$CIDR= ($Range.Split('/'))[1]

            [array]$NetworkAddressArray = $([System.Net.IPAddress]$NetworkAddress).GetAddressBytes()
            if ([BitConverter]::IsLittleEndian) {
                [Array]::Reverse($NetworkAddressArray)
            }
            [double]$StartAddressBits = [System.BitConverter]::ToUInt32($NetworkAddressArray,0)

            [System.Net.IPAddress]$SubnetMask = (Convert-CIDRToSubnet $CIDR).SubnetMask

            [array]$SubnetMaskArray = $([System.Net.IPAddress]$SubnetMask).GetAddressBytes()
            if ([BitConverter]::IsLittleEndian) {
                [Array]::Reverse($SubnetMaskArray)
            }
            [double]$SubnetMaskBits = [System.BitConverter]::ToUInt32($SubnetMaskArray,0)

            $StartAddressBinary = $StartAddressBits -band $SubnetMaskBits
            [System.Net.IPAddress]$StartAddress = $StartAddressBinary

            [array]$Address = @()
            foreach ($Octect in $(($SubnetMask.IPAddressToString).split('.'))) {
                $Address += 255-$Octect
            }

            [System.Net.IPAddress]$InvertedSubnetMask = $Address -join '.'
            [array]$InvertedSubnetMaskArray = $([System.Net.IPAddress]$InvertedSubnetMask).GetAddressBytes()
            if ([BitConverter]::IsLittleEndian) {
                [Array]::Reverse($InvertedSubnetMaskArray)
            }
            [double]$InvertedSubnetMaskBits = [System.BitConverter]::ToUInt32($InvertedSubnetMaskArray,0)
            [System.Net.IPAddress]$EndAddress = [System.Net.IPAddress]$($StartAddressBinary -bor $InvertedSubnetMaskBits)

            $Output += @("$Range,$StartAddress,$EndAddress")
        }
    }

    END {
        foreach ($Row in $Output) {
            [PSCustomObject]@{
                Network = $($Row -split (','))[0]
                StartAddress = $($Row -split (','))[1]
                EndAddress = $($Row -split (','))[2]
            }
        }
    }

}