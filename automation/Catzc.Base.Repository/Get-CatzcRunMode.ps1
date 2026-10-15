<#
.SYNOPSIS
    Returns the run mode of the current session: 'source' or 'build'.
.DESCRIPTION
    The mode is derived, never stored.
    [ADR-DSGN-RUNMODE#4](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md#comment1)
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
