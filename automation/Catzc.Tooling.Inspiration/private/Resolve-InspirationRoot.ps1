<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1
    folder: private
    name: resolve-inspiration-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
    cites:
      - ADR-AUTO-PATH#{3,6,11}
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
