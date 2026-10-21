<#
---
catzc:
  immutable:
    with_body_sha: "73c45f1ff05c"
  edges:
    docs: "[Get-ContractCheckResult.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractCheckResult.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE
      - ADR-REPO-CONTRACT-CONTRACTASSET
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
            ([Catzc.Base.Contracts.ContractAssetKind]::Command) {
                Get-ContractCommandFindings -RepositoryRoot $RepositoryRoot -Asset $Asset
            }
            default {
                throw [System.ArgumentException]::new("Get-ContractCheckResult: '$($Asset.AssetPath)' is of kind '$($Asset.Kind)', which no check covers.")
            }
        })
    [Catzc.Base.Contracts.ContractCheckResult]::new($Asset, $findings)
}
