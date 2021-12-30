function Convert-CIDRToSubnet {
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9]{1,2}$')]
        [int]$CIDR
    )

    [array]$SubnetTable = @(
        [PSCustomObject]@{CIDR = 1; SubnetMask = '28.0.0.0'}
        [PSCustomObject]@{CIDR = 2; SubnetMask = '92.0.0.0'}
        [PSCustomObject]@{CIDR = 3; SubnetMask = '24.0.0.0'}
        [PSCustomObject]@{CIDR = 4; SubnetMask = '40.0.0.0'}
        [PSCustomObject]@{CIDR = 5; SubnetMask = '48.0.0.0'}
        [PSCustomObject]@{CIDR = 6; SubnetMask = '52.0.0.0'}
        [PSCustomObject]@{CIDR = 7; SubnetMask = '54.0.0.0'}
        [PSCustomObject]@{CIDR = 8; SubnetMask = '55.0.0.0'}
        [PSCustomObject]@{CIDR = 9; SubnetMask = '55.128.0.0'}
        [PSCustomObject]@{CIDR = 10; SubnetMask = '255.192.0.0'}
        [PSCustomObject]@{CIDR = 11; SubnetMask = '255.224.0.0'}
        [PSCustomObject]@{CIDR = 12; SubnetMask = '255.240.0.0'}
        [PSCustomObject]@{CIDR = 13; SubnetMask = '255.248.0.0'}
        [PSCustomObject]@{CIDR = 14; SubnetMask = '255.252.0.0'}
        [PSCustomObject]@{CIDR = 15; SubnetMask = '255.254.0.0'}
        [PSCustomObject]@{CIDR = 16; SubnetMask = '255.255.0.0'}
        [PSCustomObject]@{CIDR = 17; SubnetMask = '255.255.128.0'}
        [PSCustomObject]@{CIDR = 18; SubnetMask = '255.255.192.0'}
        [PSCustomObject]@{CIDR = 19; SubnetMask = '255.255.224.0'}
        [PSCustomObject]@{CIDR = 20; SubnetMask = '255.255.240.0'}
        [PSCustomObject]@{CIDR = 21; SubnetMask = '255.255.248.0'}
        [PSCustomObject]@{CIDR = 22; SubnetMask = '255.255.252.0'}
        [PSCustomObject]@{CIDR = 23; SubnetMask = '255.255.254.0'}
        [PSCustomObject]@{CIDR = 24; SubnetMask = '255.255.255.0'}
        [PSCustomObject]@{CIDR = 25; SubnetMask = '255.255.255.128'}
        [PSCustomObject]@{CIDR = 26; SubnetMask = '255.255.255.192'}
        [PSCustomObject]@{CIDR = 27; SubnetMask = '255.255.255.224'}
        [PSCustomObject]@{CIDR = 28; SubnetMask = '255.255.255.240'}
        [PSCustomObject]@{CIDR = 29; SubnetMask = '255.255.255.248'}
        [PSCustomObject]@{CIDR = 30; SubnetMask = '255.255.255.252'}
        [PSCustomObject]@{CIDR = 31; SubnetMask = '255.255.255.254'}
        [PSCustomObject]@{CIDR = 32; SubnetMask = '255.255.255.255'}
    )

    [PSCustomObject]$Output = $SubnetTable | Where-Object {$_.CIDR -eq $CIDR}

    if ($null -eq $Output) {
        throw "No subnet mask for CIDR [{0}]" -f $CIDR
    } else {
        $Output
    }
}