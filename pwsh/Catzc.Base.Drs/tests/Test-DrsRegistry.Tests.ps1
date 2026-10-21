<#
---
catzc:
  immutable:
    with_body_sha: e16cb2ea0720
  edges:
    docs: "[Test-DrsRegistry.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/Test-DrsRegistry.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/Test-DrsRegistry.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-DRSCODE-PATHOFSEGMENTS
      - ADR-REPO-DRSCODE-DOMAINSEGMENT
      - ADR-REPO-DRSCODE-NAMEDNOTNUMBERED
      - ADR-REPO-DRSCODE-ONESTRINGONEFACT
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'Test-DrsRegistry' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
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
                            'widget-one' = [ordered]@{ external = 'ADR-GA-WIDGET' } # same slug as widget's, other domain
                        }
                    }
                }
            })
        $script:out = Join-Path $TestDrive 'out'

        function Write-AdrFixture {
            param([string] $Relative, [string] $Text)
            $path = Join-Path $TestDrive "adr/$Relative"
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, $Text)
        }

        function New-ChecksConfig {
            param([string] $CitationGraph, [string] $DoraCoverage, [string] $CodeLanguage = 'report')
            [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                    citation_graph = [ordered]@{ mode = $CitationGraph }
                    dora_coverage  = [ordered]@{ mode = $DoraCoverage }
                    code_language  = [ordered]@{ mode = $CodeLanguage }
                })
        }
    }

    BeforeEach {
        $adr = Join-Path $TestDrive 'adr'
        if (Test-Path -LiteralPath $adr) {
            Remove-Item -LiteralPath $adr -Recurse -Force
        }
        if (Test-Path -LiteralPath $out) {
            Remove-Item -LiteralPath $out -Recurse -Force
        }
        Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n"
        Write-AdrFixture 'gadget/sub/gadget-one.md' "# Gadget one`n`n## Rules: ADR-GA-ONE`n"
        Write-AdrFixture 'gadget/widget-one.md' "# Gadget widget`n`n## Rules: ADR-GA-WIDGET`n"
        Write-AdrFixture 'gadget/dora-explains.md' "# Dora explains`n"
        Write-AdrFixture 'index.md' "# Index`n"

        $script:checks = New-ChecksConfig -CitationGraph 'report' -DoraCoverage 'report'
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'adr-checks' } { $script:checks }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } { Join-Path $TestDrive 'adr' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    Context 'the registry and its files' {
        It 'passes when every rule set has one file heading its external code and no rule file is unregistered' {
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.IssueCount | Should -Be 0
            $result.Facts['RuleSets'] | Should -Be 3
            $result.Facts['Files'] | Should -Be 5
        }

        It 'throws once naming a missing, a duplicated, a mis-headed, and an unregistered rule file' {
            Remove-Item -LiteralPath (Join-Path $TestDrive 'adr/widget/widget-one.md')
            Write-AdrFixture 'gadget/other/gadget-one.md' "# Gadget one again`n`n## Rules: ADR-GA-ONE`n"
            Write-AdrFixture 'gadget/widget-one.md' "# Gadget widget`n`n## Rules: ADR-GA-GIZMO`n"
            Write-AdrFixture 'gadget/gizmo.md' "# Gizmo`n`n## Rules: ADR-GA-GIZMO`n"
            $thrown = { Test-DrsRegistry -OutputFolder $out } | Should -Throw -PassThru
            $message = $thrown.Exception.Message
            $message | Should -BeLike 'Test-DrsRegistry failed: 4 issue(s)*'
            $message | Should -Match 'ADR-WI-ONE: no ADR file docs/drs/widget/\*\*/widget-one\.md'
            $message | Should -Match 'ADR-GA-ONE: 2 ADR files named gadget-one\.md under docs/drs/gadget/'
            $message | Should -Match "docs/drs/gadget/widget-one\.md: must head its rule registry '## Rules: ADR-GA-WIDGET'"
            $message | Should -Match "docs/drs/gadget/gizmo\.md: declares '## Rules: ADR-GA-GIZMO' but no adrs\.yml rule set registers it"
        }

        It 'returns the issues under -PassThru instead of throwing' {
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n"
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.Subject | Should -Be 'adr-registry'
            $result.Issues | Should -HaveCount 1
            $result.Issues[0] | Should -Match "docs/drs/widget/widget-one\.md: must head its rule registry '## Rules: ADR-WI-ONE'"
        }
    }

    Context 'the configured checks' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        BeforeEach {
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-LEAN`n`nA widget leans on ADR-GA-ONE-APPLY.`n"
        }

        It 'prints a report-mode check''s findings in its own report and never fails the run' {
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.IssueCount | Should -Be 0
            $result.Facts['CitationGraphMode'] | Should -Be 'report'
            $result.Facts['CitationGraphFindings'] | Should -Be 1
            $result.Facts['CitationGraph'] | Should -Be @('docs/drs/widget/widget-one.md:7: ADR-WI-ONE-LEAN (widget) cites ADR-GA-ONE-APPLY (gadget); widget depends on: none')
            $result.Facts['DoraCoverageMode'] | Should -Be 'report'
            $result.Facts['DoraCoverage'] | Should -Be @(
                'docs/drs/widget/dora-explains.md: missing, so no section links ADR-WI-ONE'
                'docs/drs/gadget/dora-explains.md: no section links ADR-GA-ONE (docs/drs/gadget/sub/gadget-one.md)'
                'docs/drs/gadget/dora-explains.md: no section links ADR-GA-WIDGET (docs/drs/gadget/widget-one.md)'
            )
            Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq '1 adr-citation-graph issue(s).' }
            Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq '3 adr-dora-coverage issue(s).' }
            # The report sits in a run folder below its subject folder; the deeper levels are headroom.
            Get-ChildPath (Join-Path $out 'adr-citation-graph') -File -Filter 'adr-citation-graph.md' -Depth 3 -Exclude @() | Should -Not -BeNullOrEmpty
            { Test-DrsRegistry -OutputFolder $out } | Should -Not -Throw
        }

        It 'adds a gate-mode check''s findings to the gate''s issues' {
            $script:checks = New-ChecksConfig -CitationGraph 'gate' -DoraCoverage 'report'
            $thrown = { Test-DrsRegistry -OutputFolder $out } | Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike 'Test-DrsRegistry failed: 1 issue(s)*'
            $thrown.Exception.Message | Should -BeLike '*ADR-WI-ONE-LEAN (widget) cites ADR-GA-ONE-APPLY (gadget)*'
        }

        It 'passes a gate-mode DORA-coverage check when every rule set has exactly one section' {
            $script:checks = New-ChecksConfig -CitationGraph 'report' -DoraCoverage 'gate'
            Write-AdrFixture 'widget/dora-explains.md' "# Dora`n`n## Widget one`n`n[ADR-WI-ONE](widget-one.md)`n"
            Write-AdrFixture 'gadget/dora-explains.md' "# Dora`n`n## Gadget one`n`n[ADR-GA-ONE](sub/gadget-one.md)`n`n## Widget`n`n[ADR-GA-WIDGET](widget-one.md)`n"
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.IssueCount | Should -Be 0
            $result.Facts['DoraCoverageMode'] | Should -Be 'gate'
            $result.Facts['DoraCoverageFindings'] | Should -Be 0
        }
    }

    Context 'the code-language check' -Tag 'ADR-REPO-DRSCODE-PATHOFSEGMENTS' {
        BeforeAll {
            $script:sharedFixture = $script:fixture
        }

        AfterEach {
            $script:fixture = $script:sharedFixture
        }

        It 'counts a file''s numbered rule headings as one finding' {
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE:1`n`n### Rule ADR-WI-ONE:2`n"
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.IssueCount | Should -Be 0
            $result.Facts['CodeLanguageMode'] | Should -Be 'report'
            $result.Facts['CodeLanguage'] | Should -Be @('docs/drs/widget/widget-one.md: 2 numbered rule heading(s); a rule is named, never numbered (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)')
        }

        It 'passes named rule headings that are one segment below their ADR' {
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-SPINS`n`n``````text`n### Rule ADR-WI-ONE:9`n```````n"
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.Facts['CodeLanguageFindings'] | Should -Be 0
        }

        It 'reports a heading of two segments, a heading under another code, a rule named like an ADR, and a code outside its domain' {
            $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                    domains = [ordered]@{
                        widget = [ordered]@{
                            code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                            stack = 'PRIN'; concern = @('build')
                            rulesets = [ordered]@{
                                'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' }
                                'widget-two' = [ordered]@{ external = 'ADR-WI-ONE-TWO' }
                                'gizmo'      = [ordered]@{ external = 'ADR-GIZMO' }
                            }
                        }
                    }
                })
            Write-AdrFixture 'widget/widget-one.md' (
                "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE-SPINS-FREELY`n`n### Rule ADR-GA-ONE-SPINS`n`n### Rule ADR-WI-ONE-TWO`n")
            Write-AdrFixture 'widget/widget-two.md' "# Widget two`n`n## Rules: ADR-WI-ONE-TWO`n"
            Write-AdrFixture 'widget/gizmo.md' "# Gizmo`n`n## Rules: ADR-GIZMO`n"
            Remove-Item -LiteralPath (Join-Path $TestDrive 'adr/gadget') -Recurse -Force
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.Facts['CodeLanguage'] | Should -Be @(
                "docs/drs/widget/widget-one.md:5: '### Rule ADR-WI-ONE-SPINS-FREELY' is not ADR-WI-ONE plus one named segment (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)"
                "docs/drs/widget/widget-one.md:7: '### Rule ADR-GA-ONE-SPINS' is not ADR-WI-ONE plus one named segment (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)"
                'docs/drs/widget/widget-one.md:9: rule ADR-WI-ONE-TWO shares its name with the ADR ADR-WI-ONE-TWO (ADR-REPO-DRSCODE-ONESTRINGONEFACT)'
                "ADR-GIZMO (widget): does not start with its domain's prefix, ADR-WI- (ADR-REPO-DRSCODE-DOMAINSEGMENT)"
            )
        }

        It 'reports a domain code of two segments once and holds its ADRs to the first segment' {
            $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                    domains = [ordered]@{
                        widget = [ordered]@{
                            code = 'WI-SPIN'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                            stack = 'PRIN'; concern = @('build')
                            rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-SPIN' } }
                        }
                    }
                })
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-SPIN`n"
            Remove-Item -LiteralPath (Join-Path $TestDrive 'adr/gadget') -Recurse -Force
            $result = Test-DrsRegistry -OutputFolder $out -PassThru
            $result.Facts['CodeLanguage'] | Should -Be @('widget: domain code WI-SPIN is not one segment (ADR-REPO-DRSCODE-DOMAINSEGMENT)')
        }

        It 'adds its findings to the gate''s issues in gate mode' {
            $script:checks = New-ChecksConfig -CitationGraph 'report' -DoraCoverage 'report' -CodeLanguage 'gate'
            Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n`n### Rule ADR-WI-ONE:1`n"
            $thrown = { Test-DrsRegistry -OutputFolder $out } | Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike '*widget-one.md: 1 numbered rule heading(s)*'
        }
    }
}

Describe 'Test-DrsRegistry — real ADRs' -Tag 'L2', 'integrity', 'source-only' {
    It 'Test-DrsRegistry passes over the real registry and ADRs' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-DrsRegistry -OutputFolder (Join-Path $TestDrive 'registry') } | Should -Not -Throw
    }
}
