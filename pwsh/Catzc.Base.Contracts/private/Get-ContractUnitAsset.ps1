<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractUnitAsset.ps1
    folder: private
    name: get-contract-unit-asset
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
    docs: "[Get-ContractUnitAsset.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractUnitAsset.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
---
#>

function Get-ContractUnitAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Unit,

        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [SupportsWildcards()]
        [string[]] $Version,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TargetRoot,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $stray = @([System.IO.Directory]::GetFiles($Folder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    if ($stray.Count -gt 0) {
        throw "contracts/${Unit}: '$($stray -join "', '")' sits outside a version folder; a unit folder holds only contracts/<unit>/<version>/ (ADR-REPO-CONTRACT-LAYOUT)."
    }

    $versionFolders = [string[]] [System.IO.Directory]::GetDirectories($Folder)
    [System.Array]::Sort($versionFolders, [System.StringComparer]::Ordinal)
    $misnamed = @($versionFolders | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Where-Object { $_ -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$' })
    if ($misnamed.Count -gt 0) {
        throw "contracts/${Unit}: '$($misnamed -join "', '")' is not a version folder; a version folder is named <major>.<minor>.<patch> (ADR-REPO-CONTRACT-LAYOUT)."
    }

    foreach ($versionFolder in $versionFolders) {
        $versionName = [System.IO.Path]::GetFileName($versionFolder)
        if (@($Version | Where-Object { $versionName -like $_ }).Count -gt 0) {
            Get-ContractVersionAsset -Unit $Unit -Version $versionName -Folder $versionFolder -TargetRoot $TargetRoot -RepositoryRoot $RepositoryRoot
        }
    }
}
