<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.DevOps/tests/Get-AdoRepositoryName.Tests.ps1
    adrs:
      - ADR-PWSH-PARAM#4
  config:
    synopsis: 'The Azure DevOps repository this checkout is: the sensible default for every -RepositoryName.'
    description: |-
      In a pipeline, the agent's own repository ($env:BUILD_REPOSITORY_NAME); on a devbox, the checkout folder's
      name (the leaf of Get-RepositoryRoot), which is the repository's name in a default clone. The one place the
      ADO functions derive the name, declared as their -RepositoryName default
      ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)), so an
      explicit argument always wins and Get-Help shows where the default comes from.
    outputs: '[string] The repository name.'
    examples:
      - Get-AdoRepositoryName
---
#>

function Get-AdoRepositoryName {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($env:BUILD_REPOSITORY_NAME) {
        return $env:BUILD_REPOSITORY_NAME
    }
    Split-Path (Get-RepositoryRoot) -Leaf
}
