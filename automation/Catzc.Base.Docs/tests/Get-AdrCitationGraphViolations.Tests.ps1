<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md
      source: automation/Catzc.Base.Docs/private/Get-AdrCitationGraphViolations.ps1
    adrs:
      - ADR-AUTO-TEST#{3,35}
---
#>

Describe 'Get-AdrCitationGraphViolations' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35' {
    BeforeAll {
        $adrs = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' } }
                    }
                    gizmo  = [ordered]@{
                        code = 'GZ'; role = 'implementation'; description = 'The gizmo implementation.'; depends_on = @('gadget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'gizmo-one' = [ordered]@{ external = 'ADR-GZ-ONE' } }
                    }
                }
            })
        $root = Join-Path $TestDrive 'adr'
        $files = [ordered]@{
            'widget/widget-one.md' = @(
                '# Widget one'                                                                           # 1
                ''                                                                                       # 2
                '## Rules: ADR-WI-ONE'                                                                   # 3
                ''                                                                                       # 4
                '### Rule ADR-WI-ONE:1'                                                                  # 5
                ''                                                                                       # 6
                'A widget cites its own ADR-WI-ONE#2 and the ADR-WI-* family.'                           # 7
                ''                                                                                       # 8
                '### Rule ADR-WI-ONE:2'                                                                  # 9
                ''                                                                                       # 10
                'A widget leans on ADR-GA-ONE#1 and [gadget-one](../gadget/gadget-one.md#rule-adr-ga-one1), and ADR-GZ-ONE#2.' # 11
                ''                                                                                       # 12
                '- [Context](#context)'                                                                  # 13
                ''                                                                                       # 14
                '## Context'                                                                             # 15
                ''                                                                                       # 16
                'Prose may point anywhere: ADR-GZ-ONE#1 and [gizmo-one](../gizmo/gizmo-one.md).'         # 17
            )
            'gadget/gadget-one.md' = @(
                '# Gadget one'                                                                           # 1
                ''                                                                                       # 2
                '## Rules: ADR-GA-ONE'                                                                   # 3
                ''                                                                                       # 4
                '### Rule ADR-GA-ONE:1'                                                                  # 5
                ''                                                                                       # 6
                'A gadget applies ADR-WI-ONE#1 ([widget-one](../widget/widget-one.md)), its ADR-GA-* siblings, and ADR-ZZ-NOPE#3.' # 7
                'It links [the index](../index.md) and [a reference](../../references/gizmo.md).'        # 8
            )
            'gizmo/gizmo-one.md'   = @(
                '# Gizmo one'                                                                            # 1
                ''                                                                                       # 2
                '## Rules: ADR-GZ-ONE'                                                                   # 3
                ''                                                                                       # 4
                '### Rule ADR-GZ-ONE:1'                                                                  # 5
                ''                                                                                       # 6
                'A gizmo builds on ADR-GA-ONE#1, and on ADR-WI-ONE#2 only through gadget.'               # 7
                'Every ADR-WI-* rule is out of reach too.'                                               # 8
            )
            'index.md'             = @('# Index')
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $root $relative
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($files[$relative] -join "`n"))
        }
        $script:findings = InModuleScope Catzc.Base.Docs -Parameters @{ Adrs = $adrs; Root = $root } {
            $index = Get-AdrFileIndex @($Adrs.RuleSets) -AdrRoot $Root
            Get-AdrCitationGraphViolations -Adrs $Adrs -Index $index
        }
    }

    It 'reports a citation of a domain the citing domain does not depend on, naming the rule, the code, and both domains' {
        $findings | Should -Contain 'docs/adr/widget/widget-one.md:11: ADR-WI-ONE#2 (widget) cites ADR-GA-ONE#1 (gadget); widget depends on: none'
        $findings | Should -Contain 'docs/adr/widget/widget-one.md:11: ADR-WI-ONE#2 (widget) cites ADR-GZ-ONE#2 (gizmo); widget depends on: none'
    }

    It 'reads depends_on as declared, not transitively, and resolves a wildcard code to its domain' {
        $findings | Should -Contain 'docs/adr/gizmo/gizmo-one.md:7: ADR-GZ-ONE#1 (gizmo) cites ADR-WI-ONE#2 (widget); gizmo depends on: gadget'
        $findings | Should -Contain 'docs/adr/gizmo/gizmo-one.md:8: ADR-GZ-ONE#1 (gizmo) cites ADR-WI (widget); gizmo depends on: gadget'
    }

    It 'reports each cited domain once per line, though a citation and a link both name it' {
        $findings | Where-Object { $_ -like '*:11:*(gadget)*' } | Should -HaveCount 1
    }

    It 'allows the own domain and a declared dependency, and ignores unknown codes, links outside the domains, and body prose' {
        $findings | Should -HaveCount 4
        $findings | Where-Object { $_ -like 'docs/adr/gadget/*' } | Should -HaveCount 0
        $findings | Where-Object { $_ -like '*:17:*' } | Should -HaveCount 0
    }

    It 'reports a link-only citation by its target' {
        $linkOnly = Join-Path $TestDrive 'link-only'
        $relative = 'widget/widget-one.md'
        $path = Join-Path $linkOnly "adr/$relative"
        [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
        [System.IO.File]::WriteAllText($path, "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE:1`n`nSee [gadget-one](../gadget/gadget-one.md).`n")
        $found = InModuleScope Catzc.Base.Docs -Parameters @{ Adrs = $adrs; Root = (Join-Path $linkOnly 'adr') } {
            $index = Get-AdrFileIndex @($Adrs.RuleSets) -AdrRoot $Root
            Get-AdrCitationGraphViolations -Adrs $Adrs -Index $index
        }
        $found | Should -Be @('docs/adr/widget/widget-one.md:7: ADR-WI-ONE#1 (widget) cites ../gadget/gadget-one.md (gadget); widget depends on: none')
    }
}
