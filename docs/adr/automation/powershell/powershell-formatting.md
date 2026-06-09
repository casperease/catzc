# ADR: PowerShell formatting — the language layer over uniform-formatting

## Rules: ADR-PSFORMAT

### Rule ADR-PSFORMAT:1

PowerShell formatting builds on the repo-wide [uniform-formatting](../../repository/uniform-formatting.md) baseline and adds the
PowerShell-specific rules below, enforced by PSScriptAnalyzer (`PSScriptAnalyzerSettings.psd1`) plus custom analyzer rules, run in the L2
test suite.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PSFORMAT:2

Brace style is K&R — the opening brace on the same line — enforced by `PSPlaceOpenBrace`.

- [Brace style](#brace-style)

### Rule ADR-PSFORMAT:3

Indentation is 4 spaces (the PowerShell community default), set by `.editorconfig`'s `[*.{ps1,psm1,psd1}]` section on top of the repo
baseline.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PSFORMAT:4

Variable casing: PascalCase for parameters and scoped variables, camelCase for locals — enforced by the custom `Measure-VariableCasing` rule
(scriptblock params and automatic variables excluded).

- [Variable casing](#variable-casing)

### Rule ADR-PSFORMAT:5

Every authored PowerShell file the repository ships or runs is covered by the formatting and analysis gates — including the root
`importer.ps1` and authored `.psd1` config — resolved through one shared selector so no file escapes by living outside the module tree.
Generated module manifests are excluded: they are build output, made canonical by their generator.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PSFORMAT:6

A multi-line predicate passed to `.FindAll(...)` (or any method call) is bound to a local variable first, never written inline inside the
call's parentheses. A paren-nested multi-line scriptblock is the one construct where PSScriptAnalyzer versions compute
`PSUseConsistentIndentation` differently — so the inline form squiggles in the editor (whose bundled analyzer differs from vendored 1.25.0)
even though the gate accepts it, and the two formatters fight over the indent. A `$x = { … }` assignment has no paren nesting, so every
version indents it identically.

- [Scriptblock arguments](#scriptblock-arguments)

## Context

[uniform-formatting](../../repository/uniform-formatting.md) fixes the cross-language baseline every file meets (UTF-8 without BOM, LF,
spaces, trimmed trailing whitespace, final newline) and the repo-wide "tools format, never debate" policy. PowerShell adds a thicker layer
on top — brace placement, variable casing, line length, and the full PSScriptAnalyzer rule set — because PowerShell is the bulk of the
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
then squiggles in the editor while the gate (1.25.0) stays green, and "Format Document" and `Format-Automation` disagree on the indent.
Binding the predicate to a local removes the paren nesting, so every version indents it the same.

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

### Line length and encoding

Max line length is 120 for `.ps1`/`.psm1`/`.psd1`, set in `.editorconfig`. Encoding is UTF-8 without BOM (the repo baseline — see
[uniform-formatting](../../repository/uniform-formatting.md)). Which analyzer rules are on or off — and why (for example, line length is
enforced by `.editorconfig`, not the analyzer suite) — is documented inline in `PSScriptAnalyzerSettings.psd1`.

## Decision

PowerShell files follow the repo-wide baseline plus the PowerShell-specific rules above, all mechanically enforced. No per-file overrides.

### How this is enforced

- **`.editorconfig`** — the `[*.{ps1,psm1,psd1}]` section sets the PowerShell indent width and max line length, on top of the `[*]`
  baseline.
- **PSScriptAnalyzer** — the full rule set, options, and on/off rationale live in `PSScriptAnalyzerSettings.psd1` (every rule folded out
  with inline comments). Custom analyzer rules, including `Measure-VariableCasing` (the casing rule above), live in
  `automation/.scriptanalyzer/`.
- **Shared gated set** — `Get-AutomationSourceFiles` names the canonical set the gates cover: every module `*.ps1` (module root, `private/`,
  `tests/`), the `.internal` and `.scriptanalyzer` infrastructure folders (the `Loader`, `Bootstrap`, `TestKit`, and `Types` internal
  modules, the custom analyzer rules `*.psm1`, and their `tests/`), the root `importer.ps1`, and authored `.psd1` config
  (`PSScriptAnalyzerSettings.psd1`). `Format-Automation`, `Test-ScriptAnalyzer`, and the L2 `Test-ScriptAnalyzer.Tests.ps1` all draw from it
  — the L2 test shards the resulting list across processes for speed — so no gate can drift from the others. The dot-prefixed `.vendor`
  (third-party) and `.compiled` (build output) folders, `assets/`, and generated module manifests are excluded as vendored or generated
  rather than authored source. A custom rule's `*.Tests.ps1` embeds the very anti-patterns the rule forbids as fixtures, so it carries a
  file-scoped `SuppressMessageAttribute` for its own rule. Formatting violations fail the build.

## Consequences

- PowerShell pull-request diffs contain only logic changes; `git blame` points at the logic author, not the last reformatter.
- New contributors produce correctly formatted PowerShell because their editor reads `.editorconfig` and PSScriptAnalyzer plus the L2 suite
  catch the rest before merge.
- The cross-language baseline is single-sourced in [uniform-formatting](../../repository/uniform-formatting.md); this ADR holds only the
  PowerShell layer, so the two never duplicate or drift.
