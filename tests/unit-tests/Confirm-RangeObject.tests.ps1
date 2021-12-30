BeforeAll {

    [object]$BadObject = [PSCustomObject]@{
        Network      = '192.168.1.0/24'
        StartAddress = '192.168.1.0'
        EndAddress   = '192.168.1.255'
        BadProperty  = $true
    }

    [object]$ValidObject = [PSCustomObject]@{
        Network      = '192.168.1.0/24'
        StartAddress = '192.168.1.0'
        EndAddress   = '192.168.1.255'
    }

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "Confirm-RangeObject tests" {

    $BadParameterCases = @(
        @{Parameter = 'string'; Value = [string]"I'm a bad parameter" }
        @{Parameter = 'int'; Value = [int]666 }
    )

    $ThrowCases = @(
        @{Property = 'Network'; MockObject = [PSCustomObject]@{Network = '192.168.1.0'; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.255' } }
        @{Property = 'StartAddress'; MockObject = [PSCustomObject]@{Network = '192.168.1.0'; StartAddress = '192.168.1.X'; EndAddress = '192.168.1.255' } }
        @{Property = 'EndAddress'; MockObject = [PSCustomObject]@{Network = '192.168.1.0'; StartAddress = '192.168.1.0'; EndAddress = '192.1L8.1.0' } }
    )

    $NullParameterCases = @(
        @{Property = 'Network'; MockObject = [PSCustomObject]@{Network = $null; StartAddress = '192.168.1.0'; EndAddress = '192.168.1.255' } }
        @{Property = 'StartAddress'; MockObject = [PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = $null; EndAddress = '192.168.1.255' } }
        @{Property = 'EndAddress'; MockObject = [PSCustomObject]@{Network = '192.168.1.0/24'; StartAddress = '192.168.1.0'; EndAddress = $null } }
    )

    It "Given <Parameter> instead of an object, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { Confirm-RangeObject -RangeObject $Value } | Should -Throw
        { Confirm-RangeObject -RangeObject $Value } | Should -Throw "Cannot bind argument to parameter 'ReferenceObject' because it is null."
    }

    It "Given an object with an empty <Property> property, it'll throw" -TestCases $NullParameterCases {
        param (
            $MockObject
        )
        { Confirm-RangeObject -RangeObject $MockObject } | Should -Throw
        # since I can't figure out how to test for a throw message with variables
        { Confirm-RangeObject -RangeObject $MockObject } | Should -Throw -ExceptionType ([System.Management.Automation.RuntimeException])
    }

    It "Given an object with an invalid <Property> property, it'll throw" -TestCases $ThrowCases {
        param(
            $MockObject
        )
        { Confirm-RangeObject -RangeObject $MockObject } | Should -Throw
        { Confirm-RangeObject -RangeObject $MockObject } | Should -Throw -ExceptionType ([System.Management.Automation.RuntimeException])
    }

    It "Given an object with an unexpected property, it'll throw" {
        { Confirm-RangeObject -RangeObject $BadObject } | Should -Throw
        { Confirm-RangeObject -RangeObject $BadObject } | Should -Throw "Unexpected property in object"
    }

    It "Given an object with valid parameters, it'll return true" {
        { Confirm-RangeObject -RangeObject $ValidObject } | Should -Be $true
    }
}