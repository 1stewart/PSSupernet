@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'PSSupernet.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.0'

    # ID used to uniquely identify this module
    GUID              = '4049ea80-04ac-412f-ac33-7b39d4d7d8ea'

    # Author of this module
    Author            = 'Stewart L'

    # Copyright statement for this module
    Copyright         = '(c) 2021 Stewart L. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PowerShell module for calculating supernets from subnets'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Functions to export from this module
    FunctionsToExport = @('Confirm-RangeObject','Convert-BinaryIPAddressToNetwork','Convert-CIDRToSubnet','Convert-IPAddressToBinary',
        'Convert-IPAddressToRange','ConvertTo-Supernet','Get-HostAddressDifference','Get-NewSubnetMask','Get-UsableAddressCount',
        'Split-SequentialIPRange'
    )

    # Cmdlets to export from this module
    CmdletsToExport   = ''

    # Aliases to export from this module
    AliasesToExport   = ''

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Networking', 'Network', 'Supernet', 'IP', 'Subnet')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/1stewart/pssupernet/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/1stewart/pssupernet'

            # ReleaseNotes of this module
            ReleaseNotes = 'Initial release'

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}