---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LogicTestIdentityFinding.ps1.md
    kind: reference
    body_sha: "1ddaf4203aab"
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-PWSH-FORMAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The PowerShell AST omits comments, here-doc trivia, and help entirely, so this reads only real code string
literals — a config comment illustrating `[acme, globex]`, a `.EXAMPLE` help block, or demo data in a
comment never reaches it.

A live identity is legitimate ONLY inside an `integrity`-tagged block (binding the real config is an
integrity test's job, [ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)); anywhere else
in a logic-bearing test file it is a leak. So the scan
EXCLUDES the script-block extent of every Describe/Context/It tagged `integrity`, and reports a match
everywhere else — the shared setup, the logic Contexts, the unit tests. This makes a MIXED logic+integrity
file work with no file split: the integrity Context's identities are carved out, the logic body is checked.

Classification and exclusion are read from the AST `-Tag` values, never by running Pester. A file with no
`logic` tag at all is not a logic surface and is skipped; a `*.Integrity.Tests.ps1` file is skipped by
convention. Matching is EXACT (a literal that IS 'apex', not the segment inside 'apex/…' or a path), so
false positives stay near zero (Phase 1).
```

## comment:2

Above `$isCommandNode = {`.

```text
Predicates bound to locals (never inlined in a .FindAll(...) call) —
[ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6).
```

## comment:3

Above `$hasLogic = $false`.

```text
Walk the Pester block commands once: note whether the file carries a `logic` tag anywhere, and collect
the script-block offset range of every `integrity`-tagged block (its literals are carved out of the scan).
```

## comment:4

Above `$literals = $ast.FindAll($isStringLiteral, $true)`.

```text
Exact pass — a distinctive identity (customer / subscription / org / template / project) flagged as a
bare literal anywhere outside an integrity block.
```

## comment:5

Above `$identityParameters = 'Environment', 'Env', 'Shortcode'`.

```text
Position pass — an ambiguous identity (an environment name or shortcode, like 'test'/'dev') is flagged
ONLY when bound to an identity parameter (-Environment / -Env / -Shortcode), never as a prose literal.
```
