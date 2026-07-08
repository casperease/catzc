<#
.SYNOPSIS
    Validates configs/exporter.yml and throws with all violations collected.
.DESCRIPTION
    The single export config (see the file for the key documentation). Integrity rules, all required unless
    noted:

      direct_install_version  numeric MAJOR.MINOR.PATCH (PSModulePath-legal) — the on-disk direct-install sentinel
      version                 numeric MAJOR.MINOR.PATCH — the published NuGet/PSGallery semver
      default_profile         a non-empty lowercase profile token (a profiles.yml key; not cross-checked here,
                              to keep this Base validator self-contained — an integrity test confirms it exists)
      default_aspect          'live' or 'full'
      vendor_policy           'runtime' or 'full'
      module_guid             a GUID — the NuGet/PSGallery module's stable identity (a registered managed GUID)
      package                 a map: author, company, description (non-empty strings), tags (a non-empty list),
                              and optional project_uri / license_uri (strings; empty omits the field)

    Unknown keys throw (a typo fails fast at load). Auto-dispatched by Get-Config when loading 'exporter'.
#>
function Assert-ExporterConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $errors = [System.Collections.Generic.List[string]]::new()

    $allowedKeys = @('direct_install_version', 'version', 'default_profile', 'default_aspect', 'vendor_policy', 'module_guid', 'package')
    foreach ($key in @($Config.Keys)) {
        if ($key -notin $allowedKeys) {
            $errors.Add("unknown key '$key' (allowed: $($allowedKeys -join ', '))")
        }
    }

    foreach ($versionKey in @('direct_install_version', 'version')) {
        if (-not $Config.Contains($versionKey)) {
            $errors.Add("missing required key '$versionKey'")
        }
        elseif ("$($Config[$versionKey])" -notmatch '^\d+\.\d+\.\d+$') {
            $errors.Add("invalid $versionKey '$($Config[$versionKey])' (must be numeric MAJOR.MINOR.PATCH)")
        }
    }

    if (-not $Config.Contains('default_profile')) {
        $errors.Add("missing required key 'default_profile'")
    }
    elseif ("$($Config.default_profile)" -cnotmatch '^[a-z][a-z0-9]*(-[a-z0-9]+)*$') {
        $errors.Add("invalid default_profile '$($Config.default_profile)' (a lowercase profile token)")
    }

    if (-not $Config.Contains('default_aspect')) {
        $errors.Add("missing required key 'default_aspect'")
    }
    elseif ("$($Config.default_aspect)" -cnotmatch '^(live|full)$') {
        $errors.Add("invalid default_aspect '$($Config.default_aspect)' (valid: live, full)")
    }

    if (-not $Config.Contains('vendor_policy')) {
        $errors.Add("missing required key 'vendor_policy'")
    }
    elseif ("$($Config.vendor_policy)" -cnotmatch '^(runtime|full)$') {
        $errors.Add("invalid vendor_policy '$($Config.vendor_policy)' (valid: runtime, full)")
    }

    if (-not $Config.Contains('module_guid')) {
        $errors.Add("missing required key 'module_guid'")
    }
    elseif (-not [System.Guid]::TryParse("$($Config.module_guid)", [ref]([System.Guid]::Empty))) {
        $errors.Add("invalid module_guid '$($Config.module_guid)' (must be a GUID)")
    }

    if (-not $Config.Contains('package')) {
        $errors.Add("missing required key 'package'")
    }
    else {
        $package = $Config['package']
        foreach ($field in @('author', 'company', 'description')) {
            if (-not $package.Contains($field) -or [string]::IsNullOrWhiteSpace("$($package[$field])")) {
                $errors.Add("package.$field is required and must be a non-empty string")
            }
        }
        if (-not $package.Contains('tags') -or @($package['tags']).Count -eq 0) {
            $errors.Add('package.tags is required and must be a non-empty list')
        }
    }

    if ($errors.Count -gt 0) {
        throw "exporter configuration validation failed:`n$($errors -join "`n")"
    }
}
