<#
.SYNOPSIS
    Resolves a (possibly repo-relative or out/-anchored) path to an absolute one — never against $PWD.
.DESCRIPTION
    Companion to ConvertTo-RepoRelativePath, and the binding helper for the path-representation contract.
    [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)
    [comment:1](/docs/references/automation/catzc-base-repository/Resolve-RepoPath.ps1.md#comment1)
.PARAMETER Path
    The path to resolve.
    [comment:2](/docs/references/automation/catzc-base-repository/Resolve-RepoPath.ps1.md#comment2)
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
