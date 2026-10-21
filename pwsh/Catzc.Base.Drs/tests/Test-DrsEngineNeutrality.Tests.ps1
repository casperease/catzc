<#
---
catzc:
  immutable:
    with_body_sha: "80f33bf35c4c"
  edges:
    docs: "[Test-DrsEngineNeutrality.Tests.ps1.md](docs/references/pwsh/catzc-base-drs/tests/Test-DrsEngineNeutrality.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/Test-DrsEngineNeutrality.ps1
    cites:
      - ADR-AUTO-ENGINE-THREEENGINES
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-QUALITYGATE
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'Test-DrsEngineNeutrality' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE', 'ADR-AUTO-ENGINE-THREEENGINES' {
    BeforeAll {
        $script:adrs = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{
                            'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' }
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }   # no ADR file: a Test-DrsRegistry finding
                        }
                    }
                }
            })
        $script:out = Join-Path $TestDrive 'out'

        function New-ChecksConfig {
            param([string] $Mode, [string[]] $Domains = @('gadget'))
            [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                    engine_neutrality = [ordered]@{
                        mode    = $Mode
                        domains = $Domains
                        tokens  = [ordered]@{ 'gizmo-variable' = '\$gizmo:'; 'gizmo-file' = '\.gz1\b' }
                    }
                })
        }

        $files = [ordered]@{
            'widget/widget-one.md' = @(
                '# Widget one'
                ''
                '## Rules: ADR-WI-ONE'
                ''
                '### Rule ADR-WI-ONE-READ'
                ''
                'A widget may read `$gizmo:HOME`; its domain is not checked.'
            )
            'gadget/gadget-one.md' = @(
                '# Gadget one'                                                     # 1
                ''                                                                 # 2
                '## Rules: ADR-GA-ONE'                                             # 3
                ''                                                                 # 4
                '### Rule ADR-GA-ONE-RUN'                                          # 5
                ''                                                                 # 6
                'A gadget reads `$gizmo:HOME` and `$gizmo:PATH`, then runs `spin.gz1`.' # 7
                'Naming the catzc command `Get-Gadget` is allowed.'                 # 8
                ''                                                                 # 9
                '- [Context](#context)'                                            # 10
                ''                                                                 # 11
                '## Context'                                                       # 12
                ''                                                                 # 13
                'Body prose may show `$gizmo:HOME`.'                               # 14
            )
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $TestDrive "adr/$relative"
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($files[$relative] -join "`n"))
        }
    }

    BeforeEach {
        $script:checks = New-ChecksConfig -Mode 'report'
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs' } { $script:adrs }
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } { Join-Path $TestDrive 'adr' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'lists one finding per token and summary line, with every match, and skips other domains and body prose' {
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'adr-engine-neutrality'
        $result.Issues | Should -Be @(
            "docs/drs/gadget/gadget-one.md:7: ADR-GA-ONE-RUN: gizmo-variable — '`$gizmo:'"
            "docs/drs/gadget/gadget-one.md:7: ADR-GA-ONE-RUN: gizmo-file — '.gz1'"
        )
        $result.Facts['Mode'] | Should -Be 'report'
        $result.Facts['Domains'] | Should -Be 'gadget'
        $result.Facts['RuleSets'] | Should -Be 1
        $result.Facts['Lines'] | Should -Be 2
    }

    It 'prints the findings and their count in report mode, writes the report, and never throws' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        { Test-DrsEngineNeutrality -OutputFolder $out } | Should -Not -Throw
        Test-DrsEngineNeutrality -OutputFolder $out | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq '2 adr-engine-neutrality issue(s).' }
        # The report sits in a run folder below the output folder; the deeper levels are headroom.
        Get-ChildPath $out -File -Filter 'adr-engine-neutrality.md' -Depth 4 -Exclude @() | Should -Not -BeNullOrEmpty
    }

    It 'throws once listing every finding in gate mode' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $script:checks = New-ChecksConfig -Mode 'gate'
        $thrown = { Test-DrsEngineNeutrality -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-DrsEngineNeutrality failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*gizmo-file*'
    }

    It 'reports a configured domain that drs.yml does not declare' {
        $script:checks = New-ChecksConfig -Mode 'report' -Domains @('gizmo')
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("drs-checks.yml: engine_neutrality domain 'gizmo' is not a domain of drs.yml")
    }

    It 'passes in gate mode when no summary carries a token' {
        $script:checks = New-ChecksConfig -Mode 'gate' -Domains @('widget')
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } {
            $clean = Join-Path $TestDrive 'clean/adr'
            [void][System.IO.Directory]::CreateDirectory((Join-Path $clean 'widget'))
            [System.IO.File]::WriteAllText((Join-Path $clean 'widget/widget-one.md'), "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-SPIN`n`nA widget spins.`n")
            $clean
        }
        $result = Test-DrsEngineNeutrality -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Mode'] | Should -Be 'gate'
    }
}

Describe 'Test-DrsEngineNeutrality — real ADRs' -Tag 'L2', 'integrity', 'source-only' {
    It 'Test-DrsEngineNeutrality passes over the real ADRs' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-DrsEngineNeutrality -OutputFolder (Join-Path $TestDrive 'neutrality') } | Should -Not -Throw
    }
}
