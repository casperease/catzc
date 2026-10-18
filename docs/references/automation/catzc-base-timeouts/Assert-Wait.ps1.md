---
catzc:
  immutable:
    with_body_sha: "6da1a21d90fc"
    repo_status: locked
    path: docs/references/automation/catzc-base-timeouts/Assert-Wait.ps1.md
    folder: docs/references/automation/catzc-base-timeouts
    name: assert-wait-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Timeouts/Assert-Wait.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

A watchpoint — stands where the thread or process may be blocked, writes loudly, warns once and lets go.

### description

Holds the calling thread for Seconds + Milliseconds in ten evenly spaced ticks and writes a line per tick through
Write-Message: when the tick was due, when it ran, and how late it was. A blocked thread or a starved process cannot keep
that schedule, so a late tick is the evidence. It ends with one Write-Message -Warning line (always, blocked or not), then
returns. It stops nothing and throws nothing for a block; only an invalid argument throws.

The closing line is Write-Message -Warning, not the Write-Warning cmdlet: the importer sets $WarningPreference = 'Stop',
so the cmdlet would terminate where this must let go. A watchpoint is a diagnostic — it costs its full duration on every
run and is removed once the block it found is bounded (Invoke-WithTimeout, a timeouts.yml entry).

It rests on [ADR-AUTO-FAILFAST#5](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast5) and [ADR-AUTO-FAILFAST#7](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7).

### parameter Seconds

Whole seconds to stand. Default: the timeouts registry's wait.seconds, one second declared once on TimeoutsConfig.

### parameter Milliseconds

Milliseconds added to Seconds. Default: the registry's wait.milliseconds, one millisecond declared once on TimeoutsConfig.

### example 1

```powershell
Assert-Wait
```

### example 2

```powershell
Assert-Wait -Seconds 2
```

### example 3

```powershell
Assert-Wait -Seconds 0 -Milliseconds 250
```

## comment:1

Above `$remainingMs = $dueMs - [long]$watch.ElapsedMilliseconds`, written with `#`.

```text
Sleep until the tick is due, not for the whole slice: a sleep overruns by a few ms, and a fixed slice would carry that
overrun into every later tick, so the last tick would read late with nothing blocked.
```
