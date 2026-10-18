Describe 'SlidesConfig' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES#6' {
    It 'takes the declared default kit folder for an omitted key' -Tag 'ADR-AUTO-DEFAULT#6' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{})).kit | Should -Be '.claude/slides'
        ([Catzc.Base.Slides.SlidesConfig]::new($null)).kit | Should -Be '.claude/slides'
    }

    It 'maps the kit folder it is given, without a trailing slash' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{ kit = 'widget/gadget/' })).kit | Should -Be 'widget/gadget'
    }

    It 'names the kit files once' {
        [Catzc.Base.Slides.SlidesConfig]::KitDefaultsFile | Should -Be 'slides.yml'
        [Catzc.Base.Slides.SlidesConfig]::PatternsFolder | Should -Be 'patterns'
        [Catzc.Base.Slides.SlidesConfig]::SlideSuffix | Should -Be '.slide.md'
        [Catzc.Base.Slides.SlidesConfig]::DeckFile | Should -Be 'deck.md'
    }

    It 'rejects an unknown key, naming the allowed set' {
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key ''gadget''*kit*'
    }

    It 'rejects a kit path that is not in communication form' -Tag 'ADR-AUTO-PATH#1' {
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = 'C:/widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = '/widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = 'widget\gadget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = '../widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = ' ' }) } | Should -Throw '*communication form*'
    }
}

Describe 'SlidesConfig (shipped slides.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped slides.yml as a SlidesConfig that points at the kit' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = Get-Config -Config slides
        $config | Should -BeOfType ([Catzc.Base.Slides.SlidesConfig])
        $config.kit | Should -Be '.claude/slides'
    }
}
