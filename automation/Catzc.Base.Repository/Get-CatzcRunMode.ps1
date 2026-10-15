<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
    kind: public-function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-DSGN-RUNMODE#4
  config:
    synopsis: 'Returns the run mode of the current session: ''source'' or ''build''.'
    description: |-
      The mode is derived, never stored
      ([ADR-DSGN-RUNMODE#4](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4)). It is 'source' when the code root
      (Get-CatzcModulesRoot) is <RepositoryRoot>/automation — the modules were loaded in place by importer.ps1 — and
      'build' otherwise, when the modules were loaded from a built Catzc package by its Import-Catzc.ps1. The two
      roots are compared as normalized full paths, case-insensitively, so a trailing separator or a mixed-case
      drive letter never flips the answer.
    examples:
      - if ((Get-CatzcRunMode) -eq 'build') { ... }
---
#>

function Get-CatzcRunMode {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $modulesRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) 'automation')).TrimEnd('\', '/')

    if ($modulesRoot -ieq $sourceRoot) {
        return 'source'
    }
    'build'
}
