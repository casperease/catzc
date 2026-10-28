Describe 'Get-GeneratedTrackedPath' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-PROVENANCEINHEAD' {
    BeforeEach {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/*.yml', 'Build-Widget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/index.md', 'Build-WidgetIndex', 'rollable')
            # A later target that also takes a widget file never claims it a second time.
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/**', 'Update-Gadget', 'snapshot')
        }
        $script:run = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $Path } {
                param($Path)
                Get-GeneratedTrackedPath -Path $Path
            }
        }
    }

    It 'names each path a writer row''s output takes, with the writer of the most literal glob that takes it and its class' {
        $rows = @(& $script:run @('widget/alpha.yml', 'widget/index.md', 'widget/prices.json'))
        @($rows | ForEach-Object path) | Should -Be @('widget/alpha.yml', 'widget/index.md', 'widget/prices.json')
        @($rows | ForEach-Object generator) | Should -Be @('Build-Widget', 'Build-WidgetIndex', 'Update-Gadget')
        @($rows | ForEach-Object class) | Should -Be @('rollable', 'rollable', 'snapshot')
    }

    It 'gives a path two globs take to the more literal one, whichever comes first in the registry' {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/*/.assets/*.png', 'Draw-Gadget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/*/.assets/*.slide.png', 'Render-Gadget', 'rollable')
        }
        $rows = @(& $script:run @('gadget/cog/.assets/cog.png', 'gadget/cog/.assets/cog.slide.png'))
        @($rows | ForEach-Object { "$($_.path)=$($_.generator)" }) |
            Should -Be @('gadget/cog/.assets/cog.png=Draw-Gadget', 'gadget/cog/.assets/cog.slide.png=Render-Gadget')
    }

    It 'gives a path two equally literal globs take to the first in the registry' {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/*.json', 'Build-Gadget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/?.json', 'Update-Gadget', 'snapshot')
        }
        $rows = @(& $script:run @('gadget/a.json'))
        @($rows | ForEach-Object generator) | Should -Be @('Build-Gadget')
    }

    It 'leaves out a path no output takes, whatever it holds, since a head on no declared path is authored' {
        @(& $script:run @('gadget/notes.yml', 'docs\gadget.md')) | Should -BeNullOrEmpty
        Should -Invoke Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'reads no registry for no paths' {
        @(& $script:run @()) | Should -BeNullOrEmpty
        Should -Invoke Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
