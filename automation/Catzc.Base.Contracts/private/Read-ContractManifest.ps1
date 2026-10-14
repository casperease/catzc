<#
.SYNOPSIS
    Reads a version folder's contract.yml, the direction overrides of its assets.
.DESCRIPTION
    The per-version manifest of [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7) sits at
    contracts/<unit>/<version>/contract.yml. Most version folders carry none, so an absent file is an empty manifest.
    The ContractManifest type validates what it reads and throws on a malformed file.
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
