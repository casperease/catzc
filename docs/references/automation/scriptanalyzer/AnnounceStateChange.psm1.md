---
catzc:
  immutable:
    with_body_sha: b09d0ac4a344
    path: docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: announce-state-change-psm1
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

# automation/.scriptanalyzer/AnnounceStateChange.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Test-CommandParameter {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: a function that changes the session's state must announce it.
.DESCRIPTION
    The rule checks that a writer runs with the change, not what the line says; that wording stays a review concern.
    [comment:1](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment1)
```

## comment:2

Above `function Get-CommandArgument {`, written with `#`.

```text
The argument of a command's named parameter (-Name value or -Name:value), else its first positional
argument — the element straight after the command name, when that is not a parameter.
```

## comment:3

Above `$isInOtherRunspace = {`, written with `#`.

```text
Whether a node sits in a scriptblock handed literally to a job or a parallel ForEach-Object, which runs in
another runspace or process.
```

## comment:4

Above `$isCandidate = {`, written with `#`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:5

Above `$changesByScope = [ordered]@{}`, written with `#`.

```text
Group every change by its scope, and note per scope which targets a finally block restores and which
blocks an information-stream writer call covers.
```

## comment:6

Above `function Measure-PersistentWriteThroughSeam {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: persistent environment and registry writes go only through their seams.
.DESCRIPTION
    Persistent environment and registry writes go through one mockable seam, so only its own test touches real state.
    [comment:6](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment6)
```
