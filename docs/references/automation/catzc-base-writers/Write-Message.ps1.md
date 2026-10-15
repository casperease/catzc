---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Message.ps1.md
    kind: comment-page
    body_sha: "45eeec779afc"
    adrs:
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-CONSOLE#8
---

# automation/Catzc.Base.Writers/Write-Message.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Writes to the information stream via Write-InformationColored (which routes through
Write-Information). Automatically prepends the calling function name as a header.

Pass -Verbose to route the message (header included) to the verbose stream instead of the information
stream — use it for detail that should appear only under -Verbose. Visibility follows the -Verbose value
the caller supplies, so a caller forwards its own state, e.g. Write-Message '...' -Verbose:$emitVerbose;
-Verbose:$false stays silent. -ForegroundColor does not apply on the verbose stream.

Output is suppressed during a Pester run by the chokepoint guard in Write-InformationColored
(this function has none of its own), so it stays silent in tests without per-function plumbing.
```

## comment:2

Section `.PARAMETER ForegroundColor` of the comment-based help.

```text
Text color. When a header is shown, the color applies to the whole line (header included). Accepts a
[System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
[Catzc.Base.Writers.RainbowColor] profile — a status line is solid, so a rainbow input side-grades to its
base colour rather than drawing a gradient (a gradient rule is a header/footer concern).
```

## comment:3

Section `.PARAMETER Warning` of the comment-based help.

```text
Render the line yellow on the information stream
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7) yellow =
warning) — a non-fatal, attention-drawing
status line, NOT the terminating Write-Warning stream. The importer sets $WarningPreference = 'Stop', so a
real warning would halt (NoWriteErrorOrWarning rule, error-handling ADR); use throw for something that must
stop and -Warning for something worth noticing that must not. Implies yellow, so it is mutually exclusive
with -ForegroundColor, and does not apply on the verbose stream. Aliased -Warn.
```

## comment:4

Section `.PARAMETER NoNewline` of the comment-based help.

```text
Render the text without a trailing line break, so the next write continues the same line — the inline
liveness dot of
[ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)
(Write-Message '.' -NoHeader -NoNewline). Stays on the information
stream. Does not apply on the verbose stream.
```

## comment:5

Above `if ($PSBoundParameters.ContainsKey('Verbose')) {`.

```text
A verbose message (an explicitly-bound -Verbose) routes to the verbose stream instead of the always-on
information stream; its visibility follows the -Verbose value the caller passed (an explicit -Verbose
sets this call's $VerbosePreference, which Write-Verbose honours, so -Verbose:$false stays silent).
Requiring an EXPLICIT -Verbose keeps ordinary messages on the info stream even when the session's
$VerbosePreference is Continue. -ForegroundColor does not apply to the verbose stream.
```

## comment:6

Above `if ($Warning) {`.

```text
-Warning is sugar for yellow
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)) on the
information stream, NOT the terminating Write-Warning stream.
Parameter sets make it exclusive with -ForegroundColor, so at most one of these branches carries a colour.
```

## comment:7

Above `$plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound`.

```text
A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour: the
shared resolver flattens a ConsoleColor, its name, a 'rainbow'/'<base>-rainbow' bareword, or a
RainbowColor profile to one ConsoleColor. Passing a rainbow to Write-Message therefore just works.
```
