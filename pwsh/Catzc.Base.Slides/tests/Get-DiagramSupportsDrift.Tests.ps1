Describe 'Get-DiagramSupportsDrift' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-DECLARATION' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/widgets/.assets')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/.assets/widget-flow.drawio.yml'), "about:`n  adrs: [ADR-WIDGET-ONE, ADR-WIDGET-TWO]`n  lens: architecture`ncontent:`n  title: Widgets`n")
        $script:page = 'docs/widgets/widget-flow.md'
        $script:drift = {
            param([string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:root $script:page), $Text)
            InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root; Page = $script:page } {
                param($Root, $Page)
                @(Get-DiagramSupportsDrift -Stem 'docs/widgets/.assets/widget-flow' -Page $Page -RepositoryRoot $Root)
            }
        }
    }

    It 'passes a page whose one-line Supports names the yml''s codes and lens' {
        & $script:drift "# Widgets`n`n``````text`nWidgets.`n`nSupports ADR-WIDGET-ONE and ADR-WIDGET-TWO (architecture lens).`n```````n" | Should -BeNullOrEmpty
    }

    It 'passes a Supports line wrapped onto the next line of its fence, as a long one must be' {
        & $script:drift "# Widgets`n`n``````text`nWidgets.`n`nSupports ADR-WIDGET-ONE`nand ADR-WIDGET-TWO (architecture lens).`n```````n" | Should -BeNullOrEmpty
    }

    It 'names a wrapped Supports line that disagrees, on one line' {
        $found = @(& $script:drift "# Widgets`n`n``````text`nWidgets.`n`nSupports ADR-WIDGET-ONE`nand ADR-WIDGET-TWO (meta lens).`n```````n")
        $found | Should -HaveCount 1
        "$($found[0])" | Should -BeLike '*says Supports ADR-WIDGET-ONE and ADR-WIDGET-TWO (meta lens)*its yml says ADR-WIDGET-ONE, ADR-WIDGET-TWO (architecture lens)'
    }
}
