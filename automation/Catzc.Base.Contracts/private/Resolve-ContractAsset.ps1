<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Resolve-ContractAsset.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-AUTO-ZERO
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
---
#>

<#
.SYNOPSIS
    Derives one contract asset's facts from its name and place, and returns them as a ContractAsset.
.DESCRIPTION
    A schema targets the sample payload of its name beside it, else the real file at its path under the target root.
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Resolve-ContractAsset.ps1.md#comment1)
.PARAMETER Unit
    The deployable-unit folder name.
.PARAMETER Version
    The unit's version folder name.
.PARAMETER Module
    The owning module folder name.
.PARAMETER Path
    The asset's path under its module folder, '/'-separated.
.PARAMETER File
    The asset's absolute path, read to tell an empty fragment and to find a sample beside a schema.
.PARAMETER TargetRoot
    The empty path is the repository root, the default for a module with no target_roots entry.
    [comment:2](/docs/references/automation/catzc-base-contracts/private/Resolve-ContractAsset.ps1.md#comment2)
.PARAMETER Override
    The version's contract.yml direction overrides, keyed by `<module>/<path>`. Default: none.
.OUTPUTS
    [Catzc.Base.Contracts.ContractAsset]
.EXAMPLE
    Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file
.EXAMPLE
    Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file -TargetRoot .widget
#>
function Resolve-ContractAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset])]
    param(
        [Parameter(Mandatory)]
        [string] $Unit,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $File,

        [AllowEmptyString()]
        [string] $TargetRoot = [Catzc.Base.Contracts.ContractsConfig]::DefaultTargetRoot,

        [System.Collections.IDictionary] $Override = @{}
    )

    $name = [System.IO.Path]::GetFileName($File)
    $isEmpty = [string]::IsNullOrWhiteSpace([System.IO.File]::ReadAllText($File))
    $kind = Get-ContractAssetKind -Name $name -IsEmpty:$isEmpty

    $prefix = if ($TargetRoot) {
        "$TargetRoot/"
    }
    else {
        ''
    }
    $target = "$prefix$Path"
    $direction = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample) {
        $target = $null
        $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
    }
    elseif ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema) {
        $stem = $name.Substring(0, $name.Length - '.schema.json'.Length)
        $samplePattern = '^' + [regex]::Escape($stem) + '\.sample\.[^.]+$'
        $folder = [System.IO.Path]::GetDirectoryName($File)
        $samples = @([System.IO.Directory]::GetFiles($folder) |
                ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Where-Object { $_ -cmatch $samplePattern } |
                Sort-Object)
        $target = $prefix + $Path.Substring(0, $Path.Length - '.schema.json'.Length)
        if ($samples.Count -gt 1) {
            throw "contract asset 'contracts/$Unit/$Version/$Module/$Path': the schema sits beside $($samples.Count) sample payloads named '$stem' ($($samples -join ', ')); keep one sample per schema name (ADR-REPO-CONTRACT#6)."
        }
        if ($samples.Count -eq 1) {
            $slash = $Path.LastIndexOf('/')
            $relative = if ($slash -ge 0) {
                $Path.Substring(0, $slash + 1) + $samples[0]
            }
            else {
                $samples[0]
            }
            $target = "contracts/$Unit/$Version/$Module/$relative"
            $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
        }
    }

    $key = "$Module/$Path"
    $isOverridden = $Override.ContainsKey($key)
    if ($isOverridden) {
        $direction = $Override[$key]
    }

    [Catzc.Base.Contracts.ContractAsset]::new($Unit, $Version, $Module, $Path, $kind, $target, $direction, $isOverridden)
}
