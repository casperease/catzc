<#
---
catzc:
  immutable:
    repo_status: clean
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
