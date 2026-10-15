<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Read-ContractManifest.ps1
    kind: private-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#7
---
#>

<#
.SYNOPSIS
    Reads a version folder's contract.yml, the direction overrides of its assets.
.DESCRIPTION
    An absent contract.yml is an empty manifest, since most version folders carry none; a malformed one throws.
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
