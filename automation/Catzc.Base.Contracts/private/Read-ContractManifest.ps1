<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/private/Read-ContractManifest.ps1
    folder: private
    name: read-contract-manifest
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CONTRACT#7
  config:
    synopsis: Reads a version folder's contract.yml, the direction overrides of its assets.
    description: |-
      The per-version manifest of [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7) sits at
      contracts/<unit>/<version>/contract.yml. Most version folders carry none, so an absent file is an empty manifest.
      The ContractManifest type validates what it reads and throws on a malformed file.
    parameters:
      Folder: The version folder's absolute path.
    outputs: '[Catzc.Base.Contracts.ContractManifest]'
    examples:
      - (Read-ContractManifest -Folder $versionFolder).direction
---
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
