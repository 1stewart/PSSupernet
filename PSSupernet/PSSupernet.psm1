# Define load order + only import explicitly imported functions
[array]$Modules = @(
    "$($PSScriptRoot)\private\Confirm-RangeObject.ps1"
    "$($PSScriptRoot)\private\Convert-BinaryIPAddressToNetwork.ps1"
    "$($PSScriptRoot)\private\Convert-CIDRToSubnet.ps1"
    "$($PSScriptRoot)\private\Convert-IPAddressToBinary.ps1"
    "$($PSScriptRoot)\private\Convert-IPAddressToRange.ps1"
    "$($PSScriptRoot)\private\Get-HostAddressDifference.ps1"
    "$($PSScriptRoot)\private\Get-NewSubnetMask.ps1"
    "$($PSScriptRoot)\private\Get-UsableAddressCount.ps1"
    "$($PSScriptRoot)\private\Split-SequentialIPRange.ps1"
    "$($PSScriptRoot)\public\ConvertTo-Supernet.ps1"
)

# Dot source the files
ForEach ($Module in $Modules) {
    Try {
        . $Module -Verbose
    } Catch {
        Write-Error "Failed to import function [$($Module)]: $_"
    }
}
