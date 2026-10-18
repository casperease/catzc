# automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tries, without waiting, to take the user's system-test lock — the right to run L3 on this account.

### description

L3 holds the vertical system tests, which change state outside the repository: the user's PATH and other persistent environment variables,
the registry, installed tools ([ADR-AUTO-TEST#33](../../../../adr/automation/test-automation.md#rule-adr-auto-test33)). That state belongs
to the user, not to a checkout, so the working folder's lock (one per checkout) cannot guard it: two clones — or a clone and an installed
build — each own their own working folder and would run L3 against the same user state at once. This lock is keyed on the user instead: a
named `[System.Threading.Mutex]`, machine-wide through the Global\ namespace, tried with a zero timeout. A run never waits for it
([ADR-AUTO-TEST#32](../../../../adr/automation/test-automation.md#rule-adr-auto-test32)): taken, the run may run L3; held, it skips L3 and
names the holder.

Taken (or abandoned — the previous holder died mid-run), the holder writes its lock record (Write-TestRunLockRecord) to a per-user file, so
a run from any checkout can say who holds the lock. The caller releases the lock through Exit-TestRunLocation.

### parameter `EntryPoint`

The entry point taking the lock — written to the lock record.

### parameter `RunDirectory`

The run's report folder — written to the lock record.

### parameter `RepositoryRoot`

The run's working folder — written to the lock record, so the holder's checkout can be named.

### parameter `Name`

The mutex name. Defaults to the current user's: `Global\catzc-system-tests-<hash of domain\user>`.

### parameter `LockPath`

The lock record. Defaults to the per-user catzc folder (%LOCALAPPDATA%\catzc\test-runs on Windows, ~/.local/share/catzc/test-runs on Unix).

### outputs

`[pscustomobject]` Acquired (`[bool]`), Mutex (owned, or $null), LockPath (the record this run wrote, or $null), and Holder
(Get-TestRunLockHolder's description of who holds it, or $null).

### example 1

```powershell
$lock = Enter-SystemTestLock -EntryPoint 'Test-Automation' -RunDirectory $runDir -RepositoryRoot $root
```
