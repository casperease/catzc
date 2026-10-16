<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-AdrUsageRow.Tests.ps1
    folder: tests
    name: get-adr-usage-row-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-AdrUsageRow' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:map = [Catzc.Base.Docs.AdrCitationMap]::new(
            @{ 'ADR-WIDGET-PART' = @{ path = 'docs/adr/widget/part.md'; rules = @(1, 2, 3) } },
            @('docs/adr/widget/part.md', 'docs/adr/index.md'))

        function script:Get-Rows {
            param([string] $Text, [string] $Path = 'docs/gadget/spec.md', $Form)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; Path = $Path; Map = $script:map; Form = $Form } {
                param($Text, $Path, $Map, $Form)
                if ($Form) {
                    Get-AdrUsageRow -Text $Text -Path $Path -Map $Map -Form $Form
                }
                else {
                    Get-AdrUsageRow -Text $Text -Path $Path -Map $Map
                }
            }
        }
    }

    It 'expands a group in a Markdown head into one row per rule' {
        $rows = @(Get-Rows "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-PART#{1,3}`n---`nbody`n")
        @($rows.Rule) | Should -Be @(1, 3)
        @($rows.Source | Sort-Object -Unique) | Should -Be @('head')
    }

    It 'keeps a bare code as the whole ADR' {
        $rows = @(Get-Rows "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-PART`n---`nbody`n")
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -BeNullOrEmpty
    }

    It 'reads a link to a rule and a link to the ADR, and skips a link no code owns' {
        $text = "---`ncatzc:`n  edges:`n    links:`n      - docs/adr/index.md`n      - docs/adr/widget/part.md`n      - docs/adr/widget/part.md#rule-adr-widget-part2`n---`nbody`n"
        $rows = @(Get-Rows $text)
        $rows.Count | Should -Be 2
        @($rows.Code | Sort-Object -Unique) | Should -Be @('ADR-WIDGET-PART')
        @($rows.Rule) | Should -Be @($null, 2)
        @($rows.Source | Sort-Object -Unique) | Should -Be @('link')
    }

    It 'skips a code or a rule the index does not register' {
        $rows = @(Get-Rows "---`ncatzc:`n  edges:`n    cites:`n      - ADR-GADGET-SPEC`n      - ADR-WIDGET-PART#{3,9}`n---`nbody`n")
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -Be 3
    }

    It 'returns nothing for a file without a head' {
        @(Get-Rows "plain`n").Count | Should -Be 0
    }
}
