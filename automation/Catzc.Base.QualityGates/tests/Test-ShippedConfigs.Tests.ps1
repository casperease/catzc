<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
    folder: tests
    name: test-shipped-configs-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-ShippedConfigs.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-ShippedConfigs' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'automation'
        foreach ($path in 'TstWidget/configs/widget.yml', 'TstWidget/configs/widget-parts.yml', 'TstGadget/configs/gadget.yml',
            'TstGadget/README.md', '.internal/configs/hidden.yml') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        $script:out = Join-Path $TestDrive 'out'

        function script:New-FixtureRegistry {
            param([hashtable] $Types)
            $map = [System.Collections.Generic.Dictionary[string, string]]::new()
            foreach ($key in $Types.Keys) {
                $map[$key] = $Types[$key]
            }
            [pscustomobject]@{ configs = $map }
        }
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'automation' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -ne 'configs' } { 'loaded' }
    }

    It 'passes when every shipped config has a resolvable type and loads' {
        $registry = New-FixtureRegistry @{ widget = 'System.String'; 'widget-parts' = 'System.String'; gadget = 'System.String' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()

        $result = Test-ShippedConfigs -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Configs | Should -Be 3
        $result.Types | Should -Be 3
        Should -Invoke Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'gadget' -and $Module -eq 'TstGadget' } -Times 1
    }

    It 'throws once listing a missing entry, an orphan entry, an unresolved type, and a config that does not load' {
        $registry = New-FixtureRegistry @{ widget = 'System.String'; gadget = 'Tst.NoSuchType'; sprocket = 'System.String' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'widget' } { throw 'widget.yml: size is required' }

        $thrown = { Test-ShippedConfigs -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ShippedConfigs failed: 4 issue(s)*'
        $message | Should -BeLike '*TstWidget/configs/widget-parts.yml: no type registered in configs.yml*'
        $message | Should -BeLike "*configs.yml: 'sprocket' names no shipped config*"
        $message | Should -BeLike "*configs.yml: 'gadget' type 'Tst.NoSuchType' does not resolve*"
        $message | Should -BeLike '*TstWidget/configs/widget.yml: does not load — widget.yml: size is required*'
    }
}
