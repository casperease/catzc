<#
---
catzc:
  immutable:
    with_body_sha: c7c709591ec0
  edges:
    code: pwsh/Catzc.Base.Slides/private/Get-DiagramMinimapReason.ps1
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
---
#>

Describe 'Get-DiagramMinimapReason' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-MINIMAPSFROMDATA' {
    BeforeAll {
        $script:read = {
            param([string] $Text)
            $path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).md"
            [System.IO.File]::WriteAllText($path, $Text)
            InModuleScope Catzc.Base.Slides -Parameters @{ Path = $path } { param($Path) @(Get-DiagramMinimapReason -Path $Path) }
        }
    }

    It 'reads one judged reason per lit minimap from the Minimap reasons section only' {
        $text = "# Widget flow`n`n## Claims`n`n- axis: not a reason, this section is not read`n`n## Minimap reasons`n`n" +
        "- axis: the ruleset ADR-WIDGET sits in the widget domain`n" +
        "- grid: widgets/Get-Widget.ps1 cites ADR-WIDGET-SPIN`n`n## After`n`n- grid: not read`n"
        $found = & $script:read $text
        $found | Should -HaveCount 2
        $found[0].Minimap | Should -Be 'axis'
        $found[0].Reason | Should -Be 'the ruleset ADR-WIDGET sits in the widget domain'
        $found[1].Minimap | Should -Be 'grid'
        $found[0].PSObject.Properties.Name | Should -Not -Contain 'Cell'
    }

    It 'joins a reason Prettier wrapped onto the next line' {
        $found = & $script:read "## Minimap reasons`n`n- grid: widgets/Get-Widget.ps1 cites`n  ADR-WIDGET-SPIN, the rule the gadget names`n"
        $found[0].Reason | Should -Be 'widgets/Get-Widget.ps1 cites ADR-WIDGET-SPIN, the rule the gadget names'
    }

    It 'throws on a minimap named twice' {
        { & $script:read "## Minimap reasons`n`n- grid: the widget files`n- grid: the gadget files`n" } | Should -Throw "*4: 'grid' is named twice*"
    }

    It 'reads nothing from a file without the section, or no file at all' {
        & $script:read "# Widget flow`n`nNo reasons here.`n" | Should -BeNullOrEmpty
        InModuleScope Catzc.Base.Slides -Parameters @{ Path = (Join-Path $TestDrive 'no-such-widget.md') } { param($Path) @(Get-DiagramMinimapReason -Path $Path) } |
            Should -BeNullOrEmpty
    }

    It 'names every malformed line and every unknown minimap in one throw' {
        { & $script:read "## Minimap reasons`n`n- grid without a colon`n- gizmo: no such minimap`n" } |
            Should -Throw "*3: '- grid without a colon' is not*4: 'gizmo' is not a minimap id*"
    }
}
