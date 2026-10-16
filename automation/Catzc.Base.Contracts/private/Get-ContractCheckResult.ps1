<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractCheckResult.ps1
    folder: private
    name: get-contract-check-result
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: Checks one contract asset against the repository by its kind, and returns the result.
    description: |-
      Runs the check of the asset's kind ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
      - Presence: the target exists with the exact case of its path (Get-ContractPresenceFindings);
      - Fragment: the target exists and contains the fragment (Get-ContractFragmentFindings);
      - Schema on a real file: the target exists and validates against the schema (Get-ContractSchemaFindings);
      - Schema on a sample payload (its target is a sample under the asset's own module folder): the schema is well-formed
        and uses the supported keywords only; the sample is not validated here, since its own check does that, so a
        defect gives one finding on one result;
      - Sample: the payload parses, and validates against the schema beside it (Get-ContractSampleFindings).
      A failed check is findings on the result, never an exception.
    parameters:
      RepositoryRoot: The repository root the asset and its target are relative to.
      Asset: The asset to check.
    outputs: '[Catzc.Base.Contracts.ContractCheckResult]'
    examples:
      - Get-ContractCheckResult -RepositoryRoot $root -Asset $asset
---
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
