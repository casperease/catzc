<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/Assert-SourceTree.ps1
    name: assert-source-tree
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Assert-SourceTree.Tests.ps1
    cites:
      - ADR-DSGN-RUNMODE
  config:
    synopsis: Throws when the session runs a built Catzc package instead of the catzc source tree.
    description: |-
      A guard for tools that operate on the catzc source repository by definition — lint and format quality gates,
      dependency analysis over the per-function files, test discovery, and authoring steps that write back into
      automation/. In build mode
      ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)) those files are not where the loaded code lives, so the tool
      stops with a named error instead of silently reading or writing the wrong tree. Silent in source mode.
    parameters:
      Command: The name of the guarded tool, used in the error message. Defaults to the calling command's name.
    examples:
      - Assert-SourceTree
      - Assert-SourceTree -Command 'Format-Types'
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
