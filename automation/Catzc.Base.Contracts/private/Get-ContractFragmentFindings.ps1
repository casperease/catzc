<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/private/Get-ContractFragmentFindings.ps1
    folder: private
    name: get-contract-fragment-findings
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: Checks that a fragment asset's target exists and contains the fragment, and returns the findings.
    description: |-
      The fragment check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6).
      The target must first be present, with the exact case of its path (Get-ContractPresenceFindings); a missing target
      is the only finding, since there is nothing to compare. Then, by the target's format (Get-ContractDataFormat):
      - Json or Yaml: both files are parsed and compared as a key subset (ContractFragment.MatchData: every key path of
        the fragment exists in the target, a scalar equals, an array element is matched by some target element, a null
        pins the key only). A file that does not parse is the finding.
      - any other text: every non-blank fragment line appears in the target in order, not necessarily adjacent, with
        trailing whitespace trimmed (ContractFragment.MatchLines).
    parameters:
      RepositoryRoot: The repository root the asset and its target are relative to.
      Asset: The fragment asset.
    outputs: '[string[]] The findings; none when the target contains the fragment.'
    examples:
      - Get-ContractFragmentFindings -RepositoryRoot $root -Asset $asset
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
