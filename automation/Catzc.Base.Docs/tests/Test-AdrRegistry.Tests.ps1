# Test-AdrRegistry over a fixture docs/adr tree in $TestDrive and a fixture AdrsConfig (Get-Config and
# Resolve-RepoPath mocked), so each test pins one rule. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-AdrRegistry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
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
    }

    BeforeEach {
        $adr = Join-Path $TestDrive 'adr'
        if (Test-Path -LiteralPath $adr) {
            Remove-Item -LiteralPath $adr -Recurse -Force
        }
        Write-AdrFixture 'widget/widget-one.md' "# Widget one`n`n## Rules: ADR-WI-ONE`n"
        Write-AdrFixture 'gadget/sub/gadget-one.md' "# Gadget one`n`n## Rules: ADR-GA-ONE`n"
        Write-AdrFixture 'gadget/widget-one.md' "# Gadget widget`n`n## Rules: ADR-GA-WIDGET`n"
        Write-AdrFixture 'gadget/dora-explains.md' "# Dora explains`n"
        Write-AdrFixture 'index.md' "# Index`n"

        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq 'docs/adr' } { Join-Path $TestDrive 'adr' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes when every rule set has one file heading its external code and no rule file is unregistered' {
        $result = Test-AdrRegistry -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.RuleSets | Should -Be 3
        $result.Files | Should -Be 5
    }

    It 'throws once naming a missing, a duplicated, a mis-headed, and an unregistered rule file' {
        Remove-Item -LiteralPath (Join-Path $TestDrive 'adr/widget/widget-one.md')
        Write-AdrFixture 'gadget/other/gadget-one.md' "# Gadget one again`n`n## Rules: ADR-GA-ONE`n"
        Write-AdrFixture 'gadget/widget-one.md' "# Gadget widget`n`n## Rules: ADR-GA-GIZMO`n"
        Write-AdrFixture 'gadget/gizmo.md' "# Gizmo`n`n## Rules: ADR-GA-GIZMO`n"
        $thrown = { Test-AdrRegistry -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-AdrRegistry failed: 4 issue(s)*'
        $message | Should -Match 'ADR-WI-ONE: no ADR file docs/adr/widget/\*\*/widget-one\.md'
        $message | Should -Match 'ADR-GA-ONE: 2 ADR files named gadget-one\.md under docs/adr/gadget/'
        $message | Should -Match "docs/adr/gadget/widget-one\.md: must head its rule registry '## Rules: ADR-GA-WIDGET'"
        $message | Should -Match "docs/adr/gadget/gizmo\.md: declares '## Rules: ADR-GA-GIZMO' but no adrs\.yml rule set registers it"
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Write-AdrFixture 'widget/widget-one.md' "# Widget one`n"
        $result = Test-AdrRegistry -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'adr-registry'
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -Match "docs/adr/widget/widget-one\.md: must head its rule registry '## Rules: ADR-WI-ONE'"
    }
}
