# ADR: PowerShell formatting — the language layer over uniform-formatting

## Rules: ADR-PWSH-FORMAT

### Rule ADR-PWSH-FORMAT-UNIFORMBASELINE

PowerShell formatting builds on the repo-wide uniform-formatting baseline ([Context](#context)) and adds the PowerShell-specific rules
below, enforced by PSScriptAnalyzer (`PSScriptAnalyzerSettings.psd1`) plus custom analyzer rules, run in the L2 tests.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT-KANDRBRACES

Brace style is K&R — the opening brace on the same line — enforced by `PSPlaceOpenBrace`.

- [Brace style](#brace-style)

### Rule ADR-PWSH-FORMAT-FOURSPACEINDENT

Indentation is 4 spaces (the PowerShell community default), set by `.editorconfig`'s `[*.{ps1,psm1,psd1}]` section on top of the repo
baseline.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT-VARIABLECASING

Variable casing: PascalCase for parameters and scoped variables, camelCase for locals — enforced by the custom `Measure-VariableCasing` rule
(scriptblock params and automatic variables excluded).

- [Variable casing](#variable-casing)

### Rule ADR-PWSH-FORMAT-EVERYFILECOVERED

Every authored PowerShell file the repository ships or runs is covered by the formatting and analysis quality gates — including the root
`importer.ps1` and authored `.psd1` config — resolved through one shared selector so no file escapes by living outside the module tree.
Generated module manifests are excluded: they are build output, made canonical by their generator.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND

A multi-line predicate passed to `.FindAll(...)` (or any method call) is bound to a local variable first, never written inline inside the
call's parentheses. A paren-nested multi-line scriptblock is the one construct where PSScriptAnalyzer versions compute
`PSUseConsistentIndentation` differently — so the inline form squiggles in the editor (whose bundled analyzer differs from vendored 1.25.0)
even though the gate accepts it, and the two formatters fight over the indent. A `$x = { … }` assignment has no paren nesting, so every
version indents it identically.

- [Scriptblock arguments](#scriptblock-arguments)

### Rule ADR-PWSH-FORMAT-ANALYZERRECORDMAPPING

The analyzer→ADR mapping — the source for the `pssa-rule` enforcer kind — lives in `Catzc.Base.QualityGates/configs/analyzer-drs-map.yml`,
each enabled analyzer rule (a custom `Measure-*` rule or an enabled built-in) mapped to the citation(s) it enforces. Its shape is validated
at load (its config type, `AnalyzerDrsMapConfig`); the `Test-AnalyzerDrsMap` quality gate checks that every mapped id resolves to a real
rule and that **every custom analyzer rule is mapped**, and an **integrity test** runs it, so a new custom rule cannot ship unmapped and a
renumber breaks the build. Id existence is checked by that gate, not at load, keeping config load hermetic.

- [The analyzer map](#the-analyzer-map)

### Rule ADR-PWSH-FORMAT-STEPASSERTIONS

The step assertions of [ADR-AUTO-NONEST-ASSERTBETWEENSTEPS](../avoid-deep-nesting.md#rule-adr-auto-nonest-assertbetweensteps) are `Assert-*`
calls on the named intermediate, on the line after the step that produced it. Inside a pipeline that must stay one statement,
`Assert-PipelineCount` asserts mid-pipeline and passes the items through.

- [Flat steps](#flat-steps)

### Rule ADR-PWSH-FORMAT-SIMPLEEXPRESSIONS

The simple expressions [ADR-AUTO-NONEST-SIMPLEEXPRESSIONSEXEMPT](../avoid-deep-nesting.md#rule-adr-auto-nonest-simpleexpressionsexempt)
exempts are, in PowerShell, a `Join-Path` onto an anchor, a single property access (`$moduleDir.Name`), a straightforward cast, and a short
pipeline of two obvious stages (`Get-ChildPath … | Sort-Object`).

- [Flat steps](#flat-steps)

### Rule ADR-PWSH-FORMAT-MULTILINEHASHTABLE

A hashtable literal that holds an `if`/`else` is written on several lines, or its value is bound to a local first, never written on one
line. PSScriptAnalyzer's `Invoke-Formatter` throws on the one-line form, and because `Format-Code` and `Test-Formatting` format every file
in one pass, one such file stops the quality gate's formatting pass for the whole tree instead of failing a single file. The custom
`Measure-NoOneLineHashtableIfElse` rule flags it.

- [One-line hashtables](#one-line-hashtables)

### Rule ADR-PWSH-FORMAT-NOTRAILINGSEMICOLONS

Never use trailing semicolons; statements end at the newline. A `;` at the end of a line with nothing after it is dead C#/dotnet syntax.

- [Semicolons](#semicolons)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT-SINGLELINECHAINING

Single-line chaining is allowed: `$x = 1; $y = 2` on one line chains two statements. The rule targets the habit of ending every line with
`;`, not concise single-line expressions.

- [Semicolons](#semicolons)

### Rule ADR-PWSH-FORMAT-FORHEADERSEXEMPT

`for` loop headers are exempt: `for ($i = 0; $i -lt $n; $i++)` requires semicolons as syntactic separators.

- [The two semicolon exceptions](#the-two-semicolon-exceptions)

### Rule ADR-PWSH-FORMAT-INLINEHASHTABLESEXEMPT

Inline hash table literals are exempt: `@{ A = 1; B = 2 }` is idiomatic PowerShell.

- [The two semicolon exceptions](#the-two-semicolon-exceptions)

## Context

The repository's uniform formatting fixes the cross-language baseline every file meets (UTF-8 without BOM, LF, spaces, trimmed trailing
whitespace, final newline) and the repo-wide "tools format, never debate" policy. PowerShell adds a layer on top that is thicker — brace
placement, variable casing, line length, and the full PSScriptAnalyzer rule set — because PowerShell is the bulk of the codebase and has the
richest analyzer support. This ADR records the PowerShell-specific choices; the baseline and the never-hand-format policy live in
uniform-formatting and are not repeated here.

### Brace style

K&R — the opening brace on the same line — is the most common style in PowerShell. `PSPlaceOpenBrace` enforces it.

```powershell
# YES — K&R style
if ($condition) {
    Do-Something
}

# NO — Allman style
if ($condition)
{
    Do-Something
}
```

### Variable casing

PascalCase for parameters and scoped variables, camelCase for locals. This makes it immediately clear in a diff whether a variable is a
parameter, module-level state, or a throwaway local.

```powershell
function Get-Config {
    param(
        [string] $EnvironmentName        # PascalCase — parameter
    )

    $script:ConfigCache = ...             # PascalCase — module state
    $configPath = Join-Path ...           # camelCase  — local
}
```

### Scriptblock arguments

A multi-line scriptblock nested in a method call's parentheses is the one place PSScriptAnalyzer's `PSUseConsistentIndentation` is
version-sensitive: the editor extension's bundled analyzer wants the body indented one level, vendored 1.25.0 wants two. The inline form
then squiggles in the editor while the gate (1.25.0) stays green, and "Format Document" and `Format-Code` disagree on the indent. Binding
the predicate to a local removes the paren nesting, so every version indents it the same.

```powershell
# NO — paren-nested multi-line scriptblock; editor and gate disagree on the body indent
$nodes = $ScriptBlockAst.FindAll({
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }, $true)

# YES — predicate bound to a local first; no paren nesting, so all versions indent it identically
$isCommand = {
    param($node)
    $node -is [System.Management.Automation.Language.CommandAst]
}
$nodes = $ScriptBlockAst.FindAll($isCommand, $true)
```

### One-line hashtables

`Invoke-Formatter` throws "Operation is not valid due to the current state of the object" on a hashtable literal that sits on one line and
holds an `if`/`else`, with or without a `$( )` around it. A hashtable on several lines, and an `if` without an `else`, are read without
trouble. The throw comes out of the formatting pass's background job, so the quality gate fails for the whole tree before it reports a
single file. Binding the value to a local first keeps the hashtable short and the `if`/`else` readable.

```powershell
# NO — an if/else inside a one-line hashtable; Invoke-Formatter throws and the formatting gate stops
[ordered]@{ $Kind.keys[0] = $(if ($module) { $module } else { '' }) }

# YES — the value is bound first; the hashtable holds only the variable
$value = if ($module) {
    $module
}
else {
    ''
}
[ordered]@{ $Kind.keys[0] = $value }
```

### Semicolons

PowerShell separates statements by newlines and needs no semicolons. A semicolon carried over from C# or JavaScript habit adds noise and
signals that the author is thinking in a different language.

**Trailing semicolons** — line terminators left over from C# habits:

```powershell
# Wrong — semicolons are noise
$config = Get-Config;
$name = $config.Name;
Write-Message $name;
```

```powershell
# Correct
$config = Get-Config
$name = $config.Name
Write-Message $name
```

**Statement chaining on a single line** — permitted when it improves readability for short, related statements:

```powershell
# OK — short related assignments chained on one line
$inner = $Width - 2; "╰$('─' * $inner)╯"

# OK — compact switch branches
'Curved' { $inner = $Width - 2; "╰$('─' * $inner)╯" }
```

```powershell
# Wrong — trailing semicolons (statement terminators, not chaining)
$a = 1;
$b = 2;
```

A semicolon followed by another statement on the same line is chaining (allowed); one at the end of a line is a trailing terminator
(forbidden).

### The two semicolon exceptions

**`for` loop headers** — The `for` statement uses semicolons as syntactic separators. This is required — there is no alternative syntax:

```powershell
for ($i = 0; $i -lt 10; $i++) {
    # ...
}
```

**Inline hash table literals** — Semicolons separate entries in single-line hash tables. This is idiomatic PowerShell:

```powershell
$obj = [PSCustomObject]@{ Name = 'test'; Value = 42 }
```

Multi-line hash tables use newlines instead and do not need semicolons:

```powershell
$obj = [PSCustomObject]@{
    Name  = 'test'
    Value = 42
}
```

Both exceptions are structural — the semicolons serve as syntactic separators, not statement terminators. The `for` loop exception is narrow
and unambiguous, so it needs no judgment call.

### Line length and encoding

Max line length is 120 for `.ps1`/`.psm1`/`.psd1`, set in `.editorconfig`. Encoding is UTF-8 without BOM (the repo baseline). Which analyzer
rules are on or off — and why (for example, line length is enforced by `.editorconfig`, not `Test-ScriptAnalyzer`) — is documented inline in
`PSScriptAnalyzerSettings.psd1`.

### The analyzer map

`Which ADR rule each analyzer rule enforces`

A PSScriptAnalyzer rule that fails the build enforces a DRS rule on every run, so the rule-coverage report of
[test-automation](../test-automation.md#provenance-and-rule-coverage) counts it as an enforcer beside the tagged tests. The map from
analyzer rule to citation sits with the analyzer quality gate (`Test-ScriptAnalyzer`) that runs those rules, not with the test runner: a
custom rule is added here, in `pwsh/.scriptanalyzer/`, and its entry in `analyzer-drs-map.yml` is part of the same change.
`Test-AnalyzerDrsMap` keeps the two in step — an unmapped custom rule, or a mapped id that no ADR declares, fails it. Checking id existence
in the gate rather than at config load is the same split the Azure customer catalogue uses: the load stays hermetic, and the cross-reference
is a quality gate.

### Flat steps

[avoid-deep-nesting](../avoid-deep-nesting.md) fixes the doctrine: one operation per line, intermediate results named, assertions between
the steps, and simple expressions exempt. In PowerShell a step's assertion is an `Assert-*` call on the variable the step assigned
([fail-fast-with-asserts](../fail-fast-with-asserts.md)), and `Assert-PipelineCount` is the one assertion written inside a pipeline, because
it passes its input through:

```powershell
$config = Get-Content $path | ConvertFrom-Json
Assert-HaveProperty $config 'Items'

$active = $config.Items.Where({ $_.Status -eq 'Active' }) | Assert-PipelineCount -Minimum 1
```

A `Join-Path` onto an anchor, a single property access, a cast, and a two-stage pipeline read naturally inline; they cannot fail in a way a
named intermediate would explain.

## Decision

PowerShell files follow the repo-wide baseline plus the PowerShell-specific rules above, all mechanically enforced. No per-file overrides.
Every custom analyzer rule names the DRS rule it enforces in the analyzer map. Semicolons are never trailing statement terminators; they are
permitted for chaining statements on a single line, in `for` loop headers, and in inline hash table literals.

### How this is enforced

- **`.editorconfig`** — the `[*.{ps1,psm1,psd1}]` section sets the PowerShell indent width and max line length, on top of the `[*]`
  baseline.
- **PSScriptAnalyzer** — the full rule set, options, and on/off rationale live in `PSScriptAnalyzerSettings.psd1` (every rule folded out
  with inline comments). Custom analyzer rules, including `Measure-VariableCasing` (the casing rule above), live in `pwsh/.scriptanalyzer/`,
  one check module each. The settings hand the engine one entry rule, `CatzcRules.psm1`, which runs every check once per file (the engine
  otherwise calls a script rule once per script block); a new check module is added to its list. Each check keeps its own rule name, so
  diagnostics and `SuppressMessageAttribute` name the check.
- **The source set, shared** — `Get-ModuleSourceFile` names the canonical set the analysis quality gates cover: every module `*.ps1` (module
  root, `private/`, `tests/`), the `.internal` and `.scriptanalyzer` infrastructure folders (every `.internal/*.psm1` internal module, the
  custom analyzer rules `*.psm1`, and their `tests/`), the root `importer.ps1`, and authored `.psd1` config
  (`PSScriptAnalyzerSettings.psd1`). `Test-ScriptAnalyzer` and the L2 `Test-ScriptAnalyzer.Tests.ps1` both draw from it — the L2 test shards
  the resulting list across processes for speed — so neither can drift from the other. Formatting covers more: `Format-Code` runs the
  `psscriptanalyzer` engine over every tracked PowerShell file except vendored code. The dot-prefixed `.vendor` (third-party) and
  `.compiled` (build output) folders, `assets/`, and generated module manifests are excluded as vendored or generated rather than authored
  source. A custom rule's `*.Tests.ps1` embeds the very anti-patterns the rule forbids as fixtures, so it carries a file-scoped
  `SuppressMessageAttribute` for its own rule. Formatting violations fail the build.
- **`Test-AnalyzerDrsMap`** — the quality gate over `analyzer-drs-map.yml` (ADR-PWSH-FORMAT-ANALYZERRECORDMAPPING), run by its integrity test.
- **PSScriptAnalyzer built-in rule `PSAvoidSemicolonsAsLineTerminators`** — catches trailing semicolons
  (ADR-PWSH-FORMAT-NOTRAILINGSEMICOLONS); enabled in `PSScriptAnalyzerSettings.psd1`.

## Consequences

- PowerShell pull-request diffs contain only logic changes; `git blame` points at the logic author, not the last reformatter.
- New contributors produce correctly formatted PowerShell because their editor reads `.editorconfig` and PSScriptAnalyzer plus the L2 tests
  catch the rest before merge.
- The cross-language baseline is single-sourced in the repository's uniform formatting; this ADR holds only the PowerShell rules, so the two
  never duplicate or drift.
- A new custom analyzer rule cannot ship without naming the DRS rule it enforces, so the coverage report credits it from its first run.
- Code reads as idiomatic PowerShell, not transliterated C#: every statement is on its own line, easier to read, debug, blame, and diff, and
  developers with C# habits get immediate feedback from the linter rather than accumulating semicolons over time.
