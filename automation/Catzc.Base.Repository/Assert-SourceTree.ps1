<#
.SYNOPSIS
    Throws when the session runs a built Catzc package instead of the catzc source tree.
.DESCRIPTION
    A guard for tools that operate on the catzc source repository by definition — lint and format quality gates,...
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-repository/Assert-SourceTree.ps1.md#comment1)
.PARAMETER Command
    The name of the guarded tool, used in the error message. Defaults to the calling command's name.
.EXAMPLE
    Assert-SourceTree
.EXAMPLE
    Assert-SourceTree -Command 'Format-Types'
#>
function Assert-SourceTree {
    [CmdletBinding()]
    param(
        [string] $Command
    )

    if ((Get-CatzcRunMode) -eq 'source') {
        return
    }

    $commandName = $Command
    if (-not $commandName) {
        $caller = (Get-PSCallStack)[1]
        $commandName = $caller.Command
    }

    throw "$commandName operates on the catzc source tree; this session runs a built Catzc package ($(Get-CatzcModulesRoot)). Load the repository with importer.ps1 to use it."
}
