# catzc:
#   path: automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
#   module: Catzc.Base.Overlay
#   visibility: public

<#
.SYNOPSIS
    Returns every reason a .ps1 file is not one function, named for the file, that can be loaded anywhere.
.DESCRIPTION
    A file loaded away from its folder must never read PSScriptRoot, which then names another folder.
    [ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5),
    [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md),
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    [comment:1](/docs/references/automation/catzc-base-overlay/Get-FunctionFileViolation.ps1.md#comment1)
.PARAMETER Path
    The file to check.
.PARAMETER RelativePath
    The file's name as the messages should show it (a repository- or overlay-relative path).
.OUTPUTS
    [string] One message per violation; nothing when the file passes.
.EXAMPLE
    Get-FunctionFileViolation -Path ./automation/Catzc.Base.Widget/Get-Widget.ps1 -RelativePath automation/Catzc.Base.Widget/Get-Widget.ps1
#>
function Get-FunctionFileViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RelativePath
    )

    $expectedName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $tokens = $null
    $parseErrors = $null
    $syntaxTree = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $parseErrors)

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

    $isScriptRootRead = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst] -and $node.VariablePath.UserPath -ieq 'PSScriptRoot'
    }
    foreach ($read in $syntaxTree.FindAll($isScriptRootRead, $true)) {
        "${RelativePath}:$($read.Extent.StartLineNumber): reads `$PSScriptRoot, which names the merged file's folder in a build; locate content with Get-CatzcModuleRoot (ADR-AUTO-ASSETDEP#1)"
    }
}
