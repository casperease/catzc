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
                $assetFolder = $Asset.AssetPath.Substring(0, $Asset.AssetPath.LastIndexOf('/') + 1)
                $leaf = $Asset.Target.Substring($Asset.Target.LastIndexOf('/') + 1)
                $onSample = $Asset.Target.StartsWith($assetFolder, [System.StringComparison]::Ordinal) -and
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
                # A schema states its guarantee in its $comment; an unparsable one is already a finding.
                $schema = try {
                    Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
                }
                catch {
                    $null
                }
                if ($schema -is [System.Collections.IDictionary]) {
                    $comment = $schema.Contains('$comment') ? "$($schema['$comment'])" : ''
                    Get-ContractDescriptionFindings -AssetPath $Asset.AssetPath -Key '$comment' -Description $comment
                }
            }
            ([Catzc.Base.Contracts.ContractAssetKind]::Sample) {
                Get-ContractSampleFindings -RepositoryRoot $RepositoryRoot -Asset $Asset
            }
            # A types surface is validated by the one types schema, whose asset targets it; here it only has to parse.
            ([Catzc.Base.Contracts.ContractAssetKind]::Types) {
                try {
                    $null = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
                }
                catch {
                    $_.Exception.Message
                }
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
