# pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1

The tests of `Wait-CatzcRunLock`, which waits for the run lock within a budget and reads the holder's record; the cases with a real caller
process sit beside them in `Wait-CatzcRunLock.Caller.Tests.ps1`.

## The helpers

Both test files dot-source the helpers from the shared fixture, `RunLock.Fixture.ps1`. `Start-LockHolder` holds the lock on another thread
for the given milliseconds, the way a plain run would. With `-Burst` it is a burst that ends when it lets go, and with `-RecordSeconds` it
writes the holder record a plain run writes. `Start-Waiter` waits for the lock on another thread, the way another run would; on taking it,
it records its name in the shared order and lets go.

## The holder's record is a limit, never a promise

The cases show that a declared deadline bounds the wait without deciding when the lock frees:

- The holder keeps the lock 2.5 s, past the waiter's 1 s, and its record says it will be done within 30 s, inside the 60 s budget.
- The holder has just taken the lock: its record says 120 s, past the waiter's 10 s budget, but that is only its budget, no promise.
- The holder declares 120 s, past the waiter's 5 s budget, but lets go after 1.5 s: a deadline is a limit, never when it ends.
- The record names a dead process declared until 120 s from now, past the waiter's 5 s budget; the lock itself falls free in 1.5 s.
- The holder's own process lives and its record runs 120 s, but the caller named in the record is killed: an orphan holds no one (a
  caller-process case).
