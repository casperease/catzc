<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/private/Resolve-VendorRepository.ps1
    kind: function
    module: Catzc.Base.Vendor
    visibility: private
---
#>

<#
.SYNOPSIS
    Resolves the PSResourceRepository name the vendor functions download from and validate against.
.DESCRIPTION
    A stripped install fails here with a clear message, not a missing-cmdlet error from deep in a vendor call.
    [comment:1](/docs/references/automation/catzc-base-vendor/private/Resolve-VendorRepository.ps1.md#comment1)
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
    $source = $config.source

    if ($config.sourceUrl) {
        $url = $config.sourceUrl
        if (-not (Get-PSResourceRepository -Name $source -ErrorAction SilentlyContinue)) {
            Register-PSResourceRepository -Name $source -Uri $url -Trusted -ErrorAction Stop | Out-Null
            Write-Message "Registered vendor repository '$source' -> $url"
        }
    }

    $source
}
