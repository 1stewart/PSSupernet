BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Convert-CIDRToSubnet tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcde' } # just text
    )

    $ValidValueCases = @(
        @{Value = [int]5; Result = [PSCustomObject]@{CIDR = 5; SubnetMask = '48.0.0.0' } }
        @{Value = [int]13; Result = [PSCustomObject]@{CIDR = 13; SubnetMask = '255.248.0.0' } }
        @{Value = [int]32; Result = [PSCustomObject]@{CIDR = 32; SubnetMask = '255.255.255.255' } }
    )

    $BadValueCases = @(
        @{Value = [int](Get-Random -Minimum 33 -Maximum 99) }
        @{Value = [int]0 }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Convert-CIDRToSubnet -CIDR $Value } | Should -Throw
        { Convert-CIDRToSubnet -CIDR $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Convert-CIDRToSubnet -CIDR $Value).GetType() | Should -Be 'PSCustomObject'
        }
    } else {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Convert-CIDRToSubnet -CIDR $Value).GetType() | Should -Be 'System.Management.Automation.PSCustomObject'
        }
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Convert-CIDRToSubnet -CIDR $Value) $Result | Should -BeNullOrEmpty
    }

    It "Given an out-of-range parameter value, it'll throw" -TestCases $BadValueCases {
        param (
            $Value
        )
        { Convert-CIDRToSubnet -CIDR $Value } | Should -Throw
        { Convert-CIDRToSubnet -CIDR $Value } | Should -Throw -ExceptionType ([System.Management.Automation.RuntimeException])
    }

}