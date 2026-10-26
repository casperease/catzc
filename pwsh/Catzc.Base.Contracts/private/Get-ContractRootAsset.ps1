<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractRootAsset.ps1.md"
  header: "generated"
---
#>

function Get-ContractRootAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [SupportsWildcards()]
        [string[]] $Version,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    $stray = @($layout.FileNames($Folder))
    if ($stray.Count -gt 0) {
        throw "contracts/${Root}: '$($stray -join "', '")' sits outside a version folder; a root folder holds only contracts/<root>/<version>/ (ADR-REPO-CONTRACT-LAYOUT)."
    }

    $versionFolders = $layout.Folders($Folder)
    $misnamed = @($versionFolders | ForEach-Object { [System.IO.Path]::GetFileName($_) } |
        Where-Object { $_ -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$' })
    if ($misnamed.Count -gt 0) {
        throw "contracts/${Root}: '$($misnamed -join "', '")' is not a version folder; a version folder is named <major>.<minor>.<patch> (ADR-REPO-CONTRACT-LAYOUT)."
    }

    foreach ($versionFolder in $versionFolders) {
        $versionName = [System.IO.Path]::GetFileName($versionFolder)
        if (@($Version | Where-Object { $versionName -like $_ }).Count -gt 0) {
            Get-ContractVersionAsset -Root $Root -Version $versionName -Folder $versionFolder -RepositoryRoot $RepositoryRoot
        }
    }
}
