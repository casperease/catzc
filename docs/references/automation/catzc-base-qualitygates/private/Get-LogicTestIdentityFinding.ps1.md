---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LogicTestIdentityFinding.ps1.md
    kind: comment-page
    body_sha: cc4236933a74
    adrs:
      - ADR-PWSH-FORMAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$isCommandNode = {`.

```text
Predicates bound to locals (never inlined in a .FindAll(...) call) —
[ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6).
```

## comment:7

Above `$hasLogic = $false`.

```text
Walk the Pester block commands once: note whether the file carries a `logic` tag anywhere, and collect
the script-block offset range of every `integrity`-tagged block (its literals are carved out of the scan).
```

## comment:8

Above `$literals = $ast.FindAll($isStringLiteral, $true)`.

```text
Exact pass — a distinctive identity (customer / subscription / org / template / project) flagged as a
bare literal anywhere outside an integrity block.
```

## comment:9

Above `$identityParameters = 'Environment', 'Env', 'Shortcode'`.

```text
Position pass — an ambiguous identity (an environment name or shortcode, like 'test'/'dev') is flagged
ONLY when bound to an identity parameter (-Environment / -Env / -Shortcode), never as a prose literal.
```
