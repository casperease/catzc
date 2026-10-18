# automation/.scriptanalyzer/SpellOutIdentifiers.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:oracleReady = $false   # declared at load so the guard reads it...`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: enforce spelled-out identifier names — no invented local abbreviations.
.DESCRIPTION
    Tokenizing with no length floor catches short coined names that the spelling check lets pass.
    [comment:1](/docs/references/automation/scriptanalyzer/SpellOutIdentifiers.psm1.md#comment1)
```

## comment:2

Above `$script:oracleReady = $false   # declared at load so the guard reads it...`, written with `#`.

```text
Bring the oracle type into THIS runspace and load its dictionary, once. This must run at rule-invocation
time, not at module load: PSScriptAnalyzer resolves and runs custom rules in its own runspace, whose
type-resolution table does not inherit assemblies the importer loaded in the parent — and the analyzer
shards are bare pwsh processes with neither our module system nor $env:RepositoryRoot. So resolve paths
from $PSScriptRoot (this file lives at automation/.scriptanalyzer/) and load the current committed types
assembly here. Idempotent: guarded by a module-scope flag, and the load is skipped when the type already resolves.
```

## comment:3

Above `Import-Module (Join-Path $modulesRoot '.internal/Catzc.Internal.Types.psm1')`, written with `#`.

```text
The build for the CURRENT sources — keyed by the one shared hash (Get-CombinedTypeHash), never picked by
file age — loaded through the one shared load path (Import-TypesAssembly: a per-user shadow copy), so an
editor host or analyzer shard never locks a build inside .compiled. Catzc.Internal.Types has no importer
dependencies, so it imports by path even in a bare analyzer process.
```

## comment:4

Above `$fixturePaths = [string[]] @($allTermPaths | Where-Object {...`, written with `#`.

```text
Fixture terms (.cspell/fixture.txt) are test-only vocabulary
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)): kept separate so
the oracle
accepts them only when analyzing a test file, never in production code.
```

## comment:5

Above `$script:skipVariables = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
Automatic / preference / well-known variables the language owns — never identifier choices, so never
flagged. Mirrors the skip set in VariableCasing.psm1.
```

## comment:6

Above `$isTestScope = Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst...`, written with `#`.

```text
A test file may use fixture vocabulary
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)); production code may
not. Fixture terms are accepted
only when the file under analysis is a test (`*.Tests.ps1` or under a `tests/` folder).
```

## comment:7

Above `$reported =...`, written with `#`.

```text
Report each distinct coined name once per file, not once per occurrence — a variable read ten times is
one naming problem.
```

## comment:8

Above `$isVariable = {`, written with `#`.

```text
Every variable reference — assignment targets, parameters, loop variables, and reads — so a coined name
is caught wherever it is defined. Predicate as a local
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:9

Above `if ($variablePath.DriveName) {`, written with `#`.

```text
$env:, $function:, $variable: … — an external/special drive, not an identifier we choose
([ADR-AUTO-SPELL#4](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell4)).
```

## comment:10

Above `$isFunction = {`, written with `#`.

```text
The noun of each function name (the verb is checked by PSUseApprovedVerbs). Predicate as a local
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
