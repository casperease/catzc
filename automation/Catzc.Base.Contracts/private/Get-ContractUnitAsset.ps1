<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/private/Get-ContractUnitAsset.ps1
    folder: private
    name: get-contract-unit-asset
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
      - ADR-REPO-CONTRACT#{2,5}
  config:
    synopsis: Lists the contract assets of the selected versions of one unit.
    description: |-
      A unit folder, contracts/<unit>/, holds only version folders named <major>.<minor>.<patch>
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)); 0.0.0 is the unit's draft
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). Every version folder name is
      checked, selected or not, so a misnamed folder throws on any listing; a file directly in the unit folder throws too.
      A selection that matches no version folder gives nothing. Versions come in ordinal order.
    parameters:
      Unit: The deployable-unit folder name.
      Folder: The unit folder's absolute path.
      Version: The version folder names to list; wildcards allowed.
      TargetRoot: |-
        The target roots, module name to repository-relative folder
        ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). A module it does not name
        takes the repository root.
    outputs: '[Catzc.Base.Contracts.ContractAsset[]]'
    examples:
      - Get-ContractUnitAsset -Unit widget -Folder $unitFolder -Version 0.0.0 -TargetRoot @{}
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
