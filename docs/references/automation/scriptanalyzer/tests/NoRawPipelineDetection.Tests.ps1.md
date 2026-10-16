---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1.md
    folder: docs/references/automation/scriptanalyzer/tests
    name: no-raw-pipeline-detection-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e114d85b13db
---

# automation/.scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoRawPipelineDetection' -Tag 'L0', 'logic' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`, written with `#`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
```

## comment:3

Above `function Test-RawDetectionFile {`, written with `#`.

```text
The *.Tests.ps1 exemption keys off $ScriptBlockAst.Extent.File, so that case must parse from a real
file path (ParseInput leaves Extent.File empty).
```
