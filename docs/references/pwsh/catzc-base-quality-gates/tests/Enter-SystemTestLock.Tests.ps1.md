# pwsh/Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1

The tests of `Enter-SystemTestLock`, at L1 with real named mutexes held and abandoned from thread jobs. Every test passes its own unique lock
name and record path, so none touches the real per-user system-test lock.

## A lock held elsewhere

A mutex is re-entrant on its owning thread, so a held lock is only observable from another thread. The thread job owns the named mutex until
`$release` is set.
