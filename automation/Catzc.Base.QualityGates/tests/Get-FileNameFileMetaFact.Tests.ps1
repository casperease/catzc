<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-FileNameFileMetaFact.Tests.ps1
    folder: tests
    name: get-file-name-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#11
---
#>

Describe 'Get-FileNameFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#11' {
    BeforeAll {
        $script:types = [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{ definition = 'A widget folder.'; places = @(@{ root = 'widgetry'; name = 'folder' }) }
                    'widget-file'   = [ordered]@{ definition = 'A widget file.'; places = @(@{ root = 'widgetry/.core'; name = 'file'; extension = 'wdg' }) }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'module-types' } { $script:types }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-name' = @{ keys = @('folder', 'name') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-FileNameFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the folder under the module and the kebab-case name, under the kind''s keys' {
        $fact = Get-Fact 'widgetry/Catzc.Widget/types/GadgetMetrics.cs'
        @($fact.Keys) | Should -Be @('folder', 'name')
        $fact['folder'] | Should -BeExactly 'types'
        $fact['name'] | Should -BeExactly 'gadget-metrics'
    }

    It 'gives a file directly in its module an empty folder, so the key is left out of its head' {
        $fact = Get-Fact 'widgetry/Catzc.Widget/Get-Gadget.ps1'
        $fact['folder'] | Should -BeExactly ''
        $fact['name'] | Should -BeExactly 'get-gadget'
    }

    It 'keeps every folder of a nested path, and reads a backslash path' {
        (Get-Fact 'widgetry/Catzc.Widget/tests/types/Gadget.Tests.ps1')['folder'] | Should -BeExactly 'tests/types'
        (Get-Fact 'widgetry\Catzc.Widget\tests\Gadget.Tests.ps1')['folder'] | Should -BeExactly 'tests'
    }

    It 'takes the name of a single-file module from the file, and the whole path for a file placed in no module' -ForEach @(
        @{ Path = 'widgetry/.core/Widget.Core.Loader.wdg'; Folder = ''; Name = 'widget-core-loader' }
        @{ Path = 'docs/adr/index.md'; Folder = 'docs/adr'; Name = 'index' }
        @{ Path = 'importer.ps1'; Folder = ''; Name = 'importer' }
        @{ Path = '.gitkeep'; Folder = ''; Name = 'gitkeep' }
    ) {
        $fact = Get-Fact $Path
        $fact['folder'] | Should -BeExactly $Folder
        $fact['name'] | Should -BeExactly $Name
    }

    It 'stops on a file name that holds no letter or digit to name it by' {
        { Get-Fact 'widgetry/Catzc.Widget/..' } | Should -Throw '*holds no letter or digit*'
    }
}
