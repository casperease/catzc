<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractCheckResult.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
---
#>

<#
.SYNOPSIS
    Checks one contract asset against the repository by its kind, and returns the result.
.DESCRIPTION
    A schema aimed at a sample is only checked well-formed here, so a defect gives one finding on one result.
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractCheckResult.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the asset and its target are relative to.
.PARAMETER Asset
    The asset to check.
.OUTPUTS
    [Catzc.Base.Contracts.ContractCheckResult]
.EXAMPLE
    Get-ContractCheckResult -RepositoryRoot $root -Asset $asset
#>
function Get-ContractCheckResult {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractCheckResult])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    $findings = [string[]] @(switch ($Asset.Kind) {
            ([Catzc.Base.Contracts.ContractAssetKind]::Presence) {
                Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target
            }
            ([Catzc.Base.Contracts.ContractAssetKind]::Fragment) {
                Get-ContractFragmentFindings -RepositoryRoot $RepositoryRoot -Asset $Asset
            }
            ([Catzc.Base.Contracts.ContractAssetKind]::Schema) {
                $moduleFolder = "contracts/$($Asset.Unit)/$($Asset.Version)/$($Asset.Module)/"
                $leaf = $Asset.Target.Substring($Asset.Target.LastIndexOf('/') + 1)
                $onSample = $Asset.Target.StartsWith($moduleFolder, [System.StringComparison]::Ordinal) -and
                (Get-ContractAssetKind -Name $leaf) -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample
                if ($onSample) {
                    Get-ContractSchemaFindings -RepositoryRoot $RepositoryRoot -SchemaPath $Asset.AssetPath
                }
                else {
                    $missing = @(Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
                    if ($missing.Count -gt 0) {
                        $missing
                    }
                    else {
                        Get-ContractSchemaFindings -RepositoryRoot $RepositoryRoot -SchemaPath $Asset.AssetPath -InstancePath $Asset.Target
                    }
                }
            }
            ([Catzc.Base.Contracts.ContractAssetKind]::Sample) {
                Get-ContractSampleFindings -RepositoryRoot $RepositoryRoot -Asset $Asset
            }
            default {
                throw [System.ArgumentException]::new("Get-ContractCheckResult: '$($Asset.AssetPath)' is of kind '$($Asset.Kind)', which no check covers.")
            }
        })
    [Catzc.Base.Contracts.ContractCheckResult]::new($Asset, $findings)
}
