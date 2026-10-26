# pwsh/Base.Writers/Write-Message.ps1

The status-message writer: it prefixes the calling function's name and writes to the information stream, or to the verbose stream when
`-Verbose` is passed.

## help

### synopsis

Writes a status message with calling function name prefix.

### description

Writes to the information stream via Write-InformationColored (which routes through Write-Information). Automatically prepends the calling
function name as a header.

Pass -Verbose to route the message (header included) to the verbose stream instead of the information stream — use it for detail that should
appear only under -Verbose. Visibility follows the -Verbose value the caller supplies, so a caller forwards its own state, e.g.
Write-Message '...' -Verbose:$emitVerbose;
-Verbose:$false stays silent. -ForegroundColor does not apply on the verbose stream.

Output is suppressed during a Pester run by the chokepoint guard in Write-InformationColored (this function has none of its own), so it
stays silent in tests without per-function plumbing.

It rests on [ADR-AUTO-CONSOLE-NOBOXDRAWING](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing).

### parameter `Message`

The message text to write.

### parameter `NoHeader`

Omits the `[caller]` prefix.

### parameter `NoNewline`

Render the text without a trailing line break, so the next write continues the same line — the inline liveness dot of (Write-Message '.'
-NoHeader -NoNewline). Stays on the information stream. Does not apply on the verbose stream.

### parameter `ForegroundColor`

Text color. When a header is shown, the color applies to the whole line (header included). Accepts a `[System.ConsoleColor]` (or its name),
a 'rainbow' / '`<base>-rainbow`' bareword, or a `[Catzc.Base.Writers.RainbowColor]` profile — a status line is solid, so a rainbow input
side-grades to its base colour rather than drawing a gradient (a gradient rule is a header/footer concern).

### parameter `Warning`

Render the line yellow on the information stream
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour) yellow = warning) —
a non-fatal, attention-drawing status line, NOT the terminating Write-Warning stream. The importer sets $WarningPreference = 'Stop', so a
real warning would halt (NoWriteErrorOrWarning rule, error-handling ADR); use throw for something that must stop and -Warning for something
worth noticing that must not. Implies yellow, so it is mutually exclusive with -ForegroundColor, and does not apply on the verbose stream.
Aliased -Warn.

### example 1

```powershell
Write-Message '.' -NoHeader -NoNewline
```

### example 2

```powershell
Write-Message 'Deployment complete'
```

### example 3

```powershell
Write-Message 'Done' -ForegroundColor Green -NoHeader
```

### example 4

```powershell
Write-Message -Warning 'Two builds present - is a console session locking the old DLL?'
```

## Verbose routing

A message is verbose only when `-Verbose` is explicitly bound. It then goes to the verbose stream instead of the always-on information
stream, and its visibility follows the `-Verbose` value the caller passed: an explicit `-Verbose` sets this call's `$VerbosePreference`,
which `Write-Verbose` honours, so `-Verbose:$false` stays silent. Requiring an explicit `-Verbose` keeps ordinary messages on the
information stream even when the session's `$VerbosePreference` is `Continue`. `-ForegroundColor` does not apply to the verbose stream.

## Warning

`-Warning` is sugar for yellow
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)) on the information
stream, never the terminating `Write-Warning` stream. The parameter sets make it exclusive with `-ForegroundColor`, so at most one branch
carries a colour.

## Rainbow input

A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour. The shared resolver flattens a
`ConsoleColor`, its name, a `rainbow` or `<base>-rainbow` bareword, or a `RainbowColor` profile to one `ConsoleColor`, so passing a rainbow
to `Write-Message` just works.
