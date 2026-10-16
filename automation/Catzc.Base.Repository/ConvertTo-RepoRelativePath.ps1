<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Repository
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
      test: automation/Catzc.Base.Repository/tests/ConvertTo-RepoRelativePath.Tests.ps1
    adrs:
      - ADR-AUTO-PATH
  config:
    synopsis: 'Normalizes a path to its communication form: out/-anchored, then repo-root-relative, else absolute.'
    description: |-
      The "relative-where-possible" normalization for paths kept in records, configs, and long-lived information
      ([ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). It picks the anchor in order:

        1. Under the OUTPUT root (Get-OutputRoot) -> 'out/<remainder>' (forward slashes). The output root is
           context-dependent ({root}/out on a devbox, the external staging directory in a pipeline), so the
           reserved 'out/' sentinel keeps an output artifact portable across the build->deploy boundary:
           Resolve-RepoPath re-anchors it via Get-OutputRoot at the other end. A pipeline artifact that
           would otherwise have no repo-relative form (it lives outside the repo) is captured here.
        2. Under the REPOSITORY root (Get-RepositoryRoot) -> a plain repo-relative path (forward slashes).
        3. Under neither -> returned absolute (normalized). No repo/out-relative form exists; degrade
           honestly
           ([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)) rather than emit a hybrid.

      Pairs with Resolve-RepoPath, which turns the result back into an absolute path against the matching
      root.
    parameters:
      Path: The path to normalize. Need not exist.
    examples:
      - 'ConvertTo-RepoRelativePath ''C:\repo\catzc\out\template\sample\main.json''   # -> out/template/sample/main.json'
      - 'ConvertTo-RepoRelativePath ''C:\repo\catzc\automation\mod\file.ps1''         # -> automation/mod/file.ps1'
      - 'ConvertTo-RepoRelativePath ''D:\a\1\ws\sample\main.json''                   # outside both roots -> unchanged (absolute)'
---
#>

function ConvertTo-RepoRelativePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $full = [IO.Path]::GetFullPath($Path)

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
