<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md"
  header: "generated"
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

    # A named whole-tree walk: the gate hunts stray folders, so nothing is pruned.
    $folders = [string[]] @(Get-ChildPath $contractsRoot -Directory -Depth 64 -Exclude @() -PruneVendor $false |
            ForEach-Object { [System.IO.Path]::GetRelativePath($contractsRoot, $_) -replace '\\', '/' })
    [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
    foreach ($folder in $folders) {
        $segments = $folder.Split('/')
        $dotted = @($segments | Where-Object { $_.StartsWith('.', [System.StringComparison]::Ordinal) })
        if ($dotted.Count -eq 1 -and $segments[-1].StartsWith('.', [System.StringComparison]::Ordinal)) {
            "contracts/$folder/ is a dot-prefixed folder under contracts/; name the files it constrains in the version's contract.yml applies_to instead (ADR-REPO-CONTRACT-NODOTFOLDERS)."
        }
    }
}
