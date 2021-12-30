BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Get-NewSubnetMask tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcdef' } # string
        @{Value = [int]1234567 } # number
        @{Value = [string]'01010101010101010111011111100101011010101' } # too long
    )

    $ValidValueCases = @(
        @{Value = [array]@('0000000000', '0000000000'); Result = [PSCustomObject]@{CIDR = 22; Mask = '255.255.252.0' } }
        @{Value = [array]@('111110000000', '000000000000'); Result = [PSCustomObject]@{CIDR = 20; Mask = '255.255.240.0' } }
        @{Value = [array]@('1', '1'); Result = [PSCustomObject]@{CIDR = 32; Mask = '255.255.255.255' } }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {

        param (
            $Value
        )
        { Get-NewSubnetMask -NetworkBits $Value } | Should -Throw
        { Get-NewSubnetMask -NetworkBits $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])

    }

    It "Given only one value, it'll throw" {
        { Get-NewSubnetMask -NetworkBits '10011110001011101001001100111010' } | Should -Throw
        { Get-NewSubnetMask -NetworkBits '10011110001011101001001100111010' } | Should -Throw 'Only one value provided, expected an array'
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        It "Given a valid parameter value, it returns an integer" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Get-NewSubnetMask -NetworkBits $Value).GetType() | Should -Be 'PSCustomObject'
        }
    } else {
        It "Given a valid parameter value, it returns an integer" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Get-NewSubnetMask -NetworkBits $Value).GetType() | Should -Be 'ystem.Management.Automation.PSCustomObject'
        }
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Get-NewSubnetMask -NetworkBits $Value) $Result | Should -BeNullOrEmpty
    }

}

