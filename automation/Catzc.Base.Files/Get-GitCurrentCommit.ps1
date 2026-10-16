<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Get-GitCurrentCommit.ps1
    name: get-git-current-commit
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-GitCurrentCommit.Tests.ps1
  config:
    synopsis: Returns the current git commit hash (full 40-char SHA).
    description: |-
      The commit HEAD names in the checkout at Get-RepositoryRoot, read from its ref files in-process
      ([Catzc.Base.Git.GitRefs]) — what `git rev-parse HEAD` answers, without starting git.
    examples:
      - Get-GitCurrentCommit
---
#>

function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
