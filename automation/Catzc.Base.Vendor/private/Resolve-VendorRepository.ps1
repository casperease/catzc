<#
.SYNOPSIS
    Resolves the PSResourceRepository name the vendor functions download from and validate against.
.DESCRIPTION
    Reads configs/vendor.yml (Get-Config -Config vendor). Returns its 'source' name — PSGallery by default.
    When a custom 'sourceUrl' is set (an Artifactory / proxy feed), registers a trusted repository under the
    'source' name on first use, so Save-PSResource/Find-PSResource can target it by name. Also asserts the
    bundled PSResourceGet cmdlets are present (they ship with PowerShell 7.4+) so a stripped install fails with
    a clear message rather than a missing-cmdlet error.
.OUTPUTS
    [string] The repository name to pass to the PSResourceGet cmdlets.
#>
function Resolve-VendorRepository {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    foreach ($cmd in 'Find-PSResource', 'Save-PSResource', 'Get-PSResourceRepository', 'Register-PSResourceRepository') {
        if (-not (Get-Command $cmd -ErrorAction Ignore)) {
            throw "Vendor operations require Microsoft.PowerShell.PSResourceGet ('$cmd' not found) — it ships with PowerShell 7.4+."
        }
    }

    $config = Get-Config -Config vendor
    $source = "$($config.source)"

    if ($config.Contains('sourceUrl')) {
        $url = "$($config.sourceUrl)"
        if (-not (Get-PSResourceRepository -Name $source -ErrorAction SilentlyContinue)) {
            Register-PSResourceRepository -Name $source -Uri $url -Trusted -ErrorAction Stop | Out-Null
            Write-Message "Registered vendor repository '$source' -> $url"
        }
    }

    $source
}
