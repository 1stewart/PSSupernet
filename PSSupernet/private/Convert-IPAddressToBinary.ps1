function Convert-IPAddressToBinary {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidatePattern('^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\/[0-9]{1,2}|)$')]
        [string[]]$IPAddress
    )

    BEGIN {
        [array]$Output = @()
    }

    PROCESS {
        foreach ($IP in $IPAddress) {
            # trim CIDR
            if ($IP -match '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$') {
                $IP = $($IP -split '/')[0]
            }

            [array]$BinaryAddress = @()
            # turn each octect in to binary representation
            foreach ($Octect in $($IP.Split('.'))) {
                [string]$Binary = [convert]::ToString([int32]$Octect,2)
                if ($Binary -notmatch '[0-1]{8}') {
                    # if less than 8 characters, pad to the left with 0s
                    $BinaryAddress += $Binary.PadLeft(8,'0')
                } else {
                    $BinaryAddress += $Binary
                }
            }
            # rejoin octect conversion to output converted address
            $Output += $BinaryAddress -join ''
        }
    }

    END {
        $Output
    }

}