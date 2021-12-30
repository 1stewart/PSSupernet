BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Get-HostAddressDifference tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcdef' } # string
        @{Value = [int]1234567 } # number
        @{Value = [array]@('010101010101010101110111111001', '01010101010101010101010101010101') } # too short
        @{Value = [array]@('01010101010101010111011111100101011010101', '01010101010101010101010101010101') } # too long
    )

    $ValidValueCases = @(
        @{Value = [array]@('11000000000000111100001010101001', '00100111111001001010100110011001'); Result = [int]0 }
        @{Value = [array]@('10011110001011101001001100111010', '10011110001011101001011100111010', '10011110011011101001011100111010'); Result = [int]9 }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Get-HostAddressDifference -BinaryIPAddress $Value } | Should -Throw
        { Get-HostAddressDifference -BinaryIPAddress $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }

    It "Given only one value, it'll throw" {
        { Get-HostAddressDifference -BinaryIPAddress '10011110001011101001001100111010' } | Should -Throw
        { Get-HostAddressDifference -BinaryIPAddress '10011110001011101001001100111010' } | Should -Throw 'Only one value provided, expected an array'
    }

    It "Given a valid parameter value, it returns an integer" -TestCases $ValidValueCases {
        param (
            $Value
        )
            (Get-HostAddressDifference -BinaryIPAddress $Value).GetType() | Should -Be 'int'
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Get-HostAddressDifference -BinaryIPAddress $Value) $Result | Should -BeNullOrEmpty
    }

    It "Given a parameter value that would result in only one difference, it returns the expected result" { # test array output sorting
            (Get-HostAddressDifference -BinaryIPAddress @('10100000000000000000000000000000', '10000000000000000000000000000000')).Count | Should -Be 1
    }

    It "Given a parameter value that would result in multiple differences, it returns the expected result" { # test array output sorting
            (Get-HostAddressDifference -BinaryIPAddress @('10100000000000000000000000000000', '10000000000000000000000000000000', '11000000000000000000000000000000')).Count | Should -Be 1
        Get-HostAddressDifference -BinaryIPAddress @('10000100000000000000000000000000', '10000110000000000000000000000000', '10000010000000000000000000000000') | Should -Be 5
    }

}