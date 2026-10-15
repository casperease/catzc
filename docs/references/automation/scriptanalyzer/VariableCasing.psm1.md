---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/VariableCasing.psm1.md
    kind: comment-page
    body_sha: "1f0ae2e5e936"
    adrs:
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/VariableCasing.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
PascalCase: parameters, $global: scoped variables.
camelCase: local (unscoped), $script:, and $private: scoped variables.
Scriptblock params and automatic variables are skipped.
```

## comment:2

Above `$isParameter = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `$parentOfScript = $p.Parent.Parent.Parent`.

```text
Skip scriptblock params (e.g. { param($n) ... } in FindAll predicates)
Named function: ParamBlockAst → ScriptBlockAst → FunctionDefinitionAst
Scriptblock:    ParamBlockAst → ScriptBlockAst → ScriptBlockExpressionAst
```

## comment:4

Above `$isAssignment = {`.

```text
Check variable assignments
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
