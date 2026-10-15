<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/CatzcRules.psm1
    kind: other
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The check modules load nested in this rule module, inside the analyzer engine; nothing in the session changes, so there is no state to announce')]
param()

Set-StrictMode -Version Latest   # this module's scope: the entry rule runs strict inside the analyzer engine

$checks = @(
    'VariableCasing'
    'NeverDependOnPwd'
    'FunctionLength'
    'NoWriteErrorOrWarning'
    'NoAzModuleNaming'
    'NoAutomaticVariableMisuse'
    'NoForEachObjectControlFlow'
    'NoRawVsoCommand'
    'NoRawPipelineDetection'
    'NoRawInformationStream'
    'NoRawConsoleWrite'
    'AnnounceStateChange'
    'SpellOutIdentifiers'
    'NoScriptRootAnchor'
    'NoEnvRepositoryRoot'
    'ParameterDesign'
    'NoUnsafeFirstIndex'
    'NoBareCacheEntryRead'
)

# Declared null at load so the strict-mode guard can read it before the first root block fills it.
# [comment:1](/docs/references/automation/scriptanalyzer/CatzcRules.psm1.md#comment1)
$script:measures = $null

<#
.SYNOPSIS
    The one custom PSScriptAnalyzer rule the settings load: runs every repository check once per file.
.DESCRIPTION
    One entry rule acting only on the root block, so each check runs once per file instead of once per script block.
    [comment:2](/docs/references/automation/scriptanalyzer/CatzcRules.psm1.md#comment2)
.PARAMETER ScriptBlockAst
    The script block the engine hands the rule; only a file's root block (no parent) is acted on.
#>
function Measure-CatzcRules {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Only the file's root block: every check walks the whole tree from it.
    if ($ScriptBlockAst.Parent) {
        return
    }

    # Nested loading keeps the Measure-* functions out of the engine's view, which would run each per block.
    # [comment:3](/docs/references/automation/scriptanalyzer/CatzcRules.psm1.md#comment3)
    if ($null -eq $script:measures) {
        $script:measures = @(foreach ($check in $checks) {
                $module = Import-Module (Join-Path $PSScriptRoot "$check.psm1") -PassThru
                $module.ExportedFunctions.Values | Where-Object { $_.Name -like 'Measure-*' }
            })
    }

    foreach ($measure in $script:measures) {
        & $measure -ScriptBlockAst $ScriptBlockAst
    }
}

Export-ModuleMember -Function Measure-CatzcRules
