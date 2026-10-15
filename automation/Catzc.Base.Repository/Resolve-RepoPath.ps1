<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Resolve-RepoPath.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PATH
---
#>

<#
.SYNOPSIS
    Resolves a (possibly repo-relative or out/-anchored) path to an absolute one — never against $PWD.
.DESCRIPTION
    An 'out/' path binds to the output root, not the repo root, so one stored string fits devbox and pipeline.
.PARAMETER Path
    An absolute path is returned as given; only 'out/...' and other relative paths are re-anchored and normalized.
.EXAMPLE
    Resolve-RepoPath 'automation/Catzc.Base.Repository/Get-RepositoryFile.ps1'
.EXAMPLE
    Resolve-RepoPath 'out/template/sample/main.json'   # -> {output-root}/template/sample/main.json
#>
function Resolve-RepoPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $forward = $Path.Replace('\', '/')

    if ($forward -eq 'out' -or $forward.StartsWith('out/')) {
        $remainder = $forward.Substring([Math]::Min(4, $forward.Length))
        $outputRoot = Get-OutputRoot
        if ([string]::IsNullOrEmpty($remainder)) {
            return [IO.Path]::GetFullPath($outputRoot)
        }
        return [IO.Path]::GetFullPath((Join-Path $outputRoot $remainder))
    }

    if ([IO.Path]::IsPathRooted($Path)) {
        return $Path
    }

    [IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) $Path))
}
