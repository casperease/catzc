# pwsh/Tooling.Listen/Start-DocListener.ps1

The listener loop of the listen mode: it starts or resumes a session, then waits for each settled change, writes its note and moves the seen
copy forward, until the editor stops it.

## help

### synopsis

The listener of the listen mode: notes every settled change of the watched folder, until stopped.

### description

Starts a session (New-DocSnapshot), or resumes one, then loops: Wait-DocChange, one New-DocNote per settled change, and Update-DocSnapshot
to move seen/ forward. It runs no model and interprets nothing, so no note waits on thinking; the processor (the listen-process skill) reads
the notes on its own time. The editor runs it in a terminal of its own and stops it with Ctrl+C; a stopped listener loses nothing, since
every note is on disk once written.

The session lives in out/, which can be wiped at any time. When the session vanishes, the listener says so and starts a new one from the
folder as it is then; the notes that vanished with the old one are gone, and the new session's baseline is the new start.

### parameter `Session`

Resume this session instead of starting a new one.

### parameter `Cycles`

Stop after this many waits; 0 (default) waits until stopped.

### example 1

```powershell
Start-DocListener
```
