<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
    folder: tests
    name: get-module-type-file-meta-fact-tests
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
      - ADR-DSGN-TRACK#3
---
#>

Describe 'Get-ModuleTypeFileMetaFact' -Tag 'L0', 'logic', 'ADR-DSGN-TRACK#3' {
    BeforeAll {
        $script:types = [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{ definition = 'A widget folder.'; places = @(@{ root = 'widgetry'; name = 'folder' }) }
                    'widget-tool'   = [ordered]@{ definition = 'A widget tool.'; places = @(@{ root = '.gizmo'; name = 'root' }) }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'module-types' } { $script:types }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'module-type' = @{ keys = @('moduletype') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-ModuleTypeFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the type of the module the file is placed in, under the kind''s key' {
        $fact = Get-Fact 'widgetry/Gadget/Cog.ps1'
        @($fact.Keys) | Should -Be @('moduletype')
        $fact['moduletype'] | Should -BeExactly 'widget-folder'
        (Get-Fact '.gizmo/settings.json')['moduletype'] | Should -BeExactly 'widget-tool'
    }

    It 'gives an empty value to a file placed in no module' -ForEach @(
        @{ Path = 'LICENSE' }
        @{ Path = 'widgetry/Cog.ps1' }
        @{ Path = 'docs/page.md' }
    ) {
        (Get-Fact $Path)['moduletype'] | Should -BeExactly ''
    }
}
