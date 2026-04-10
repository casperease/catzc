<#
.SYNOPSIS
    Validates configs/vendor.yml and throws with all violations collected.
.DESCRIPTION
    The vendor source config — where vendored modules are downloaded from and validated against. Integrity
    rules:

    - only the known keys are allowed ('source', 'sourceUrl') — an unknown key (typo) fails fast at load
    - 'source' is required and non-empty (the registered PSResourceRepository name, e.g. PSGallery)
    - 'sourceUrl' (optional) is an absolute URI when present (a custom Artifactory / proxy feed)

    Auto-dispatched by Get-Config when loading the 'vendor' config (the Assert-<Name>Config convention).
.PARAMETER Config
    The parsed vendor.yml — an ordered dictionary.
.EXAMPLE
    Assert-VendorConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-VendorConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $errors = [System.Collections.Generic.List[string]]::new()

    $allowedKeys = @('source', 'sourceUrl')
    foreach ($key in @($Config.Keys)) {
        if ($key -notin $allowedKeys) {
            $errors.Add("unknown key '$key' (allowed: $($allowedKeys -join ', '))")
        }
    }

    if (-not $Config.Contains('source') -or [string]::IsNullOrWhiteSpace("$($Config.source)")) {
        $errors.Add("missing required key 'source' (the PSResourceRepository name, e.g. PSGallery)")
    }

    if ($Config.Contains('sourceUrl')) {
        $url = "$($Config.sourceUrl)"
        if ([string]::IsNullOrWhiteSpace($url) -or -not [System.Uri]::IsWellFormedUriString($url, [System.UriKind]::Absolute)) {
            $errors.Add("invalid sourceUrl '$url' (must be an absolute URI)")
        }
    }

    if ($errors.Count -gt 0) {
        throw "vendor configuration validation failed:`n$($errors -join "`n")"
    }
}
