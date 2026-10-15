<#
.SYNOPSIS
    Finds every dot-prefixed folder under contracts/, and returns one finding per folder.
.DESCRIPTION
    contracts/ holds no dot-prefixed folder at any depth: a dot prefix marks a repository root as infrastructure, so...
    [ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10),
    [ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4),
    [ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root that holds contracts/.
.OUTPUTS
    [string[]] The findings; none when no folder under contracts/ is dot-prefixed.
.EXAMPLE
    Get-ContractDotFolderFindings -RepositoryRoot $root
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

    $folders = [string[]] @([System.IO.Directory]::GetDirectories($contractsRoot, '*', [System.IO.SearchOption]::AllDirectories) |
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
