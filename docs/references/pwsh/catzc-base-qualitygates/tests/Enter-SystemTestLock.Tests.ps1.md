# pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Enter-SystemTestLock' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#33' {`, written with `#`.

```text
L1: real named mutexes, held and abandoned from thread jobs. Every test passes its own unique lock name and
record path, so no test ever touches the real per-user system-test lock.
```

## comment:2

Above `$script:holdLock = {`, written with `#`.

```text
A lock held by another thread: a mutex is re-entrant on its owning thread, so a held lock is only
observable from a different thread. The thread job owns the named mutex until $release is set.
```
