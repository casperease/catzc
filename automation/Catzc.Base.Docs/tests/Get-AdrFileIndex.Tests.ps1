<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1
    folder: tests
    name: get-adr-file-index-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/Get-AdrFileIndex.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-AdrFileIndex' -Tag 'L0', 'logic' {
    BeforeAll {
        $adrs = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{
                            'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' }
                            'widget-two' = [ordered]@{ external = 'ADR-WI-TWO' }   # two files
                            'widget-six' = [ordered]@{ external = 'ADR-WI-SIX' }   # no file
                        }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-GA-WIDGET' } }   # same slug, other domain
                    }
                }
            })
        $root = Join-Path $TestDrive 'adr'
        foreach ($relative in 'widget/widget-one.md', 'widget/widget-two.md', 'widget/sub/widget-two.md', 'gadget/widget-one.md', 'index.md') {
            $path = Join-Path $root $relative
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, "# $relative`n")
        }
        $script:index = InModuleScope Catzc.Base.Docs -Parameters @{ RuleSets = @($adrs.RuleSets); Root = $root } {
            Get-AdrFileIndex $RuleSets -AdrRoot $Root
        }
    }

    It 'lists every file relative to docs/adr/ with forward slashes' {
        $index.Relative | Sort-Object | Should -Be @('gadget/widget-one.md', 'index.md', 'widget/sub/widget-two.md', 'widget/widget-one.md', 'widget/widget-two.md')
    }

    It 'keys files by domain folder and slug, so a shared slug stays distinct and a repeated one collects both files' {
        $index.ByKey['widget/widget-one'] | Should -Be @('widget/widget-one.md')
        $index.ByKey['gadget/widget-one'] | Should -Be @('gadget/widget-one.md')
        $index.ByKey['widget/widget-two'] | Should -HaveCount 2
        $index.ByKey['/index'] | Should -Be @('index.md')
    }

    It 'maps a rule set to its file only when exactly one file has its key' {
        $index.FileOf['ADR-WI-ONE'] | Should -Be 'widget/widget-one.md'
        $index.FileOf['ADR-GA-WIDGET'] | Should -Be 'gadget/widget-one.md'
        $index.FileOf.ContainsKey('ADR-WI-TWO') | Should -BeFalse
        $index.FileOf.ContainsKey('ADR-WI-SIX') | Should -BeFalse
    }
}
