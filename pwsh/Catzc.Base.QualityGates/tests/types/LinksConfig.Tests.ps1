<#
---
catzc:
  immutable:
    with_body_sha: "074ad9bfbd3a"
  edges:
    docs: "[LinksConfig.Tests.ps1.md](../../../../docs/references/pwsh/catzc-base-quality-gates/tests/types/LinksConfig.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-LINK-ONECITATIONSPELLING
      - ADR-REPO-LINK-ALIGNEDBYTOOL
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
---
#>

Describe 'LinksConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{})
        $config.wrap | Should -Be ([Catzc.Base.QualityGates.LinkWrap]::Break)
        $config.default_line_limit | Should -Be 140
        $config.line_limit.Count | Should -Be 0
        $config.string_citations.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
        $config.string_citations.exempt.Count | Should -Be 0
    }

    It 'maps the string-citation check''s mode and exempt globs' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING', 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
        $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{
                string_citations = [ordered]@{ mode = 'report'; exempt = [ordered]@{ 'src/widget.Tests.ps1' = 'its fixtures' } }
            })
        $config.string_citations.IsReport | Should -BeTrue
        $config.string_citations.IsExempt('src/widget.Tests.ps1') | Should -BeTrue
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ string_citations = 'report' }) } | Should -Throw '*string_citations must be a map*'
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ string_citations = @{ mode = 'loud' } }) } | Should -Throw '*gate, report*'
    }

    It 'maps every key it is given' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{ wrap = 'off'; default_line_limit = 100; line_limit = @{ '.ps1' = 90 } })
        $config.wrap | Should -Be ([Catzc.Base.QualityGates.LinkWrap]::Off)
        $config.default_line_limit | Should -Be 100
        $config.line_limit['.ps1'] | Should -Be 90
    }

    It 'rejects an unknown wrap mode, naming the allowed set' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ wrap = 'widget' }) } | Should -Throw '*break, off*'
    }

    It 'rejects an unknown key and a line limit that is not an extension' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key*'
        { [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ ps1 = 90 } }) } | Should -Throw "*starting with '.'*"
    }
}

Describe 'LinksConfig (shipped links.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped links.yml as a LinksConfig' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        (Get-Config -Config links) | Should -BeOfType ([Catzc.Base.QualityGates.LinksConfig])
    }
}
