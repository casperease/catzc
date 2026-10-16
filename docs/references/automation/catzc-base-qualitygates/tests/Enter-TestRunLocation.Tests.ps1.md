---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "601e36da99bb"
---

# automation/Catzc.Base.QualityGates/tests/Enter-TestRunLocation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:holdLock = {`, written with `#`.

```text
A lock held by another thread: a mutex is re-entrant on its owning thread, so a held lock is only
observable from a different thread. The thread job owns the named mutex until $release is set.
```

## comment:2

Above `Mock Enter-SystemTestLock {`, written with `#`.

```text
The user's system-test lock is its own unit (Enter-SystemTestLock.Tests); here it is a seam, so no test
takes the real per-user lock. By default another run holds it; the cases below override.
```

## comment:3

Above `$script:savedLocationHeld = $env:CATZC_TEST_RUN_LOCATION_HELD`, written with `#`.

```text
These tests run inside a harness worker, which carries the parent run's location marker; each test
starts from a process that holds no location, and the worker case sets the marker itself.
```

## comment:4

Above `$name = & $script:mutexName $script:root`, written with `#`.

```text
A child process acquires and exits without releasing -> abandoned. Not a thread job: Wait-Job returns
when the job turns Completed, which can be before its thread has exited, and only the exit abandons.
```
