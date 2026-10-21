<#
---
catzc:
  immutable:
    with_body_sha: d70112f9fab3
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Resolve-RepoPath.Tests.ps1
    docs: "[Resolve-RepoPath.ps1.md](docs/references/pwsh/catzc-base-repository/Resolve-RepoPath.ps1.md)"
    cites:
      - ADR-AUTO-PATH
---
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
        return [IO.Path]::GetFullPath($Path)
    }

    [IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) $Path))
}
