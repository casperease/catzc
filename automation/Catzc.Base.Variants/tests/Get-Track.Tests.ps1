Describe 'Get-Track' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget   = [ordered]@{ root = 'widget'; class = 'core'; languages = @('widget-lang') }
                    gadget   = [ordered]@{ root = 'gadget'; class = 'adapter'; languages = @('gadget-lang', 'widget-lang') }
                    '.gizmo' = [ordered]@{ root = '.gizmo'; class = 'external-port' }
                    sprocket = [ordered]@{ root = '.sprocket'; class = 'verification' }
                }
            })
    }

    Context 'a declared registry' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }
        }

        It 'returns every track in declared order on the zero-argument call' {
            $tracks = @(Get-Track)
            $tracks[0] | Should -BeOfType [Catzc.Base.Variants.VariantTrack]
            $tracks.name | Should -Be @('widget', 'gadget', '.gizmo', 'sprocket')
        }

        It 'returns the named tracks' {
            (Get-Track -Name gadget).languages | Should -Be @('gadget-lang', 'widget-lang')
            @(Get-Track -Name widget, '.gizmo').class | Should -Be @('core', 'external-port')
        }

        It 'throws on an unknown name, naming the config file and the declared tracks' {
            { Get-Track -Name gimbal } | Should -Throw "*Unknown track 'gimbal'*variants.yml*widget, gadget*"
        }

        It 'returns the track whose root is the first segment of a path' {
            (Get-Track -Path 'widget/Widget.Module/Get-Widget.ps1').name | Should -Be 'widget'
            (Get-Track -Path 'gadget/deep/nested/folder/gadget.cfg').name | Should -Be 'gadget'
            (Get-Track -Path '.gizmo/settings.json').name | Should -Be '.gizmo'
        }

        It 'matches the root, not the track name' {
            (Get-Track -Path '.sprocket/tests/sprocket_test.go').name | Should -Be 'sprocket'
            Get-Track -Path 'sprocket/file.txt' | Should -BeNullOrEmpty
        }

        It 'accepts backslashes, a leading ./, and a bare root folder' {
            (Get-Track -Path 'gadget\modules\gadget.cfg').name | Should -Be 'gadget'
            (Get-Track -Path './widget/Get-Widget.ps1').name | Should -Be 'widget'
            (Get-Track -Path 'widget').name | Should -Be 'widget'
        }

        It 'returns nothing for out/, a root file, and an undeclared root folder' {
            Get-Track -Path 'out/widget/report.md' | Should -BeNullOrEmpty
            Get-Track -Path 'LICENSE' | Should -BeNullOrEmpty
            Get-Track -Path 'gimbal/gimbal.txt' | Should -BeNullOrEmpty
        }
    }

    Context 'no registry declared' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{}) }
        }

        It 'returns nothing, and finds no track for a path' {
            Get-Track | Should -BeNullOrEmpty
            Get-Track -Path 'widget/Get-Widget.ps1' | Should -BeNullOrEmpty
        }
    }
}

Describe 'Get-Track — the real repository' -Tag 'L1', 'integrity', 'source-only', 'ADR-DSGN-TRACK#17' {
    It 'declares the unordered track as the shelf nothing defaults to' {
        (Get-Track -Name '.unordered').class | Should -Be 'unordered'
        (Get-Track -Path '.unordered/15-10-2026/plan-widget.md').name | Should -Be '.unordered'
    }
}
