Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: enforce spelled-out identifier names — no invented local abbreviations.
.DESCRIPTION
    Backs [ADR-AUTO-SPELL#1](/docs/adr/automation/powershell/spell-out-names.md#rule-adr-auto-spell1). Every variable
    name, parameter name, and the noun
    of every function name is tokenized (camelCase / PascalCase / snake_case) and each fragment is checked
    against the SpellingOracle — the union of cspell's English words (assets/english.txt.gz) and the approved
    terminology (.cspell/*.txt: domain vocabulary + the conventional-abbreviation allow-list). A fragment that
    is neither a real word nor approved vocabulary is an invented abbreviation and is flagged.

    This catches what Test-Spelling cannot: cspell's minWordLength (4) lets short coined tokens (rcg, and
    camelCase fragments <= 3 chars) pass silently; tokenizing identifiers with no length floor catches them.

    The oracle (load + tokenize + lookup) is a native C# type because a PowerShell method call costs
    ~10 microseconds — looking up thousands of fragments per file in PowerShell would dominate the analyzer's
    runtime. The rule calls the oracle once per identifier.
#>

# Bring the oracle type into THIS runspace and load its dictionary, once. This must run at rule-invocation
# time, not at module load: PSScriptAnalyzer resolves and runs custom rules in its own runspace, whose
# type-resolution table does not inherit assemblies the importer loaded in the parent — and the analyzer
# shards are bare pwsh processes with neither our module system nor $env:RepositoryRoot. So resolve paths
# from $PSScriptRoot (this file lives at automation/.scriptanalyzer/) and load the current committed types
# assembly here. Idempotent: guarded by a module-scope flag, and the load is skipped when the type already resolves.
$script:oracleReady = $false   # declared at load so the guard reads it strict-clean
function Initialize-SpellingOracle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Runs inside the analyzer engine, whose custom rules may emit only diagnostic records; it binds the committed types assembly the importer already loaded and announced, and in a bare analyzer shard process there is no console session to announce to')]
    param()

    if ($script:oracleReady) {
        return
    }
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))

    if (-not ('Catzc.Base.QualityGates.SpellingOracle' -as [type])) {
        # The build for the CURRENT sources — keyed by the one shared hash (Get-CombinedTypeHash), never picked by
        # file age — loaded through the one shared load path (Import-TypesAssembly: a per-user shadow copy), so an
        # editor host or analyzer shard never locks a build inside .compiled. Catzc.Internal.Types has no importer
        # dependencies, so it imports by path even in a bare analyzer process.
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
    # Fixture terms (.cspell/fixture.txt) are test-only vocabulary
    # ([ADR-AUTO-SPELL#6](/docs/adr/automation/powershell/spell-out-names.md#rule-adr-auto-spell6)): kept separate so
    # the oracle
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

    Initialize-SpellingOracle

    # A test file may use fixture vocabulary
    # ([ADR-AUTO-SPELL#6](/docs/adr/automation/powershell/spell-out-names.md#rule-adr-auto-spell6)); production code may
    # not. Fixture terms are accepted
    # only when the file under analysis is a test (`*.Tests.ps1` or under a `tests/` folder).
    $isTestScope = Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst -IncludeTestsFolder

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-SpellOutIdentifiers'
    # Report each distinct coined name once per file, not once per occurrence — a variable read ten times is
    # one naming problem.
    $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Every variable reference — assignment targets, parameters, loop variables, and reads — so a coined name
    # is caught wherever it is defined. Predicate as a local
    # ([ADR-AUTO-PSFORMAT#6](/docs/adr/automation/powershell/powershell-formatting.md#rule-adr-auto-psformat6)).
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($variable in $ScriptBlockAst.FindAll($isVariable, $true)) {
        $variablePath = $variable.VariablePath
        # $env:, $function:, $variable: … — an external/special drive, not an identifier we choose
        # ([ADR-AUTO-SPELL#4](/docs/adr/automation/powershell/spell-out-names.md#rule-adr-auto-spell4)).
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
                    Message  = "Variable '`$$name' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-AUTO-SPELL:1), or add it to terminology.yml if it is genuine vocabulary (ADR-AUTO-SPELL:7)."
                    Extent   = $variable.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    # The noun of each function name (the verb is checked by PSUseApprovedVerbs). Predicate as a local
    # ([ADR-AUTO-PSFORMAT#6](/docs/adr/automation/powershell/powershell-formatting.md#rule-adr-auto-psformat6)).
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
                    Message  = "Function noun in '$functionName' has non-word fragment(s): $($coined -join ', '). Spell it out in full (ADR-AUTO-SPELL:1), or add it to terminology.yml if it is genuine vocabulary (ADR-AUTO-SPELL:7)."
                    Extent   = $function.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
