---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "51d5a9ac5917"
---

# automation/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoScriptRootAnchor' -Tag 'L0', 'logic' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. Its scope is decided by the file path, so each case writes a fixture file into $TestDrive under
a fake automation/ layout and parses it from there (ParseInput leaves Extent.File empty). The engine-wiring proof
(PSScriptAnalyzer discovers and fires this rule via -CustomRulePath) lives once, for all custom rules, in
CustomRuleWiring.Tests.ps1.
```

## comment:2

Above `if (-not (Get-Module PSScriptAnalyzer)) {`, written with `#`.

```text
The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
once for the type — we never invoke the analyzer engine.
```
