# catzc:
#   path: automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1
#   module: Catzc.Tooling.Inspiration
#   visibility: private

<#
.SYNOPSIS
    Resolves an inspiration's stored root to its binding form, a normalized absolute path.
.DESCRIPTION
    Both pwsh and Git Bash views resolve alike: on Windows '/c/projects' is read as 'C:/projects'.
    [ADR-AUTO-PATH#6](/docs/adr/automation/path-representation.md#rule-adr-auto-path6),
    [ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3),
    [ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)
    [comment:1](/docs/references/automation/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md#comment1)
.PARAMETER Root
    The stored root: '{workspace}/<folder>', a repository-relative path, or an absolute path in either shell's view.
.EXAMPLE
    Resolve-InspirationRoot '{workspace}/eac'   # -> C:\projects\eac when the repository root is C:\projects\catzc
#>
function Resolve-InspirationRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Root
    )

    $path = if ([Catzc.Tooling.Inspiration.InspirationRoot]::IsWorkspaceAnchored($Root)) {
        [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace($Root, (Get-RepositoryRoot), $IsWindows)
    }
    else {
        Resolve-RepoPath ([Catzc.Tooling.Inspiration.InspirationRoot]::ToNative($Root, $IsWindows))
    }
    [IO.Path]::GetFullPath($path)
}
