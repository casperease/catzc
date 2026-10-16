<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    adrs:
      - ADR-AUTO-PATH#7
  config:
    synopsis: Returns the full, normalized path to a folder relative to the repository root.
    description: |-
      A binding helper (see
      [ADR-AUTO-PATH#7](/docs/adr/automation/path-representation.md#rule-adr-auto-path7)): it takes a
      repo-relative path and returns the normalized absolute path to bind against — '.\', '..', and mixed
      separators collapse, so a leading './' never leaks into the result. Resolution is against the
      repository root, not $PWD. Delegates to Resolve-RepoPath so the normalization lives in one place.
    parameters:
      Path: Relative path from the repository root.
    examples:
      - Get-RepositoryFolder 'automation/Catzc.Base.Repository'
---
#>

function Get-RepositoryFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Resolve-RepoPath $Path
}
