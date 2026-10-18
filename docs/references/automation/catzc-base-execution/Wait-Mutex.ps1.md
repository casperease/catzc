# automation/Catzc.Base.Execution/Wait-Mutex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Awaits a mutex reliably, announcing itself only when the wait is actually noticeable.

### description

The one low-level cover for blocking on a `[System.Threading.Mutex]`. It scales its console presence to how long the wait actually takes:

- Acquired within -AnnounceAfterSeconds (default 2): a non-noticeable glitch — the only trace is a verbose breadcrumb ('Awaited the `<name>`
  in N ms'), visible under -Verbose and silent otherwise.
- Still waiting past that threshold: a genuine halt — one announcement line names what is being waited on
  ([ADR-AUTO-CONSOLE#10](../../../adr/automation/console-output-matters.md#rule-adr-auto-console10)), then a liveness dot every
  -DotIntervalSeconds (default 5) until the mutex is acquired (the dot-per-interval signal of
  [ADR-AUTO-CONSOLE#8](../../../adr/automation/console-output-matters.md#rule-adr-auto-console8)), followed by an acquisition outcome line.

An abandoned mutex — the previous holder's process or thread died while owning it — transfers ownership and is treated as acquired, not as
an error (a verbose breadcrumb records the transfer). On return the caller owns the mutex and MUST release and dispose it in a finally
block.

Dots are written through the writer chokepoint (Write-Message '.' -NoHeader -NoNewline,
[ADR-PWSH-ANNOUNCE#1](../../../adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): an inline information-stream record, so nothing
pollutes the pipeline and a Pester run silences them with every other message.

### parameter Mutex

The mutex to await. On return the current thread owns it.

### parameter Name

Short noun for the messages (e.g. 'test-run mutex'). Defaults to 'mutex'.

### parameter AnnounceText

The announcement written when the wait crosses -AnnounceAfterSeconds. Defaults to 'Waiting for the `<Name>` — another process holds it'.

### parameter AnnounceAfterSeconds

How long a wait may take before it is announced (and dots begin). Defaults to 2.

### parameter DotIntervalSeconds

Seconds between liveness dots once the wait is announced. Defaults to 5.

### parameter TimeoutSeconds

Optional hard ceiling on the whole wait; the function throws when it expires. Defaults to 0 — wait indefinitely.

### outputs

None. Ownership is expressed on the mutex object itself.

### example 1

```powershell
$mutex = [System.Threading.Mutex]::new($false, "Global\my-app-lock")
Wait-Mutex $mutex -Name 'app lock'
try {
    # ... exclusive work ...
}
finally {
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
```

### example 2

```powershell
Wait-Mutex $mutex -Name 'deploy mutex' -TimeoutSeconds 300   # throw rather than wait past 5 minutes
```

## comment:1

Above `$waitSeconds = if ($announced) {`, written with `#`.

```text
Wait in observation-sized slices: up to the announce threshold first, then one dot interval
per slice — a failed slice is exactly one console event (the announcement, or a dot).
```
