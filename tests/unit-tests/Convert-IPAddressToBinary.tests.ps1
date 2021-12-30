BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Convert-IPAddressToBinary tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcde' } # just text
        @{Value = [int]123 } # number
        @{Value = [string]'192.168.0.1/241' } # invalid subnet mask
        @{Value = [string]'2555.255.255.255/24' } # invalid IP
    )

    $ValidValueCases = @(
        @{Value = [array]@('192.168.1.1/24'); Result = [string]'11000000101010000000000100000001' }
        @{Value = [array]@('10.0.1.0', '10.1.0.0'); Result = [array]@('00001010000000000000000100000000', '00001010000000010000000000000000') }
        @{Value = [array]@('24.1.33.123'); Result = [string]'00011000000000010010000101111011' }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Convert-IPAddressToBinary -IPAddress $Value } | Should -Throw
        { Convert-IPAddressToBinary -IPAddress $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }

    It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
        param (
            $Value
        )
            (Convert-IPAddressToBinary -IPAddress $Value).GetType() | Should -BeIn @('string', 'System.Object[]')
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Convert-IPAddressToBinary -IPAddress $Value) $Result | Should -BeNullOrEmpty
    }

    It "Given a valid parameter value, it returns multiple values when needed" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
            (Convert-IPAddressToBinary -IPAddress $Value).Count | Should -Be $Result.Count
    }

}