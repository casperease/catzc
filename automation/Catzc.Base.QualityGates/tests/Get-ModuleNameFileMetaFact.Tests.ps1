<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1
    adrs:
      - ADR-REPO-CODEMETA#2
---
#>

Describe 'Get-ModuleNameFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#2' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{ automation = [ordered]@{ root = 'widgetry'; class = 'core'; languages = @('widget-lang') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'module-name' = @{ keys = @('module') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-ModuleNameFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'returns the folder under the automation track''s root, whatever the file''s depth' {
        @((Get-Fact 'widgetry/Catzc.Widget/Get-Gadget.ps1').Keys) | Should -Be @('module')
        (Get-Fact 'widgetry/Catzc.Widget/Get-Gadget.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'widgetry/Catzc.Widget/private/Get-Sprocket.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'widgetry/Catzc.Widget/tests/types/Gadget.Tests.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
    }

    It 'gives an empty value to a file placed in no module, so the key is left out of its head' -ForEach @(
        @{ Path = 'docs/gadget.md' }
        @{ Path = 'widgetry/Get-Gadget.ps1' }
        @{ Path = 'widgetry/.internal/Catzc.Internal.Loader.psm1' }
        @{ Path = 'importer.ps1' }
    ) {
        (Get-Fact $Path)['module'] | Should -BeExactly ''
    }
}
