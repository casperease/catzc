<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractFragmentFindings.ps1
    folder: private
    name: get-contract-fragment-findings
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
    docs: "[Get-ContractFragmentFindings.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractFragmentFindings.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

function Get-ContractFragmentFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    $missing = @(Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
    if ($missing.Count -gt 0) {
        return $missing
    }

    if (-not (Get-ContractDataFormat -Path $Asset.Target)) {
        $fragmentText = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Asset.AssetPath))
        $targetText = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Asset.Target))
        return [Catzc.Base.Contracts.ContractFragment]::MatchLines($fragmentText, $targetText)
    }

    try {
        $fragment = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
        $target = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.Target
    }
    catch {
        return $_.Exception.Message
    }
    [Catzc.Base.Contracts.ContractFragment]::MatchData($fragment, $target)
}
