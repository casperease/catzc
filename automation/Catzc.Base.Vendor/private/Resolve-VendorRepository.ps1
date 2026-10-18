<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Vendor/private/Resolve-VendorRepository.ps1
    folder: private
    name: resolve-vendor-repository
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Vendor/tests/Resolve-VendorRepository.Tests.ps1
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
