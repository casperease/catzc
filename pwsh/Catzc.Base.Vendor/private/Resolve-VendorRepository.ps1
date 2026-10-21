<#
---
catzc:
  immutable:
    with_body_sha: e99bfc928109
  edges:
    test: pwsh/Catzc.Base.Vendor/tests/Resolve-VendorRepository.Tests.ps1
    docs: "[Resolve-VendorRepository.ps1.md](docs/references/pwsh/catzc-base-vendor/private/Resolve-VendorRepository.ps1.md)"
---
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
