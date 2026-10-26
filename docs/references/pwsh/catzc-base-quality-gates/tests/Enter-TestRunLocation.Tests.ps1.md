# pwsh/Base.QualityGates/tests/Enter-TestRunLocation.Tests.ps1

The tests of `Enter-TestRunLocation`, which takes the run's location under the user's system-test lock.

## The lock

The lock is its own unit (`Enter-SystemTestLock.Tests`). Here it is a seam, mocked so that no test takes the real per-user lock. By default
another run holds it, and the cases override that. A held lock is built on another thread, since a mutex is re-entrant on its owning thread.

## The harness marker

These tests run inside a harness worker, which carries the parent run's location marker. Each test starts from a process that holds no
location, and the worker case sets the marker itself.

## Abandoned locks

The abandoned-lock case uses a child process that acquires and exits without releasing. A thread job would not do: `Wait-Job` returns when the
job turns Completed, which can be before its thread has exited, and only the exit abandons the mutex.
