<#
.SYNOPSIS
    Validates configs/guids.yml and throws with all violations collected.
.DESCRIPTION
    The managed-GUID registry — every GUID literal the repository carries, each a named, described entry —
    plus the non-allow list of values that are never a legitimate identity.

    Required shape:
      denied:  map; name -> { guid, description }               (optional; the non-allow list)
      guids:   map; name -> { guid, description [, sentence] }  (empty map allowed)

    Integrity rules:
    - only `denied` and `guids` exist at the top level — the schema is strict, so a stray key cannot
      quietly linger
    - an entry name (the map key) is snake_case: leading lowercase letter, then lowercase alphanumerics
      and underscores
    - `guid` is required and canonical: the lowercase hyphenated 8-4-4-4-12 form
    - guid values are unique across all entries — a GUID has exactly one name, and a denied value can
      never also be registered
    - `description` is required and non-empty
    - `sentence` is optional but non-empty when present on a `guids:` entry (the ConvertTo-Guid source of
      a minted placeholder); a `denied:` entry never carries one — a denied value is not minted for use

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

    foreach ($topLevelKey in @($Config.Keys)) {
        if ("$topLevelKey" -cnotin @('denied', 'guids')) {
            $errors.Add("unknown top-level key '$topLevelKey' (allowed: denied, guids)")
        }
    }

    # One pass validates both sections; the section decides the allowed entry keys.
    $sections = [ordered]@{
        denied = @('guid', 'description')
        guids  = @('guid', 'description', 'sentence')
    }
    $deniedValues = @()
    $allowedValues = @()
    foreach ($section in $sections.Keys) {
        $entries = if ($Config.Contains($section) -and $null -ne $Config[$section]) {
            $Config[$section]
        }
        else {
            [ordered]@{}
        }
        $allowedKeys = $sections[$section]

        foreach ($name in @($entries.Keys)) {
            if ("$name" -cnotmatch '^[a-z][a-z0-9_]*$') {
                $errors.Add("$section entry name '$name' is invalid (must be snake_case: leading lowercase letter, then lowercase alphanumerics/underscores)")
            }

            $entry = $entries[$name]
            if ($entry -isnot [System.Collections.IDictionary]) {
                $errors.Add("$section entry '$name' must be a map with keys: $($allowedKeys -join ', ')")
                continue
            }

            foreach ($key in @($entry.Keys)) {
                if ("$key" -cnotin $allowedKeys) {
                    $errors.Add("$section entry '$name' carries unknown key '$key' (allowed: $($allowedKeys -join ', '))")
                }
            }

            if (-not $entry.Contains('guid')) {
                $errors.Add("$section entry '$name' is missing 'guid'")
            }
            elseif ("$($entry.guid)" -cnotmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
                $errors.Add("$section entry '$name' has invalid guid '$($entry.guid)' (must be the canonical lowercase hyphenated form)")
            }
            elseif ($section -ceq 'denied') {
                $deniedValues += "$($entry.guid)"
            }
            else {
                $allowedValues += "$($entry.guid)"
            }

            if (-not $entry.Contains('description') -or [string]::IsNullOrWhiteSpace("$($entry.description)")) {
                $errors.Add("$section entry '$name' is missing a non-empty 'description'")
            }

            if ($entry.Contains('sentence') -and [string]::IsNullOrWhiteSpace("$($entry.sentence)")) {
                $errors.Add("$section entry '$name' has an empty 'sentence' (omit the key, or give the ConvertTo-Guid source sentence)")
            }
        }
    }

    $duplicates = @($deniedValues) + @($allowedValues) | Group-Object | Where-Object Count -GT 1
    foreach ($duplicate in $duplicates) {
        $errors.Add("Duplicate guid value: '$($duplicate.Name)' (a GUID has exactly one entry — and a denied value can never also be registered)")
    }

    if ($errors.Count -gt 0) {
        throw "guids configuration validation failed:`n$($errors -join "`n")"
    }
}
