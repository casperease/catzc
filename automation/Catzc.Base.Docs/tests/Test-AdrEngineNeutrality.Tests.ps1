<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md
      source: automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#{3,35}
      - ADR-PRIN-CONFIG#1
---
#>

Describe 'Test-AdrEngineNeutrality' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35', 'ADR-AUTO-ENGINE#1' {
    BeforeAll {
        $script:adrs = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
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
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }   # no ADR file: a Test-AdrRegistry finding
                        }
                    }
                }
            })
        $script:out = Join-Path $TestDrive 'out'

        function New-ChecksConfig {
            param([string] $Mode, [string[]] $Domains = @('gadget'))
            [Catzc.Base.Docs.AdrChecksConfig]::new([ordered]@{
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
                '### Rule ADR-WI-ONE:1'
                ''
                'A widget may read `$gizmo:HOME`; its domain is not checked.'
            )
            'gadget/gadget-one.md' = @(
                '# Gadget one'                                                     # 1
                ''                                                                 # 2
                '## Rules: ADR-GA-ONE'                                             # 3
                ''                                                                 # 4
                '### Rule ADR-GA-ONE:1'                                            # 5
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
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:adrs }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adr-checks' } { $script:checks }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq 'docs/adr' } { Join-Path $TestDrive 'adr' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'lists one finding per token and summary line, with every match, and skips other domains and body prose' {
        $result = Test-AdrEngineNeutrality -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'adr-engine-neutrality'
        $result.Issues | Should -Be @(
            "docs/adr/gadget/gadget-one.md:7: ADR-GA-ONE#1: gizmo-variable — '`$gizmo:'"
            "docs/adr/gadget/gadget-one.md:7: ADR-GA-ONE#1: gizmo-file — '.gz1'"
        )
        $result.Mode | Should -Be 'report'
        $result.Domains | Should -Be 'gadget'
        $result.RuleSets | Should -Be 1
        $result.Lines | Should -Be 2
    }

    It 'prints the findings and their count in report mode, writes the report, and never throws' -Tag 'ADR-PRIN-CONFIG#1' {
        { Test-AdrEngineNeutrality -OutputFolder $out } | Should -Not -Throw
        Test-AdrEngineNeutrality -OutputFolder $out | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq '2 adr-engine-neutrality issue(s).' }
        # The report sits in a run folder below the output folder; the deeper levels are headroom.
        Get-ChildPath $out -File -Filter 'adr-engine-neutrality.md' -Depth 4 -Exclude @() | Should -Not -BeNullOrEmpty
    }

    It 'throws once listing every finding in gate mode' -Tag 'ADR-PRIN-CONFIG#1' {
        $script:checks = New-ChecksConfig -Mode 'gate'
        $thrown = { Test-AdrEngineNeutrality -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-AdrEngineNeutrality failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*gizmo-file*'
    }

    It 'reports a configured domain that adrs.yml does not declare' {
        $script:checks = New-ChecksConfig -Mode 'report' -Domains @('gizmo')
        $result = Test-AdrEngineNeutrality -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("adr-checks.yml: engine_neutrality domain 'gizmo' is not a domain of adrs.yml")
    }

    It 'passes in gate mode when no summary carries a token' {
        $script:checks = New-ChecksConfig -Mode 'gate' -Domains @('widget')
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq 'docs/adr' } {
            $clean = Join-Path $TestDrive 'clean/adr'
            [void][System.IO.Directory]::CreateDirectory((Join-Path $clean 'widget'))
            [System.IO.File]::WriteAllText((Join-Path $clean 'widget/widget-one.md'), "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE:1`n`nA widget spins.`n")
            $clean
        }
        $result = Test-AdrEngineNeutrality -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Mode | Should -Be 'gate'
    }
}

Describe 'Test-AdrEngineNeutrality — real ADRs' -Tag 'L2', 'integrity', 'source-only' {
    It 'Test-AdrEngineNeutrality passes over the real ADRs' -Tag 'ADR-AUTO-TEST#35' {
        { Test-AdrEngineNeutrality -OutputFolder (Join-Path $TestDrive 'neutrality') } | Should -Not -Throw
    }
}
