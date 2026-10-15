# catzc:
#   path: automation/Catzc.Base.Contracts/private/Get-ContractSchemaFindings.ps1
#   module: Catzc.Base.Contracts
#   visibility: private

<#
.SYNOPSIS
    Validates one JSON or YAML file against a JSON Schema file, or checks the schema alone, and returns the findings.
.DESCRIPTION
    Without -InstancePath only the schema is checked well-formed, so a defect in a sample's schema gives one finding.
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractSchemaFindings.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.PARAMETER SchemaPath
    The schema file, repository-relative.
.PARAMETER InstancePath
    The file that validates against it, repository-relative. Default: none, and the schema is checked alone.
.OUTPUTS
    [string[]] The findings; none when the file validates, or with no instance, when the schema is well-formed.
.EXAMPLE
    Get-ContractSchemaFindings -RepositoryRoot $root -SchemaPath $asset.AssetPath -InstancePath $asset.Target
.EXAMPLE
    Get-ContractSchemaFindings -RepositoryRoot $root -SchemaPath $asset.AssetPath
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
