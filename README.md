# PSSupernet

### Description
A PowerShell module for converting subnets in to supernets. Supernetting concepts are explained at https://www.cuyamaca.edu/student-support/tutoring-center/files/student-resources/How%20to%20Supernet-Cisco.pdf. Our original use case was to reduce the Microsoft published Azure service tag subnets to meet the 200 AKS authorized IP restrictions.

### Features
* Convert large lists of subnets, including out of order, e.g. whole service tag blocks
* Support a differential between subnets and supernet, identify if unsuitable
* Option to keep subnets that can't be supernetted, to allow concatenation between subnets + supernets
* Output in raw, or human readable formats

### Usage
1. Download the latest release from: https://github.com/1stewart/PSSupernet/releases
2. Import module
** Either place in `PSModulePath` (`$env:PSModulePath`) and `Import-Module PSSupernet` or
** Extract to a folder and import directly from the psd1 file `Import-Module ./PSSupernet/PSSupernet.psd1 -Force`
3. Run the function `ConvertTo-Supernet`, (e.g. `ConvertTo-Supernet -IPAddress @('192.168.1.0/24','192.168.2.0/24')`

### Parameters

`-IPAddress`

  Array of addresses to try to supernet
|||
|-|-|
|Type:|string[]|
|Position:|1|
|Default Value:|None|
|Accept pipeline input:|True|
|Accept wildcard characters:|False|

`-Tolerance`

Difference between subnets and supernets that'd be considered reasonable (e.g. 24 -> 23 would be 2 addresses difference)
|||
|-|-|
|Type:|int|
|Position:|Named|
|Default Value:|-1|
|Accept pipeline input:|False|
|Accept wildcard characters:|False|

`-KeepInvalid`

Whether to include subnets that cannot be supernetted in output (ideal for concatenating valid and invalid)
|||
|-|-|
|Type:|boolean|
|Position:|Named|
|Default Value:|True|
|Accept pipeline input:|False|
|Accept wildcard characters:|False|

`-Format`

Output format, one of `JSON`,`Human`,`None`. `Human` will scale to be readable in console, `None` will be a raw PS object.
|||
|-|-|
|Type:|string|
|Position:|Named|
|Default Value:|'none'|
|Accept pipeline input:|False|
|Accept wildcard characters:|False|


### Requirements
* PowerShell 5.1 ![example workflow](https://github.com/1stewart/PSSupernet/actions/workflows/validate-powershell.yml/badge.svg)
* PowerShell Core ![example workflow](https://github.com/1stewart/PSSupernet/actions/workflows/validate-pwsh.yml/badge.svg)
* Pester 5 (if want to run tests)

### Running tests
The tests are ran as part of a PR or branch commit, however if you want to run them locally.

1. Get Pester 5
`Install-Module Pester -RequiredVersion 5.3.1` (or any version of 5)

2. Define Pester 5 configuration block (Only Run.Path is required, the others are optional)
```
$PesterConfigurationOptions = @{
    Run = @{ EnableExit = $true; Path = "./tests/unit-tests/" };
    Output = @{ Verbosity = 'Detailed' };
    CodeCoverage = @{ Enabled = $true; Path = @("PSSupernet/private","PSSupernet/public") }
}

$PesterConfiguration = New-PesterConfiguration -Hashtable $PesterConfigurationOptions
```
3. Execute Pester with configuration block
`Invoke-Pester -Configuration $PesterConfiguration`

### TODO:
IPv6 support 💀