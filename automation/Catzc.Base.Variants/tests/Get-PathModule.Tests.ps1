<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    relatives:
      source: automation/Catzc.Base.Variants/Get-PathModule.ps1
    adrs:
      - ADR-DSGN-TRACK#3
---
#>

Describe 'Get-PathModule' -Tag 'L0', 'logic', 'ADR-DSGN-TRACK#3' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    automation = [ordered]@{ root = 'widgetry'; class = 'core'; languages = @('widget-lang') }
                    docs       = [ordered]@{ root = 'papers'; class = 'external-port' }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }
    }

    It 'returns the folder under the automation track''s root, whatever the file''s depth' {
        Get-PathModule 'widgetry/Catzc.Widget/Get-Gadget.ps1' | Should -BeExactly 'Catzc.Widget'
        Get-PathModule 'widgetry/Catzc.Widget/private/Get-Sprocket.ps1' | Should -BeExactly 'Catzc.Widget'
        Get-PathModule 'widgetry/Catzc.Widget/tests/types/Gadget.Tests.ps1' | Should -BeExactly 'Catzc.Widget'
    }

    It 'reads the root from the track registry, not from the word automation' {
        Get-PathModule 'automation/Catzc.Widget/Get-Gadget.ps1' | Should -BeNullOrEmpty
    }

    It 'accepts a backslash path' {
        Get-PathModule 'widgetry\Catzc.Widget\Get-Gadget.ps1' | Should -BeExactly 'Catzc.Widget'
    }

    It 'places a path outside the track, or a file directly in the root, in no module' -ForEach @(
        @{ Path = 'papers/Catzc.Widget/guide.md' }
        @{ Path = 'widgetry/Get-Gadget.ps1' }
        @{ Path = 'widgetry' }
        @{ Path = 'widgetry/' }
        @{ Path = 'importer.ps1' }
        @{ Path = '' }
    ) {
        Get-PathModule $Path | Should -BeNullOrEmpty
    }

    It 'places the infrastructure folders, whose names start with a dot, in no module' -ForEach @(
        @{ Path = 'widgetry/.internal/Catzc.Internal.Loader.psm1' }
        @{ Path = 'widgetry/.vendor/Pester/Pester.psd1' }
    ) {
        Get-PathModule $Path | Should -BeNullOrEmpty
    }

    It 'does not take a root that only shares the prefix' {
        Get-PathModule 'widgetry-extra/Catzc.Widget/Get-Gadget.ps1' | Should -BeNullOrEmpty
    }
}
