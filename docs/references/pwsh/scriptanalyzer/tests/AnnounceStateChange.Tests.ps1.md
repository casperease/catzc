# pwsh/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1

The tests of `Measure-AnnounceStateChange`.

## What is run

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
engine-wiring proof (PSScriptAnalyzer discovers and fires the rule via `-CustomRulePath`) lives once, for all custom rules, in
`CustomRuleWiring.Tests.ps1`.

The rule's return type, `DiagnosticRecord`, lives in the PSScriptAnalyzer assembly, so the file loads the module once for the type. It never
invokes the analyzer engine; that is the L2 wiring test.

## Editor buffers

VS Code's PowerShell extension analyzes the open buffer as a script definition with no file name, so the Pester structure (a `Describe`
call) is what marks it as a test file.
