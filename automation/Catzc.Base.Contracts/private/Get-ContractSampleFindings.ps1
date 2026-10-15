<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
---
#>

<#
.SYNOPSIS
    Checks that a sample payload parses, and validates against the schema beside it when one exists; returns the findings.
.DESCRIPTION
    That the owning module produces or parses the sample is its own tests' work, not this check's.
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractSampleFindings.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the asset is relative to.
.PARAMETER Asset
    The sample payload asset.
.OUTPUTS
    [string[]] The findings; none when the sample parses and validates.
.EXAMPLE
    Get-ContractSampleFindings -RepositoryRoot $root -Asset $asset
#>
function Get-ContractSampleFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    $file = Join-Path $RepositoryRoot $Asset.AssetPath
    $stem = [System.IO.Path]::GetFileName($file) -creplace '\.sample\.[^.]+$', ''
    $schemaName = "$stem.schema.json"
    $siblings = @([System.IO.Directory]::GetFiles([System.IO.Path]::GetDirectoryName($file)) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    if (@($siblings | Where-Object { $_ -ceq $schemaName }).Count -gt 0) {
        $folder = $Asset.AssetPath.Substring(0, $Asset.AssetPath.LastIndexOf('/') + 1)
        return Get-ContractSchemaFindings -RepositoryRoot $RepositoryRoot -SchemaPath "$folder$schemaName" -InstancePath $Asset.AssetPath
    }

    try {
        $null = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
    }
    catch {
        return $_.Exception.Message
    }
}
