<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-DSGN-RUNMODE#4
---
#>

<#
.SYNOPSIS
    Returns the run mode of the current session: 'source' or 'build'.
.DESCRIPTION
    Compared as normalized, case-insensitive full paths, so a trailing separator or drive-letter case never flips it.
.EXAMPLE
    if ((Get-CatzcRunMode) -eq 'build') { ... }
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
