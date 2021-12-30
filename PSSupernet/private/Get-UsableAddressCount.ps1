function Get-UsableAddressCount {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidatePattern('^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(|\/[0-9]{1,2})$')]
        [string[]]$IPRange
    )

    BEGIN {
        # set to null as during testing this'd randomly be an object
        $Output = $null
    }

    PROCESS {
        foreach ($IP in $($IPRange | Select-Object -Unique)) {
            [int]$NetworkSuffix = ($IP.Split('/'))[1]

            if ($NetworkSuffix -gt 32) {
                throw "Invalid CIDR [{0}]" -f $NetworkSuffix
            }

            [int]$HostBits = $(32 - $NetworkSuffix)
            if ($NetworkSuffix -eq 32 -or $NetworkSuffix -eq 31) {
                # 32 is a single address
                # 31 special use case https://datatracker.ietf.org/doc/html/rfc3021
                [int]$Output += [int]([System.Math]::Pow(2, $HostBits))
            } else {
                # Everything else has a reserved network address + broadcast address
                [int]$Output += [int]([System.Math]::Pow(2, $HostBits)) - 2
            }

        }
    }

    END {
        $Output
    }
}