<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-TrackDeclaration.ps1.md"
  header: "generated"
---
#>

function Test-TrackDeclaration {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $trackTypes = Get-Config -Config track-types
    $moduleTypes = Get-Config -Config module-types
    $violations = [System.Collections.Generic.List[string]]::new()
    # A track's name is its definitive name in the repository normal form (DDR-TRACKTYPE-NAMEFROMMEMBERS); the form is declared
    # once, in the languages config, so the config type holds no naming policy.
    $normalForm = (Get-Config -Config languages).naming_normal_form

    foreach ($track in Get-Track) {
        if (-not [Catzc.Base.Objects.NameCase]::IsNormal($track.name, $normalForm)) {
            $violations.Add("track '$($track.name)': the name is not in the repository normal form ($normalForm segments joined by '.')")
        }
        $trackType = $trackTypes.TypeOf($track.type)
        if (-not $trackType) {
            $violations.Add("track '$($track.name)': track type '$($track.type)' is not declared in track-types.yml")
        }
        # A namespace names a track's module folders, so only a track whose type admits modules may declare one.
        if ($track.namespace -and $trackType -and @($trackType.admits).Count -eq 0) {
            $violations.Add("track '$($track.name)': namespace '$($track.namespace)' on a track of type '$($track.type)', which holds no modules")
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
