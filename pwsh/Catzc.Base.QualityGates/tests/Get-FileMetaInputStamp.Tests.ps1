Describe 'Get-FileMetaInputStamp' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:widget = Join-Path $script:root 'widgets/Get-Widget.wdg'
        $script:note = Join-Path $script:root 'notes/widget.md'
        $script:config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'widget-shade' = @{ keys = @('shade'); select = @(@{ classes = @('function') }) } }
            })
    }
    BeforeEach {
        $script:engine = 'engine-one'
        # The engine stamp is the input stamp over the files FileMetaConfig.EngineInputs names; a fixture stands for its value here.
        Mock Get-InputStamp -ModuleName Catzc.Base.QualityGates { $script:engine }
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates { throw 'the stamp reads no citation registry' }
        $script:stamp = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = @($script:widget, $script:note); R = $script:root; C = $script:config } {
                param($F, $R, $C)
                Get-FileMetaInputStamp -File $F -RepositoryRoot $R -Config $C
            }
        }
    }

    It 'changes the stamp of every file when the engine or its registries change, and reads the engine stamp once per call' {
        $before = & $script:stamp
        $script:engine = 'engine-two'
        $after = & $script:stamp
        $after[$script:widget] | Should -Not -Be $before[$script:widget]
        $after[$script:note] | Should -Not -Be $before[$script:note]
        Should -Invoke Get-InputStamp -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'keeps the stamp while the engine is the same, and never reads the citation registry, since a head cites no rule' {
        $before = & $script:stamp
        (& $script:stamp)[$script:widget] | Should -Be $before[$script:widget]
        Should -Invoke Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
