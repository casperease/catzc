---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1.md
    kind: test-asset
    body_sha: ff10e5a2cbdc
    adrs:
      - ADR-AUTO-SPELL#2
---

# automation/.scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Measure-SpellOutIdentifiers' -Tag 'L0', 'logic' {`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst (the SpellingOracle it consults is loaded once, warmed in BeforeAll below). The engine-wiring
proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath, which also exercises the oracle
initializing inside the analyzer's own runspace) lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
```

## comment:3

Above `@{ Code = 'foreach ($i in 1..3) { $i }' }`.

```text
single-letter loop index
([ADR-AUTO-SPELL#2](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell2))
```
