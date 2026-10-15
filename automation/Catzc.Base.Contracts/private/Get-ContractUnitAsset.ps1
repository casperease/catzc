<#
.SYNOPSIS
    Lists the contract assets of the selected versions of one unit.
.DESCRIPTION
    Every version folder name is checked, selected or not, so a misnamed folder throws on any listing.
    [ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2),
    [ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractUnitAsset.ps1.md#comment1)
.PARAMETER Unit
    The deployable-unit folder name.
.PARAMETER Folder
    The unit folder's absolute path.
.PARAMETER Version
    The version folder names to list; wildcards allowed.
.PARAMETER TargetRoot
    A module the map does not name takes the repository root.
    [ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)
    [comment:2](/docs/references/automation/catzc-base-contracts/private/Get-ContractUnitAsset.ps1.md#comment2)
.OUTPUTS
    [Catzc.Base.Contracts.ContractAsset[]]
.EXAMPLE
    Get-ContractUnitAsset -Unit widget -Folder $unitFolder -Version 0.0.0 -TargetRoot @{}
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
        [System.Collections.IDictionary] $TargetRoot
    )

    $stray = @([System.IO.Directory]::GetFiles($Folder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    if ($stray.Count -gt 0) {
        throw "contracts/${Unit}: '$($stray -join "', '")' sits outside a version folder; a unit folder holds only contracts/<unit>/<version>/ (ADR-REPO-CONTRACT#2)."
    }

    $versionFolders = [string[]] [System.IO.Directory]::GetDirectories($Folder)
    [System.Array]::Sort($versionFolders, [System.StringComparer]::Ordinal)
    $misnamed = @($versionFolders | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Where-Object { $_ -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$' })
    if ($misnamed.Count -gt 0) {
        throw "contracts/${Unit}: '$($misnamed -join "', '")' is not a version folder; a version folder is named <major>.<minor>.<patch> (ADR-REPO-CONTRACT#2)."
    }

    foreach ($versionFolder in $versionFolders) {
        $versionName = [System.IO.Path]::GetFileName($versionFolder)
        if (@($Version | Where-Object { $versionName -like $_ }).Count -gt 0) {
            Get-ContractVersionAsset -Unit $Unit -Version $versionName -Folder $versionFolder -TargetRoot $TargetRoot
        }
    }
}
