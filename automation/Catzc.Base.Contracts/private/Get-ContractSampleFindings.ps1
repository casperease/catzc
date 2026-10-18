<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1
    folder: private
    name: get-contract-sample-findings
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
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
