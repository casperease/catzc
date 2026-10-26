# pwsh/Tooling.Listen/Wait-DocChange.ps1

The listener's wait: it polls for changes and returns once they have stopped moving, so a burst of saves is one change. The wait is bounded
and returns nothing when the bound runs out.

## help

### synopsis

Waits until a change of the watched folder has settled, and returns it; returns nothing when the wait's bound runs out.

### description

Polls Get-DocChange every poll_milliseconds. Once a change shows, it waits until the set of changes, diffs included, has stayed the same for
quiet_seconds, so one burst of saves is one change. The whole wait is bounded by -TimeoutSeconds, as ADR-AUTO-FAILFAST-BOUNDEVERYWAIT asks
of every wait; the listener simply waits again after a bound runs out.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `TimeoutSeconds`

The bound of this wait, 1 to 86400. Default: listen.yml's change_wait_seconds.

### outputs

`[pscustomobject]` per settled change (Get-DocChange's records), or nothing.

### example 1

```powershell
Wait-DocChange -TimeoutSeconds 60
```
