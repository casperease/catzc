<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    folder: tests
    name: get-module-name-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-CODEMETA#2
---
#>

Describe 'Get-ModuleNameFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#2' {
    BeforeAll {
        $script:types = [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{
                        definition = 'A widget folder.'
                        places     = @(
                            @{ root = 'widgetry'; name = 'folder' }
                            @{ root = 'widgetry/.core'; name = 'folder'; prefix = 'Widget.Core.' }
                        )
                    }
                    'widget-file'   = [ordered]@{ definition = 'A widget file.'; places = @(@{ root = 'widgetry/.core'; name = 'file'; extension = 'wdg' }) }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'module-types' } { $script:types }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'module-name' = @{ keys = @('module') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-ModuleNameFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'returns the name of the module the file is placed in, whatever the file''s depth' {
        @((Get-Fact 'widgetry/Catzc.Widget/Get-Gadget.ps1').Keys) | Should -Be @('module')
        (Get-Fact 'widgetry/Catzc.Widget/Get-Gadget.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'widgetry/Catzc.Widget/private/Get-Sprocket.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'widgetry/Catzc.Widget/tests/types/Gadget.Tests.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
    }

    It 'names a single-file module by the file, and a prefixed folder by its PascalCase' -ForEach @(
        @{ Path = 'widgetry/.core/Widget.Core.Loader.wdg'; Module = 'Widget.Core.Loader' }
        @{ Path = 'widgetry/.core/tests/Assert-Widget.Tests.ps1'; Module = 'Widget.Core.Tests' }
    ) {
        (Get-Fact $Path)['module'] | Should -BeExactly $Module
    }

    It 'gives an empty value to a file placed in no module, so the key is left out of its head' -ForEach @(
        @{ Path = 'docs/gadget.md' }
        @{ Path = 'widgetry/Get-Gadget.ps1' }
        @{ Path = 'widgetry/.vendor/Pester/Pester.psd1' }
        @{ Path = 'importer.ps1' }
    ) {
        (Get-Fact $Path)['module'] | Should -BeExactly ''
    }
}
