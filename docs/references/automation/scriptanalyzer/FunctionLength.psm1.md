---
catzc:
  immutable:
    with_body_sha: "1e2b8cb17f5c"
    path: docs/references/automation/scriptanalyzer/FunctionLength.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: function-length-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-FORMAT#6
---

# automation/.scriptanalyzer/FunctionLength.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-FunctionLength {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: function body must not exceed 300 lines.
.DESCRIPTION
    Help placed before the function is outside the braces, so it never counts toward the limit.
    [comment:1](/docs/references/automation/scriptanalyzer/FunctionLength.psm1.md#comment1)
```

## comment:2

Above `$isFunctionDefinition = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
