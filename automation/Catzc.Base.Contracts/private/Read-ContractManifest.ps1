<#
.SYNOPSIS
    Reads a version folder's contract.yml, the direction overrides of its assets.
.DESCRIPTION
    The per-version manifest of sits at contracts/<unit>/<version>/contract.yml.
    [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Read-ContractManifest.ps1.md#comment1)
.PARAMETER Folder
    The version folder's absolute path.
.OUTPUTS
    [Catzc.Base.Contracts.ContractManifest]
.EXAMPLE
    (Read-ContractManifest -Folder $versionFolder).direction
#>
function Read-ContractManifest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractManifest])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Folder
    )

    $file = Join-Path $Folder 'contract.yml'
    if (-not [System.IO.File]::Exists($file)) {
        return [Catzc.Base.Contracts.ContractManifest]::new($null)
    }
    $raw = Get-Content -LiteralPath $file -Raw | ConvertFrom-Yaml -Ordered
    [Catzc.Base.Contracts.ContractManifest]::new($raw)
}
