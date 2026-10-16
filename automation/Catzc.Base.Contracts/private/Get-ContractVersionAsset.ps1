<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md
    adrs:
      - ADR-PWSH-ENUM#3
      - ADR-REPO-CONTRACT#{2,5,7}
  config:
    synopsis: Lists every contract asset of one unit version folder, with its contract.yml overrides applied.
    description: |-
      A version folder, contracts/<unit>/<version>/, holds one folder per owning module and, optionally, its contract.yml
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2),
      [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every file under a module folder
      is an asset, at any depth. A released version folder also holds its .frozen record, the hash of each of its files
      that Publish-ContractRelease writes when it freezes the draft
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)); it is not an asset. Any other
      file at the version level, and a .frozen in the draft 0.0.0, has no owning module, and a contract.yml entry that
      names no asset overrides nothing; both throw, naming the file or the entry. Each asset's target sits under its
      module's target root, which ContractsConfig.ResolveTargetRoot picks from -TargetRoot
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). Assets come in ordinal
      order of module, then path.
    parameters:
      Unit: The deployable-unit folder name.
      Version: The unit's version folder name.
      Folder: The version folder's absolute path.
      TargetRoot: The target roots, module name to repository-relative folder. A module it does not name takes the repository root.
    outputs: '[Catzc.Base.Contracts.ContractAsset[]]'
    examples:
      - Get-ContractVersionAsset -Unit widget -Version 0.0.0 -Folder $versionFolder -TargetRoot @{}
---
#>

function Get-ContractVersionAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Unit,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TargetRoot
    )

    $stray = @([System.IO.Directory]::GetFiles($Folder) |
            ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Where-Object { $_ -cne 'contract.yml' -and -not ($_ -ceq '.frozen' -and $Version -cne '0.0.0') })
    if ($stray.Count -gt 0) {
        throw "contracts/$Unit/${Version}: '$($stray -join "', '")' sits outside a module folder; an asset lives under contracts/<unit>/<version>/<module>/ (ADR-REPO-CONTRACT#2)."
    }

    $override = (Read-ContractManifest -Folder $Folder).direction
    $used = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $moduleFolders = [string[]] [System.IO.Directory]::GetDirectories($Folder)
    [System.Array]::Sort($moduleFolders, [System.StringComparer]::Ordinal)
    $assets = foreach ($moduleFolder in $moduleFolders) {
        $module = [System.IO.Path]::GetFileName($moduleFolder)
        $root = [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($TargetRoot, $module)
        $files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude @() -PruneVendor $false)
        $paths = [string[]] @($files | ForEach-Object { [System.IO.Path]::GetRelativePath($moduleFolder, $_) -replace '\\', '/' })
        [System.Array]::Sort($paths, [System.StringComparer]::Ordinal)
        foreach ($path in $paths) {
            $null = $used.Add("$module/$path")
            Resolve-ContractAsset -Unit $Unit -Version $Version -Module $module -Path $path -File (Join-Path $moduleFolder $path) -TargetRoot $root -Override $override
        }
    }

    $unknown = @($override.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unknown.Count -gt 0) {
        throw "contracts/$Unit/$Version/contract.yml: the direction of '$($unknown -join "', '")' is overridden, but no such asset exists under the version folder (ADR-REPO-CONTRACT#7)."
    }
    $assets
}
