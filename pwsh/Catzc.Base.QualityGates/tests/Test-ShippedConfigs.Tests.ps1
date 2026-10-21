<#
---
catzc:
  immutable:
    with_body_sha: e1264818c25d
  edges:
    docs: "[Test-ShippedConfigs.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Test-ShippedConfigs.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Test-ShippedConfigs' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'widget-modules'
        foreach ($path in 'TstWidget/configs/widget.yml', 'TstWidget/configs/widget-parts.yml', 'TstGadget/configs/gadget.yml',
            'TstGadget/README.md', '.internal/configs/hidden.yml') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        $script:out = Join-Path $TestDrive 'out'

        function script:New-FixtureRegistry {
            param([hashtable] $Types, [hashtable] $Differs = @{})
            $entries = [ordered]@{}
            foreach ($key in $Types.Keys) {
                $entries[$key] = [ordered]@{ type = $Types[$key] }
                if ($Differs.ContainsKey($key)) {
                    $entries[$key].differs = $Differs[$key]
                }
            }
            [Catzc.Base.Config.ConfigsConfig]::new([ordered]@{ configs = $entries })
        }
        $script:widgetFile = Join-Path $root 'TstWidget/configs/widget.yml'
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'widget-modules' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -ne 'configs' } { 'loaded' }
    }

    It 'passes when every shipped config has a resolvable type and loads' {
        $registry = New-FixtureRegistry @{ widget = 'System.String'; 'widget-parts' = 'System.String'; gadget = 'System.String' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()

        $result = Test-ShippedConfigs -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Configs'] | Should -Be 3
        $result.Facts['Types'] | Should -Be 3
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

    Context 'the shipped file shows its type''s defaults' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        # A real type with a Default<Key> constant: VariantsConfig declares DefaultAdoNaming = 'standard'.
        AfterEach {
            [System.IO.File]::WriteAllText($script:widgetFile, '')
        }

        It 'reports a key whose shipped value differs from the type''s default' {
            [System.IO.File]::WriteAllText($script:widgetFile, "ado_naming: gadget`n")
            $registry = New-FixtureRegistry @{ widget = 'Catzc.Base.Variants.VariantsConfig'; 'widget-parts' = 'System.String'; gadget = 'System.String' }
            Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()

            $thrown = { Test-ShippedConfigs -OutputFolder $out } | Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike "*TstWidget/configs/widget.yml: 'ado_naming' ships 'gadget' where its type's default is 'standard'*"
        }

        It 'passes a difference that carries its reason, and a value that matches' {
            [System.IO.File]::WriteAllText($script:widgetFile, "ado_naming: gadget`n")
            $registry = New-FixtureRegistry @{ widget = 'Catzc.Base.Variants.VariantsConfig'; 'widget-parts' = 'System.String'; gadget = 'System.String' } @{ widget = @{ ado_naming = 'The widgets name their projects their own way.' } }
            Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()
            (Test-ShippedConfigs -OutputFolder $out -PassThru).IssueCount | Should -Be 0

            [System.IO.File]::WriteAllText($script:widgetFile, "ado_naming: standard`n")
            $plain = New-FixtureRegistry @{ widget = 'Catzc.Base.Variants.VariantsConfig'; 'widget-parts' = 'System.String'; gadget = 'System.String' }
            Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $plain }.GetNewClosure()
            (Test-ShippedConfigs -OutputFolder $out -PassThru).IssueCount | Should -Be 0
        }

        It 'reports a reason for a key whose values agree' {
            [System.IO.File]::WriteAllText($script:widgetFile, "ado_naming: standard`n")
            $registry = New-FixtureRegistry @{ widget = 'Catzc.Base.Variants.VariantsConfig'; 'widget-parts' = 'System.String'; gadget = 'System.String' } @{ widget = @{ ado_naming = 'A stale reason.' } }
            Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'configs' } { $registry }.GetNewClosure()

            $thrown = { Test-ShippedConfigs -OutputFolder $out } | Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike "*configs.yml: 'widget' differs 'ado_naming', but the shipped value and the type's default agree*"
        }
    }
}
