<#
.SYNOPSIS
    Validates one JSON or YAML file against a JSON Schema file, and returns the findings.
.DESCRIPTION
    The schema check of ADR-REPO-CONTRACT#6 ([api-contracts](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)),
    shared by a schema asset (on a real file or on the sample payload beside it) and a sample payload with a schema
    beside it. Both files are parsed (Read-ContractData; YAML is parsed before it is validated) and the value validates
    against the bounded JSON Schema subset of ContractSchema, which reports every keyword outside the subset as
    unsupported. A file that does not parse, or is neither JSON nor YAML, is the finding.
.PARAMETER RepositoryRoot
    The repository root both paths are relative to.
.PARAMETER SchemaPath
    The schema file, repository-relative.
.PARAMETER InstancePath
    The file that validates against it, repository-relative.
.OUTPUTS
    [string[]] The findings; none when the file validates.
.EXAMPLE
    Get-ContractSchemaFindings -RepositoryRoot $root -SchemaPath $asset.AssetPath -InstancePath $asset.Target
#>
function Get-ContractSchemaFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $SchemaPath,

        [Parameter(Mandatory)]
        [string] $InstancePath
    )

    try {
        $schema = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $SchemaPath
        $value = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $InstancePath
    }
    catch {
        return $_.Exception.Message
    }
    [Catzc.Base.Contracts.ContractSchema]::Validate($schema, $value)
}
