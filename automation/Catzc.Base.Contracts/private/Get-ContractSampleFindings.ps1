<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1
    folder: private
    name: get-contract-sample-findings
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: Checks that a sample payload parses, and validates against the schema beside it when one exists; returns the findings.
    description: |-
      The sample check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6).
      A sample payload `<name>.sample.<ext>` must be JSON or YAML by its extension and parse. When `<name>.schema.json`
      sits in the same folder, with exactly that case (the rule Get-Contract uses to aim that schema at the sample), the
      sample also validates against it (Get-ContractSchemaFindings). That the owning module produces or parses the sample
      is the module's own tests' work, not this check's.
    parameters:
      RepositoryRoot: The repository root the asset is relative to.
      Asset: The sample payload asset.
    outputs: '[string[]] The findings; none when the sample parses and validates.'
    examples:
      - Get-ContractSampleFindings -RepositoryRoot $root -Asset $asset
---
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
