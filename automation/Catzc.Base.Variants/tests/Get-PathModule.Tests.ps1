<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
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

    It 'places the other folders whose names start with a dot in no module' -ForEach @(
        @{ Path = 'widgetry/.vendor/Pester/Pester.psd1' }
        @{ Path = 'widgetry/.scriptanalyzer/Rule.psm1' }
        @{ Path = 'widgetry/.compiled/Catzc.Types.dll' }
    ) {
        Get-PathModule $Path | Should -BeNullOrEmpty
    }

    It 'names a psm1 file directly in .internal as the module it is' {
        Get-PathModule 'widgetry/.internal/Catzc.Internal.Types.psm1' | Should -BeExactly 'Catzc.Internal.Types'
    }

    It 'places a file under a folder of .internal in the module Catzc.Internal plus the folder in PascalCase' -ForEach @(
        @{ Path = 'widgetry/.internal/tests/Assert-Widget.Tests.ps1'; Module = 'Catzc.Internal.Tests' }
        @{ Path = 'widgetry/.internal/assets/Import-Widget.ps1'; Module = 'Catzc.Internal.Assets' }
        @{ Path = 'widgetry/.internal/assets/obj/Debug/gadget.cs'; Module = 'Catzc.Internal.Assets' }
        @{ Path = 'widgetry\.internal\tests\Assert-Widget.Tests.ps1'; Module = 'Catzc.Internal.Tests' }
        @{ Path = 'widgetry/.internal/test-kit/Part.ps1'; Module = 'Catzc.Internal.TestKit' }
    ) {
        Get-PathModule $Path | Should -BeExactly $Module
    }

    It 'places a file directly in .internal that is no psm1 in no module' -ForEach @(
        @{ Path = 'widgetry/.internal/README.md' }
        @{ Path = 'widgetry/.internal/Part.ps1' }
        @{ Path = 'widgetry/.internal/' }
    ) {
        Get-PathModule $Path | Should -BeNullOrEmpty
    }

    It 'does not take a root that only shares the prefix' {
        Get-PathModule 'widgetry-extra/Catzc.Widget/Get-Gadget.ps1' | Should -BeNullOrEmpty
    }
}
