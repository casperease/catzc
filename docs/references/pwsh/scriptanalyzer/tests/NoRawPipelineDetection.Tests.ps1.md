# pwsh/.scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1

The tests of `Measure-NoRawPipelineDetection`.

## What is run

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
engine-wiring proof (PSScriptAnalyzer discovers and fires the rule via `-CustomRulePath`) lives once, for all custom rules, in
`CustomRuleWiring.Tests.ps1`.

The rule's return type, `DiagnosticRecord`, lives in the PSScriptAnalyzer assembly, so the file loads the module once for the type. It
never invokes the analyzer engine; that is the L2 wiring test.

## The test-file exemption

The `*.Tests.ps1` exemption keys off `$ScriptBlockAst.Extent.File`, so that case must parse from a real file path (`ParseInput` leaves
`Extent.File` empty). `Test-RawDetectionFile` does that.
