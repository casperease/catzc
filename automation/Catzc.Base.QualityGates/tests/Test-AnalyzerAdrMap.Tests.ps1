Describe 'Test-AnalyzerAdrMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $rules = Join-Path $TestDrive 'scriptanalyzer'
        [void][System.IO.Directory]::CreateDirectory($rules)
        [System.IO.File]::WriteAllText((Join-Path $rules 'WidgetRules.psm1'), (@('function Measure-Widget { }', 'function Get-Helper { }') -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $rules 'CatzcRules.psm1'), 'function Measure-Dispatch { }')
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'automation/.scriptanalyzer' } {
            Join-Path $TestDrive 'scriptanalyzer'
        }
        Mock Get-CatsAdrRuleIds -ModuleName Catzc.Base.QualityGates { 'ADR-TST-WIDGET:1', 'ADR-TST-WIDGET:2' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'analyzer-adr-map' } {
            [pscustomobject]@{ analyzers = [ordered]@{
                    'Measure-Widget' = @('ADR-TST-WIDGET#1')
                    'PSUseGadget'    = @('ADR-TST-WIDGET#2')
                }
            }
        }
    }

    It 'passes when every cited id is real and every custom rule is mapped (the entry rule excluded)' {
        $result = Test-AnalyzerAdrMap -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Analyzers | Should -Be 2
        $result.CustomRules | Should -Be 1
    }

    It 'throws once naming an unknown id and an unmapped custom rule' {
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'scriptanalyzer/GadgetRules.psm1'), 'function Measure-Gadget { }')
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'analyzer-adr-map' } {
            [pscustomobject]@{ analyzers = [ordered]@{ 'Measure-Widget' = @('ADR-TST-WIDGET#1', 'ADR-TST-WIDGET#9') } }
        }
        try {
            $thrown = { Test-AnalyzerAdrMap -OutputFolder $out } | Should -Throw -PassThru
        }
        finally {
            Remove-Item (Join-Path $TestDrive 'scriptanalyzer/GadgetRules.psm1')
        }
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-AnalyzerAdrMap failed: 2 issue(s)*'
        $message | Should -Match 'Measure-Widget: cites ADR-TST-WIDGET#9, which is not a rule in docs/adr'
        $message | Should -Match 'Measure-Gadget: a custom analyzer rule missing from analyzer-adr-map.yml'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-CatsAdrRuleIds -ModuleName Catzc.Base.QualityGates { 'ADR-TST-WIDGET:1' }
        $result = Test-AnalyzerAdrMap -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'analyzer-adr-map'
        $result.Issues | Should -HaveCount 1
    }
}
