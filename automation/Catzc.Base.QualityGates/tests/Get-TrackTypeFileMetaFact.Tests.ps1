<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Get-TrackTypeFileMetaFact.Tests.ps1
    folder: tests
    name: get-track-type-file-meta-fact-tests
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
      - ADR-DSGN-TRACKTYPE#6
---
#>

Describe 'Get-TrackTypeFileMetaFact' -Tag 'L0', 'logic', 'ADR-DSGN-TRACKTYPE#6' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget   = [ordered]@{ places = @('widget'); type = 'widget-works' }
                    '.gizmo' = [ordered]@{ places = @('.gizmo', 'widget/gizmo-settings'); type = 'gizmo-settings'; vendor = 'gizmo' }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'track-type' = @{ keys = @('tracktype') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-TrackTypeFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the type of the track that holds the file, under the kind''s key' {
        $fact = Get-Fact 'widget/part/file.wdg'
        @($fact.Keys) | Should -Be @('tracktype')
        $fact['tracktype'] | Should -BeExactly 'widget-works'
    }

    It 'names the type of the narrower track where a place lies inside another track''s root' {
        (Get-Fact 'widget/gizmo-settings/a.json')['tracktype'] | Should -BeExactly 'gizmo-settings'
    }

    It 'gives an empty value to a root file, the output folder, and a path no place contains' -ForEach @(
        @{ Path = 'LICENSE' }
        @{ Path = 'out/plan.md' }
        @{ Path = 'elsewhere/file.wdg' }
    ) {
        (Get-Fact $Path)['tracktype'] | Should -BeExactly ''
    }
}
