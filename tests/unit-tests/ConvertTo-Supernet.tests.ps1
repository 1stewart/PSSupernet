BeforeAll {

    Import-Module $PSScriptRoot\..\..\PSSupernet\PSSupernet.psd1 -Force

}

Describe "ConvertTo-Supernet tests" {

    $BadParameterCases = @(
        @{Value = [PSCustomObject]@{IPAddress = 'abcde'; Tolerance = -1; KeepInvalid = $true; Format = 'Human' }} # just text
        @{Value = [PSCustomObject]@{IPAddress = 100; Tolerance = -1; KeepInvalid = $true; Format = 'Human' }} # number
        @{Value = [PSCustomObject]@{IPAddress = $null; Tolerance = -1; KeepInvalid = $true; Format = 'Human' }} # missing parameter
        @{Value = [PSCustomObject]@{IPAddress = @('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24'); Tolerance = 'A'; KeepInvalid = $true; Format = 'Human' }} # invalid tolerance parameter
        @{Value = [PSCustomObject]@{IPAddress = @('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24'); Tolerance = -1; KeepInvalid = 123; Format = 'Human' }} # just text # invalid KeepInvalid parameter
        @{Value = [PSCustomObject]@{IPAddress = @('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24'); Tolerance = -1; KeepInvalid = $true; Format = $true }} # just text # invalid Format parameter
    )

    $ValidValueCases = @(
        @{Value = [array]@('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24','192.168.10.0/24'); Result = @([PSCustomObject]@{Subnets = @('192.168.1.0/24','192.168.2.0/24','192.168.3.0/24'); Supernet = '192.168.0.0/22'; Differential = 260; Suitable = 'YES'},[PSCustomObject]@{Subnets = @('192.168.10.0/24'); Supernet = $null; Differential = 0; Suitable = $null})}
        @{Value = [array]@('192.168.1.6/24','192.168.2.0/24','192.168.3.0/24','192.168.10.0/24','192.168.20.0/24','192.168.21.0/24'); Result = @([PSCustomObject]@{Subnets = @('192.168.20.0/24','192.168.21.0/24'); Supernet = '192.168.20.0/23'; Differential = 2; Suitable = 'YES'},[PSCustomObject]@{Subnets = @('192.168.1.6/24','192.168.2.0/24','192.168.3.0/24'); Supernet = '192.168.0.0/22'; Differential = 260; Suitable = 'YES'},[PSCustomObject]@{Subnets = @('192.168.10.0/24'); Supernet = $null; Differential = 0; Suitable = $null})}
        @{Value = [array]@('10.1.39.34/19','10.1.64.0/19'); Result = @([PSCustomObject]@{Subnets = @('10.1.39.34/19','10.1.64.0/19'); Supernet = '10.1.0.0/17'; Differential = 16386; Suitable = 'YES'},[PSCustomObject]@{Subnets = @(); Supernet = $null; Differential = 0; Suitable = $null})}
        @{Value = [array]@('10.0.1.90/28','10.0.1.96/28','10.0.1.112/28'); Result = @([PSCustomObject]@{Subnets = @('10.0.1.90/28','10.0.1.96/28','10.0.1.112/28'); Supernet = '10.0.1.64/26'; Differential = 20; Suitable = 'YES'},[PSCustomObject]@{Subnets = @(); Supernet = $null; Differential = 0; Suitable = $null})}
        @{Value = [array]@('192.168.98.0/24','192.168.99.0/24','192.168.100.0/24','192.168.101.0/24','192.168.102.0/24','192.168.103.0/24','192.168.104.0/24','192.168.105.0/24'); Result = @([PSCustomObject]@{Subnets = @('192.168.98.0/24','192.168.99.0/24','192.168.100.0/24','192.168.101.0/24','192.168.102.0/24','192.168.103.0/24','192.168.104.0/24','192.168.105.0/24'); Supernet = '192.168.96.0/20'; Differential = 2062; Suitable = 'YES'},[PSCustomObject]@{Subnets = @(); Supernet = $null; Differential = 0; Suitable = $null})} # Wikipedia example
        @{Value = [array]@("13.65.25.19/32","13.66.60.119/32","13.66.143.220/30","13.66.202.14/32","13.66.248.225/32","13.66.249.211/32","13.67.10.124/30","13.69.109.132/30","13.71.1.53/32","13.71.36.155/32","13.71.199.112/30","13.73.18.38/32","13.73.24.128/32","13.73.25.229/32","13.73.28.125/32","13.73.109.196/32","13.73.110.148/32","13.73.112.191/32","13.73.116.224/32","13.77.53.216/30","13.77.172.102/32","13.77.183.209/32","13.77.202.164/32","13.78.109.156/30","13.78.128.145/32","13.78.148.178/32","13.78.150.153/32","13.78.150.201/32","13.78.150.208/32","13.78.223.116/32","13.84.49.247/32","13.84.51.172/32","13.84.52.58/32","13.86.221.220/30","13.106.38.142/32","13.106.38.148/32","13.106.54.3/32","13.106.54.19/32","13.106.57.181/32","13.106.57.196/31","20.21.42.88/30","20.36.73.139/32","20.36.73.193/32","20.36.74.214/32","20.36.74.239/32","20.36.75.46/32","20.36.75.50/32","20.38.149.132/30","20.39.53.174/32","20.42.64.36/30","20.43.121.124/30","20.44.17.220/30","20.45.64.137/32","20.45.64.138/32","20.45.64.142/32","20.45.72.89/32","20.45.72.111/32","20.45.75.183/32","20.45.123.236/30","20.48.16.247/32","20.48.21.83/32","20.48.21.242/31","20.48.40.122/32","20.72.27.152/30","20.135.70.51/32","20.135.74.3/32","20.150.172.228/30","20.192.238.124/30","20.193.128.244/32","20.193.129.6/32","20.193.129.126/32","20.193.136.12/32","20.193.136.57/32","20.193.136.59/32","20.193.136.157/32","20.193.136.160/32","20.193.136.214/32","20.193.136.216/31","20.193.136.224/32","20.193.136.239/32","20.193.136.249/32","20.193.137.13/32","20.193.137.14/32","20.193.137.36/32"); Result = @([PSCustomObject]@{Subnets = @('20.193.137.13/32','20.193.137.14/32'); Supernet = '20.193.137.12/30'; Differential = 0; Suitable = 'YES'},[PSCustomObject]@{Subnets = @('20.45.64.137/32','20.45.64.138/32'); Supernet = '20.45.64.136/30'; Differential = 0; Suitable = 'YES'},[PSCustomObject]@{Subnets = @('20.193.137.36/32','20.193.136.249/32','20.193.136.239/32','20.193.136.224/32','20.193.136.216/31','20.193.136.214/32','20.193.136.160/32','20.193.136.157/32','20.193.136.59/32','20.193.136.57/32','20.193.136.12/32','20.193.129.126/32','20.193.129.6/32','20.193.128.244/32','20.192.238.124/30','20.150.172.228/30','20.135.74.3/32','20.135.70.51/32','20.72.27.152/30','20.48.40.122/32','20.48.21.242/31','20.48.21.83/32','20.48.16.247/32','20.45.123.236/30','20.45.75.183/32','20.45.72.111/32','20.45.72.89/32','20.45.64.142/32','20.44.17.220/30','20.43.121.124/30','20.42.64.36/30','20.39.53.174/32','20.38.149.132/30','20.36.75.50/32','20.36.75.46/32','20.36.74.239/32','20.36.74.214/32','20.36.73.193/32','20.36.73.139/32','20.21.42.88/30','13.106.57.196/31','13.106.57.181/32','13.106.54.19/32','13.106.54.3/32','13.106.38.148/32','13.106.38.142/32','13.86.221.220/30','13.84.52.58/32','13.84.51.172/32','13.84.49.247/32','13.78.223.116/32','13.78.150.208/32','13.78.150.201/32','13.78.150.153/32','13.78.148.178/32','13.78.128.145/32','13.78.109.156/30','13.77.202.164/32','13.77.183.209/32','13.77.172.102/32','13.77.53.216/30','13.73.116.224/32','13.73.112.191/32','13.73.110.148/32','13.73.109.196/32','13.73.28.125/32','13.73.25.229/32','13.73.24.128/32','13.73.18.38/32','13.71.199.112/30','13.71.36.155/32','13.71.1.53/32','13.69.109.132/30','13.67.10.124/30','13.66.249.211/32','13.66.248.225/32','13.66.202.14/32','13.66.143.220/30','13.66.60.119/32','13.65.25.19/32'); Supernet = $null; Differential = 0; Suitable = $null})}
    )

    It "Given an invalid parameter value, it'll throw" -TestCases $BadParameterCases {
        param (
            $Value
        )
        { ConvertTo-Supernet -IPAddress $Value.IPAddress -Tolerance $Value.Tolerance -KeepInvalid $Value.KeepInvalid -Format = $Value.Format } | Should -Throw
        { ConvertTo-Supernet -IPAddress $Value.IPAddress -Tolerance $Value.Tolerance -KeepInvalid $Value.KeepInvalid -Format = $Value.Format } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }

    It "Given valid values, it'll return the expected result" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        # use compare object since should assertion doesn't match, but result the same
        Compare-Object $Result $(ConvertTo-Supernet -IPAddress $Value) | Should -BeNullOrEmpty
    }

    It "Given valid values in the wrong order, it'll return the expected result" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        Compare-Object $Result $(ConvertTo-Supernet -IPAddress $($Value | Sort-Object {Get-Random})) | Should -BeNullOrEmpty
    }

    It "Given valid values, it'll return the expected properties" -TestCases $ValidValueCases {
        param (
            $Value,
            $Result
        )
        # use compare object since should assertion doesn't match, but result the same
        (ConvertTo-Supernet -IPAddress $Value | Get-Member -MemberType NoteProperty).Name | Should -Be @('Differential','Subnets','Suitable','Supernet')
    }

    It "Given no Tolerance parameter, it'll suggest all supernets are suitable" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value)[0].Suitable | Should -Be 'YES'
        (ConvertTo-Supernet -IPAddress $Value)[1].Suitable | Should -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value).Suitable -notcontains 'NO' | Should -Be $true
    }

    It "Given a Tolerance parameter, it'll identify unsuitable subnets" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 10)[0].Suitable | Should -Be 'NO'
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 10)[1].Suitable | Should -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 10).Suitable -notcontains 'YES' | Should -Be $true
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 300)[0].Suitable | Should -Be 'YES'
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 300)[1].Suitable | Should -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value -Tolerance 300).Suitable -notcontains 'NO' | Should -Be $true
    }

    It "Given no KeepInvalid parameter, it'll retain non-supernetted subnets" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value)[0].Supernet | Should -Not -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value)[1].Subnets | Should -Be '192.168.10.0/24'
        (ConvertTo-Supernet -IPAddress $Value)[1].Supernet | Should -BeNullOrEmpty
    }

    It "Given a KeepInvalid parameter of `$false, it'll remove unsuitable subnets" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value -KeepInvalid $false)[0].Supernet | Should -Not -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value -KeepInvalid $false)[1].Subnets | Should -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value -KeepInvalid $false).Count | Should -Be 1
    }

    It "Given no Format parameter, it'll output as a raw object" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value)[0].Supernet | Should -Not -BeNullOrEmpty
        (ConvertTo-Supernet -IPAddress $Value)[1].Subnets | Should -Be '192.168.10.0/24'
        (ConvertTo-Supernet -IPAddress $Value)[1].Supernet | Should -BeNullOrEmpty
    }

    It "Given the Format parameter JSON, it'll output JSON" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        Compare-Object (ConvertTo-Supernet -IPAddress $Value -Format 'json' | ConvertFrom-Json) $Result | Should -BeNullOrEmpty
    }

    It "Given the Format parameter Human, it'll output a human readable object" -TestCases $ValidValueCases[0] {
        param (
            $Value,
            $Result
        )
        (ConvertTo-Supernet -IPAddress $Value -Format 'Human') | Get-Member -Name groupingEntry | Should -Not -BeNullOrEmpty
    }

}
