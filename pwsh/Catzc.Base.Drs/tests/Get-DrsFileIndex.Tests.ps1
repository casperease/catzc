<#
---
catzc:
  immutable:
    with_body_sha: "78e5fca3f172"
  edges:
    docs: "[Get-DrsFileIndex.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-drs/tests/Get-DrsFileIndex.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/private/Get-DrsFileIndex.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Get-DrsFileIndex' -Tag 'L0', 'logic' {
    BeforeAll {
        $adrs = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
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
        $script:index = InModuleScope Catzc.Base.Drs -Parameters @{ RuleSets = @($adrs.RuleSets); Root = $root } {
            Get-DrsFileIndex $RuleSets -DrsRoot $Root
        }
    }

    It 'lists every file relative to docs/drs/ with forward slashes' {
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

    It 'keys a file under the longest domain folder that holds it, so a domain folder nested in another keeps its own files' {
        $nested = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @()
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' } }
                    }
                    cog    = [ordered]@{
                        code = 'CO'; role = 'implementation'; description = 'The cog implementation.'; depends_on = @('gadget')
                        stack = 'AUTO'; concern = @('automation'); folder = 'gadget/cog'
                        rulesets = [ordered]@{ 'cog-one' = [ordered]@{ external = 'ADR-CO-ONE' } }
                    }
                }
            })
        $nestedRoot = Join-Path $TestDrive 'nested-adr'
        foreach ($relative in 'gadget/gadget-one.md', 'gadget/sub/note.md', 'gadget/cog/cog-one.md', 'gadget/cog/dora-explains.md', 'gadget/dora-explains.md') {
            $path = Join-Path $nestedRoot $relative
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, "# $relative`n")
        }
        $result = InModuleScope Catzc.Base.Drs -Parameters @{ RuleSets = @($nested.RuleSets); Root = $nestedRoot } {
            Get-DrsFileIndex $RuleSets -DrsRoot $Root
        }
        $result.FileOf['ADR-GA-ONE'] | Should -Be 'gadget/gadget-one.md'
        $result.FileOf['ADR-CO-ONE'] | Should -Be 'gadget/cog/cog-one.md'
        $result.ByKey['gadget/cog/dora-explains'] | Should -Be @('gadget/cog/dora-explains.md')
        $result.ByKey['gadget/dora-explains'] | Should -Be @('gadget/dora-explains.md')
        $result.ByKey['gadget/note'] | Should -Be @('gadget/sub/note.md')
    }
}
