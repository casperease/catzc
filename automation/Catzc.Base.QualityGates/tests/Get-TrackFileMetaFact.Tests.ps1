<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
    folder: tests
    name: get-track-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-DSGN-TRACK#1
---
#>

Describe 'Get-TrackFileMetaFact' -Tag 'L0', 'logic', 'ADR-DSGN-TRACK#1' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget   = [ordered]@{ root = 'widget'; class = 'core'; languages = @('widget-lang') }
                    '.gizmo' = [ordered]@{ root = '.gizmo'; class = 'external-port' }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ track = @{} } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-TrackFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the track whose root folder holds the file, under the kind''s key' {
        $fact = Get-Fact 'widget/part/deep/file.wdg'
        @($fact.Keys) | Should -Be @('track')
        $fact['track'] | Should -BeExactly 'widget'
    }

    It 'names a dot-root track' {
        (Get-Fact '.gizmo/settings.json')['track'] | Should -BeExactly '.gizmo'
    }

    It 'gives an empty value to a root file, the output folder, and a root no track declares' -ForEach @(
        @{ Path = 'LICENSE' }
        @{ Path = 'out/plan.md' }
        @{ Path = 'elsewhere/file.wdg' }
    ) {
        (Get-Fact $Path)['track'] | Should -BeExactly ''
    }
}
