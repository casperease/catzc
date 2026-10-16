---
catzc:
  immutable:
    with_body_sha: "799d8325540d"
    repo_status: locked
    path: docs/references/automation/catzc-base-writers/Write-Message.ps1.md
    folder: docs/references/automation/catzc-base-writers
    name: write-message-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/Write-Message.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($PSBoundParameters.ContainsKey('Verbose')) {`, written with `#`.

```text
A verbose message (an explicitly-bound -Verbose) routes to the verbose stream instead of the always-on
information stream; its visibility follows the -Verbose value the caller passed (an explicit -Verbose
sets this call's $VerbosePreference, which Write-Verbose honours, so -Verbose:$false stays silent).
Requiring an EXPLICIT -Verbose keeps ordinary messages on the info stream even when the session's
$VerbosePreference is Continue. -ForegroundColor does not apply to the verbose stream.
```

## comment:2

Above `if ($Warning) {`, written with `#`.

```text
-Warning is sugar for yellow
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)) on the
information stream, NOT the terminating Write-Warning stream.
Parameter sets make it exclusive with -ForegroundColor, so at most one of these branches carries a colour.
```

## comment:3

Above `$plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound`, written with `#`.

```text
A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour: the
shared resolver flattens a ConsoleColor, its name, a 'rainbow'/'<base>-rainbow' bareword, or a
RainbowColor profile to one ConsoleColor. Passing a rainbow to Write-Message therefore just works.
```
