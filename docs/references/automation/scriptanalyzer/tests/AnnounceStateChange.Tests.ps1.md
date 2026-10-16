---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/AnnounceStateChange.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f8f78b6e5a3e
---

# automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-AnnounceStateChange' -Tag 'L0', 'logic',...`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`, written with `#`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine (that is the L2 wiring test).
```

## comment:3

Above ``$code = "BeforeAll { Import-Module 'C:\widget' -Force }`nDescribe 'Widget' {...``, written with `#`.

```text
VS Code's PowerShell extension analyzes the open buffer as a script definition: no file name, so the
Pester structure (a Describe call) is what marks it as a test file.
```
