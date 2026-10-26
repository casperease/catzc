# pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function script:Start-LockHolder {`, written with `#`.

```text
Holds the lock on another thread for the given milliseconds, the way a plain run would; with -Burst, it is a burst that ends
when it lets go.
```

## comment:2

Above `function script:Start-Waiter {`, written with `#`.

```text
Waits for the lock on another thread, the way another run would; on taking it, records its name in the shared
order and lets go.
```

## comment:3

Above `function script:Start-LockHolder {`, written with `#`.

```text
Holds the lock on another thread for the given milliseconds; with -RecordSeconds it writes the holder record a
plain run writes.
```

## comment:4

Above `$holder = Start-LockHolder -Name $script:lockName -Milliseconds 2500...`, written with `#`.

```text
The holder keeps the lock 2.5 s, past the waiter's 1 s, and its record says it will be done within 30 s,
inside the 60 s budget.
```

## comment:5

Above `$holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500...`, written with `#`.

```text
The holder has just taken the lock: its record says 120 s, past the waiter's 10 s budget, but that is only its
budget, no promise.
```

## comment:6

Above `$holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500...` (occurrence 2), written with `#`.

```text
The holder declares 120 s, past the waiter's 5 s budget, but lets go after 1.5 s: a deadline is a limit, never
when it ends.
```

## comment:7

Above `$holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500` (occurrence 2), written with `#`.

```text
The record names a dead process declared until 120 s from now, past the waiter's 5 s budget; the lock itself
falls free in 1.5 s.
```

## comment:8

Above `$caller = Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList...` (occurrence 2), written with `#`.

```text
The holder's own process lives and its record runs 120 s, but the caller named in the record is killed: an
orphan holds no one.
```
