<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/SpellOutIdentifiers.psm1
    kind: analyzer-rule
    relatives:
      page: docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

$script:oracleReady = $false   # declared at load so the guard reads it strict-clean
function Initialize-SpellingOracle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Runs inside the analyzer engine, whose custom rules may emit only diagnostic records; it binds the committed types assembly the importer already loaded and announced, and in a bare analyzer shard process there is no console session to announce to')]
    param()

    if ($script:oracleReady) {
        return
    }
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))

    if (-not ('Catzc.Base.QualityGates.SpellingOracle' -as [type])) {
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
    $fixturePaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -eq 'fixture.txt' })
    $termPaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -ne 'fixture.txt' })
    [Catzc.Base.QualityGates.SpellingOracle]::Initialize($englishPath, [string[]] $termPaths, [string[]] $fixturePaths)
    $script:oracleReady = $true
}

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

    $isTestScope = Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst -IncludeTestsFolder

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-SpellOutIdentifiers'
    $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($variable in $ScriptBlockAst.FindAll($isVariable, $true)) {
        $variablePath = $variable.VariablePath
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
