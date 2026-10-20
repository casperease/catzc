<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/types/ContractValue.Tests.ps1
    folder: tests/types
    name: contract-value-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ContractValue.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/types/ContractValue.Tests.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

Describe 'ContractValue' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-CONTRACTASSET' {
    It 'reads <Text> as <Kind>' -ForEach @(
        @{ Text = 'null'; Kind = 'null' }
        @{ Text = 'true'; Kind = 'boolean' }
        @{ Text = '"widget"'; Kind = 'string' }
        @{ Text = '7'; Kind = 'integer' }
        @{ Text = '7.0'; Kind = 'integer' }
        @{ Text = '7.5'; Kind = 'number' }
        @{ Text = '123456789012345678901234567890'; Kind = 'integer' }
        @{ Text = '{"widget":1}'; Kind = 'object' }
        @{ Text = '[1]'; Kind = 'array' }
    ) {
        $value = $Text | ConvertFrom-Json -AsHashtable -NoEnumerate
        [Catzc.Base.Contracts.ContractValue]::Kind($value) | Should -Be $Kind
    }

    It 'reads the YAML parser''s values as the same kinds' {
        $value = "a: 1`nb: 1.5`nc: gadget`nd: [1]`ne:`n" | ConvertFrom-Yaml -Ordered
        @('a', 'b', 'c', 'd', 'e') | ForEach-Object { [Catzc.Base.Contracts.ContractValue]::Kind($value[$_]) } |
            Should -Be @('integer', 'number', 'string', 'array', 'null')
    }

    It 'throws on a value no JSON or YAML parser gives' {
        { [Catzc.Base.Contracts.ContractValue]::Kind([guid]::Empty) } | Should -Throw '*System.Guid is not a JSON or YAML value*'
    }

    It 'compares <Left> and <Right> as equal: <Equal>' -ForEach @(
        @{ Left = '1'; Right = '1.0'; Equal = $true }
        @{ Left = '"1"'; Right = '1'; Equal = $false }
        @{ Left = '"Widget"'; Right = '"widget"'; Equal = $false }
        @{ Left = '{"a":1,"b":[1,2]}'; Right = '{"b":[1,2],"a":1}'; Equal = $true }
        @{ Left = '{"a":1}'; Right = '{"a":1,"b":2}'; Equal = $false }
        @{ Left = '[1,2]'; Right = '[2,1]'; Equal = $false }
        @{ Left = 'null'; Right = 'false'; Equal = $false }
    ) {
        $leftValue = $Left | ConvertFrom-Json -AsHashtable -NoEnumerate
        $rightValue = $Right | ConvertFrom-Json -AsHashtable -NoEnumerate
        [Catzc.Base.Contracts.ContractValue]::Equal($leftValue, $rightValue) | Should -Be $Equal
    }

    It 'reads a <Type> as <Kind>' -ForEach @(
        @{ Type = 'int'; Value = [int]7; Kind = 'integer' }
        @{ Type = 'long'; Value = [long]7; Kind = 'integer' }
        @{ Type = 'bool'; Value = $false; Kind = 'boolean' }
        @{ Type = 'string'; Value = 'gadget'; Kind = 'string' }
        @{ Type = 'null'; Value = $null; Kind = 'null' }
        @{ Type = 'PSObject-wrapped int'; Value = [psobject]::AsPSObject([int]7); Kind = 'integer' }
    ) {
        [Catzc.Base.Contracts.ContractValue]::Kind($Value) | Should -Be $Kind
    }

    It 'compares a <Left> with a <Right> as equal: <Equal>' -ForEach @(
        @{ Left = [int]7; Right = [int]7; Equal = $true }
        @{ Left = [int]7; Right = [int]8; Equal = $false }
        @{ Left = [int]7; Right = [long]7; Equal = $true }
        @{ Left = [long]7; Right = [long]8; Equal = $false }
        @{ Left = [int]7; Right = [double]7; Equal = $true }
        @{ Left = [int]7; Right = [double]7.5; Equal = $false }
        @{ Left = $true; Right = $true; Equal = $true }
        @{ Left = $true; Right = $false; Equal = $false }
        @{ Left = 'widget'; Right = 'widget'; Equal = $true }
        @{ Left = 'widget'; Right = 'Widget'; Equal = $false }
        @{ Left = 'widget'; Right = [psobject]::AsPSObject('widget'); Equal = $true }
        @{ Left = [int]1; Right = 'gadget'; Equal = $false }
        @{ Left = $true; Right = [int]1; Equal = $false }
    ) {
        [Catzc.Base.Contracts.ContractValue]::Equal($Left, $Right) | Should -Be $Equal
    }

    It 'compares a YAML decimal and a JSON double by value' {
        $yaml = "widget: 1.5`n" | ConvertFrom-Yaml -Ordered
        $json = '{"widget":1.5}' | ConvertFrom-Json -AsHashtable
        [Catzc.Base.Contracts.ContractValue]::Equal($yaml, $json) | Should -BeTrue
    }

    It 'describes a value on one line, and cuts a long one' {
        $value = '{"widget":["gadget",1,null,true]}' | ConvertFrom-Json -AsHashtable
        [Catzc.Base.Contracts.ContractValue]::Describe($value) | Should -Be "{widget: ['gadget', 1, null, true]}"
        $long = [Catzc.Base.Contracts.ContractValue]::Describe('w' * 200)
        $long.Length | Should -Be ([Catzc.Base.Contracts.ContractValue]::DescribeLimit)
        $long | Should -BeLike "'www*..."
    }
}
