---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Enter-SystemTestLock.ps1.md
    kind: comment-page
    body_sha: "821c60302fad"
    adrs:
      - ADR-AUTO-TEST#32
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
L3 holds the vertical system tests, which change state outside the repository: the user's PATH and other
persistent environment variables, the registry, installed tools
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). That state belongs to the
user, not to a checkout, so the working folder's lock (one per checkout) cannot guard it: two clones — or a clone
and an installed build — each own their own working folder and would run L3 against the same user state at
once. This lock is keyed on the user instead: a named [System.Threading.Mutex], machine-wide through the
Global\ namespace, tried with a zero timeout. A run never waits for it
([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): taken, the run may
run L3; held, it skips L3 and names the holder.

Taken (or abandoned — the previous holder died mid-run), the holder writes its lock record
(Write-TestRunLockRecord) to a per-user file, so a run from any checkout can say who holds the lock. The
caller releases the lock through Exit-TestRunLocation.
```

## comment:2

Section `.PARAMETER LockPath` of the comment-based help.

```text
The lock record. Defaults to the per-user catzc folder (%LOCALAPPDATA%\catzc\test-runs on Windows,
~/.local/share/catzc/test-runs on Unix).
```
