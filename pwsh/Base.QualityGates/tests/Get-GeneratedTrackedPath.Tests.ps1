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

    It 'names each path a writer row''s output takes, with the first writer that takes it and its class' {
        $rows = @(& $script:run @('widget/alpha.yml', 'widget/index.md', 'widget/prices.json'))
        @($rows | ForEach-Object path) | Should -Be @('widget/alpha.yml', 'widget/index.md', 'widget/prices.json')
        @($rows | ForEach-Object generator) | Should -Be @('Build-Widget', 'Build-WidgetIndex', 'Update-Gadget')
        @($rows | ForEach-Object class) | Should -Be @('rollable', 'rollable', 'snapshot')
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
