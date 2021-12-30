function Split-SequentialIPRange {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateScript({Confirm-RangeObject $_})]
        [object]$IPRange,
        [bool]$KeepInvalid = $true
    )

    BEGIN {
        # set first row of array as initial entry, for comparison purposes backwards
        [hashtable]$Output = @{0 = @($IPRange[0].Network)}
    }

    PROCESS {
        [int]$z = 0
        for ([int]$i = 1; $i -lt $IPRange.Count; $i++) {
            [int]$LastOctect = $($IPRange[$i].EndAddress).split('.')[-1]
            if ($(
                # if our last octect is 255, the next sequential octect would be (+1.)0, not 256
                if ($LastOctect -eq 255) {
                    # does our current IP range's second-to-last octect-1 equal the previous IP range's second-to-last octect
                    [int]$($IPRange[$i].StartAddress).split('.')[-2] - 1 -eq [int]$($IPRange[$i-1].EndAddress).split('.')[-2]
                } else {
                    # does our current IP range's first octect equal the previous IP range's last octect+1
                    [int]$($IPRange[$i].StartAddress).split('.')[-1] -eq [int]$($IPRange[$i-1].EndAddress).split('.')[-1] + 1
                }) -eq $true
            ) {
                # if the condition is met, either add to the existing range at the index
                if ($null -ne $output[$z]) {
                    $Output[$z] += @($IPRange[$i].Network)
                } else {
                    # or create a new index with the range at $z
                    $Output += @{$z = @($IPRange[$i].Network)}
                }
            } else {
                # if the condition isn't met, increment the index by 1 and start a new index with the network range
                $z++
                $Output[$z] += @($IPRange[$i].Network)
            }
        }
    }

    END {
        foreach ($Row in $Output.GetEnumerator()) {
            if ($Row.Value.Count -lt 2 -and $KeepInvalid -eq $false) {
                Write-Verbose "Dropping Row [$($Row.Value)] as count is only 1"
            } elseif ($Row.Value.Count -lt 2 -and $KeepInvalid -eq $true) {
                [PSCustomObject]@{
                    Collection = '-1'
                    Ranges = $Row.Value
                }
            } else {
                [PSCustomObject]@{
                    Collection = $Row.Name
                    Ranges = $Row.Value
                }
            }
        }
   }

}