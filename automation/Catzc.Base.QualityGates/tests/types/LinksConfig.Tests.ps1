# LinksConfig maps links.yml and is the one declaration of its sensible defaults
# ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key
# behaves exactly like the default, and a malformed value fails at construction with the allowed set.
Describe 'LinksConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{})
        $config.wrap | Should -Be ([Catzc.Base.QualityGates.LinkWrap]::Break)
        $config.default_line_limit | Should -Be 140
        $config.line_limit.Count | Should -Be 0
    }

    It 'maps every key it is given' -Tag 'ADR-REPO-LINK#8' {
        $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{ wrap = 'off'; default_line_limit = 100; line_limit = @{ '.ps1' = 90 } })
        $config.wrap | Should -Be ([Catzc.Base.QualityGates.LinkWrap]::Off)
        $config.default_line_limit | Should -Be 100
        $config.line_limit['.ps1'] | Should -Be 90
    }

    It 'rejects an unknown wrap mode, naming the allowed set' -Tag 'ADR-REPO-LINK#8' {
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ wrap = 'widget' }) } | Should -Throw '*break, off*'
    }

    It 'rejects an unknown key and a line limit that is not an extension' -Tag 'ADR-REPO-LINK#8' {
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key*'
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ ps1 = 90 } }) } | Should -Throw "*starting with '.'*"
    }
}

Describe 'LinksConfig (shipped links.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped links.yml as a LinksConfig' -Tag 'ADR-REPO-LINK#8' {
        (Get-Config -Config links) | Should -BeOfType ([Catzc.Base.QualityGates.LinksConfig])
    }
}
