---
catzc:
  immutable:
    with_body_sha: "30e4288af2cd"
    path: docs/references/automation/scriptanalyzer/NoRawConsoleWrite.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: no-raw-console-write-psm1
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

# automation/.scriptanalyzer/NoRawConsoleWrite.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoRawConsoleWrite {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid writing to the console past the information stream.
.DESCRIPTION
    A raw write bypasses the stream, so it escapes output control, Pester silencing and the caller header.
    [comment:1](/docs/references/automation/scriptanalyzer/NoRawConsoleWrite.psm1.md#comment1)
```

## comment:2

Above `$consoleWriterMembers = @('Out', 'Error')`, written with `#`.

```text
[Console]::Out / [Console]::Error are raw writers only when written through; reading them (to save and
restore around a SetOut capture) writes nothing.
```

## comment:3

Above `$isCandidate = {`, written with `#`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
