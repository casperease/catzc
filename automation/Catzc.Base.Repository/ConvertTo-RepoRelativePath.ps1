<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PATH
      - ADR-AUTO-PATH#5
---
#>

<#
.SYNOPSIS
    Normalizes a path to its communication form: out/-anchored, then repo-root-relative, else absolute.
.DESCRIPTION
    No hybrid form: a path under neither root stays absolute, and the out/ anchor is tried first.
.PARAMETER Path
    The path to normalize. Need not exist.
.EXAMPLE
    ConvertTo-RepoRelativePath 'C:\repo\catzc\out\template\sample\main.json'   # -> out/template/sample/main.json
.EXAMPLE
    ConvertTo-RepoRelativePath 'C:\repo\catzc\automation\mod\file.ps1'         # -> automation/mod/file.ps1
.EXAMPLE
    ConvertTo-RepoRelativePath 'D:\a\1\ws\sample\main.json'                   # outside both roots -> unchanged (absolute)
#>
function ConvertTo-RepoRelativePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $full = [IO.Path]::GetFullPath($Path)

    # Output root first: a pipeline's staging area sits outside the repo, so only 'out/' keeps it portable.
    # [comment:2](/docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md#comment2)
    $outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))
    $fromOutput = [IO.Path]::GetRelativePath($outputRoot, $full)
    if ($fromOutput -ne $full -and -not $fromOutput.StartsWith('..')) {
        if ($fromOutput -eq '.') {
            return 'out'
        }
        return 'out/' + ($fromOutput -replace '\\', '/')
    }

    # 2. Otherwise repo-root-relative; 3. else degrade to a normalized absolute path.
    $root = [IO.Path]::GetFullPath((Get-RepositoryRoot))
    $relative = [IO.Path]::GetRelativePath($root, $full)
    if ($relative -eq $full -or $relative.StartsWith('..')) {
        return $full
    }

    $relative -replace '\\', '/'
}
