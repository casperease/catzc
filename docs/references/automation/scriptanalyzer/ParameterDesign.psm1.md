---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/ParameterDesign.psm1.md
    kind: comment-page
    body_sha: f407cf7606af
    adrs:
      - ADR-PWSH-FORMAT#6
      - ADR-PWSH-PARAM#2
      - ADR-PWSH-PARAM#3
      - ADR-PWSH-PARAM#4
---

# automation/.scriptanalyzer/ParameterDesign.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Two checks over the functions in a module function file — a .ps1 directly under automation/<Module>/ (public) or
automation/<Module>/private/ (private); tests, assets, dot-prefixed infrastructure, and files outside automation/
are exempt by path, as for Measure-NoScriptRootAnchor:

Measure-ParameterFillIn
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)):
the body fills an empty parameter in — `if (-not $P) { $P = … }` or `$P = $P ?? …` — instead of declaring the default.
The cases a declaration cannot express carry a SuppressMessageAttribute naming the reason.

Measure-PrimaryArgumentPosition
([ADR-PWSH-PARAM#2](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param2)):
a public function with exactly one mandatory parameter, and no parameter at Position 0, leaves its primary argument
named-only. Private helpers are exempt: they are called by name from inside their module.

Measure-NoOptionalBooleanParameter
([ADR-PWSH-PARAM#3](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param3)):
an optional [bool] parameter is opt-in behaviour, which is a [switch]. A mandatory [bool] is a value both ways, not an
opt-in, and is left alone.

Measure-NoSwitchDefaultOn
([ADR-PWSH-PARAM#3](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param3)):
a [switch] declared `= $true` is on unless the caller passes -Name:$false — opt-in behaviour is off by default.
```

## comment:2

Above `$isFunction = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `if (-not (Test-ModuleFunctionFile $ScriptBlockAst) -or...`.

```text
Public functions only: a positional primary argument serves the module's callers; a private helper is called by
name from inside its module.
```
