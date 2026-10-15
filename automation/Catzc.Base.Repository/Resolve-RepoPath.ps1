<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Resolve-RepoPath.ps1
    kind: automation-function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PATH
  config:
    synopsis: Resolves a (possibly repo-relative or out/-anchored) path to an absolute one — never against $PWD.
    description: |-
      Companion to ConvertTo-RepoRelativePath, and the binding helper for the path-representation contract
      ([ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Resolution rules, in order:

        - A path under the reserved 'out/' anchor resolves against Get-OutputRoot, NOT the repository root.
          The output root is context-dependent ({root}/out on a devbox, the external staging directory in a
          pipeline), so the SAME stored 'out/...' string re-anchors to the right place in either context.
          This is why an output artifact is stored 'out/...' rather than degraded to a machine-specific
          absolute: it stays portable across the build->deploy boundary.
        - An already-absolute path is returned unchanged.
        - Any other relative path resolves against Get-RepositoryRoot.

      Use this in PowerShell consumers (Import-Module, Test-Path, Get-Content, …) before touching a path
      that came from a source relative to the repo or anchored at out/. Code that hands the path to an external tool
      via Invoke-Executable does NOT need this for repo-relative paths — that runs from the repo root — but
      DOES need it for out/-anchored paths, whose root is not the repo root.
    parameters:
      Path: |-
        The path to resolve. Absolute -> returned as-is. 'out/...' -> joined onto Get-OutputRoot. Other
        relative -> joined onto Get-RepositoryRoot. All results are normalized to a full path.
    examples:
      - Resolve-RepoPath 'automation/Catzc.Base.Repository/Get-RepositoryFile.ps1'
      - 'Resolve-RepoPath ''out/template/sample/main.json''   # -> {output-root}/template/sample/main.json'
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
        return $Path
    }

    [IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) $Path))
}
