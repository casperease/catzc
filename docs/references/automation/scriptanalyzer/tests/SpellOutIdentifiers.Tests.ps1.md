---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "12bbcdbec0d0"
    adrs:
      - ADR-AUTO-SPELL#2
---

# automation/.scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-SpellOutIdentifiers' -Tag 'L0', 'logic' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst (the SpellingOracle it consults is loaded once, warmed in BeforeAll below). The engine-wiring
proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath, which also exercises the oracle
initializing inside the analyzer's own runspace) lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`, written with `#`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
```

## comment:3

Above `@{ Code = 'foreach ($i in 1..3) { $i }' }`, written with `#`.

```text
single-letter loop index
([ADR-AUTO-SPELL#2](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell2))
```
