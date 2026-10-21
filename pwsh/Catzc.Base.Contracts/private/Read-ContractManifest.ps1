<#
---
catzc:
  immutable:
    with_body_sha: b94756141d4e
  edges:
    docs: "[Read-ContractManifest.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/private/Read-ContractManifest.ps1.md)"
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
