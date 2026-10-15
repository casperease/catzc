---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md
    kind: comment-page
    body_sha: "8486f495bf25"
    adrs:
      - ADR-PWSH-ANNOUNCE#1
    links: []
---

# automation/Catzc.Base.Execution/Invoke-WithProgress.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Wraps a long-running call with a visual heartbeat so the user knows
the process is alive. The scriptblock runs on the current thread,
preserving module scope and all imported functions, so the dots come
from a background ThreadJob that streams to this host (-StreamingHost).

The dots go through the writer chokepoint like every other console
write ([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)):
the job imports the loaded Catzc.Base.Writers
module and writes Write-Message '.' -NoHeader -NoNewline — an inline
information-stream record, so the scriptblock's return value passes
through uncontaminated. The job inherits this session's Pester-run
guard, so a test run stays silent there as everywhere else.

Dots stop and a trailing newline is written when the scriptblock
completes — including when it throws.
```

## comment:2

Section `.PARAMETER Message` of the comment-based help.

```text
Optional prefix written before the dots (e.g., 'Checking tools').
Appears on the same line as the dots.
```

## comment:3

Above `$writersPath = (Get-Module Catzc.Base.Writers).Path`.

```text
The dot writer runs in a thread job with its own runspace: it streams to this host, imports the same
Writers module this session loaded, and copies this session's Pester-run guard, so its dots behave
exactly like a Write-Message on this thread.
```

## comment:4

Above `$dotJob | Remove-Job -Force`.

```text
Stop and remove without Receive-Job: the dots already streamed, and receiving would replay them.
-Force: Stop-Job can return while a thread job is still Stopping, and a plain Remove-Job throws then.
```
