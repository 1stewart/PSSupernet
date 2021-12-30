BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Get-UsableAddressCount tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcde' } # just text
        @{Value = [int]123 } # number
        @{Value = [string]'192.168.0.1/241' } # invalid subnet mask
        @{Value = [string]'2555.255.255.255/24' } # invalid IP
    )

    $ValidValueCases = @(
        @{Value = [array]@('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24'); Result = [int]762}
        @{Value = [array]@('192.168.1.1/32','192.168.2.1/32'); Result = [int]2}
        @{Value = [array]@('192.168.1.1/31','192.168.2.1/31'); Result = [int]4}
        @{Value = [array]@('10.1.0.0/16'); Result = [int]65534}
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {

        param (
            $Value
        )
        { Get-UsableAddressCount -IPRange $Value } | Should -Throw
        { Get-UsableAddressCount -IPRange $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])

    }

    It "Given a CIDR above 32, it'll throw" {
        { Get-UsableAddressCount -IPRange '192.168.1.1/33' } | Should -Throw
        { Get-UsableAddressCount -IPRange '192.168.1.1/33' } | Should -Throw -ExceptionType ([System.Management.Automation.RuntimeException])
    }

    It "Given a valid parameter value, it returns an integer" -TestCases $ValidValueCases {
        param (
            $Value
        )
            (Get-UsableAddressCount -IPRange  $Value).GetType() | Should -Be 'int'
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Get-UsableAddressCount -IPRange  $Value) $Result | Should -BeNullOrEmpty
    }

}

