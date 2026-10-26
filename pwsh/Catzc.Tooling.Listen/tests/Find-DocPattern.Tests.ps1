Describe 'Find-DocPattern' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
        # An edit on disk after the start never reaches the reference.
        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nADR-WIDGET-PARTS-SINGLE, edited live.`n"
    }

    It 'finds every matching line in the committed reference, in path order, with its tier, skipping binaries and .git' {
        $found = @(Find-DocPattern -Session $script:session 'ADR-WIDGET-PARTS-SINGLE')
        @($found.Path) | Should -Be @('Get-Widget.ps1', 'docs/drs/widget.md')
        @($found.Tier) | Should -Be @('code', 'rule')
        $found[1].Line | Should -Be 3
        $found[1].Text | Should -BeExactly 'The widget rule, ADR-WIDGET-PARTS-SINGLE.'
        $found[1].Kind | Should -BeExactly 'adr'
    }

    It 'searches only the named tiers' {
        @((Find-DocPattern -Session $script:session 'ADR-WIDGET' -Tier 'rule').Path) |
            Should -Be @('docs/drs/widget.md')
        @(Find-DocPattern -Session $script:session 'ADR-WIDGET' -Tier 'docs').Count | Should -Be 0
    }

    It 'searches only a slice' {
        @((Find-DocPattern -Session $script:session 'Gadget' -Path 'docs/explanation').Path) |
            Should -Be @('docs/explanation/gadget.md')
        @(Find-DocPattern -Session $script:session 'Gadget' -Path 'docs/gizmo').Count | Should -Be 0
    }

    It 'matches case-sensitively' {
        @(Find-DocPattern -Session $script:session 'why the gadget').Count | Should -Be 0
        @(Find-DocPattern -Session $script:session 'Why the gadget').Count | Should -Be 1
    }
}
