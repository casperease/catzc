<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Get-GitCurrentBranch.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Files/tests/Get-GitCurrentBranch.Tests.ps1
  config:
    synopsis: Returns the current git branch name (or 'HEAD' when detached).
    description: |-
      The branch HEAD is on in the checkout at Get-RepositoryRoot, read from its HEAD file in-process
      ([Catzc.Base.Git.GitRefs]) — what `git rev-parse --abbrev-ref HEAD` answers, without starting git.
    examples:
      - Get-GitCurrentBranch
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
