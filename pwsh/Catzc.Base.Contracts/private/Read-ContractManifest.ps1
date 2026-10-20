<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Read-ContractManifest.ps1
    folder: private
    name: read-contract-manifest
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Read-ContractManifest.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Read-ContractManifest.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
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
