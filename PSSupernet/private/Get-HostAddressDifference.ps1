function Get-HostAddressDifference {
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[0-1]{32}$')]
        [string[]]$BinaryIPAddress
    )

    BEGIN {
        [array]$Output = @()
        if ($BinaryIPAddress.Count -eq 1) {
            throw "Only one value provided, expected an array"
        }
    }

    PROCESS {
        for ([int]$i = 1; $i -le $BinaryIPAddress.Count; $i++) {
            for ([int]$y = 0; $y -lt ($BinaryIPAddress[$i].Length); $y++) {
                # for each character, compare to character in last row in array
                if (($BinaryIPAddress[$i])[$y] -ne $($BinaryIPAddress[$i-1])[$y]) {
                    # add to array if different
                    $Output += $y
                }
            }
        }
    }

    END {
        if ($null -ne $Output -and $Output.Count -gt 1) {
            # sort character number that is different in all arrays, return earliest
            ($Output | Sort-Object)[0]
        } else {
            $Output
        }
    }

}