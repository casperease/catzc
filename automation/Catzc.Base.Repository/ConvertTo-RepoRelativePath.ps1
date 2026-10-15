<#
.SYNOPSIS
    Normalizes a path to its communication form: out/-anchored, then repo-root-relative, else absolute.
.DESCRIPTION
    The "relative-where-possible" normalization for paths kept in records, configs, and long-lived information.
    [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md),
    [ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)
    [comment:1](/docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md#comment1)
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

    # 1.
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
