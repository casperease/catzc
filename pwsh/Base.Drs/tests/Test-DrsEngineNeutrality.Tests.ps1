Describe 'Test-DrsEngineNeutrality' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE', 'ADR-AUTO-ENGINE-THREEENGINES' {
    BeforeAll {
        $script:drs = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget    = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget    = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{
                            'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' }
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }   # no record file: a Test-DrsRegistry finding
                        }
                    }
                    sprocket  = [ordered]@{
                        code = 'SP'; role = 'architecture'; description = 'The sprocket flow.'; depends_on = @('widget')
                        stack = 'PIPE'; concern = @('build')
                        rulesets = [ordered]@{ 'sprocket-one' = [ordered]@{ external = 'ADR-SP-ONE' } }
                    }
                    doohickey = [ordered]@{
                        code = 'DO'; role = 'architecture'; description = 'The doohickey design.'; depends_on = @('widget')
                        stack = 'DSGN'; concern = @('build')
                        rulesets = [ordered]@{ 'doohickey-one' = [ordered]@{ external = 'ADR-DO-ONE' } }
                    }
                }
            })
        $script:out = Join-Path $TestDrive 'out'

        function New-ChecksConfig {
            param([string] $Mode, [System.Collections.IDictionary] $Domains = [ordered]@{ gadget = @('engine') })
            [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                    engine_neutrality = [ordered]@{
                        mode       = $Mode
                        domains    = $Domains
                        token_sets = [ordered]@{
                            engine = [ordered]@{ 'gizmo-variable' = '\$gizmo:'; 'gizmo-file' = '\.gz1\b' }
                            vendor = [ordered]@{ 'acme-name' = '\bAcme\b' }
                        }
                    }
                })
        }

        $files = [ordered]@{
            'widget/widget-one.md'       = @(
                '# Widget one'
                ''
                '## Rules: ADR-WI-ONE'
                ''
                '### Rule ADR-WI-ONE-READ'
                ''
                'A widget may read `$gizmo:HOME` on Acme; its domain is not checked.'
            )
            'gadget/gadget-one.md'       = @(
                '# Gadget one'                                                     # 1
                ''                                                                 # 2
                '## Rules: ADR-GA-ONE'                                             # 3
                ''                                                                 # 4
                '### Rule ADR-GA-ONE-RUN'                                          # 5
                ''                                                                 # 6
                'A gadget reads `$gizmo:HOME` and `$gizmo:PATH`, then runs `spin.gz1` on Acme.' # 7
                'Naming the catzc command `Get-Gadget` is allowed.'                 # 8
                ''                                                                 # 9
                '- [Context](#context)'                                            # 10
                ''                                                                 # 11
                '## Context'                                                       # 12
                ''                                                                 # 13
                'Body prose may show `$gizmo:HOME`.'                               # 14
            )
            'sprocket/sprocket-one.md'   = @(
                '# Sprocket one'
                ''
                '## Rules: ADR-SP-ONE'
                ''
                '### Rule ADR-SP-ONE-TURN'
                ''
                'A sprocket turns on Acme and may read `$gizmo:HOME`.'
            )
            'doohickey/doohickey-one.md' = @(
                '# Doohickey one'
                ''
                '## Rules: ADR-DO-ONE'
                ''
                '### Rule ADR-DO-ONE-SHAPE'
                ''
                'A doohickey shapes `spin.gz1` on Acme.'
            )
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $TestDrive "drs/$relative"
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($files[$relative] -join "`n"))
        }
    }

    BeforeEach {
        $script:checks = New-ChecksConfig -Mode 'report'
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs' } { $script:drs }
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } { Join-Path $TestDrive 'drs' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'lists one finding per token and summary line, with every match, and skips other domains, other sets and body prose' {
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'drs-engine-neutrality'
        $result.Issues | Should -Be @(
            "docs/drs/gadget/gadget-one.md:7: ADR-GA-ONE-RUN: gizmo-variable — '`$gizmo:'"
            "docs/drs/gadget/gadget-one.md:7: ADR-GA-ONE-RUN: gizmo-file — '.gz1'"
        )
        $result.Facts['Mode'] | Should -Be 'report'
        $result.Facts['Domains'] | Should -Be 'gadget (engine)'
        $result.Facts['RuleSets'] | Should -Be 1
        $result.Facts['Lines'] | Should -Be 2
    }

    It 'holds a domain to the vendor set only, leaving engine syntax alone' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $script:checks = New-ChecksConfig -Mode 'report' -Domains ([ordered]@{ sprocket = @('vendor') })
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("docs/drs/sprocket/sprocket-one.md:7: ADR-SP-ONE-TURN: acme-name — 'Acme'")
        $result.Facts['Domains'] | Should -Be 'sprocket (vendor)'
    }

    It 'holds a domain to both sets, engine tokens first' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $script:checks = New-ChecksConfig -Mode 'report' -Domains ([ordered]@{ doohickey = @('engine', 'vendor') })
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Issues | Should -Be @(
            "docs/drs/doohickey/doohickey-one.md:7: ADR-DO-ONE-SHAPE: gizmo-file — '.gz1'"
            "docs/drs/doohickey/doohickey-one.md:7: ADR-DO-ONE-SHAPE: acme-name — 'Acme'"
        )
        $result.Facts['Domains'] | Should -Be 'doohickey (engine+vendor)'
    }

    It 'prints the findings and their count in report mode, writes the report, and never throws' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        { Test-DrsEngineNeutrality -OutputFolder $out } | Should -Not -Throw
        Test-DrsEngineNeutrality -OutputFolder $out | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq '2 drs-engine-neutrality issue(s).' }
        # The report sits in a run folder below the output folder; the deeper levels are headroom.
        Get-ChildPath $out -File -Filter 'drs-engine-neutrality.md' -Depth 4 -Exclude @() | Should -Not -BeNullOrEmpty
    }

    It 'throws once listing every finding in gate mode' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $script:checks = New-ChecksConfig -Mode 'gate'
        $thrown = { Test-DrsEngineNeutrality -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-DrsEngineNeutrality failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*gizmo-file*'
    }

    It 'reports a configured domain that drs.yml does not declare' {
        $script:checks = New-ChecksConfig -Mode 'report' -Domains ([ordered]@{ gizmo = @('engine') })
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("drs-checks.yml: engine_neutrality domain 'gizmo' is not a domain of drs.yml")
    }

    It 'passes in gate mode when no summary carries a token' {
        $script:checks = New-ChecksConfig -Mode 'gate' -Domains ([ordered]@{ widget = @('engine', 'vendor') })
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } {
            $clean = Join-Path $TestDrive 'clean/drs'
            [void][System.IO.Directory]::CreateDirectory((Join-Path $clean 'widget'))
            [System.IO.File]::WriteAllText((Join-Path $clean 'widget/widget-one.md'),
                "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-SPIN`n`nA widget spins.`n")
            $clean
        }
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Mode'] | Should -Be 'gate'
    }
}

Describe 'Test-DrsEngineNeutrality — real records' -Tag 'L2', 'integrity', 'source-only' {
    It 'Test-DrsEngineNeutrality passes over the real records' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-DrsEngineNeutrality -OutputFolder (Join-Path $TestDrive 'neutrality') } | Should -Not -Throw
    }
}
