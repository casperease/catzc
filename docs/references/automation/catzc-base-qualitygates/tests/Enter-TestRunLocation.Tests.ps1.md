---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md
    kind: test-asset
    body_sha: "636891bd35d2"
---

# automation/Catzc.Base.QualityGates/tests/Enter-TestRunLocation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:holdLock = {`.

```text
A lock held by another thread: a mutex is re-entrant on its owning thread, so a held lock is only
observable from a different thread. The thread job owns the named mutex until $release is set.
```

## comment:2

Above `Mock Enter-SystemTestLock {`.

```text
The user's system-test lock is its own unit (Enter-SystemTestLock.Tests); here it is a seam, so no test
takes the real per-user lock. By default another run holds it; the cases below override.
```

## comment:3

Above `$script:savedLocationHeld = $env:CATZC_TEST_RUN_LOCATION_HELD`.

```text
These tests run inside a harness worker, which carries the parent run's location marker; each test
starts from a process that holds no location, and the worker case sets the marker itself.
```

## comment:4

Above `$name = & $script:mutexName $script:root`.

```text
A child process acquires and exits without releasing -> abandoned. Not a thread job: Wait-Job returns
when the job turns Completed, which can be before its thread has exited, and only the exit abandons.
```
