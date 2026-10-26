# pwsh/Tooling.Listen/Wait-DocNote.ps1

The processor's wait: it blocks, bounded, until a session holds a note the ledger has no line for, and returns at once when a backlog
already exists.

## help

### synopsis

Waits until a session holds a note the processor has not processed, and returns those notes; returns nothing when the bound runs out.

### description

The processor's wait, bounded under the background roof of the time safeguard, as ADR-AUTO-FAILFAST-BOUNDEVERYWAIT asks of every wait. It
returns at once when unprocessed notes already exist, so a processor that starts late catches up on the backlog first.

The session lives in out/, which can be wiped at any time: with no session yet, or once the session has vanished, it keeps waiting, and
without -Session it follows the newest session, so a listener that starts after the processor, or starts again after a wipe, is picked up.

### parameter `Session`

The session folder. Default: the newest session, looked up again on every poll.

### parameter `TimeoutSeconds`

The bound of this wait, 1 to 3600. Default: listen.yml's note_wait_seconds.

### parameter `Source`

Wait only for notes from these writers (Get-DocNote -Source); the processor waits for editor.

### outputs

`[pscustomobject]` per unprocessed note (Get-DocNote's records), or nothing.

### example 1

```powershell
Wait-DocNote -Source editor -TimeoutSeconds 300
```
