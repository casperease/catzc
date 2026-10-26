# pwsh/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1

The tests of `Measure-NoScriptRootAnchor`.

## What is run

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
rule's reach is decided by the file path, so each case writes a fixture file into `$TestDrive` under a fake modules-folder layout and parses
it from there (`ParseInput` leaves `Extent.File` empty). The engine-wiring proof (PSScriptAnalyzer discovers and fires the rule via
`-CustomRulePath`) lives once, for all custom rules, in `CustomRuleWiring.Tests.ps1`.

The rule's return type, `DiagnosticRecord`, lives in the PSScriptAnalyzer assembly, so the file loads the module once for the type. It never
invokes the analyzer engine.
