---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoRawConsoleWrite.psm1.md
    kind: comment-page
    body_sha: "6505e8983e4f"
    adrs:
      - ADR-PWSH-ANNOUNCE#1
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoRawConsoleWrite.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every write to the console goes through the information stream, by way of the writer chokepoint
(Write-Message -> Write-InformationColored -> Write-Information) —
[ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1). Only there
is the
output controllable ($InformationPreference, -InformationAction, 6> redirection), silenced during a Pester
run (the chokepoint guard), and headed with its caller. A write that goes around the stream bypasses all
three, so this rule flags every way to do it:

  - the commands Write-Host, Out-Host, Write-Progress and Clear-Host (and the clear / cls aliases);
  - the [Console] write methods (Write, WriteLine, Clear, ResetColor, SetCursorPosition, Beep, ...), a write
    through the raw writers ([Console]::Out.Write(...), [Console]::Error.WriteLine(...)), the raw streams
    OpenStandardOutput / OpenStandardError, and any assignment to a [Console] property (title, colours,
    cursor, encoding);
  - the host's write methods ($Host.UI.Write*), the raw-UI mutators ($Host.UI.RawUI.Set* / Flush* /
    Scroll*), and any assignment under $Host.UI.RawUI.

Reading console state ([Console]::CursorLeft, $Host.UI.RawUI.WindowSize) is not a write and passes, and so is
redirecting the console writer to capture output ([Console]::SetOut around a test). An inline dot without a
line break is Write-Message '.' -NoHeader -NoNewline, so no case needs a raw write.

This supersedes the built-in PSAvoidUsingWriteHost, which is excluded in PSScriptAnalyzerSettings.psd1: one
rule owns the console bypass, and it covers every route, not only Write-Host.

See ADR: [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1).
```

## comment:2

Above `$consoleWriterMembers = @('Out', 'Error')`.

```text
[Console]::Out / [Console]::Error are raw writers only when written through; reading them (to save and
restore around a SetOut capture) writes nothing.
```

## comment:3

Above `$isCandidate = {`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
