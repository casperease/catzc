<#
.SYNOPSIS
    Checks that a fragment asset's target exists and contains the fragment, and returns the findings.
.DESCRIPTION
    The fragment check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6).
    The target must first be present, with the exact case of its path (Get-ContractPresenceFindings); a missing target
    is the only finding, since there is nothing to compare. Then, by the target's format (Get-ContractDataFormat):
    - Json or Yaml: both files are parsed and compared as a key subset (ContractFragment.MatchData: every key path of
      the fragment exists in the target, a scalar equals, an array element is matched by some target element, a null
      pins the key only). A file that does not parse is the finding.
    - any other text: every non-blank fragment line appears in the target in order, not necessarily adjacent, with
      trailing whitespace trimmed (ContractFragment.MatchLines).
.PARAMETER RepositoryRoot
    The repository root the asset and its target are relative to.
.PARAMETER Asset
    The fragment asset.
.OUTPUTS
    [string[]] The findings; none when the target contains the fragment.
.EXAMPLE
    Get-ContractFragmentFindings -RepositoryRoot $root -Asset $asset
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
