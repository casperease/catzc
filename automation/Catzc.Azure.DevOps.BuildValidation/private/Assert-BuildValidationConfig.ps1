<#
.SYNOPSIS
    Validates configs/build-validation.yml and throws with all violations collected.
.DESCRIPTION
    Required shape (the local config that ties ADO build-validation branch policies to globsets):
      branch:      the branch the policies guard (non-empty, e.g. main)
      validations: a non-empty LIST of entries, each a mapping with
                     globset:      required — the declared globset the policy is tied to (unique per entry)
                     pipeline:     optional — the pipeline name (defaults to the globset's annotation)
                     blocking:     optional bool (defaults to true)
                     display_name: optional — the policy display name

    Keys are snake_case (enforced by Assert-YmlNaming); globset names live in VALUES because they are
    kebab-case. Run on load by Get-Config (convention: Assert-<TitleCase(name)>Config). Globset existence
    is deliberately NOT checked here — that read would couple every config load to the globs registry; it
    is enforced at runtime (Get-GlobSet throws) and by an integrity test (the ADR-CUSTOMER:3 pattern).
    Mirrors Assert-AdoConfig (collect-all-then-throw).
.PARAMETER Config
    The parsed build-validation.yml (ordered dictionary).
#>
function Assert-BuildValidationConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-YmlNaming $Config

    $errors = [System.Collections.Generic.List[string]]::new()

    foreach ($key in $Config.Keys) {
        if ($key -notin 'branch', 'validations') {
            $errors.Add("Unknown top-level key: '$key' (allowed: branch, validations)")
        }
    }
    foreach ($key in 'branch', 'validations') {
        if (-not $Config.Contains($key)) {
            $errors.Add("Missing required key: '$key'")
        }
    }
    if ($errors.Count -gt 0) {
        throw "build-validation configuration validation failed:`n$($errors -join "`n")"
    }

    if ([string]::IsNullOrWhiteSpace($Config.branch)) {
        $errors.Add('branch is empty')
    }

    $entries = $Config.validations
    if ($entries -isnot [System.Collections.IList] -or @($entries).Count -eq 0) {
        $errors.Add('validations must be a non-empty list of entries')
    }
    else {
        $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        for ($i = 0; $i -lt @($entries).Count; $i++) {
            $entry = @($entries)[$i]
            if ($entry -isnot [System.Collections.IDictionary]) {
                $errors.Add("validations[$i] must be a mapping with a 'globset' key")
                continue
            }
            foreach ($key in $entry.Keys) {
                if ($key -notin 'globset', 'pipeline', 'blocking', 'display_name') {
                    $errors.Add("validations[$i]: unknown key '$key' (allowed: globset, pipeline, blocking, display_name)")
                }
            }
            if (-not $entry.Contains('globset') -or [string]::IsNullOrWhiteSpace($entry.globset)) {
                $errors.Add("validations[$i]: 'globset' is required and must be non-empty")
            }
            elseif (-not $seen.Add("$($entry.globset)")) {
                $errors.Add("validations[$i]: duplicate entry for globset '$($entry.globset)'")
            }
            if ($entry.Contains('pipeline') -and [string]::IsNullOrWhiteSpace($entry.pipeline)) {
                $errors.Add("validations[$i]: 'pipeline' must be non-empty when present")
            }
            if ($entry.Contains('blocking') -and $entry.blocking -isnot [bool]) {
                $errors.Add("validations[$i]: 'blocking' must be a boolean")
            }
            if ($entry.Contains('display_name') -and [string]::IsNullOrWhiteSpace($entry.display_name)) {
                $errors.Add("validations[$i]: 'display_name' must be non-empty when present")
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "build-validation configuration validation failed:`n$($errors -join "`n")"
    }
}
