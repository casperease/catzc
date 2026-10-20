<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Assert-SourceTree.ps1
    name: assert-source-tree
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Assert-SourceTree.Tests.ps1
    docs: "[Assert-SourceTree.ps1.md](docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE
---
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
