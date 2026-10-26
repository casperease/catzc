Describe 'SlidesConfig' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-SLIDEFILEKIND' {
    It 'takes the declared default kit folder for an omitted key' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{})).kit | Should -Be 'python/diagrams/assets/slides'
        ([Catzc.Base.Slides.SlidesConfig]::new($null)).kit | Should -Be 'python/diagrams/assets/slides'
    }

    It 'takes the declared default for the draw.io kit' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{})).drawio_kit | Should -Be 'python/diagrams'
    }

    It 'takes the declared default theme, maps a theme it is given, and rejects one that is not a theme name' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{})).theme | Should -Be 'dark'
        ([Catzc.Base.Slides.SlidesConfig]::new(@{ theme = 'light' })).theme | Should -Be 'light'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ theme = 'Light Mode' }) } |
            Should -Throw '*theme ''Light Mode'' must be a theme name*'
    }

    It 'maps a draw.io kit it is given, and rejects one not in communication form' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{ drawio_kit = 'widget/kit/' })).drawio_kit | Should -Be 'widget/kit'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ drawio_kit = '../kit' }) } |
            Should -Throw '*drawio_kit*communication form*'
    }

    It 'lists no diagram: a diagram is found under docs/**/.assets/, so the old keys are unknown' -Tag 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ diagram_folders = @('docs/widgets/.assets') }) } |
            Should -Throw '*unknown key ''diagram_folders''*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ diagram_batch = 7 }) } |
            Should -Throw '*unknown key ''diagram_batch''*'
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

    It 'rejects a kit path that is not in communication form' -Tag 'ADR-AUTO-PATH-TWOFORMS' {
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = 'C:/widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = '/widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = 'widget\gadget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = '../widget' }) } | Should -Throw '*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ kit = ' ' }) } | Should -Throw '*communication form*'
    }

    It 'declares no name mention by default, maps each declared path to its reason, and rejects a path or a reason that is not one' -Tag 'DDR-VISUAL-NONAMEINPICTURE' {
        ([Catzc.Base.Slides.SlidesConfig]::new(@{})).name_mentions.Count | Should -Be 0
        $config = [Catzc.Base.Slides.SlidesConfig]::new(@{ name_mentions = @{ 'docs/widgets/.assets/widget-act' = ' the widget is drawn against the gadget ' } })
        $config.name_mentions['docs/widgets/.assets/widget-act'] | Should -Be 'the widget is drawn against the gadget'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ name_mentions = @{ 'docs\widgets' = 'a reason' } }) } | Should -Throw '*name_mentions key*communication form*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ name_mentions = @{ 'docs/widgets' = ' ' } }) } | Should -Throw '*must say why*'
        { [Catzc.Base.Slides.SlidesConfig]::new(@{ name_mentions = 'docs/widgets' }) } | Should -Throw '*name_mentions must map*'
    }
}

Describe 'SlidesConfig (shipped slides.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped slides.yml as a SlidesConfig that points at the kit' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = Get-Config -Config slides
        $config | Should -BeOfType ([Catzc.Base.Slides.SlidesConfig])
        $config.kit | Should -Be 'python/diagrams/assets/slides'
    }
}
