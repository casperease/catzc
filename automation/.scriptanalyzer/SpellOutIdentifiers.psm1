<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: enforce spelled-out identifier names — no invented local abbreviations.
.DESCRIPTION
    Backs docs/adr/automation/spell-out-names.md (ADR-SPELL:1). Every variable name, parameter name, and the noun
    of every function name is tokenized (camelCase / PascalCase / snake_case) and each fragment is checked
    against the SpellingOracle — the union of cspell's English words (assets/english.txt.gz) and the approved
    terminology (.cspell/*.txt: domain vocabulary + the conventional-abbreviation allow-list). A fragment that
    is neither a real word nor approved vocabulary is an invented abbreviation and is flagged.

    This catches what the cspell gate cannot: cspell's minWordLength (4) lets short coined tokens (rcg, and
    camelCase fragments <= 3 chars) pass silently; tokenizing identifiers with no length floor catches them.

    The oracle (load + tokenize + lookup) is a native C# type because a PowerShell method call costs
    ~10 microseconds — looking up thousands of fragments per file in PowerShell would dominate the analyzer's
    runtime. The rule calls the oracle once per identifier.
#>

# Bring the oracle type into THIS runspace and load its dictionary, once. This must run at rule-invocation
# time, not at module load: PSScriptAnalyzer resolves and runs custom rules in its own runspace, whose
# type-resolution table does not inherit assemblies the importer loaded in the parent — and the analyzer
# shards are bare pwsh processes with neither our module system nor $env:RepositoryRoot. So resolve paths
# from $PSScriptRoot (this file lives at automation/.scriptanalyzer/) and load the committed types assembly
# here. Idempotent: guarded by a module-scope flag, and Add-Type is skipped when the type already resolves.
function Initialize-SpellingOracle {
    if ($script:oracleReady) {
        return
    }
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))

    if (-not ('Catzc.Base.QualityGates.SpellingOracle' -as [type])) {
        $typesDll = Get-ChildItem -Path (Join-Path $repoRoot 'automation/.compiled') -Filter 'Catzc.Types.*.dll' -File -ErrorAction Ignore |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if (-not $typesDll) {
            throw 'Measure-SpellOutIdentifiers: the compiled types assembly (automation/.compiled/Catzc.Types.*.dll) was not found — run the importer to build it.'
        }
        Add-Type -Path $typesDll.FullName
    }

    $englishPath = Join-Path $repoRoot 'automation/Catzc.Base.QualityGates/assets/english.txt.gz'
    $cspellDir = Join-Path $repoRoot '.cspell'
    $allTermPaths = if ([System.IO.Directory]::Exists($cspellDir)) {
        [string[]] @([System.IO.Directory]::EnumerateFiles($cspellDir, '*.txt'))
    }
    else {
        [string[]] @()
    }
    # Fixture terms (.cspell/fixture.txt) are test-only vocabulary (ADR-SPELL:6): kept separate so the oracle
    # accepts them only when analyzing a test file, never in production code.
    $fixturePaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -eq 'fixture.txt' })
    $termPaths = [string[]] @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -ne 'fixture.txt' })
    [Catzc.Base.QualityGates.SpellingOracle]::Initialize($englishPath, [string[]] $termPaths, [string[]] $fixturePaths)
    $script:oracleReady = $true
}

# Automatic / preference / well-known variables the language owns — never identifier choices, so never
# flagged. Mirrors the skip set in VariableCasing.psm1.
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

    # PSScriptAnalyzer invokes a [ScriptBlockAst] rule once per scriptblock in the file — the top-level one and
    # every nested one. FindAll below already recurses, so process only the top-level scriptblock; a nested
    # invocation would re-find and re-report the same identifiers.
    if ($null -ne $ScriptBlockAst.Parent) {
        return
    }

    Initialize-SpellingOracle

    # A test file may use fixture vocabulary (ADR-SPELL:6); production code may not. Fixture terms are accepted
    # only when the file under analysis is a test (`*.Tests.ps1` or under a `tests/` folder).
    $file = $ScriptBlockAst.Extent.File
    $isTestScope = [bool] $file -and ($file -match '\.Tests\.ps1$' -or $file -match '[\\/]tests[\\/]')

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-SpellOutIdentifiers'
    # Report each distinct coined name once per file, not once per occurrence — a variable read ten times is
    # one naming problem.
    $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Every variable reference — assignment targets, parameters, loop variables, and reads — so a coined name
    # is caught wherever it is defined. Predicate as a local (ADR-PSFORMAT:6).
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($variable in $ScriptBlockAst.FindAll($isVariable, $true)) {
        $variablePath = $variable.VariablePath
        # $env:, $function:, $variable: … — an external/special drive, not an identifier we choose (ADR-SPELL:4).
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
                    Message  = "Variable '`$$name' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-SPELL:1), or add it to terminology.yml if it is genuine vocabulary (ADR-SPELL:7)."
                    Extent   = $variable.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    # The noun of each function name (the verb is gated by PSUseApprovedVerbs). Predicate as a local (ADR-PSFORMAT:6).
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
                    Message  = "Function noun in '$functionName' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-SPELL:1), or add it to terminology.yml if it is genuine vocabulary (ADR-SPELL:7)."
                    Extent   = $function.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
