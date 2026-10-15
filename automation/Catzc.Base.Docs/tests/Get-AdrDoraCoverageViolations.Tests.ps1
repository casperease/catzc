<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#4
---
#>

# Get-AdrDoraCoverageViolations — every rule set outside the domains its config exempts has exactly one section...
# [comment:1](/docs/references/automation/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md#comment1)
Describe 'Get-AdrDoraCoverageViolations' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35' {
    BeforeAll {
        $script:adrs = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{
                            'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' }
                            'widget-two' = [ordered]@{ external = 'ADR-WI-TWO' }
                        }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{
                            'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' }
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }   # no ADR file: a Test-AdrRegistry finding
                        }
                    }
                    gizmo  = [ordered]@{
                        code = 'GZ'; role = 'reference'; description = 'The gizmo reference.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'gizmo-one' = [ordered]@{ external = 'ADR-GZ-ONE' } }
                    }
                }
            })
        $script:root = Join-Path $TestDrive 'adr'
        $files = [ordered]@{
            'widget/widget-one.md'     = @('# Widget one')
            'widget/sub/widget-two.md' = @('# Widget two')
            'gadget/gadget-one.md'     = @('# Gadget one')
            'gizmo/gizmo-one.md'       = @('# Gizmo one')
            'widget/dora-explains.md'  = @(
                '# Widget DORA'                                                       # 1
                ''                                                                    # 2
                'The intro links [widget-two](sub/widget-two.md), outside a section.' # 3
                ''                                                                    # 4
                '## Widget one'                                                       # 5
                ''                                                                    # 6
                '[ADR-WI-ONE](widget-one.md)'                                         # 7
                ''                                                                    # 8
                '- [A capability](../../references/gizmo/capabilities.md#gizmo)'      # 9
            )
            'gadget/dora-explains.md'  = @(
                '# Gadget DORA'                                                       # 1
                ''                                                                    # 2
                '## Gadget one'                                                       # 3
                ''                                                                    # 4
                '`gadget.yml` · [ADR-GA-ONE](gadget-one.md#rules-adr-ga-one)'          # 5
                ''                                                                    # 6
                '## Gadget one, again'                                                # 7
                ''                                                                    # 8
                '[ADR-GA-ONE](gadget-one.md)'                                         # 9
                '```text'                                                             # 10
                '## not a section inside a fence'                                     # 11
                '```'                                                                 # 12
            )
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $root $relative
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($files[$relative] -join "`n"))
        }

        function Get-Finding {
            param([System.Collections.IDictionary] $Settings)
            $check = [Catzc.Base.Docs.AdrChecksConfig]::new([ordered]@{ dora_coverage = $Settings }).dora_coverage
            InModuleScope Catzc.Base.Docs -Parameters @{ Adrs = $script:adrs; Root = $script:root; Check = $check } {
                $index = Get-AdrFileIndex @($Adrs.RuleSets) -AdrRoot $Root
                Get-AdrDoraCoverageViolations -Adrs $Adrs -Index $index -Settings $Check
            }
        }
        $script:findings = Get-Finding ([ordered]@{})
    }

    It 'reports a rule set no section links, even when a link outside any section names it' {
        $findings | Should -Contain 'docs/adr/widget/dora-explains.md: no section links ADR-WI-TWO (docs/adr/widget/sub/widget-two.md)'
    }

    It 'reports a rule set two sections link, with both sections'' heading lines' {
        $findings | Should -Contain 'docs/adr/gadget/dora-explains.md:3,7: 2 sections link ADR-GA-ONE (docs/adr/gadget/gadget-one.md)'
    }

    It 'reports a domain without a DORA file once per rule set' {
        $findings | Should -Contain 'docs/adr/gizmo/dora-explains.md: missing, so no section links ADR-GZ-ONE'
    }

    It 'passes a rule set with exactly one section and skips one with no ADR file' {
        $findings | Should -HaveCount 3
        $findings | Where-Object { $_ -like '*ADR-WI-ONE*' -or $_ -like '*ADR-GA-TWO*' } | Should -HaveCount 0
    }

    It 'skips an exempt domain and reads the configured file name' -Tag 'ADR-PRIN-CONFIG#4' {
        $exempt = Get-Finding ([ordered]@{ exempt = [ordered]@{ gizmo = 'Gizmo is the reference itself.' } })
        $exempt | Where-Object { $_ -like '*gizmo*' } | Should -HaveCount 0
        $renamed = Get-Finding ([ordered]@{ file = 'gadget-notes.md'; exempt = [ordered]@{ gizmo = 'Gizmo is the reference itself.' } })
        $renamed | Should -Contain 'docs/adr/widget/gadget-notes.md: missing, so no section links ADR-WI-ONE'
    }

    It 'skips a rule set whose ADR lies in an exempt folder, and only that one' -Tag 'ADR-PRIN-CONFIG#4' {
        $exempt = Get-Finding ([ordered]@{ exempt_folders = [ordered]@{ 'widget/sub' = 'Widget sub answers a vendor checklist.' } })
        $exempt | Where-Object { $_ -like '*ADR-WI-TWO*' } | Should -HaveCount 0
        $exempt | Should -HaveCount 2
    }
}
