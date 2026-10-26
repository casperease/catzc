# pwsh/.scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1

The tests of `Measure-NoRawVsoCommand`.

## Suppressing the rule on this file

This file is covered by `Test-ScriptAnalyzer` like all authored PowerShell (`Get-ModuleSourceFile`). Its fixtures deliberately embed raw
`##vso[task.*]` strings so the rule can prove it flags them, which the rule itself would then report against this file. The file suppresses
the rule for the whole file rather than mangle the fixtures.

## What is run

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
engine-wiring proof (PSScriptAnalyzer discovers and fires the rule via `-CustomRulePath`) lives once, for all custom rules, in
`CustomRuleWiring.Tests.ps1`.

The rule's return type, `DiagnosticRecord`, lives in the PSScriptAnalyzer assembly, so the file loads the module once for the type. It
never invokes the analyzer engine; that is the L2 wiring test.
