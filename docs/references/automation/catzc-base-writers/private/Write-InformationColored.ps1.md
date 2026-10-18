# automation/Catzc.Base.Writers/private/Write-InformationColored.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes colored messages to the information stream.

### description

Writes via Write-Information, carrying the color as ANSI escape sequences embedded in the message text rather than via a console-API color
parameter.

Two reasons for embedded ANSI over Write-Host's -ForegroundColor:

- Colors work in both interactive terminals and CI pipelines (ADO, GitHub Actions) because the message text contains ANSI escape sequences.
  Write-Host's -ForegroundColor uses the console API, which only works in interactive terminals — in CI stdout is a pipe and colors are
  lost. Embedding ANSI codes in the string survives redirection.

- Output stays on the information stream, so in normal use it obeys $InformationPreference, -InformationAction, and 6> redirection — none of
  which Write-Host honours (it always renders).

This is the single chokepoint every writer (Write-Message, Write-Object, Write-Header, …) routes through, so it is also where host output is
suppressed during a Pester run. The suppression is a guard, not a stream preference: Pester captures the information stream around each test
and replays it at Normal+ verbosity, so
$InformationPreference = 'SilentlyContinue' does NOT stop the output —
only not writing it does. Test-Automation sets $global:__PesterRunning,
and this guard returns before writing. Tests that need to assert writer output lift the flag for their own scope.

It is also the one way to write to the console at all
([ADR-PWSH-ANNOUNCE#1](../../../../adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): nothing in the toolset calls Write-Host,
`[Console]::Write` or
$Host.UI. -NoNewline covers the one thing those were used for — an inline
liveness dot
([ADR-AUTO-CONSOLE#8](../../../../adr/automation/console-output-matters.md#rule-adr-auto-console8)). It wraps
the text in a HostInformationMessage with NoNewLine set, the same
record Write-Host emits internally, so the host renders it without a line break while it stays an ordinary
information-stream record: it obeys $InformationPreference
and 6> redirection, and never enters the pipeline.

### parameter MessageData

The message to write.

### parameter ForegroundColor

Text color. Defaults to the host's current foreground color.

### parameter NoNewline

Render the text without a trailing line break, so the next write continues the same line.

### example 1

```powershell
Write-InformationColored 'Build succeeded' -ForegroundColor Green
```

### example 2

```powershell
Write-InformationColored 'WARN' -ForegroundColor Yellow
```

## comment:1

Above `if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly...`, written with `#`.

```text
Suppress during Pester runs (flag set by Test-Automation). The single chokepoint for all writers,
so nothing routed through here can leak into test output. See .DESCRIPTION for why a flag, not a stream.
Read through Get-Variable: the flag is unset outside a test run, and strict mode rejects an unset variable.
```

## comment:2

Above `$ansi = [Catzc.Base.Writers.Ansi]::Code($ForegroundColor)`, written with `#`.

```text
The ConsoleColor -> ANSI SGR map lives once, in the Ansi type (shared with the rainbow writer),
so this chokepoint and RainbowColor can never disagree on a colour's code. Empty = no escape.
```
