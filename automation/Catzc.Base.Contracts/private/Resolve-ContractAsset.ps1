<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Resolve-ContractAsset.ps1
    kind: private-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-AUTO-ZERO
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
  config:
    synopsis: Derives one contract asset's facts from its name and place, and returns them as a ContractAsset.
    description: |-
      Zero ceremony ([ADR-AUTO-ZERO](/docs/adr/automation/zero-ceremony-poka-yoke.md)): the asset declares nothing.
      - Kind, from the file name (Get-ContractAssetKind,
        [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)).
      - Target: a presence or fragment constrains the real file at its own path under the module's target root; a
        `<path>.schema.json` constrains the real file at `<path>` under that root, unless a sample payload of the same
        `<name>` sits beside it (`<name>.sample.<ext>`), in which case it applies to that sample; a sample payload
        constrains no file ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)).
      - Direction, by convention ([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): an
        asset that constrains a real repository file is DependedOn; a sample payload, and the schema that applies to it,
        are Provided. An entry for `<module>/<path>` in -Override replaces the convention.
    parameters:
      Unit: The deployable-unit folder name.
      Version: The unit's version folder name.
      Module: The owning module folder name.
      Path: The asset's path under its module folder, '/'-separated.
      File: The asset's absolute path, read to tell an empty fragment and to find a sample beside a schema.
      TargetRoot: |-
        The module's target root, repository-relative; the empty path is the repository root. Default: ContractsConfig's
        DefaultTargetRoot, the repository root.
      Override: 'The version''s contract.yml direction overrides, keyed by `<module>/<path>`. Default: none.'
    outputs: '[Catzc.Base.Contracts.ContractAsset]'
    examples:
      - Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file
      - Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file -TargetRoot .widget
---
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
