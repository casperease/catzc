<#
.SYNOPSIS
    Returns the Catzc bundle version from exporter.yml — the direct-install sentinel by default.
.DESCRIPTION
    Reads the two numeric versions declared in configs/exporter.yml (Get-Config -Config exporter):

      (default)   direct_install_version — the fixed sentinel every on-disk direct install carries
                  (Catzc/<version>/); the common case for the near-term install path.
      -Published  version                — the real semver the future NuGet/PSGallery artifact publishes under.

    Both are PSModulePath-legal MAJOR.MINOR.PATCH strings (the config validator enforces the shape).
.PARAMETER Published
    Return the published semver instead of the direct-install sentinel.
.EXAMPLE
    Get-CatzcVersion            # -> 6.6.666  (the on-disk direct-install version)
.EXAMPLE
    Get-CatzcVersion -Published # -> the semver for the NuGet/PSGallery artifact
#>
function Get-CatzcVersion {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $Published
    )

    $config = Get-Config -Config exporter
    if ($Published) {
        return "$($config.version)"
    }

    "$($config.direct_install_version)"
}
