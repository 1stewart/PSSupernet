function Get-NewSubnetMask {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidatePattern('^[0-1]{1,32}$')]
        [string[]]$NetworkBits
    )

    BEGIN {
        [array]$Output = @()
        if ($NetworkBits.Count -eq 1) {
            throw "Only one value provided, expected an array"
        }
    }

    PROCESS {
        for ([int]$y = 0; $y -lt ($NetworkBits[0].Length); $y++) {
            # check X character on each row in the array, if they differ, set to 1
            if ($($NetworkBits.Substring($y,1) | Sort-Object -Unique).Count -gt 1) {
                $Output += 0
            } else {
                # if the values in each row are the same, set to that value (0 or 1)
                $Output += $NetworkBits.Substring($y,1) | Sort-Object -Unique
            }
        }

        # pad out to 32 characters with the character 1
        [string]$IPBinary = ($Output -join '').PadLeft(32,'1')
    }

    END {
        [PSCustomObject]@{
            CIDR = ($IPBinary.ToCharArray() | Select-String 1).Count
            Mask = ([System.Net.IPAddress]"$([System.Convert]::ToInt64($($IPBinary),2))").IPAddressToString
        }
    }

}