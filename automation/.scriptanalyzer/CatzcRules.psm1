<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/CatzcRules.psm1
    folder: automation/.scriptanalyzer
    name: catzc-rules
    filetype: psm1
    kind: analyzer-rule
    language: powershell
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/CatzcRules.psm1.md
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
    'NoUnboundedEnumeration'
    'NoOneLineHashtableIfElse'
)

$script:measures = $null

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
