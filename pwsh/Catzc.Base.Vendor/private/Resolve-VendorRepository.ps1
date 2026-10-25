<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vendor/private/Resolve-VendorRepository.ps1.md"
  header: "generated"
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
