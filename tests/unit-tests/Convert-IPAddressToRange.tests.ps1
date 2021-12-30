BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Convert-IPAddressToRange tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcde' } # just text
        @{Value = [int]123 } # number
        @{Value = [string]'192.168.0.1' } # no subnet mask
        @{Value = [string]'2555.255.255.255/24' } # invalid IP
    )

    $ValidValueCases = @(
        @{Value = [array]@('192.168.1.0/24'); Result = [PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.255' } }
        @{Value = [array]@('192.168.1.0/24', '192.168.2.0/24'); Result = @([PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.255' }, [PSCustomObject]@{Network = '192.168.2.0/24'; StartAddress = '192.168.2.0'; EndAddress = '192.168.2.255' }) }
        @{Value = [array]@('2.26.95.132/19'); Result = [PSCustomObject]@{Network = '2.26.95.132/19'; StartAddress = '2.26.64.0'; EndAddress = '2.26.95.255' } }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Convert-IPAddressToRange -IPAddress $Value } | Should -Throw
        { Convert-IPAddressToRange -IPAddress $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }
    
    if ($PSVersionTable.PSEdition -eq 'Core') {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Convert-IPAddressToRange -IPAddress $Value).GetType() | Should -BeIn @('PSCustomObject', 'System.Object[]]')
        }
    } else {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
                (Convert-IPAddressToRange -IPAddress $Value).GetType() | Should -BeIn @('SystemObject[]]','System.Management.Automation.PSCustomObject')
        }
    }

    It "Given a valid parameter value, it returns an object with all three properties" -TestCases $ValidValueCases {
        param (
            $Value
        )
        $((Convert-IPAddressToRange -IPAddress $Value) | Get-Member -MemberType NoteProperty | Sort-Object).Name  | Should -Be @('EndAddress', 'Network', 'StartAddress')
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Convert-IPAddressToRange -IPAddress $Value) $Result | Should -BeNullOrEmpty
    }

    It "Given a valid parameter value, it returns multiple values when needed" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
            (Convert-IPAddressToRange -IPAddress $Value).Count | Should -Be $Result.Count
    }

}