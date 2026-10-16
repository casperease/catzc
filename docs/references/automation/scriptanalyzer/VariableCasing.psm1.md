---
catzc:
  immutable:
    with_body_sha: "1a55363585a6"
    repo_status: locked
    path: docs/references/automation/scriptanalyzer/VariableCasing.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: variable-casing-psm1
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

# automation/.scriptanalyzer/VariableCasing.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:skipVariables = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: enforce variable casing conventions.
.DESCRIPTION
    Scriptblock parameters and automatic variables are skipped, as their names are not the author's choice.
    [comment:1](/docs/references/automation/scriptanalyzer/VariableCasing.psm1.md#comment1)
```

## comment:2

Above `$isParameter = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `$parentOfScript = $p.Parent.Parent.Parent`, written with `#`.

```text
Skip scriptblock params (e.g. { param($n) ... } in FindAll predicates)
Named function: ParamBlockAst → ScriptBlockAst → FunctionDefinitionAst
Scriptblock:    ParamBlockAst → ScriptBlockAst → ScriptBlockExpressionAst
```

## comment:4

Above `$isAssignment = {`, written with `#`.

```text
Check variable assignments
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
