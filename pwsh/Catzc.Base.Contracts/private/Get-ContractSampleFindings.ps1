<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1
    folder: private
    name: get-contract-sample-findings
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
    docs: "[Get-ContractSampleFindings.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractSampleFindings.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
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
