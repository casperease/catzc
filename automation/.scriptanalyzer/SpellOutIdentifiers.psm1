<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/SpellOutIdentifiers.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: enforce spelled-out identifier names — no invented local abbreviations.
.DESCRIPTION
    Tokenizing with no length floor catches short coined names that the spelling check lets pass.
    [comment:1](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment1)
#>

# Runs at rule time, not module load: the analyzer's runspace does not inherit the importer's loaded assemblies.
# [comment:2](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment2)
$script:oracleReady = $false   # declared at load so the guard reads it strict-clean
function Initialize-SpellingOracle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Runs inside the analyzer engine, whose custom rules may emit only diagnostic records; it binds the committed types assembly the importer already loaded and announced, and in a bare analyzer shard process there is no console session to announce to')]
    param()

    if ($script:oracleReady) {
        return
    }
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))

    if (-not ('Catzc.Base.QualityGates.SpellingOracle' -as [type])) {
        # Keyed by the shared source hash, never by file age, and loaded as a shadow copy so no host locks a build.
        # [comment:3](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment3)
        Import-Module (Join-Path $repoRoot 'automation/.internal/Catzc.Internal.Types.psm1')
        $automationRoot = Join-Path $repoRoot 'automation'
        $combinedHash = (Get-CombinedTypeHash $automationRoot).CombinedHash
        $typesDll = Join-Path $automationRoot ".compiled/Catzc.Types.$combinedHash.dll"
        if (-not [System.IO.File]::Exists($typesDll)) {
            throw "Measure-SpellOutIdentifiers: the compiled types assembly for the current sources ($typesDll) was not found — run the importer to build it."
        }
        Import-TypesAssembly -Path $typesDll | Out-Null
    }

    $englishPath = Join-Path $repoRoot 'automation/Catzc.Base.QualityGates/assets/english.txt.gz'
    $cspellDir = Join-Path $repoRoot '.cspell'
    $allTermPaths = if ([System.IO.Directory]::Exists($cspellDir)) {
        [string[]] @([System.IO.Directory]::EnumerateFiles($cspellDir, '*.txt'))
    }
    else {
        [string[]] @()
    }
    # Kept apart from the main vocabulary so the oracle accepts fixture terms only when analysing a test file.
    # [comment:4](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment4)
    $fixturePaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -eq 'fixture.txt' })
    $termPaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -ne 'fixture.txt' })
    [Catzc.Base.QualityGates.SpellingOracle]::Initialize($englishPath, [string[]] $termPaths, [string[]] $fixturePaths)
    $script:oracleReady = $true
}

# Automatic / preference / well-known variables the language owns — never identifier choices, so never flagged.
# [comment:5](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment5)
$script:skipVariables = [System.Collections.Generic.HashSet[string]]::new(
    [string[]]@(
        '_', 'PSItem', 'this', 'null', 'true', 'false',
        'PSCmdlet', 'PSBoundParameters', 'MyInvocation', 'ExecutionContext',
        'PSScriptRoot', 'PSCommandPath', 'PSDefaultParameterValues',
        'ErrorActionPreference', 'InformationPreference', 'WarningPreference',
        'DebugPreference', 'VerbosePreference', 'ProgressPreference',
        'ConfirmPreference', 'WhatIfPreference',
        'LASTEXITCODE', 'PROFILE', 'HOME', 'Host', 'PID', 'PWD', 'ShellId',
        'StackTrace', 'Error', 'Event', 'EventArgs', 'EventSubscriber', 'Sender',
        'Matches', 'OFS', 'FormatEnumerationLimit', 'MaximumHistoryCount',
        'input', 'args', 'ConsoleFileName', 'NestedPromptLevel',
        'IsWindows', 'IsMacOS', 'IsLinux', 'IsCoreCLR', 'ErrorView'
    ),
    [System.StringComparer]::OrdinalIgnoreCase
)

function Measure-SpellOutIdentifiers {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    Initialize-SpellingOracle

    # A test file may use fixture vocabulary; production code may not.
    # [comment:6](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment6)
    $isTestScope = Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst -IncludeTestsFolder

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-SpellOutIdentifiers'
    # A name read ten times is one naming problem, so each coined name is reported once per file.
    # [comment:7](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment7)
    $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Every reference, not only definitions, so a coined name is caught wherever it is defined; predicate as a local.
    # [comment:8](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment8)
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($variable in $ScriptBlockAst.FindAll($isVariable, $true)) {
        $variablePath = $variable.VariablePath
        # $env:, $function:, $variable: … — an external/special drive, not an identifier we choose.
        # [comment:9](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment9)
        if ($variablePath.DriveName) {
            continue
        }
        $name = $variablePath.UserPath
        # Strip a scope prefix (script:Foo → Foo) before checking the bare name.
        if ($name -match '^(script|global|private|local|using|workflow):(.+)$') {
            $name = $Matches[2]
        }
        if ($script:skipVariables.Contains($name) -or $reported.Contains($name)) {
            continue
        }
        $coined = [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments($name, $isTestScope)
        if ($coined.Count -gt 0) {
            [void] $reported.Add($name)
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Variable '`$$name' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-AUTO-SPELL#1), or add it to terminology.yml if it is genuine vocabulary (ADR-AUTO-SPELL#7)."
                    Extent   = $variable.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    # The noun of each function name (the verb is checked by PSUseApprovedVerbs).
    # [comment:10](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment10)
    $isFunction = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    foreach ($function in $ScriptBlockAst.FindAll($isFunction, $true)) {
        $functionName = $function.Name
        $noun = if ($functionName -match '^[^-]+-(.+)$') {
            $Matches[1]
        }
        else {
            $functionName
        }
        $key = "function:$functionName"
        if ($reported.Contains($key)) {
            continue
        }
        $coined = [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments($noun, $isTestScope)
        if ($coined.Count -gt 0) {
            [void] $reported.Add($key)
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function noun in '$functionName' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-AUTO-SPELL#1), or add it to terminology.yml if it is genuine vocabulary (ADR-AUTO-SPELL#7)."
                    Extent   = $function.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
