---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e23eae1a88b8
---

# automation/.scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand',...`, written with `#`.

```text
This file is covered by Test-ScriptAnalyzer like all authored PowerShell (Get-AutomationSourceFiles). Its
fixtures deliberately embed raw ##vso[task.*] strings so the rule can prove it flags them, which the rule
itself would then report against this file — suppress it here for the whole file rather than mangle the
fixtures.
```

## comment:2

Above `Describe 'Measure-NoRawVsoCommand' -Tag 'L0', 'logic' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:3

Above `if (-not (Get-Module PSScriptAnalyzer)) {`, written with `#`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
```
