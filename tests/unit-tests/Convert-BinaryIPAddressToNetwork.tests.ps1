BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Confirm-BinaryIPAddressToNetwork tests" {

    $BadParameterCases = @(
        @{Parameter = 'BinaryIPAddress'; BinaryIPAddress = [string]'abcde'; Difference = 24 } # string
        @{Parameter = 'BinaryIPAddress'; BinaryIPAddress = [int]1234567; Difference = 24 } # number
        @{Parameter = 'BinaryIPAddress'; BinaryIPAddress = [string]'010101010101010101110111111001'; Difference = 24 } # too short
        @{Parameter = 'BinaryIPAddress'; BinaryIPAddress = [string]'01010101010101010111011111100101011010101'; Difference = 24 } # too long
        @{Parameter = 'Difference'; BinaryIPAddress = [string]'10101010111011111100101011010101'; Difference = 'abc' } # string
        @{Parameter = 'Difference'; BinaryIPAddress = [string]'10101010111011111100101011010101'; Difference = 0 } # too small
        @{Parameter = 'Difference'; BinaryIPAddress = [string]'10101010111011111100101011010101'; Difference = 400 } # too big
    )

    $BadLogicCases = @( # the script should throw if there are differences after the difference count
        @{Value = @('11111111111111111111111111111111', '00000000000000000000000000000000') }
        @{Value = @('00000000000000000000000000000000', '11111111111111111111111111111111') }
    )

    $ValidValueCases = @(
        @{Value = @("11000000101010000000000000000000", "11000000101010000000000100000000", "11000000101010000000001000000000", "11000000101010000000001100000000"); Difference = 22; ExpectedValue = '192.168.0.0/22' }
        @{Value = @("00001010000000010000000000000000", "00001010000000010000000000000111", "00001010000000010000000000111111", "00001010000000010000000000111100"); Difference = 19; ExpectedValue = '10.1.0.0/19' }
    )

    It "Given an invalid <Parameter> parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Parameter,
            $BinaryIPAddress,
            $Difference
        )
        { Convert-BinaryIPAddressToNetwork -BinaryIPAddress $BinaryIPAddress -Difference $Difference } | Should -Throw
        { Convert-BinaryIPAddressToNetwork -BinaryIPAddress $BinaryIPAddress -Difference $Difference } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }

    It "Given values that are different at the expected location, it'll throw" -TestCases $BadLogicCases {
        param (
            $Value
        )
        { Convert-BinaryIPAddressToNetwork -BinaryIPAddress $Value -Difference 24 } | Should -Throw
        { Convert-BinaryIPAddressToNetwork -BinaryIPAddress $Value -Difference 24 } | Should -Throw -ExceptionType ([System.Management.Automation.RuntimeException])
    }

    It "Given valid values, it'll return the expected result" -TestCases $ValidValueCases {
        param (
            $Value,
            $Difference,
            $ExpectedValue
        )
        Convert-BinaryIPAddressToNetwork -BinaryIPAddress $Value -Difference $Difference | Should -Be $ExpectedValue
    }
}