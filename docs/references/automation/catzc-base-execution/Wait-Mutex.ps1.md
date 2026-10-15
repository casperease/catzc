---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Wait-Mutex.ps1.md
    kind: comment-page
    body_sha: a47db4b09616
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-AUTO-CONSOLE#8
      - ADR-PWSH-ANNOUNCE#1
---

# automation/Catzc.Base.Execution/Wait-Mutex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one low-level cover for blocking on a [System.Threading.Mutex]. It scales its console
presence to how long the wait actually takes:

- Acquired within -AnnounceAfterSeconds (default 2): a non-noticeable glitch — the only trace is
  a verbose breadcrumb ('Awaited the <name> in N ms'), visible under -Verbose and silent otherwise.
- Still waiting past that threshold: a genuine halt — one announcement line names what is being
  waited on
  ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)), then a
  liveness dot every -DotIntervalSeconds (default 5) until the
  mutex is acquired (the dot-per-interval signal of
  [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)), followed
  by an acquisition
  outcome line.

An abandoned mutex — the previous holder's process or thread died while owning it — transfers
ownership and is treated as acquired, not as an error (a verbose breadcrumb records the transfer).
On return the caller owns the mutex and MUST release and dispose it in a finally block.

Dots are written through the writer chokepoint (Write-Message '.' -NoHeader -NoNewline,
[ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): an inline
information-stream record, so nothing pollutes the pipeline and a
Pester run silences them with every other message.
```

## comment:2

Section `.PARAMETER AnnounceText` of the comment-based help.

```text
The announcement written when the wait crosses -AnnounceAfterSeconds. Defaults to
'Waiting for the <Name> — another process holds it'.
```

## comment:3

Section `.PARAMETER TimeoutSeconds` of the comment-based help.

```text
Optional hard ceiling on the whole wait; the function throws when it expires. Defaults to 0 —
wait indefinitely.
```

## comment:4

Above `$waitSeconds = if ($announced) {`.

```text
Wait in observation-sized slices: up to the announce threshold first, then one dot interval
per slice — a failed slice is exactly one console event (the announcement, or a dot).
```

## comment:5

Above `$waitSeconds = if ($announced) {`.

```text
Wait in observation-sized slices: up to the announce threshold first, then one dot interval
per slice — a failed slice is exactly one console event (the announcement, or a dot).
```
