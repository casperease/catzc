Describe 'Test-AnalyzerDrsMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $rules = Join-Path $TestDrive '.scriptanalyzer'
        [void][System.IO.Directory]::CreateDirectory($rules)
        [System.IO.File]::WriteAllText((Join-Path $rules 'WidgetRules.psm1'), (@('function Measure-Widget { }',
                    'function Get-Helper { }') -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $rules 'EntryRule.psm1'), 'function Measure-Dispatch { }')
        [System.IO.File]::WriteAllText((Join-Path $rules 'GizmoEntry.psm1'), 'function Measure-GizmoEntry { }')
        # The entry rules are what the settings' CustomRulePath lists; the fixture names two.
        $settings = [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::SettingsPath($TestDrive)
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($settings))
        [System.IO.File]::WriteAllText($settings,
            "@{ CustomRulePath = @('pwsh/.scriptanalyzer/EntryRule.psm1','pwsh/.scriptanalyzer/GizmoEntry.psm1') }")
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-DrsRuleIds -ModuleName Catzc.Base.QualityGates { 'ADR-TST-WIDGET-SPIN', 'ADR-TST-WIDGET-TURN' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'analyzer-drs-map' } {
            [pscustomobject]@{ analyzers = [ordered]@{
                    'Measure-Widget' = @('ADR-TST-WIDGET-SPIN')
                    'PSUseGadget'    = @('ADR-TST-WIDGET-TURN')
                }
            }
        }
    }

    It 'leaves every entry rule the settings list out of the map, and still counts a check that is not one' {
        $result = Test-AnalyzerDrsMap -OutputFolder $out -PassThru
        $result.Issues | Should -Not -Match 'Measure-Dispatch|Measure-GizmoEntry'
        $result.Facts['CustomRules'] | Should -Be 1
    }

    It 'passes when every cited id is real and every custom rule is mapped (the entry rules excluded)' {
        $result = Test-AnalyzerDrsMap -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Analyzers'] | Should -Be 2
        $result.Facts['CustomRules'] | Should -Be 1
    }

    It 'throws once naming an unknown id and an unmapped custom rule' {
        [System.IO.File]::WriteAllText((Join-Path $TestDrive '.scriptanalyzer/GadgetRules.psm1'),
            'function Measure-Gadget { }')
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'analyzer-drs-map' } {
            [pscustomobject]@{ analyzers = [ordered]@{ 'Measure-Widget' = @('ADR-TST-WIDGET-SPIN',
                        'ADR-TST-WIDGET-GHOST')
                }
            }
        }
        try {
            $thrown = { Test-AnalyzerDrsMap -OutputFolder $out } | Should -Throw -PassThru
        }
        finally {
            Remove-Item (Join-Path $TestDrive '.scriptanalyzer/GadgetRules.psm1')
        }
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-AnalyzerDrsMap failed: 2 issue(s)*'
        $message | Should -Match 'Measure-Widget: cites ADR-TST-WIDGET-GHOST, which is not a rule in docs/drs'
        $message | Should -Match 'Measure-Gadget: a custom analyzer rule missing from analyzer-drs-map.yml'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-DrsRuleIds -ModuleName Catzc.Base.QualityGates { 'ADR-TST-WIDGET-SPIN' }
        $result = Test-AnalyzerDrsMap -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'analyzer-drs-map'
        $result.Issues | Should -HaveCount 1
    }
}
