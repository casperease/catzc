<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/private/Get-GitIndexPath.ps1
    folder: private
    name: get-git-index-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Files/tests/Get-GitIndexPath.Tests.ps1
  config:
    synopsis: Returns the absolute path of the repository's git index file.
    description: |-
      The index of the checkout at Get-RepositoryRoot: `<root>/.git/index` for a plain checkout, or
      `<gitdir>/index` when `.git` is a file (`gitdir: <path>` — a linked worktree or a submodule), with a
      relative gitdir resolved against the root ([Catzc.Base.Git.GitRefs], read in-process). Throws when the root
      is not a git checkout. The file itself may be absent (a fresh `git init` with nothing added) — the caller
      reads that as "nothing tracked".
    outputs: '[string]'
---
#>

function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
