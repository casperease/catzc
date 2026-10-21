<#
---
catzc:
  immutable:
    with_body_sha: "248648d5aece"
  edges:
    test: pwsh/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
    docs: "[Resolve-InspirationRoot.ps1.md](../../../docs/references/pwsh/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md)"
    cites:
      - ADR-AUTO-PATH-BINDINGFORMONLYATBINDING
      - ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM
      - ADR-AUTO-PATH-WORKSPACEANCHOR
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
