<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md"
  header: "generated"
---
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
