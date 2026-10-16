<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-CatzcBundleFileMetaFact.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    adrs:
      - ADR-PRIN-CONFIG#1
---
#>

Describe 'Get-CatzcBundleFileMetaFact' -Tag 'L0', 'logic', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'catzc-bundle' = @{} } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-CatzcBundleFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    BeforeEach {
        # Declared largest first, to show the fact takes the one with the fewest modules, not the first it finds.
        $script:exporter = [Catzc.Base.Exporter.ExporterConfig]::new([ordered]@{
                direct_install_version = '1.0.0'
                module_guid            = '00000000-0000-0000-0000-000000000001'
                default_bundle         = 'large'
                bundles                = [ordered]@{
                    large = @{ profile = 'azure'; version = '1.0' }
                    small = @{ profile = 'minimal'; version = '1.0' }
                }
                package                = @{ author = 'A'; company = 'C'; description = 'D'; tags = @('t'); project_uri = 'https://example.org'; license_uri = 'https://example.org/l' }
            })
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'exporter' } { $script:exporter }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.QualityGates {
            if ($Name -eq 'minimal') {
                @('Widget.Core', '.internal')
            }
            else {
                @('Widget.Core', 'Widget.Extra', '.internal')
            }
        }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ name = 'automation'; root = 'widgetry' } }
    }

    It 'names the smallest bundle that holds the module of the file, under the kind''s key' {
        $fact = Get-Fact 'widgetry/Widget.Core/Get-Gadget.ps1'
        @($fact.Keys) | Should -Be @('catzc_bundle')
        $fact['catzc_bundle'] | Should -BeExactly 'small'
    }

    It 'names the bundle that alone holds a module' {
        (Get-Fact 'widgetry/Widget.Extra/private/Get-Cog.ps1')['catzc_bundle'] | Should -BeExactly 'large'
    }

    It 'counts an infrastructure folder, whatever the depth of the file in it' {
        (Get-Fact 'widgetry/.internal/tests/Assert-Widget.Tests.ps1')['catzc_bundle'] | Should -BeExactly 'small'
    }

    It 'gives an empty value to a module no bundle holds, a file outside the track, and a file directly in the root' -ForEach @(
        @{ Path = 'widgetry/Widget.Other/Get-Cog.ps1' }
        @{ Path = 'docs/page.md' }
        @{ Path = 'widgetry/Get-Cog.ps1' }
    ) {
        (Get-Fact $Path)['catzc_bundle'] | Should -BeExactly ''
    }

    It 'reads a backslash path' {
        (Get-Fact 'widgetry\Widget.Core\Get-Gadget.ps1')['catzc_bundle'] | Should -BeExactly 'small'
    }

    It 'resolves each bundle''s members once while the exporter registry stays the same one' {
        Get-Fact 'widgetry/Widget.Core/a.ps1' | Out-Null
        Get-Fact 'widgetry/Widget.Core/b.ps1' | Out-Null
        Should -Invoke Get-ModuleProfile -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }
}
