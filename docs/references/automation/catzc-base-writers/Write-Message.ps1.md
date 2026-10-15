---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Message.ps1.md
    kind: comment-page
    body_sha: "349fef5fe71c"
    adrs:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/Write-Message.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `if ($PSBoundParameters.ContainsKey('Verbose')) {`.

```text
A verbose message (an explicitly-bound -Verbose) routes to the verbose stream instead of the always-on
information stream; its visibility follows the -Verbose value the caller passed (an explicit -Verbose
sets this call's $VerbosePreference, which Write-Verbose honours, so -Verbose:$false stays silent).
Requiring an EXPLICIT -Verbose keeps ordinary messages on the info stream even when the session's
$VerbosePreference is Continue. -ForegroundColor does not apply to the verbose stream.
```

## comment:9

Above `if ($Warning) {`.

```text
-Warning is sugar for yellow
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)) on the
information stream, NOT the terminating Write-Warning stream.
Parameter sets make it exclusive with -ForegroundColor, so at most one of these branches carries a colour.
```

## comment:10

Above `$plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound`.

```text
A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour: the
shared resolver flattens a ConsoleColor, its name, a 'rainbow'/'<base>-rainbow' bareword, or a
RainbowColor profile to one ConsoleColor. Passing a rainbow to Write-Message therefore just works.
```
