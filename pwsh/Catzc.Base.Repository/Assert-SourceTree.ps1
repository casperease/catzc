<#
---
catzc:
  immutable:
    with_body_sha: "7fef3803990d"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Assert-SourceTree.Tests.ps1
    docs: "[Assert-SourceTree.ps1.md](../../docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md)"
    cites:
      - DDR-RUNMODE
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
