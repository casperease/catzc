Describe 'Get-DrsCitationGraphViolations' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE' {
    BeforeAll {
        $drs = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
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
                '### Rule ADR-WI-ONE-SPIN'                                                               # 5
                ''                                                                                       # 6
                'A widget cites its own ADR-WI-ONE-LEAN and the ADR-WI-* family.'                        # 7
                ''                                                                                       # 8
                '### Rule ADR-WI-ONE-LEAN'                                                               # 9
                ''                                                                                       # 10
                'A widget leans on ADR-GA-ONE-APPLY and [gadget-one](../gadget/gadget-one.md#rule-adr-ga-one-apply), and ADR-GZ-ONE-TURN.' # 11
                ''                                                                                       # 12
                '- [Context](#context)'                                                                  # 13
                ''                                                                                       # 14
                '## Context'                                                                             # 15
                ''                                                                                       # 16
                'Body prose cites ADR-GZ-ONE-BUILD and [gizmo-one](../gizmo/gizmo-one.md) too.'           # 17
            )
            'gadget/gadget-one.md' = @(
                '# Gadget one'                                                                           # 1
                ''                                                                                       # 2
                '## Rules: ADR-GA-ONE'                                                                   # 3
                ''                                                                                       # 4
                '### Rule ADR-GA-ONE-APPLY'                                                              # 5
                ''                                                                                       # 6
                'A gadget applies ADR-WI-ONE-SPIN ([widget-one](../widget/widget-one.md)), its ADR-GA-* siblings, and ADR-ZZ-NOPE-SPIN.' # 7
                'It links [the index](../index.md) and [a reference](../../references/gizmo.md).'        # 8
                ''                                                                                       # 9
                '## Context'                                                                             # 10
                ''                                                                                       # 11
                'Body prose may cite ADR-WI-ONE-SPIN, a declared dependency.'                            # 12
                '```text'                                                                                # 13
                'A fence is not read: ADR-GZ-ONE-BUILD.'                                                 # 14
                '```'                                                                                    # 15
            )
            'gizmo/gizmo-one.md'   = @(
                '# Gizmo one'                                                                            # 1
                ''                                                                                       # 2
                '## Rules: ADR-GZ-ONE'                                                                   # 3
                ''                                                                                       # 4
                '### Rule ADR-GZ-ONE-BUILD'                                                              # 5
                ''                                                                                       # 6
                'A gizmo builds on ADR-GA-ONE-APPLY, and on ADR-WI-ONE-LEAN only through gadget.'        # 7
                'Every ADR-WI-* rule is out of reach too.'                                               # 8
            )
            'index.md'             = @('# Index')
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $root $relative
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($files[$relative] -join "`n"))
        }
        $script:findings = InModuleScope Catzc.Base.Drs -Parameters @{ Drs = $drs; Root = $root } {
            $index = Get-DrsFileIndex @($Drs.RuleSets) -DrsRoot $Root
            Get-DrsCitationGraphViolations -Drs $Drs -Index $index
        }
    }

    It 'reports a citation of a domain the citing domain does not depend on, naming the rule, the code, and both domains' {
        $findings |
            Should -Contain 'docs/drs/widget/widget-one.md:11: ADR-WI-ONE-LEAN (widget) cites ADR-GA-ONE-APPLY (gadget); widget depends on: none'
        $findings |
            Should -Contain 'docs/drs/widget/widget-one.md:11: ADR-WI-ONE-LEAN (widget) cites ADR-GZ-ONE-TURN (gizmo); widget depends on: none'
    }

    It 'reads depends_on as declared, not transitively, and resolves a wildcard code to its domain' {
        $findings |
            Should -Contain 'docs/drs/gizmo/gizmo-one.md:7: ADR-GZ-ONE-BUILD (gizmo) cites ADR-WI-ONE-LEAN (widget); gizmo depends on: gadget'
        $findings |
            Should -Contain 'docs/drs/gizmo/gizmo-one.md:8: ADR-GZ-ONE-BUILD (gizmo) cites ADR-WI (widget); gizmo depends on: gadget'
    }

    It 'reports each cited domain once per line, though a citation and a link both name it' {
        $findings | Where-Object { $_ -like '*:11:*(gadget)*' } | Should -HaveCount 1
    }

    It 'reports a body citation outside the rule registry, naming the ADR as the citer' {
        $findings |
            Should -Contain 'docs/drs/widget/widget-one.md:17: ADR-WI-ONE (widget) cites ADR-GZ-ONE-BUILD (gizmo); widget depends on: none'
    }

    It 'allows the own domain and a declared dependency in the body too, and ignores unknown codes, links outside the domains, and fences' {
        $findings | Should -HaveCount 5
        $findings | Where-Object { $_ -like 'docs/drs/gadget/*' } | Should -HaveCount 0
    }

    It 'reports a link-only citation by its target' {
        $linkOnly = Join-Path $TestDrive 'link-only'
        $relative = 'widget/widget-one.md'
        $path = Join-Path $linkOnly "adr/$relative"
        [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
        [System.IO.File]::WriteAllText($path,
            "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-SPIN`n`nSee [gadget-one](../gadget/gadget-one.md).`n")
        $found = InModuleScope Catzc.Base.Drs -Parameters @{ Drs = $drs; Root = (Join-Path $linkOnly 'adr') } {
            $index = Get-DrsFileIndex @($Drs.RuleSets) -DrsRoot $Root
            Get-DrsCitationGraphViolations -Drs $Drs -Index $index
        }
        $found |
            Should -Be @('docs/drs/widget/widget-one.md:7: ADR-WI-ONE-SPIN (widget) cites ../gadget/gadget-one.md (gadget); widget depends on: none')
    }
}
