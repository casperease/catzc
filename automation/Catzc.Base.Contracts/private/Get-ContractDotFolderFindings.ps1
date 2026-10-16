<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
    folder: private
    name: get-contract-dot-folder-findings
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
    page: docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
    cites:
      - ADR-PWSH-ENUM#3
      - ADR-REPO-CONTRACT#{2,10}
      - ADR-REPO-FOLDERS#4
  config:
    synopsis: Finds every dot-prefixed folder under contracts/, and returns one finding per folder.
    description: |-
      contracts/ holds no dot-prefixed folder at any depth
      ([ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)): a dot prefix marks a
      repository root as infrastructure ([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)),
      so an asset whose target sits under a dot-prefixed root reaches it through its module's target root in contracts.yml
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)) and never repeats the dot
      folder. Only the outermost dot-prefixed folder of a branch is a finding, since moving it moves what it holds. A
      dot-prefixed file name is not a finding: a released folder's .frozen record and an asset that pins a dotfile by its
      own name are files, and a target root relocates a folder but never renames a file. Findings come in ordinal path
      order; a missing contracts/ gives none.
    parameters:
      RepositoryRoot: The repository root that holds contracts/.
    outputs: '[string[]] The findings; none when no folder under contracts/ is dot-prefixed.'
    examples:
      - Get-ContractDotFolderFindings -RepositoryRoot $root
---
#>

function Get-ContractDotFolderFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if (-not [System.IO.Directory]::Exists($contractsRoot)) {
        return
    }

    $folders = [string[]] @(Get-ChildPath $contractsRoot -Directory -Depth 64 -Exclude @() -PruneVendor $false |
            ForEach-Object { [System.IO.Path]::GetRelativePath($contractsRoot, $_) -replace '\\', '/' })
    [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
    foreach ($folder in $folders) {
        $segments = $folder.Split('/')
        $dotted = @($segments | Where-Object { $_.StartsWith('.', [System.StringComparison]::Ordinal) })
        if ($dotted.Count -eq 1 -and $segments[-1].StartsWith('.', [System.StringComparison]::Ordinal)) {
            "contracts/$folder/ is a dot-prefixed folder under contracts/; place its assets at their paths under the owning module's target root, declared in contracts.yml's target_roots (ADR-REPO-CONTRACT#10)."
        }
    }
}
