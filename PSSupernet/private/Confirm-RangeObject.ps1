function Confirm-RangeObject {
    param (
        [Parameter(Mandatory)]
        [object]$RangeObject
    )

    [array]$RequiredProperties = @('Network','StartAddress','EndAddress')

    if ($null -ne $(Compare-Object ($RangeObject | Get-Member -MemberType NoteProperty).Name $RequiredProperties)) {
        throw "Unexpected property in object"
    }

    foreach ($Property in $RequiredProperties) {
        if ($null -eq $RangeObject.$($Property)) {
            throw "Property [{0}] is null" -f $Property
        } elseif ($Property -eq 'Network' -and $RangeObject.$($Property) -notmatch '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$') {
            throw "Property [{0}] is not in CIDR format (e.g. 192.168.1.0/24) [{1}]" -f $Property, $RangeObject.$($Property)
        } elseif ($Property -in @('StartAddress','EndAddress') -and $RangeObject.$($Property) -notmatch '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$') {
            throw "Property [{0}] is not in IP format (e.g. 192.168.1.0) [{1}" -f $Property, $RangeObject.$($Property)
        }
    }

    return $true
}