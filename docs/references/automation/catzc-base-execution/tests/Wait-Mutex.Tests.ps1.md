---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Wait-Mutex.Tests.ps1.md
    kind: test-asset
    body_sha: b13a96fe9a9e
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Base.Execution/tests/Wait-Mutex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Write-Message { } -ModuleName Catzc.Base.Execution`.

```text
The writer is the observable boundary
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)): assert which
message shape each path emits.
```

## comment:2

Above `$script:startContendedHold = {`.

```text
Hold the mutex on another thread, signal once owned, release after a fixed hold — so the
main thread's Wait-Mutex reliably crosses a tiny announce threshold before acquiring.
```
