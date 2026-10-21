Describe 'Get-VendorFileMetaFact' -Tag 'L0', 'logic', 'ADR-DSGN-TRACKTYPE-FACTSFROMDECLARATION' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget   = [ordered]@{ places = @('widget'); type = 'widget-works' }
                    '.gizmo' = [ordered]@{ places = @('.gizmo', 'widget/gizmo-settings'); type = 'gizmo-settings'; vendor = 'gizmo' }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ vendor = @{ keys = @('vendor') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-VendorFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the vendor of the track that holds the file, under the kind''s key' {
        $fact = Get-Fact '.gizmo/settings.json'
        @($fact.Keys) | Should -Be @('vendor')
        $fact['vendor'] | Should -BeExactly 'gizmo'
        (Get-Fact 'widget/gizmo-settings/a.json')['vendor'] | Should -BeExactly 'gizmo'
    }

    It 'gives an empty value to a track with no vendor, a root file, and a path no place contains' -ForEach @(
        @{ Path = 'widget/part/file.wdg' }
        @{ Path = 'LICENSE' }
        @{ Path = 'elsewhere/file.wdg' }
    ) {
        (Get-Fact $Path)['vendor'] | Should -BeExactly ''
    }
}
