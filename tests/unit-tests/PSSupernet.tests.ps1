BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "PSSupernet tests" {

    $FunctionCases = @(
        @{Name = 'Confirm-RangeObject' }
        @{Name = 'Convert-BinaryIPAddressToNetwork'}
        @{Name = 'Convert-CIDRToSubnet'}
        @{Name = 'Convert-IPAddressToBinary'}
        @{Name = 'Convert-IPAddressToRange'}
        @{Name = 'ConvertTo-Supernet'}
        @{Name = 'Get-HostAddressDifference'}
        @{Name = 'Get-NewSubnetMask'}
        @{Name = 'Get-UsableAddressCount'}
        @{Name = 'Split-SequentialIPRange'}
    )

    It "Imports successfully" {
        Get-Module PSSupernet | Should -Not -BeNullOrEmpty
    }

    It "Imports with the expected name" {
        (Get-Module PSSupernet).Name | Should -Be 'PSSupernet'
    }

    It "Imports with the expected version" {
        (Get-Module PSSupernet).Version | Should -Be '1.0.0'
    }

    It "Imports with the expected description" {
        (Get-Module PSSupernet).Description | Should -Be 'PowerShell module for calculating supernets from subnets'
    }

    It "Imports with the expected GUID" {
        (Get-Module PSSupernet).Guid | Should -Be '4049ea80-04ac-412f-ac33-7b39d4d7d8ea'
    }

    It "Imports with the expected tags" {
        (Get-Module PSSupernet).Tags | Select-Object -Unique | Should -Be @('Networking','Network','Supernet','IP','Subnet')
    }

    It "Imports with the expected project URI" {
        (Get-Module PSSupernet).ProjectUri | Should -Be 'https://github.com/1stewart/pssupernet'
    }

    It "Imports with the expected license URI" {
        (Get-Module PSSupernet).LicenseUri | Should -Be 'https://github.com/1stewart/pssupernet/blob/master/LICENSE'
    }

    It "Exports the expected functions" -TestCases $FunctionCases {
        param (
            $Name
        )
        (Get-Module PSSupernet).ExportedCommands.Keys -contains $Name | Should -Be $true
    }

    It "Doesn't export any unexpected functions" {
        (Get-Module PSSupernet).ExportedCommands.Keys.Count | Should -Be 10
    }

}