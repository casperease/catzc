<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-TrackDeclaration.ps1
    name: test-track-declaration
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-TrackDeclaration.Tests.ps1
    docs: "[Test-TrackDeclaration.ps1.md](docs/references/pwsh/catzc-base-variants/Test-TrackDeclaration.ps1.md)"
    cites:
      - ADR-DSGN-MODTYPE-TRACKTYPEADMITSMODULETYPES
      - ADR-DSGN-TRACKTYPE-DECLAREDONCE
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
