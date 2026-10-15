---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md
    kind: comment-page
    body_sha: "98b2d84d73e2"
    adrs:
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoForEachObjectControlFlow.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
return/break/continue have completely different semantics inside a
ForEach-Object scriptblock than inside a foreach loop:
- return exits the scriptblock (acts like continue), not the function
- break/continue act on the enclosing loop or terminate the script
If you need control flow, use a foreach statement instead.

See ADR: prefer-foreach-over-foreach-object.
```

## comment:2

Above `$isForEachObjectCommand = {`.

```text
Find all ForEach-Object / % command invocations
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `$scriptBlocks = @()`.

```text
Collect all scriptblock arguments to this ForEach-Object call.
These are the -Process, -Begin, -End blocks or positional scriptblock args.
```

## comment:4

Above `$isControlFlowStatement = {`.

```text
Find return, break, continue statements that are direct children of THIS
scriptblock — not inside a nested foreach/for/while/do/switch/function/
scriptblock, where they would be valid.
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:5

Above `$parent = $node.Parent`.

```text
Walk up the AST to check if there is an intervening loop/switch/function
between this statement and the ForEach-Object scriptblock.
If there is, the keyword targets that construct — not our scriptblock.
```
