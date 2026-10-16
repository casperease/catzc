<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Test-TrackDeclaration.ps1
    name: test-track-declaration
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Test-TrackDeclaration.Tests.ps1
    cites:
      - ADR-DSGN-MODTYPE#3
      - ADR-DSGN-TRACKTYPE#4
  config:
    synopsis: Checks that the tracks, the track types, the vendors and the module types agree with one another.
    description: |-
      The `tracks` map ([ADR-DSGN-TRACKTYPE#4](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype4)) and the track-types registry
      are read apart, so this check reads them together: every track names a declared track type, every vendor a track names is
      declared, and every place of every module type lies in a track whose track type admits that module type
      ([ADR-DSGN-MODTYPE#3](/docs/adr/design/module-types.md#rule-adr-dsgn-modtype3)). A module place that lies in no track is left
      out, since a root no git file is tracked under names no track. Throws one error naming every violation; returns nothing when
      the declarations agree.
    examples:
      - Test-TrackDeclaration
---
#>

function Test-TrackDeclaration {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $trackTypes = Get-Config -Config track-types
    $moduleTypes = Get-Config -Config module-types
    $violations = [System.Collections.Generic.List[string]]::new()

    foreach ($track in Get-Track) {
        $trackType = $trackTypes.TypeOf($track.type)
        if (-not $trackType) {
            $violations.Add("track '$($track.name)': track type '$($track.type)' is not declared in track-types.yml")
        }
        if ($track.vendor -and -not $trackTypes.VendorOf($track.vendor)) {
            $violations.Add("track '$($track.name)': vendor '$($track.vendor)' is not declared in track-types.yml")
        }
    }

    foreach ($trackType in $trackTypes.types) {
        foreach ($admitted in $trackType.admits) {
            if (-not ($moduleTypes.types | Where-Object { $_.id -ceq $admitted })) {
                $violations.Add("track type '$($trackType.id)': admitted module type '$admitted' is not declared in module-types.yml")
            }
        }
    }

    foreach ($moduleType in $moduleTypes.types) {
        foreach ($place in $moduleType.places) {
            $track = Get-Track -Path $place.root
            if (-not $track) {
                continue
            }
            $trackType = $trackTypes.TypeOf($track.type)
            if ($trackType -and $moduleType.id -cnotin $trackType.admits) {
                $violations.Add("module type '$($moduleType.id)': place '$($place.root)' lies in track '$($track.name)' of type '$($track.type)', which does not admit it")
            }
        }
    }

    if ($violations.Count -gt 0) {
        throw "Test-TrackDeclaration failed: $($violations.Count) violation(s):`n$($violations -join "`n")"
    }
}
