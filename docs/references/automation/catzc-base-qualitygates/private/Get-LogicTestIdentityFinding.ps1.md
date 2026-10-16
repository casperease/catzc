---
catzc:
  immutable:
    with_body_sha: "86d044ad18e2"
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LogicTestIdentityFinding.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-logic-test-identity-finding-ps1
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

# automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$isCommandNode = {`, written with `#`.

```text
Predicates bound to locals (never inlined in a .FindAll(...) call) —
[ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6).
```

## comment:2

Above `$hasLogic = $false`, written with `#`.

```text
Walk the Pester block commands once: note whether the file carries a `logic` tag anywhere, and collect
the script-block offset range of every `integrity`-tagged block (its literals are carved out of the scan).
```

## comment:3

Above `$literals = $ast.FindAll($isStringLiteral, $true)`, written with `#`.

```text
Exact pass — a distinctive identity (customer / subscription / org / template / project) flagged as a
bare literal anywhere outside an integrity block.
```

## comment:4

Above `$identityParameters = 'Environment', 'Env', 'Shortcode'`, written with `#`.

```text
Position pass — an ambiguous identity (an environment name or shortcode, like 'test'/'dev') is flagged
ONLY when bound to an identity parameter (-Environment / -Env / -Shortcode), never as a prose literal.
```
