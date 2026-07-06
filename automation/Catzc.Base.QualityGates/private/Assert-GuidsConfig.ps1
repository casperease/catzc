<#
.SYNOPSIS
    Validates configs/guids.yml and throws with all violations collected.
.DESCRIPTION
    The managed-GUID registry — every GUID literal the repository carries, each a named, described entry.

    Required shape:
      guids:  map; name -> { guid, description [, sentence] }   (empty map allowed)

    Integrity rules:
    - entry name (the map key) is snake_case: leading lowercase letter, then lowercase alphanumerics and
      underscores
    - `guid` is required and canonical: the lowercase hyphenated 8-4-4-4-12 form
    - guid values are unique across entries — a GUID has exactly one registered name
    - `description` is required and non-empty
    - `sentence` is optional but non-empty when present (the ConvertTo-Guid source of a minted placeholder)
    - no other keys — the schema is strict, so a stray key cannot quietly linger

    Auto-dispatched by Get-Config when loading the 'guids' config.
#>
function Assert-GuidsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('guids')) {
        throw "guids configuration validation failed:`nMissing required top-level key: 'guids'"
    }

    $errors = [System.Collections.Generic.List[string]]::new()
    $entries = $Config.guids
    if ($null -eq $entries) {
        $entries = [ordered]@{}
    }

    $allowedKeys = @('guid', 'description', 'sentence')
    $guidValues = @()
    foreach ($name in @($entries.Keys)) {
        if ("$name" -cnotmatch '^[a-z][a-z0-9_]*$') {
            $errors.Add("entry name '$name' is invalid (must be snake_case: leading lowercase letter, then lowercase alphanumerics/underscores)")
        }

        $entry = $entries[$name]
        if ($entry -isnot [System.Collections.IDictionary]) {
            $errors.Add("entry '$name' must be a map with keys: guid, description [, sentence]")
            continue
        }

        foreach ($key in @($entry.Keys)) {
            if ("$key" -cnotin $allowedKeys) {
                $errors.Add("entry '$name' carries unknown key '$key' (allowed: guid, description, sentence)")
            }
        }

        if (-not $entry.Contains('guid')) {
            $errors.Add("entry '$name' is missing 'guid'")
        }
        elseif ("$($entry.guid)" -cnotmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
            $errors.Add("entry '$name' has invalid guid '$($entry.guid)' (must be the canonical lowercase hyphenated form)")
        }
        else {
            $guidValues += "$($entry.guid)"
        }

        if (-not $entry.Contains('description') -or [string]::IsNullOrWhiteSpace("$($entry.description)")) {
            $errors.Add("entry '$name' is missing a non-empty 'description'")
        }

        if ($entry.Contains('sentence') -and [string]::IsNullOrWhiteSpace("$($entry.sentence)")) {
            $errors.Add("entry '$name' has an empty 'sentence' (omit the key, or give the ConvertTo-Guid source sentence)")
        }
    }

    $duplicates = $guidValues | Group-Object | Where-Object Count -GT 1
    foreach ($duplicate in $duplicates) {
        $errors.Add("Duplicate guid value: '$($duplicate.Name)' (a GUID has exactly one registered name)")
    }

    if ($errors.Count -gt 0) {
        throw "guids configuration validation failed:`n$($errors -join "`n")"
    }
}
