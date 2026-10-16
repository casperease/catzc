<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Overlay
    visibility: public
    relatives:
      test: automation/Catzc.Base.Overlay/tests/Get-FunctionFileViolation.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-MANIFEST#5
  config:
    synopsis: Returns every reason a .ps1 file is not one function, named for the file, that can be loaded anywhere.
    description: |-
      The one check of a function file's shape, read from its syntax tree, shared by the two places that load a
      function file away from the folder it was written in: the build, which merges a module's function files into one
      file (the merge preconditions,
      [ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), and a consumer
      overlay, whose override file is loaded into a built module
      ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). A file passes when it parses; it defines exactly
      one function, named for the file, and nothing else at the top level (no param block, no begin/process blocks,
      no other statement); it carries no `using` statement and no `#requires`; and it never reads $PSScriptRoot,
      which names another folder once the file is loaded elsewhere
      ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
    parameters:
      Path: The file to check.
      RelativePath: The file's name as the messages should show it (a repository- or overlay-relative path).
      ParsedScripts: |-
        The call's shared parse of each script; a caller checking many files passes one so a file is parsed once.
    outputs: '[string] One message per violation; nothing when the file passes.'
    examples:
      - Get-FunctionFileViolation -Path ./automation/Catzc.Base.Widget/Get-Widget.ps1 -RelativePath automation/Catzc.Base.Widget/Get-Widget.ps1
---
#>

function Get-FunctionFileViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    $expectedName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $script = $ParsedScripts.Get($Path)
    $parseErrors = $script.Errors
    $syntaxTree = $script.Ast

    foreach ($parseError in @($parseErrors)) {
        "${RelativePath}:$($parseError.Extent.StartLineNumber): does not parse ($($parseError.Message))"
    }
    if (@($parseErrors).Count -gt 0) {
        return
    }

    if ($syntaxTree.ScriptRequirements) {
        "${RelativePath}: carries a #requires statement; a merged file cannot hold per-file requirements"
    }
    if (@($syntaxTree.UsingStatements).Count -gt 0) {
        "${RelativePath}: carries a using statement; a merged file cannot hold per-file using statements"
    }
    if ($syntaxTree.ParamBlock -or $syntaxTree.BeginBlock -or $syntaxTree.ProcessBlock -or $syntaxTree.DynamicParamBlock) {
        "${RelativePath}: has a script-level param/begin/process block; only one function may sit at the top level"
    }

    $statements = @(if ($syntaxTree.EndBlock) {
            $syntaxTree.EndBlock.Statements
        })
    $functions = @($statements | Where-Object { $_ -is [System.Management.Automation.Language.FunctionDefinitionAst] })
    if ($statements.Count -ne 1 -or $functions.Count -ne 1) {
        "${RelativePath}: must hold exactly one top-level statement, the function '$expectedName' (found $($statements.Count) statement(s), $($functions.Count) function(s))"
    }
    elseif ($functions[0].Name -cne $expectedName) {
        "${RelativePath}: defines function '$($functions[0].Name)', but the file is named for '$expectedName'"
    }

    foreach ($read in [Catzc.Base.Repository.SyntaxSearch]::VariableReads($syntaxTree, 'PSScriptRoot')) {
        "${RelativePath}:$($read.Extent.StartLineNumber): reads `$PSScriptRoot, which names the merged file's folder in a build; locate content with Get-CatzcModuleRoot (ADR-AUTO-ASSETDEP#1)"
    }
}
