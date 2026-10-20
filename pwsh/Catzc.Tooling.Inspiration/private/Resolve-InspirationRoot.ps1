<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1
    folder: private
    name: resolve-inspiration-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
    docs: "[Resolve-InspirationRoot.ps1.md](docs/references/pwsh/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md)"
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
