# pwsh/.scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1

The tests of `Measure-SpellOutIdentifiers`.

## What is run

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
`SpellingOracle` it consults is loaded once and warmed in `BeforeAll`. The engine-wiring proof (PSScriptAnalyzer discovers and fires the
rule via `-CustomRulePath`, which also exercises the oracle initializing inside the analyzer's own runspace) lives once, for all custom
rules, in `CustomRuleWiring.Tests.ps1`.

The rule's return type, `DiagnosticRecord`, lives in the PSScriptAnalyzer assembly, so the file loads the module once for the type. It
never invokes the analyzer engine; that is the L2 wiring test.

## Allowed abbreviations

A single-letter loop index passes
([ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-allowedabbreviations)).
