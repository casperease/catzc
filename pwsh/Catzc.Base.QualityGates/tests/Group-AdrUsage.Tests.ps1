<#
---
catzc:
  immutable:
    with_body_sha: f8d612c16bcd
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Group-AdrUsage.ps1
---
#>

Describe 'Group-AdrUsage' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:rows = @(
            [pscustomobject]@{ Path = 'b/two.md'; Code = 'ADR-WIDGET-PART'; Rule = 'ADR-WIDGET-PART-SPIN'; Source = 'head' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = 'ADR-WIDGET-PART-SPIN'; Source = 'link' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = 'ADR-WIDGET-PART-SPIN'; Source = 'head' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = $null; Source = 'link' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-GADGET-SPEC'; Rule = 'ADR-GADGET-SPEC-TURN'; Source = 'head' }
        )

        function script:Invoke-Group {
            param($Row, [string] $By)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Row = $Row; By = $By } {
                param($Row, $By)
                Group-AdrUsage -Row $Row -By $By
            }
        }
    }

    It 'groups by rule: one row per code and rule, the whole ADR first, each document once' {
        $groups = @(Invoke-Group $rows 'Rule')
        @($groups | ForEach-Object { "$($_.Code)|$($_.Rule)" }) | Should -Be @('ADR-GADGET-SPEC|ADR-GADGET-SPEC-TURN', 'ADR-WIDGET-PART|', 'ADR-WIDGET-PART|ADR-WIDGET-PART-SPIN')
        $spin = $groups[2]
        @($spin.Documents) | Should -Be @('a/one.md', 'b/two.md')
        $spin.Count | Should -Be 2
    }

    It 'groups by document: one row per file, its citations sorted without duplicates' {
        $groups = @(Invoke-Group $rows 'Document')
        @($groups.Path) | Should -Be @('a/one.md', 'b/two.md')
        @($groups[0].Citations) | Should -Be @('ADR-GADGET-SPEC-TURN', 'ADR-WIDGET-PART', 'ADR-WIDGET-PART-SPIN')
        $groups[0].Count | Should -Be 3
    }

    It 'returns nothing for no rows' {
        @(Invoke-Group @() 'Rule').Count | Should -Be 0
        @(Invoke-Group @() 'Document').Count | Should -Be 0
    }
}
