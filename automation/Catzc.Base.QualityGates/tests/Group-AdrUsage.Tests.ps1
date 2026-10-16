<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Group-AdrUsage.Tests.ps1
    folder: tests
    name: group-adr-usage-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Group-AdrUsage' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:rows = @(
            [pscustomobject]@{ Path = 'b/two.md'; Code = 'ADR-WIDGET-PART'; Rule = 2; Source = 'head' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = 2; Source = 'link' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = 2; Source = 'head' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-WIDGET-PART'; Rule = $null; Source = 'link' }
            [pscustomobject]@{ Path = 'a/one.md'; Code = 'ADR-GADGET-SPEC'; Rule = 1; Source = 'head' }
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
        @($groups | ForEach-Object { "$($_.Code)#$($_.Rule)" }) | Should -Be @('ADR-GADGET-SPEC#1', 'ADR-WIDGET-PART#', 'ADR-WIDGET-PART#2')
        $part2 = $groups[2]
        @($part2.Documents) | Should -Be @('a/one.md', 'b/two.md')
        $part2.Count | Should -Be 2
    }

    It 'groups by document: one row per file, its citations sorted without duplicates' {
        $groups = @(Invoke-Group $rows 'Document')
        @($groups.Path) | Should -Be @('a/one.md', 'b/two.md')
        @($groups[0].Citations) | Should -Be @('ADR-GADGET-SPEC#1', 'ADR-WIDGET-PART', 'ADR-WIDGET-PART#2')
        $groups[0].Count | Should -Be 3
    }

    It 'returns nothing for no rows' {
        @(Invoke-Group @() 'Rule').Count | Should -Be 0
        @(Invoke-Group @() 'Document').Count | Should -Be 0
    }
}
