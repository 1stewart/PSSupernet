function Convert-BinaryIPAddressToNetwork {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[0-1]{32}$')]
        [string[]]$BinaryIPAddress,
        [Parameter(Mandatory)]
        [ValidateScript({$_ -gt 0 -and $_ -lt 33})]
        [int]$Difference
    )

    [array]$NetworkBits = $BinaryIPAddress.Substring(0, $Difference) | Sort-Object -Unique

    if ($NetworkBits.Count -gt 1) {
        throw "An error has occurred, the network bits [{0}] are not the same" -f $($NetworkBits.Substring(0, $Difference))
    }

    [array]$HostBits = $BinaryIPAddress.Substring($Difference, (32 - $Difference))
    [string]$IPBinary = $NetworkBits.PadRight(32,'0')
    Write-Output "$(([System.Net.IPAddress]`"$([System.Convert]::ToInt64($($IPBinary),2))`").IPAddressToString)/$((Get-NewSubnetMask -NetworkBits $HostBits).CIDR)"

}