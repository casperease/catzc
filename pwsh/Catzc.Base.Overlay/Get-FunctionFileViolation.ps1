<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
    name: get-function-file-violation
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Overlay
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Overlay/tests/Get-FunctionFileViolation.Tests.ps1
    docs: "[Get-FunctionFileViolation.ps1.md](docs/references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md)"
    cites:
      - ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
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
        "${RelativePath}:$($read.Extent.StartLineNumber): reads `$PSScriptRoot, which names the merged file's folder in a build; locate content with Get-CatzcModuleRoot (ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY)"
    }
}
