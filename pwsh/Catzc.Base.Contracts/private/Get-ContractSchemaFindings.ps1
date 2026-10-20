<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractSchemaFindings.ps1
    folder: private
    name: get-contract-schema-findings
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ContractSchemaFindings.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractSchemaFindings.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
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
