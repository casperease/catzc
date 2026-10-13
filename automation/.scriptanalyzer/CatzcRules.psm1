Set-StrictMode -Version Latest   # this module's scope: the entry rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    The one custom PSScriptAnalyzer rule the settings load: runs every repository check once per file.
.DESCRIPTION
    PSScriptAnalyzer calls a script rule once for every ScriptBlockAst in a file (the file, each function body, each
    script block literal) and pays a fixed cost per call, even for a rule that does nothing. This entry rule acts only
    on the file's root block and hands it to each check, so every check runs once per file and walks the whole tree
    from there.

    Each check lives in its own module next to this one, with its own tests, and keeps its own RuleName on the records
    it emits. Diagnostics, SuppressMessageAttribute('Measure-<Check>', …) and analyzer-adr-map.yml all name the check,
    never this entry rule. Add a new check module to $checks below (every Measure-* function it exports runs); the
    engine-wiring test (CustomRuleWiring.Tests.ps1) proves each check fires through the engine.
#>

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
    'NoUnsafeFirstIndex'
    'NoBareScriptSlotRead'
)

# Each check module loads nested in this one, so its Measure-* functions are visible here but not exported to the
# engine. A module may export more than one check.
$script:measures = @(foreach ($check in $checks) {
        $module = Import-Module (Join-Path $PSScriptRoot "$check.psm1") -PassThru
        $module.ExportedFunctions.Values | Where-Object { $_.Name -like 'Measure-*' }
    })

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

    foreach ($measure in $script:measures) {
        & $measure -ScriptBlockAst $ScriptBlockAst
    }
}

Export-ModuleMember -Function Measure-CatzcRules
