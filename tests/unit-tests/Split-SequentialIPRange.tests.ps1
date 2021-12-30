BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Split-SequentialIPRange tests" {

    $BadParameterCases = @(
        @{Value = [string]'abcde' } # just text
        @{Value = [int]123 } # number
        @{Value = [PSCustomObject]@{Network = '192.168.1.0/24'; EndAddress = '192.168.1.255'}} # missing property
        @{Value = [PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.2555'}} # invalid address in property
    )

    $ValidValueCases = @(
        @{Value =
            @(
                [PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.255'}
                [PSCustomObject]@{Network = '192.168.2.0/24'; StartAddress = '192.168.2.0'; EndAddress = '192.168.2.255'}
                [PSCustomObject]@{Network = '192.168.3.0/24'; StartAddress = '192.168.3.0'; EndAddress = '192.168.3.255'}
                [PSCustomObject]@{Network = '192.168.10.0/24'; StartAddress = '192.168.10.0'; EndAddress = '192.168.10.255'}
            );
        Result =
            @(
                [PSCustomObject]@{Collection = '-1'; Ranges = @('192.168.10.0/24')}
                [PSCustomObject]@{Collection = '0'; Ranges = @('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24')}
            )
        }
        @{Value =
            @(
                [PSCustomObject]@{Network = '10.0.1.90/28'; StartAddress = '10.0.1.80'; EndAddress = '10.0.1.95'}
                [PSCustomObject]@{Network = '10.0.1.96/28'; StartAddress = '10.0.1.96'; EndAddress = '10.0.1.111'}
                [PSCustomObject]@{Network = '10.0.1.112/28'; StartAddress = '10.0.1.112'; EndAddress = '10.0.1.127'}
            );
        Result =
            @(
                [PSCustomObject]@{Collection = '0'; Ranges = @('10.0.1.90/28','10.0.1.96/28','10.0.1.112/28')}
            )
        }
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Split-SequentialIPRange -IPRange   $Value } | Should -Throw
        { Split-SequentialIPRange -IPRange $Value } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])

    }
    if ($PSVersionTable.PSEdition -eq 'Core') {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
            (Split-SequentialIPRange -IPRange $Value).GetType() | Should -BeIn @('System.Object[]','PSCustomObject')
        }
    } else {
        It "Given a valid parameter value, it returns an object" -TestCases $ValidValueCases {
            param (
                $Value
            )
            (Split-SequentialIPRange -IPRange $Value).GetType() | Should -Be 'System.Management.Automation.PSCustomObject'
        }
    }

    It "Given a valid parameter value, it returns the expected output" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $(Split-SequentialIPRange -IPRange $Value) $Result | Should -BeNullOrEmpty
    }

    It "Given a parameter value that'd result in multiple indexes, it returns the expected output" -TestCases $ValidValueCases[0] {
        param (
            $Value
        )
        (Split-SequentialIPRange -IPRange $Value).Collection[0] | Should -Be -1
        (Split-SequentialIPRange -IPRange $Value).Collection[1] | Should -Be 0
    }

    It "Given a parameter value that'd result in a single index, it returns the expected output" -TestCases $ValidValueCases[1] {
        param (
            $Value
        )
        (Split-SequentialIPRange -IPRange $Value).Collection[0] | Should -Be 0
        (Split-SequentialIPRange -IPRange $Value).Collection.Count | Should -Be 1
    }

    It "Given a parameter value that includes KeepInvalid set to false, it writes to verbose" -TestCases $ValidValueCases[0] {
        param (
            $Value
        )
        $CurrentVerbosePreference = $VerbosePreference
        $VerbosePreference = 'Continue'
        $(Split-SequentialIPRange -IPRange $Value -KeepInvalid $false -Verbose 4>&1 | Select-String 'Dropping')| Should -Be 'Dropping Row [192.168.10.0/24] as count is only 1'
        $VerbosePreference = $CurrentVerbosePreference
    }

}