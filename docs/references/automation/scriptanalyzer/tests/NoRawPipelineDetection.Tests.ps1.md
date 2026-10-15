---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1.md
    kind: test-asset
    body_sha: "3d0e26cdbd4d"
---

# automation/.scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Measure-NoRawPipelineDetection' -Tag 'L0', 'logic' {`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
```

## comment:3

Above `function Test-RawDetectionFile {`.

```text
The *.Tests.ps1 exemption keys off $ScriptBlockAst.Extent.File, so that case must parse from a real
file path (ParseInput leaves Extent.File empty).
```
