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
        $schema = ConvertTo-BclValue (Read-ContractData -RepositoryRoot $RepositoryRoot -Path $SchemaPath)
        if (-not $InstancePath) {
            return [Catzc.Base.Contracts.ContractSchema]::Inspect($schema)
        }
        $value = ConvertTo-BclValue (Read-ContractData -RepositoryRoot $RepositoryRoot -Path $InstancePath)
    }
    catch {
        return $_.Exception.Message
    }
    [Catzc.Base.Contracts.ContractSchema]::Validate($schema, $value)
}
