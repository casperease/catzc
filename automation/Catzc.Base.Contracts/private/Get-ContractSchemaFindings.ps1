<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractSchemaFindings.ps1
    folder: private
    name: get-contract-schema-findings
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
    synopsis: Validates one JSON or YAML file against a JSON Schema file, or checks the schema alone, and returns the findings.
    description: |-
      The schema check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
      shared by a schema asset and a sample payload with a schema beside it. Both files are parsed (Read-ContractData;
      YAML is parsed before it is validated) and the value validates against the bounded JSON Schema subset of
      ContractSchema, which ignores the annotation keywords and reports every other keyword outside the subset as
      unsupported. A file that does not parse, or is neither JSON nor YAML, is the finding.
      With no -InstancePath, only the schema is parsed and checked to be well-formed in the subset (ContractSchema.Inspect):
      a schema aimed at a sample payload is checked that way, since the sample's own check validates the sample, and a
      defect gives one finding, not two.
    parameters:
      RepositoryRoot: The repository root the paths are relative to.
      SchemaPath: The schema file, repository-relative.
      InstancePath: 'The file that validates against it, repository-relative. Default: none, and the schema is checked alone.'
    outputs: '[string[]] The findings; none when the file validates, or with no instance, when the schema is well-formed.'
    examples:
      - Get-ContractSchemaFindings -RepositoryRoot $root -SchemaPath $asset.AssetPath -InstancePath $asset.Target
      - Get-ContractSchemaFindings -RepositoryRoot $root -SchemaPath $asset.AssetPath
---
#>

function Get-ContractSchemaFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $SchemaPath,

        [string] $InstancePath
    )

    try {
        $schema = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $SchemaPath
        if (-not $InstancePath) {
            return [Catzc.Base.Contracts.ContractSchema]::Inspect($schema)
        }
        $value = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $InstancePath
    }
    catch {
        return $_.Exception.Message
    }
    [Catzc.Base.Contracts.ContractSchema]::Validate($schema, $value)
}
