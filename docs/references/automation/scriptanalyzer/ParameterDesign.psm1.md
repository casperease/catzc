---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8960d512cee8"
    adrs:
      - ADR-PWSH-FORMAT#6
      - ADR-PWSH-PARAM#4
---

# automation/.scriptanalyzer/ParameterDesign.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Test-ModuleFunctionFile {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rules for a function's parameter surface
    ([ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md)).
.DESCRIPTION
    Two checks over the functions in a module function file — a.ps1 directly under automation/<Module>/ (public) or...
    [comment:1](/docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md#comment1)
```

## comment:2

Above `$isFunction = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `if (-not (Test-ModuleFunctionFile $ScriptBlockAst) -or...`, written with `#`.

```text
Public functions only: a positional primary argument serves the module's callers; a private helper is called by
name from inside its module.
```

## comment:4

Above `if ($parameter.DefaultValue -and $parameter.DefaultValue.Extent.Text -match...`, written with `#`.

```text
A [bool] whose default reads the configuration is a configurable setting
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)), not opt-in behaviour.
```
