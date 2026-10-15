# automation/.scriptanalyzer/NoRawInformationStream.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Console/log output must go through the repo's writers, which all route through the single chokepoint
Write-InformationColored — and that chokepoint is where output is SUPPRESSED during a Pester run (the
$global:__PesterRunning guard returns before writing). A direct Write-Information call skips that guard, so
its output LEAKS into test output: Pester captures the information stream regardless of $InformationPreference
and replays it. It also skips the caller-identity header Write-Message adds (useful in local and CI logs).

Use Write-Message for any message from the automation to the console/log — it carries the [caller] header
(drop it with -NoHeader) and supports -ForegroundColor, and it is guarded. Write-InformationColored is the
low-level chokepoint Write-Message builds on; it is the one place Write-Information may be called, so a
Write-Information inside the function Write-InformationColored is exempt. The bootstrap's chokepoint,
Write-ImporterMessage, is exempt for the same reason: it is the writer of the import itself, which runs before
Write-Message is loaded.

See ADR: [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) (the Pester-suppression chokepoint).
```

## comment:2

Above `$isCommand = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
