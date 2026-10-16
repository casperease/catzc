---
catzc:
  immutable:
    with_body_sha: "8b6e4a3e998a"
    path: docs/adr/pwsh/powershell-formatting.md
    folder: docs/adr/pwsh
    name: powershell-formatting
    filetype: md
    kind: adr
    language: markdown
    track: docs
  edges:
    defines:
      - ADR-PWSH-FORMAT#{1-10}
    cites:
      - ADR-AUTO-NONEST#{3,5}
    links:
      - docs/adr/automation/avoid-deep-nesting.md
      - docs/adr/automation/avoid-deep-nesting.md#rule-adr-auto-nonest3
      - docs/adr/automation/avoid-deep-nesting.md#rule-adr-auto-nonest5
      - docs/adr/automation/fail-fast-with-asserts.md
      - docs/adr/automation/test-automation.md#provenance-and-rule-coverage
      - docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3
      - docs/adr/repository/uniform-formatting.md
---

# ADR: PowerShell formatting — the language layer over uniform-formatting

## Rules: ADR-PWSH-FORMAT

### Rule ADR-PWSH-FORMAT:1

PowerShell formatting builds on the repo-wide uniform-formatting baseline ([Context](#context)) and adds the PowerShell-specific rules
below, enforced by PSScriptAnalyzer (`PSScriptAnalyzerSettings.psd1`) plus custom analyzer rules, run in the L2 tests.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT:2

Brace style is K&R — the opening brace on the same line — enforced by `PSPlaceOpenBrace`.

- [Brace style](#brace-style)

### Rule ADR-PWSH-FORMAT:3

Indentation is 4 spaces (the PowerShell community default), set by `.editorconfig`'s `[*.{ps1,psm1,psd1}]` section on top of the repo
baseline.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT:4

Variable casing: PascalCase for parameters and scoped variables, camelCase for locals — enforced by the custom `Measure-VariableCasing` rule
(scriptblock params and automatic variables excluded).

- [Variable casing](#variable-casing)

### Rule ADR-PWSH-FORMAT:5

Every authored PowerShell file the repository ships or runs is covered by the formatting and analysis quality gates — including the root
`importer.ps1` and authored `.psd1` config — resolved through one shared selector so no file escapes by living outside the module tree.
Generated module manifests are excluded: they are build output, made canonical by their generator.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FORMAT:6

A multi-line predicate passed to `.FindAll(...)` (or any method call) is bound to a local variable first, never written inline inside the
call's parentheses. A paren-nested multi-line scriptblock is the one construct where PSScriptAnalyzer versions compute
`PSUseConsistentIndentation` differently — so the inline form squiggles in the editor (whose bundled analyzer differs from vendored 1.25.0)
even though the gate accepts it, and the two formatters fight over the indent. A `$x = { … }` assignment has no paren nesting, so every
version indents it identically.

- [Scriptblock arguments](#scriptblock-arguments)

### Rule ADR-PWSH-FORMAT:7

The analyzer→ADR mapping — the source for the `pssa-rule` enforcer kind — lives in `Catzc.Base.QualityGates/configs/analyzer-adr-map.yml`,
each enabled analyzer rule (a custom `Measure-*` rule or an enabled built-in) mapped to the citation(s) it enforces. Its shape is validated
at load (its config type, `AnalyzerAdrMapConfig`); the `Test-AnalyzerAdrMap` quality gate checks that every mapped id resolves to a real
rule and that **every custom analyzer rule is mapped**, and an **integrity test** runs it, so a new custom rule cannot ship unmapped and a
renumber breaks the build. Id existence is checked by that gate, not at load, keeping config load hermetic.

- [The analyzer map](#the-analyzer-map)

### Rule ADR-PWSH-FORMAT:8

The step assertions of [ADR-AUTO-NONEST#3](../automation/avoid-deep-nesting.md#rule-adr-auto-nonest3) are `Assert-*` calls on the named
intermediate, on the line after the step that produced it. Inside a pipeline that must stay one statement, `Assert-PipelineCount` asserts
mid-pipeline and passes the items through.

- [Flat steps](#flat-steps)

### Rule ADR-PWSH-FORMAT:9

The simple expressions [ADR-AUTO-NONEST#5](../automation/avoid-deep-nesting.md#rule-adr-auto-nonest5) exempts are, in PowerShell, a
`Join-Path` onto an anchor, a single property access (`$moduleDir.Name`), a straightforward cast, and a short pipeline of two obvious stages
(`Get-ChildPath … | Sort-Object`).

- [Flat steps](#flat-steps)

### Rule ADR-PWSH-FORMAT:10

A hashtable literal that holds an `if`/`else` is written on several lines, or its value is bound to a local first, never written on one
line. PSScriptAnalyzer's `Invoke-Formatter` throws on the one-line form, and because `Format-Code` and `Test-Formatting` format every file
in one pass, one such file stops the quality gate's formatting pass for the whole tree instead of failing a single file. The custom
`Measure-NoOneLineHashtableIfElse` rule flags it.

- [One-line hashtables](#one-line-hashtables)

## Context

[uniform-formatting](../repository/uniform-formatting.md) fixes the cross-language baseline every file meets (UTF-8 without BOM, LF, spaces,
trimmed trailing whitespace, final newline) and the repo-wide "tools format, never debate" policy. PowerShell adds a layer on top that is
thicker — brace placement, variable casing, line length, and the full PSScriptAnalyzer rule set — because PowerShell is the bulk of the
codebase and has the richest analyzer support. This ADR records the PowerShell-specific choices; the baseline and the never-hand-format
policy live in uniform-formatting and are not repeated here.

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

### Line length and encoding

Max line length is 120 for `.ps1`/`.psm1`/`.psd1`, set in `.editorconfig`. Encoding is UTF-8 without BOM (the repo baseline — see
[uniform-formatting](../repository/uniform-formatting.md)). Which analyzer rules are on or off — and why (for example, line length is
enforced by `.editorconfig`, not `Test-ScriptAnalyzer`) — is documented inline in `PSScriptAnalyzerSettings.psd1`.

### The analyzer map

`Which ADR rule each analyzer rule enforces`

A PSScriptAnalyzer rule that fails the build enforces an ADR rule on every run, so the rule-coverage report of
[test-automation](../automation/test-automation.md#provenance-and-rule-coverage) counts it as an enforcer beside the tagged tests. The map
from analyzer rule to citation sits with the analyzer quality gate (`Test-ScriptAnalyzer`) that runs those rules, not with the test runner:
a custom rule is added here, in `automation/.scriptanalyzer/`, and its entry in `analyzer-adr-map.yml` is part of the same change.
`Test-AnalyzerAdrMap` keeps the two in step — an unmapped custom rule, or a mapped id that no ADR declares, fails it. Checking id existence
in the gate rather than at config load is the same split the Azure customer catalogue uses
([azure-customer-model](../azure/azure-customer-model.md#rule-adr-az-customer3)): the load stays hermetic, and the cross-reference is a
quality gate.

### Flat steps

[avoid-deep-nesting](../automation/avoid-deep-nesting.md) fixes the doctrine: one operation per line, intermediate results named, assertions
between the steps, and simple expressions exempt. In PowerShell a step's assertion is an `Assert-*` call on the variable the step assigned
([fail-fast-with-asserts](../automation/fail-fast-with-asserts.md)), and `Assert-PipelineCount` is the one assertion written inside a
pipeline, because it passes its input through:

```powershell
$config = Get-Content $path | ConvertFrom-Json
Assert-HaveProperty $config 'Items'

$active = $config.Items.Where({ $_.Status -eq 'Active' }) | Assert-PipelineCount -Minimum 1
```

A `Join-Path` onto an anchor, a single property access, a cast, and a two-stage pipeline read naturally inline; they cannot fail in a way a
named intermediate would explain.

## Decision

PowerShell files follow the repo-wide baseline plus the PowerShell-specific rules above, all mechanically enforced. No per-file overrides.
Every custom analyzer rule names the ADR rule it enforces in the analyzer map.

### How this is enforced

- **`.editorconfig`** — the `[*.{ps1,psm1,psd1}]` section sets the PowerShell indent width and max line length, on top of the `[*]`
  baseline.
- **PSScriptAnalyzer** — the full rule set, options, and on/off rationale live in `PSScriptAnalyzerSettings.psd1` (every rule folded out
  with inline comments). Custom analyzer rules, including `Measure-VariableCasing` (the casing rule above), live in
  `automation/.scriptanalyzer/`, one check module each. The settings hand the engine one entry rule, `CatzcRules.psm1`, which runs every
  check once per file (the engine otherwise calls a script rule once per script block); a new check module is added to its list. Each check
  keeps its own rule name, so diagnostics and `SuppressMessageAttribute` name the check.
- **The source set, shared** — `Get-AutomationSourceFiles` names the canonical set the analysis quality gates cover: every module `*.ps1`
  (module root, `private/`, `tests/`), the `.internal` and `.scriptanalyzer` infrastructure folders (every `.internal/*.psm1` internal
  module, the custom analyzer rules `*.psm1`, and their `tests/`), the root `importer.ps1`, and authored `.psd1` config
  (`PSScriptAnalyzerSettings.psd1`). `Test-ScriptAnalyzer` and the L2 `Test-ScriptAnalyzer.Tests.ps1` both draw from it — the L2 test shards
  the resulting list across processes for speed — so neither can drift from the other. Formatting covers more: `Format-Code` runs the
  `psscriptanalyzer` engine over every tracked PowerShell file except vendored code. The dot-prefixed `.vendor` (third-party) and
  `.compiled` (build output) folders, `assets/`, and generated module manifests are excluded as vendored or generated rather than authored
  source. A custom rule's `*.Tests.ps1` embeds the very anti-patterns the rule forbids as fixtures, so it carries a file-scoped
  `SuppressMessageAttribute` for its own rule. Formatting violations fail the build.
- **`Test-AnalyzerAdrMap`** — the quality gate over `analyzer-adr-map.yml` (ADR-PWSH-FORMAT#7), run by its integrity test.

## Consequences

- PowerShell pull-request diffs contain only logic changes; `git blame` points at the logic author, not the last reformatter.
- New contributors produce correctly formatted PowerShell because their editor reads `.editorconfig` and PSScriptAnalyzer plus the L2 tests
  catch the rest before merge.
- The cross-language baseline is single-sourced in [uniform-formatting](../repository/uniform-formatting.md); this ADR holds only the
  PowerShell layer, so the two never duplicate or drift.
- A new custom analyzer rule cannot ship without naming the ADR rule it enforces, so the coverage report credits it from its first run.
