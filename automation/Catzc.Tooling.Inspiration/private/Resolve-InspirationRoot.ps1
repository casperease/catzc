<#
---
catzc:
  immutable:
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
  config:
    synopsis: Resolves an inspiration's stored root to its binding form, a normalized absolute path.
    description: |-
      An inspiration's root is stored in communication form
      ([ADR-AUTO-PATH#6](/docs/adr/automation/path-representation.md#rule-adr-auto-path6)) and resolved only at the point
      of use ([ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3)):

        - '{workspace}/<folder>' resolves against the workspace, the parent folder of the repository root
          ([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11));
        - any other path goes through Resolve-RepoPath, so a repository-relative root resolves against the repository
          root and an absolute one passes through.

      Both pwsh's and Git Bash's view of a path resolve the same: the repository root, or an absolute root, given as
      '/c/projects/...' on Windows is read as 'C:/projects/...' (InspirationRoot.ToNative). The result is normalized
      with [IO.Path]::GetFullPath, so it is in the platform's own form.
    parameters:
      Root: 'The stored root: ''{workspace}/<folder>'', a repository-relative path, or an absolute path in either shell''s view.'
    examples:
      - 'Resolve-InspirationRoot ''{workspace}/eac''   # -> C:\projects\eac when the repository root is C:\projects\catzc'
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
