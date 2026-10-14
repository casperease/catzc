<#
.SYNOPSIS
    Checks one contract asset against the repository by its kind, and returns the result.
.DESCRIPTION
    Runs the check of the asset's kind ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
    - Presence: the target exists with the exact case of its path (Get-ContractPresenceFindings);
    - Fragment: the target exists and contains the fragment (Get-ContractFragmentFindings);
    - Schema: the target exists and validates against the schema (Get-ContractSchemaFindings);
    - Sample: the payload parses, and validates against the schema beside it (Get-ContractSampleFindings).
    A failed check is findings on the result, never an exception.
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
                $missing = @(Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
                if ($missing.Count -gt 0) {
                    $missing
                }
                else {
                    Get-ContractSchemaFindings -RepositoryRoot $RepositoryRoot -SchemaPath $Asset.AssetPath -InstancePath $Asset.Target
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
